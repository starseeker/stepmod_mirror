//$Id: mkmodule.js,v 1.15 2002/07/14 15:05:51 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:  JScript to generate the default XML for the module.
//     cscript mkmodule.js <module> 
//     e.g.
//     cscript mkmodule.js person
//     The script is called from mkmodule.ws


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// NOTE NO LONGER REQUIRE THIS VARIABLE TO BE SET
// Change this to wherever you have installed the module repository
// Note the use of UNIX path descriptions as opposed to DOS
// var stepmodHome = "e:/My Documents/projects/nist_module_repo/stepmod";

// If you do not run mkmodule from 
var stepmodHome = "..";


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
	"  cscript mkmodule.js <module> <long_form>";
    if ((cArgs.length == 1) || (cArgs.length == 2)) {
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
    if (fso.FolderExists(modFldr)) 
	throw("Directory already exists for module: "+ module);
    return(true);
}


function GetModuleDir(module) {
    return( stepmodHome+"/data/modules/"+module+"/");
}

// Create the dvlp directory and insert the projmg and issues file
function MakeDvlpDir(module) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var modFldr = GetModuleDir(module);
    var modDvlpFldr = modFldr+"dvlp/";
    var projmgXML = modDvlpFldr+"projmg.xml";
    var issuesXML = modDvlpFldr+"issues.xml";

    var f,ts;
    if (!fso.FolderExists(modDvlpFldr)) 
	fso.CreateFolder(modDvlpFldr);
    if (!fso.FileExists(projmgXML)) { 
	fso.CreateTextFile(projmgXML, true );
	f = fso.GetFile(projmgXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	// ADD XML HERE
	ts.Close();
    }
    if (!fso.FileExists(issuesXML)) {
	fso.CreateTextFile(issuesXML, true );
	f = fso.GetFile(issuesXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	// ADD XML HERE
	ts.Close();
    }
}


function MakeModuleClause(module, clause) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var clauseXML = modSysFldr+clause+".xml";
    var clauseXSL = "sect_"+clause+".xsl";

    //userMessage("Creating "+clauseXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( clauseXML, true );
    var f = fso.GetFile(clauseXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkmodule.js,v 1.15 2002/07/14 15:05:51 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE module_clause SYSTEM \"../../../../dtd/module_clause.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../../xsl/" + clauseXSL + "\" ?>");
    ts.WriteLine("<module_clause directory=\"" + module + "\"/>");

    ts.Close();
}


function MakeModuleXML(module, long_form, partNo) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var armOrMimXML = modFldr+"module.xml";

    //userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimXML, true );
    var f = fso.GetFile(armOrMimXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkmodule.js,v 1.15 2002/07/14 15:05:51 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE module SYSTEM \"../../../dtd/module.dtd\">");
    //ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    //ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<!-- Generated by mkmodule.js, Eurostep Limited, http://www.eurostep.com -->");
    ts.WriteLine(" <!-- ");
    ts.WriteLine("     To view the module in IExplorer, open: sys/1_scope.xml");
    ts.WriteLine("      -->");
    ts.WriteLine("<module");
    ts.WriteLine("   name=\"" + module + "\"");
    ts.WriteLine("   part=\""+partNo+"\"");
    ts.WriteLine("   version=\"1\"");
    ts.WriteLine("   wg.number=\"00000\"");
    ts.WriteLine("   wg.number.arm=\"\"");
    ts.WriteLine("   wg.number.mim=\"\"");
    ts.WriteLine("   wg.number.ballot_package=\"\"");
    ts.WriteLine("   wg.number.ballot_comment=\"\"");
    ts.WriteLine("   checklist.internal_review=\"\"");
    ts.WriteLine("   checklist.project_leader=\"\"");
    ts.WriteLine("   checklist.convener=\"\"");
    ts.WriteLine("   status=\"CD-TS\"");
    ts.WriteLine("   language=\"E\"");
    ts.WriteLine("   publication.year=\"\"");
    ts.WriteLine("   published=\"n\"");
    var rcsdate = "$"+"Date: $";
    ts.WriteLine("   rcs.date=\""+rcsdate+"\"");
    var rcsrevision = "$"+"Revision: $";
    ts.WriteLine("   rcs.revision=\""+rcsrevision+"\">");
    ts.WriteLine("");
    ts.WriteLine(" <keywords>");
    ts.WriteLine("    module");
    ts.WriteLine(" </keywords>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Reference to contacts detailed in stepmod/data/basic/contacts.xml -->");
    ts.WriteLine(" <contacts>");
    // for pdmmodules
    //ts.WriteLine("   <projlead ref=\"pdmmodules.projlead\"/>");
    //ts.WriteLine("   <editor ref=\"pdmmodules.editor\"/>");

    ts.WriteLine("   <projlead ref=\"xxx\"/>");
    ts.WriteLine("   <editor ref=\"xxx\"/>");
    ts.WriteLine(" </contacts>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Introduction -->");
    ts.WriteLine(" <purpose>");
    ts.WriteLine(" </purpose>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Items in scope -->");
    ts.WriteLine(" <inscope>");
    ts.WriteLine("   <li>xxxxx</li>");
    ts.WriteLine(" </inscope>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Items out of scope -->");
    ts.WriteLine(" <outscope>");
    ts.WriteLine("   <li>xxxx</li>");
    ts.WriteLine(" </outscope>");
    ts.WriteLine("");
    ts.WriteLine("<!--");
    ts.WriteLine(" <normrefs/>");
    ts.WriteLine("");
    ts.WriteLine(" <definition/>");
    ts.WriteLine("");
    ts.WriteLine(" <abbreviations/>");
    ts.WriteLine("-->");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Clause 4 ARM  -->");
    ts.WriteLine(" <arm>");
    ts.WriteLine("   <!-- Note ARM short form EXPRESS is in arm_sf.xml -->");
    ts.WriteLine("   <!-- Units of functionality -->");
    ts.WriteLine("   <uof name=\"-\">");
    ts.WriteLine("     <description>");
    ts.WriteLine("     </description>");
    ts.WriteLine("     <uof.ae entity=\"-\"/>");
    ts.WriteLine("   </uof>");
    ts.WriteLine("");
    ts.WriteLine("   <!-- Short form EXPRESS-G -->");
    ts.WriteLine("   <express-g>");
    ts.WriteLine("     <imgfile file=\"armexpg1.xml\"/>");
    ts.WriteLine("   </express-g>");
    ts.WriteLine(" </arm>");
    ts.WriteLine("");
    if (long_form == true) {
	ts.WriteLine(" <!-- ARM long form (optional) -->");
	ts.WriteLine(" <!-- If not required, delete this section and the following files:");
	ts.WriteLine("          arm_lf.xml");
	ts.WriteLine("          armexpg_lf1.gif");
	ts.WriteLine("          armexpg_lf1.xml -->");
	ts.WriteLine(" <arm_lf>");
	ts.WriteLine("   <!-- Note ARM long form EXPRESS is in arm_lf.xml -->");
	ts.WriteLine("   <express-g>");
	ts.WriteLine("     <imgfile file=\"armexpg_lf1.xml\"/>");
	ts.WriteLine("   </express-g>");
	ts.WriteLine(" </arm_lf>");
    }
    ts.WriteLine("");
    ts.WriteLine(" <!-- Clause 5.1 Mapping specification -->");
    ts.WriteLine(" <mapping_table>");
    ts.WriteLine("   <ae entity=\"xx\"/>");
    ts.WriteLine(" </mapping_table>");

    ts.WriteLine("");
    ts.WriteLine(" <!-- Clause 5.2 MIM -->");
    ts.WriteLine(" <mim>");
    ts.WriteLine("   <!--  Note MIM short form express is in mim.xml -->");
    ts.WriteLine("   <express-g>");
    ts.WriteLine("     <imgfile file=\"mimexpg1.xml\"/>");
    ts.WriteLine("   </express-g>");
    ts.WriteLine(" </mim>");
    ts.WriteLine("");

    if (long_form == true) {
	ts.WriteLine(" <!-- MIM long form (optional) -->");
	ts.WriteLine(" <!-- If not required, delete this section and the following files:");
	ts.WriteLine("          mim_lf.xml");
	ts.WriteLine("          mimexpg_lf1.gif");
	ts.WriteLine("          mimexpg_lf1.xml -->");
	ts.WriteLine(" <mim_lf>");
	ts.WriteLine("   <!-- Note MIM long form EXPRESS is in mim_lf.xml -->");
	ts.WriteLine("   <express-g>");
	ts.WriteLine("     <imgfile file=\"mimexpg_lf1.xml\"/>");
	ts.WriteLine("   </express-g>");
	ts.WriteLine(" </mim_lf>");
	ts.WriteLine("");
    }
    ts.WriteLine("</module>");
    ts.Close();
}

function MakeExpressG(module, expgfile, title) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var expg = modFldr+expgfile;
    var expg_gif = expgfile.replace(".xml",".gif");

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( expg, true );
    var f = fso.GetFile(expg);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkmodule.js,v 1.15 2002/07/14 15:05:51 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE imgfile.content SYSTEM \"../../../dtd/text.ent\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("    href=\"../../../xsl/imgfile.xsl\"?>");
    ts.WriteLine("<imgfile.content");
    ts.WriteLine("  module=\""+module+"\"");
    ts.WriteLine("  file=\""+expgfile+"\">");
    ts.WriteLine("  <img src=\""+expg_gif+"\">");
    ts.WriteLine("  </img>");
    ts.WriteLine("</imgfile.content>");
    ts.Close();

    // Copy across underconstruction image
    expg_gif = expg.replace(".xml",".gif");
    fso.CopyFile(stepmodHome+"/images/underconstruction.gif", expg_gif);
}


function MakeExpressXML(module, armOrMim) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var modFldr = GetModuleDir(module);
    var armOrMimXML = modFldr+armOrMim+".xml";

    //userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimXML, true );
    var f = fso.GetFile(armOrMimXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkmodule.js,v 1.15 2002/07/14 15:05:51 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE express SYSTEM \"../../../dtd/express.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<express");
    ts.WriteLine("   language_version=\"2\"");
    ts.WriteLine("   rcs.date=\"$Date: 2002/07/14 15:05:51 $\"");
    ts.WriteLine("   rcs.revision=\"$Revision: 1.15 $\">");
    ts.WriteLine("  <schema name=\""+module+"_"+armOrMim+"\">");
    ts.WriteLine("  </schema>");
    ts.WriteLine("</express>");
    ts.Close();
}

function UpdateModule(module, long_from, partNo) {
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    userMessage("Updating module "+module);

//      var modOldFldr = modFldr+"old/";
//      if (fso.FolderExists(modOldFldr)) {
//  	throw("old directory already exists for module: "+ module);
//      } else {
//  	fso.CreateFolder(modOldFldr);
//      }
//      userMessage("Created: "+modOldFldr);
//      var armg = modFldr+"armexpg1.xml";
//      userMessage("moving: "+armg);
//      if (fso.FileExists(armg)) 
//  	fso.MoveFile(armg,modOldFldr);

//      var mimg = modFldr+"mimexpg1.xml";
//      if (fso.FileExists(mimg)) 
//  	fso.MoveFile(mimg,modOldFldr);

//      var modxml = modFldr+"module.xml";
//      if (fso.FileExists(modxml)) 
//  	fso.MoveFile(modxml,modOldFldr);

    MakeExpressG(module,"armexpg1.xml");
    MakeExpressG(module,"mimexpg1.xml");
    MakeModuleXML(module, long_form, partNo);
    userMessage("Created module "+module);
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



function MakeModule(module, long_form, partNo) {
    // make sure module has a valid name
    module = NameModule(module);
    var modFldr = GetModuleDir(module);
    var modSysFldr = modFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    //userMessage("Creating module "+module);
    try {
	CheckModule(module);

	fso.CreateFolder(modFldr);
	fso.CreateFolder(modSysFldr);	

	for (var i=0; i<moduleClauses.length; i++) {
	    MakeModuleClause(module, moduleClauses[i]);
	}
	MakeExpressG(module,"armexpg1.xml");
	MakeExpressG(module,"mimexpg1.xml");
	MakeExpressXML(module,"arm");
	MakeExpressXML(module,"mim");
	
	if (long_form == true) {
	    MakeExpressG(module,"armexpg_lf1.xml");
	    MakeExpressG(module,"mimexpg_lf1.xml");
	    MakeExpressXML(module,"arm_lf");
	    MakeExpressXML(module,"mim_lf");
	}

	MakeModuleXML(module, long_form, partNo);
	userMessage("Created module:   "+module);
    }
    catch(e) {
	ErrorMessage(e);
    }    
}


function Main() {
    var cArgs = WScript.Arguments;
    if (CheckArgs() && CheckStepHome() ) {
	var cArgs = WScript.Arguments;
	var module=cArgs(0);
	var long_form=false;
	if (cArgs.length == 2) {
	    long_form=true;
	}
	try {
	    MakeModule(module, long_form, 'xxxx');
	}
	catch(e) {
	    ErrorMessage(e);
	}
    }
}

function MainWindow(module) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var modName = NameModule(module);
    if (modName.length > 1) {
	var question;
	var long_form = objShell.Popup("Do you need a long_form?",0,"Creating module", 36);
	if (long_form == 6) {
	    long_form = true;
	    question = "About to create module: "+modName+
		" with a long form\n   OK?";
	} else if (long_form == 7) {
	    long_form = false;
	    question = "About to create module: "+modName+
		" with no long form\n   OK?";

	}
	
	
	var intRet = objShell.Popup(question,0, "Creating module", 49);
	if (intRet == 1) {
	    // OK
	    MakeModule(module, long_form, 'xxxx');
	    objShell.Popup("Created module: "+modName+"\n"+
			   "  Directory: stepmod/data/modules/"+modName+"\n"+
			   "  To view module in IExplorer open stepmod/data/modules/"+modName+"/sys/1_scope.xml\n",
			   0, "Created module", 64);
	}
    } else {
	objShell.Popup("You must enter a module name");
    }
}


//Main();

