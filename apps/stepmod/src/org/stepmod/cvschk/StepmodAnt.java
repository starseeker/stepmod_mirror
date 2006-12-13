/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * StepmodAnt.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod.cvschk;
import java.io.*;
import org.apache.tools.ant.*;
import java.util.*;
import org.stepmod.STEPmod;

import org.stepmod.StepmodModule;
import org.stepmod.StepmodPart;
import org.stepmod.gui.STEPModFrame;


/**
 *
 * StepmodAnt provides a facility to build and execute Ant scripts. 
 * The scripts are written to a temporary file and then read back into 
 * the application. 
 * @author jpe
 * 
 */
public class StepmodAnt {
    

    
    
    /**
     * Use ANT to execute a CVS command
     * The SSH properties required to connect to the CVS server are stored in
     * the stepmod root directory 
     * @param Stepmod an instance of stepmod
     * @param partName a string representing the part name to be operated on
     * @param cvsPath a string respresenting the cvsPath
     * @param cvsCommand a string representing the cvs command to be executed
     * @throws IOException if an input or output error occurs
     */
    public void runCvs(STEPmod stepMod, String partName, String cvsPath, String cvsCommand) {
        try {
            // Create a temporary ANT build file
            File antBuildFile = File.createTempFile("ant_"+partName, ".xml");
            // Delete temp file when program exits.
            antBuildFile.deleteOnExit();
            
            // Write to temp file
            BufferedWriter out = new BufferedWriter(new FileWriter(antBuildFile));
            out.write("<?xml version='1.0' encoding='UTF-8'?>\n");
            out.write("<project name=\"stepmodapp\" default=\"all\" basedir=\""+ stepMod.getRootDirectory() +"\">\n\n");
            
            out.write(" <target name=\"init\" description=\"initialize variables\">\n");
            out.write("   <tstamp/>\n");
            out.write("   <!-- user specific properties stored in dexlib root an customized by the user -->\n");
            out.write("   <!-- Specifies CVS properties -->\n");
            out.write("   <loadproperties srcfile=\"stepmod.properties\"/>\n");
            out.write(" </target>\n\n");
            
            out.write("  <target name=\"all\" depends=\"init\">\n");
            out.write("    <cvs cvsroot=\":ssh:${SFORGE_USERNAME}@stepmod.cvs.sourceforge.net:/cvsroot/stepmod\"\n");
            out.write("       cvsRSH='ssh'\n");
            out.write("       dest=\""+stepMod.getRootDirectory()+"\"\n");
            out.write("       command=\""+cvsCommand+"\"\n");
            out.write("       package=\""+cvsPath+"\"\n");
            out.write("       output=\"log.txt\"/>\n");
            out.write("  </target>\n\n");
            out.write("</project>");
            out.close();
            
            Project antProject = new Project();
            
            // Steup some loggers to deal with CVS outputs
            DefaultLogger consoleLogger = new DefaultLogger();
            consoleLogger.setErrorPrintStream(System.err);
            consoleLogger.setOutputPrintStream(System.out);
            consoleLogger.setMessageOutputLevel(Project.MSG_INFO);
            antProject.addBuildListener(consoleLogger);
            
            antProject.setUserProperty("ant.file", antBuildFile.getAbsolutePath());
            try {                
                antProject.fireBuildStarted();
                antProject.init();
                ProjectHelper helper = ProjectHelper.getProjectHelper();
                antProject.addReference("ant.projectHelper", helper);
                
                helper.parse(antProject, antBuildFile);
                // ANT does not seem to pick up the basedir set in the ant file
                // so explicitly set it here
                antProject.setBasedir( stepMod.getRootDirectory() );                
                
                // Now run ANT
                antProject.executeTarget("all");
                
                antProject.fireBuildFinished(null);
            } catch (BuildException e) {
                antProject.fireBuildFinished(e);
            }
        } catch(IOException ex){
            System.out.println("Unable to create temporary ANT build file");
        }
    }
    
    
   
}

