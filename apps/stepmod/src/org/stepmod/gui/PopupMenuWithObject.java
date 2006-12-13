/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * PopupMenuWithObject.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod.gui;

import javax.swing.JPopupMenu;

/**
 * PopupMenuWithObject extends JPopupMenu by associating a user defined object with the menu.
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
