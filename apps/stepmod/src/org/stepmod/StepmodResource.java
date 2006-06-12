/*
 * $Id: StepmodResource.java,v 1.2 2006/04/26 08:55:50 RobB Exp $
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

/**
 *
 * @author rbn
 */
public class StepmodResource {
    
    private String name;
    private String stepmodType;
    
    /** Creates a new instance of StepmodResource */
    public StepmodResource(STEPmod stepMod, String partName) {
        this.name = partName;
        this.setStepmodType();
        stepMod.addResource(this);
    }
    
    String getName() {
        return (name);
    }
    
    private void setStepmodType() {
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
