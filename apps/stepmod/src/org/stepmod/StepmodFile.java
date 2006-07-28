/**
 * $Id: StepmodFile.java,v 1.1 2006/07/18 17:03:39 robbod Exp $
 *
 *
 * (c) Copyright 2006 Eurostep Limited
 * Cwttir Lane, St Asaph, Denbighshire, UK
 * All rights reserved.
 *
 *
 * This software is the confidential and proprietary information
 * of Eurostep Limited ("Confidential Information").  You
 * shall not disclose such Confidential Information and shall use
 * it only in accordance with the terms of the license agreement
 * you entered into with Eurostep Limited.
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
