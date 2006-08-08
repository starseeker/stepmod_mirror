/**
 * $Id: StepmodCvs.java,v 1.6 2006/07/27 15:13:54 robbod Exp $
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
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.stepmod.STEPmod;
import org.stepmod.gui.STEPModFrame;

/**
 * StepmodCvs provides a facility to execute CVS tasks.
 * It requires the cvsnt to be installed and the path to the executable set up in stepmod.properties.
 * It also requires the sourceforge user name to be set up in stepmod.properties
 * @author Rob Bodington
 */
public class StepmodCvs {
    
    private STEPmod stepMod;
    private String cvsCommand;
    private int cvsExitVal;
    private int cvsErrorVal ;
    private String cvsMessages;
    private String cvsExecDirectory;
    
    /**
     * CVS properties stored in stepmod.properties OK
     */
    public static final int CVS_ERROR_OK = 0;
    
    /**
     * SFORGE_USERNAME CVS properties stored in stepmod.properties incorrect
     */
    public static final int CVS_ERROR_PROPS_SFORGE_USERNAME = -1;
    
    /**
     * CVSEXE CVS properties stored in stepmod.properties incorrect
     */
    public static final int CVS_ERROR_PROPS_CVSEXE = -2;
    
    /**
     * CVS_RSH CVS properties stored in stepmod.properties incorrect
     */
    public static final int CVS_ERROR_PROPS_CVS_RSH = -3;
    
    /**
     * The SSH connection used by CVS has failed
     */
    public static final int CVS_ERROR_SSH = -4;
    
    /** Creates a new instance of StepmodCvs */
    public StepmodCvs(STEPmod stepMod) {
        this.setStepMod(stepMod);
    }
    
    /**
     * Check that all the CVS properties stored in stepmod.properties
     * point an execuables etc.
     *
     *
     * @return CVS_ERROR_OK if properties OK,
     * CVS_ERROR_PROPS_SFORGE_USERNAME if SFORGE_USERNAME CVS property incorrect
     * CVS_ERROR_PROPS_CVSEXE if CVSEXE CVS property incorrect
     * CVS_ERROR_PROPS_CVS_RSH if CVS_RSH CVS property incorrect
     * The return value is also set in cvsErrorVal
     */
    public int testCvsProperties() {
        int retVal = StepmodCvs.CVS_ERROR_OK;
        String SFORGE_USERNAME = getStepMod().getStepmodProperty("SFORGE_USERNAME");
        String CVSEXE = getStepMod().getStepmodProperty("CVSEXE");
        String CVS_RSH = getStepMod().getStepmodProperty("CVS_RSH");
        if ((SFORGE_USERNAME == null) ||  (SFORGE_USERNAME.length() == 0)) {
            retVal = StepmodCvs.CVS_ERROR_PROPS_SFORGE_USERNAME;
        } else if (!(new File(CVSEXE)).exists()) {
            retVal = StepmodCvs.CVS_ERROR_PROPS_CVSEXE;
        } else if ((CVS_RSH == null) ||  (CVS_RSH.length() == 0)) {
            retVal = StepmodCvs.CVS_ERROR_PROPS_CVS_RSH;
        }
        setCvsErrorVal(retVal);
        return (retVal);
    }
    
    /**
     * Executes a CVS command using SSH. executeCvsCommand reads stepmod.properties to set the CVS
     * executable and the sourceforge user name
     *
     */
    public int executeCvsCommand(List<String> command, String directory) throws IOException, InterruptedException {
        int cvsProps = testCvsProperties();
        if (cvsProps != CVS_ERROR_OK) {
            return(cvsProps);
        } else {
            String cvsCmd = getStepMod().getStepmodProperty("CVSEXE");
            String cvsRoot = ":"+getStepMod().getStepmodProperty("PROTOCOL")+":"
                    + getStepMod().getStepmodProperty("SFORGE_USERNAME")
                    + "@stepmod.cvs.sourceforge.net:/cvsroot/stepmod";
            command.add(0,cvsCmd);
            command.add(1,"-q");
            command.add(2,"-d");
            command.add(3,cvsRoot);
            
            ProcessBuilder builder = new ProcessBuilder(command);
            builder.redirectErrorStream(true);
            
            Map<String, String> environ = builder.environment();
            environ.put("CVS_RSH", getStepMod().getStepmodProperty("CVS_RSH"));
            
            builder.directory( new File(directory));
            
            
            cvsCommand = "";
            for (Iterator it = command.iterator(); it.hasNext();) {
                String elem = (String) it.next();
                cvsCommand += elem + " ";
            }
            
            setCvsExecDirectory(directory);
            Process cvsProc = builder.start();
            
            InputStream is = cvsProc.getInputStream();
            InputStreamReader isr = new InputStreamReader(is);
            BufferedReader br = new BufferedReader(isr);
            String line="";
            int c;
            while ((c = br.read()) != -1) {
                line = line + (char)c;
                if (line.endsWith("'s password:")) {
                    // CVS is asking for a password, so SSH is not set
                    line = line + "\nCVS is asking for a password, so SSH is not setup correctly\n";
                    setCvsErrorVal(CVS_ERROR_SSH);
                    cvsProc.destroy();
                }
            }
            setCvsExitVal(cvsProc.waitFor());
            is.close();
            
            setCvsMessages(line);
            return(getCvsExitVal());
        }
    }
    
    
    
    /**
     * Runs CVS update on a directory
     */
    public int cvsUpdate(String dir) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("update");
            command.add("-A");
            exitVal = executeCvsCommand(command, dir);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    /**
     * Runs CVS commit on a file in a given drectory
     */
    public int cvsCommit(String dir, String Filename) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("commit");
            command.add("-m");
            command.add("Initial revision");
            command.add(Filename);
            exitVal = executeCvsCommand(command, dir);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    
    /**
     * Runs CVS tag on a file in a given drectory
     */
    public int cvsTag(String dir, String tag) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("tag");
            command.add(tag);
            exitVal = executeCvsCommand(command, dir);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    /**
     * Runs CVS delete tag on a file in a given drectory
     */
    public int cvsDeleteTag(String dir, String tag) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("tag");
            command.add("-d");
            command.add(tag);
            exitVal = executeCvsCommand(command, dir);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    
    /**
     * Adds a directory or file to CVS
     */
    public int cvsAdd(String directoryPath, String directoryName) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("add");
            command.add(directoryName);
            exitVal = executeCvsCommand(command, directoryPath);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    
    
    
    /**
     * Runs CVS update -r (Check out a tagged version) on a directory
     */
    public int cvsCoRelease(String dir, String tag) {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("update");
            command.add("-r");
            command.add(tag);
            exitVal = executeCvsCommand(command, dir);
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    /**
     * Runs CVS status on repository_index.xml to test the communication with
     * SourceForge
     */
    public int testCVSconnection() {
        int exitVal = CVS_ERROR_OK;
        try {
            List<String> command = new ArrayList<String>();
            command.add("status");
            command.add("--");
            command.add("repository_index.xml");
            exitVal = executeCvsCommand(command, getStepMod().getRootDirectory());
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    public STEPmod getStepMod() {
        return stepMod;
    }
    
    public void setStepMod(STEPmod stepMod) {
        this.stepMod = stepMod;
    }
    
    public String getCvsCommand() {
        return cvsCommand;
    }
    
    public void setCvsCommand(String cvsCommand) {
        this.cvsCommand = cvsCommand;
    }
    
    public int getCvsExitVal() {
        return cvsExitVal;
    }
    
    public void setCvsExitVal(int cvsExitVal) {
        this.cvsExitVal = cvsExitVal;
    }
    
    public String getCvsMessages() {
        return cvsMessages;
    }
    
    public void setCvsMessages(String cvsMessages) {
        this.cvsMessages = cvsMessages;
    }
    
    public String getCvsExecDirectory() {
        return cvsExecDirectory;
    }
    
    public void setCvsExecDirectory(String cvsExecDirectory) {
        this.cvsExecDirectory = cvsExecDirectory;
    }
    
    public int getCvsErrorVal() {
        return cvsErrorVal;
    }
    
    public void setCvsErrorVal(int cvsPropsVal) {
        this.cvsErrorVal = cvsPropsVal;
    }
    
    
}
