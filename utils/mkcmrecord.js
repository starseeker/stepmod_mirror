//$Id: mkcmrecord.js,v 1.1 2007/04/13 02:02:31 radack Exp $
//  Author: Gerald Radack
//          Adapted from mkmodule.js by Rob Bodington.
//  Purpose: JScript to generate CM record for a module.
//
//     cscript mkcmrecord.js <module> 
//     e.g.
//     cscript mkcmrecord.js person
//     The script is called from mkcmrecord.ws


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// NOTE NO LONGER REQUIRE THIS VARIABLE TO BE SET
// Change this to wherever you have installed the module repository
// Note the use of UNIX path descriptions as opposed to DOS
// var stepmodHome = "e:/My Documents/projects/nist_module_repo/stepmod";

// If you do not run mkmodule from 
var stepmodHome = "..";


// If 1 then output user messages
var outputUsermessage = 1;


//------------------------------------------------------------
function userMessage(msg){
    if (outputUsermessage == 1)
	WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    objShell.Popup(msg);
}

function CheckStepHome() {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FolderExists(stepmodHome)) {
	ErrorMessage("The variable stepmodHome is incorrectly set in:\n"+
		     "stepmod/utils/mkmodule.js to:\n\n"+stepmodHome+
		     "\n\nNote: it is a UNIX rather then WINDOWS path i.e. uses / not \\");
	return(false);
    }
    if (!fso.FolderExists(stepmodHome+"/data/modules")) {
	ErrorMessage("You must run the script from the directory:\n"+
		     "stepmod/utils");
	return(false);
    }
    return(true);
}


function CheckArgs() {
    var cArgs = WScript.Arguments;
    var msg = "Incorrect arguments\n"+
	"  cscript mkcmrecord.js <module>";
    userMessage("length = " + cArgs.length);
    if (cArgs.length == 1) {
	return(true);
    } else {
	ErrorMessage(msg);
	return(false);
    } 
}

function CheckModule(module) {
    var modFldr = GetModuleDir(module);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // check if the folder exists
    if (!fso.FolderExists(modFldr)) 
	throw("Directory does not exist for module: "+ module);
    return(true);
}

function GetModuleDir(module) {
    return( stepmodHome+"/data/modules/"+module+"/");
}

function NameModule(module) {

    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
     var modName = module.replace(/(^\s*)|(\s*$)/g, "");

    // name must all be lower case
     modName = modName.toLowerCase();
    // no whitespace replace with  _
    re = / /g;
    modName = modName.replace(re, "_");
    
    // no - replace with  _
    re = /-/g;
    modName = modName.replace(re, "_");

    re = /__*/g;
    modName = modName.replace(re, "_");
    return(modName);
} 


function MakeCmRecord(module) {
    // make sure module has a valid name
    module = NameModule(module);
    var modFldr = GetModuleDir(module);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var objShell = WScript.CreateObject("WScript.Shell");

    try {
	CheckModule(module);
	// Invoke the Java program.
	var oExec = 1;
	var env = objShell.Environment("SYSTEM");
	var saxonHome = env("SAXON_HOME");
	var classpath = "mkcmrecord;mkcmrecord/mkcmrecord.jar;" + saxonHome + "/saxon8.jar;" + saxonHome + "/saxon8-dom.jar";
	var cmd = "java -classpath " + classpath + " MakeCMRecordGui " + stepmodHome + " " + module;

	oExec = objShell.Exec(cmd);

	while (oExec.Status == 0) {
	     WScript.Sleep(100);
	}
	userMessage("Exec status = " + oExec.Status);

	userMessage("Created CM record: "+module);
    }
    catch(e) {
	ErrorMessage(e);
    }    
}

function MainWindow(module) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var modName = NameModule(module);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (modName.length > 1) {
	var intRet = 1;

	var modFldr = GetModuleDir(modName);
	var cmFilePath = modFldr+"cm_record.xml";
	objShell.Popup("cmFilePath = " + cmFilePath);
	if (fso.fileExists(cmFilePath)) {
	    var question = "Update CM record for module " + module + "? ";
	    intRet = objShell.Popup(question,0, "Update existing CM record", 49);
	}

	if (intRet == 1) {
	    // OK
	    intRet = MakeCmRecord(module);
	    /*
	    if (intRet = 1) {
		objShell.Popup("CM record created or updated: stepmod/data/modules/"+modName+"/cm_record.xml\n",
			       0, "Created CM record", 64);
	    }
	    */
	}
    } else {
	objShell.Popup("You must enter a module name");
    }
}


//------------------------------------------------------------

function Main() {
    var cArgs = WScript.Arguments;
    if (CheckArgs() && CheckStepHome() ) {
	var cArgs = WScript.Arguments;
	var module=cArgs(0);
	try {
	    MakeCmRecord(module);
	}
	catch(e) {
	    ErrorMessage(e);
	}
    }
}
