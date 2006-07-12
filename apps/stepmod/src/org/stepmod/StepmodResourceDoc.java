/*
 * $Id: StepmodResourceDoc.java,v 1.1 2006/06/12 15:31:08 robbod Exp $
 *
 * StepmodResourceDoc.java
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

/**
 *
 * @author rbn
 */
public class StepmodResourceDoc extends StepmodPart {
    
    /** Creates a new instance of StepmodResourceDoc */
    public StepmodResourceDoc(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
        // read the CM record
        this.readCmRecord();
        this.setStepmodType();
        stepMod.addResourceDoc(this);
        // now read resource.xml for the part populating the attributes
    }
    
    protected void setStepmodType() {
        this.stepmodType = "resource_doc";
    }
    
    /**
     * Returns the full path to the apDoc directory
     * @return The full path to the apDoc directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/resource_docs/" + this.getName();
        return(dir);
    }
    
    /**
     * Proved an HTML summary of the module
     */
    public String summaryHtml() {
        return("");
    }
}
