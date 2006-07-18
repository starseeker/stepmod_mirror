/**
 * $Id: ExpressSaxHandler.java,v 1.1 2006/07/17 13:20:23 robbod Exp $
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

import java.util.HashMap;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author Rob Bodington
 */
public class ExpressSaxHandler extends DefaultHandler {
    
    private String currentElement;
    private StepmodPart part;
    private HashMap interfacedFiles = new  HashMap();
    private boolean hasInterfacedFiles = false;
    private String expressFile;
    private STEPmod stepMod;
    
    /**
     * Instantiate a Sax handler for reading the module.xml file
     */
    public ExpressSaxHandler(STEPmod stepMod, StepmodPart part, String expressFile) {
        this.part = part;
        this.expressFile = expressFile;
        this.stepMod = stepMod;
    }
    
    
    public void startElement(String namespaceURI, String sName, // simple name
            String qName, // qualified name
            Attributes attrs) throws SAXException {
        currentElement = qName;
        if (currentElement.equals("express")
        || currentElement.equals("application")
        || currentElement.equals("schema")) {
            // ignore the first part of the file
        }  else if (currentElement.equals("interface")) {
            hasInterfacedFiles = true;
            String schema = attrs.getValue("schema");
            StepmodPart part = null;
            if (schema.endsWith("_arm")) {
                String moduleName = schema.substring(0,schema.lastIndexOf("_arm")).toLowerCase();
                part = this.stepMod.getModuleByName(moduleName);
                if (part == null) {
                    // Part not loaded so add module so force it to be loaded
                    interfacedFiles.put(moduleName, "module");
                } else {
                    interfacedFiles.put(moduleName, part);
                }
            } else if (schema.endsWith("_mim")) {
                String moduleName = schema.substring(0,schema.lastIndexOf("_mim")).toLowerCase();
                part = this.stepMod.getModuleByName(moduleName);
                if (part == null) {
                    // Part not loaded so add module so force it to be loaded
                    interfacedFiles.put(moduleName, "module");
                } else {
                    interfacedFiles.put(moduleName, part);
                }
            } else {
                part = this.stepMod.getResourceByName(schema);
                if (part == null) {
                    // Part not loaded so add module so force it to be loaded
                    interfacedFiles.put(schema, "resource");
                } else {
                    interfacedFiles.put(schema, part);
                }
            }
        } else {
            // only interested in interface elements
            // throw back to the caller who should trap StepmodReadSAXException
            // and process results
            throw (new StepmodReadSAXException());
        }
    }
    
    
    public HashMap getInterfacedFiles() {
        return(interfacedFiles);
    }
    
    public boolean foundInterfacedFiles() {
        return(hasInterfacedFiles);
    }
}
