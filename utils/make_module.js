//$Id: make_module.js,v 1.2 2001/11/22 09:51:22 robbod Exp $
// JScript to generate the expressg html for a module.
// This script uses The Saxon XSLT processor:
//  http://sourceforge.net/projects/saxon
// cscript make_module.js <module> 
// e.g.
// cscript make_module.js person

// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var saxonExe = "z:/apps/instant-saxon/saxon.exe";
var stepmodHome = "Z:/My Documents/projects/nist_module_repo/stepmod";
var ballotModulesHome = "Z:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169";

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

// This script can be used to:
//  copy across a set of HTML modules 
//   - run convertBallotModules
//MainConvertBallotModules(ballotModulesHome);
//
// List a set of modules in a directory structure, outputting th result in XML
//   - run listModules
//
//  run SAXON to generate the HTML for the modules
//   - makeHtmlModule
//
//  generate the directory structure and initial content for a module
//   - run MainMakeModule
//MainMakeModule();
//
//  update the directory structure and initial content for a module
//   - run MainUpdateModule
//MainUpdateModule();
//
//  update the directory structure and initial content for all modules listed
// in repository_index.xml
//   - run MainUpdateModule
//MainUpdateModules() 
//
// Make the HTML for all the resources from the XML
// MainMakeHtmlResources()

// Make the HTML for all the modules from the XML
// MainMakeHtmlModules()

// Make the all HTML for all the modules, resources and index
MainMakeHtmlAll()



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
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript make_module.js <module>" );	
	return(false);
    } 
    return(true);
}

function CheckModule(module) {
    var modFldr = GetModuleDir(module);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // check if the folder exists
    if (fso.FolderExists(modFldr)) 
	throw("Directory already exists for module: "+ module);
    return(true);
}


function GetModuleDir(module) {
    return( "../data/modules/"+module+"/");
}

function CheckModuleClauses(module) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    userMessage("Checking module: " + module);
    if (!fso.FolderExists(modFldr)) {
	userMessage(" +++ module folder does not exist: " + modFldr);
	return(false);
    }    

    if (!fso.FolderExists(modSysFldr)) {
	userMessage(" +++ module folder does not exist: " + modSysFldr);
	return(false);
    }    
    for (var i=0; i<moduleClauses.length; i++) {
	var clause = moduleClauses[i];
	var clauseXML = modSysFldr+clause+".xml";
	if (!fso.FileExists(clauseXML))
	    userMessage(" +++ clause missing: " + clauseXML);
    }
}

function UpdateModule(module) {
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    userMessage("Updating module "+module);

    for (var i=0; i<moduleClauses.length; i++) {
	MakeModuleClause(module, moduleClauses[i]);
    }
    
    MakeExpressXML(module,"arm");
    MakeExpressXML(module,"mim");
    MakeExpressXML(module,"mim_lf");
    MakeModuleXML(module);
}

function MakeModule(module) {
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    userMessage("Creating module "+module);
    try {
	CheckModule(module);

	fso.CreateFolder(modFldr);
	fso.CreateFolder(modSysFldr);	

	for (var i=0; i<moduleClauses.length; i++) {
	    MakeModuleClause(module, moduleClauses[i]);
	}

	MakeExpressXML(module,"arm");
	MakeExpressXML(module,"mim");
	MakeModuleXML(module);
    }
    catch(e) {
	ErrorMessage(e);
    }    
}


function MakeModuleXML(module) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var armOrMimXML = modFldr+"module.xml";

    userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimXML, true );
    var f = fso.GetFile(armOrMimXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: make_module.js,v 1.2 2001/11/22 09:51:22 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE module SYSTEM \"../../../dtd/module.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<module");
    ts.WriteLine("   name=\"" + module + "\"");
    ts.WriteLine("   part=\"\"");
    ts.WriteLine("   version=\"\"");
    ts.WriteLine("   iim=\"\"");
    var rcsdate = "$"+"Date: $";
    ts.WriteLine("   rcs.date=\""+rcsdate+"\"");
    var rcsrevision = "$"+"Revision: $";
    ts.WriteLine("   rcs.revision=\""+rcsrevision+"\">");
    ts.WriteLine(" <purpose>");
    ts.WriteLine(" </purpose>");
    ts.WriteLine("");
    ts.WriteLine(" <inscope>");
    ts.WriteLine(" </inscope>");
    ts.WriteLine("");
    ts.WriteLine(" <outscope>");
    ts.WriteLine(" </outscope>");
    ts.WriteLine("");
    ts.WriteLine(" <normrefs/>");
    ts.WriteLine("");
    ts.WriteLine(" <definition/>");
    ts.WriteLine("");
    ts.WriteLine(" <abbreviations/>");
    ts.WriteLine("");
    ts.WriteLine(" <arm/>");
    ts.WriteLine("");
    ts.WriteLine(" <mapping_table/>");
    ts.WriteLine("");
    ts.WriteLine(" <mim/>");
    ts.WriteLine("");
    ts.WriteLine("</module>");
    ts.Close();
}



function MakeExpressXML(module, armOrMim) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var armOrMimXML = modFldr+armOrMim+".xml";

    userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimXML, true );
    var f = fso.GetFile(armOrMimXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: make_module.js,v 1.2 2001/11/22 09:51:22 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE express SYSTEM \"../../../dtd/express.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<express>");
    ts.WriteLine("  <schema name=\""+module+"\">");
    ts.WriteLine("  </schema>");
    ts.WriteLine("</express>");
    ts.Close();
}

function MakeModuleClause(module, clause) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var clauseXML = modSysFldr+clause+".xml";
    var clauseXSL = "sect_"+clause+".xsl";

    userMessage("Creating "+clauseXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( clauseXML, true );
    var f = fso.GetFile(clauseXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: make_module.js,v 1.2 2001/11/22 09:51:22 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE module_clause SYSTEM \"../../../../dtd/module_clause.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../../xsl/" + clauseXSL + "\" ?>");
    ts.WriteLine("<module_clause directory=\"" + module + "\"/>");

    ts.Close();
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

    xmlFile = moduleHome + "arm.xml";
    htmFile = moduleHome + "arm.htm";	
    runSaxon(xmlFile, htmFile);

    xmlFile = moduleHome + "mim.xml";
    htmFile = moduleHome + "mim.htm";	
    runSaxon(xmlFile, htmFile);

    xmlFile = moduleHome + "mim_lf.xml";
    htmFile = moduleHome + "mim_lf.htm";	
    runSaxon(xmlFile, htmFile);

}



// Return true if the folder is a module folder. I.e. it contains arm.exp
// Used when convertng HTML modules to XML
function isModuleFldr(fldr) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var fc = new Enumerator(fldr.files);
    for (; !fc.atEnd(); fc.moveNext())
	{
	    var fpath = fc.item();
	    if ( fpath.Name == "arm.exp" ) {
		return(true);
	    }
	}
    return(false);
}


// Recursively search through the directory structure adding any folders
// that are module folders to the moduleArr
// Used when convertng HTML modules to XML
function getModuleFldrs(root, modulesArr) {
   var fso = new ActiveXObject("Scripting.FileSystemObject");
   var fldr = fso.GetFolder(root);
   if (isModuleFldr(fldr)) {
       modulesArr.push(fldr);
   } else {
       // loop through all sub folders
       var fc = new Enumerator(fldr.SubFolders);
       for (;!fc.atEnd(); fc.moveNext())
	   getModuleFldrs(fc.item(), modulesArr);
   }
}

// Copy an HTML module express to an XML module
// Used when convertng HTML modules to XML
function copyModuleExpress(fldr) {
   var fso = new ActiveXObject("Scripting.FileSystemObject");
   var src, dst;
   var module = fldr.Name;
   var moduleFldr = stepmodHome + "/data/modules/"+module+"/";
   var srcFile;

   userMessage("Copying " + fldr);
   if (!fso.FolderExists(moduleFldr)) 
       fso.CreateFolder(moduleFldr);

   // copy sf.exp
   srcFile=fldr + "/sf.exp";
   if (fso.FileExists(srcFile)) {
       src = fso.GetFile(fldr + "/sf.exp");
       dst = moduleFldr + "/mim.exp";
       src.Copy(dst);
   } else 
       errorMessage(srcFile + " does not exist.");

   // copy long_form.exp
   srcFile = fldr + "/long_form.exp";
   if (fso.FileExists(srcFile)) {
       src = fso.GetFile(srcFile);
       dst = moduleFldr + "/mim_lf.exp";
       src.Copy(dst);
   } else 
       ErrorMessage(srcFile + " does not exist.");
       
   // copy arm.exp
   srcFile=fldr + "/arm.exp";
   if (fso.FileExists(srcFile)) {
       src = fso.GetFile(srcFile);
       dst = moduleFldr + "/arm.exp";
       src.Copy(dst);
   } else 
       ErrorMessage(srcFile + " does not exist.");

   // copy arm.gif
   srcFile=fldr + "/arm.gif";
   if (fso.FileExists(srcFile)) {
       src = fso.GetFile(srcFile);
       dst = moduleFldr + "/arm.gif";
       src.Copy(dst);
   } else 
       ErrorMessage(srcFile + " does not exist.");

   // copy short_form.gif
   srcFile=fldr + "/short_form.gif";
   if (fso.FileExists(srcFile)) {
       src = fso.GetFile(srcFile);
       dst = moduleFldr + "/short_form.gif";
       src.Copy(dst);
   } else 
       ErrorMessage(srcFile + " does not exist.");
}


function listModules(root) {
    var modules = new Array;
    getModuleFldrs(root,modules);
    userMessage("<repository_index>");
    userMessage("  <modules>");

    for (var i=0; i<modules.length; i++) {
	var module = modules[i].Name;
	WScript.Echo("   <module name=\""+module+"\"/>");
    }
    userMessage(   "</modules>");
    userMessage("</repository_index>");
}

// Convert all the ballot modules to XML 
function MainConvertBallotModules(modDir) {
    var modules = new Array;
    getModuleFldrs(modDir,modules);
    for (var i=0; i<modules.length; i++) {
	var module = modules[i].Name;  
	// Generate the directory and sys files for the module.
	UpdateModule(module);
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	copyModuleExpress(modules[i]);
	//makeHtmlModule(module);
    }
    //listModules(stepmodHome);
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
		var reg = /<module\b.*name=/;
		if (l.match(reg)) {
		    l = l.replace(reg,"");
		    l = l.replace(/"/g,"");
		    l = l.replace(/\/>/g,"");
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
		    l = l.replace(/"/g,"");
		    l = l.replace(/\/>/g,"");
		    l = l.replace(/(^\s*)|(\s*$)/g, "");
                    arr[i++]=l;
		}
	    }
    }
  return(arr);
}

function MainMakeModule() {
    if (CheckArgs() == 1) {
	var cArgs = WScript.Arguments;
	var module = cArgs(0);
	try {
	    MakeModule(module);
	    //var objShell = WScript.CreateObject("WScript.Shell");
	    //objShell.Popup("Done");
	}
	catch(e) {
	    ErrorMessage(e);
	}
    }
}

function MainUpdateModule() {
    if (CheckArgs() == 1) {
	var cArgs = WScript.Arguments;
	var module = cArgs(0);
	try {
	    UpdateModule(module);
	    var objShell = WScript.CreateObject("WScript.Shell");
	    //objShell.Popup("Done");
	}
	catch(e) {
	    ErrorMessage(e);
	}
    }
}


//  update the directory structure and initial content for all modules listed
// in repository_index.xml
function MainUpdateModules() {
    var modules = readRepositoryIndexModules2Array();
    for (var i=0; i<modules.length; i++) {
	UpdateModule(modules[i]);
    }
}

// Make the HTML for all the resources from the XML
function MainMakeHtmlResources() {
    var resources = readRepositoryIndexResources2Array();
    for (var i=0; i<resources.length; i++) {
	var resource = resources[i];
	userMessage(resource);
	makeHtmlResource(resource);
    }
}

// Make the HTML for all the modules from the XML
function MainMakeHtmlModules() {
    var modules = readRepositoryIndexModules2Array();
    for (var i=0; i<modules.length; i++) {
	var module = modules[i];
	userMessage(module);
	makeHtmlModule(module);
    }
}

function MainMakeHtmlAll() {
    //MainMakeHtmlResources();
    //MainMakeHtmlModules();
    makeHtmlIndex();
}
