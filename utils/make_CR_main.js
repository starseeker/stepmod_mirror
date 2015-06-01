//$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $
//  Author: Mike Ward, Eurostep Limited
//  Owner:  Developed by Eurostep
//  Purpose:  JScript to generate a change request



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
    var publicationXml = stepmodHome+"/publication/part1000/"+publication+"/sys/"+xml;
    fso.CreateTextFile(publicationXml, true);
    var f = fso.GetFile(publicationXml);

    var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
    ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
    ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/"+xsl+"\" ?>");

    ts.WriteLine("<!-- ");
    ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
    ts.WriteLine("  Author:  Mike Ward, Eurostep Limited");
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
    var cvsTag = publication;
    var publicationDir = stepmodHome + "/publication/part1000/"+publication;

    if (!fso.FolderExists(publicationDir)) {
	// Make the directory for the publication package
	fso.CreateFolder(publicationDir);
	fso.CreateFolder(publicationDir+"/sys");

	mkPublicationXsl(publication, "CR_publication_summary.xsl", "publication_summary.xml");

	//Make the publication_index file
	var publicationIndexXml = stepmodHome+"/publication/part1000/"+publication+"/publication_index.xml";
	fso.CreateTextFile(publicationIndexXml, true );
	var f = fso.GetFile(publicationIndexXml);
	var ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE part1000.publication_index SYSTEM \"../../dtd/p1000_publication_index.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
	ts.WriteLine("  Author:  Mike Ward, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A listing of modules and/or resource documents and/or business object models to be published as a Part 1000 change request");
	ts.WriteLine("           Note - to generate an ant build for this package, run:");
	ts.WriteLine("              ant -buildfile buildbuild.xml");
	ts.WriteLine("           This will create the build.xml file.");
	ts.WriteLine("           Then run: ");
	ts.WriteLine("              ant all");
	ts.WriteLine("           to create the HTML files of the individual modules, resources, or boms");
	ts.WriteLine("           See: readme.txt for details");
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
	ts.WriteLine("               The date the set of parts were published by ISO");
        ts.WriteLine("           sc4.working_group");
        ts.WriteLine("               The WG number for the SC4 working_group");
        ts.WriteLine("-->");

	ts.WriteLine("<part1000.publication_index");
	ts.WriteLine("  name=\""+publication+"\"");
	ts.WriteLine("  wg.number.publication_set=\"\"");
	ts.WriteLine("  wg.number.publication_set_comments=\"\"");
	ts.WriteLine("  date.iso_submission=\"\"");
	ts.WriteLine("  sc4.working_group=\"\"");

	dt = new Date();   //Gets today's date right now (to the millisecond).
	iso_publication = dt.getFullYear()+'-99-'+publication.substring(publication.length-2, publication.length);

	ts.WriteLine("  date.iso_publication=\""+iso_publication+"\">");
	ts.WriteLine("");
	ts.WriteLine("  <description>");
	ts.WriteLine("    The modules and/or resources and/or BO Models that are to be added to Part1000 as part of ");
	ts.WriteLine("    change request "+publication);
	ts.WriteLine("    ");
	ts.WriteLine("    The STEPmod CVS repository should be tagged as: "+cvsTag);
	ts.WriteLine("    before submitting the change request");
	ts.WriteLine("  </description>");
	ts.WriteLine("");
	ts.WriteLine("  <contacts>");
	ts.WriteLine("    <projlead ref=\"xx\"/>");
	ts.WriteLine("    <editor ref=\"xx\"/>");
	ts.WriteLine("  </contacts>");
	ts.WriteLine("");
	ts.WriteLine("  <!-- The list of modules, resources, or bo models to be included in a change request -->");
	ts.WriteLine("  <!-- Only add each item once -->");
	ts.WriteLine("  <modules>");
  	ts.WriteLine("    <!-- START: AP203 modules -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap203\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
  	ts.WriteLine("    <!-- END: AP203 modules -->");
	ts.WriteLine("");
  	ts.WriteLine("    <!-- START: AP209 modules -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap209\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
  	ts.WriteLine("    <!-- END: AP09 modules -->");
	ts.WriteLine("");
  	ts.WriteLine("    <!-- START: AP210 modules -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap210\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
  	ts.WriteLine("    <!-- END: AP210 modules -->");
	ts.WriteLine("");
  	ts.WriteLine("    <!-- START: AP233 modules -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap233\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
	ts.WriteLine("");
  	ts.WriteLine("    <!-- START: AP236 modules -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap236\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
  	ts.WriteLine("    <!-- END: AP236 modules -->");
	ts.WriteLine("");
  	ts.WriteLine("    <!-- START: AP239 modules  -->");
  	ts.WriteLine("    <!-- <module name=\"\" team=\"ap239\" version=\"\" arm.change=\"n\" mim.change=\"n\"/> -->");
  	ts.WriteLine("    <!-- END: AP239 specific modules -->");
	ts.WriteLine("");
	ts.WriteLine("  </modules>");
	ts.WriteLine("");
	ts.WriteLine("</part1000.publication_index>");
	ts.Close();


	// Make the ISO menu bar
	var menubarIsoXml = stepmodHome+"/publication/part1000/"+publication+"/menubar_iso.xml";
	fso.CreateTextFile(menubarIsoXml, true );
	f = fso.GetFile(menubarIsoXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
	ts.WriteLine("  Author:  Mike Ward, Eurostep Limited");
	ts.WriteLine("  Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("  Purpose: A menubar providing links to the index of modules, resources, or boms");
	ts.WriteLine("-->");

	ts.WriteLine("<menubar/>");
	ts.Close();


	// Make the normref-check
	var normrefXml = stepmodHome+"/publication/part1000/"+publication+"/sys/normref_check.xml";
	fso.CreateTextFile(normrefXml, true );
	f = fso.GetFile(normrefXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/pub_ballot/normref_check.xsl\" ?>");
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
  	ts.WriteLine("Author:  Mike Ward, Eurostep Limited");
  	ts.WriteLine("Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("Purpose: Display summary of normative references");
	ts.WriteLine("-->");
	ts.WriteLine("<publication directory=\""+publication+"\"/>");
	ts.Close();


	// Make the biblio-check
	var biblioXml = stepmodHome+"/publication/part1000/"+publication+"/sys/bibliography_check.xml";
	fso.CreateTextFile(biblioXml, true );
	f = fso.GetFile(biblioXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/pub_ballot/bibliography_check.xsl\" ?>");
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
  	ts.WriteLine("Author:  Mike Ward, Eurostep Limited");
  	ts.WriteLine("Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("Purpose: Display summary of bibliography");
	ts.WriteLine("-->");
	ts.WriteLine("<publication directory=\""+publication+"\"/>");
	ts.Close();


	// Make the biblio-check
	var biblioXml = stepmodHome+"/publication/part1000/"+publication+"/sys/modules_check.xml";
	fso.CreateTextFile(biblioXml, true );
	f = fso.GetFile(biblioXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../../xsl/pub_ballot/modules_check.xsl\" ?>");
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
  	ts.WriteLine("Author:  Mike Ward, Eurostep Limited");
  	ts.WriteLine("Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("Purpose: Display summary of modules");
	ts.WriteLine("-->");
	ts.WriteLine("<publication directory=\""+publication+"\"/>");
	ts.Close();

	// Make the wgn_check
	var biblioXml = stepmodHome+"/publication/part1000/"+publication+"/sys/wgn_summary.xml";
	fso.CreateTextFile(biblioXml, true );
	f = fso.GetFile(biblioXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE publication SYSTEM \"../../../dtd/publication_xsl_appl.dtd\">");
	ts.WriteLine("<?xml-stylesheet type=\"text/xsl\" href=\"../../../xsl/wgn_summary.xsl\" ?>");
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
  	ts.WriteLine("Author:  Mike Ward, Eurostep Limited");
  	ts.WriteLine("Owner:   Developed by Eurostep Limited http://www.eurostep.com");
	ts.WriteLine("Purpose: Display wg summary");
	ts.WriteLine("-->");
	ts.WriteLine("<publication directory=\""+publication+"\"/>");
	ts.Close();


	// Make the buildbuild file
	var buildbuildXml = stepmodHome+"/publication/part1000/"+publication+"/buildbuild.xml";
	fso.CreateTextFile(buildbuildXml, true );
	f = fso.GetFile(buildbuildXml);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	ts.WriteLine("<!DOCTYPE menubar SYSTEM \"../../../dtd/menubar.dtd\">");
	
	ts.WriteLine("<!-- ");
	ts.WriteLine("$Id: make_CR_main.js,v 1.2 2014/06/16 12:24:03 mikeward Exp $");
	ts.WriteLine("  Author:  Mike Ward, Eurostep Limited");
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
	ts.WriteLine("       <srcfilelist dir=\".\" files=\"../../xsl/build_CR.xsl\"/>");
	ts.WriteLine("       <targetfilelist dir=\".\" files=\"build.xml\"/>");
	ts.WriteLine("     </dependset>");
	ts.WriteLine("    <style in=\"publication_index.xml\" out=\"build.xml\" destdir=\".\" extension=\".xml\"");
	ts.WriteLine("      style=\"../../xsl/build_CR.xsl\">");
	ts.WriteLine("    </style>");
	ts.WriteLine("   </target>");
	ts.WriteLine("</project>");
	ts.Close();

	// Make the readme file
	var readmetxt = stepmodHome+"/publication/part1000/"+publication+"/readme.txt";
	fso.CreateTextFile(readmetxt, true );
	f = fso.GetFile(readmetxt);
	ts = f.OpenAsTextStream(ForWriting, TristateUseDefault);
	ts.WriteLine("This directory contains files used to generate a Part 1000 change request package");
	ts.WriteLine("");
	ts.WriteLine("To build the change request package:");
	ts.WriteLine("");
	ts.WriteLine("1) Add the modules, resources, or bo models to be published to: publication_index.xml ");
	ts.WriteLine("");
	ts.WriteLine("2) Generate the ANT build file using ANT");
	ts.WriteLine("     ant -buildfile buildbuild.xml");
	ts.WriteLine("");
	ts.WriteLine("3) CVS tag the repository using "+cvsTag+" as the tag");
	ts.WriteLine("");
	ts.WriteLine("4) Run ANT on the build.xml that has just been created:");
	ts.WriteLine("     ant all");
	ts.WriteLine("   NOTE - this process will ask for the name of the CVS tag used in stage 3");
	ts.WriteLine("");
	ts.WriteLine("   This will create a directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication);
	ts.WriteLine("");
	ts.WriteLine("5) The HTML for each part to be published will be generated and stored in ");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/part1000");
	ts.WriteLine("   The directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/part1000/data/modules");
	ts.WriteLine("     contains the modules");
	ts.WriteLine("   The directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/part1000/data/resources");
	ts.WriteLine("     contains the integrated resources schemas referenced by the modules");
	ts.WriteLine("   The directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/part1000/express");
	ts.WriteLine("     contains the EXPRESS for all the modules and integrated resources schemas.");
	ts.WriteLine("   The complete directory:");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/part1000");
	ts.WriteLine("   is added to the zip file: ");
	ts.WriteLine("     stepmod/publication/isopub/"+publication+"/"+publication+"<YYYYMMDD>.zip");
	ts.WriteLine("   where <YYYMMDD> is the date of the build.");
	ts.WriteLine("   The zip file is to be sent to the modules validation team for sign off");
	ts.WriteLine("");
	ts.WriteLine("");
	ts.WriteLine("To merge the change request into Part1000");
	ts.WriteLine("1) Check out part1000 to the same directory that contains stepmod");
	ts.WriteLine("2) Run ANT on the build.xml that has been created in 2) above:");
	ts.WriteLine("     ant mergePart1000");
	userMessage("Created: "+publicationDir);
    } else {
	ErrorMessage("The publication folder "+publicationDir+" already exists");
    }
}



