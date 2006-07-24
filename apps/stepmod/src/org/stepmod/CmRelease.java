package org.stepmod;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.TreeSet;
/*
 * $Id: CmRelease.java,v 1.9 2006/07/20 17:12:24 robbod Exp $
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
    
    /**
     * A list of all the parts (modules and resource schemas) on which the released part is dependent
     * These parts are not necessarily the ones loaded - they may well be at a different revision level.
     */
    private TreeSet dependentParts = null;
    
    
    /**
     * A map of all the files that this part depends on.
     */
    private TreeMap dependentFiles = null;
    
    
    
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
        // the dependencies will be read from the file
        dependentParts = new TreeSet();
        dependentFiles = new TreeMap();
    }
    
    
    
    /**
     * Create a new release for the CM record
     * The release will use the dependent parts currently checked out
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
        cmRecord.setRecordState(CmRecord.CM_RECORD_CHANGED_NOT_SAVED);
        setReleaseDate(part.getReleaseDate());
        setEdition(part.getVersion());
        setIsoStatus(part.getIsoStatus());
        setReleaseStatus(releaseStatus);
        setId(part.getNextReleaseId());
        setWho(who);
        setStepmodRelease(part.getStepMod().getStepmodRelease());
        setDescription(description);
        // Make sure that the dependencies for the part are loaded
        setupDependencies();
    }
    
    /**
     * Return the part that this is a release for
     */
    public StepmodPart getStepmodPart() {
        return(getInRecord().getStepmodPart());
    }
    
    /**
     * Return the Stepmod instance that contains this release
     */
    public STEPmod getStepMod() {
        return(getInRecord().getStepMod());
    }
    
    public void setupDependencies() {
        dependentParts = new TreeSet();
        // Make sure that the dependencies for the part are loaded
        StepmodPart part = getStepmodPart();
        STEPmod stepMod = part.getStepMod();
        part.setupDependencies();
        for (Iterator it = part.getDependentParts().iterator(); it.hasNext();) {
            String dependentPartName = (String)it.next();
            StepmodPart dependentPart = stepMod.getPartByName(dependentPartName);
            String partCmRelease = dependentPart.getCvsTag();
            int partType;
            if (dependentPart instanceof StepmodModule) {
                partType = StepmodPartCM.IS_A_MODULE;
            } else {
                partType = StepmodPartCM.IS_A_RESOURCESCHEMA;
            }
            this.addDependentPart(new StepmodPartCM(dependentPart.getName(), dependentPart.getPartNumber(), partCmRelease, partType, this));
        }
        dependentFiles = new TreeMap();
        dependentFiles.putAll(part.getDependentFiles());
    }
    
    public void writeToStream(FileWriter out) throws IOException {
        out.write("   <cm_release\n");
        out.write("      release=\""+ getId() +"\"\n");
        out.write("      who=\""+ getWho() +"\"\n");
        out.write("      when=\""+ getReleaseDate() +"\"\n");
        out.write("      stepmod_release=\""+ getStepmodRelease() +"\"\n");
        out.write("      iso_status=\""+ getIsoStatus() +"\"\n");
        out.write("      release_status=\""+ getReleaseStatus() +"\"\n");
        //out.write("      release_sequence=\""+ getReleaseSequence() +"\"\n");
        out.write("      edition=\""+ getEdition() +"\"\n");
        out.write("      description=\""+ getDescription() +"\">\n");
        TreeSet dependentParts = null;
        out.write("    <dependencies>\n");
        out.write("      <sources>\n");
        out.write("      </sources>\n");
        
        STEPmod stepMod = getStepMod();
        dependentParts = getDependentParts();
        
        out.write("      <modules>\n");
        for (Iterator it = dependentParts.iterator(); it.hasNext();) {
            StepmodPartCM dependentPart = (StepmodPartCM)it.next();
            String cmRelease = dependentPart.getCmRelease();
            if (cmRelease.length() == 0) {
                // must be a development release
                cmRelease = "Development release";
            }
            
            if (dependentPart.isaModule()) {
                out.write("        <module name=\""+dependentPart.getName()
                +"\" part=\""+dependentPart.getPartNumber()
                +"\" release=\""+cmRelease+"\"/>\n");
            }
        }
        out.write("      </modules>\n");
        
        out.write("      <resource_schemas>\n");
        for (Iterator it = dependentParts.iterator(); it.hasNext();) {
            StepmodPartCM dependentPart = (StepmodPartCM)it.next();
            String cmRelease = dependentPart.getCmRelease();
            if (cmRelease.length() == 0) {
                // must be a development release
                cmRelease = "Development release";
            }
            if (dependentPart.isaResourceSchema()) {
                out.write("        <resource name=\""+dependentPart.getName()
                +"\" part=\""+dependentPart.getPartNumber()
                +"\" release=\""+cmRelease+"\"/>\n");
            }
        }
        out.write("      </resource_schemas>\n");
        out.write("    </dependencies>\n");
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
            getInRecord().setRecordState(CmRecord.CM_RECORD_CHANGED_NOT_SAVED);
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
    
    public TreeMap getDependentFiles() {
        return dependentFiles;
    }
    
    public TreeSet getDependentParts() {
        return dependentParts;
    }
    
    public void addDependentPart(StepmodPartCM part) {
        dependentParts.add(part);
    }
    
    public void addDependentFile(StepmodFile file) {
        dependentFiles.put(file.toString(),file);
    }
    
    /**
     * Answer true if all the dependencies of the release are the expected releases
     */
    public boolean isDependenciesCheckedOut() {
        for (Iterator it = this.getDependentParts().iterator(); it.hasNext();) {
            StepmodPartCM dependentPart = (StepmodPartCM)it.next();
            if (!dependentPart.isCheckedOut()) {
                return(false);
            }
        }
        return(true);
    }
}
