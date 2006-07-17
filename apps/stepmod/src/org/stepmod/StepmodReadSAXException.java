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
