//$Id: testRepositoryIndexMain.js,v 1.2 2002/07/30 13:20:56 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:
//    JScript to to test that all the modules present in repository_index 
//	exist.     



// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

// If 1 then output user messages
var outputUsermessage = 1;


var moduleClauses = new Array("main", "cover", "contents", 
			      "introduction", "foreword", 
			      "1_scope", "2_refs", "3_defs", "4_info_reqs", 
			      "5_main", "5_mim", "5_mapping", 
			      "a_short_names", "b_obj_reg", "c_arm_expg", 
			      "d_mim_expg", 
			      "e_exp", 
			      "e_exp_mim", "e_exp_mim_lf", 
			      "e_exp_arm", "e_exp_arm_lf", 
			      "f_guide", 
			      "biblio");

// The number of Errors detected.
var errorCount = 0;

//------------------------------------------------------------
function userMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    else
	objShell.Popup(msg);
}



function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    else
	objShell.Popup(msg);
}



// Check that a module directory exists
function testModule(module) {    
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var moduleFldr = stepmodHome + "/data/modules/" + module;
    if (fso.FolderExists(moduleFldr)) {
	var file = moduleFldr+"/module.xml";
	if (!fso.FileExists(file)) {
	    ErrorMessage("Error M2: Module "+module
			 +"\n   There is no file: "
			 +"\n   "+file+"\n");
	    errorCount++;
	}
	var fldr = moduleFldr+"/sys";
	if (!fso.FolderExists(fldr)) {
	    ErrorMessage("Error M3: Module "+module
			 +"\n   There is no sys folder: "
			 +"\n   "+file+"\n");
		    errorCount++;
	}

    } else {
	ErrorMessage("Error M1: Module "+module
		     +"\n   There is no module folder:"
		     +"\n   "+moduleFldr+"\n");
	    errorCount++;
	}
}


function outputModuleList() {
    var repoIndexXml = stepmodHome + "/repository_index.xml";
    userMessage("Testing: "+repoIndexXml);
    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(repoIndexXml);
    var expr = "/repository_index/modules/module";
    var moduleNodes = objXML.selectNodes(expr);
    var members = moduleNodes.length;
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	testModule(moduleName);
    }
    if (errorCount > 0) 
	ErrorMessage("There were "+ errorCount + " errors found");
    else
	userMessage("No errors found");
}

//outputModuleList();

