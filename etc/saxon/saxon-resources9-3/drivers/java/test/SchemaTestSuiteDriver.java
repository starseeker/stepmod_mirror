package test;


import com.saxonica.config.EnterpriseConfiguration;
import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.Version;
import net.sf.saxon.event.Receiver;
import net.sf.saxon.lib.FeatureKeys;
import net.sf.saxon.lib.SaxonOutputKeys;
import net.sf.saxon.om.NamePool;
import net.sf.saxon.s9api.*;
import net.sf.saxon.trans.XPathException;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;
import java.util.regex.Pattern;

/**
 * This class runs the W3C XML Schema Test Suite, driven from the test catalog.
 */
public class SchemaTestSuiteDriver {

    public final static String testNS = "http://www.w3.org/XML/2004/xml-schema-test-suite/";
    public final static String SCM_SCHEMA_LOCATION = "c:/MyJava/samples/scm/scmschema.scm";

    public final static QName QN_bugzilla = new QName("bugzilla");
    public final static QName QN_contributor = new QName("contributor");
    public final static QName QN_group = new QName("group");
    public final static QName QN_name = new QName("name");
    public final static QName QN_set = new QName("set");
    public final static QName QN_status = new QName("status");
    public final static QName QN_targetNamespace = new QName("targetNamespace");
    public final static QName QN_validity = new QName("validity");
    public final static QName QN_version = new QName("version");

    public final static QName QN_xlink_href = new QName("http://www.w3.org/1999/xlink", "href");
    
    /**
     * Run the testsuite using Saxon.
     *
     * @param args Array of parameters passed to the application
     * via the command line.
     */
    public static void main(String[] args) throws Exception {
        if (args.length == 0 || args[0].equals("-?")) {
            System.err.println("SchemaTestSuiteDriver testDir [-w] [-onwards] [-scm] -v:1.0|1.1 -c:contributor? -s:setName? -g:groupName?");
        }
        System.err.println("Testing Saxon " + Version.getProductVersion());
        new SchemaTestSuiteDriver().go(args);
    }

    String testSuiteDir;
    EnterpriseConfiguration catalogConfig;
    Processor catalogProcessor;
    SchemaValidator scmValidator;
    XMLReader parser;                 
    boolean showWarnings = true;
    boolean onwards = false;
    boolean useSCM = false;
    String versionUnderTest = "1.1";

    XMLStreamWriter results;
    int xlinkHref;

    /**
     * Get the document referenced by the xlink:href attribute of a given element node
     * @param element the element node (a node in the catalog)
     * @param processor the processor used to build the target document (the processor under test)
     * @param validate true if the document is to be schema-validated
     * @return the constructed document (owned by the supplied Processor)
     * @throws URISyntaxException if the xlink:href attribute is invalid
     * @throws SaxonApiException if an error occurs building the document
     */

    private XdmNode getLinkedDocument(XdmNode element, Processor processor, boolean validate)
    throws URISyntaxException, SaxonApiException {
        String href = element.getAttributeValue(QN_xlink_href);
        URI target = element.getBaseURI().resolve(href);
        Source ss = new StreamSource(target.toString());

        if (validate) {
            SchemaValidator validator = processor.getSchemaManager().newSchemaValidator();
            validator.validate(ss);
            return null;
        } else {
            DocumentBuilder builder = processor.newDocumentBuilder();
            builder.setLineNumbering(true);
            return processor.newDocumentBuilder().build(ss);
        }
    }


    /**
     * Run the tests
     * @param args command line arguments
     * @throws SAXException
     * @throws ParserConfigurationException
     * @throws XPathException
     * @throws IOException
     * @throws URISyntaxException
     */

    public void go(String[] args) throws SAXException, ParserConfigurationException,
            XPathException, IOException, URISyntaxException {


        testSuiteDir = args[0];
        Pattern testSetPattern = null;
        Pattern testGroupPattern = null;
        String contributor = null;
        HashMap exceptions = new HashMap();

        for (int i=1; i<args.length; i++) {
            if (args[i].equals("-w")) {
                showWarnings = true;
            } else if (args[i].equals("-onwards")) {
                onwards = true;
            } else if (args[i].equals("-scm")) {
                useSCM = true;
                try {
                    Processor scmProcessor = new Processor(true);
                    scmProcessor.setConfigurationProperty(FeatureKeys.XSD_VERSION, "1.1");
                    scmProcessor.setConfigurationProperty(FeatureKeys.XML_VERSION, "1.1");
                    SchemaManager sm = scmProcessor.getSchemaManager();
                    sm.importComponents(new StreamSource(new File(SCM_SCHEMA_LOCATION)));
                    scmValidator = sm.newSchemaValidator();
                } catch (SaxonApiException e) {
                    e.printStackTrace();
                    useSCM = false;
                }
            } else if (args[i].startsWith("-c:")) {
                contributor = args[i].substring(3);
            } else if (args[i].startsWith("-s:")) {
                testSetPattern = Pattern.compile(args[i].substring(3));
            } else if (args[i].startsWith("-g:")) {
                testGroupPattern = Pattern.compile(args[i].substring(3));
            } else if (args[i].startsWith("-v:")) {
                versionUnderTest = args[i].substring(3);
            } else {
                System.err.println("Usage: SchemaTestSuiteDriver testDir [-v:1.0|1.1] [-w] [-s:testSetPattern] [-g:testGroupPattern]");
            }
        }

        try {

            NamePool pool = new NamePool();
            catalogConfig = new EnterpriseConfiguration();
            catalogConfig.setNamePool(pool);
            catalogConfig.setHostLanguage(Configuration.XML_SCHEMA);
            parser = catalogConfig.getSourceParser();
            catalogProcessor = new Processor(catalogConfig);

            xlinkHref = pool.allocate("", "http://www.w3.org/1999/xlink", "href");


            XdmNode catalog = catalogProcessor.newDocumentBuilder().build(
                    new File(testSuiteDir + "/suite.xml"));

            writeResultFilePreamble(catalogConfig);

            XdmNode exceptionsDoc = catalogProcessor.newDocumentBuilder().build(
                    new File(testSuiteDir + "/saxon/exceptions" + (versionUnderTest.equals("1.0") ? "" : "11") + ".xml"));

            XPathCompiler xpath = catalogProcessor.newXPathCompiler();

            for (XdmItem testCaseItem : xpath.evaluate("//testcase", exceptionsDoc)) {
                XdmNode testCase = (XdmNode)testCaseItem;
                String set = testCase.getAttributeValue(QN_set);
                String group = testCase.getAttributeValue(QN_group);
                String comment = xpath.evaluateSingle("string(comment)", testCase).getStringValue();
                exceptions.put(set + "#" + group, comment);
            }

            xpath.setCaching(true);
            xpath.declareNamespace("", testNS);

            long startTime = (new Date()).getTime();

            for (XdmItem testCaseRefItem : xpath.evaluate("//testSetRef", catalog)) {
                XdmNode testSetRef = (XdmNode)testCaseRefItem;
                XdmNode testSetDoc = getLinkedDocument(testSetRef, catalogProcessor, false);
                XdmNode testSetElement = (XdmNode)xpath.evaluateSingle("testSet", testSetDoc);

                if (testSetElement == null) {
                    System.err.println("test set doc has no TestSet child: " + testSetDoc.getBaseURI());
                    continue;
                }

                String testSetName = testSetElement.getAttributeValue(QN_name);
                System.err.println("Test set " + testSetName);
                if (testSetPattern != null && !testSetPattern.matcher(testSetName).matches()) {
                    continue;
                }
                if (contributor != null && !contributor.equals(testSetElement.getAttributeValue(QN_contributor))) {
                    continue;
                }

                String testSetVn = testSetElement.getAttributeValue(QN_version);
                if (testSetVn == null) {
                    testSetVn = "";
                }
                if (!testSetVn.isEmpty() && !testSetVn.contains(versionUnderTest)) {
                    continue;
                }

                boolean xml11TestSet = testSetVn.contains("XML-1.1");

                for (XdmItem testGroupItem : xpath.evaluate("testGroup", testSetElement)) {
                    XdmNode testGroup = (XdmNode)testGroupItem;

                    String testGroupVn = testGroup.getAttributeValue(QN_version);
                    if (testGroupVn == null) {
                        testGroupVn = "";
                    }
                    if (!testGroupVn.isEmpty() && !testGroupVn.contains(versionUnderTest)) {
                        continue;
                    }

                    boolean xml11TestGroup = testGroupVn.contains("XML-1.1");

                    String testGroupName = testGroup.getAttributeValue(QN_name);
                    String exception = (String)exceptions.get(testSetName + "#" + testGroupName);

                    if (testGroupPattern != null && !testGroupPattern.matcher(testGroupName).matches()) {
                        continue;
                    }

                    System.err.println("TEST SET " + testSetName + " GROUP " + testGroupName);
                    if (onwards) {
                        testGroupPattern = null;
                        testSetPattern = null;
                    }
                    EnterpriseConfiguration testConfig = new EnterpriseConfiguration();
                    testConfig.setHostLanguage(Configuration.XML_SCHEMA);
                    testConfig.setValidationWarnings(true);
                    testConfig.setConfigurationProperty(FeatureKeys.XSD_VERSION, versionUnderTest);
                    if (xml11TestSet || xml11TestGroup) {
                        testConfig.setConfigurationProperty(FeatureKeys.XML_VERSION, "1.1");
                    }
                    Processor testProcessor = new Processor(testConfig);

                    boolean schemaQueried = false;
                    String bugzillaRef = null;
                    for (XdmItem schemaTestItem : xpath.evaluate("schemaTest", testGroup)) {
                        XdmNode schemaTest = (XdmNode)schemaTestItem;
                        bugzillaRef = null;
                        String testName = schemaTest.getAttributeValue(QN_name);
                        if (exception != null) {
                            results.writeEmptyElement("testResult");
                            results.writeAttribute("set", testSetName);
                            results.writeAttribute("group", testGroupName);
                            results.writeAttribute("test", testName);
                            results.writeAttribute("actualValidity", "notKnown");
                            results.writeAttribute("saxon:outcome", "notRun");
                            results.writeAttribute("saxon:comment", exception);
                            continue;
                        }

                        String schemaTestVn = schemaTest.getAttributeValue(QN_version);
                        if (schemaTestVn != null && !schemaTestVn.contains(versionUnderTest)) {
                            continue;
                        }

                        boolean queried = false;
                        XdmNode statusElement = (XdmNode)xpath.evaluateSingle("current", schemaTest);
                        if (statusElement != null) {
                            String status = statusElement.getAttributeValue(QN_status);
                            queried = "queried".equals(status) || "disputed-test".equals(status);
                            bugzillaRef = statusElement.getAttributeValue(QN_bugzilla);
                        }
                        if (queried) {
                            schemaQueried = true;
                        }
                        System.err.println("TEST SCHEMA " + testName + (queried ? " (queried)" : ""));
                        boolean success = true;
                        success = loadSchemas(xpath, testProcessor, schemaTest, success);
                        XdmNode expected = (XdmNode)xpath.evaluateSingle(
                            "expected[not(@version) or contains(@version, '" +versionUnderTest + "')]", schemaTest);
                        String expectedOutcome = (expected==null ? "indeterminate" :
                                expected.getAttributeValue(QN_validity));
                        boolean ok = "indeterminate".equals(expectedOutcome) ||
                                "implementation-defined".equals(expectedOutcome) ||
                                "implementation-dependent".equals(expectedOutcome) ||
                                success == "valid".equals(expectedOutcome);

                        results.writeEmptyElement("testResult");
                        results.writeAttribute("set", testSetName);
                        results.writeAttribute("group", testGroupName);
                        results.writeAttribute("test", testName);
                        results.writeAttribute("expectedValidity", expectedOutcome);
                        results.writeAttribute("actualValidity", (success ? "valid" : "invalid" ));
                        if (queried) {
                            results.writeAttribute("saxon:queried", "true");
                            results.writeAttribute("saxon:bugzilla", bugzillaRef);
                        } else {
                            results.writeAttribute("saxon:outcome", (ok ? "same" : "different"));
                        }
                    }
                    for (XdmItem instanceTestItem : xpath.evaluate("instanceTest", testGroup)) {
                        XdmNode instanceTest = (XdmNode)instanceTestItem;
                        String testName = instanceTest.getAttributeValue(QN_name);

                        if (exception != null) {
                            results.writeEmptyElement("testResult");
                            results.writeAttribute("set", testSetName);
                            results.writeAttribute("group", testGroupName);
                            results.writeAttribute("test", testName);
                            results.writeAttribute("actualValidity", "notKnown");
                            results.writeAttribute("saxon:outcome", "notRun");
                            results.writeAttribute("saxon:comment", exception);
                            continue;
                        }

                        String instanceTestVn = instanceTest.getAttributeValue(QN_version);
                        if (instanceTestVn != null && !instanceTestVn.contains(versionUnderTest)) {
                            continue;
                        }

                        boolean queried = false;
                        XdmNode statusElement = (XdmNode)xpath.evaluateSingle("current", instanceTest);
                        if (statusElement != null) {
                            String status = statusElement.getAttributeValue(QN_status);
                            queried = "queried".equals(status);
                            String instanceBug = statusElement.getAttributeValue(QN_bugzilla);
                            if (instanceBug != null) {
                                bugzillaRef = instanceBug;
                            }
                        }
                        queried |= schemaQueried;

                        System.err.println("TEST INSTANCE " + testName + (queried ? " (queried)" : ""));

                        XdmNode instanceDocument = (XdmNode)xpath.evaluateSingle("instanceDocument", instanceTest);

                        boolean success = true;
                        try {
                            getLinkedDocument(instanceDocument, testProcessor, true);
                        } catch (SaxonApiException err) {
                            System.err.println(err.getMessage());
                            success = false;
                        }

                        XdmNode expected = (XdmNode)xpath.evaluateSingle(
                            "expected[not(@version) or contains(@version, '" +versionUnderTest + "')]", instanceTest);
                        String expectedOutcome = (expected==null ? "indeterminate" :
                                expected.getAttributeValue(QN_validity));
                        boolean ok = "indeterminate".equals(expectedOutcome) ||
                                "implementation-defined".equals(expectedOutcome) ||
                                "implementation-dependent".equals(expectedOutcome) ||
                                success == "valid".equals(expectedOutcome);

                        results.writeEmptyElement("testResult");
                        results.writeAttribute("set", testSetName);
                        results.writeAttribute("group", testGroupName);
                        results.writeAttribute("test", testName);
                        results.writeAttribute("expectedValidity", expectedOutcome);
                        results.writeAttribute("actualValidity", (success ? "valid" : "invalid" ));
                        if (queried) {
                            results.writeAttribute("saxon:queried", "true");
                            results.writeAttribute("saxon:bugzilla", bugzillaRef);
                        } else {
                            results.writeAttribute("saxon:outcome", (ok ? "same" : "different"));
                        }
                    }
                }
            }

            writeResultFilePostamble();

            System.err.println("Time: " + (new Date().getTime() - startTime) + " ms");

            generateFailureReport();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean loadSchemas(XPathCompiler xpath, Processor testProcessor, XdmNode schemaTest, boolean success)
            throws URISyntaxException, SaxonApiException {
        if (useSCM) {
            return loadSchemasViaSCM(xpath, testProcessor, schemaTest, success);
        } else {
            return loadSchemasDirect(xpath, testProcessor, schemaTest, success);
        }
    }

    private boolean loadSchemasDirect(XPathCompiler xpath, Processor processor, XdmNode schemaTest, boolean success)
    throws SaxonApiException, URISyntaxException {
        for (XdmItem schemaDocRefItem : xpath.evaluate("schemaDocument", schemaTest)) {
            XdmNode schemaDocumentRef = (XdmNode)schemaDocRefItem;
            System.err.println("Loading schema at " + schemaDocumentRef.getAttributeValue(QN_xlink_href));
            XdmNode schemaDoc = getLinkedDocument(schemaDocumentRef, processor, false);
            XdmSequenceIterator si = schemaDoc.axisIterator(Axis.CHILD);
            XdmNode schemaElement = (si.hasNext() ? (XdmNode)si.next() : null);
            String targetNamespace = schemaElement.getAttributeValue(QN_targetNamespace);
            if (targetNamespace != null && processor.getUnderlyingConfiguration().isSchemaAvailable(targetNamespace)) {
                // do nothing
                // TODO: this is the only way I can get MS additional test addB132 to work.
                // This test has two schema documents, A and B; A imports B, and the test catalog
                // requests both A and B to be loaded.
                // It's not ideal: addSchemaSource() ought to be a no-op if the schema components
                // are already loaded, but in fact recompiling the imported schema document on its
                // own is losing the substitution group membership that was defined in the
                // importing document.
            } else {
                try {
                    processor.getSchemaManager().load(schemaDoc.asSource()); // TODO: use an ErrorListener
                } catch (SaxonApiException err) {
                    success = false;
                }
            }
        }
        return success;
    }

    private boolean loadSchemasViaSCM(XPathCompiler xpath, Processor testProcessor, XdmNode schemaTest, boolean success)
    throws SaxonApiException, URISyntaxException {
        Processor tempProcessor = new Processor(true);
        tempProcessor.setConfigurationProperty(FeatureKeys.XSD_VERSION, versionUnderTest);
        tempProcessor.setConfigurationProperty(FeatureKeys.XML_VERSION,
                testProcessor.getConfigurationProperty(FeatureKeys.XML_VERSION));
        EnterpriseConfiguration tempConfig = (EnterpriseConfiguration)tempProcessor.getUnderlyingConfiguration();
        XPathCompiler tempXPath = tempProcessor.newXPathCompiler();
        for (XdmItem schemaDocRefItem : xpath.evaluate("schemaDocument", schemaTest)) {
            XdmNode schemaDocumentRef = (XdmNode)schemaDocRefItem;
            System.err.println("Loading schema at " + schemaDocumentRef.getAttributeValue(QN_xlink_href));
            XdmNode schemaDoc = getLinkedDocument(schemaDocumentRef, tempProcessor, false);
            XdmNode schemaElement =
                    (XdmNode)tempXPath.evaluateSingle("*", schemaDoc);
            String targetNamespace = schemaElement.getAttributeValue(QN_targetNamespace);
            if (targetNamespace != null && tempConfig.isSchemaAvailable(targetNamespace)) {
                // do nothing
            } else {
                try {
                    tempProcessor.getSchemaManager().load(schemaDoc.asSource()); // TODO: use an ErrorListener
                } catch (SaxonApiException err) {
                    return false;
                }
            }
        }
        try {
            StringWriter sw = new StringWriter();
            Result result = new StreamResult(sw);
            Properties props = new Properties();
            props.setProperty(OutputKeys.METHOD, "xml");
            props.setProperty(OutputKeys.INDENT, "yes");
            Receiver serializer = tempConfig.getSerializerFactory().getReceiver(
                    result, tempConfig.makePipelineConfiguration(), props);

            tempConfig.exportComponents(serializer);
            String scm = sw.toString();
            try {
                scmValidator.validate(new StreamSource(new StringReader(scm)));
            } catch (SaxonApiException e) {
                System.err.println("*** SCM does not validate against schema for SCM ***");
                System.err.println(scm);
                System.exit(2);
            }
            try {
                testProcessor.getSchemaManager().importComponents(new StreamSource(new StringReader(scm)));
            } catch (SaxonApiException e) {
                e.printStackTrace();
                System.exit(2);
            }
        } catch (XPathException e) {
            if (!e.hasBeenReported()) {
                System.err.println(e.getMessage());
            }
            return false;
        }
        return success;
    }

     protected boolean isExcluded(String testName) {
        return false;
    }


    private void writeResultFilePreamble(Configuration config) throws IOException, XPathException, XMLStreamException {
        Writer resultWriter = new BufferedWriter(new FileWriter(new File(testSuiteDir + "/saxon/SaxonResults"
                    + Version.getProductVersion() + ".xml")));
        Properties resultProperties = new Properties();
        resultProperties.setProperty(OutputKeys.METHOD, "xml");
        resultProperties.setProperty(OutputKeys.INDENT, "yes");
        resultProperties.setProperty(SaxonOutputKeys.LINE_LENGTH, "120");
        results = config.getSerializerFactory().getXMLStreamWriter(
                new StreamResult(resultWriter), resultProperties);

        results.writeStartElement("testSuiteResults");
        results.writeDefaultNamespace("http://www.w3.org/XML/2004/xml-schema-test-suite/");
        results.writeNamespace("saxon", "http://saxon.sf.net/");
        results.writeAttribute("suite", "XS_2006");
        results.writeAttribute("processor", "Saxon " + Version.getProductVariantAndVersion(config) + " with xsdVersion=" + versionUnderTest);
        results.writeAttribute("submitDate", new Controller(config).getCurrentDateTime().getStringValue().substring(0, 10));
        results.writeAttribute("publicationPermission", "public");
    }

    private void writeResultFilePostamble() throws IOException, XMLStreamException {
        results.writeEndElement();
        results.close();
    }

    private void generateFailureReport() throws SaxonApiException, FileNotFoundException {
        Processor processor = new Processor(true);
        XsltCompiler c = processor.newXsltCompiler();
        XsltTransformer t = c.compile(new StreamSource(new File(testSuiteDir + "/saxon/summarize-results.xsl"))).load();
        Serializer ser = new Serializer(new FileOutputStream(
                testSuiteDir + "/saxon/SaxonFailures" + Version.getProductVersion() + ".xml"));

        t.setInitialTemplate(new QName("all-diffs"));
        t.setDestination(ser);
        t.transform();
    }
}
