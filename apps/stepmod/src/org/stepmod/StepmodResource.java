/*
 * $Id: StepmodResource.java,v 1.8 2006/07/27 15:13:54 robbod Exp $
 *
 * StepmodResource.java
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

import java.io.File;
import java.io.IOException;
import java.util.TreeSet;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.CvsStatus;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author rbn
 */
public class StepmodResource extends StepmodPart {
    
    /** Creates a new instance of StepmodResource */
    public StepmodResource(STEPmod stepMod, String partName) {
        super(stepMod, partName);
        stepMod.addResource(this);
        
        this.setCvsStatusObject(new CvsStatus(this.getDirectory(), this.getName()+".xml"));
        // now read resource.xml for the part populating the attributes
        this.loadXml();
        // read the CM record
        this.readCmRecord();
        this.setupDependencies();
    }
    
    /**
     * Reads the resourceDoc.xml file and populates the relevant attributes
     */
    public void loadXml() {
        // now read resourceDoc.xml for the part populating the attributes
        DefaultHandler handler = new ResourceSaxHandler(this, this.getStepMod());
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        String resDocFilename = this.getDirectory() + "/" + this.getName()+".xml";
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File resDocFile =  new File(resDocFilename);
            saxParser.parse( resDocFile, handler );
        } catch (ParserConfigurationException ex) {
            TrappedError error = this.getErrors().addError(this,resDocFilename,ex);
            error.output();
        } catch (SAXException ex) {
            // a bit of a hack -- only need to read the attributes on first element,
            // so  parser throws StepmodReadSAXException once all have been read
            if ( !(ex instanceof StepmodReadSAXException)) {
                // A real error
                TrappedError error = this.getErrors().addError(this,resDocFilename,ex);
                error.output();
            }
        } catch (IOException ex) {
            TrappedError error = this.getErrors().addError(this,resDocFilename,ex);
            error.output();
        }
    }
    
    /**
     * Instantiate a SAX handler to read in resourceDoc.xml
     */
    private class ResourceSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private StepmodResource resource;
        private STEPmod stepMod;
        
        /**
         * Instantiate a Sax handler for reading the resourceDoc.xml file
         */
        public ResourceSaxHandler(StepmodResource resDoc, STEPmod stepMod) {
            this.resource = resDoc;
            this.stepMod = stepMod;
        }
        
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("express")) {
                resource.setPartNumber(attrs.getValue("reference"));
                // a bit of a hack -- only need to read the attributes so
                // thows StepmodReadSAXException out of the parser once all have been read
                throw (new StepmodReadSAXException());
            }
        }
    }
    
    /**
     * Provide the HTML body that is the summary of the part
     */
//    public String summaryHtmlBody() {
//        return "";
//    }
    
    /**
     * Returns the full path to the resources directory
     * @return The full path to the resources directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/resources/" + this.getName();
        return(dir);
    }
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Resource documen: ISO 10303-239"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Resource schema: "+getPartNumber());
    }
    
    public void setStepmodType() {
        this.stepmodType = "resource";
    }
    
    /**
     * returns the STEPmod type of the StepmodPart. Either:
     * module, resource_doc, application_protocol, resource
     */
    public String getStepmodType() {
        return stepmodType;
    }
    
    public String toString() {
        return(getName());
    }
    
    public void print() {
        System.out.println(getStepmodType()+": " + getName());
    }
    
    /**
     * Deduce which parts this part is dependent on and store the results in
     * the TreeMap dependencies
     */
    public void setupDependencies() {
        if (getDependentParts() == null) {
            this.setDependentParts(new TreeSet());   
            // read the schema .xml
            String schemaFilename = this.getDirectory() + "/" + this.getName()+".xml";
            readExpressInterface(schemaFilename);
        }
    }
    
}
