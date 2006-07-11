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

package org.stepmod.cvschk;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.stepmod.StepmodPart;

/**
 *
 * @author Rob Bodington
 */
public class CvsStatus {
    
    
    private int cvsState;
    private String cvsTag;
    
    /**
     * The part for which the CVS status is being determined
     */
    private StepmodPart part;
    
    /**
     * The directory for in whihc all part files are stored.
     * E.g stepmod/data/modules/actvity
     */
    private String partDirectory;
    
    /**
     * The main file for the part whihc is used to determine the CV Status
     * For modules: module.xml
     * For APs: applciation_protocol.xml
     */
    private String partMainFile;
    
    /**
     * It is not known what CVS state STEPmod part is in
     * Need to query the Root file to find out
     */
    final public static int CVSSTATE_UNKNOWN= 0;
    
    /**
     * The latest revision of the STEPmod part has been checked out
     */
    final public static int CVSSTATE_DEVELOPMENT = 1;
    
    /**
     * A release of the STEPmod part has been checked out
     */
    final public static int CVSSTATE_RELEASE = 2;
    
    
    /** Creates a new instance of CvsStatus */
    public CvsStatus(StepmodPart part, String partDir, String partMainFile) {
        this.part = part;
        this.partDirectory = partDir;
        this.partMainFile = partMainFile;
        this.updateCvsStatus();
    }
    
    /**
     * Sets up the CVS status by reading from the Entires file in the CVS directory
     * Sets the cvsState and cvTag
     * @return returns 0 if the CVS information was successuly reads. 
     * returns -1 if not.
     */
    public int updateCvsStatus() {
        int retVal = 0;
        String cvsEntriesFile = this.getPartDirectory() + "/CVS/Entries";
        try {
            BufferedReader in = new BufferedReader(new FileReader(cvsEntriesFile));
            String str;
            Pattern mainfilePattern = Pattern.compile("^/"+this.getPartMainFile()+"/.*$");
            while ((str = in.readLine()) != null) {
                Matcher m = mainfilePattern.matcher(str);
                if (m.matches()) {
                    // Found the line with the mail file in. E.g. /module.xml/
                    // If the entry ends with / then it is the development version
                    // otherwise it will end with the CVS tag
                    if (str.endsWith("/")) {
                        this.cvsState = this.CVSSTATE_DEVELOPMENT;
                        this.cvsTag = "";
                    } else {
                        this.cvsState = this.CVSSTATE_RELEASE;
                        String tag = str.substring(str.lastIndexOf("/")+2);
                        this.setCvsTag(tag);
                    }
                }
            }
            in.close();
        } catch (IOException e) {
            retVal = -1;
        }
        return(retVal);
    }
    
    
    /**
     * Returns the cvs configuration state of the part
     */
    public int getCvsState() {
        // check if the part has a Tag file in the CVS directory.
        // If No then it is a development version
        // If yes, findout whether the Tag corresponds to a release or a publication
        if (this.cvsState == this.CVSSTATE_UNKNOWN) {
            this.updateCvsStatus();
        }
        return(this.cvsState);
    }
    
    public void setCvsState(int cvsState) {
        this.cvsState = cvsState;
    }
    
    public String getCvsTag() {
        return cvsTag;
    }
    
    public void setCvsTag(String cvsTag) {
        this.cvsTag = cvsTag;
    }
    
    public StepmodPart getPart() {
        return part;
    }
    
    public String getPartDirectory() {
        return partDirectory;
    }
    
    public String getPartMainFile() {
        return partMainFile;
    }
    
}
