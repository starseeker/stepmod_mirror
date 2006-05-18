//$Id: splitmodules.js,v 1.1 2006/05/05 00:59:57 thendrix Exp $
// JScript to split an EXPRESS file into its constituent schemas.
// A directory will be created for each schema with the same name as the
// schema. The EXPRESS for the schema will be stored in the schema
// directory in a file with the same name as the schema.  

// cscript splitmodules.js arm_20060503_v1.exp
var usageMessage = "cscript splitmodules.js <express.exp>";

var ForReading = 1, ForWriting = 2, ForAppending = 8;
var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;


var stepmodHome = '..';


function debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function userMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    WScript.Echo(msg);
    objShell.Popup(msg);
}


// Return the first word in the line or (*
function readToken(line) {
    // get the first word
    var reg = /^\s*\b\w*\b/i;
    var token = line.match(reg);
    if (!token) {
	// Not a word, so check for comment
	reg = /^\s*\(\*/;
	token = line.match(reg);
	}
    if (!token) {
	// Not a word, so check for {} statement
	reg = /^\{/i;
	token = line.match(reg);	
    }
    if (token) {
	token = token[0].replace(/\s/g,"");
	token = token.toString();
	switch (token) {
	case "USE" :
	    var reg = /^\s*USE FROM\b/i;
	    token = line.match(reg);
	    if (token) {
		token = token[0].replace(/\s/g,"");
		token = token.toString();
	    } else {
		token = -1;	
	    }
	    break;
	case "REFERENCE" :
	    var reg = /^\s*REFERENCE FROM\b/i;
	    token = line.match(reg);
	    if (token) {
		token = token[0].replace(/\s/g,"");
		token = token.toString();
	    } else {
		token = -1;
	    }
	    break;
	default :
	    break;
	}
    } else {
	//debug("tt:"+token+":"+line);
	token = -1;
    }
    return(token);
}

// Return a statement terminated by ;
function readStatement(line, ts) {
    var statement = "";
    var pos;

    // remove any trailing -- comments
    pos = line.search("--");
   if (pos != -1) {
	line = line.substr(0,pos);
    }
    if (ts.AtEndOfStream) 
	return(line);
    else {
	pos = line.search(";");
	if (pos == -1) {
	    statement = line + readStatement(ts.ReadLine(), ts);
	} else {
	    statement = line.substr(0,pos+1);
	}
	return(statement);
    }
}

// Separate all , and ( ) with whitespace, remove all tabs etc
function normaliseStatement(statement) {
    statement = statement.replace(/,/g," , ");
    statement = statement.replace(/;/g," ;");
    statement = statement.replace(/\[/g," [ ");
    statement = statement.replace(/\]/g," ] ");
    statement = statement.replace(/\(/g," ( ");
    statement = statement.replace(/\)/g," ) ");
    statement = statement.replace(/\t/g," ");
    statement = statement.replace(/^\s*/g,"");
    while (statement.search(/  /) != -1) {
	statement = statement.replace(/  /g," ");
    }
    
    return(statement);
}

function getArmMim(schemaName) {
    var pos = schemaName.lastIndexOf('_arm');
    schemaName = schemaName.toLowerCase();
    var module = schemaName;
    if (pos > 1) {
	return('arm');
    }
    pos = schemaName.lastIndexOf('_mim');
    if (pos > 1) {
	return('mim');
    }
    return(module);
}
function getModuleName(schemaName) {
    var pos = schemaName.lastIndexOf('_arm');
    schemaName = schemaName.toLowerCase();
    var module = schemaName;
    if (pos > 1) {
      module= module.substring(0,pos);
    }
    pos = schemaName.lastIndexOf('_mim');
    if (pos > 1) {
      module= module.substring(0,pos);
    }
    return(module);
}
function getWord(n, statement) {
    statement = normaliseStatement(statement);
    var arr = statement.split(" ");
    var word = arr[n-1];
    word = word.replace(/:/,"");
    return(word);
}

function ReadSchema(expTs, outTs) {
    while (!expTs.AtEndOfStream) {
	var l = expTs.ReadLine();
	outTs.Writeline(l);
	var token = readToken(l);
	if (token == "END_SCHEMA") {
	    outTs.Close();
	    return(true);
	}
    }
}

function checkXMLParse(doc) {
    if (doc.parseError.errorCode !=0) {
	var strError = new String;
	strError = 'Invalid XML file!\n'
	    + 'File URL: ' + doc.parseError.url + '\n'
	    + 'Line No: ' + doc.parseError.line + '\n'
	    + 'Character: ' + doc.parseError.linepos + '\n'
	    + 'File Position: ' + doc.parseError.filepos + '\n'
	    + 'Source Text: ' + doc.parseError.srcText + '\n'
	    + 'Error Code: ' + doc.parseError.errorCode + '\n'
	    + 'Description: ' + doc.parseError.reason;
	ErrorMessage(strError);
    }
    return (doc.parseError.errorCode == 0 );
}

function SplitModules(bp,expFile) {
  var moduleNames = getModuleNamesFromXML(bp);
  OutputSchemas(expFile,moduleNames,bp);
}


function getModuleNamesFromXML(bp) {
  var bpDir= stepmodHome+"/ballots/ballots/";
  var ballotXml = bpDir+bp;
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var bpFldr = fso.GetFolder(ballotXml);
  var ballotIndexXmlFile = bpFldr.Path.toString()+"\\ballot_index.xml";
  
  //userMessage("ballotIndexXmlFile: "+ballotIndexXmlFile);

  // Load in the ballot_index.xml file
  var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
  xml.async = false;
  var err = xml.load(ballotIndexXmlFile);
  var moduleNames = new Array();
  if (checkXMLParse(xml)) {
    // Get name of file
    var moduleNodes = xml.selectNodes("/ballot_index/ballot_package/module");
    for (var i=0; i < moduleNodes.length; i++) {
      moduleNames[i]= moduleNodes[i].attributes.getNamedItem("name").nodeValue;
    }
  }
  return(moduleNames);
}


function OutputSchemas(expFile, moduleNames,bp) {
  //  userMessage("Reading " + expFile);
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var expF = fso.GetFile(expFile);
  var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);
  var modulesFldr = expFile.replace("\.exp","");
  var moduleNamesSplit = new Array();
  split_count = 0;
  if (!fso.FolderExists(modulesFldr))
    fso.CreateFolder(modulesFldr);
    
  while (!expTs.AtEndOfStream)
    {
      var l = expTs.ReadLine();
      var token = readToken(l);
      switch( token ) {
      case "SCHEMA" :
	var statement = readStatement(l,expTs);
	var schema = getWord(2,statement);
	var module = getModuleName(schema);
	var ArmOrMim = getArmMim(schema);
	//kludge alert !
	var schemaFldr = modulesFldr;
	var schemaFile = schemaFldr+"/"+"bitbucket.exp";
	for (var i=0; i < moduleNames.length; i++) {
	  if (module == moduleNames[i]) {
	    var schemaFldr = modulesFldr+"/"+module;
	    var schemaFile = schemaFldr+"/"+ArmOrMim+".exp";
	    moduleNamesSplit[split_count]= module;
	    split_count = split_count + 1;
	  } 
	}
	if (!fso.FolderExists(schemaFldr))
	  fso.CreateFolder(schemaFldr);
	//	userMessage(schemaFile);
	fso.CreateTextFile(schemaFile, true );
	var f = fso.GetFile(schemaFile);
	var outTs = f.OpenAsTextStream(ForWriting,
				       TristateUseDefault);
	outTs.WriteLine("(* Genenerated from: " + expFile + " *)\n");
	outTs.Writeline(statement);
	ReadSchema(expTs, outTs);
	break;
      }
    }
  userMessage("Split into "+split_count+" modules:\n"+moduleNamesSplit); 
}

// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    var cArgs = WScript.Arguments;
    if ( !((cArgs.length == 2)) )  {
      var msg="Incorrect arguments\n"+usageMessage;
      ErrorMessage(msg);
      return(false);
    } else {
      SplitModules(cArgs(0),cArgs(1));
    }
    
}

// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
//Main();
