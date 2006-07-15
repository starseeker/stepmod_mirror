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
 * A TrappedError is used to record errors that occur when reading files and parsing XML
 * These are caught and stored so that they can be presented back to the user
 * @author Rob Bodington
 */
public class TrappedError {
    
    /**
     * The execption that lead to the error
     */
    private java.lang.Exception exception;
    
    /**
     * The file being read when exception occured
     */
    private String filePath;
    
    /**
     * The StepmodPart that gave rise to the error
     */
    private StepmodPart stepmodPart;
    
    /**
     * The identifier of the error
     */
    private String errorId;
    
    private STEPmod stepMod;
    
    /** Creates a new instance of TrappedError */
    public TrappedError(String errorId, StepmodPart stepmodPart, String filePath, java.lang.Exception exception) {
        this.stepmodPart = stepmodPart;
        this.filePath = filePath;
        this.exception = exception;
        this.stepMod = stepmodPart.getStepMod();
        this.errorId = errorId;
    }
    
    public java.lang.Exception getException() {
        return exception;
    }
    
    public void setException(java.lang.Exception exception) {
        this.exception = exception;
    }
    
    public String getFilePath() {
        return filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    public StepmodPart getStepmodPart() {
        return stepmodPart;
    }
    
    public void setStepmodPart(StepmodPart stepmodPart) {
        this.stepmodPart = stepmodPart;
    }
    
    public void output() {
        String errorMsg = "Error: " + getErrorId() 
        + "\n in file: " + getFilePath() 
        + "\n" + getException().getMessage();
        stepMod.output(errorMsg);
    }
    
    public String getErrorId() {
        return errorId;
    }
    
    public void setErrorId(String errorId) {
        this.errorId = errorId;
    }
    
}
