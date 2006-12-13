/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * StepmodFile.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod;

/**
 *
 * @author Rob Bodington
 */
public class StepmodFile {
    
    private String name;
    private String subDirectory;
    private StepmodPart inPart;
    private String cvsRelease;
    private String cvsDate;
    
    
    /** Creates a new instance of StepmodFile */
    public StepmodFile(String name, String subDirectory, StepmodPart inPart, String cvsRelease, String cvsDate) {
        this.name = name;
        this.subDirectory = subDirectory;
        this.inPart = inPart;
        this.cvsRelease = cvsRelease;
        this.cvsDate = cvsDate;
    }
    
    public String toString() {
        if (getSubDirectory().length() == 0) {
            return(getName()+ " (" +getCvsRelease()+")");
        } else {
            return(getSubDirectory()+"/"+getName()+ " (" +getCvsRelease()+")");
        }
    }

    public String getCvsRelease() {
        return cvsRelease;
    }

    public String getCvsDate() {
        return cvsDate;
    }

    public String getName() {
        return name;
    }

    public String getSubDirectory() {
        return subDirectory;
    }
    
}
