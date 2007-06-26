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

import net.sf.saxon.FeatureKeys;
import net.sf.saxon.trace.XSLTTraceListener;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import org.w3c.dom.*;

public class MakeCMRecord {
    String moduleName;
    File moduleDir;
    File moduleXMLFile;
    InputStream xsltStream;
    File cmRecordFile;
    String description;
    String release;
    String stepmodRelease;
    String status;
    String releaseSequence;
    String edition;
    java.util.Date when;
    String who;
    boolean recordExists;

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

    static Logger logger = Logger.getLogger("MakeCMRecord");

    public MakeCMRecord(File moduleDir, String cmFileName, String description, String release, String stepmodRelease, String status, String releaseSequence, String edition, java.util.Date when, String who) throws InvalidModuleDirException {
	this.moduleDir = moduleDir;
	String path = "";
	try {
	    path = moduleDir.getCanonicalPath();
	}
	catch (java.io.IOException e) {
	    e.printStackTrace();
	    logger.info("Invalid module directory " + path);
	    throw new InvalidModuleDirException();
	}
	System.setProperty("user.dir", path);
	moduleXMLFile = new File(moduleDir, "module.xml");
	xsltStream = ClassLoader.getSystemResourceAsStream("cm-record.xsl");
	cmRecordFile = new File(moduleDir, cmFileName);
	this.description = description;
	this.release = release;
	this.stepmodRelease = stepmodRelease;
	this.status = status;
	this.releaseSequence = releaseSequence;
	this.edition = edition;
	this.when = when;
	this.who = who;
	File cmRecordFile = new File(moduleDir, "cm_record.xml");
	recordExists = cmRecordFile.exists();
	if (recordExists) {
	    System.err.println("Updating existing CM record.");
	}
    }

    public void generateCM() throws java.io.FileNotFoundException, java.io.IOException, javax.xml.transform.TransformerException, ConnectionException, InternalErrorException {
	Node rootNode;
	Element sources;

	try {
	    rootNode = transform(moduleXMLFile, xsltStream);
	    document = (Document) rootNode;
	    NodeList sourcesList = document.getElementsByTagName("sources");
	    for (int i=0; i<sourcesList.getLength(); i++) {
		sources = (Element) sourcesList.item(i);
		if (sources.getTextContent().trim().equals("*** INSERT DIRECTORY ELEMENTS ***")) {
		    NodeList childList = sources.getChildNodes();
		    for (int j=0; j<childList.getLength(); j++) {
			sources.removeChild(childList.item(j));
		    }
		    processDir(moduleDir, moduleDir, sources);
		}
	    }
	    write();
	}
	catch (FileNotUpToDateException e) {
	    File file = e.getFile();
	    System.err.println("Error: File " + file.getAbsolutePath() + " is not up-to-date.  Not writing CM record for directory " + moduleDir.getName());
	}
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
	// XSLTTraceListener traceListener = new XSLTTraceListener();
	// transFact.setAttribute(FeatureKeys.TRACE_LISTENER, traceListener);
 
	String whenStr = cmrDateFormat.format(when);
	String recordExistsStr = "false";
	if (recordExists) {
	    recordExistsStr = "true";
	}

        Transformer trans = transFact.newTransformer(xsltSource);
	trans.setParameter("release", release);
	trans.setParameter("stepmod_release", stepmodRelease);
	trans.setParameter("release_sequence", releaseSequence);
	trans.setParameter("edition", edition);
	trans.setParameter("who", who);
	trans.setParameter("when", whenStr);
	trans.setParameter("description", description);
	trans.setParameter("status", status);
	trans.setParameter("record_exists", recordExistsStr);

        trans.transform(xmlSource, result);
	return result.getNode();
    }

    void processDir(File current, File root, Element sources) throws java.io.FileNotFoundException, java.io.IOException, FileNotUpToDateException, ConnectionException, InternalErrorException {
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

    void processFile(File current, Element dirElt) throws java.io.FileNotFoundException, java.io.IOException, FileNotUpToDateException, ConnectionException, InternalErrorException {
	Element element;
	Metadata metadata;

	System.err.println(current.getAbsoluteFile());
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

    Metadata getMetadata(File file) throws java.io.FileNotFoundException, java.io.IOException, FileNotUpToDateException, ConnectionException, InternalErrorException {
	Metadata metadata = new Metadata();
	Runtime runtime = Runtime.getRuntime();
	String[] cmdarray = new String[3];
	Process process;
	String line;
	Capturer1 capturer1;
	Capturer2 capturer2;
	ErrorCapturer errorCapturer;
	int exitVal;

	cmdarray[0] = "cvs";
	cmdarray[1] = "status";
	cmdarray[2] = file.getName();
	process = runtime.exec(cmdarray, null, file.getParentFile());
	capturer1 = new Capturer1(process.getInputStream());
	capturer1.start();
	errorCapturer = new ErrorCapturer(process.getErrorStream());
	errorCapturer.start();
	try {
	    exitVal = process.waitFor();
	}
	catch (java.lang.InterruptedException e) {
	    e.printStackTrace();
	    throw new InternalErrorException("Interrupted exception");
	}
	logger.debug("status command exited with code = " + exitVal);
	if (!capturer1.cvsStatus.equals("Up-to-date")) {
	    logger.info("File " + file.getAbsolutePath() + " is not up-to-date.");
	    throw new FileNotUpToDateException(file);
	}

	if (capturer1.workingRevision.length() > 0) {
	    metadata.revision = capturer1.workingRevision;
	}
	else {
	    logger.error("Working revision not found.");
	    throw new InternalErrorException("Could not find working revision.");
	}

	cmdarray[0] = "cvs";
	cmdarray[1] = "log";
	cmdarray[2] = file.getName();
	process  = runtime.exec(cmdarray, null, file.getParentFile());
	capturer2 = new Capturer2(process.getInputStream(), metadata.revision);
	capturer2.start();
	errorCapturer = new ErrorCapturer(process.getErrorStream());
	errorCapturer.start();
	try {
	    exitVal = process.waitFor();
	}
	catch (java.lang.InterruptedException e) {
	    e.printStackTrace();
	    throw new InternalErrorException("Interrupted exception");
	}	
	logger.debug("status command exited with code = " + exitVal);

	metadata.date = fixDate(capturer2.cvsDate);
	logger.debug("metadata.revision = " + metadata.revision);
	logger.debug("metadata.date = " + metadata.date);

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
    static {
	// Make sure that the Saxon implementation of TransformerFactory is used.
	System.setProperty("javax.xml.transform.TransformerFactory","net.sf.saxon.TransformerFactoryImpl");
    }
}

class Metadata {
    String date;
    String revision;
}
