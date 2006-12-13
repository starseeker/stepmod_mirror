/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * Approvals.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod;

/**
 *
 * @author jpe
 */

import java.io.*;
import javax.xml.parsers.*;
import javax.xml.xpath.*;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.stepmod.*;


public class Approvals {
    
    private STEPmod stepMod;
    
    public Approvals(STEPmod stepMod){
        this.stepMod = stepMod;
        
    }
    
   /**
     * Parses an XML file and returns a DOM document.
     * If validating is true, the contents is validated against the DTD
     * specified in the file.
     */
    public  Document parseXmlFile(String filename, boolean validating) {
        try {
            
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(validating);
            
            
            Document admin = factory.newDocumentBuilder().parse(new File(filename));
            return admin;
            
        } catch (SAXException e) {
            stepMod.output("A parsing error occurred; the xml input is not valid");
        } catch (ParserConfigurationException e) {
        } catch (IOException e) {
            e.printStackTrace();
            stepMod.output("error with file IO");
        }
        return null;
        
    }
    
    /**
     * Check method parses the document administration.xml then compares the 
     * value of "sforge_name" with the property "SFORGE_USERNAME.
     * The method is used to enable and disable administration menus in the GUI 
     * 
     * @return returns a boolean true or false
     */
    
    public boolean check(){
        
        Document administrators = parseXmlFile(stepMod.getRootDirectory()+"/config_management/administration.xml",false);
        Element root = administrators.getDocumentElement();
        if(root.getAttribute("sforge_name").equals(stepMod.getStepmodProperty("SFORGE_USERNAME"))){
            stepMod.output("results match");
            return true;
        }
        else{
            stepMod.output("authorization required");
            return false;
        }
        
        
    }
}

