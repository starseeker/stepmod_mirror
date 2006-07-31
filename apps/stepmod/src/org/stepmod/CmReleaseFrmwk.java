/*
 * $Id: express_code.xsl,v 1.5 2005/06/13 16:56:06 robbod Exp $
 *
 * CmReleaseFrmwk.java
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

import java.io.FileWriter;
import java.io.IOException;

/**
 *
 * @author rbn
 */
public class CmReleaseFrmwk {
    
    private String id;
    
    private String description;
    
    private String who;
    
    private String releaseDate;
    
    private CmRecordFrmwk inRecord;
    
    /** Creates a new instance of CmReleaseFrmwk */
    public CmReleaseFrmwk(CmRecordFrmwk cmRecord, String id, String description,
            String who, String releaseDate) {
        setInRecord(cmRecord);
        cmRecord.addCmReleaseToReleases(this);
        setId(id);
        setDescription(description);
        setWho(who);
        setReleaseDate(releaseDate);
    }
    
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getWho() {
        return who;
    }
    
    public void setWho(String who) {
        this.who = who;
    }
    
    public String getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public CmRecordFrmwk getInRecord() {
        return inRecord;
    }
    
    public void setInRecord(CmRecordFrmwk inRecord) {
        this.inRecord = inRecord;
    }
    
    public void writeToStream(FileWriter out) throws IOException {
        out.write("   <cm_release\n");
        out.write("      release=\""+ getId() +"\"\n");
        out.write("      who=\""+ getWho() +"\"\n");
        out.write("      when=\""+ getReleaseDate() +"\"\n");
        out.write("      description=\""+ getDescription() +"\"/>\n");
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
}
