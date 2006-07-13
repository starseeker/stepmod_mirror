package org.stepmod;

import java.io.FileWriter;
import java.io.IOException;
import org.stepmod.cvschk.CvsStatus;
/*
 * $Id: CmRelease.java,v 1.5 2006/07/12 18:10:24 robbod Exp $
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

public class CmRelease {
    private String id;
    
    private String description;
    
    private String isoStatus;
    
    private String releaseStatus;
    
    private String who;
    
    private String edition;
    
    private String releaseSequence;
    
    private String stepmodRelease;
    
    private String releaseDate;
    
    private CmRecord inRecord;
    
    private int dependencies_ref;
    
    /**
     * Create a new release for the CM record - only used when reading releases from CM record file
     */
    public CmRelease(CmRecord cmRecord, String id, String description,
            String isoStatus, String releaseStatus,
            String who, String edition, String releaseSequence,
            String stepmodRelease, String releaseDate) {
        setInRecord(cmRecord);
        cmRecord.addCmReleaseToReleases(this);
        setId(id);
        setDescription(description);
        setIsoStatus(isoStatus);
        setReleaseStatus(releaseStatus);
        setWho(who);
        setEdition(edition);
        setReleaseSequence(releaseSequence);
        setStepmodRelease(stepmodRelease);
        setReleaseDate(releaseDate);
    }
    
    
    
    /**
     * Create a new release for the CM record
     * Note - a release must be explicitly written to the cm_record.xml file by
     * writing the record invoking the {@link updateCmRecordFile} on the StepmodPart
     * @param  part the part that is being release
     * @param  who the person who is creating the release
     * @param  releaseStatus the release status
     * @param   description the description of the release
     * @return the CmRelease object that has been created.
     */
    public CmRelease(StepmodPart part, String who, String releaseStatus, String description) {
        CmRecord cmRecord = part.getCmRecord();
        setInRecord(cmRecord);
        cmRecord.addCmReleaseToReleases(this);
        
        try {
            cmRecord.setModified(CmRecord.CM_RECORD_CHANGED_NOT_SAVED);
            setReleaseDate(part.getReleaseDate());
            setEdition(part.getVersion());
            setIsoStatus(part.getIsoStatus());
            setReleaseStatus(releaseStatus);
            setId(part.getNextReleaseId());
            setWho(who);
            setStepmodRelease(part.getStepMod().getStepmodRelease());
            setDescription(description);} catch (Exception ex) {
                ex.printStackTrace();
            }
    }
    
    void writeToStream(FileWriter out) throws IOException {
        out.write("   <cm_release\n");
        out.write("      release=\""+ getId() +"\"");
        out.write("      who=\""+ getWho() +"\"");
        out.write("      when=\""+ getReleaseDate() +"\" ");
        out.write("      stepmod_release=\""+ getStepmodRelease() +"\"");
        out.write("      iso_status=\""+ getIsoStatus() +"\" ");
        out.write("      release_status=\""+ getReleaseStatus() +"\" ");
        //out.write("      release_sequence=\""+ getReleaseSequence() +"\"");
        out.write("      edition=\""+ getEdition() +"\" ");
        out.write("      description=\""+ getDescription() +"\">");
        
        out.write("   </cm_release>\n");
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getIsoStatus() {
        return isoStatus;
    }
    
    public void setIsoStatus(String status) {
        this.isoStatus = status;
    }
    
    public String getReleaseStatus() {
        return releaseStatus;
    }
    
    public void setReleaseStatus(String status) {
        this.releaseStatus = status;
    }
    
    /**
     * Set the release status, updating the Cmrecord of the fact that a release has been modified
     */
    public void setReleaseStatus(String status, boolean cmRecordUpdate) {
        if (cmRecordUpdate && (this.releaseStatus != status)) {
            this.releaseStatus = status;
            try {
                getInRecord().setModified(CmRecord.CM_RECORD_CHANGED_NOT_SAVED);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
    
    public String getWho() {
        return who;
    }
    
    public void setWho(String who) {
        this.who = who;
    }
    
    public String getEdition() {
        return edition;
    }
    
    public void setEdition(String edition) {
        this.edition = edition;
    }
    
    public String getReleaseSequence() {
        return releaseSequence;
    }
    
    public void setReleaseSequence(String releaseSequence) {
        this.releaseSequence = releaseSequence;
    }
    
    public String getStepmodRelease() {
        return stepmodRelease;
    }
    
    public void setStepmodRelease(String stepmodRelease) {
        this.stepmodRelease = stepmodRelease;
    }
    
    public String getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public CmRecord getInRecord() {
        return inRecord;
    }
    
    public void setInRecord(CmRecord inRecord) {
        this.inRecord = inRecord;
    }
    
    public int getDependencies_ref() {
        return dependencies_ref;
    }
    
    public void setDependencies_ref(int dependencies_ref) {
        this.dependencies_ref = dependencies_ref;
    }
    
    public String toString() {
        return(id);
    }
    
    /**
     * Return true if this release is the one that has been checked out by CVS
     */
    public boolean isCheckedOutRelease() {
        return(getInRecord().getCheckedOutRelease() == this);
    }
    
    /**
     * Return true if this release has been published by ISO
     * Note - publication is determined by the release_status in the cm_record.xml
     * being not by anything recorded in the module
     */
    public boolean isPublishedIsoRelease() {
        String relStatus = getReleaseStatus();
        if (relStatus != null) {
            return(relStatus.equals("ISO publication"));
        } else {
            return(false);
        }
    }
    
    
}
