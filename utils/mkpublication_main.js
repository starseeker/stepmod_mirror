//$Id: mkballot_main.js,v 1.16 2003/08/19 06:35:47 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:  JScript to generate a publication package



// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

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

// Make the various XML files that simply apply stylesheets 
// to publication_index.xml
function mkPublicationXsl(publication,xsl,xml) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var publicationXml = stepmodHome+"/publication/publication/"+publication+"/sys/"+xml;
    fso.CreateTextFile(publicationXml, true);
    var f = fso.GetFile(publicationXml);

    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/"+xsl+"\" ?>");

    ts.WriteLine("<!-- ");
    ts.WriteLine("$Id: mkpublication_main.js,v 1.16 2003/08/19 06:35:47 robbod Exp $");
    ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
    ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
    ts.WriteLine("  Purpose: ");
    ts.WriteLine("-->");
    ts.WriteLine("<publication directory=\""+publication+"\"/>");
    ts.Close();
}


function mkPublicationPackage(publication) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;

    var publicationDir = stepmodHome + "/publication/publication/"+publication;

    if (!fso.FolderExists(publicationDir)) {
	// Make the directory for the publication package
	fso.CreateFolder(publicationDir);
	fso.CreateFolder(publicationDir+"/sys");

	mkPublicationXsl(publication, "publication_summary.xsl", "publication_summary.xml");

	//Make the publication_index file
	var publicationIndexXml = stepmodHome+"/publication/publication/"+publication+"/publication_index.xml";
	fso.CreateTextFile(publicationIndexXml, true );
	var f = fso.GetFile(publicationIndexXml);
	var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication_index SYSTEM \"../../dtd/publication_index.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.16 2003/08/19 06:35:47 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("           and supplied to NIST under contract");
	ts.WriteLine("  Purpose: A listing of modules to be published ");
	ts.WriteLine("           Note - to generate an ant build for this package, run:");
	ts.WriteLine("              ant -buildfile buildbuild.xml");
	ts.WriteLine("           This will create the build.xml file.");
	ts.WriteLine("           Then run: ");
	ts.WriteLine("              ant all");
	ts.WriteLine("           to create the HTML files of the individual modules");
	ts.WriteLine("");
	ts.WriteLine("     publication_index has the following attributes");
	ts.WriteLine("           name");
	ts.WriteLine("               The name of the publication set.");
	ts.WriteLine("           sc4.working_group");
	ts.WriteLine("               The SC4 working group. Either WG3 or WG12.");
	ts.WriteLine("           wg.number.publication_set ");
	ts.WriteLine("               The WG number for the publication set. ");
	ts.WriteLine("               It should be an integer. ");
	ts.WriteLine("           wg.number.publication_set_comment ");
	ts.WriteLine("               The WG number for the addressed ballot comments");
	ts.WriteLine("           date.iso_submission");
	ts.WriteLine("               The date the set of parts were submitted to ISO");
	ts.WriteLine("           date.iso_publication");
	ts.WriteLine("               The date the set of parts were published by ISO           ");
	ts.WriteLine("-->");

	ts.WriteLine("<publication_index");
	ts.WriteLine("  name=\""+publication+"\"");
	ts.WriteLine("  sc4.working_group=\"\"");
	ts.WriteLine("  wg.number.publication_set=\"\"");
	ts.WriteLine("  wg.number.publication_set_comment=\"\"");
	ts.WriteLine("  date.iso_submission=\"\"");
	ts.WriteLine("  date.iso_publication=\"\">");
	ts.WriteLine("");
	ts.WriteLine("  <description>");
	ts.WriteLine("  </description>");
	ts.WriteLine("");
	ts.WriteLine("  <contacts>");
	ts.WriteLine("    <projlead ref=\"xx\"/>");
	ts.WriteLine("    <editor ref=\"xx\"/>");
	ts.WriteLine("  </contacts>");
	ts.WriteLine("");
	ts.WriteLine("  <!-- The list of modules to be published as individual ISO parts -->");
	ts.WriteLine("  <modules>");
   	ts.WriteLine("    <module name=\"\"/>");
	ts.WriteLine("  </modules>");
	ts.WriteLine("");
	ts.WriteLine("  <!-- The list of resource documents to be published as individual ISO parts -->");
	ts.WriteLine("  <!-- Commented out as can not published modules, a resources and APs together ");
	ts.WriteLine("  <resource_docs>");
	ts.WriteLine("    <res_doc name=\"\"/>");
	ts.WriteLine("  </resource_docs>");
	ts.WriteLine("  -->");
	ts.WriteLine("");
	ts.WriteLine("  <!-- The list of application protocols to be published as individual ISO parts -->");
	ts.WriteLine("  <!-- NOTE - all modules used by AP will be included -->");
	ts.WriteLine("  <!-- Commented out as can not published modules, a resources and APs together ");
	ts.WriteLine("  <application_protocols>");
	ts.WriteLine("    <ap_doc name=\"\"/>");
	ts.WriteLine("  </application_protocols>");
	ts.WriteLine("  -->");
	ts.WriteLine("");
	ts.WriteLine("</publication_index>");
	ts.Close();

	// Make the ISO menu bar
	var menubarIsoXml = stepmodHome+"/publication/publication/"+publication+"/menubar_iso.xml";
	fso.CreateTextFile(menubarIsoXml, true );
	f = fso.GetFile(menubarIsoXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.16 2003/08/19 06:35:47 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A menubar providing links to the index of modules");
	ts.WriteLine("-->");

	ts.WriteLine("<menubar/>");
	ts.Close();


	// Make the buildbuild file
	var buildbuildXml = stepmodHome+"/publication/publication/"+publication+"/buildbuild.xml";
	fso.CreateTextFile(buildbuildXml, true );
	f = fso.GetFile(buildbuildXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.16 2003/08/19 06:35:47 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A bootstrap file used to create the main build");
	ts.WriteLine("           file for the publication package. Run:");
	ts.WriteLine("              ant -buildfile buildbuild.xml");
	ts.WriteLine("           This will  create the build.xml file.");
	ts.WriteLine("           Then run: ");
	ts.WriteLine("              ant all");
	ts.WriteLine("           to create the HTML version of the publication package");
	ts.WriteLine("-->");
	ts.WriteLine("<project name=\"buildbuild\" default=\"main\" basedir=\".\">");
	ts.WriteLine("   <target name=\"main\">");
	ts.WriteLine("     <dependset>");
	ts.WriteLine("       <srcfilelist dir=\".\" files=\"../../xsl/build.xsl\"/>");
	ts.WriteLine("       <targetfilelist dir=\".\" files=\"build.xml\"/>");
	ts.WriteLine("     </dependset>");
	ts.WriteLine("    <style in=\"publication_index.xml\" out=\"build.xml\" destdir=\".\" extension=\".xml\"");
	ts.WriteLine("      style=\"../../xsl/build.xsl\">");
	ts.WriteLine("    </style>");
	ts.WriteLine("   </target>");
	ts.WriteLine("</project>");
	ts.Close();

	// Make the readme file
	var readmetxt = stepmodHome+"/publication/publication/"+publication+"/readme.txt";
	fso.CreateTextFile(readmetxt, true );
	f = fso.GetFile(readmetxt);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("This directory contains files used to generate a package");
	ts.WriteLine("for distribution to ISO for publication.");
	ts.WriteLine("");
	ts.WriteLine("To build the publication package:");
	ts.WriteLine("");
	ts.WriteLine("1) Add the modules, resources documents and application protocols to be");
	ts.WriteLine("   published to: publication_index.xml      ");
	ts.WriteLine("   NOTE - you can not mix modules, resource documents and application");
	ts.WriteLine("   protocols in one publication package.");
	ts.WriteLine("");
	ts.WriteLine("2) Generate the ANT build file using ANT");
	ts.WriteLine("     ant -buildfile buildbuild.xml");
	ts.WriteLine("");
	ts.WriteLine("3) CVS tag the repository");
	ts.WriteLine("");
	ts.WriteLine("4) Run ANT on the build.xml that has just been created:");
	ts.WriteLine("     ant all");
	ts.WriteLine("   NOTE - this process will ask for the name of the CVS tag used in stage 3");
	ts.WriteLine("");
	ts.WriteLine("   This will create a directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication);
	ts.WriteLine("");
	ts.WriteLine("5) The HTML for each part to be published will be generated and stored in a");
	ts.WriteLine("   zip file in: ");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/zip/iso<part>.zip");
	ts.WriteLine("   where <part> is the ISO part number of the part being published.");
	ts.WriteLine("   These are the files to be sent to ISO");
	ts.WriteLine("   The complete directory:");
	ts.WriteLine("    stepmod/publication/isopub/"+publication);
	ts.WriteLine("   is also zipped to WG???.zip. This is the file to send to the convener for sign off");
	ts.WriteLine("");
	userMessage("Created: "+publicationDir);
    } else {
	ErrorMessage("The publication folder "+publicationDir+" already exists");
    }
}


function checkBallotPackageExists(ballot) {
    
}

function ouputAntProperty(moduleNodes, property, xml, buildts) {
    var members = moduleNodes.length;
    buildts.WriteLine("")
    buildts.WriteLine("    <property name=\""+property+"\" value=\"");
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	if (i == (members - 1)) {
	    buildts.WriteLine("data/modules/"+moduleName+"/"+xml+"\"/>");
	} else {
	    buildts.WriteLine("data/modules/"+moduleName+"/"+xml+",");
	}
    }
}

function outputAntBuild(ballot, buildfile) {
    var ballotIndexXml = stepmodHome + "/publication/publication/"
	+ballot+"/ballot_index.xml";
    userMessage("Loading: "+ballotIndexXml);
    
    userMessage("Writing: "+buildfile);
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile(buildfile, true );
    var f = fso.GetFile(buildfile);
    var buildts = f.OpenAsTextStream(ForWriting, TristateUseDefault);

    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(ballotIndexXml);
    var expr = "/ballot_index/ballot_package/module";
    var moduleNodes = objXML.selectNodes(expr);
    buildts.WriteLine("    <!-- ***************************************************** -->");
    ouputAntProperty(moduleNodes, "EXPRESS", "*.exp", buildts);
    ouputAntProperty(moduleNodes, "GIFS", "*.gif", buildts);
    ouputAntProperty(moduleNodes, "CONTENTSXML", "sys/contents.xml", buildts);
    ouputAntProperty(moduleNodes, "SCOPEXML", "sys/1_scope.xml", buildts);
    ouputAntProperty(moduleNodes, "REFSXML", "sys/2_refs.xml", buildts);
    ouputAntProperty(moduleNodes, "DEFSXML", "sys/3_defs.xml", buildts);
    ouputAntProperty(moduleNodes, "INFOREQSXML", "sys/4_info_reqs.xml", buildts);
    ouputAntProperty(moduleNodes, "MAINXML", "sys/5_main.xml", buildts);
    ouputAntProperty(moduleNodes, "MAPPINGXML", "sys/5_mapping.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMXML", "sys/5_mim.xml", buildts);
    ouputAntProperty(moduleNodes, "ASHORTNAMESXML", "sys/a_short_names.xml", buildts);
    ouputAntProperty(moduleNodes, "BOBJREGXML", "sys/b_obj_reg.xml", buildts);
    ouputAntProperty(moduleNodes, "BIBLIOXML", "sys/biblio.xml", buildts);
    ouputAntProperty(moduleNodes, "CARMEXPGXML", "sys/c_arm_expg.xml", buildts);
    ouputAntProperty(moduleNodes, "COVERXML", "sys/cover.xml", buildts);
    ouputAntProperty(moduleNodes, "DMIMEXPGXML", "sys/d_mim_expg.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPXML", "sys/e_exp.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPARMXML", "sys/e_exp_arm.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPMIMXML", "sys/e_exp_mim.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPMIMLFXML", "sys/e_exp_mim_lf.xml", buildts);
    ouputAntProperty(moduleNodes, "FGUIDEXML", "sys/f_guide.xml", buildts);
    ouputAntProperty(moduleNodes, "FOREWORDXML", "sys/foreword.xml", buildts);
    ouputAntProperty(moduleNodes, "INTRODUCTIONXML", "sys/introduction.xml", buildts);
    ouputAntProperty(moduleNodes, "ARMDESCRIPTIONSXML", "arm_descriptions.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMDESCRIPTIONSXML", "mim_descriptions.xml", buildts);
    ouputAntProperty(moduleNodes, "ARMEXPGXML", "armexpg*.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMEXPGXML", "mimexpg*.xml", buildts);

    ouputAntProperty(moduleNodes, "ARMEXPXML", "arm.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMEXPXML", "mim.xml", buildts);
    buildts.WriteLine("    <!-- ***************************************************** -->");
    buildts.Close();
    userMessage("Written: "+buildfile);
}


function outputModuleList(ballot) {
    var ballotIndexXml = stepmodHome + "/publication/publication/"
	+ballot+"/ballot_index.xml";
    userMessage("Loading: "+ballotIndexXml);
    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(ballotIndexXml);
    var expr = "/ballot_index/ballot_package/module";
    var moduleNodes = objXML.selectNodes(expr);
    var members = moduleNodes.length;
    userMessage("Making:"+members);
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	userMessage(moduleName);
    }

}


