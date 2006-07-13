/*
 * $Id: StepmodResourceDoc.java,v 1.3 2006/07/12 18:10:24 robbod Exp $
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
        this.loadXml();
    }
    
    
    public void loadXml() {
    }
    
    /**
     * Provide the HTML body that is the summary of the part
     */
    public String summaryHtmlBody() {
        return "";
    }
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Resource documen: ISO 10303-239"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Resource document: ISO 10303-"+getPartNumber());
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
