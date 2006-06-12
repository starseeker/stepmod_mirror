package org.stepmod;

import java.io.FileWriter;
import java.io.IOException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
/*
 * $Id: CmRelease.java,v 1.3 2006/05/02 18:24:53 RobB Exp $
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
    
    private String status;
    
    private String who;
    
    private String edition;
    
    private String releaseSequence;
    
    private String stepmodRelease;
    
    private String releaseDate;
    
    private CmRecord inRecord;
    
    private int dependencies_ref;
    
    /**
     * Create a new release for the CM record
     */
    public CmRelease(CmRecord cmRecord, String id, String description, String status,
            String who, String edition, String releaseSequence,
            String stepmodRelease, String releaseDate) {
        setInRecord(cmRecord);
        cmRecord.addCmReleaseToReleases(this);
        setId(id);
        setDescription(description);
        setStatus(status);
        setWho(who);
        setEdition(edition);
        setReleaseSequence(releaseSequence);
        setStepmodRelease(stepmodRelease);
        setReleaseDate(releaseDate);
    }
    
    /**
     * Create a new release for the CM record
     */
    public CmRelease(CmRecord cmRecord) {
        setInRecord(cmRecord);
        cmRecord.addCmReleaseToReleases(this);
        setReleaseSequence( "r"+cmRecord.getHasCmReleases().size());
        // Get today's date
        Date date = new Date();
        Format formatter = new SimpleDateFormat("yyyyMMdd");
        setReleaseDate(formatter.format(date));
        StepmodPart part = getInRecord().getStepmodPart();
        setId( part.getName() +
                "-" + part.getVersion()  +
                "-" + part.getStatus() +
                "-" + getReleaseDate()
                );
    }
    
    void writeToStream(FileWriter out) throws IOException {
        out.write("   <cm_release\n");
        out.write("      release=\""+ getId() +"\"");
        out.write("      who=\""+ getWho() +"\"");
        out.write("      when=\""+ getReleaseDate() +"\" ");
        out.write("      stepmod_release=\""+ getStepmodRelease() +"\"");
        out.write("      status=\""+ getStatus() +"\" ");
        out.write("      release_sequence=\""+ getReleaseSequence() +"\"");
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
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
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
    
    public String summaryHtml() {
        String summary = "<html><body>";
        StepmodPart part = getInRecord().getStepmodPart();
        summary = summary + "<h1>Part: "+ part.getName() + "</h1><h2> CM release:" + getId()+"</h2>";
        summary = summary + "<ul>";
        summary = summary + "<li> Released by:" + getWho() + "</li>";
        summary = summary + "<li> Released on:" + getReleaseDate() + "</li>";
        summary = summary + "<li> Status:" + getStatus() + "</li>";
        summary = summary + "</ul>";
        summary = summary + "</body></html>";
        return(summary);
    }
}
