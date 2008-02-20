
/********************************************************************************
/* MakeCMRecord                                                                 *
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

import org.netbeans.lib.cvsclient.CVSRoot;
import org.netbeans.lib.cvsclient.Client;
import org.netbeans.lib.cvsclient.admin.StandardAdminHandler;
import org.netbeans.lib.cvsclient.command.Command;
import org.netbeans.lib.cvsclient.command.GlobalOptions;
import org.netbeans.lib.cvsclient.command.log.LogCommand;
import org.netbeans.lib.cvsclient.command.status.StatusCommand;
import org.netbeans.lib.cvsclient.connection.PServerConnection;
import org.netbeans.lib.cvsclient.event.CVSListener;

public class MakeCMRecord {

    private int partType;
    private File stepmodBaseDir;
    private Config config;
    private String partName;
    private File partDir;
    private File partCmDir;
    private String partDirCanonicalPath;
    private File partXMLFile;
    private InputStream xsltStream;
    private File cmRecordFile;
    private String description;
    private String release;
    private String releaseStatus;
    private String stepmodCommonRelease;
    private String stepmodFrameworkRelease;
    private String status;
    private String releaseSequence;
    private String edition;
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
    private GlobalOptions globalOptions;
    private CVSRoot cvsRoot;
    private PServerConnection connection;
    private Client client;
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
    public static final int PT_MODULE = 1;
    public static final int PT_RESOURCE = 2;
    private static final String[] subdirName = {"", "modules", "resources"};
    private String fileSeparator;
    public static final String CM_FILE_NAME = "cm_record.xml";
    private static Logger logger = Logger.getLogger("MakeCMRecord");

    public MakeCMRecord(int partType, Config config, File stepmodBaseDir,
            String partName, String description, String release, String releaseStatus,
            String stepmodCommonRelease, String stepmodFrameworkRelease,
            String status, String releaseSequence,
            String edition, String who, java.util.Date when,
            StatusPrinter statusPrinter)
            throws InvalidPartDirException {
        this.partType = partType;
        this.stepmodBaseDir = stepmodBaseDir;
        this.config = config;
        this.partName = partName;
        this.description = description;
        this.release = release;
        this.releaseStatus = releaseStatus;
        this.stepmodCommonRelease = stepmodCommonRelease;
        this.stepmodFrameworkRelease = stepmodFrameworkRelease;
        this.status = status;
        this.releaseSequence = releaseSequence;
        this.edition = edition;
        this.when = when;
        this.who = who;
        this.statusPrinter = statusPrinter;

        fileSeparator = System.getProperty("file.separator");
        partDir = new File(stepmodBaseDir, "data" + fileSeparator + subdirName[partType] + fileSeparator + partName);
        partCmDir = new File(stepmodBaseDir, "config_management" + fileSeparator + subdirName[partType] + fileSeparator + partName);

        try {
            partDirCanonicalPath = partDir.getCanonicalPath();
        } catch (java.io.IOException e) {
            throw new InvalidPartDirException(e);
        }

        System.setProperty("user.dir", partDirCanonicalPath);
        partXMLFile = new File(partDir, "module.xml");
        xsltStream = ClassLoader.getSystemResourceAsStream("cm-record.xsl");
        cmRecordFile = new File(partCmDir, CM_FILE_NAME);

        recordExists = cmRecordFile.exists();
        if (recordExists) {
            statusPrinter.printStatusMessage("Updating existing CM record.");
            try {
                cmRecordUrl = cmRecordFile.toURL().toString();
            }
            catch (java.net.MalformedURLException e) {
                e.printStackTrace();
                recordExists = false;
            }
        } else {
            statusPrinter.printStatusMessage("Creating new CM record.");
        }
        globalOptions = new GlobalOptions();
        String cvsRootStr = config.getCvsRootStr();
        cvsRoot = CVSRoot.parse(cvsRootStr);
        globalOptions.setCVSRoot(cvsRootStr);
    }

    public void generateCM() throws java.io.FileNotFoundException, javax.xml.transform.TransformerException, ConnectionException, InternalErrorException {
        Node rootNode;
        Element sources;

        metadataCollection = new MetadataCollection();
        statusProcessor = new StatusProcessor(metadataCollection);
        statusListener = new CvsListener(statusProcessor);
        logProcessor = new LogProcessor(metadataCollection, statusPrinter);
        logListener = new CvsListener(logProcessor);

        rootNode = transform(partXMLFile, xsltStream);
        document = (Document) rootNode;
        NodeList sourcesList = document.getElementsByTagName("sources");
        for (int i = 0; i < sourcesList.getLength(); i++) {
            sources = (Element) sourcesList.item(i);
            if (sources.getTextContent().trim().equals("*** INSERT DIRECTORY ELEMENTS ***")) {
                NodeList childList = sources.getChildNodes();
                for (int j = 0; j < childList.getLength(); j++) {
                    sources.removeChild(childList.item(j));
                }
                processDirTree(partDir, sources);
            }
        }
        write();
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

        Transformer trans = transFact.newTransformer(xsltSource);
        trans.setParameter("release", release);
        trans.setParameter("release_status", releaseStatus);
        trans.setParameter("stepmod_common_release", stepmodCommonRelease);
        trans.setParameter("stepmod_framework_release", stepmodFrameworkRelease);
        trans.setParameter("release_sequence", releaseSequence);
        trans.setParameter("edition", edition);
        trans.setParameter("who", who);
        trans.setParameter("when", whenStr);
        trans.setParameter("description", description);
        trans.setParameter("status", status);
        if (recordExists) {
            trans.setParameter("existing_record_url", cmRecordUrl);
        }

        trans.transform(xmlSource, result);
        return result.getNode();
    }

    void processDirTree(File root, Element sources) throws java.io.FileNotFoundException, ConnectionException, InternalErrorException {

        StatusCommand statusCommand = new StatusCommand();
        statusCommand.setRecursive(true);
        statusCommand.setBuilder(null);
        doCvs(root, statusCommand, statusListener);
        statusProcessor.flush();

        LogCommand logCommand = new LogCommand();
        logCommand.setRecursive(true);
        logCommand.setBuilder(null);
        doCvs(root, logCommand, logListener);
        logProcessor.flush();

        // metadataCollection.print();

        processDir(root, root, sources);
    }

    void processDir(File current, File root, Element sources) throws java.io.FileNotFoundException, ConnectionException, InternalErrorException {
        File[] children = current.listFiles();
        String rootPath = root.getPath();
        String currentPath = current.getPath();
        String relativePath;
        Element element;
        Element childElt;

        if (currentPath.equals(rootPath)) {
            relativePath = ".";
        } else {
            if (currentPath.startsWith(rootPath + "\\")) {
                relativePath = currentPath.substring(rootPath.length() + 1);
            } else {
                relativePath = "*ERROR*";
            }
        }
        element = document.createElement("directory");
        element.setAttribute("name", relativePath);
        sources.appendChild(element);
        for (int i = 0; i < children.length; i++) {
            File child = children[i];
            String childName = child.getName();
            if (child.isDirectory() && !(childName.equals("CVS")) && !(childName.equals("Attic"))) {
                processDir(child, root, sources);
            }
            if (child.isFile() && !childName.equals("cm_record.xml")) {
                processFile(child, element);
            }
        }
    }

    void processFile(File current, Element dirElt) throws java.io.FileNotFoundException, ConnectionException, InternalErrorException {
        Element element;
        Metadata metadata = null;

        try {
            metadata = getMetadata(current);
            if (metadata == null) {
                statusPrinter.printStatusMessage("Metadata not found for file " + current.getCanonicalPath());
                return;
            }
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }




        element = document.createElement("file");
        element.setAttribute("name", current.getName());

        if (metadata.date != null) {
            element.setAttribute("cvs_date", fixDate(metadata.date));
        } else {
            element.setAttribute("cvs_date", "*** FILL IN ***");
            statusPrinter.printStatusMessage("Date not found for " + current.getPath() + ".");
        }

        if (metadata.revision != null) {
            element.setAttribute("cvs_revision", metadata.revision);
        } else {
            element.setAttribute("cvs_revision", "*** FILL IN ***");
            statusPrinter.printStatusMessage("Revision not found for " + current.getPath() + ".");
        }

        dirElt.appendChild(element);
    }

    Metadata getMetadata(File file) throws java.io.FileNotFoundException, java.io.IOException, ConnectionException, InternalErrorException {
        String line;

        String canonicalPath = file.getCanonicalPath();
        String relativePath = canonicalPath.substring(partDirCanonicalPath.length()).replace("\\", "/");

        String repositoryPath = repositoryPrefix + relativePath;

        Metadata metadata = metadataCollection.get(repositoryPath);
        return metadata;
    }

    String getCvsRevision(String idStr) {
        String[] comp = idStr.split(" ");
        if (comp.length >= 2) {
            return comp[1];
        } else {
            return null;
        }
    }

    String getCvsDate(String idStr) {
        String[] comp = idStr.split(" ");
        if (comp.length >= 4) {
            return comp[2] + " " + comp[3];
        } else {
            return null;
        }
    }

    void doCvs(File root, Command command, CVSListener listener) throws ConnectionException {
        try {
            connection = new PServerConnection(cvsRoot);
            connection.open();

            client = new Client(connection, new StandardAdminHandler());
            repositoryPrefix = client.getRepositoryForDirectory(partDir.getCanonicalPath());

            client.setLocalPath(root.getCanonicalPath());

            client.getEventManager().addCVSListener(listener);
            client.executeCommand(command, globalOptions);
            client.getEventManager().removeCVSListener(listener);
        } catch (org.netbeans.lib.cvsclient.connection.AuthenticationException e) {
            e.printStackTrace();
            throw new ConnectionException("Unable to open CVS connection.");
        } catch (org.netbeans.lib.cvsclient.command.CommandAbortedException e) {
            e.printStackTrace();
            throw new ConnectionException("CVS command aborted.");
        } catch (org.netbeans.lib.cvsclient.command.CommandException e) {
            e.printStackTrace();
            throw new ConnectionException("CVS command error.");
        } catch (java.io.IOException e) {
            e.printStackTrace();
            throw new ConnectionException("IO exception.");
        } finally {
            try {
                connection.close();
            } catch (java.io.IOException e) {
                System.err.println("IOException while closing connection.");
            }
        }
    }

    String fixDate(String inDate) {
        if (inDate == null) {
            return null;
        } else {
            try {
                Date date = cvsDateFormat.parse(inDate);
                String str = cmrDateFormat.format(date);
                return str;
            } catch (java.text.ParseException e) {
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
        System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
    }
}
