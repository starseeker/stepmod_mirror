/*
 * $Id: STEPmod.java,v 1.8 2006/07/14 16:27:58 robbod Exp $
 *
 * STEPmod.java
 *
 * (c) Copyright 2005 Eurostep Limited
 *
 * All rights reserved.
 *
 * This software is the confidential and proprietary information
 * of Eurostep Limited ("Confidential Information").  You
 * shall not disclose such Confidential Information and shall use
 * it only in accordance with the terms of the license agreement
 * you entered into with Eurostep Limited
 */

package org.stepmod;

import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import javax.swing.UIManager;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.gui.STEPModFrame;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * This class is the main application class.
 * @author rbn
 */
public class STEPmod {
    
    private String rootDirectory;
    private TreeMap hasModules;
    private TreeMap hasApplicationProtocols;
    private TreeMap hasResourceDocs;
    private TreeMap hasResources;
    private STEPModFrame stepModGui;
    private Properties properties = new Properties();
    
    private String applicationDir;
    
    
    /** Creates a new instance of STEPmod */
    public STEPmod(String stepModRoot, String appDir) {
        rootDirectory = stepModRoot;
        applicationDir = appDir;
        readStepmodProperties();
    }
    
    /**
     * Return the directory in which STEPmod is stored.
     * @return The directory in which STEPmod is stored.
     */
    public String getRootDirectory() {
        return rootDirectory;
    }
    
    /**
     * Set the directory in which STEPmod is stored.
     * @param rootDirectory The Stepmod directory
     */
    public void setRootDirectory(String rootDirectory) {
        this.rootDirectory = rootDirectory;
    }
    
    /**
     * Sets the root directory of the STEPmod application
     *
     * @param dir the new application directory
     */
    public void setApplicationDir( String dir ) {
        applicationDir= dir;
    }
    
    /**
     * Returns the root directory of the STEPmod application
     *
     * @return the application directory or empty string if <b>setApplicationDir</b> was not called
     */
    public String getApplicationDir( ) {
        if(applicationDir != null)
            return applicationDir;
        return "";
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
     * Read the repository_index.xml file from the STEPmod root directory instantiating the STEPparts
     */
    public void readRepositoryIndex() {
        hasModules = new TreeMap();
        hasApplicationProtocols  = new TreeMap();
        hasResourceDocs = new TreeMap();
        hasResources = new TreeMap();
        
        //  set up a SAX handler to read repository_index.xml instantiating Stepmodparts.
        String stepModDir = getRootDirectory();
        String repoFilename = stepModDir+"/repository_index.xml";
        // Use an instance of ourselves as the SAX event handler
        DefaultHandler handler = new RepositorySaxHandler(this);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File repoFile =  new File(repoFilename);
            saxParser.parse( repoFile, handler );
            this.output("Loaded: "+repoFile.getPath());
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
    
    
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int i = 0;
        String stepmodRoot = "";
        String appDir = "";
        while(i < args.length) {
            if(args[i].startsWith("-")) {
                if(args[i].equals("-appDdir")) {
                    appDir = args[i+1];
                    i++;
                } else if (args[i].equals("-root")) {
                    stepmodRoot = args[i+1];
                    i++;
                }
            }
            i++;
        }
        
        
        STEPmod stepMod = new STEPmod(stepmodRoot, appDir);
        try {
            UIManager.setLookAndFeel(
                    UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {}
        
        // create the GUI for STEPmod
        STEPModFrame stepModGui = new STEPModFrame(stepMod);
        stepMod.setStepModGui(stepModGui);
        stepModGui.initialise();
        stepMod.readRepositoryIndex();
        stepModGui.initRepositoryTree();
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
    
    public void help() {
        this.toBeDone("STEPmod.help");
    }
    
    /**
     * Read the Stepmod.properties file
     */
    public void readStepmodProperties() {
        try {
            properties.load(new FileInputStream(getRootDirectory()+"/stepmod.properties"));
        } catch (IOException e) {
        }
    }
    
    /**
     * Write the Stepmod.properties file
     */
    public void writeStepmodProperties() {
        try {
            properties.store(new FileOutputStream(getRootDirectory()+"/stepmod.properties"), null);
        } catch (IOException e) {
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
     * Returns the release of STEPmod that is currently checked out.
     */
    String getStepmodRelease() {
        return null;
    }
    
}


