/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * TrappedError.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
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
        + "\n in part: " + getStepmodPart()
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
