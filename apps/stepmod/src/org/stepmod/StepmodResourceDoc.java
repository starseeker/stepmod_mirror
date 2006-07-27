/*
 * $Id: StepmodResourceDoc.java,v 1.7 2006/07/25 12:20:56 robbod Exp $
 *
 * StepmodResourceDoc.java
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
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeSet;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.CvsStatus;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;

/**
 *
 * @author rbn
 */
public class StepmodResourceDoc extends StepmodPart {
    
    private String WgNumberExpress;
    private String WgNumberExpressSupersedes;
    private ArrayList hasSchemas = new ArrayList();
    
    /** Creates a new instance of StepmodResourceDoc */
    public StepmodResourceDoc(STEPmod stepMod, String partName) {
        super(stepMod, partName);
        stepMod.addResourceDoc(this);
        
        this.setCvsStatusObject(new CvsStatus(this, this.getDirectory(), "resource.xml"));
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
        DefaultHandler handler = new ResourceDocSaxHandler(this, this.getStepMod());
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        String resDocFilename = this.getDirectory() + "/resource.xml";
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
    private class ResourceDocSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private StepmodResourceDoc resourceDoc;
        private STEPmod stepMod;
        
        /**
         * Instantiate a Sax handler for reading the resourceDoc.xml file
         */
        public ResourceDocSaxHandler(StepmodResourceDoc resDoc, STEPmod stepMod) {
            this.resourceDoc = resDoc;
            this.stepMod = stepMod;
        }
        
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("resource")) {
                resourceDoc.setNameFrench(attrs.getValue("name.french"));
                resourceDoc.setPartNumber(attrs.getValue("part"));
                resourceDoc.setVersion(attrs.getValue("version"));
                resourceDoc.setWgNumber(attrs.getValue("wg.number"));
                resourceDoc.setWgNumberSupersedes(attrs.getValue("wg.number.supersedes"));
                resourceDoc.setWgNumberExpress(attrs.getValue("wg.number.express"));
                resourceDoc.setWgNumberExpressSupersedes(attrs.getValue("wg.number.express.supersedes"));
                resourceDoc.setChecklistInternalReview(attrs.getValue("checklist.internal_review"));
                resourceDoc.setChecklistProjectLeader(attrs.getValue("checklist.project_leader"));
                resourceDoc.setChecklistConvener(attrs.getValue("checklist.convener"));
                resourceDoc.setSc4WorkingGroup(attrs.getValue("sc4.working_group"));
                resourceDoc.setIsoStatus(attrs.getValue("status"));
                resourceDoc.setRcsDate(attrs.getValue("rcs.date"));
                resourceDoc.setRcsRevision(attrs.getValue("rcs.revision"));
                resourceDoc.setPublicationYear(attrs.getValue("publication.year"));
                resourceDoc.setPublicationDate(attrs.getValue("publication.date"));
                String published = attrs.getValue("published");
                if (published.equals("y")) {
                    resourceDoc.setPublished(true);
                } else {
                    resourceDoc.setPublished(false);
                }
                resourceDoc.setLanguage(attrs.getValue("language"));
                // a bit of a hack -- only need to read the attributes so
                // thows StepmodReadSAXException out of the parser once all have been read
                //throw (new StepmodReadSAXException());
            } else if (currentElement.equals("schema")) {
                String schemaName = attrs.getValue("name");
                resourceDoc.getHasSchemas().add(schemaName);
            }
        }
    }
    
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Resource documen: ISO 10303-239"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Resource document: ISO 10303-"+getPartNumber());
    }
    
    protected void setStepmodType() {
        this.stepmodType = "resource_doc";
    }
    
    /**
     * Returns the full path to the resource doc directory
     * @return The full path to the resource doc directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/resource_docs/" + this.getName();
        return(dir);
    }
    
    
    public String getWgNumberExpress() {
        return WgNumberExpress;
    }
    
    public void setWgNumberExpress(String WgNumberExpress) {
        this.WgNumberExpress = WgNumberExpress;
    }
    
    public String getWgNumberExpressSupersedes() {
        return WgNumberExpressSupersedes;
    }
    
    public void setWgNumberExpressSupersedes(String WgNumberExpressSupersedes) {
        this.WgNumberExpressSupersedes = WgNumberExpressSupersedes;
    }
    
    /**
     * Deduce which parts this part is dependent on and store the results in
     * the TreeMap dependencies
     */
    public void setupDependencies() {
        if (this.getDependentParts() == null) {
            this.setDependentParts(new TreeSet());
            for (Iterator it = hasSchemas.iterator(); it.hasNext();) {
                String schemaName = (String) it.next();
                StepmodResource resSchema = this.getStepMod().getResourceByName(schemaName);
                if (resSchema == null) {
                    // Load it
                    resSchema = new StepmodResource(this.getStepMod(), schemaName);
                }                
                this.addDependentPart(resSchema);
                // read the schema.xml
                String schemaFilename = this.getStepMod().getRootDirectory()
                + "/data/resources/" + schemaName +"/" + schemaName + ".xml";
                readExpressInterface(schemaFilename);
            }
        }
    }
    
    
    public ArrayList getHasSchemas() {
        return hasSchemas;
    }
    
}
