/*
 * $Id: StepmodModule.java,v 1.2 2006/06/13 08:34:36 robbod Exp $
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
import javax.xml.parsers.SAXParser;
import java.io.*;
import javax.xml.parsers.SAXParserFactory;
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
    private String sc4WorkingGroup;
    
    
    
    /**
     * Creates a new instance of StepmodModule
     */
    public StepmodModule(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
        // read the CM record
        this.readCmRecord();
        stepMod.addModule(this);
        
        // now read module.xml for the part populating the attributes
        DefaultHandler handler = new ModuleSaxHandler(this, stepMod);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            String stepModDir = stepMod.getRootDirectory();
            String moduleFilename = stepModDir+"/data/modules/" + partName + "/module.xml";
            File moduleFile =  new File(moduleFilename);
            saxParser.parse( moduleFile, handler );
        } catch (Throwable t) {
            t.printStackTrace();
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
                module.setSc4WorkingGroup(attrs.getValue("sc4.working_group"));
                module.setChecklistConvener(attrs.getValue("checklist.convener"));
                module.setIsoStatus(attrs.getValue("status"));
                module.setPublicationYear(attrs.getValue("publication.year"));
                module.setPublicationDate(attrs.getValue("publication.date"));
                String published = attrs.getValue("published");
                if (published.equals("y")) {
                    module.setPublished(true);
                } else {
                    module.setPublished(false);
                }
                module.setLanguage(attrs.getValue("language"));
            }
        }
    }
    
    private void setStepmodType() {
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
    
    public void setSc4WorkingGroup(String sc4WorkingGroup) {
        this.sc4WorkingGroup = sc4WorkingGroup;
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
    
    public String getSc4WorkingGroup() {
        return sc4WorkingGroup;
    }
    
    /**
     * Proved an HTML summary of the module
     */
    public String summaryHtml() {
        String summary = "<html><body>";
        summary = summary + "<h1>Module ISO 10303-"+getPartNumber()+" "+getName() +"</h1>";
        summary = summary + "</body></html>";
        return(summary);
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
     * @return The ull path to the module directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/modules/" + this.getName();
        return(dir);
    }
    
}
