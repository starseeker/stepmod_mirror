//$Id: getExpressMain.js,v 1.13 2003/03/12 14:33:25 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep 
//  Purpose:  JScript to copy all the express files from the repository to
//            a directory. 
//
//            The script is called from getExpress.wsf
//
//            Given the name of a new directory, <dir> create a three sub
//            directories 
//                     <dir>/arm - the ARM express
//                     <dir>/mim - the MIM express
//                     <dir>/resources - the Integrated resources express
//            Copy the all the ARM, MIM and Integrated Resource express
//            from the repository renaming each express file to be the same
//            as the schema it contains and storing it in the relevant
//            directory  
//               cscript getExpressMain.js <dir>
//            e.g.
//               cscript getExpressMain.js "../express"
//
//------------------------------------------------------------

// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

// If 1 then output user messages
var outputUsermessage = 1;


function Debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function UserMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    objShell.Popup(msg);
}


// Add a function called trim as a method of the prototype 
// object of the String constructor.
String.prototype.trim = function()
{
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    return this.replace(/(^\s*)|(\s*$)/g, "");
}


function getDate() {
    var a, date, year, month, day;
    date = new Date();                           //Create Date object.
    year = ""+date.getYear();                         //Get year.
    month = ""+(date.getMonth() + 1);            //Get month
    day = ""+date.getDate();                   //Get day
    if (day.length == 1) day = "0"+day;
    if (month.length == 1) month = "0"+month;
    s = year + month + day;    
    return(s);                                //Return date.
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


// Append all the express files
function AppendMimArm(armOrMim, modList, armFile) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    var schemaArr = new Array;

    var dateSuffix="_"+getDate()+"v1";
    
    // make sure that the arm.exp file does not exist
    if (fso.FileExists(armFile)) {
	ErrorMessage("The "+armOrMim+".exp already exists. Delete to proceed\n"+armFile);
	return(0);
    }  

    if (!fso.FileExists(modList)) {
	ErrorMessage("The "+modList+" file does not exist");
	return(0);
    }  
    var modListStr = fso.OpenTextFile(modList,ForReading);
    var armStr = fso.CreateTextFile(armFile, true);

    var srcPath = "../data/modules"

    var reg = /{.*iso\b/;
    while (!modListStr.AtEndOfStream) {
	var src =  modListStr.ReadLine();
	// strip white space - read word
	src = src.trim();
	// any module starting with // is assumed commented out
	var word = src.match(/^\w+/);
	if (word) {
	    src = srcPath+"/"+src+"/"+armOrMim+".exp";
	    if (fso.FileExists(src)) {
		var srcStr = fso.OpenTextFile(src,ForReading);	
		armStr.WriteLine("");
		armStr.WriteLine("");
		armStr.WriteLine("(*");
		armStr.WriteLine("   ------------------------------------------------------------");
		armStr.WriteLine(src);
		armStr.WriteLine("   ------------------------------------------------------------");
		armStr.WriteLine("*)");
		armStr.WriteLine("");
		while (!srcStr.AtEndOfStream) {
		    var l =  srcStr.ReadLine();
		    // ignore 
		    // {iso standard 10303 part (11) version (4)} 
		    if (!l.match(reg))
			armStr.WriteLine(l);
		}
		srcStr.Close();    
	    }
	}
    }
   armStr.Close();
   return(armFile);		
}


// Append Integrated Resource express listed in irList to expFile
// if newOrAppend = 'new' create a new expFile, else append to expFile
function AppendIrExpress(irList, expFile, newOrAppend) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;

    if (!fso.FileExists(irList)) {
	ErrorMessage("The "+irList+" file does not exist");
	return(0);
    }

    var irFldr = fso.GetFolder("../data/resources");
    var irListStr = fso.OpenTextFile(irList,ForReading);
    var expFileStr;
    if (newOrAppend == 'new') {
	//UserMessage("Creating to "+expFile);
	expFileStr =  fso.CreateTextFile(expFile,true);
    } else {
	expFileStr = fso.OpenTextFile(expFile,ForAppending);
	//UserMessage("Adding to "+expFile);
    }


    while (!irListStr.AtEndOfStream) {
	var resourceName =  irListStr.ReadLine();
	// strip white space - read word
	resourceName = resourceName.trim();

	var src, dst;
	// any module starting with // is assumed commented out
	var reg=/^\w+/;
	var word = resourceName.match(reg);
	if (word) {
	    // Copy across resource express file
	    var resourceFileName = "../data/resources/"+resourceName+"/"+resourceName+".exp";

	    if (fso.FileExists(resourceFileName)) {
		src = fso.GetFile(resourceFileName);
		
		// append into expFile
		var srcStr = fso.OpenTextFile(src,ForReading);	
		expFileStr.WriteLine("");
		expFileStr.WriteLine("");
		expFileStr.WriteLine("(*");
		expFileStr.WriteLine("   ------------------------------------------------------------");
		expFileStr.WriteLine(src);
		expFileStr.WriteLine("   ------------------------------------------------------------");
		expFileStr.WriteLine("*)");
		expFileStr.WriteLine("");
		while (!srcStr.AtEndOfStream) {
		    var l =  srcStr.ReadLine();
		    // ignore 
		    // {iso standard 10303 part (11) version (4)} 
		    var reg = /{.*iso\b/;
				if (!l.match(reg))
				expFileStr.WriteLine(l);
		    }
		    srcStr.Close();    
		} else {
		    UserMessage("File does not exist:\n"+resourceFileName);
		}
	    }
    }
}



function getModuleExpFilename(moduleName,armOrMim) {
    var expDir = "../data/modules/"+moduleName+"/dvlp/express";
    var dateSuffix="_"+getDate()+"v1";
    return(expDir+"/"+armOrMim+dateSuffix+".exp");    
}

function getResourceExpFilename(resourceName) {
    var expDir = "../data/resource_docs/"+resourceName+"/dvlp/express";
    var dateSuffix="_"+getDate()+"v1";
    return(expDir+"/"+resourceName+dateSuffix+".exp");    
}

// Given a module + a list of dependent modules
// concatentate all the modules express
function GetExpressModule(moduleName, armOrMim, modList, irList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var modDir = "../data/modules/"+moduleName;
    if (!fso.FolderExists(modDir)) {
	ErrorMessage("Module "+modDir+" does not exist");
	return(-1);
    } else if (!fso.FileExists(modList)) {
	ErrorMessage("The "+modList+" file does not exist");
	return(-1);
    }    

    var armFile = getModuleExpFilename(moduleName,armOrMim);
    AppendMimArm(armOrMim,modList,armFile);
    if (armOrMim == "mim") {
	AppendIrExpress(irList,armFile);
    }
    UserMessage("Concatenated "+armOrMim+" EXPRESS: "+armFile);
}


// Given a resource doc + a list of dependent IR schemas
// concatentate all the express
function GetExpressResource(resourceName, irList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var resDocDir = "../data/resource_docs/"+resourceName;
    if (!fso.FolderExists(resDocDir)) {
	ErrorMessage("Resource "+resDocDir+" does not exist");
	return(-1);
    } else if (!fso.FileExists(irList)) {
	ErrorMessage("The "+irList+" file does not exist");
	return(-1);
    }    

    var resFile = getResourceExpFilename(resourceName);
    AppendIrExpress(irList,resFile, 'new');
    UserMessage("Concatenated EXPRESS: "+resFile);
}


//GetExpressModule("ap239_product_definition_information", "arm", "..\\data\\modules\\ap239_product_definition_information\\dvlp\\express\\modlist.txt");

//GetExpressModule("ap239_part_definition_information", "mim", "..\\data\\modules\\ap239_part_definition_information\\dvlp\\express\\modlist.txt","..\\data\\modules\\ap239_part_definition_information\\dvlp\\express\\irlist.txt");

//GetExpressResource("fundamentals_of_product_description_and_support","..\\data\\resource_docs\\fundamentals_of_product_description_and_support\\dvlp\\express\\irlist.txt");
