/*
 * $Id: StepmodResource.java,v 1.1 2006/06/12 15:31:08 robbod Exp $
 *
 * StepmodResource.java
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

import org.stepmod.cvschk.CvsStatus;

/**
 *
 * @author rbn
 */
public class StepmodResource extends StepmodPart {
    
    /** Creates a new instance of StepmodResource */
    public StepmodResource(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
        stepMod.addResource(this);
        
        this.setCvsStatusObject(new CvsStatus(this, this.getDirectory(), ".xml"));
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
     * Returns the full path to the resources directory
     * @return The full path to the resources directory
     */
    public String getDirectory() {
        String dir = this.getStepMod().getRootDirectory()+"/data/resources/" + this.getName();
        return(dir);
    }
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Resource documen: ISO 10303-239"
     * @return a string containing the full part number
     */
    public String getPartNumberString() {
        return("Resource document: ISO 10303-"+getPartNumber());
    }
    
    public void setStepmodType() {
        this.stepmodType = "resource";
    }
    
    /**
     * returns the STEPmod type of the StepmodPart. Either:
     * module, resource_doc, application_protocol, resource
     */
    public String getStepmodType() {
        return stepmodType;
    }
    
    public String toString() {
        return(getName());
    }
    
    public void print() {
        System.out.println(getStepmodType()+": " + getName());
    }
    
}
