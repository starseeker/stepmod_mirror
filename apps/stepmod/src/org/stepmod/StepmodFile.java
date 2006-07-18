/**
 * $Id: AbstractModuleAction.java,v 1.3 2004/11/08 12:07:44 Patrick Exp $
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
        if (subDirectory.length() == 0) {
            return(name+ " (" +cvsRelease+")");
        } else {
            return(subDirectory+"/"+name+ " (" +cvsRelease+")");
        }
    }
    
}
