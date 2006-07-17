/*
 * $Id: StepmodModule.java,v 1.10 2006/07/15 08:08:37 robbod Exp $
 *
 * StepmodModule.java
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
import java.util.Iterator;
import java.util.TreeSet;
import javax.xml.parsers.SAXParser;
import java.io.*;
import java.util.Map;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.CvsStatus;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


/**
 *
 * @author rbn
 */
public class StepmodModule extends StepmodPart {
    
    
    private String wgNumberArm;
    private String wgNumberArmSupersedes;
    private String wgNumberArmLf;
    private String wgNumberArmLfSupersedes;
    private String wgNumberMim;
    private String wgNumberMimSupersedes;
    private String wgNumberMimLfSupersedes;
    private String wgNumberMimLf;
    
    
    
    /**
     * Creates a new instance of StepmodModule
     */
    public StepmodModule(STEPmod stepMod, String partName) {
        super(stepMod, partName);
        stepMod.addModule(this);
        
        this.setCvsStatusObject(new CvsStatus(this, this.getDirectory(), "module.xml"));
        this.loadXml();
        // read the CM record
        this.readCmRecord();
    }
    
    
    /**
     * Reads the module.xml file and populates the relevant attributes
     */
    public void loadXml() {
        // now read module.xml for the part populating the attributes
        DefaultHandler handler = new ModuleSaxHandler(this, this.getStepMod());
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        String moduleFilename = this.getDirectory() + "/module.xml";
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File moduleFile =  new File(moduleFilename);
            saxParser.parse( moduleFile, handler );
        } catch (ParserConfigurationException ex) {
            TrappedError error = this.getErrors().addError(this,moduleFilename,ex);
            error.output();
        } catch (SAXException ex) {
            // a bit of a hack -- only need to read the attributes on first element,
            // so  parser throws StepmodReadSAXException once all have been read
            if ( !(ex instanceof StepmodReadSAXException)) {
                // A real error
                TrappedError error = this.getErrors().addError(this,moduleFilename,ex);
                error.output();
            }
        } catch (IOException ex) {
            TrappedError error = this.getErrors().addError(this,moduleFilename,ex);
            error.output();
        }
    }
    
    
    /**
     * Instantiate a SAX handler to read in module.xml
     */
    private class ModuleSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private StepmodModule module;
        private STEPmod stepMod;
        
        /**
         * Instantiate a Sax handler for reading the module.xml file
         */
        public ModuleSaxHandler(StepmodModule module, STEPmod stepMod) {
            this.module = module;
            this.stepMod = stepMod;
        }
        
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("module")) {
                module.setNameFrench(attrs.getValue("name.french"));
                module.setPartNumber(attrs.getValue("part"));
                module.setVersion(attrs.getValue("version"));
                module.setWgNumber(attrs.getValue("wg.number"));
                module.setWgNumberSupersedes(attrs.getValue("wg.number.supersedes"));
                module.setWgNumberArm(attrs.getValue("wg.number.arm"));
                module.setWgNumberArmSupersedes(attrs.getValue("wg.number.arm.supersedes"));
                module.setWgNumberMim(attrs.getValue("wg.number.mim"));
                module.setWgNumberMimSupersedes(attrs.getValue("wg.number.mim.supersedes"));
                module.setWgNumberArmLf(attrs.getValue("wg.number.arm_lf"));
                module.setWgNumberArmLfSupersedes(attrs.getValue("wg.number.arm_lf.supersedes"));
                module.setWgNumberMimLf(attrs.getValue("wg.number.mim_lf"));
                module.setWgNumberMimLfSupersedes(attrs.getValue("wg.number.mim_lf.supersedes"));
                module.setChecklistInternalReview(attrs.getValue("checklist.internal_review"));
                module.setChecklistProjectLeader(attrs.getValue("checklist.project_leader"));
                module.setChecklistConvener(attrs.getValue("checklist.convener"));
                module.setSc4WorkingGroup(attrs.getValue("sc4.working_group"));
                module.setIsoStatus(attrs.getValue("status"));
                module.setPublicationYear(attrs.getValue("publication.year"));
                module.setPublicationDate(attrs.getValue("publication.date"));
                module.setRcsDate(attrs.getValue("rcs.date"));
                module.setRcsRevision(attrs.getValue("rcs.revision"));
                String published = attrs.getValue("published");
                if (published.equals("y")) {
                    module.setPublished(true);
                } else {
                    module.setPublished(false);
                }
                module.setLanguage(attrs.getValue("language"));
                // a bit of a hack -- only need to read the attributes so
                // thows StepmodReadSAXException out of the parser once all have been read
                throw (new StepmodReadSAXException());
            }
        }
    }
    
    protected void setStepmodType() {
        this.stepmodType = "module";
    }
    
    
    
    public String getWgNumberArm() {
        return wgNumberArm;
    }
    
    public void setWgNumberArm(String wgNumberArm) {
        this.wgNumberArm = wgNumberArm;
    }
    
    public void setWgNumberArmSupersedes(String wgNumberArmSupersedes) {
        this.wgNumberArmSupersedes = wgNumberArmSupersedes;
    }
    
    public void setWgNumberArmLf(String wgNumberArmLf) {
        this.wgNumberArmLf = wgNumberArmLf;
    }
    
    public void setWgNumberArmLfSupersedes(String wgNumberArmLfSupersedes) {
        this.wgNumberArmLfSupersedes = wgNumberArmLfSupersedes;
    }
    
    public String getWgNumberMim() {
        return wgNumberMim;
    }
    
    public void setWgNumberMim(String wgNumberMim) {
        this.wgNumberMim = wgNumberMim;
    }
    
    public void setWgNumberMimSupersedes(String wgNumberMimSupersedes) {
        this.wgNumberMimSupersedes = wgNumberMimSupersedes;
    }
    
    public void setWgNumberMimLf(String wgNumberMimLf) {
        this.wgNumberMimLf = wgNumberMimLf;
    }
    
    public void setWgNumberMimLfSupersedes(String wgNumberMimLfSupersedes) {
        this.wgNumberMimLfSupersedes = wgNumberMimLfSupersedes;
    }
    
    public String getWgNumberArmSupersedes() {
        return wgNumberArmSupersedes;
    }
    
    public String getWgNumberArmLf() {
        return wgNumberArmLf;
    }
    
    public String getWgNumberArmLfSupersedes() {
        return wgNumberArmLfSupersedes;
    }
    
    public String getWgNumberMimSupersedes() {
        return wgNumberMimSupersedes;
    }
    
    public String getWgNumberMimLfSupersedes() {
        return wgNumberMimLfSupersedes;
    }
    
    public String getWgNumberMimLf() {
        return wgNumberMimLf;
    }
    
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Module: ISO 10303-439"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Module: ISO 10303-"+getPartNumber());
    }
    
    
    
    
    /**
     * Generates the ANT build file that is used to generate the HTML that is to be published
     */
    public void publicationCreatePackage() {
        getStepMod().getStepModGui().toBeDone("StepmodModule.publicationCreatePackage");
    }
    
    /**
     * Generates the HTML for the module that is to be published
     */
    public void publicationGenerateHtml() {
        getStepMod().getStepModGui().toBeDone("StepmodModule.publicationGenerateHtml");
    }
    
    /**
     * Returns the full path to the module directory
     * @return The full path to the module directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/modules/" + this.getName();
        return(dir);
    }
    
    /**
     * Deduce which parts this part is dependent on and store the results in
     * the TreeMap dependencies
     */
    public void setupDependencies() {
        if (getDependencies() != null) {
            // Already read the dependencies, so do not need to again
        } else {
            this.setDependencies(new TreeSet());
            this.setUsedBy(new TreeSet());
            
            // read the arm.xml
            String armFilename = this.getDirectory() + "/arm.xml";
            readExpressInterface(armFilename);
        }
    }
    
    
}
