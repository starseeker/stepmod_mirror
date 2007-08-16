/*
 * $Id: STEPmod.java,v 1.25 2007/08/15 17:20:12 joshpearce2005 Exp $
 *
 * STEPmod.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod;

import java.io.*;
import java.text.ParseException;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import java.util.jar.Manifest;
import javax.swing.UIManager;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.StepmodCvs;
import org.stepmod.gui.STEPModFrame;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * This class is the main application class.
 * @author rbn
 */
public class STEPmod {
    
    private TreeMap hasModules;
    private TreeMap hasApplicationProtocols;
    private TreeMap hasResourceDocs;
    private TreeMap hasResources;
    private STEPModFrame stepModGui;
    private Properties properties = new Properties();
    private String propertiesFilename;
    
    private String applicationDir;
    
    /**
     * The Cm record for the basic directory
     */
    private CmRecordFrmwk basicCmRecord;
    
    
    /**
     * The Cm record for the basic directory
     */
    private CmRecordFrmwk stepmodCmRecord;
    
    /**
     * The repositroy_index.xml that has been loaded
     */
    private File currentRepositoryIndex;
    
    /** Creates a new instance of STEPmod */
    public STEPmod() {
        readStepmodProperties();
        setBasicCmRecord(new CmRecordFrmwk(this, "basic"));
        setStepmodCmRecord(new CmRecordFrmwk(this, "stepmod"));
    }
    
    
    
    /**
     * Return the directory in which STEPmod is stored.
     * @return The directory in which STEPmod is stored.
     */
    public String getRootDirectory() {
        return(getStepmodProperty("STEPMODROOT"));
    }
    
    
    /**
     * Instantiate A Sax handler for reading the repository_index.xml file
     */
    private class RepositorySaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private STEPmod stepMod;
        private String partName;
        private StepmodModule module;
        private StepmodResourceDoc resourceDoc;
        private StepmodResource resource;
        private StepmodApplicationProtocol appProtocol;
        
        /*
         * Instantiate a Sax handler for reading the repository_index.xml file
         */
        public RepositorySaxHandler(STEPmod stepMod) {
            this.stepMod = stepMod;
        }
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("module")) {
                partName = attrs.getValue("name");
                module = new StepmodModule(stepMod, partName);
            } else if (qName.equals("resource_doc")) {
                partName = attrs.getValue("name");
                resourceDoc = new StepmodResourceDoc(stepMod, partName);
            } else if (qName.equals("application_protocol")) {
                partName = attrs.getValue("name");
                appProtocol = new StepmodApplicationProtocol(stepMod, partName);
            } else if (qName.equals("resource")) {
                String partName = attrs.getValue("name");
                resource = new StepmodResource(stepMod, partName);
            }
        }
        
        public void endElement(String namespaceURI,
                String sName, // simple name
                String qName  // qualified name
                )
                throws SAXException {
            if (currentElement.equals("module")) {
                module = null;
            } else if (qName.equals("resource_doc")) {
                resourceDoc = null;
            } else if (qName.equals("application_protocol")) {
                appProtocol = null;
            } else if (qName.equals("resource")) {
                resource = null;
            }
        }
        
        public void characters( char ch[], int start, int length )
        throws SAXException {
            String value = new String( ch , start , length );
        }
    }
    
    
    
    /**
     * Read the repository_index.xml file instantiating the STEPparts
     */
    public void readRepositoryIndex(String repositoryIndexFilename) {
        File repoFile =  new File(repositoryIndexFilename);
        readRepositoryIndex(repoFile);
    }
    
    /**
     * Read the repository_index.xml file instantiating the STEPparts
     */
    public void readRepositoryIndex(File repoFile) {
        hasModules = new TreeMap();
        hasApplicationProtocols  = new TreeMap();
        hasResourceDocs = new TreeMap();
        hasResources = new TreeMap();
        
        //  set up a SAX handler to read repository_index.xml instantiating Stepmodparts.
        // Use an instance of ourselves as the SAX event handler
        DefaultHandler handler = new RepositorySaxHandler(this);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            saxParser.parse( repoFile, handler );
            this.output("Loaded: "+repoFile.getPath());
            setCurrentRepositoryIndex(repoFile);
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    /**
     * Get the {@link StepmodModule} named moduleName
     * @param moduleName The name of the module
     * @return The StepmodModule representing the module named moduleName
     */
    public StepmodModule getModuleByName(String moduleName){
        StepmodModule module = (StepmodModule) hasModules.get(moduleName);
        return(module);
    }
    
    /**
     * Get the {@link StepmodPart} named partName
     * @param partName The name of the part
     * @return The StepmodPart representing the module named partName
     */
    public StepmodPart getPartByName(String partName){
        StepmodPart part = (StepmodPart)getModuleByName(partName);
        if (part != null) {
            return (part);
        }
        part = (StepmodPart)getResourceByName(partName);
        if (part != null) {
            return (part);
        }
        part = (StepmodPart)getApplicationProtocolByName(partName);
        if (part != null) {
            return (part);
        }
        part = (StepmodPart)getResourceDocByName(partName);
        if (part != null) {
            return (part);
        }
        return (part);
    }
    
    /**
     * Add a module to the module hashtable indexed by the name of the module.
     */
    public void addModule(StepmodModule module) {
        String name = module.getName();
        hasModules.put(name, module);
    }
    
    /**
     * return the hashtable that is used to index the modules
     */
    public TreeMap getModulesHash() {
        return(hasModules);
    }
    
    
    /**
     * Get the {@link StepmodApplicationProtocol} named apName
     * @param apName The name of the ApplicationProtocol
     * @return The StepmodApplicationProtocol representing the ApplicationProtocol named apName
     */
    public StepmodApplicationProtocol getApplicationProtocolByName(String apName){
        StepmodApplicationProtocol ap = (StepmodApplicationProtocol) hasApplicationProtocols.get(apName);
        return(ap);
    }
    
    
    /**
     * Add an ApplicationProtocol to the ApplicationProtocol hashtable indexed by the name of the ApplicationProtocol.
     */
    public void addApplicationProtocol(StepmodApplicationProtocol ap) {
        String name = ap.getName();
        hasApplicationProtocols.put(name, ap);
    }
    
    /**
     * return the hashtable that is used to index the ApplicationProtocol
     */
    public TreeMap getApplicationProtocolsHash() {
        return(hasApplicationProtocols);
    }
    
    
    
    
    /**
     * Get the {@link StepmodResource} named resourceName
     * @param resourceName The schema name of the resourceName
     * @return The StepmodResource representing the resource named resourceName
     */
    public StepmodResource getResourceByName(String resourceName){
        StepmodResource resource = (StepmodResource) hasResources.get(resourceName);
        return(resource);
    }
    
    
    /**
     * Add a resource to the resource hashtable indexed by the schema name of the resource.
     */
    public void addResource(StepmodResource resource) {
        String name = resource.getName();
        hasResources.put(name, resource);
    }
    
    /**
     * return the hashtable that is used to index the modules
     */
    public TreeMap getResourcesHash() {
        return(hasResources);
    }
    
    
    /**
     * Run a cvs update on stepmod/config_management
     */
    public StepmodCvs cvsUpdateConfigManagement() {
        StepmodCvs stepmodCvs = new StepmodCvs(this);
        stepmodCvs.cvsUpdate(this.getRootDirectory()+"/config_management");
        return stepmodCvs;
    }
    
    /**
     * Runs a CVS update to force the check out of the latest development revisions of all the modules.
     */
    public void cvsUpdateAllModulesDevelopmentRevision() {
        toBeDone("org.stepmod.STEPModFrame.cvsUpdateAllModulesDevelopmentRevision");
    }
    
    /**
     * Runs a CVS update to force the check out of the latest released revisions of all the modules.
     */
    public void cvsUpdateAllModulesLatestRevision() {
        toBeDone("org.stepmod.STEPModFrame.cvsUpdateAllModulesLatestRevision");
    }
    
    /**
     * Runs a CVS update to force the check out of the latest published, i.e. standard revisions of all the modules.
     */
    public void cvsUpdateAllModulesLatestPublications() {
        toBeDone("org.stepmod.STEPModFrame.cvsUpdateAllModulesLatestPublications");
    }
    
    
    /**
     * Get the {@link StepmodResourceDoc} named resourceDocName
     * @param resourceDocName The name of the resourceDoc
     * @return The StepmodResourceDoc representing the ResourceDoc named resourceDocName
     */
    public StepmodResourceDoc getResourceDocByName(String resourceDocName){
        StepmodResourceDoc resourceDoc = (StepmodResourceDoc) hasResourceDocs.get(resourceDocName);
        return(resourceDoc);
    }
    
    
    /**
     * Add a module to the module hashtable indexed by the name of the module.
     */
    public void addResourceDoc(StepmodResourceDoc module) {
        String name = module.getName();
        hasResourceDocs.put(name, module);
    }
    
    /**
     * return the hashtable that is used to index the modules
     */
    public TreeMap getResourceDocsHash() {
        return(hasResourceDocs);
    }
    
    /**
     * Print out the contents of the repository
     * Used for debugging
     */
    public void printRepository() {
        System.out.println("Modules");
        for (Iterator it=getModulesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodModule module = (StepmodModule)entry.getValue();
            module.print();
        }
        System.out.println("");
        
        System.out.println("Application Protocols");
        for (Iterator it=getApplicationProtocolsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodApplicationProtocol ap = (StepmodApplicationProtocol)entry.getValue();
            ap.print();
        }
        System.out.println("");
        
        System.out.println("Resource docs");
        for (Iterator it=getResourceDocsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResourceDoc res = (StepmodResourceDoc)entry.getValue();
            res.print();
        }
        System.out.println("");
        
        
        System.out.println("Resource dcs");
        for (Iterator it=getResourcesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResource res = (StepmodResource)entry.getValue();
            res.print();
        }
        System.out.println("");
    }
    
    /**
     * Output the string. Send the output to the Gui If a GUI is available
     */
    public void output(String string) {
        if (getStepModGui() != null) {
            getStepModGui().output(string);
        } else {
            System.out.println(string);
        }
    }
    
    /**
     * Output a warning string. Send the warning to the Gui If a GUI is available
     */
    public void warning(String string) {
        if (getStepModGui() != null) {
            getStepModGui().warning(string);
        } else {
            System.out.println(string);
        }
    }
    
    
    /**
     * Output a warning that the method is to be implemented. Send the warning to the Gui If a GUI is available
     */
    public void toBeDone(String string) {
        if (getStepModGui() != null) {
            getStepModGui().toBeDone(string);
        } else {
            System.out.println(string);
        }
    }
    
    
    public STEPModFrame getStepModGui() {
        return stepModGui;
    }
    
    public void setStepModGui(STEPModFrame stepModGui) {
        this.stepModGui = stepModGui;
    }
    
    public void mkNewModule() {
        this.toBeDone("STEPmod.mkNewModule");
    }
    
    public void mkNewApplicationProtocol() {
        this.toBeDone("STEPmod.mkNewApplicationProtocol");
    }
    
    public void mkNewResourceDoc() {
        this.toBeDone("STEPmod.mkNewResourceDoc");
    }
    
    public void about() {
        this.toBeDone("STEPmod.about");
    }
    
    
    /**
     * Read the Stepmod.properties file
     */
    public void readStepmodProperties() {
        String stepmodDirName = System.getProperty("user.home")+"/stepmod";
        File stepmodDir = new File(stepmodDirName);
        boolean success = true;
        if (!stepmodDir.exists()) {
            success = stepmodDir.mkdir();
        }
        if (success) {
            String stepmodPropsFilename = stepmodDirName+"/stepmod.properties";
            File stepmodPropsFile = new File(stepmodPropsFilename);
            if (stepmodPropsFile.exists()) {
                // Load the properties from users home
                // C:/Documents and Settings/user on windows
                try {
                    properties.load(new FileInputStream(stepmodPropsFile));
                    setPropertiesFilename(stepmodPropsFilename);
                } catch (FileNotFoundException ex) {
                    ex.printStackTrace();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            } else {
                //setStepmodProperty("PUTTY_SESSION","");
                setStepmodProperty("PROTOCOL","");
                setStepmodProperty("SFORGE_USERNAME","");
                setStepmodProperty("CVS_RSH","");
                setStepmodProperty("STEPMODROOT","");
                setStepmodProperty("CVSEXE","");
                setPropertiesFilename(stepmodPropsFilename);
                writeStepmodProperties();
            }
            
        } else {
            System.out.println("Can not read or create directory " + stepmodDir);
        }
    }
    
    /**
     * Answer if the stepmod root has been correctly set in the properties
     */
    public boolean isValidStepmodRoot() {
        File stepmodRoot = new File(getStepmodProperty("STEPMODROOT")+"/repository_index.xml");
        return(stepmodRoot.exists());
    }
    
    /**
     * Write the Stepmod.properties file
     */
    public void writeStepmodProperties() {
        try {
            properties.store(new FileOutputStream(getPropertiesFilename()), null);
        } catch (FileNotFoundException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    
    /**
     * Get a property from the Stepmod.properties file
     * @param propName the name of the property whose value is being returned
     * @return returns the value of the property
     */
    public String getStepmodProperty(String propName) {
        return(properties.getProperty(propName));
    }
    
    /**
     * Set a property from the Stepmod.properties file
     * @param propName the name of the property whose value is being set
     * @param propValue the value being set to the property
     */
    public void setStepmodProperty(String propName, String propValue) {
        properties.setProperty(propName, propValue);
    }
    
    /**
     * Returns the release of the common files (data/basic) of STEPmod that is currently checked out.
     */
    public String getStepmodCommonRelease() {
        String id = null;
        if (getBasicCmRecord().getCheckedOutRelease() != null) {
            id = getBasicCmRecord().getCheckedOutRelease().getId();
        }
        return(id);
    }
    
    /**
     * Returns the release of the STEPmod framework files (xsl, dtd) is currently checked out.
     */
    public String getStepmodFrameworkRelease() {
        String id = null;
        if (getStepmodCmRecord().getCheckedOutRelease() != null) {
            id = getStepmodCmRecord().getCheckedOutRelease().getId();
        }
        return(id);
    }
    
    public File getCurrentRepositoryIndex() {
        return currentRepositoryIndex;
    }
    
    public void setCurrentRepositoryIndex(File currentRepositoryIndex) {
        this.currentRepositoryIndex = currentRepositoryIndex;
    }
    
    public String getPropertiesFilename() {
        return propertiesFilename;
    }
    
    public void setPropertiesFilename(String propertiesFilename) {
        this.propertiesFilename = propertiesFilename;
    }
    
    
    /**
     * Allows to access to the information of the application contained in a Manifest file.
     */
    public java.util.jar.Manifest getManifestInformation() {
        java.util.jar.Manifest manifest = null;
        try{
            java.net.URL manifestURL = getClass().getResource("/org/stepmod/META_INF/MANIFEST.MF");
            java.io.InputStream is = manifestURL.openStream();
            manifest = new java.util.jar.Manifest(is);
        } catch(java.io.IOException ioe){
            ioe.printStackTrace();
        }
        return manifest;
    }
    
    public String getBuildNumber() {
        Manifest manifest = this.getManifestInformation();
        java.util.jar.Attributes attributes = manifest.getMainAttributes();
        String buildNumber = attributes.getValue("Build-Number");
        return(buildNumber);
    }
    
    /**
     * Answer if the part exists in STEPmod, in other words there is a part directory
     */
    public boolean partExists(String partName, String partType) {
        // TODO need to complete this function
        if (partType.equals("module")) {
            File partFile = new File( getRootDirectory()+"/data/"+partType+"s/"+partName+"/module.xml");
            return(partFile.exists());
        } else if (partType.equals("resource")){
            File partFile = new File( getRootDirectory()+"/data/"+partType+"s/"+partName+"/"+partName+".xml");
            return(partFile.exists());
        }
        return(true);
    }
    
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        STEPmod stepMod = new STEPmod();

        try {
            UIManager.setLookAndFeel(
                    UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {}
        
        // create the GUI for STEPmod
        STEPModFrame stepModGui = new STEPModFrame(stepMod);
        stepMod.setStepModGui(stepModGui);
        stepModGui.initialise();
        //stepMod.readRepositoryIndex();
       // stepModGui.initRepositoryTree();
    }
    
    public CmRecordFrmwk getBasicCmRecord() {
        return basicCmRecord;
    }
    
    public void setBasicCmRecord(CmRecordFrmwk basicCmRecord) {
        this.basicCmRecord = basicCmRecord;
    }
    
    public CmRecordFrmwk getStepmodCmRecord() {
        return stepmodCmRecord;
    }
    
    public void setStepmodCmRecord(CmRecordFrmwk stepmodCmRecord) {
        this.stepmodCmRecord = stepmodCmRecord;
    }
    
    public String toString() {
        return("STEPmod");
    }
    
    
}


