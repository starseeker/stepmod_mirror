/*
 * $Id: CmRecordFrmwk.java,v 1.1 2006/07/31 05:56:42 robbod Exp $
 *
 * CmRecordFrmwk.java
 *
 * (c) Copyright 2005 Eurostep Limited
 *
 * All rights reserved.
 *
 * This software is the confidential and proprietary information
 * of Eurostep Limited ("Confidential Information").  You
 * shall not disclose such Confidential Information and shall use
 * it only in accordance with the terms of the license agreement
 * you entered into with Eurostep Limited
 */

package org.stepmod;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.TimeZone;
import java.util.regex.Pattern;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.CvsStatus;
import org.stepmod.cvschk.StepmodCvs;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * A CmRecordFrmwk  maintains a record of all the releases (CMRelease) for the STEPmod framework.
 * The XSL, DTDs etc, the normatives references in basic
 * The releases are first read from the cm_record.xml file.
 *
 * @author rbn
 */
public class CmRecordFrmwk {
    
    /**
     * The date that file was udpated in CVS
     */
    private String cvsDate;
    
    /**
     * The CVS revision
     */
    private String cvsRevision;
    
    private ArrayList hasCmReleases;
    private STEPmod stepMod;
    
    /**
     * A flag indicating if the cm_record has been updated in this session
     */
    private int recordState = CM_RECORD_NO_CHANGE;
    
    
    /**
     * A flag indicating that the CM record has not been modified by the application
     */
    public static final int CM_RECORD_NO_CHANGE = 0;
    
    
    /**
     * A flag indicating that the CM record has been modified by the application and not saved
     * to cm_record.xml
     */
    public static final int CM_RECORD_CHANGED_NOT_SAVED = 1;
    
    
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, does not exist for this part
     */
    public static final int CM_RECORD_FILE_NOT_EXIST = 2;
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, does exists for
     * this part but has not been added to CVS
     */
    public static final int CM_RECORD_CVS_NOT_ADDED = 3;
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, for
     * this part but has been added to CVS but not committed
     */
    public static final int CM_RECORD_CVS_ADDED= 4;
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, for
     * this part but has been committed to CVS
     */
    public static final int CM_RECORD_CVS_COMMITTED = 5;
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, for
     * this part has been committed to CVS but the local file has changed
     */
    public static final int CM_RECORD_CVS_CHANGED = 6;
    
    
    /**
     * A flag indicating that the CM record file, cm_record.xml, for
     * this part exists, but the record directory has not been added to CVS
     */
    public static final int CM_RECORD_CVS_DIR_NOT_ADDED = 7;
    
    
    /**
     * Either stepmod or basic
     */
    private String type;
    
    /**
     * The CVS status of the part that has been checked out
     * The status is read from the CVS/Entries file for the part
     */
    private CvsStatus cvsStatusObject;
    
    
    
    
    /**
     * Creates a new instance of CmRecordFrmwk
     */
    public CmRecordFrmwk(STEPmod stepMod, String type) {
        setHasCmReleases(new ArrayList());
        this.stepMod = stepMod;
        this.type = type;
        this.readCmRecord();
        
        if (type.equals("stepmod")) {
            String cmRecordDir = getStepMod().getRootDirectory() +"/xsl";
            this.setCvsStatusObject(new CvsStatus(cmRecordDir,  "common.xsl"));
        } else {
            String cmRecordDir = getStepMod().getRootDirectory() +"/data/basic";
            this.setCvsStatusObject(new CvsStatus(cmRecordDir,  "normrefs.xml"));
        }
        
        
    }
    
    
    /**
     * Updates an instance of the CM record for the StepmodPart part.
     * The CM records are stored in stepmod/config_management/<part>/cm_record.xml
     */
    public void readCmRecord() {
        // A CM record is stored in the file "cm_record.xml" in the part directory
        // read the cm_record.xml creating the releases inserting them into hasCmReleases
        // now read cm_record.xml for the part populating the attributes
        DefaultHandler handler = new CmRecordFrmwkSaxHandler(this);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        String stepModDir = getStepMod().getRootDirectory();
        String cmRecordFilename = stepModDir+"/config_management/"+ this.getType() + "/cm_record.xml";
        
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File cmRecordFile =  new File(cmRecordFilename);
            if (cmRecordFile.exists()) {
                saxParser.parse( cmRecordFile, handler);
                // TODO this.setRecordState(this.getCmRecordCvsStatus());
            } else {
                // TODO this.setRecordState(CM_RECORD_FILE_NOT_EXIST);
            }
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    
    /**
     * Instantiate a SAX handler to read in module.xml
     */
    private class CmRecordFrmwkSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private String cmRecordCvsRevision;
        private String cmRecordCvsDate;
        
        private String cmReleaseId;
        private String cmReleaseDescription;
        private String cmReleaseStatus;
        private String cmReleaseWho;
        private String cmReleaseReleaseDate;
        private CmRecordFrmwk cmRecord;
        private CmReleaseFrmwk currentCmRelease;
        
        
        /**
         * Instantiate a Sax handler for reading the module.xml file
         */
        public CmRecordFrmwkSaxHandler(CmRecordFrmwk cmRecord) {
            this.cmRecord = cmRecord;
        }
        
        
        public void startElement(String namespaceURI, String sName, // simple name
                String qName, // qualified name
                Attributes attrs) throws SAXException {
            currentElement = qName;
            if (currentElement.equals("cm_record")) {
                cmRecordCvsRevision = attrs.getValue("cvs_revision");
                cmRecordCvsDate = attrs.getValue("cvs_date");
                cmRecord.setCvsRevision(cmRecordCvsRevision);
                cmRecord.setCvsDate(cmRecordCvsDate);
            } else if (currentElement.equals("cm_release")) {
                cmReleaseId = attrs.getValue("release");
                cmReleaseDescription = attrs.getValue("description");
                cmReleaseWho = attrs.getValue("who");
                cmReleaseReleaseDate = attrs.getValue("when");
                currentCmRelease = new CmReleaseFrmwk(cmRecord, cmReleaseId, cmReleaseWho, cmReleaseReleaseDate, cmReleaseDescription);
            }
        }
    }
    
    
    /**
     * Add the CmReleaseFrmwk to the array of releases associated with the cm record
     */
    public void addCmReleaseToReleases(CmReleaseFrmwk cmRelease) {
        hasCmReleases.add(cmRelease);
    }
    
    public String getCvsDate() {
        return cvsDate;
    }
    
    public void setCvsDate(String cvsDate) {
        this.cvsDate = cvsDate;
    }
    
    public String getCvsRevision() {
        return cvsRevision;
    }
    
    public void setCvsRevision(String cvsRevision) {
        this.cvsRevision = cvsRevision;
    }
    
    public ArrayList getHasCmReleases() {
        return hasCmReleases;
    }
    
    public void setHasCmReleases(ArrayList hasCmReleases) {
        this.hasCmReleases = hasCmReleases;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * Generate a summary of the release in HTML
     * @return am HTML summary
     */
    public String summaryHtml(CmReleaseFrmwk cmRelease) {
        String id = "";
        if (cmRelease == null) {
            id = "Development release";
        } else {
            id = cmRelease.getId();
        }
        String recName;
        if (getType().equals("basic")) {
            recName = "common files";
        } else {
            recName = "STEPmod framework";
        }
        
        
        
        
        String cmDescr = "";
        int cmRecordState = getCmRecordCvsStatus();
        if (cmRecordState == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
            cmDescr = "CM record modified but not saved to cm_record.xml";
        } else if (cmRecordState == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
            cmDescr = "The CM record file, cm_record.xml, does not exist for this part";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_NOT_ADDED) {
            cmDescr = "The CM record file, cm_record.xml, exists but has not been added to CVS";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_ADDED) {
            cmDescr = "The CM record file, cm_record.xml, has been added to CVS but not committed";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_COMMITTED) {
            cmDescr = "The CM record file, cm_record.xml, has been committed to CVS";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_CHANGED) {
            cmDescr = "The CM record file, cm_record.xml, has  been committed to CVS but the local file has changed";
        } else if (cmRecordState == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED) {
            cmDescr = "The CM record file, cm_record.xml, exists but the record directory has not been added to CVS";
        }
        
        CmReleaseFrmwk currentRelease = getCheckedOutRelease();
        String currentReleaseDscr;
        if (currentRelease == null) {
            currentReleaseDscr = "Development revision";
        } else {
            currentReleaseDscr = currentRelease.getId();
        }
        
        String summary = "<html><body>"
                + "<h2>Release "+recName+": " + id + "</h2>"
                + "<table>";
        if (cmRelease != null) {
            summary +=  "<tr><td>&#160;</td><td>&#160;<td></tr>"
                    + "<tr><td>Release identifier:</td><td>" + cmRelease.getId() + "</td></tr>"
                    + "<tr><td>Released date:</td><td>" + cmRelease.getReleaseDate() + "</td></tr>"
                    + "<tr><td>Released by:</td><td>" + cmRelease.getWho() + "</td></tr>"
                    + "<tr><td>Description:</td><td>" + cmRelease.getDescription() + "</td></tr>"
                    + "<tr><td>Checked out release:</td><td>" + currentReleaseDscr + "</td></tr>"
                    + "<tr><td>CM record CVS status:</td><td>" + cmDescr + "</td></tr>";
        }
        summary += "</table></body></html>";
        return(summary);
    }
    
    
    
    public int getCmRecordCvsStatus() {
        int retVal = 0;
        
        String cmDirName = getStepMod().getRootDirectory()+"/config_management/"+ getType();
        String cmRecordFilename = cmDirName+ "/cm_record.xml";
        String cvsEntriesFilename = cmDirName+ "/CVS/Entries";
        File cmDir = new File(cmDirName);
        File cmRecordFile = new File(cmRecordFilename);
        File cvsEntriesFile = new File(cvsEntriesFilename);
        if (!cmRecordFile.exists()) {
            // The CM record file, cm_record.xml, does not exist for this part
            retVal = CM_RECORD_FILE_NOT_EXIST;
        } else {
            if (!cvsEntriesFile.exists()) {
                // The CM record file, cm_record.xml, exists but the record directory has not been added to CVS
                retVal = CM_RECORD_CVS_DIR_NOT_ADDED;
            } else {
                // Directory under CVS control, so check CVS status of cm_record.xml
                try {
                    BufferedReader in = new BufferedReader(new FileReader(cvsEntriesFile));
                    String str;
                    Pattern mainfilePattern = Pattern.compile("^/cm_record.xml/.*$");
                    boolean foundCmRecordEntry = false;
                    String datestamp = null;
                    while ((str = in.readLine()) != null) {
                        String[] fields = str.split("/");
                        if (fields.length > 2) {
                            if (fields[1].equals("cm_record.xml")) {
                                foundCmRecordEntry = true;
                                // Found the line with the cm_record.xml
                                if (foundCmRecordEntry) {
                                    datestamp = fields[3];
                                }
                            }
                        }
                    }
                    in.close();
                    
                    if (!foundCmRecordEntry) {
                        // Cannot find cm_record.xml in CVS/Entries
                        //The CM record file, cm_record.xml, exists but has not been added to CVS
                        retVal = CmRecord.CM_RECORD_CVS_NOT_ADDED;
                    } else if (datestamp.equals("dummy timestamp")) {
                        // If contains dummy timestamp, then added but not committed
                        //The CM record file, cm_record.xml, has been added to CVS but not committed;
                        retVal = CmRecord.CM_RECORD_CVS_ADDED;
                    } else {
                        SimpleDateFormat cvsDateFormat = new SimpleDateFormat("EEE MMM dd H:mm:ss yyyy");
                        try {
                            TimeZone tz = TimeZone.getDefault();
                            Date cvsDate = cvsDateFormat.parse(datestamp);
                            Calendar cvsGcCal = new GregorianCalendar(tz);
                            cvsGcCal.setTime(cvsDate);
                            
                            //System.out.println("CVS date " + cvsDateFormat.format(cvsGcCal.getTime()));
                            
                            // This is a bit of a hack
                            // the CVS client seems to ignore daylight savings, so the comparisons are wrong
                            if (tz.inDaylightTime(cvsDate)) {
                                cvsGcCal.add(Calendar.MILLISECOND, tz.getDSTSavings());
                                //System.out.println("CVS date + savings" + cvsDateFormat.format(cvsGcCal.getTime()));
                            }
                            
                            Date fileDate = new Date(cmRecordFile.lastModified());
                            Calendar fileGcCal = new GregorianCalendar(tz);
                            fileGcCal.setTime(fileDate);
                            //System.out.println("File date " + cvsDateFormat.format(fileDate));/
                            //System.out.println("CVS before File " + cvsGcCal.before(fileGcCal));
                            //System.out.println("File before CVS " + cvsGcCal.after(fileGcCal));
                            //System.out.println("==" + (cvsGcCal.getTimeInMillis() - fileGcCal.getTimeInMillis()));
                            
                            // The calendar times do not seem to exactly equal, so give 3 minutes marhin of error
                            long diff = java.lang.Math.abs(cvsGcCal.getTimeInMillis() - fileGcCal.getTimeInMillis());
                            if (diff < 180) {
                                //The CM record file, cm_record.xml, has been committed to CVS
                                //System.out.println("DIFF " + diff + " " + cmRecordFilename);
                                
                                retVal = CmRecord.CM_RECORD_CVS_COMMITTED;
                            } else {
                                //The CM record file, cm_record.xml, has  been committed to CVS but the local file has changed
                                retVal = CmRecord.CM_RECORD_CVS_CHANGED;
                            }
                        } catch(java.text.ParseException p) {
                            System.out.println(p.toString());
                        }
                    }
                } catch (IOException e) {
                    retVal = -1;
                }
            }
        }
        return(retVal);
    }
    
    
    public StepmodCvs cvsCoRelease(CmReleaseFrmwk cmRelease) {
        STEPmod stepMod = this.getStepMod();
        StepmodCvs stepmodCvs = new StepmodCvs(stepMod);
        if (this.getType().equals("stepmod")) {
            String xslDir = stepMod.getRootDirectory() +"/xsl";
            stepmodCvs.cvsCoRelease(xslDir, cmRelease.getId());
            this.getCvsStatusObject().updateCvsStatus();
            String dtdDir = stepMod.getRootDirectory() +"/dtd";
            stepmodCvs.cvsCoRelease(dtdDir, cmRelease.getId());
            this.getCvsStatusObject().updateCvsStatus();
            return stepmodCvs;
        } else {
            String basicDir = stepMod.getRootDirectory() +"/data/basic";
            stepmodCvs.cvsCoRelease(basicDir, cmRelease.getId());
            this.getCvsStatusObject().updateCvsStatus();
            return stepmodCvs;
        }
    }
    
    public StepmodCvs cvsUpdate() {
        STEPmod stepMod = this.getStepMod();
        StepmodCvs stepmodCvs = new StepmodCvs(stepMod);
        if (this.getType().equals("stepmod")) {
            String xslDir = stepMod.getRootDirectory() +"/xsl";
            stepmodCvs.cvsUpdate(xslDir);
            this.getCvsStatusObject().updateCvsStatus();
            String dtdDir = stepMod.getRootDirectory() +"/dtd";
            stepmodCvs.cvsUpdate(dtdDir);
            this.getCvsStatusObject().updateCvsStatus();
            return stepmodCvs;
        } else {
            String basicDir = stepMod.getRootDirectory() +"/data/basic";
            stepmodCvs.cvsUpdate(basicDir);
            this.getCvsStatusObject().updateCvsStatus();
            return stepmodCvs;
        }
    }
    
    public StepmodCvs cvsCommitRecord () {
        STEPmod stepMod = this.getStepMod();
        StepmodCvs stepmodCvs = new StepmodCvs(stepMod);
        String cmDir;
        if (this.getType().equals("stepmod")) {            
            cmDir = stepMod.getRootDirectory()+"/config_management/stepmod";
        } else {
            cmDir = stepMod.getRootDirectory()+"/config_management/basic"; 
        }
        stepmodCvs.cvsCommit(cmDir, "cm_record.xml");
        return(stepmodCvs);
    }
        
        
    
    public STEPmod getStepMod() {
        return stepMod;
    }
    
    public String getCvsTag() {
        return (this.getCvsStatusObject().getCvsTag());
    }
    
    /**
     * Return the CmRelease that has been checked out
     * If no CmRelease found, then the development revision has been checked out.
     */
    public CmReleaseFrmwk getCheckedOutRelease() {
        String currentRelTag = this.getCvsTag();
        CmReleaseFrmwk cmCheckedOutRelease = null;
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmReleaseFrmwk cmRelease = (CmReleaseFrmwk) it.next();
            if (cmRelease.getId().equals(currentRelTag)) {
                cmCheckedOutRelease = cmRelease;
            }
        }
        return(cmCheckedOutRelease);
    }
    
    public CvsStatus getCvsStatusObject() {
        return cvsStatusObject;
    }
    
    public void setCvsStatusObject(CvsStatus cvsStatusObject) {
        this.cvsStatusObject = cvsStatusObject;
    }
    
    
    
    /**
     * Creates a new cm_record.xml file for the part. It overwrites the existing file.
     */
    public void writeCmRecord() {
        // check that a cm_record.xml does not exist in the part directory e.g.
        // stepmod/data/modules/{module}/cm_record.xml
        // Create the cm_record.xml. Should not contain any releases.
        try {
            String stepModDir = getStepMod().getRootDirectory();
            String cmRecordFilename = stepModDir+"/config_management/"+ this.getType() + "/cm_record.xml";
            File cmRecordFile = new File(cmRecordFilename);
            FileWriter out = new FileWriter(cmRecordFile);
            this.writeToStream(out);
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    /**
     * Write the CM record to the stream
     */
    void writeToStream(FileWriter out) throws IOException {
        out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        //out.write("<!DOCTYPE cm_record SYSTEM \"../../../dtd/cm_record.dtd\">\n");
        out.write("<!-- $Id: CmRecord.java,v 1.17 2006/07/28 13:28:28 robbod Exp $ -->\n");
        out.write("\n");
        out.write("<!-- A configuration management record\n");
        out.write("     part_name\n");
        out.write("       The name of the STEP part\n");
        out.write("     part_type\n");
        out.write("       The type of the STEP part. Either module, application_protocol or resource_doc\n");
        out.write("     part_number\n");
        out.write("       The ISO part number\n");
        out.write("     cvs_revision\n");
        out.write("       The file revision of the cm record. (RCS keyword Revision)\n");
        out.write("     cvs_date\n");
        out.write("       The date of the file revision. (RCS keyword Date)\n");
        out.write("     -->\n");
        out.write("<cm_record\n");
        out.write("  cvs_revision=\""+getCvsRevision()+"\"\n");
        out.write("  cvs_date=\""+getCvsDate()+"\">\n");
        out.write("<cm_releases>\n");
        out.write("   <!-- A release of the part\n");
        out.write("         release\n");
        out.write("           the release identifier\n");
        out.write("         stepmod_release\n");
        out.write("           the release of  STEPmod used to create HTML for the release\n");
        out.write("         who\n");
        out.write("           the person who created the release\n");
        out.write("         when\n");
        out.write("           the date when the release was created\n");
        out.write("         description\n");
        out.write("           free text description of the release\n");
        out.write("         -->\n");
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmReleaseFrmwk cmRelease = (CmReleaseFrmwk) it.next();
            cmRelease.writeToStream(out);
        }
        out.write("</cm_releases>\n");
        out.write("</cm_record>\n");
    }
    
    
}
