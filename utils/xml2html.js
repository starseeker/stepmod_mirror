//$Id: xml2html.js,v 1.2 2002/01/03 10:35:42 robbod Exp $
// JScript to convert the module XML to HTML
//
// This script uses The Saxon XSLT processor:
//  http://sourceforge.net/projects/saxon
//
// cscript xml2html.js module <module>
//   generate the HTML for a module
//
// cscript xml2html.js all modules
//   generate the HTML for all modules
//
// cscript xml2html.js resource <resource>
//   generate the HTML for a resource
//
// cscript xml2html.js all resources
//   generate the HTML for all resources
//
// cscript xml2html.js all 
//   generate all the HTML for the module repository.


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// change to point to local installation of saxon
var saxonExe = "z:/apps/instant-saxon/saxon.exe";

// change to point to root diectory of module repository
var stepmodHome = "Z:/My Documents/projects/nist_module_repo/stepmod";

var ForReading = 1, ForWriting = 2, ForAppending = 8;
var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;

var ForReading = 1, ForWriting = 2, ForAppending = 8;
var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;


var moduleClauses = new Array("main", "cover", "introduction", "foreword", 
			      "1_scope", "2_refs", "3_defs", "4_info_reqs", 
			      "5_mim", "5_mapping", 
			      "a_short_names", "b_obj_reg", "c_arm_expg", 
			      "d_mim_expg", 
			      "e_exp", 
			      "e_exp_mim", "e_exp_mim_lf", 
			      "e_exp_arm", "e_exp_arm_lf", 
			      "f_guide", 
			      "biblio");

//------------------------------------------------------------
function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    WScript.Echo(msg);
    objShell.Popup(msg);
}

function userMessage(msg) {
    WScript.Echo(msg);
}

function CheckArgs() {
    var cArgs = WScript.Arguments;
    var msg = "Incorrect arguments\n"+
	"  cscript xml2html.js module <module>\n"+
	"  cscript xml2html.js all modules\n"+
	"  cscript xml2html.js resource <resource>\n"+
	"  cscript xml2html.js all resources\n"+
	"  cscript xml2html.js all";
    if (cArgs.length < 1) {
	ErrorMessage(msg);
	return(false);
    } 

    var mode=cArgs(0);
    var arg="";
    switch(mode) {
    case "module" :
	if (cArgs.length != 2) {
	    ErrorMessage(msg);
	    return(false);
	}
	break;
	case "resource" :
	    if (cArgs.length != 2) {
		ErrorMessage(msg);
		return(false);
	    }
	    break;
    case "all" :
	if (cArgs.length == 2) {
	    arg=cArgs(1);
	    switch(arg) {
	    case "modules" :
		break;
	    case "resources" :
		break;
	    default :
		ErrorMessage(msg);
		return(false);
		break;
	    }
	} else if (cArgs.length > 2) {
	    ErrorMessage(msg);
	    return(false);
	}	    
	break;
    default :
	ErrorMessage(msg);
	return(false);
	break;
    }        
    return(true);
}


function runSaxon(xmlFile, htmFile) {
    userMessage("HTML to XML: ");
    userMessage("  html: " + htmFile);
    userMessage("  xml: " + xmlFile);
    var args = " -a -o \"" + htmFile + "\" \"" + xmlFile + "\" output_type=\"HTM\"";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    if (fso.FileExists(xmlFile)) {
	var WSHShell = WScript.CreateObject("WScript.Shell");
	var ret = WSHShell.Run (saxonExe + args, 2, true);
	userMessage(ret);
    } else {
	ErrorMessage(" Can't find:: " + xmlFile);
    }
}


function makeHtmlIndex()
{
    var xmlFile = stepmodHome + "/repository_index.xml";
    var htmFile = stepmodHome + "/repository_index.htm";
    runSaxon(xmlFile, htmFile);
}

function makeHtmlResource(resource)
{
    var resourceHome = stepmodHome + "/data/resources/" 
	+ resource + "/" + resource;
    var xmlFile = resourceHome + ".xml";
    var htmFile = resourceHome + ".htm";
    runSaxon(xmlFile, htmFile);
}


function makeHtmlModule(module)
{
    var moduleHome = stepmodHome + "/data/modules/" + module;
    var xmlFile, htmFile;

    for (var i=0; i<moduleClauses.length; i++) {
	xmlFile = moduleHome + "/sys/" + moduleClauses[i] +".xml";
	htmFile = moduleHome + "/sys/" + moduleClauses[i] +".htm";	
	runSaxon(xmlFile, htmFile);
    }

    xmlFile = moduleHome + "/arm.xml";
    htmFile = moduleHome + "/arm.htm";	
    runSaxon(xmlFile, htmFile);

    xmlFile = moduleHome + "/mim.xml";
    htmFile = moduleHome + "/mim.htm";	
    runSaxon(xmlFile, htmFile);

    xmlFile = moduleHome + "/mim_lf.xml";
    htmFile = moduleHome + "/mim_lf.htm";	
    runSaxon(xmlFile, htmFile);

}

function readRepositoryIndexModules2Array() {
    var repoIndexFile = stepmodHome + "/repository_index.xml";
    var arr = new Array();
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FileExists(repoIndexFile)) {
	f = fso.GetFile(repoIndexFile);
	var xmlTs = f.OpenAsTextStream(ForReading, TristateUseDefault);
	var i=0;
	while (!xmlTs.AtEndOfStream)
	    {
		var l = xmlTs.ReadLine();
		//var reg = /name=\"(\b.*)\"/g;
		
		var reg = /<module\b.*name=/;
		var m = l.match(reg);
		if (m) {
		    l = l.replace(reg,"");		    
		    l = l.replace(/"/,"");
		    l = l.replace(/\".*\/>/g,"");
		    l = l.replace(/(^\s*)|(\s*$)/g, "");
                    arr[i++]=l;
		}
	    }
    }
  return(arr);
}

function readRepositoryIndexResources2Array() {
    var repoIndexFile = stepmodHome + "/repository_index.xml";
    var arr = new Array();
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FileExists(repoIndexFile)) {
	f = fso.GetFile(repoIndexFile);
	var xmlTs = f.OpenAsTextStream(ForReading, TristateUseDefault);
	var i=0;
	while (!xmlTs.AtEndOfStream)
	    {
		var l = xmlTs.ReadLine();
		var reg = /<resource\b.*name=/;
		if (l.match(reg)) {
				    l = l.replace(reg,"");		    
		    l = l.replace(/"/,"");
		    l = l.replace(/\".*\/>/g,"");
		    l = l.replace(/(^\s*)|(\s*$)/g, "");
                    arr[i++]=l;
		    userMessage(l);
		}
	    }
    }
  return(arr);
}


function makeHtmlModules() {
    var modules = readRepositoryIndexModules2Array();
    for (var i=0; i<modules.length; i++) {
	var module = modules[i];
	userMessage(module);
	makeHtmlModule(module);
    }
}


function makeHtmlResources() {
    var resources = readRepositoryIndexResources2Array();
    for (var i=0; i<resources.length; i++) {
	var resource = resources[i];
	userMessage(resource);
	makeHtmlResource(resource);
    }
}
function makeHtmlAll() {
    makeHtmlResources();
    makeHtmlModules();
    makeHtmlIndex();
}



function Main() {
    var cArgs = WScript.Arguments;
    if (CheckArgs() == 1) {
	var cArgs = WScript.Arguments;
	var mode=cArgs(0);
	switch(mode) {
	case "module" :
	    makeHtmlModule(cArgs(1));
	    break;
	case "resource" :
	    makeHtmlResource(cArgs(1));
	    break;
	case "all" :
	    if (cArgs.length == 2) {
		arg=cArgs(1);
		switch(arg) {
		case "modules" :
		    makeHtmlModules();
		    break;
		case "resources" :
		    makeHtmlResources();
		    break;
		}
	    } else {
		makeHtmlAll();
	    }
	}
    }
}

Main();



