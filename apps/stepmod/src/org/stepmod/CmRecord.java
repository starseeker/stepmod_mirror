package org.stepmod;
/*
 * $Id: CmRecord.java,v 1.24 2007/08/16 12:42:45 robbod Exp $
 *
 * CmRecord.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */



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
 * The CmRecord maintains a record of all the releases (CMRelease) for a given STEPmod part.
 * The releases are first read from the cm_record.xml file.
 * New releases for the part can be created by invoking the operation mkCmRelease on the relevant STEPmod part.
 * The CmRecord file is updated by invoking the updateCmRecordFile operation.
 */
public class CmRecord {
    /**
     * The date that file was udpated in CVS
     */
    private String cvsDate;
    
    /**
     * The CVS revision
     */
    private String cvsRevision;
    
    /**
     * The name of the part.
     */
    private String partName;
    
    /**
     * The ISO number for the part
     */
    private String partNumber;
    
    /**
     * The type of the part. Either module, application_protocol, resource_doc.
     */
    private String partType;
    
    /**
     * The StepmodPart object representing the STEP part for which this is the configuration record.
     */
    private StepmodPart stepmodPart;
    
    private ArrayList hasCmReleases;
    
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
    
    
    public CmRecord(StepmodPart part, String cvsRevision, String  cvsDate) {
        setHasCmReleases(new ArrayList());
        this.stepmodPart = part;
        this.partType = stepmodPart.getStepmodType();
        this.partNumber = stepmodPart.getPartNumber();
        this.cvsRevision = cvsRevision;
        this.cvsDate = cvsDate;
    }
    
    /**
     * Makes an instance of the CM record for the StepmodPart part
     * @param part The STEPmod part for which the CM record is being created.
     */
    public CmRecord(StepmodPart stepmodPart) {
        setHasCmReleases(new ArrayList());
        this.stepmodPart = stepmodPart;
        this.partName = stepmodPart.getName();
        this.partType = stepmodPart.getStepmodType();
        this.partNumber = stepmodPart.getPartNumber();
        this.cvsRevision = "$Revision:";
        this.cvsRevision +=" $";
        this.cvsDate = "$Date: ";
        this.cvsDate +=" $";
    }
    
    /**
     * Updates an instance of the CM record for the StepmodPart part.
     * The CM records are stored in stepmod/config_management/<part>/cm_record.xml
     */
    public void readCmRecord() {
        // A CM record is stored in the file "cm_record.xml" in the part directory
        // read the cm_record.xml creating the releases inserting them into hasCmReleases
        // now read cm_record.xml for the part populating the attributes
        DefaultHandler handler = new CmRecordSaxHandler(this, stepmodPart);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        String stepModDir = stepmodPart.getStepMod().getRootDirectory();
        String cmRecordFilename = stepModDir+"/config_management/"+ stepmodPart.getStepmodType() +"s/" + stepmodPart.getName()+ "/cm_record.xml";
        
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File cmRecordFile =  new File(cmRecordFilename);
            if (cmRecordFile.exists()) {
                saxParser.parse( cmRecordFile, handler);
                this.setRecordState(this.getCmRecordCvsStatus());
            } else {
                //stepmodPart.getStepMod().output("File does not exist:" + cmRecordFilename);
                this.setRecordState(CM_RECORD_FILE_NOT_EXIST);
            }
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    
    /**
     * Creates a new cm_record.xml file for the part. It overwrites the existing file.
     */
    public void writeCmRecord() {
        // check that a cm_record.xml does not exist in the part directory e.g.
        // stepmod/data/modules/{module}/cm_record.xml
        // Create the cm_record.xml. Should not contain any releases.
        StepmodPart part = this.getStepmodPart();
        try {
            String cmDirName = part.getStepMod().getRootDirectory()+"/config_management/"+ part.getStepmodType() +"s/" + part.getName();
            String cmRecordFilename = cmDirName+ "/cm_record.xml";
            File cmDir = new File(cmDirName);
            File cmRecordFile = new File(cmRecordFilename);
            boolean success = true;
            if (!cmRecordFile.exists()) {
                if (!cmDir.exists()) {
                    success = cmDir.mkdir();
                }
            }
            if (success) {
                FileWriter out = new FileWriter(cmRecordFile);
                this.writeToStream(out);
                out.close();
                setRecordState(this.getCmRecordCvsStatus());
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    
    
    /**
     * Instantiate a SAX handler to read in module.xml
     */
    private class CmRecordSaxHandler extends DefaultHandler {
        // Common attributes
        private String currentElement;
        private StepmodPart part;
        private STEPmod stepMod;
        private String cmRecordCvsRevision;
        private String cmRecordCvsDate;
        private String cmReleaseId;
        private String cmReleaseDescription;
        private String cmReleaseIsoStatus;
        private String cmReleaseStatus;
        private String cmReleaseWho;
        private String cmReleaseEdition;
        private String cmReleaseStepmodCommonRelease;
        private String cmReleaseStepmodFrameworkRelease;
        private String cmReleaseReleaseDate;
        private CmRecord cmRecord;
        private CmRelease currentCmRelease;
        private String directoryName;
        
        
        /**
         * Instantiate a Sax handler for reading the module.xml file
         */
        public CmRecordSaxHandler(CmRecord cmRecord, StepmodPart part) {
            this.part = part;
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
                cmReleaseIsoStatus = attrs.getValue("iso_status");
                cmReleaseStatus = attrs.getValue("release_status");
                cmReleaseWho = attrs.getValue("who");
                cmReleaseEdition = attrs.getValue("edition");
                cmReleaseStepmodCommonRelease = attrs.getValue("stepmod_common_release");
                cmReleaseStepmodFrameworkRelease= attrs.getValue("stepmod_framework_release");
                cmReleaseReleaseDate = attrs.getValue("when");
                currentCmRelease = new CmRelease(cmRecord, cmReleaseId, cmReleaseDescription,
                        cmReleaseIsoStatus, cmReleaseStatus,cmReleaseWho, cmReleaseEdition,
                        cmReleaseStepmodCommonRelease, cmReleaseStepmodFrameworkRelease, cmReleaseReleaseDate);
            } else if (currentElement.equals("module")) {
                // reading a dependent module
                String moduleName = attrs.getValue("name");
                String moduleNumber = attrs.getValue("part");
                String moduleRelease= attrs.getValue("release");
                currentCmRelease.addDependentPart(new StepmodPartCM(moduleName, moduleNumber, moduleRelease, StepmodPartCM.IS_A_MODULE, currentCmRelease));
            } else if (currentElement.equals("resource")) {
                // reading a dependent resource schema
                String resourceName = attrs.getValue("name");
                String resourceNumber = attrs.getValue("part");
                String resourceRelease= attrs.getValue("release");
                currentCmRelease.addDependentPart(new StepmodPartCM(resourceName, resourceNumber, resourceRelease, StepmodPartCM.IS_A_RESOURCESCHEMA, currentCmRelease));
            } else if (currentElement.equals("directory")) {
                directoryName = attrs.getValue("name");
            } else if (currentElement.equals("file")) {
                String fileName = attrs.getValue("name");
                String fileCvsRevision  = attrs.getValue("cvs_revision");
                String fileCvsDate = attrs.getValue("cvs_date");
                StepmodFile stepmodFile = new StepmodFile(fileName, directoryName, part, fileCvsRevision, fileCvsDate);
                currentCmRelease.addDependentFile(stepmodFile);
            }
        }
    }
    
    /**
     * Add the cmRelease to the array of releases associated with the cm record
     */
    public void addCmReleaseToReleases(CmRelease cmRelease) {
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
    
    public String getPartName() {
        return partName;
    }
    
    public void setPartName(String partName) {
        this.partName = partName;
    }
    
    public String getPartNumber() {
        return partNumber;
    }
    
    public void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }
    
    public String getPartType() {
        return partType;
    }
    
    public void setPartType(String partType) {
        this.partType = partType;
    }
    
    public StepmodPart getStepmodPart() {
        return stepmodPart;
    }
    
    public void setStepmodPart(StepmodPart stepmodPart) {
        this.stepmodPart = stepmodPart;
    }
    
    public ArrayList getHasCmReleases() {
        return hasCmReleases;
    }
    
    public void setHasCmReleases(ArrayList hasCmReleases) {
        this.hasCmReleases = hasCmReleases;
    }
    
    /**
     * Return the CmRelease that has been checked out
     * If no CmRelease found, then the development revision has been checked out.
     */
    public CmRelease getCheckedOutRelease() {
        String currentRelTag = this.getStepmodPart().getCvsTag();
        CmRelease cmCheckedOutRelease = null;
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmRelease cmRelease = (CmRelease) it.next();
            if (cmRelease.getId().equals(currentRelTag)) {
                cmCheckedOutRelease = cmRelease;
            }
        }
        return(cmCheckedOutRelease);
    }
    
    
    /**
     * Return the CmRelease that has the given tag
     */
    public CmRelease getNamedRelease(String tag) {
        CmRelease cmCheckedOutRelease = null;
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmRelease cmRelease = (CmRelease) it.next();
            if (cmRelease.getId().equals(tag)) {
                cmCheckedOutRelease = cmRelease;
            }
        }
        return(cmCheckedOutRelease);
    }
    
    
    /**
     * Write the CM record to the stream
     */
    void writeToStream(FileWriter out) throws IOException {
        out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        out.write("<!DOCTYPE cm_record SYSTEM \"../../../dtd/cm_record.dtd\">\n");
        out.write("<!-- $Id: CmRecord.java,v 1.24 2007/08/16 12:42:45 robbod Exp $ -->\n");
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
        out.write("  part_name=\""+getPartName()+"\"\n");
        out.write("  part_type=\""+getPartType()+"\"\n");
        out.write("  part_number=\""+getPartNumber()+"\"\n");
        String cvsRevision = getCvsRevision();
        if ((cvsRevision == null) || (!cvsRevision.contains("$Revision:"))) {
            cvsRevision = "$Revision: 1.24 $";
        }
        if ((cvsDate == null) || (!cvsDate.contains("$Date:"))) {
            cvsDate = "$Date: 2007/08/16 12:42:45 $";
        }
        
        out.write("  cvs_revision=\""+cvsRevision+"\"\n");
        out.write("  cvs_date=\""+cvsDate+"\">\n");
        out.write("<cm_releases>\n");
        out.write("   <!-- A relase of the part\n");
        out.write("         release\n");
        out.write("           the release identifier\n");
        out.write("         stepmod_release\n");
        out.write("           the release of  STEPmod used to create HTML for the release\n");
        out.write("         who\n");
        out.write("           the person who created the release\n");
        out.write("         when\n");
        out.write("           the date when the release was created\n");
        out.write("         release_status\n");
        out.write("           A record of the status of the release. The status of the release\n");
        out.write("           will only change if it passes a review with no changes. If there\n");
        out.write("           are any changes required during the review, then a new release will be\n");
        out.write("           created. The following statuses are allowed: \n");
        out.write("            - Team review - the release distributed for Team review\n");
        out.write("            - Convener review - the release distributed for Convener review\n");
        out.write("            - Secretariat review - the release distributed for Secretariat review\n");
        out.write("            - ISO review - the release distributed for Team review\n");
        out.write("            - Ballot - the release distributed for ballot\n");
        out.write("            - ISO publication - the release has been published by ISO\n");
        out.write("         \n");
        out.write("         edition\n");
        out.write("           the edition of the part that has been released\n");
        out.write("         description\n");
        out.write("           free text description of the release\n");
        out.write("         -->\n");
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmRelease cmRelease = (CmRelease) it.next();
            cmRelease.writeToStream(out);
        }
        out.write("</cm_releases>\n");
        out.write("</cm_record>\n");
    }
    
    public int getRecordState() {
        return recordState;
    }
    
    public void setRecordState(int state) {
        this.recordState = state;
    }
    
    
    public int getCmRecordCvsStatus() {
        int retVal = 0;
        StepmodPart stepmodPart = this.getStepmodPart();
        
        String cmDirName = getStepMod().getRootDirectory()+"/config_management/"+ stepmodPart.getStepmodType() +"s/" + stepmodPart.getName();
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
                                                        
                            Date cvsDate = cvsDateFormat.parse(datestamp);
                            
                            Calendar cvsCal = new GregorianCalendar(TimeZone.getTimeZone("GMT"));
                            cvsCal.setTime(cvsDate);
                            long cvsGmtTime = cvsCal.getTimeInMillis();
//            System.out.println("cvs TZ:" + cvsCal.getTimeZone());
//            System.out.println("CVS date UTC:" + cvsDateFormat.format(cvsCal.getTime()));
                            
                            // Local file is in the local time zone
                            Date cmRecordFileDate = new Date(cmRecordFile.lastModified());
                            Calendar cmRecordFileGcCal = new GregorianCalendar(TimeZone.getDefault());
                            cmRecordFileGcCal.setTime(cmRecordFileDate);
//            System.out.println("File date " + cvsDateFormat.format(cmRecordFileDate));
//            System.out.println("local TZ:" + cmRecordFileGcCal.getTimeZone());
//            System.out.println("File calendar date (local): "+ cvsDateFormat.format(cmRecordFileGcCal.getTime()));
                            
                            // get the offset from GMT for the file modification date
                            long gmtOffset = cmRecordFileGcCal.getTimeZone().getOffset(cmRecordFileGcCal.getTimeInMillis());
//            System.out.println("Off "+gmtOffset);
                            // Convert the time to GMT
                            long cmRecordFileGmtTime = cmRecordFileGcCal.getTimeInMillis() - gmtOffset;
                            
                            // Debugging info convince me that the file time has been changed to GMT
//            Calendar foo = new GregorianCalendar(TimeZone.getTimeZone("GMT"));
//            foo.setTimeInMillis(cmRecordFileGmtTime);
//            System.out.println("File calendar date (GMT): "+ cvsDateFormat.format(foo.getTime()));
                            
                            long diff = java.lang.Math.abs(cmRecordFileGmtTime - cvsGmtTime);
                            if (diff < 3000) {
                               // System.out.println(diff + "cm record not changed");
                                retVal = CmRecord.CM_RECORD_CVS_COMMITTED;
                            } else {
                               // System.out.println(diff+ "cm record changed");
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
    
    /**
     * return true if the CMrecord needs CVS action
     * The CVS commands wil work out what needs to be doen and do it
     */
    public boolean needsCvsAction() {
        int cvsState = this.getCmRecordCvsStatus();
        return((cvsState == CM_RECORD_CVS_DIR_NOT_ADDED) ||
                (cvsState == CM_RECORD_CVS_CHANGED) ||
                (cvsState == CM_RECORD_CVS_NOT_ADDED));
    }
    
    public STEPmod getStepMod(){
        return(this.getStepmodPart().getStepMod());
    }
    
    public StepmodCvs cvsCommit() {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        StepmodPart stepmodPart = this.getStepmodPart();
        String partCmDir = getStepMod().getRootDirectory()+"/config_management/"+ stepmodPart.getStepmodType() +"s/";
        String cmDirName = partCmDir + stepmodPart.getName();
        String cmRecordFilename = cmDirName+ "/cm_record.xml";
        
        int cvsStatus = getCmRecordCvsStatus();
        if (cvsStatus == CM_RECORD_CVS_DIR_NOT_ADDED) {
            // Add the part directory
            int result = stepmodCvs.cvsAdd(partCmDir, stepmodPart.getName());
            // Add the cm_record file
            result = stepmodCvs.cvsAdd(cmDirName, "cm_record.xml");
            // Commit the cm_record file
            result = stepmodCvs.cvsCommit(cmDirName, "cm_record.xml");
        } else if (cvsStatus == CM_RECORD_CVS_NOT_ADDED) {
            // Add the cm_record file
            int result = stepmodCvs.cvsAdd(cmDirName, "cm_record.xml");
            // Commit the cm_record file
            result = stepmodCvs.cvsCommit(cmDirName, "cm_record.xml");
        } else {
            // Commit the cm_record file
            int result = stepmodCvs.cvsCommit(cmDirName, "cm_record.xml");
        }
        return(stepmodCvs);
    }
    
    
    
    /**
     * Get the latest release in the record
     */
    public CmRelease getLatestRelease() {
        CmRelease latestRelease = null;
        ArrayList releases = getHasCmReleases();
        if (releases.size() > 0 ) {
            latestRelease = (CmRelease) releases.get(releases.size()-1);
        }
        return (latestRelease);
    }
    
    /**
     * Get the latest release that has been published
     */
    public CmRelease getLatestPublishedRelease() {
        CmRelease pubRelease = null;
        for (Iterator it = hasCmReleases.iterator(); it.hasNext();) {
            CmRelease cmRelease = (CmRelease) it.next();
            if (cmRelease.isPublishedIsoRelease()) {
                pubRelease = cmRelease;
            }
        }
        return pubRelease;
    }
    
    
    
    public void deleteCmRelease(CmRelease cmRelease) {
        StepmodPart part = cmRelease.getStepmodPart();
        hasCmReleases.remove(cmRelease);
    }
    
    
    /**
     * Generate a summary of the release in HTML
     * @return am HTML summary
     */
    public String summaryHtml(CmRelease cmRelease) {
        String id = "";
        if (cmRelease == null) {
            id = "Development release";
        } else {
            id = cmRelease.getId();
        }
        
        StepmodPart part = this.getStepmodPart();
        String cvsStateDscr = "";
        int cvsState = part.getCvsState();
        if (cvsState == CvsStatus.CVSSTATE_UNKNOWN) {
            cvsStateDscr = "ERROR -- Release status cannot be established";
        } else if (cvsState == CvsStatus.CVSSTATE_DEVELOPMENT) {
            cvsStateDscr = "Development release";
        } else if (cvsState == CvsStatus.CVSSTATE_RELEASE) {
            cvsStateDscr =  part.getCvsTag();
        }
        
        String summary = "<html><body>"
                + "<h2>Release: " + id + "</h2>"
                + "<table>"
                + "<tr><td>Part Number:</td><td>ISO 10303-"+part.getPartNumber()+"</td></tr>"
                + "<tr><td>Part Name:</td><td>"+part.getName()+"</td></tr>"
                + "<tr><td>Checked out release:</td><td>" + cvsStateDscr +"</td></tr>";
        if (cmRelease != null) {
            String depDescr = "";
            if (cmRelease.isDependenciesCheckedOut()) {
                depDescr = "All dependent parts are checked out at the correct release.";
            } else {
                depDescr = "A number of dependent parts are not at the correct release.";
            }
            summary +=  "<tr><td>&#160;</td><td>&#160;<td></tr>"
                    + "<tr><td>Release identifier:</td><td>" + cmRelease.getId() + "</td></tr>"
                    + "<tr><td>Released date:</td><td>" + cmRelease.getReleaseDate() + "</td></tr>"
                    + "<tr><td>Release status:</td><td>" + cmRelease.getReleaseStatus() + "</td></tr>"
                    + "<tr><td>STEPmod framework (XSL) release status:</td><td>" + cmRelease.getStepmodFrameworkRelease() + "</td></tr>"
                    + "<tr><td>STEPmod common (basic) release status:</td><td>" + cmRelease.getStepmodCommonRelease() + "</td></tr>"
                    + "<tr><td>ISO status:</td><td>" + cmRelease.getIsoStatus() + "</td></tr>"
                    + "<tr><td>Released by:</td><td>" + cmRelease.getWho() + "</td></tr>"
                    + "<tr><td>Dependency status:</td><td>" + depDescr +"</td></tr>"
                    + "<tr><td>Description:</td><td>" + cmRelease.getDescription() + "</td></tr>";
        }
        summary += "</table></body></html>";
        return(summary);
    }
    
    
    
}
