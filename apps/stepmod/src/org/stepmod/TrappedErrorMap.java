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

import java.util.TreeMap;

/**
 * A TrappedErrorMap is used to store errors that occur when reading files and parsing XML
 * These are caught and stored so that they can be presented back to the user
 * @author Rob Bodington
 */
public class TrappedErrorMap {    
    
    private TreeMap hasErrors;
    
    /**
     * The stepmodpart that gave rise to these errors
     */
    private StepmodPart stepmodPart;
    
    /** Creates a new instance of TrappedErrorMap */
    public TrappedErrorMap(StepmodPart stepmodPart) {
       hasErrors = new TreeMap();
       this.stepmodPart = stepmodPart;
    }
    
    public void clearErrors() {        
       hasErrors.clear();
    }
    
    /**
     * returns true if there are errors stored in the map
     */
    public boolean errorsExist() {
        return(hasErrors.size() > 0);
    }
    
    public TrappedError addError(StepmodPart stepmodPart, String filePath, java.lang.Exception exception) {
        int count = hasErrors.size()+1;
        String errorId = "Err-"+stepmodPart.getName() + count;
        TrappedError error = new TrappedError(errorId, stepmodPart, filePath, exception);
        hasErrors.put(errorId, error);
        return(error);
    }
    
    public TrappedError getError(String errorId) {
        return( (TrappedError) hasErrors.get(errorId));        
    }

    public StepmodPart getStepmodPart() {
        return stepmodPart;
    }
    
}
