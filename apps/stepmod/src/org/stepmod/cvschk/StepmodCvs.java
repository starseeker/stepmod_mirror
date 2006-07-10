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
    
    STEPmod stepMod;
    
    /** Creates a new instance of StepmodCvs */
    public StepmodCvs(STEPmod stepMod) {
        this.stepMod = stepMod;
    }
   
    /**
     * Executes a CVS command using SSH. executeCvsCommand reads stepmod.properties to set the CVS
     * executable and the sourceforge user name
     *
     */
    public int executeCvsCommand(List<String> command, String directory) throws IOException, InterruptedException {
        String cvsCmd = stepMod.getStepmodProperty("CVSEXE");
        String cvsRoot = ":ssh:"
                + stepMod.getStepmodProperty("SFORGE_USERNAME")
                + "@stepmod.cvs.sourceforge.net:/cvsroot/stepmod";
        command.add(0,cvsCmd);
        command.add(1,"-q");
        command.add(2,"-d");
        command.add(3,cvsRoot);
        command.add(4,"-q");
        
        ProcessBuilder builder = new ProcessBuilder(command);
        builder.redirectErrorStream(true);
        
        Map<String, String> environ = builder.environment();
        environ.put("CVS_RSH", stepMod.getStepmodProperty("CVS_RSH"));
        
        builder.directory( new File(directory));
        
        String commandString = "Executing command: ";
        for (Iterator it = command.iterator(); it.hasNext();) {
            String elem = (String) it.next();
            commandString += elem + " ";
        }
        commandString += "\nin directory: " +directory;
        System.out.println(commandString);
        Process cvsProc = builder.start();
        
        InputStream is = cvsProc.getInputStream();
        InputStreamReader isr = new InputStreamReader(is);
        BufferedReader br = new BufferedReader(isr);
        String line="";
        System.out.printf("Output of running %s is:\n",command);
        int c;
        while ((c = br.read()) != -1) {
            line = line + (char)c;
            if (line.endsWith("'s password:")) {
                // CVS is asking for a password, so SSH is not set
                line = line + "\nCVS is asking for a password, so SSH is not setup correctly\n";
                cvsProc.destroy();
            }
        }
        int exitVal = cvsProc.waitFor();
        is.close();
        System.out.print(line);
        System.out.println("Program terminated with code " + exitVal);
        return(exitVal);
    }
    
    
    
    /**
     * Runs CVS update on a directory
     */
    public int cvsUpdate(String dir) {
        int exitVal = -1;
        try {
            List<String> command = new ArrayList<String>();
            command.add("update");
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
        int exitVal = -1;
        try {
            List<String> command = new ArrayList<String>();
            command.add("status");
            command.add("--");
            command.add("repository_index.xml");
            exitVal = executeCvsCommand(command, stepMod.getRootDirectory());
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return(exitVal);
    }
    
    
}
