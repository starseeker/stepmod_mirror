/********************************************************************************
/* MakeCMRecord                                                                 *
/*                                                                              *
/* Author: Gerald Radack                                                        *
/********************************************************************************/
import java.text.SimpleDateFormat;
import java.io.*;
import java.util.Date;
import javax.xml.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamResult; 
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import org.w3c.dom.*;

public class MakeCMRecord {
    File moduleRoot;
    File moduleXML;
    InputStream xsltStream;
    File cmRecordFile;
    String description;
    String release;
    String status;
    String releaseSequence;
    String edition;
    java.util.Date when;
    String who;

    Document document;
    TransformerFactory transFact;

    private static final String IDENTITY_XSLT =
        "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>"
	+ "<xsl:output method=\"xml\" indent=\"yes\" doctype-system=\"..\\..\\..\\dtd\\cm_record.dtd\"/>"
        + "<xsl:template match='/'>"
	+ "<xsl:copy-of select='.'/>"
        + "</xsl:template></xsl:stylesheet>";

    private static final String helpStr =
	"Usage:\n" +
	"\n" +
	"  java -classpath <cp> MakeCMRecord <directory> <cm_record>\n" +
	"\n" +
	"where:\n" +
	"\n" +
	"  <cp> is a classpath containing class MakeCMRecord\n" +
	"  <directory> is a path for the module top-level directory\n" +
	"  <cm_record> is the desired filename for the CM record\n" +
	"\n" +
	"The CM record will be placed in <directory>\n";

    public static final SimpleDateFormat cvsDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    public static final SimpleDateFormat cmrDateFormat = new SimpleDateFormat("EEE MMM d HH:mm:ss yyyy");
    public static final SimpleDateFormat isoDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public MakeCMRecord(String directory, String cmFileName, String description, String release, String status, String releaseSequence, String edition, java.util.Date when, String who) {
	// Make sure that the Saxon implementation of TransformerFactory is used.
	System.setProperty("javax.xml.transform.TransformerFactory","net.sf.saxon.TransformerFactoryImpl");
	moduleRoot = new File(directory);
	moduleXML = new File(moduleRoot, "module.xml");
	xsltStream = ClassLoader.getSystemResourceAsStream("cm-record.xsl");
	cmRecordFile = new File(moduleRoot, cmFileName);
	this.description = description;
	this.release = release;
	this.status = status;
	this.releaseSequence = releaseSequence;
	this.edition = edition;
	this.when = when;
	this.who = who;
    }

    public void transform() throws java.io.FileNotFoundException, java.io.IOException, javax.xml.transform.TransformerException {
	Node rootNode;
	Element sources;
	String whenStr;

	rootNode = transform(moduleXML, xsltStream);
	document = (Document) rootNode;
        NodeList cmReleaseList = document.getElementsByTagName("cm_release");
	for (int i=0; i<cmReleaseList.getLength(); i++) {
	    Element cmRelease = (Element) cmReleaseList.item(i);
	    cmRelease.setAttribute("description", description);
	    cmRelease.setAttribute("release", release);
	    cmRelease.setAttribute("status", status);
	    cmRelease.setAttribute("release_sequence", releaseSequence);
	    cmRelease.setAttribute("edition", edition);
	    whenStr = cmrDateFormat.format(when);
	    cmRelease.setAttribute("when", whenStr);
	    cmRelease.setAttribute("who", who);
	}
	NodeList sourcesList = document.getElementsByTagName("sources");
	sources = (Element) sourcesList.item(0);
	processDir(moduleRoot, moduleRoot, sources);
    }

    Node transform(File xmlFile, InputStream xsltStream) throws javax.xml.transform.TransformerException {
        javax.xml.transform.Source xmlSource =
                new javax.xml.transform.stream.StreamSource(xmlFile);
        javax.xml.transform.Source xsltSource =
                new javax.xml.transform.stream.StreamSource(xsltStream);
        javax.xml.transform.dom.DOMResult result =
                new javax.xml.transform.dom.DOMResult();
 
        // create an instance of TransformerFactory
        transFact = TransformerFactory.newInstance();
 
        Transformer trans = transFact.newTransformer(xsltSource);
	trans.setParameter("release", release);
        trans.transform(xmlSource, result);
	return result.getNode();
    }

    void processDir(File current, File root, Element sources) throws java.io.FileNotFoundException, java.io.IOException {
	File[] children = current.listFiles();
	String rootPath = root.getPath();
	String currentPath = current.getPath();
	String relativePath;
	Element element;
	Element childElt;

	if (currentPath.equals(rootPath)) {
	    relativePath = ".";
	}
	else {
	    if (currentPath.startsWith(rootPath + "\\")) {
		relativePath = currentPath.substring(rootPath.length()+1);
	    }
	    else {
		relativePath = "*ERROR*";
	    }
	}
	element = document.createElement("directory");
	element.setAttribute("name",relativePath);
	sources.appendChild(element);
	for (int i=0; i<children.length; i++) {
	    File child = children[i];
	    if (child.isDirectory() && !(child.getName().equals("CVS"))) {
		processDir(child, root, sources);
	    }
	    if (child.isFile() && !child.getName().equals("cm_record.xml")) {
		processFile(child, element);
	    }
	}
    }

    void processFile(File current, Element dirElt) throws java.io.FileNotFoundException, java.io.IOException {
	Element element;
	Metadata metadata;

	metadata = getMetadata(current);

	element = document.createElement("file");
	element.setAttribute("name", current.getName());

	if (metadata.date != null) {
	    element.setAttribute("cvs_date", metadata.date);
	}
	else {
	    element.setAttribute("cvs_date", "*** FILL IN ***");
	    System.err.println("Date not found in file " + current.getPath() + ".");
	}

	if (metadata.revision != null) {
	    element.setAttribute("cvs_revision", metadata.revision);
	}
	else {
	    element.setAttribute("cvs_revision", "*** FILL IN ***");
	    System.err.println("Revision not found in file " + current.getPath() + ".");
	}

	dirElt.appendChild(element);
    }

    Metadata getMetadata(File file) throws java.io.FileNotFoundException, java.io.IOException {
	BufferedReader reader = new BufferedReader(new FileReader(file));
	String line;
	String idStr = "";
	Metadata metadata = new Metadata();

	while ((line = reader.readLine()) != null) {
	    if (line.contains("$Id:")) {
		String[] comp = line.split("\\$");
		for (int i=0; i<comp.length; i++) {
		    if (comp[i].startsWith("Id:")) {
			idStr = comp[i].substring(3).trim();
			metadata.revision = getCvsRevision(idStr);
			metadata.date = fixDate(getCvsDate(idStr));
		    }
		}
	    }
	    if (line.contains("$Date:")) {
		String[] comp = line.split("\\$");
		for (int i=0; i<comp.length; i++) {
		    if (comp[i].startsWith("Date:")) {
			metadata.date = fixDate(comp[i].substring(5).trim());
		    }
		}
	    }
	    if (line.contains("$Revision:")) {
		String[] comp = line.split("\\$");
		for (int i=0; i<comp.length; i++) {
		    if (comp[i].startsWith("Revision:")) {
			metadata.revision = comp[i].substring(9).trim();
		    }
		}
	    }
	}
	return metadata;
    }

    String getCvsRevision(String idStr) {
	String[] comp = idStr.split(" ");
	if (comp.length >= 2) {
	    return comp[1];
	}
	else {
	    return null;
	}
    }

    String getCvsDate(String idStr) {
	String[] comp = idStr.split(" ");
	if (comp.length >= 4) {
	    return comp[2] + " " + comp[3];
	}
	else {
	    return null;
	}
    }

   String fixDate(String inDate) {
       if (inDate == null) {
	   return null;
       }
       else {
	   try {
	       Date date = cvsDateFormat.parse(inDate);
	       String str = cmrDateFormat.format(date);
	       return str;
	   }
	   catch (java.text.ParseException e) {
	       System.err.println("Error: Unable to parse " + inDate + " as a date.");
	       return null;
	   }
       }
   }

    void write() throws javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException {
	javax.xml.transform.dom.DOMSource source = new DOMSource(document);
	StreamResult result = new StreamResult(cmRecordFile);
        javax.xml.transform.Source xsltSource = new javax.xml.transform.stream.StreamSource(
                new StringReader(IDENTITY_XSLT));
	Transformer transformer = transFact.newTransformer(xsltSource);
	transformer.transform(source, result);
    }

    /*
    public static void main(String[] arg) {
	try {
	    if (arg.length != 2) {
		System.err.print(helpStr);
	    }
	    else {
		MakeCMRecord cmr = new MakeCMRecord(arg[0], arg[1]);
		cmr.transform();
		cmr.write();
	    }
	}
	catch (Exception e) {
	    e.printStackTrace();
	}
    }
    */
}

class Metadata {
    String date;
    String revision;
}
