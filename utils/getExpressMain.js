//$Id: imagemap2xml.js,v 1.2 2002/01/29 17:23:38 robbod Exp $
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



function Debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function UserMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    WScript.Echo(msg);
    objShell.Popup(msg);
}

// Copy across the Integrated Resource express
function GetIrExpress(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var irFldr = fso.GetFolder(expDir+"/resources");
    var index = "../repository_index.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(index);
    var expr = "/repository_index/resources/resource";
    var resourceNodes = xml.selectNodes(expr);
    var members = resourceNodes.length;
    for (var i = 0; i < members; i++) {	
	var node = resourceNodes(i);
	var resourceName = node.attributes.getNamedItem("name").nodeValue;
	var src, dst;

	// Copy across resource express file
	var resourceFileName = "../data/resources/"+resourceName+"/"+resourceName+".exp";
	var newResourceFileName = expDir+"/resources/"+resourceName+".exp";
	//UserMessage(resourceFileName+"->"+newResourceFileName);

	if (fso.FileExists(resourceFileName)) {
	    src = fso.GetFile(resourceFileName);
	    dst = newResourceFileName;
	    src.Copy(dst);
	} else {
	    UserMessage("File does not exist:\n"+resourceFileName);
	}
	    
    }
}


// Copy across the MIM and the ARM express
function GetArmMimExpress(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var armFldr = fso.GetFolder(expDir+"/arm");
    var mimFldr = fso.GetFolder(expDir+"/mim");
    var index = "../repository_index.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(index);
    var expr = "/repository_index/modules/module";
    var moduleNodes = xml.selectNodes(expr);
    var members = moduleNodes.length;
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	var src, dst;

	// Copy across mim file
	var mimFileName = "../data/modules/"+moduleName+"/mim.exp";
	var newMimFileName = expDir+"/mim/"+moduleName+"_mim.exp";
	//UserMessage(mimFileName+"->"+newMimFileName);

	if (fso.FileExists(mimFileName)) {
	    src = fso.GetFile(mimFileName);
	    dst = newMimFileName;
	    src.Copy(dst);
	} else {
	    UserMessage("File does not exist:\n"+mimFileName);
	}
	    
	// Copy across arm file
	var armFileName = "../data/modules/"+moduleName+"/arm.exp";
	var newArmFileName = expDir+"/arm/"+moduleName+"_arm.exp";
	if (fso.FileExists(armFileName)) {
	    src = fso.GetFile(armFileName);
	    dst = newArmFileName;
	    src.Copy(dst);
	} else {
	    UserMessage("File does not exist:\n"+armFileName);
	}
    }
}

function MakeDirs(expDir) {
    var retVal = 1;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(expDir)) {
	ErrorMessage("Directory exists:\n"+expDir);
	return(-1);
    } else {
	fso.CreateFolder(expDir);
	fso.CreateFolder(expDir+"/arm");
	fso.CreateFolder(expDir+"/mim");
	fso.CreateFolder(expDir+"/resources");
    }
    return(retVal);
}



function TestArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript getExpress.js <new directory>\n";
    if (cArgs.length != 1) {
	ErrorMessage(msg);
	return(-1);
    } else {
	return(1);
    }
}


// Given the name of a new directory, <dir> create a three sub directories
// <dir>/arm - the ARM express
// <dir>/mim - the MIM express
// <dir>/resources - the Integrated resources express
// Copy the all the ARM, MIM and Integrated Resource express from the 
// repository renaming each express file to be the same as the schema it 
// contains and storing it in the relevant directory 
function Main() {
    if (TestArgs()==1) {
	var cArgs = WScript.Arguments;
	var expDir = cArgs(0);	
	if (MakeDirs(expDir) == 1) {
	    GetArmMimExpress(expDir);
	    GetIrExpress(expDir);
	    UserMessage("Created directory:\n  "+expDir);
	}
    }
}

//Run from getEpxress.wsf
function MainWindow(expDir) {
    if (MakeDirs(expDir) == 1) {
	GetArmMimExpress(expDir);
	GetIrExpress(expDir);
	UserMessage("Created directory:\n  "+expDir);
    }
}


