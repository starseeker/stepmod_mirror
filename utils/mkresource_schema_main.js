//$Id: mkmodule.js,v 1.26 2002/11/26 09:41:02 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep
//  Purpose:  JScript to generate the default XML for a resource schema
//     cscript mkresource_schema.js <module> 
//     e.g.
//     cscript mkresource_schema_main.js action_schema
//     The script is called from mkresource_schema.wsf


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
	"  cscript mkresource_schema.js <schema_name>";
    if (cArgs.length == 1) {
	return(true);
    } else {
	ErrorMessage(msg);
	return(false);
    } 
}


function GetResourceSchemaDir(res_schema) {
    return( stepmodHome+"/data/resources/"+res_schema+"/");
}

// Create the resource directory and insert 
function MakeResourceSchema(res_schema) {
    userMessage(res_schema);
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var resFldr = GetResourceSchemaDir(res_schema);
    var developerXML = resFldr+"developer.xml";
    var resource_mapXML = resFldr+"resource_map.xml";
    var f,ts;
    if (!fso.FolderExists(resFldr)) 
	fso.CreateFolder(resFldr);

    if (!fso.FileExists(developerXML)) { 
	fso.CreateTextFile(developerXML, true);
	f = fso.GetFile(developerXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkmodule.js,v 1.26 2002/11/26 09:41:02 robbod Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../nav/xsl/schema_developer.xsl\"?>");
  	ts.WriteLine("<stylesheet_application directory=\""+res_schema+"\"/>");
	ts.Close();
    }

    if (!fso.FileExists(resource_mapXML)) {
	fso.CreateTextFile(resource_mapXML, true );
	f = fso.GetFile(resource_mapXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkmodule.js,v 1.26 2002/11/26 09:41:02 robbod Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../nav/xsl/resource_map.xsl\"?>");
  	ts.WriteLine("<stylesheet_application directory=\""+res_schema+"\"/>");
	ts.Close();
    }
}



//MakeResourceSchema("action_schema");
