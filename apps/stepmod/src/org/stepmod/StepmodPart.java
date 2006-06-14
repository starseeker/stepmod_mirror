/*
 * $Id: StepmodPart.java,v 1.2 2006/06/13 08:34:36 robbod Exp $
 *
 * StepmodPart.java
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
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;
import org.stepmod.cvschk.StepmodAnt;

/**
 *
 * @author rbn
 */
public class StepmodPart {
    
    private String name;
    private String nameFrench;
    private String partNumber;
    private String version;
    protected String stepmodType;
    
    private String wgNumber;
    private String wgNumberSupersedes;
    private String checklistInternalReview;
    private String checklistProjectLeader;
    private String checklistConvener;
    private String status;
    private String language;
    private String publicationYear;
    private String publicationDate;
    private boolean published;
    private CmRecord cmRecord;
    private STEPmod stepMod;
    
    /**
     * The latest revision of the STEPmod part has been checked out
     */
    final public static int CVSSTATE_DEVELOPMENT = 1;
    
    /**
     * A release of the STEPmod part has been checked out
     */
    final public static int CVSSTATE_RELEASE = 2;
    
    /**
     * An ISO published release of the STEPmod part has been checked out
     */
    final public static int CVSSTATE_PUBLISHED = 3;
    
    /** Creates a new instance of StepmodPart */
    public StepmodPart(STEPmod stepMod, String partName) {
        setName(partName);
        setStepMod(stepMod);
    }
    
    /** Creates a new instance of StepmodPart */
    public StepmodPart() {
    }
    
    /**
     *  Read the cm_record.xml into the Cmrecord instance
     */
    public void readCmRecord() {
        cmRecord = new CmRecord(this);
        cmRecord.readCmRecord();
    }
    
    /**
     * Returns the name of StepmodPart
     * @return return the name of StepmodPart
     */
    public String getName() {
        return name;
    }
    
    /**
     * Sets the name of StepmodPart
     * @param name a String representing the name of StepmodPart
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * Returns the French name of StepmodPart
     * @return return the French name of StepmodPart
     */
    public String getNameFrench() {
        return nameFrench;
    }
    
    /**
     * Sets the French name of StepmodPart
     * @param nameFrench a String representing the French name of StepmodPart
     */
    public void setNameFrench(String nameFrench) {
        this.nameFrench = nameFrench;
    }
    
    /**
     * Returns a part number
     * @return return a part number
     *
     */
    public String getPartNumber() {
        return partNumber;
    }
    
    /**
     * Sets a part number
     * @param partNumber a String representing a partNumber
     */
    public void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }
    
    /**
     * Returns the version number of StepmodPart
     * @return return the version of StepmodPart
     */
    public String getVersion() {
        return version;
    }
    
    /**
     * Sets the version number of StepmodPart
     * @param version a String representing the version number of StepmodPart
     */
    
    public void setVersion(String version) {
        this.version = version;
    }
    
    /**
     * Returns the STEPmod type of the StepmodPart. Either:
     * module, resource_doc, application_protocol, resource
     */
    public String getStepmodType() {
        return stepmodType;
    }
    
    /**
     * Returns the wgNumber of the StepmodPart
     * @return return  the wgNumber of the StepmodPart
     */
    
    public String getWgNumber() {
        return wgNumber;
    }
    
    /**
     * Sets the wgNumber of the StepmodPart
     * @param wgNumber a String representing the wgNumber of the StepmodPart
     */
    public void setWgNumber(String wgNumber) {
        this.wgNumber = wgNumber;
    }
    
    /**
     * Returns the superseding wgNumber of the StepmodPart
     * @return return the wgNumberSupersedes of the StepmodPart
     */
    public String getWgNumberSupersedes() {
        return wgNumberSupersedes;
    }
    
    /**
     * Sets the superseding wgNumber of the StepmodPart
     * @param wgNumberSupersedes a String representing the wgNumberSupersedes
     * of the StepmodPart
     */
    public void setWgNumberSupersedes(String wgNumberSupersedes) {
        this.wgNumberSupersedes = wgNumberSupersedes;
    }
    
    /**
     * Returns the checklist for Internal review of the StepmodPart
     * @ return return the checklist for Internal Review of the StepmodPart
     */
    public String getChecklistInternalReview() {
        return checklistInternalReview;
    }
    
    /**
     * Sets the checklist for Internal review of the StepmodPart
     * @param checklistInternalReview a String representing the checklist for Internal Review
     * of the StepmodPart
     */
    public void setChecklistInternalReview(String checklistInternalReview) {
        this.checklistInternalReview = checklistInternalReview;
    }
    
    /**
     *  Returns the checklist for a Project leader of the StepmodPart
     *  @return return the checklist for a Project Leader of the StepmodPart
     */
    public String getChecklistProjectLeader() {
        return checklistProjectLeader;
    }
    
    /**
     * Sets the checklist for a Project leader of the StepmodPart
     * @param checklistProjectLeader a String representing the checklist for a Project Leader
     * of the StepmodPart
     */
    public void setChecklistProjectLeader(String checklistProjectLeader) {
        this.checklistProjectLeader = checklistProjectLeader;
    }
    
    /**
     * Returns the checklistconvener of the StepmodPart
     * @return return the checklistConvener of the StepmodPart
     */
    public String getChecklistConvener() {
        return checklistConvener;
    }
    
    /**
     * Sets the checklistConvener of the StepmodPart
     * @param checklistConvener a String representing the checklistConvener
     * of the StepmodPart
     */
    
    public void setChecklistConvener(String checklistConvener) {
        this.checklistConvener = checklistConvener;
    }
    
    /**
     * Returns the status of the StepmodPart
     * @return return status
     */
    public String getStatus() {
        return status;
    }
    
    /**
     * Sets the status of the StepmodPart
     * @param status a String representing the status of the StepmodPart
     */
    public void setStatus(String status) {
        this.status = status;
    }
    
    /**
     * Returns the language of the StepmodPart
     * @return return the language of the StepmodPart
     */
    public String getLanguage() {
        return language;
    }
    
    /**
     * Sets the language of the StepmodPart
     * @param language a String representig the language of the StepmodPart
     */
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    /**
     * Return the publication year
     * @return return the year of publication for the StepmodPart
     */
    public String getPublicationYear() {
        return publicationYear;
    }
    
    /**
     * Sets the publication year
     * @param publicationYear a String representing the year of publication of the StepmodPart
     */
    public void setPublicationYear(String publicationYear) {
        this.publicationYear = publicationYear;
    }
    
    /**
     * Returns a publication date for a StepmodPart
     * @return return the publication date for the StepmodPart
     */
    public String getPublicationDate() {
        return publicationDate;
    }
    
    /**
     * Sets the publication date
     * @param publicationDate a String representing the date of publication for
     * the StepmodPart
     */
    public void setPublicationDate(String publicationDate) {
        this.publicationDate = publicationDate;
    }
    
    /**
     * Returns whether the StepmodPart has been published or not
     * @return boolean published
     */
    public Boolean getPublished() {
        return published;
    }
    
    /**
     * Sets whether the StepmodPart has been published or not
     * @param published a boolean stating true or false
     */
    public void setPublished(boolean published) {
        this.published = published;
    }
    
    /**
     * Returns the configuration management record
     * @return the configuration management record for the StepmodPart
     */
    public CmRecord getCmRecord() {
        return cmRecord;
    }
    
    /**
     * Sets the configuration management record for the StepmodPart
     * @param cmRecord an instance of a CmRecord
     */
    public void setCmRecord(CmRecord cmRecord) {
        this.cmRecord = cmRecord;
    }
    
    /**
     * returns the part number and name
     * @return the Stepmodpart number and name as a String
     */
    public String toString() {
        return(getPartNumber() + ": "+ getName());
    }
    
    /**
     * prints out the StepmodPart type and name
     */
    
    public void print() {
        System.out.println(getStepmodType()+": " + getName());
    }
    
    /**
     * Returns an instance of StepMod
     * @return return the created instance of StepMod
     */
    public STEPmod getStepMod() {
        return stepMod;
    }
    
    /**
     * Sets the value of Stepmod to the created instance
     * @param stepMod is an instance of StepMod
     */
    public void setStepMod(STEPmod stepMod) {
        this.stepMod = stepMod;
    }
    
    
    /**
     * Returns the cvs configuration state of the part
     */
    public int getCvsState() {
        // check if the part has a Tag file in the CVS directory.
        // If No then it is a development version
        // If yes, findout whether the Tag corresponds to a release or a publication
        return(this.CVSSTATE_PUBLISHED);
    }
    
    
    
    
    
    /**
     * @rbn
     * Use StepModAnt to execute a CVS update
     * Creates a new instance of StepmodAnt and executes the method runCvs
     * passing in the paramaters based on the module selected
     */
    public void cvsUpdateDevelopmentRevision() {
        StepmodAnt stpAnt = new StepmodAnt();
        stpAnt.runCvs( getStepMod(), getName(), "data/modules/"+getName(), "update" );
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of
     * a specified release
     *
     */
    public void cvsCoRelease() {
        
        getStepMod().getStepModGui().toBeDone("StepmodPart.cvsCoRelease");
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of the
     * latest release
     *
     */
    
    public void cvsCoLatestRelease() {
        
        getStepMod().getStepModGui().toBeDone("StepmodPart.cvsCoLatestRelease");
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of the latest
     * published release
     *
     */
    public void cvsCoPublishedRelease() {
        
        getStepMod().getStepModGui().toBeDone("StepmodPart.cvsCoPublishedRelease");
    }
    
    /**
     *  Use StepModAnt to tag and commit a CMRecord
     */
    
    public void cvsTagRecord() {
        
        getStepMod().getStepModGui().toBeDone("StepmodPart.cvsTagRecord");
    }
    
    
}
