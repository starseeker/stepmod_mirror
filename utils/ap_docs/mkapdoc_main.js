//$Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to PDES Inc under contract.
//  Purpose:  JScript to generate the default XML for the ap document.
//     cscript mkapdoc_main.js <ap doc> 
//     e.g.
//     cscript mkapdoc_main.js person
//     The script is called from mkapdoc.wsf


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------
// If you do not run mkapdoc_main from this directory set this
var stepmodHome = "../..";

var apClauses = new Array("introduction", "1_scope", "2_refs", "3_defs", "4_info_reqs",
			  "5_main", "6_ccs", "contents", "cover",  "biblio", "foreword", 
			  "annex_exp_lf", "annex_shortnames", "annex_imp_meth",
			  "annex_pics", "annex_obj_reg", "annex_aam", "annex_arm_expg", "annex_comp_int",
			  "annex_guide", "annex_tech_disc", "annex_changes");

var apFrames = new Array("frame_aptitle", "frame_toc", "frame_contenttitle", "frame_index");

var apIndexes = new Array("index_arm_modules",
			  "index_arm_modules_top",
			  "index_arm_modules_inner",
			  "index_mim_modules",
			  "index_mim_modules_top",
			  "index_mim_modules_inner",
			  "index_resources",
			  "index_resources_top",
			  "index_resources_inner",
			  "index_arm_express",
			  "index_arm_express_top",
			  "index_arm_express_inner",
			  "index_mim_express",
			  "index_mim_express_top",
			  "index_mim_express_inner",
			  "index_arm_mappings",
			  "index_arm_mappings_top",
			  "index_arm_mappings_inner"
			  );

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
		     "stepmod/utils/ap_docs/mkapdoc_main.js to:\n\n"+stepmodHome+
		     "\n\nNote: it is a UNIX rather then WINDOWS path i.e. uses / not \\");
	return(false);
    }
    if (!fso.FolderExists(stepmodHome+"/data/application_protocols")) {
	ErrorMessage("You must run the script from the directory:\n"+
		     "stepmod/utils/ap_docs");
	return(false);
    }
    return(true);
}


function NameApDoc(apDoc) {

    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
     var apDocName = apDoc.replace(/(^\s*)|(\s*$)/g, "");

    // name must all be lower case
     apDocName = apDocName.toLowerCase();
    // no whitespace replace with  _
    re = / /g;
    apDocName = apDocName.replace(re, "_");
    
    // no - replace with  _
    re = /-/g;
    apDocName = apDocName.replace(re, "_");

    re = /__*/g;
    apDocName = apDocName.replace(re, "_");
    return(apDocName);
}


function CheckApDoc(apDoc) {
    var apDocFldr = GetApDocDir(apDoc);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // check if the folder exists
    if (fso.FolderExists(apDocFldr)) 
	throw("Directory already exists for AP document: "+ apDoc);
    return(true);
}

function GetApDocDir(apDoc) {
    return( stepmodHome+"/data/application_protocols/"+apDoc+"/");
}

// Create a Readme file
function MakeReadme(apDoc) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var apDocFldr = GetApDocDir(apDoc);
    var readme = apDocFldr+"readme.txt";
    var objShell = WScript.CreateObject("WScript.Shell");
    var f,ts;
    if (fso.FolderExists(apDocFldr)) {
	userMessage("Creating "+readme);
	fso.CreateTextFile(readme, true );
	var f = fso.GetFile(readme);
	var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);	    
	ts.WriteLine("$Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $");
	ts.WriteLine("");
	ts.WriteLine("      -----------------------------");
	ts.WriteLine("      Application Protocol document");
	ts.WriteLine("      -----------------------------");
	ts.WriteLine("");
	ts.WriteLine("Directory created by: stepmod/utils/ap_docs/mkapdoc_main.js");
	ts.WriteLine("");
	ts.WriteLine("aam.xml");
	ts.WriteLine("  contains the application activity model");
	ts.WriteLine("");
	ts.WriteLine("application_protocol.xml");
	ts.WriteLine("  contains the main clauses of the application protocol");
	ts.WriteLine("");
	ts.WriteLine("ccs.xml");
	ts.WriteLine("  contains the conformance classes of application protocol");
	ts.WriteLine("");
	ts.WriteLine("home.xml");
	ts.WriteLine("  open this file to display the application protocol in a browser");
	ts.WriteLine("");
	ts.WriteLine("dvlp/issues.xml");
	ts.WriteLine("  contains all issues raised against the application protocol");
	ts.WriteLine("");
	ts.WriteLine("sys");
	ts.WriteLine("  DO NOT EDIT FILES IN THIS DIRECTORY")
	ts.WriteLine("  contains files used by XSL to generate clauses for application protocol");
	ts.Close();
    }
}



// Create the dvlp directory and insert the projmg and issues file
function MakeDvlpFldr(apDoc, update) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var apDocFldr = GetApDocDir(apDoc);
    var apDocDvlpFldr = apDocFldr+"dvlp/";
    var projmgXML = apDocDvlpFldr+"projmg.xml";
    var issuesXML = apDocDvlpFldr+"issues.xml";

    var objShell = WScript.CreateObject("WScript.Shell");
    var f,ts;
    if (!fso.FolderExists(apDocDvlpFldr)) 
	fso.CreateFolder(apDocDvlpFldr);
    if (!fso.FileExists(projmgXML)) { 
	fso.CreateTextFile(projmgXML, true);
	f = fso.GetFile(projmgXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/projmg/projmg.xsl\"?>");
  	ts.WriteLine("<!DOCTYPE management SYSTEM \"../../../../dtd/projmg/projmg.dtd\">");
	ts.WriteLine("<management ap_doc=\""+apDoc+"\"");
	ts.WriteLine("  percentage_complete=\"0\"");
	ts.WriteLine("  issues=\"issues.xml\">");
	ts.WriteLine("");
	ts.WriteLine("  <developers>");
	ts.WriteLine("    <developer ref=\"\"/>");
	ts.WriteLine("  </developers>");
	ts.WriteLine("");
	ts.WriteLine("</management>");
	ts.Close();
    }
    if (!fso.FileExists(issuesXML)) {
	fso.CreateTextFile(issuesXML, true );
	f = fso.GetFile(issuesXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/projmg/issues_file.xsl\"?>");
  	ts.WriteLine("<!DOCTYPE issues SYSTEM \"../../../../dtd/projmg/apdoc_issues.dtd\">");
	ts.WriteLine("<issues ap_doc=\""+apDoc+"\">");
	ts.WriteLine("");
	ts.WriteLine("<!--");
	ts.WriteLine("Description of how the issues files is given in: stepmod\\help\\issues.htm");
	ts.WriteLine(" id - an identifer of the isssue unique to this file");
	ts.WriteLine(" type - the primary XML element in apDoc.xml that the issue is against.");
	ts.WriteLine("        Either: ");
	ts.WriteLine("            general | cover | keywords | abstract  | contacts | purpose | inscope | outscope");
	ts.WriteLine("            | data_plan | normrefs | definition | abbreviations | fundamentals | reqtover | aam"); 
	ts.WriteLine("            | usage_guide | tech_disc | bibliography)");
	ts.WriteLine(" category - editorial | minor_technical | major_technical | repository ");
	ts.WriteLine(" by - person raising the issue");
	ts.WriteLine(" date - date issue raised yy-mm-dd");
	ts.WriteLine(" status - status of issue. Either \"open\" or \"closed\"");
	ts.WriteLine(" seds - if \"yes\" then the issue has been raised as a SEDS.");
	ts.WriteLine("        The id should be the id of the SEDS in the SC4 database");
	ts.WriteLine("");
	ts.WriteLine("Comment - is a comment raised by someone about the issue");
	ts.WriteLine("");
	ts.WriteLine("<issue");
	ts.WriteLine("  id=\"\"");
	ts.WriteLine("  type=\"\"");
	ts.WriteLine("  category=\"\"");
	ts.WriteLine("  by=\"\"");
	ts.WriteLine("  date=\"\"");
	ts.WriteLine("  status=\"open\"");
	ts.WriteLine("  seds=\"no\">");
	ts.WriteLine("  <description>");
    	ts.WriteLine("");
	ts.WriteLine("  </description>");
    	ts.WriteLine("");
    	ts.WriteLine("<comment");
	ts.WriteLine("   by=\"\" ");
    	ts.WriteLine("   date=\"\">");
	ts.WriteLine("<description>");
    	ts.WriteLine("</description>");
	ts.WriteLine("</comment>");
	ts.WriteLine(" </issue>");
	ts.WriteLine("-->");
	ts.WriteLine("");
	ts.WriteLine("<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->");
	ts.WriteLine("<!-- +++++++++++++++++++   ISSUES                  ++++++++++++++ -->");
	ts.WriteLine("<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->");
	ts.WriteLine("");
	ts.WriteLine("</issues>");
	ts.Close();
    }
}

function MakeApDocFrame(apDoc, frame) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocSysFldr = apDocFldr+"sys/";
    var frameXML = apDocSysFldr+frame+".xml";
    var frameXSL = frame+".xsl";

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(apDocSysFldr)) {
	if (!fso.FileExists(frameXML)) { 
	    //userMessage("Creating "+frameXML);
	    fso.CreateTextFile( frameXML, true );
	    var f = fso.GetFile(frameXML);
	    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);	    
	    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
	    ts.WriteLine("<!-- Do not edit -->");
	    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/ap_doc/" + frameXSL + "\" ?>");
	    ts.WriteLine("<application_protocol directory=\"" + apDoc + "\"/>");
	    ts.Close();
	}
    }
}

function MakeApDocHome(apDoc) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var homeXML = apDocFldr+"/home.xml";
    var homeXSL = "home.xsl";

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(apDocFldr)) {
	if (!fso.FileExists(homeXML)) { 
	    //userMessage("Creating "+homeXML);
	    fso.CreateTextFile( homeXML, true );
	    var f = fso.GetFile(homeXML);
	    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);	    
	    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
	    ts.WriteLine("<!-- Do not edit -->");
	    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/ap_doc/" + homeXSL + "\" ?>");
	    ts.WriteLine("<application_protocol directory=\"" + apDoc + "\"/>");
	    ts.Close();
	}
    }
}

function MakeApDocIndex(apDoc, index) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocSysFldr = apDocFldr+"sys/";
    var indexXML = apDocSysFldr+index+".xml";
    var indexXSL = index+".xsl";

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(apDocSysFldr)) {
	if (!fso.FileExists(indexXML)) { 
	    //userMessage("Creating "+indexXML);
	    fso.CreateTextFile( indexXML, true );
	    var f = fso.GetFile(indexXML);
	    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	    
	    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
	    ts.WriteLine("<!-- Do not edit -->");
	    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/ap_doc/" + indexXSL + "\" ?>");
	    ts.WriteLine("<application_protocol directory=\"" + apDoc + "\"/>");
	    ts.Close();
	}
    }
}


function MakeApDocClause(apDoc, clause, module_name) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocSysFldr = apDocFldr+"sys/";
    var clauseXML = apDocSysFldr+clause+".xml";
    var clauseXSL = "sect_"+clause+".xsl";

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(apDocSysFldr)) {
	if (!fso.FileExists(clauseXML)) { 
	    //userMessage("Creating "+clauseXML);
	    fso.CreateTextFile( clauseXML, true );
	    var f = fso.GetFile(clauseXML);
	    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	    
	    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
	    ts.WriteLine("<!DOCTYPE application_protocol_clause SYSTEM \"../../../../dtd/ap_doc/application_protocol_clause.dtd\">");
	    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/ap_doc/" + clauseXSL + "\" ?>");
	    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
	    ts.WriteLine("<!-- Do not edit -->");
	    ts.WriteLine("<application_protocol_clause");
	    ts.WriteLine("    directory=\"" + apDoc + "\"");
	    ts.WriteLine("    module_directory=\"" + module_name + "\"/>");	    
	    ts.Close();
	}
    }
}


function MakeApAamXML(apDoc) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocXML = apDocFldr+"aam.xml";

    userMessage("Creating "+apDocXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( apDocXML, true );
    var f = fso.GetFile(apDocXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE idef0 SYSTEM \"../../../dtd/ap_doc/aam.dtd\">");
    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
    ts.WriteLine("<!-- ");
    ts.WriteLine("     IDEF0 activity model for "+apDoc);
    ts.WriteLine("      -->");
    ts.WriteLine("<idef0>");
    ts.WriteLine("  <!-- view point of the IDEF0 model -->");
    ts.WriteLine("  <viewpoint>viewpointXXX</viewpoint>");
    ts.WriteLine("");
    ts.WriteLine("  <!-- IDEF0 page -->");
    ts.WriteLine("  <page number=\"1\" node=\"A-0\" title=\"titleXXX\">");
    ts.WriteLine("    <!-- activity in the IDEF0 model -->");
    ts.WriteLine("    <activity identifier=\"A0\" inscope=\"yes\">");
    ts.WriteLine("      <name>");
    ts.WriteLine("        nameXXX");
    ts.WriteLine("      </name>");
    ts.WriteLine("      <description>");
    ts.WriteLine("        descriptionXXX");
    ts.WriteLine("      </description>");
    ts.WriteLine("    </activity>");
    ts.WriteLine("  </page>");
    ts.WriteLine("");
    ts.WriteLine("  <!-- IDEF0 Arrow definitions (inputs controls outputs mechanism) -->");
    ts.WriteLine("  <icoms>");
    ts.WriteLine("");
    ts.WriteLine("    <!-- IDEF0 Arrow definition (inputs controls outputs mechanism) -->");
    ts.WriteLine("    <icom identifier=\"icomXXX\" inscope=\"no\">");
    ts.WriteLine("      <name>");
    ts.WriteLine("        icomnameXX");
    ts.WriteLine("      </name>");
    ts.WriteLine("      <description>");
    ts.WriteLine("        icomdescriptionXXX");
    ts.WriteLine("      </description>");
    ts.WriteLine("    </icom>");
    ts.WriteLine("  </icoms>");
    ts.WriteLine("</idef0>");
    ts.Close();
}

function MakeApCcXML(apDoc, module_name) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocXML = apDocFldr+"ccs.xml";

    userMessage("Creating "+apDocXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( apDocXML, true );
    var f = fso.GetFile(apDocXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE conformance SYSTEM \"../../../dtd/ap_doc/ccs.dtd\">");
    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
    ts.WriteLine("<!-- ");
    ts.WriteLine("     The conformance classes for " +apDoc);
    ts.WriteLine("     -->");
    ts.WriteLine("<conformance>");
    ts.WriteLine("  <!-- The top level conformance class.");
    ts.WriteLine("       No arm_entities specified so all ARM entities specified in");
    ts.WriteLine("       "+module_name+" are part of the conformance class.");
    ts.WriteLine("       -->");
    ts.WriteLine("  <cc id=\"CC1\" name=\""+apDoc+"_cc1\" module=\""+module_name+"\">");
    ts.WriteLine("    <inscope from_module=\"YES\"/>");
    ts.WriteLine("  </cc>");
    ts.WriteLine("");
    ts.WriteLine("  <!-- The second conformance class.");
    ts.WriteLine("       The arm_entities identify the ARM entities in");
    ts.WriteLine("       "+module_name+" that are part of the conformance class.");
    ts.WriteLine("       -->");
    ts.WriteLine("  <cc id=\"CC2\" name=\""+apDoc+"_cc2\" module=\""+module_name+"\">");
    ts.WriteLine("    <inscope from_module=\"NO\">");
    ts.WriteLine("      <li>");
    ts.WriteLine("        @@@@ cc in scope statement @@@@");
    ts.WriteLine("      </li>");
    ts.WriteLine("    </inscope>");
    ts.WriteLine("  </cc>");
    ts.WriteLine("");
    ts.WriteLine("  <!-- A list of the ARM entities identifying which Conformance class use them -->");
    ts.WriteLine("  <arms_in_ccs>");
    ts.WriteLine("     <arm_entity_in_cc name=\"@@@entity@@@\">");
    ts.WriteLine("       <cc_id id=\"CC1\"/>");
    ts.WriteLine("     </arm_entity_in_cc>");
    ts.WriteLine("   </arms_in_ccs>");
    ts.WriteLine("");
    ts.WriteLine("</conformance>");
    ts.Close();
}


function MakeApImgfile(apDoc, imgfile) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var img = apDocFldr+imgfile;
    var img_gif = imgfile.replace(".xml",".gif");

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile(img, true );
    var f = fso.GetFile(img);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE ap.imgfile.content SYSTEM \"../../../dtd/ap_doc/text.ent\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/ap_doc/imgfile.xsl\"?>");
    ts.WriteLine("<ap.imgfile.content");
    ts.WriteLine("  application_protocol=\""+apDoc+"\"");
    ts.WriteLine("  file=\""+imgfile+"\">");
    ts.WriteLine("  <img src=\""+img_gif+"\">");
    ts.WriteLine("  </img>");
    ts.WriteLine("</ap.imgfile.content>");
    ts.Close();

    // Copy across underconstruction image
    img_gif = img.replace(".xml",".gif");
    fso.CopyFile(stepmodHome+"/images/underconstruction.gif", img_gif);
}

function MakeApDocXML(apDoc, title, partNo, module_name, new_edition, purpose) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var apDocFldr = GetApDocDir(apDoc);
    var apDocXML = apDocFldr+"application_protocol.xml";

    userMessage("Creating "+apDocXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( apDocXML, true );
    var f = fso.GetFile(apDocXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkapdoc_main.js,v 1.13 2003/05/30 10:00:26 robbod Exp $ -->");
    ts.WriteLine("<!DOCTYPE application_protocol SYSTEM \"../../../dtd/ap_doc/application_protocol.dtd\">");
    ts.WriteLine("<!-- Generated by mkapdoc_main.js, Eurostep Limited, http://www.eurostep.com -->");
    ts.WriteLine("<!-- ");
    ts.WriteLine("     To view the application document in IExplorer, open: sys/1_scope.xml");
    ts.WriteLine("      -->");
    ts.WriteLine("<!-- The XML for the AP documents");
    ts.WriteLine("     name :");
    ts.WriteLine("       is the name/directory of the Application protocol, all lower case with no whitespace");
    ts.WriteLine("");
    ts.WriteLine("     module_name :");
    ts.WriteLine("       is the name of the top level implementation module, the AP module");
    ts.WriteLine("");
    ts.WriteLine("     title :");
    ts.WriteLine("       is the title of the AP document");
    ts.WriteLine("");
    ts.WriteLine("     part :");
    ts.WriteLine("       ISO 10303 part number of the AP document");
    ts.WriteLine("");
    ts.WriteLine("     purpose :");
    ts.WriteLine("       Used to complete the first sentence in the introduction");
    ts.WriteLine("         \"This part of ISO 10303 specifies an application protocol (AP) for .....\"");
    ts.WriteLine("       and clause 4");
    ts.WriteLine("         \"This clause specifies the information required for ....\"");
    ts.WriteLine("");
    ts.WriteLine("     wg.number :");
    ts.WriteLine("       SC4 N-number of the AP document");
    ts.WriteLine("");
    ts.WriteLine("     wg.number.supersedes :");
    ts.WriteLine("       the SC4 N-number of the document that this AP document supercedes");
    ts.WriteLine("");
    ts.WriteLine("     version :");
    ts.WriteLine("       version of AP document ");
    ts.WriteLine("");
    ts.WriteLine("     status :");
    ts.WriteLine("       AP document status");
    ts.WriteLine("");
    ts.WriteLine("     language :");
    ts.WriteLine("       E for English langauge");
    ts.WriteLine("");
    ts.WriteLine("     publication.year :");
    ts.WriteLine("       year of publication of AP document");
    ts.WriteLine("");
    ts.WriteLine("     published :");
    ts.WriteLine("       y if published");
    ts.WriteLine("-->");
    ts.WriteLine("<application_protocol");
    ts.WriteLine("   name=\"" + apDoc + "\"");
    ts.WriteLine("   module_name=\"" + module_name + "\"");
    ts.WriteLine("   title=\""+title+"\"");
    ts.WriteLine("   part=\""+partNo+"\"");
    ts.WriteLine("   purpose=\""+purpose+"\"");
    ts.WriteLine("   wg.number=\"00000\"");
    ts.WriteLine("   version=\"1\"");
    ts.WriteLine("   status=\"CD\"");
    ts.WriteLine("   language=\"E\"");
    ts.WriteLine("   publication.year=\"\"");
    ts.WriteLine("   published=\"n\"");
    //ts.WriteLine("   wg.number.ballot_package=\"\"");
    //ts.WriteLine("   wg.number.ballot_comment=\"\"");
    ts.WriteLine("   checklist.internal_review=\"\"");
    ts.WriteLine("   checklist.project_leader=\"\"");
    ts.WriteLine("   checklist.convener=\"\"");
    
    if (new_edition == true) {
	ts.WriteLine("   wg.number.supersedes=\"\""); 
	ts.WriteLine("   previous.revision.number=\"\""); 
	ts.WriteLine("   previous.revision.year=\"\""); 
	ts.WriteLine("   previous.revision.cancelled=\"NO\"");
	ts.WriteLine("   revision.complete=\"NO\"");
	ts.WriteLine("   revision.scope=\"\""); 
    }

    var rcsdate = "$"+"Date: $";
    ts.WriteLine("   rcs.date=\""+rcsdate+"\"");
    var rcsrevision = "$"+"Revision: $";    
    ts.WriteLine("   rcs.revision=\""+rcsrevision+"\"");
    ts.WriteLine("   development.folder=\"dvlp\">");
    ts.WriteLine("");
    ts.WriteLine(" <keywords>");
    ts.WriteLine("    Application protocol, @@@@");
    ts.WriteLine(" </keywords>");
    ts.WriteLine("");
    ts.WriteLine("<!-- the abstract for the application protocol. -->");
    ts.WriteLine(" <abstract>");
    ts.WriteLine("    <li>@@@@ abstract statement @@@@</li>");
    ts.WriteLine(" </abstract>");
    ts.WriteLine("");
    if (new_edition == true) {
	ts.WriteLine("<!-- A new edition of an AP so document the changes -->");
	ts.WriteLine(" <changes>");
	ts.WriteLine("  <!-- The summary of the changes -->");
	ts.WriteLine("  <change_summary>");
	ts.WriteLine("    @@@@ change_summary @@@@");
	ts.WriteLine("  </change_summary>");
	ts.WriteLine("  <!-- The details of the changes -->");
	ts.WriteLine("  <change_detail>");
	ts.WriteLine("    @@@@ change_detail @@@@");
	ts.WriteLine("   </change_detail>");
	ts.WriteLine(" </changes>");
	ts.WriteLine("");
    }

    ts.WriteLine(" <!-- Reference to contacts detailed in stepmod/data/basic/contacts.xml -->");
    ts.WriteLine(" <contacts>");
    ts.WriteLine("   <projlead ref=\"@@@@projlead@@@@\"/>");
    ts.WriteLine("   <editor ref=\"@@@@editor@@@@\"/>");
    ts.WriteLine(" </contacts>");
    ts.WriteLine("");

    ts.WriteLine(" <!-- Introduction -->");
    ts.WriteLine(" <purpose>");
    ts.WriteLine("   <data_plan>");
    ts.WriteLine("     <imgfile file=\"data_plan_intro1.xml\"/>");  
    ts.WriteLine("   </data_plan>");
    ts.WriteLine("   <p>");
    ts.WriteLine("   @@@@ purpose/introduction @@@@");
    ts.WriteLine("   </p>");
    ts.WriteLine(" </purpose>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Items in scope ");
    ts.WriteLine("      If from_module is YES then XSL will copy the in scope statement from the module.");
    ts.WriteLine("      The XSL will automatically insert:");
    ts.WriteLine("          \"This part of ISO 10303 specifies the use of the integrated");
    ts.WriteLine("           resources necessary for the scope and information requirements for \"");
    ts.WriteLine("      The context is the text that completes the sentence.");
    ts.WriteLine("     -->");
    ts.WriteLine(" <inscope from_module=\"YES\" context=\"@@@@.\">");
    ts.WriteLine("   <li>@@@@ in scope statement @@@@</li>");
    ts.WriteLine(" </inscope>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Items out of scope");
    ts.WriteLine("      If from_module is YES then XSL will copy the out scope statement from the module");
    ts.WriteLine("     -->");
    ts.WriteLine(" <outscope from_module=\"YES\">");
    ts.WriteLine("   <li>@@@@ out scope statement @@@@</li>");
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
    ts.WriteLine(" <!-- Clause 4  -->");
    ts.WriteLine(" <inforeqt>");
    ts.WriteLine("   <fundamentals>");
    ts.WriteLine("     <data_plan>");
    ts.WriteLine("       <imgfile file=\"data_plan_detail1.xml\"/>");  
    ts.WriteLine("     </data_plan>");
    ts.WriteLine("     <description>");
    ts.WriteLine("       <p>");
    ts.WriteLine("       @@@@");
    ts.WriteLine("       Business concepts and terminology descriptions goes here and");
    ts.WriteLine("       provides the context for the information requirements.");
    ts.WriteLine("       This may include a data planning model. This may be a more detailed");
    ts.WriteLine("       data planning model than that in the introduction. ");
    ts.WriteLine("       References to the Activity model may be included as notes.");
    ts.WriteLine("       The description may link to the modules.");
    ts.WriteLine("       @@@@");
    ts.WriteLine("       </p>");
    ts.WriteLine("     </description>");
    ts.WriteLine("   </fundamentals>");
    ts.WriteLine("   <reqtover module=\"@@@@\">");
    ts.WriteLine("    <description>");
    ts.WriteLine("      <p>");
    ts.WriteLine("        @@@@ summary of module requirements goes here @@@@");
    ts.WriteLine("      </p>");
    ts.WriteLine("    </description>");
    ts.WriteLine("   </reqtover>");
    ts.WriteLine("   <reqtover module=\"@@@@\">");
    ts.WriteLine("    <description>");
    ts.WriteLine("      <p>");
    ts.WriteLine("        @@@@ summary of module requirements goes here @@@@");
    ts.WriteLine("      </p>");
    ts.WriteLine("    </description>");
    ts.WriteLine("   </reqtover>");
    ts.WriteLine(" </inforeqt>");
    ts.WriteLine("");
    ts.WriteLine("<!--  Terminology map -->");
    ts.WriteLine("  <terminology_map>");
    ts.WriteLine("    <!-- mapping of a business to term to an AP term -->");
    ts.WriteLine("    <term_map>");
    ts.WriteLine("      <description>");
    ts.WriteLine("        @@@@ description of the mapping @@@");
    ts.WriteLine("      </description>");
    ts.WriteLine("      <business_term term_id=\"@@@@\"/>");
    ts.WriteLine("      <ap_term term_id=\"@@@@\" application_protocol=\"@@@@\"/>");
    ts.WriteLine("      <module_term term_id=\"@@@@\" module=\"@@@@\"/>");
    ts.WriteLine("    </term_map>");
    ts.WriteLine("  </terminology_map>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Activity Model -->");
    ts.WriteLine(" <aam>");
    ts.WriteLine("   <idef0>");
    ts.WriteLine("     <imgfile file=\"aamidef01.xml\"/>");
    ts.WriteLine("   </idef0>");
    ts.WriteLine(" </aam>");
    ts.WriteLine("");

    ts.WriteLine(" <!--  -->");
    ts.WriteLine("<imp_meths>");
    ts.WriteLine("<imp_meth general=\"n\" part=\"21\">");
    ts.WriteLine("  <description>");
    ts.WriteLine("   @@@@");
    ts.WriteLine("  </description>");
    ts.WriteLine("</imp_meth>");
    ts.WriteLine("</imp_meths>");

    ts.WriteLine("");
    ts.WriteLine(" <usage_guide>");
    ts.WriteLine("   @@@");
    ts.WriteLine(" </usage_guide>");

    ts.WriteLine("");
    ts.WriteLine(" <tech_disc>");
    ts.WriteLine("  @@@@");
    ts.WriteLine(" </tech_disc>");

    ts.WriteLine("");
    ts.WriteLine("<bibliography>");
    ts.WriteLine("  <bibitem.inc ref=\"@@@@\"/>");
    ts.WriteLine("</bibliography>");

    ts.WriteLine("</application_protocol>");
    ts.Close();
}

function MakeSysFldr(apDoc, module_name) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var apDocFldr = GetApDocDir(apDoc);
    var apDocSysFldr = apDocFldr+"sys";
    if (fso.FolderExists(apDocSysFldr)) {
	// remove all the files 
	var files = apDocSysFldr+"/*";
	fso.DeleteFile(apDocSysFldr, true);
    }
    if (!fso.FolderExists(apDocSysFldr)) {
	fso.CreateFolder(apDocSysFldr);	
    }
    for (var i=0; i<apClauses.length; i++) {
	MakeApDocClause(apDoc, apClauses[i], module_name);
    }
    
    for (var i=0; i<apFrames.length; i++) {
	MakeApDocFrame(apDoc, apFrames[i]);
    }
    
    for (var i=0; i<apIndexes.length; i++) {
	MakeApDocIndex(apDoc, apIndexes[i]);
    }
}

function MakeApDoc(apDoc, title, partNo, module_name, new_edition, purpose) {
    // make sure apDoc has a valid name
    apDoc = NameApDoc(apDoc);
    module_name = NameApDoc(module_name);
    var apDocFldr = GetApDocDir(apDoc);
    var apDocSysFldr = apDocFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    userMessage("Creating AP document "+apDoc);
    try {
	CheckApDoc(apDoc);

	fso.CreateFolder(apDocFldr);

	MakeSysFldr(apDoc,module_name);
	MakeDvlpFldr(apDoc);

	MakeApDocHome(apDoc);
	MakeApDocXML(apDoc, title, partNo, module_name, new_edition, purpose);
	MakeApAamXML(apDoc);
	MakeApCcXML(apDoc, module_name);
	MakeApImgfile(apDoc, "data_plan_intro1.xml");
	MakeApImgfile(apDoc, "data_plan_detail1.xml");
	MakeApImgfile(apDoc, "aamidef01.xml");
	MakeReadme(apDoc);
	userMessage("Created apDoc:   "+apDoc);
    }
    catch(e) {
	ErrorMessage(e);
    }    
}

//MakeApDoc("apDocName", "apDocTitle", "apDocPartNo", "apDocModule", true);

//MakeSysFldr("product_life_cycle_support","ap239_product_life_cycle_support");
