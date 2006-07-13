/*
 * $Id: StepmodApplicationProtocol.java,v 1.3 2006/07/12 18:10:24 robbod Exp $
 *
 * StepmodApplicationProtocol.java
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
public class StepmodApplicationProtocol extends StepmodPart {
    
    /** Creates a new instance of StepmodApplicationProtocol */
    public StepmodApplicationProtocol(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
        // read the CM record
        this.readCmRecord();
        stepMod.addApplicationProtocol(this);
        this.loadXml();
        this.setCvsStatusObject(new CvsStatus(this, this.getDirectory(), "application_protocol.xml"));
    }
    
    
    public void loadXml() {
        // now read application_protocol.xml for the part populating the attributes
        DefaultHandler handler = new ApDocSaxHandler(this, this.getStepMod());
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            String apDocFilename = this.getDirectory()+"/application_protocol.xml";
            File apDocFile =  new File(apDocFilename);
            saxParser.parse( apDocFile, handler );
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    /**
     * Provide the HTML body that is the summary of the part
     */
    public String summaryHtmlBody() {
        return "";
    }
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Application protocol: ISO 10303-239"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Application protocol: ISO 10303-"+getPartNumber());
    }
    
    /**
     * Instantiate a SAX handler to read in apDoc.xml
     */
    private class ApDocSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private StepmodApplicationProtocol apDoc;
        private STEPmod stepMod;
        
        /**
         * Instantiate a Sax handler for reading the apDoc.xml file
         */
        public ApDocSaxHandler(StepmodApplicationProtocol apDoc, STEPmod stepMod) {
            this.apDoc = apDoc;
            this.stepMod = stepMod;
        }
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("application_protocol")) {
                apDoc.setNameFrench(attrs.getValue("name.french"));
                apDoc.setPartNumber(attrs.getValue("part"));
                apDoc.setVersion(attrs.getValue("version"));
                apDoc.setWgNumber(attrs.getValue("wg.number"));
                apDoc.setWgNumberSupersedes(attrs.getValue("wg.number.supersedes"));
                apDoc.setChecklistInternalReview(attrs.getValue("checklist.internal_review"));
                apDoc.setChecklistProjectLeader(attrs.getValue("checklist.project_leader"));
                apDoc.setChecklistConvener(attrs.getValue("checklist.convener"));
                apDoc.setIsoStatus(attrs.getValue("status"));
                apDoc.setPublicationYear(attrs.getValue("publication.year"));
                apDoc.setPublicationDate(attrs.getValue("publication.date"));
                String published = attrs.getValue("published");
                if (published.equals("y")) {
                    apDoc.setPublished(true);
                } else {
                    apDoc.setPublished(false);
                }
                apDoc.setLanguage(attrs.getValue("language"));
            }
        }
    }
    
    protected void setStepmodType() {
        this.stepmodType = "application_protocol";
    }
    
    /**
     * Returns the full path to the apDoc directory
     * @return The full path to the apDoc directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/application_protocols/" + this.getName();
        return(dir);
    }
    
    /**
     * Proved an HTML summary of the module
     */
    public String summaryHtml() {
        String cvsStateDscr = "";
        int cvsState = getCvsState();
        if (cvsState == CvsStatus.CVSSTATE_UNKNOWN) {
            cvsStateDscr = "ERROR -- Release status cannot be established";
        } else if (cvsState == CvsStatus.CVSSTATE_DEVELOPMENT) {
            cvsStateDscr = "Latest development release";
        } else if (cvsState == CvsStatus.CVSSTATE_RELEASE) {
            cvsStateDscr = "Release ("+ this.getCvsTag() +")";
        }
        String summary = "<html><body>"
                + "<h2>Application protocol: ISO 10303-"+getPartNumber()+"</h2>"
                + "<table>"
                + "<tr><td>Number:</td><td>ISO 10303-"+getPartNumber()+"</td></tr>"
                + "<tr><td>Name:</td><td>"+getName()+"</td></tr>"
                + "<tr><td>Release status:</td><td>" + cvsStateDscr +"</td></tr>"
                + "</table></body></html>";
        return(summary);
    }
}
