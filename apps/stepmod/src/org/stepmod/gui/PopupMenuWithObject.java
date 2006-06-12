/**
 * $Id: PopupMenuWithObject.java,v 1.1 2006/04/26 08:54:38 RobB Exp $
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

package org.stepmod.gui;

import javax.swing.JPopupMenu;

/**
 * PopupMenuWithObject extends JPopupMenu by associating a user defnied object with the menu.
 * @author Rob Bodington
 */
public class PopupMenuWithObject extends JPopupMenu {
    
    private Object userObject;
    
    /** Creates a new instance of PopupMenuWithObject */
    public PopupMenuWithObject() {
        
    }

    public Object getUserObject() {
        return userObject;
    }

    public void setUserObject(Object userObject) {
        this.userObject = userObject;
    }
    
}
