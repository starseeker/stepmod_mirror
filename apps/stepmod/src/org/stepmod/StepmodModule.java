/*
 * $Id: StepmodModule.java,v 1.8 2006/07/14 07:27:23 robbod Exp $
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
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
    private String sc4WorkingGroup;
    
    
    
    /**
     * Creates a new instance of StepmodModule
     */
    public StepmodModule(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
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
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            String moduleFilename = this.getDirectory() + "/module.xml";
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
     * Returns a string containing the full part number.
     * E.g. "Module: ISO 10303-439"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Module: ISO 10303-"+getPartNumber());
    }
    
    
    /**
     * Provide the HTML body that is the summary of the part
     */
    public String summaryHtmlBody() {
        String cvsStateDscr = "";
        int cvsState = getCvsState();
        if (cvsState == CvsStatus.CVSSTATE_UNKNOWN) {
            cvsStateDscr = "ERROR -- Release status cannot be established";
        } else if (cvsState == CvsStatus.CVSSTATE_DEVELOPMENT) {
            cvsStateDscr = "Latest development release";
        } else if (cvsState == CvsStatus.CVSSTATE_RELEASE) {
            cvsStateDscr =  this.getCvsTag();
        }
        
        String cmDescr = "";
        int cmRecordState = getCmRecord().getCmRecordCvsStatus();
//        if (cmRecordState == CmRecord.CM_RECORD_NOT_CHANGED) {
//            cmDescr = "CM record modified but not saved to cm_record.xml";
//        } else 
        if (cmRecordState == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
            cmDescr = "CM record modified but not saved to cm_record.xml";
        } 
//        else if (cmRecordState == CmRecord.CM_RECORD_CHANGED_SAVED) {
//            cmDescr = " CM record modified and saved to cm_record.xml";
//        }else 
        else if (cmRecordState == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
            cmDescr = "The CM record file, cm_record.xml, does not exist for this part";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_NOT_ADDED) {
            cmDescr = "The CM record file, cm_record.xml, exists but has not been added to CVS";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_ADDED) {
            cmDescr = "The CM record file, cm_record.xml, has been added to CVS but not committed";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_COMMITTED) {
            cmDescr = "The CM record file, cm_record.xml, has been committed to CVS";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_CHANGED) {
            cmDescr = "The CM record file, cm_record.xml, has  been committed to CVS but the local file has changed";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED) {
            cmDescr = " The CM record file, cm_record.xml, exists but the record directory has not been added to CVS";
        }
        
        String summary =
                "<table>"
                + "<tr><td>Part Number:</td><td>"+getPartNumberString()+"</td></tr>"
                + "<tr><td>Part Name:</td><td>"+getName()+"</td></tr>"
                + "<tr><td>Checked out release:</td><td>" + cvsStateDscr +"</td></tr>"
                + "<tr><td>CM record revision:</td><td>" + getCmRecord().getCvsRevision() +"</td></tr>"
                + "<tr><td>CM record date:</td><td>" + getCmRecord().getCvsDate() +"</td></tr>"
                + "<tr><td>CM record status:</td><td>" + cmDescr +"</td></tr>"
                + "</table>";
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
     * @return The full path to the module directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/modules/" + this.getName();
        return(dir);
    }
    
    
    
}
