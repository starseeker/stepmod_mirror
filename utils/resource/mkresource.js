//$Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $
//  Author: Tom Hendrix
//  Owner:  
//  Purpose:  JScript to generate the default XML for the common resource.
//     cscript mkresource.js <resource> 
//     e.g.
//     cscript mkresource.js person
//     The script is called from mkresource.wsf


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// NOTE NO LONGER REQUIRE THIS VARIABLE TO BE SET
// Change this to wherever you have installed the resource repository
// Note the use of UNIX path descriptions as opposed to DOS
// var stepmodHome = "e:/My Documents/projects/nist_resource_repo/stepmod";

// If you do not run mkresource from 
var stepmodHome = "../..";

var resourceSchemas = new Array("s1", "s2", "s3", "s4");

var resourceClauses = new Array("main", "cover", "contents", 
			      "introduction", "foreword", 
			      "1_scope", "2_refs", "3_defs", 
			      "4_schema",  "5_schema", "6_schema", "7_schema", 
			      "a_short_names", 
                              "b_obj_reg", 
   			      "c_expg",
                              "c_4_schema_expg","c_5_schema_expg",
                              "c_6_schema_expg","c_7_schema_expg", 
			      "d_exp",
			      "d_exp_schema_4","d_exp_schema_5",
			      "d_exp_schema_6","d_exp_schema_7",
			      "e_guide", 
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
		     "stepmod/utils/mkresource.js to:\n\n"+stepmodHome+
		     "\n\nNote: it is a UNIX rather then WINDOWS path i.e. uses / not \\");
	return(false);
    }
    if (!fso.FolderExists(stepmodHome+"/data/resource_docs")) {
	ErrorMessage("You must run the script from the directory:\n"+
		     "stepmod/utils/resources");
	return(false);
    }
    return(true);
}


function CheckArgs() {
    var cArgs = WScript.Arguments;
    var msg = "Incorrect arguments\n"+
	"  cscript mkresource.js <resource>";
    if ((cArgs.length == 1) || (cArgs.length == 2)) {
	return(true);
    } else {
	ErrorMessage(msg);
	return(false);
    } 
}

function CheckResource(resource) {
    var resourceFldr = GetResource_docDir(resource);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // check if the folder exists
    if (fso.FolderExists(resourceFldr)) 
	throw("Directory already exists for resource: "+ resource);
    return(true);
}

function schemaName(resource,armOrMim) {
    var name = resource.substr(0,1).toUpperCase()+
	resource.substr(1,resource.length)+
	"_"+armOrMim;
    return(name); 
}

function GetResourceDir(){
    return( stepmodHome+"/data/resources/");
}

function GetResource_docDir(resource) {
    return( stepmodHome+"/data/resource_docs/"+resource+"/");
}

// Create the dvlp directory and insert the projmg and issues file
function MakeDvlpFldr(resource) {
  try {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var resource_docFldr = GetResource_docDir(resource);
    var resourceDvlpFldr = resource_docFldr+"dvlp/";
    var projmgXML = resourceDvlpFldr+"projmg.xml";
    var issuesXML = resourceDvlpFldr+"issues.xml";

    var objShell = WScript.CreateObject("WScript.Shell");
    var milestones = objShell.Popup("Do you want resource milestones?",0,"Creating resource milestones", 36);
    if (milestones == 6) {
	milestones=true;
    } else {
	milestones=false;
    }
    var f,ts;
    if (!fso.FolderExists(resourceDvlpFldr)) 
	fso.CreateFolder(resourceDvlpFldr);
    if (!fso.FileExists(projmgXML)) { 
	fso.CreateTextFile(projmgXML, true);
	f = fso.GetFile(projmgXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/projmg/projmg.xsl\"?>");
  	ts.WriteLine("<!DOCTYPE management SYSTEM \"../../../../dtd/projmg/projmg.dtd\">");
	ts.WriteLine("<management resource=\""+resource+"\"");
	ts.WriteLine("  percentage_complete=\"0\"");
	ts.WriteLine("  issues=\"issues.xml\">");
	ts.WriteLine("");
	ts.WriteLine("  <developers>");
	ts.WriteLine("    <developer ref=\"\"/>");
	ts.WriteLine("  </developers>");
	ts.WriteLine("");
	if (!milestones) ts.WriteLine("<!-- ");
	ts.WriteLine("  <resource.milestones>");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M1\"");
	ts.WriteLine("      description=\"Requirements allocated to resource\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M2\"");
	ts.WriteLine("      description=\"Draft for team review\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M3\"");
	ts.WriteLine("      description=\"Ready for QC\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M4\"");
	ts.WriteLine("      description=\"QC form completed\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M5\"");
	ts.WriteLine("      description=\"Submitted for ballot\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M6\"");
	ts.WriteLine("      description=\"Ballot comments resolved\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("");
	ts.WriteLine("    <milestone");
	ts.WriteLine("      name=\"M7\"");
	ts.WriteLine("      description=\"Published as TS\"");
	ts.WriteLine("      status=\"not-achieved\"");
	ts.WriteLine("      planned_date=\"\"");
	ts.WriteLine("      predicted_date=\"\"");
	ts.WriteLine("      achieved_date=\"\">");
	ts.WriteLine("    </milestone>");
	ts.WriteLine("  </resource.milestones>");
	ts.WriteLine("");
	ts.WriteLine("  <resource.checklist>");
	ts.WriteLine("    <status section=\"resource.header\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("    </status>");
	ts.WriteLine("    ");
	ts.WriteLine("    <status section=\"resource.intro\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("        Reviewed by PLCS");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("    ");
	ts.WriteLine("    <status section=\"mapping\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"arm.xml\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"arm_expressg\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"arm.exp\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"arm_lf.exp\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"mim.xml\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"mim_expressg\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"mim.exp\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("");
	ts.WriteLine("    <status section=\"mim_lf.exp\"");
	ts.WriteLine("      by=\"\"");
	ts.WriteLine("      date=\"\"");
	ts.WriteLine("      status=\"in-work\">");
	ts.WriteLine("      <description>");
	ts.WriteLine("      </description>");
	ts.WriteLine("    </status>");
	ts.WriteLine("  </resource.checklist>");
	if (!milestones) ts.WriteLine("-->");
	ts.WriteLine("</management>");
	ts.Close();
    }
    if (!fso.FileExists(issuesXML)) {
	fso.CreateTextFile(issuesXML, true );
	f = fso.GetFile(issuesXML);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/projmg/issues_file.xsl\"?>");
  	ts.WriteLine("<!DOCTYPE issues SYSTEM \"../../../../dtd/projmg/issues.dtd\">");
	ts.WriteLine("<issues resource=\""+resource+"\">");
	ts.WriteLine("");
	ts.WriteLine("<!--");
	ts.WriteLine("Description of how the issues files is given in: stepmod\\help\\issues.htm");
	ts.WriteLine(" id - an identifer of the isssue unique to this file");
	ts.WriteLine(" type - the primary XML element in resource.xml that the issue is against.");
	ts.WriteLine("        Either: ");
	ts.WriteLine("            general | keywords | contacts | purpose |");
	ts.WriteLine("            inscope | outscope | normrefs | definition |");
	ts.WriteLine("            abbreviations | arm | armexpg | arm_lf |");
	ts.WriteLine("            armexpg_lf | mapping_table | mim  | mimexpg |");
	ts.WriteLine("            mim_lf | mimexpg_lf | usage_guide | bibliography");
	ts.WriteLine(" linkend - the target of the comment ");
	ts.WriteLine(" category - editorial | minor_technical | major_technical | repository ");
	ts.WriteLine(" by - person raising the issue");
	ts.WriteLine(" date - date issue raised yy-mm-dd");
	ts.WriteLine(" status - status of issue. Either \"open\" or \"closed\"")
	ts.WriteLine("");
	ts.WriteLine("Comment - is a comment raised by someone about the issue");
	ts.WriteLine("");
	ts.WriteLine("<issue");
	ts.WriteLine("  id=\"\"");
	ts.WriteLine("  type=\"\"");
	ts.WriteLine("  linkend=\"\"");
	ts.WriteLine("  category=\"\"");
	ts.WriteLine("  by=\"\"");
	ts.WriteLine("  date=\"\"");
	ts.WriteLine("  status=\"open\">");
	ts.WriteLine("  <description>");
    	ts.WriteLine("");
	ts.WriteLine("   </description>");
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
  catch(e) {
	ErrorMessage(e);}
}


function MakeResourceClause(resource, clause) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resource_docFldr = GetResource_docDir(resource);
    var resourceSysFldr = resource_docFldr+"sys/";
    var clauseXML = resourceSysFldr+clause+".xml";
    var clauseXSL = "sect_"+clause+".xsl";

    //userMessage("Creating "+clauseXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( clauseXML, true );
    var f = fso.GetFile(clauseXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
    ts.WriteLine("<!DOCTYPE resource_clause SYSTEM \"../../../../dtd/resource_doc/resource_clause.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../../xsl/resource_doc/" + clauseXSL + "\" ?>");
    ts.WriteLine("<resource_clause directory=\"" + resource + "\"/>");

    ts.Close();
}

function MakeResourceSchema_Clause(resource, clause) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resource_docFldr = GetResource_docDir(resource);
    var resource_docSysFldr = resource_docFldr+"sys/";
    var clauseXML = resource_docSysFldr+clause+".xml";
    var clauseXSL = "sect_"+clause+".xsl";

    //userMessage("Creating "+clauseXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( clauseXML, true );
    var f = fso.GetFile(clauseXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
    ts.WriteLine("<!DOCTYPE resource_clause SYSTEM \"../../../../dtd//resource_docs/resource_clause.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../../xsl/resource_doc" + clauseXSL + "\" ?>");
    ts.WriteLine("<resource_clause directory=\"" + resource + "\"/>");
    ts.Close();
}

function MakeResourceXML(resource, partNo) {
    ErrorMessage("In MakeResourceXML");

    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resource_docFldr = GetResource_docDir(resource);
    var resourceXML = resource_docFldr + "resource.xml";

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( resourceXML, true );
    var f = fso.GetFile(resourceXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
// debug
    ts.Close();
    return;     
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
    ts.WriteLine("<!DOCTYPE resource SYSTEM \"../../../dtd/resource.dtd\">");
    //ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    //ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<!-- Generated by mkresource.js, Eurostep Limited, http://www.eurostep.com -->");
    ts.WriteLine(" <!-- ");
    ts.WriteLine("     To view the resource in IExplorer, open: sys/1_scope.xml");
    ts.WriteLine("      -->");
    ts.WriteLine("<resource");
    ts.WriteLine("   name=\"" + resource + "\"");
    ts.WriteLine("   part=\""+partNo+"\"");
    ts.WriteLine("   version=\"1\"");
    ts.WriteLine("   wg.number=\"00000\"");
//    ts.WriteLine("   wg.number.ballot_package=\"\"");
//    ts.WriteLine("   wg.number.ballot_comment=\"\"");

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
    
    // Do not want to make issues and proj mg available just yet
    //ts.WriteLine("   rcs.revision=\""+rcsrevision+"\"");
    //ts.WriteLine("   development.folder=\"dvlp\">");
    ts.WriteLine("");
    ts.WriteLine(" <keywords>");
    ts.WriteLine("    resource");
    ts.WriteLine(" </keywords>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Reference to contacts detailed in stepmod/data/basic/contacts.xml -->");
    ts.WriteLine(" <contacts>");
    // for pdmresources
    //ts.WriteLine("   <projlead ref=\"pdmresources.projlead\"/>");
    //ts.WriteLine("   <editor ref=\"pdmresources.editor\"/>");

    ts.WriteLine("   <projlead ref=\"xxx\"/>");
    ts.WriteLine("   <editor ref=\"xxx\"/>");
    ts.WriteLine(" </contacts>");
    ts.WriteLine("");
    ts.WriteLine(" <!-- Introduction -->");
    ts.WriteLine(" <!-- The introduction should start as shown: -->");
    ts.WriteLine(" <purpose>");
    ts.WriteLine("   <p>");
    ts.WriteLine("     This part of ISO 10303 specifies an application resource for the");
    ts.WriteLine("     representation of ");
    ts.WriteLine("   </p>");
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
    ts.WriteLine(" <!-- Schemas  -->");
    ts.WriteLine(" <schemas>");
    ts.WriteLine("   <schema name=\"-\">");
    ts.WriteLine("   <!-- Note schema EXPRESS are in ..\resources\resource_name\ name_of_schema.xml -->");
    ts.WriteLine("     <description>");
    ts.WriteLine("     </description>");
    ts.WriteLine("     <introduction>");
    ts.WriteLine("     </introduction>");
    ts.WriteLine("     <fund_concepts/>");
    ts.WriteLine("");
    ts.WriteLine("   <!-- EXPRESS-G -->");
    ts.WriteLine("     <express-g>");
    ts.WriteLine("       <imgfile file=\"armexpg1.xml\"/>");
    ts.WriteLine("     </express-g>");
    ts.WriteLine("   </schema>");
    ts.WriteLine(" </schemas>");
    ts.WriteLine("");
    ts.WriteLine("");
    ts.WriteLine("</resource>");
    ts.Close();
}

function MakeExpressG(resource, expgfile, title) {
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resourceFldr = GetResource_docDir(resource);
    var expg = resourceFldr+expgfile;
    var expg_gif = expgfile.replace(".xml",".gif");

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( expg, true );
    var f = fso.GetFile(expg);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
    ts.WriteLine("<!DOCTYPE imgfile.content SYSTEM \"../../../dtd/text.ent\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("    href=\"../../../xsl/imgfile.xsl\"?>");
    ts.WriteLine("<imgfile.content");
    ts.WriteLine("  resource=\""+resource+"\"");
    ts.WriteLine("  file=\""+expgfile+"\">");
    ts.WriteLine("  <img src=\""+expg_gif+"\">");
    ts.WriteLine("  </img>");
    ts.WriteLine("</imgfile.content>");
    ts.Close();

    // Copy across underconstruction image
    expg_gif = expg.replace(".xml",".gif");
    fso.CopyFile(stepmodHome+"/images/underconstruction.gif", expg_gif);
}


function MakeExpress(resource) {

//needs to be revamped for resources.
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resourceFldr = GetResource_docDir(resource);
    var resourceExp = resourceFldr+ GetResource_Schema +".exp";

    //userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimExp, true );
    var f = fso.GetFile(armOrMimExp);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("(*");
    ts.WriteLine("   $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $");
    ts.Write("   N - ISO/CD-TS - 10303- ");
    ts.Write(resource);
    ts.Write(" - EXPRESS ");
    ts.Write(armOrMim.toUpperCase());
    ts.WriteLine("*)");
    ts.WriteLine("(* UNDER DEVELOPMENT *)");
    var schema = schemaName(resource,armOrMim);
    ts.WriteLine("SCHEMA "+schema+";");
    ts.WriteLine("END_SCHEMA;");
    ts.Close();
}


function MakeExpressXML(resource) {
//needs to be revamed for resources
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var resourceFldr = GetResourceDir();
    var armOrMimXML = resourceFldr+armOrMim+".xml";

    //userMessage("Creating "+armOrMimXML);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile( armOrMimXML, true );
    var f = fso.GetFile(armOrMimXML);
    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!-- $Id: mkresource.js,v 1.1 2002/09/16 14:14:37 thendrix Exp $ -->");
    ts.WriteLine("<!DOCTYPE express SYSTEM \"../../../dtd/express.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\"");
    ts.WriteLine("href=\"../../../xsl/express.xsl\" ?>");
    ts.WriteLine("<express");
    ts.WriteLine("   language_version=\"2\"");
    ts.WriteLine("   rcs.date=\"$Date: 2002/09/16 14:14:37 $\"");
    ts.WriteLine("   rcs.revision=\"$Revision: 1.1 $\">");
    var schema = schemaName(resource,armOrMim);
    ts.WriteLine("  <schema name=\""+schema+"\">");
    ts.WriteLine("  </schema>");
    ts.WriteLine("</express>");
    ts.Close();
}

function UpdateResource(resource, partNo) {
    var resource_docFldr = GetResource_Dir(resource);
    var resource_docSysFldr = resource_docFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    userMessage("Updating resource "+resource);

    MakeExpressG(resource,"armexpg1.xml");
    MakeExpressG(resource,"mimexpg1.xml");
    MakeResourceXML(resource, partNo);
    userMessage("Created resource "+resource);
    }


function NameResource(resource) {

    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
     var resourceName = resource.replace(/(^\s*)|(\s*$)/g, "");

    // name must all be lower case
     resourceName = resourceName.toLowerCase();
    // no whitespace replace with  _
    re = / /g;
    resourceName = resourceName.replace(re, "_");
    
    // no - replace with  _
    re = /-/g;
    resourceName = resourceName.replace(re, "_");

    re = /__*/g;
    resourceName = resourceName.replace(re, "_");
    return(resourceName);
} 


function MakeResource_doc(resource, partNo) {
    // make sure resource has a valid name
    resource = NameResource(resource);
    var resource_docFldr = GetResource_docDir(resource);
    var resource_docSysFldr = resource_docFldr+"sys/";
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    ErrorMessage("Creating resource "+resource);
    try {

	CheckResource(resource);
	fso.CreateFolder(resource_docFldr);
	fso.CreateFolder(resource_docSysFldr);	
	MakeDvlpFldr(resource);

	for (var i=0; i<resourceClauses.length; i++) {
	    MakeResourceClause(resource, resourceClauses[i]);
	}

        for (var i=0; i<resourceSchemas.length; i++){
	    MakeResourceSchemaClauses(resource, resourceSchemas[i]);
 	}

        ErrorMessage("after MakeResourceSchemaClausesXML");

//	MakeExpressG(resource);
//	MakeExpressXML(resource);
//	MakeExpress(resource);

        ErrorMessage("before MakeResourceXML");

	MakeResourceXML(resource, partNo);
	userMessage("Created resource:   "+resource);
    }
    catch(e) {
	ErrorMessage(e);
    }    
}


function Main() {
    var cArgs = WScript.Arguments;
    if (CheckArgs() && CheckStepHome() ) {
	var cArgs = WScript.Arguments;
	var resource=cArgs(0);
    }
}

function MainDvlpWindow(resource) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var resourceName = NameResource(resource);
    if (resourceName.length > 1) {

	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var resource_docFldr = GetResource_docDir(resourceName);
	var resourceDvlpFldr = resource_docFldr+"dvlp/";
	if (!fso.FolderExists(resource_docFldr)) {
	    objShell.Popup("Resource "+resourceName+" does not exist");
	} else {
	    var intRet = objShell.Popup("You are about to create a dvlp directory in resource: "+resource,0, "Creating DVLP", 49);
	    if (intRet == 1) {
		// OK
		MakeDvlpFldr(resource);
		objShell.Popup("Created dvlp folder: "+resourceDvlpFldr +"\n"+
			       "  ProjMg: stepmod/data/resource_docs/"+resourceName+"/dvlp/projmg.xml\n"+
			       "  Issues: stepmod/data/resource_docs/"+resourceName+"/dvlp/issues.xml\n"+
			       "  Add    development.folder=\"dvlp\" to resource.xml\n",
			       0, "Created resource", 64);
	    }
	}
    } else {
	objShell.Popup("You must enter a resource name");
    }
}


function MainWindow(resource) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var resourceName = NameResource(resource);
    var question = "About to create resource: " + resourceName + "   OK?" ;
    if (resourceName.length > 1) {	
	var intRet = objShell.Popup(question,0, "Creating resource", 49);
	if (intRet == 1) {
	    // OK
	    MakeResource_doc(resource, 'xxx');
	    objShell.Popup("Created resource: "+resourceName+"\n"+
			   "  Directory: stepmod/data/resource_docs/"+resourceName+"\n"+ 
"To view resource in IExplorer open stepmod/data/resource_docs/"+resourceName+"/sys/1_scope.xml\n", 0, "Created resource", 64);
	}
    } else {
	objShell.Popup("You must enter a resource  name");
    }
}


//Main();
//MakeDvlpFldr("tester");
