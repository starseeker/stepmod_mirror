//$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:  JScript to generate a ballot package
//            NOTE THIS IS UNDER DEVELOPMENT


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
// to ballot_index.xml
function mkBallotXsl(ballot,xsl,xml) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var ballotXml = stepmodHome+"/ballots/ballots/"+ballot+"/"+xml;
    fso.CreateTextFile(ballotXml, true);
    var f = fso.GetFile(ballotXml);

    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!DOCTYPE ballot SYSTEM \"../../dtd/ballot_xsl_appl.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../xsl/"+xsl+"\" ?>");

    ts.WriteLine("<!-- ");
    ts.WriteLine("$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $");
    ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
    ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
    ts.WriteLine("  Purpose: A grouping of modules into ballot packages");
    ts.WriteLine("-->");
    ts.WriteLine("<ballot directory=\""+ballot+"\"/>");
    ts.Close();
}

function mkBallotPackage(ballot) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;

    var ballotDir = stepmodHome + "/ballots/ballots/"+ballot;

    if (!fso.FolderExists(ballotDir)) {
	// Make the directory for the ballot package
	fso.CreateFolder(ballotDir);
	
	//Make the ballot_index file
	var ballotIndexXml = stepmodHome+"/ballots/ballots/"+ballot+"/ballot_index.xml";
	fso.CreateTextFile(ballotIndexXml, true );
	var f = fso.GetFile(ballotIndexXml);
	var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE ballot_index SYSTEM \"../../dtd/ballot_index.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A grouping of modules into ballot packages");
	ts.WriteLine("           Note - to generate an ant build for this package, run:");
	ts.WriteLine("              ant -buildfile buildbuild.xml");
	ts.WriteLine("           This will create the build.xml file.");
	ts.WriteLine("           Then run: ");
	ts.WriteLine("              ant all");
	ts.WriteLine("           to create the HTML version of the ballot package");

	ts.WriteLine("-->");


	ts.WriteLine("<ballot_index");
	ts.WriteLine("  name=\""+ballot+"\"");
	ts.WriteLine("  wg.number.ballot_package=\"\"");
	ts.WriteLine("  wg.number.ballot_comment=\"\"");
	ts.WriteLine("  proposed.submission.date=\"\"");
	ts.WriteLine("  ballot.start.date=\"\"");
	ts.WriteLine("  ballot.close.date=\"\"");
	ts.WriteLine("  comments.resolved.date=\"\"");
	ts.WriteLine("  ballot.complete=\"\">");
	ts.WriteLine("");
	ts.WriteLine("  <description>");
	ts.WriteLine("  </description>");
	ts.WriteLine("");
	ts.WriteLine("  <contacts>");
	ts.WriteLine("    <projlead ref=\"xx\"/>");
	ts.WriteLine("    <editor ref=\"xx\"/>");
	ts.WriteLine("  </contacts>");
	ts.WriteLine("");
	ts.WriteLine("  <ballot_package name=\"\">");
	ts.WriteLine("    <description>");
	ts.WriteLine("    </description>");
   	ts.WriteLine("    <module name=\"\"/>");
	ts.WriteLine("  </ballot_package>");
	ts.WriteLine("</ballot_index>");
	ts.Close();
	mkBallotXsl(ballot,"ballot_checklist.xsl","ballot_checklist.xml");
	mkBallotXsl(ballot,"ballot_list.xsl","ballot_list.xml");
	mkBallotXsl(ballot,"ballot_shortnames.xsl","ballot_shortnames.xml");
	mkBallotXsl(ballot,"ballot_summary.xsl","ballot_summary.xml");
	mkBallotXsl(ballot,"ballot_start.xsl","start.xml");

	// Make the menu bar
	var menubarXml = stepmodHome+"/ballots/ballots/"+ballot+"/menubar_ballot.xml";
	fso.CreateTextFile(menubarXml, true );
	f = fso.GetFile(menubarXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A menubar for packages");
	ts.WriteLine("-->");

	ts.WriteLine("<menubar>");
	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\"Module index\"");
	ts.WriteLine("    relative.url=\"../../../repository_index.xml\">");
	ts.WriteLine("  </menuitem>");
	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\"Ballot home\"");
	ts.WriteLine("    relative.url=\"../../../ballots/index.xml\">");
	ts.WriteLine("  </menuitem>");
	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\""+ballot+" Ballot home\"");
	ts.WriteLine("    relative.url=\"../../../ballots/ballots/"+ballot+"/start.xml\">");
	ts.WriteLine("  </menuitem>");

	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\""+ballot+" Ballot list\"");
	ts.WriteLine("    relative.url=\"../../../ballots/ballots/"+ballot+"/ballot_list.xml\">");
	ts.WriteLine("  </menuitem>");

	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\""+ballot+" Ballot  checklist\"");
	ts.WriteLine("    relative.url=\"../../../ballots/ballots/"+ballot+"/ballot_checklist.xml\">");
	ts.WriteLine("  </menuitem>");

	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\""+ballot+" ISO summary \"");
	ts.WriteLine("    relative.url=\"../../../ballots/ballots/"+ballot+"/ballot_summary.xml\">");
	ts.WriteLine("  </menuitem>");

	ts.WriteLine("</menubar>");
	ts.Close();


	// Make the ISO menu bar
	var menubarIsoXml = stepmodHome+"/ballots/ballots/"+ballot+"/menubar_iso.xml";
	fso.CreateTextFile(menubarIsoXml, true );
	f = fso.GetFile(menubarIsoXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A menubar providing links to the index of modules");
	ts.WriteLine("-->");

	ts.WriteLine("<menubar>");
	ts.WriteLine("  <menuitem");
	ts.WriteLine("    item=\"Module index\"");
	ts.WriteLine("    relative.url=\"../../../module_index.xml\">");
	ts.WriteLine("  </menuitem>");
	ts.WriteLine("</menubar>");
	ts.Close();


	// Make the buidbuild file
	var buildbuildXml = stepmodHome+"/ballots/ballots/"+ballot+"/buildbuild.xml";
	fso.CreateTextFile(buildbuildXml, true );
	f = fso.GetFile(buildbuildXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkballot_main.js,v 1.7 2002/12/02 08:02:33 robbod Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A bootstrap file used to create the main build");
	ts.WriteLine("           file for the ballot package. Run:");
	ts.WriteLine("              ant -buildfile buildbuild.xml");
	ts.WriteLine("           This will create the build.xml file.");
	ts.WriteLine("           Then run: ");
	ts.WriteLine("              ant all");
	ts.WriteLine("           to create the HTML version of the ballot package");
	ts.WriteLine("-->");
	ts.WriteLine("<project name=\"buildbuild\" default="main" basedir=\".\">");
	ts.WriteLine("   <target name=\"main\">");
	ts.WriteLine("     <dependset>");
	ts.WriteLine("       <srcfilelist dir=\".\" files=\"../../xsl/build.xsl\"/>");
	ts.WriteLine("       <targetfilelist dir=\".\" files=\"build.xml\"/>");
	ts.WriteLine("     </dependset>");
	ts.WriteLine("    <style in=\"ballot_index.xml\" out=\"build.xml\" destdir=\".\" extension=\".xml\"");
	ts.WriteLine("      style=\"../../xsl/build.xsl\">");
	ts.WriteLine("    </style>");
	ts.WriteLine("   </target>");
	ts.WriteLine("</project>");
	ts.Close();

	// Make the readme file
	var readmetxt = stepmodHome+"/ballots/ballots/"+ballot+"/readme.txt";
	fso.CreateTextFile(readmetxt, true );
	f = fso.GetFile(readmetxt);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("This directory contains files used to generate an package");
	ts.WriteLine("for distribution to SC4 for balloting.");
	ts.WriteLine("");
	ts.WriteLine("1) Add the modules to be balloted to ballot_index.xml");
	ts.WriteLine("");
	ts.WriteLine("2) Generate the build file using ANT");
	ts.WriteLine("     ant -buildfile buildbuild");
	ts.WriteLine("");
	ts.WriteLine("3) Run ANT on the build.xml that has just been created:");
	ts.WriteLine("     ant all");
	ts.WriteLine("");
	ts.WriteLine("   This will create a directory:");
	ts.WriteLine("     stepmod/ballots/isohtml/"+ballot);
	ts.WriteLine("");
	ts.WriteLine("4) Create a zip file of the ballot package.");
	ts.WriteLine("    ant zip");
	ts.WriteLine("");
	ts.WriteLine("   This will create a zip file:");
	ts.WriteLine("     stepmod/ballots/isohtml/"+ballot+"/"+ballot+"xxxx.zip");
	ts.Close();

	userMessage("Created: "+ballotDir);
    } else {
	ErrorMessage("The ballot folder "+ballotDir+" already exists");
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
    var ballotIndexXml = stepmodHome + "/ballots/ballots/"
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
    var ballotIndexXml = stepmodHome + "/ballots/ballots/"
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


//outputAntBuild("pdm_ballot_072002", "ballot_build.xml");
//outputModuleList("pdm_ballot_072002");
//mkBallotPackage("test");
