//$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep 
//  Purpose:  JScript to generate a Part 1000 publication package



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
    var publicationXml = stepmodHome+"/publication/publication_p1000/"+publication+"/sys/"+xml;
    fso.CreateTextFile(publicationXml, true);
    var f = fso.GetFile(publicationXml);

    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/"+xsl+"\" ?>");

    ts.WriteLine("<!-- ");
    ts.WriteLine("$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $");
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

    var publicationDir = stepmodHome + "/publication/publication_p1000/"+publication;

    if (!fso.FolderExists(publicationDir)) {
	// Make the directory for the publication package
	fso.CreateFolder(publicationDir);
	fso.CreateFolder(publicationDir+"/sys");

	mkPublicationXsl(publication, "publication_summary.xsl", "publication_summary.xml");

	//Make the publication_index file
	var publicationIndexXml = stepmodHome+"/publication/publication_p1000/"+publication+"/publication_index.xml";
	fso.CreateTextFile(publicationIndexXml, true );
	var f = fso.GetFile(publicationIndexXml);
	var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication_index SYSTEM \"../../dtd/publication_index.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $");
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
	ts.WriteLine("           wg.number.publication_set ");
	ts.WriteLine("               The WG number for the publication set. ");
	ts.WriteLine("               It should be an integer. ");
	ts.WriteLine("           wg.number.publication_set_comments ");
	ts.WriteLine("               The WG number for the addressed ballot comments");
	ts.WriteLine("           date.iso_submission");
	ts.WriteLine("               The date the set of parts were submitted to ISO");
	ts.WriteLine("           date.iso_publication");
	ts.WriteLine("               The date the set of parts were published by ISO           ");
	ts.WriteLine("-->");

	ts.WriteLine("<part1000.publication_index");
	ts.WriteLine("  name=\""+publication+"\"");
	ts.WriteLine("  wg.number.publication_set=\"\"");
	ts.WriteLine("  wg.number.publication_set_comments=\"\"");
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
	ts.WriteLine("</part1000.publication_index>");
	ts.Close();

	// Make the ISO menu bar
	var menubarIsoXml = stepmodHome+"/publication/publication_p1000/"+publication+"/menubar_iso.xml";
	fso.CreateTextFile(menubarIsoXml, true );
	f = fso.GetFile(menubarIsoXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $");
	ts.WriteLine("  Author:  Rob Bodington, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A menubar providing links to the index of modules");
	ts.WriteLine("-->");

	ts.WriteLine("<menubar/>");
	ts.Close();


	// Make the normref-check
	var normrefXml = stepmodHome+"/publication/publication_p1000/"+publication+"/sys/normref_check.xml";
	fso.CreateTextFile(normrefXml, true );
	f = fso.GetFile(normrefXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/pub_ballot/normref_check.xsl\" ?>");
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $");
  	ts.WriteLine("Author:  Rob Bodington, Eurostep Limited");
  	ts.WriteLine("Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("Purpose: Display summary of normative references");
	ts.WriteLine("-->");
	ts.WriteLine("<publication directory=\""+publication+"\"/>");

	ts.Close();


	// Make the buildbuild file
	var buildbuildXml = stepmodHome+"/publication/publication_p1000/"+publication+"/buildbuild.xml";
	fso.CreateTextFile(buildbuildXml, true );
	f = fso.GetFile(buildbuildXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: mkpublication_main.js,v 1.6 2005/04/01 21:01:33 thendrix Exp $");
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
	ts.WriteLine("       <srcfilelist dir=\".\" files=\"../../xsl/build_part1000.xsl\"/>");
	ts.WriteLine("       <targetfilelist dir=\".\" files=\"build.xml\"/>");
	ts.WriteLine("     </dependset>");
	ts.WriteLine("    <style in=\"publication_index.xml\" out=\"build.xml\" destdir=\".\" extension=\".xml\"");
	ts.WriteLine("      style=\"../../xsl/build_part1000.xsl\">");
	ts.WriteLine("    </style>");
	ts.WriteLine("   </target>");
	ts.WriteLine("</project>");
	ts.Close();

	// Make the readme file
	var readmetxt = stepmodHome+"/publication/publication_p1000/"+publication+"/readme.txt";
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



