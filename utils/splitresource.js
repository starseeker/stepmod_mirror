//$Id: splitresource.js,v 1.1 2001/11/21 17:13:06 robbod Exp $
// JScript to split an EXPRESS file into its constituent schemas.
// A directory will be created for each schema with the same name as the
// schema. The EXPRESS for the schema will be stored in the schema
// directory in a file with the same name as the schema.  

// cscript splitresource.js WG12N525.exp
var usageMessage = "cscript splitresource.js <express.exp>";

var ForReading = 1, ForWriting = 2, ForAppending = 8;
var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;


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

function OutputSchemas(expFile) {
    userMessage("Reading " + expFile);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var expF = fso.GetFile(expFile);
    var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);
    var resourceFldr = expFile.replace("\.exp","");
    if (!fso.FolderExists(resourceFldr))
	fso.CreateFolder(resourceFldr);
    
    while (!expTs.AtEndOfStream)
	{
	    var l = expTs.ReadLine();
	    var token = readToken(l);
	    switch( token ) {
	    case "SCHEMA" :
		var statement = readStatement(l,expTs);
		var schema = getWord(2,statement);
		var schemaFldr = resourceFldr+"/"+schema;
		var schemaFile = schemaFldr+"/"+schema+".exp";

		if (!fso.FolderExists(schemaFldr))
		    fso.CreateFolder(schemaFldr);
		userMessage(schemaFile);
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
}

// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    var cArgs = WScript.Arguments;
    if ( !((cArgs.length == 1) || (cArgs.length == 2)) )  {
	var msg="Incorrect arguments\n"+usageMessage;
	ErrorMessage(msg);
	return(false);
    } else {
	OutputSchemas(cArgs(0));
    }
    
}

// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
Main();
