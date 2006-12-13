/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * StepmodPartCM.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod;

import org.stepmod.cvschk.CvsStatus;

/**
 * A class representing a module that is being referred to from within a CM record
 * @author rbn
 */
public class StepmodPartCM implements Comparable {
    
    /**
     * The identifier for the CM release of this part
     */
    private String cmRelease;
    
    /**
     * The name of the part
     */
    private String name;
    
    /**
     * The part number
     */
    private String partNumber;
    
    /**
     * The actual part that this part record is depedent on
     */
    private StepmodPart inPart;
    
    /**
     * The release that identified this part record
     */
    private CmRelease inCmRelease;
    
    private int type;
    
    public static final int IS_A_MODULE = 1;
    public static final int IS_A_RESOURCESCHEMA = 2;
    
    
    /**
     * Creates a new instance of StepmodPartCM
     */
    public StepmodPartCM(String name, String partNumber, String cmRelease, int type, CmRelease inCmRelease) {
        this.name = name;
        this.partNumber = partNumber;
        this.cmRelease = cmRelease;
        this.type = type;
        this.inCmRelease = inCmRelease;
    }
    
    public String getCmRelease() {
        return cmRelease;
    }
    
    public String getName() {
        return name;
    }
    
    public String getPartNumber() {
        return partNumber;
    }
    
    public boolean isaModule() {
        return(type == IS_A_MODULE);
    }
    
    public boolean isaResourceSchema() {
        return(type == IS_A_RESOURCESCHEMA);
    }
    
    public String toString() {
        return(this.name);
    }
    
    public int compareTo(Object o) {
        StepmodPartCM stepmodPartCM = (StepmodPartCM) o;
        return(name.compareTo(stepmodPartCM.getName()));
    }
    
    public int compare(Object o1, Object o2) {
        StepmodPartCM stepmodPartCM1 = (StepmodPartCM) o1;
        StepmodPartCM stepmodPartCM2 = (StepmodPartCM) o2;
        return(stepmodPartCM1.getName().compareTo(stepmodPartCM2.getName()));
    }
    
    /**
     * Provide an HTML summary of the part
     */
    public String summaryHtml() {
        String summary = "<html><body>"
                + "<h2>"+getPartNumberString()+"</h2>"
                + this.summaryHtmlBody()
                + "</body></html>";
        return(summary);
    }
    
    
    public StepmodPart getStepmodPart() {
        STEPmod stepMod = this.inCmRelease.getStepMod();
        return (stepMod.getPartByName(this.getName()));
    }
    
    public CmRecord getCmRecord() {
        return(inCmRelease.getInRecord());
    }
    
    /**
     * Return true if this revision of the part recorded in StepmodPartCM is the same as the revision of the part checked out.
     */
    public boolean isCheckedOut() {
        String cvsStateDscr = getPartRevision();
        String partRel = this.getCmRelease();
        return(cvsStateDscr.equals(this.getCmRelease()));
    }
    
    
    public String getPartRevision() {
        StepmodPart part = getStepmodPart();
        String cvsStateDscr = "";
        if (part != null) {
            int cvsState = part.getCvsState();
            if (cvsState == CvsStatus.CVSSTATE_UNKNOWN) {
                cvsStateDscr = "ERROR -- Release status cannot be established";
            } else if (cvsState == CvsStatus.CVSSTATE_DEVELOPMENT) {
                cvsStateDscr = "Development release";
            } else if (cvsState == CvsStatus.CVSSTATE_RELEASE) {
                cvsStateDscr =  part.getCvsTag();
            } else {
                cvsStateDscr = "ERROR - the part has not been checked out";
            }
        }
        return(cvsStateDscr);
    }
    
    /**
     * Provide the HTML body that is the summary of the part
     */
    public String summaryHtmlBody() {
        StepmodPart part = getStepmodPart();
        String cvsStateDscr = getPartRevision();
        String cmDescr = "";
        if (part != null) {
            
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
        }
        String partRel = this.getCmRelease();        
        if (!isCheckedOut()) {
            partRel += " <b><em>(Different to the checked out release)</b></em>";
        }
        String summary =
                "<table>"
                + "<tr><td>Part Name:</td><td>" + getName()+"</td></tr>"
                + "<tr><td>Part Number:</td><td>" + getPartNumberString()+"</td></tr>"
                + "<tr><td>Checked out release:</td><td>" + cvsStateDscr +"</td></tr>"
                + "<tr><td>Part release:</td><td>" + partRel +"</td></tr>"
                + "<tr><td>CM record revision:</td><td>" + getCmRecord().getCvsRevision() +"</td></tr>"
                + "<tr><td>CM record date:</td><td>" + getCmRecord().getCvsDate() +"</td></tr>"
                + "<tr><td>CM record status:</td><td>" + cmDescr +"</td></tr>"
                + "</table>";
        return(summary);
    }
    
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Module: ISO 10303-439"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        if (this.isaModule()) {
            return("Module: ISO 10303-"+getPartNumber());
        } else {
            return("Resource schema: " + getPartNumber());
        }
    }
    
}
