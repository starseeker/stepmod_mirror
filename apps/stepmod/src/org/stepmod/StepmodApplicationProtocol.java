/*
 * $Id: StepmodApplicationProtocol.java,v 1.2 2006/04/26 08:55:50 RobB Exp $
 *
 * StepmodApplicationProtocol.java
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
public class StepmodApplicationProtocol extends StepmodPart {
    
    /** Creates a new instance of StepmodApplicationProtocol */
    public StepmodApplicationProtocol(STEPmod stepMod, String partName) {
        this.setName(partName);
        this.setStepmodType();
        this.setStepMod(stepMod);
        // read the CM record
        this.readCmRecord();
        stepMod.addApplicationProtocol(this);
        // now read application_protocol.xml for the part populating the attributes
    }
    
    private void setStepmodType() {
        this.stepmodType = "application_protocol";
    }
    
}
