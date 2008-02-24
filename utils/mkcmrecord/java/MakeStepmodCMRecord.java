
/********************************************************************************
/* MakeStepmodCMRecord                                                                 *
/*                                                                              *
/* Author: Gerald Radack                                                        *
/********************************************************************************/
import java.text.SimpleDateFormat;
import java.io.*;
import java.util.Date;
import java.util.Properties;
import javax.xml.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;

import net.sf.saxon.FeatureKeys;
import net.sf.saxon.trace.XSLTTraceListener;

import org.apache.log4j.Logger;

import org.w3c.dom.*;

public class MakeStepmodCMRecord {

    private File stepmodBaseDir;
    private Config config;
    private File stepmodCmDir;
    private InputStream xsltStream;
    private File cmRecordFile;
    private String description;
    private String release;
    private String tag;
    private java.util.Date when;
    private String who;
    private StatusPrinter statusPrinter;
    private boolean recordExists;
    private String cmRecordUrl;
    private MetadataCollection metadataCollection;

    /* DOM stuff */
    private Document document;
    private TransformerFactory transFact;

    /* CVS stuff */
    private CvsListener statusListener;
    private StatusProcessor statusProcessor;
    private CvsListener logListener;
    private LogProcessor logProcessor;
    private String repositoryPrefix;
    private static final String IDENTITY_XSLT =
            "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>" + "<xsl:output method=\"xml\" indent=\"yes\" doctype-system=\"..\\..\\..\\dtd\\cm_record.dtd\"/>" + "<xsl:template match='/'>" + "<xsl:copy-of select='.'/>" + "</xsl:template></xsl:stylesheet>";
    private static final String helpStr =
            "Usage:\n" +
            "\n" +
            "  java -classpath <cp> MakeCMRecord <directory> <cm_record>\n" +
            "\n" +
            "where:\n" +
            "\n" +
            "  <cp> is a classpath containing class MakeCMRecord\n" +
            "  <directory> is a path for the part top-level directory\n" +
            "  <cm_record> is the desired filename for the CM record\n" +
            "\n" +
            "The CM record will be placed in <directory>\n";
    public static final SimpleDateFormat cvsDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    public static final SimpleDateFormat cmrDateFormat = new SimpleDateFormat("EEE MMM d HH:mm:ss yyyy");
    public static final SimpleDateFormat isoDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final String CM_FILE_NAME = "cm_record.xml";
    private static final String dummyXml = "<x></x>";
    private String fileSeparator;
    private static Logger logger = Logger.getLogger("MakeCMRecord");

    public MakeStepmodCMRecord(Config config, File stepmodBaseDir,
            String description, String release,
            String tag, String who, java.util.Date when,
            StatusPrinter statusPrinter) throws InvalidPartDirException {
        this.stepmodBaseDir = stepmodBaseDir;
        this.config = config;
        this.description = description;
        this.release = release;
        this.tag = tag;
        this.when = when;
        this.who = who;
        this.statusPrinter = statusPrinter;
        
        String stepmodBaseDirCanonicalPath = "";
        try {
            stepmodBaseDirCanonicalPath = stepmodBaseDir.getCanonicalPath();
        } catch (java.io.IOException e) {
            throw new InvalidPartDirException(e);
        }
        logger.debug("stepmodBaseDirCanonicalPath = " + stepmodBaseDirCanonicalPath);

        System.setProperty("user.dir", stepmodBaseDirCanonicalPath);

        fileSeparator = System.getProperty("file.separator");
        stepmodCmDir = new File(stepmodBaseDir, "config_management" + fileSeparator + "stepmod");

        xsltStream = ClassLoader.getSystemResourceAsStream("stepmod-cm-record.xsl");
        cmRecordFile = new File(stepmodCmDir, CM_FILE_NAME);

        recordExists = cmRecordFile.exists();
        if (recordExists) {
            statusPrinter.printStatusMessage("Updating existing CM record.");
            try {
                cmRecordUrl = cmRecordFile.toURL().toString();
            } catch (java.net.MalformedURLException e) {
                e.printStackTrace();
                recordExists = false;
            }
        } else {
            statusPrinter.printStatusMessage("Creating new CM record.");
        }
    }

    public void generateCM() throws java.io.FileNotFoundException, javax.xml.transform.TransformerException, ConnectionException, InternalErrorException {
        Node rootNode;
        Element sources;

        metadataCollection = new MetadataCollection();
        statusProcessor = new StatusProcessor(metadataCollection);
        statusListener = new CvsListener(statusProcessor);
        logProcessor = new LogProcessor(metadataCollection, statusPrinter);
        logListener = new CvsListener(logProcessor);

        rootNode = transform(xsltStream);
        document = (Document) rootNode;
        NodeList sourcesList = document.getElementsByTagName("sources");
        for (int i = 0; i < sourcesList.getLength(); i++) {
            sources = (Element) sourcesList.item(i);
            if (sources.getTextContent().trim().equals("*** INSERT DIRECTORY ELEMENTS ***")) {
                NodeList childList = sources.getChildNodes();
                for (int j = 0; j < childList.getLength(); j++) {
                    sources.removeChild(childList.item(j));
                }

            }
        }
        write();
    }

    Node transform(InputStream xsltStream) throws javax.xml.transform.TransformerException {
        ByteArrayInputStream dummyStream = new ByteArrayInputStream(dummyXml.getBytes());
        javax.xml.transform.Source xmlSource =
                new javax.xml.transform.stream.StreamSource(dummyStream);
        javax.xml.transform.Source xsltSource =
                new javax.xml.transform.stream.StreamSource(xsltStream);
        javax.xml.transform.dom.DOMResult result =
                new javax.xml.transform.dom.DOMResult();

        // create an instance of TransformerFactory
        transFact = TransformerFactory.newInstance();
        // XSLTTraceListener traceListener = new XSLTTraceListener();
        // transFact.setAttribute(FeatureKeys.TRACE_LISTENER, traceListener);

        String whenStr = cmrDateFormat.format(when);

        Transformer trans = transFact.newTransformer(xsltSource);
        trans.setParameter("release", release);
        trans.setParameter("tag", tag);
        trans.setParameter("who", who);
        trans.setParameter("when", whenStr);
        trans.setParameter("description", description);
        if (recordExists) {
            trans.setParameter("existing_record_url", cmRecordUrl);
        }

        trans.transform(xmlSource, result);
        return result.getNode();
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
        System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
    }
}
