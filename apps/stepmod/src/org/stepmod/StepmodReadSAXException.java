/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * StepmodReadSAXException.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod;

import org.xml.sax.SAXException;

/**
 * In a number of situations, there is only a requirement to read a sinlge element, or the attributes on a single element
 * So this exception can thrown by a SAX parser once all the required attributes or elements have been read.
 * It is a way of improving the efficiency of the sax parser
 * @author Rob Bodington
 */
public class StepmodReadSAXException extends SAXException{
    
    /** Creates a new instance of StepmodReadSAXException */
    public StepmodReadSAXException() {
    }
    
}
