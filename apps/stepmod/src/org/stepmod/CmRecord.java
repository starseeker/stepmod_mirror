package org.stepmod;
/*
 * $Id: CmRecord.java,v 1.3 2006/05/02 18:24:53 RobB Exp $
 *
 * STEPmod.java
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


import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
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
     * values are:
     *  CmRecord.CM_RECORD_NOT_CHANGED;
     *  CmRecord.CM_RECORD_MODIFIED_NOT_CHANGED;
     *  CmRecord.CM_RECORD_MODIFIED_CHANGED;
     */
    private int modified = CM_RECORD_NOT_CHANGED;
    
    /**
     * A flag indicating that the CM record has been modified by the application and not saved
     * to cm_record.xml
     */
    public static final int CM_RECORD_NOT_CHANGED = 0;
    /**
     * A flag indicating that the CM record has been modified by the application and not saved
     * to cm_record.xml
     */
    public static final int CM_RECORD_CHANGED_NOT_SAVED = 1;
    
    /**
     * A flag indicating that the CM record has been modified by the application and saved
     * to cm_record.xml
     */
    public static final int CM_RECORD_CHANGED_SAVED = 2;
    
    
    
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
    public CmRecord(StepmodPart part) {
        setHasCmReleases(new ArrayList());
        stepmodPart = part;
        partType = stepmodPart.getStepmodType();
        partNumber = stepmodPart.getPartNumber();
    }
    
    /**
     * Updates an instance of the CM record by reading from the cm_record.xml for the StepmodPart part.
     */
    public void readCmRecord() {
        
        // A CM record is stored in the file "cm_record.xml" in the part directory
        // read the cm_record.xml creating the releases inserting them into hasCmReleases
        // now read cm_record.xml for the part populating the attributes
        DefaultHandler handler = new CmRecordSaxHandler(this, stepmodPart);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            String stepModDir = stepmodPart.getStepMod().getRootDirectory();
            String cmRecordFilename = stepModDir+"/data/"+ stepmodPart.getStepmodType() +"s/" + stepmodPart.getName()+ "/cm_record.xml";
            File cmRecordFile =  new File(cmRecordFilename);
            if (cmRecordFile.exists()) {
                saxParser.parse( cmRecordFile, handler );
            } else {
                stepmodPart.getStepMod().output("File does not exist:" + cmRecordFilename);
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
            String stepModDir = part.getStepMod().getRootDirectory();
            String cmRecordFilename = stepModDir+"/data/"+ part.getStepmodType() +"s/" + part.getName()+ "/cm_record.xml";
            File cmRecordFile =  new File(cmRecordFilename);
            FileWriter out = new FileWriter(cmRecordFile);
            this.writeToStream(out);
            out.close();
            setModified(CmRecord.CM_RECORD_CHANGED_SAVED);
        } catch (IOException ex) {
            ex.printStackTrace();
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
        private String cmReleaseStatus;
        private String cmReleaseWho;
        private String cmReleaseEdition;
        private String cmReleaseReleaseSequence;
        private String cmReleaseStepmodRelease;
        private String cmReleaseReleaseDate;
        private CmRecord cmRecord;
        
        
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
                cmRecordCvsRevision = attrs.getValue("cvsRevision");
                cmRecordCvsDate = attrs.getValue("cvsDate");
                cmRecord.setCvsRevision(cmRecordCvsRevision);
                cmRecord.setCvsDate(cmRecordCvsDate);
            } else if (currentElement.equals("cm_release")) {
                cmReleaseId = attrs.getValue("release");
                cmReleaseDescription = attrs.getValue("description");
                cmReleaseStatus = attrs.getValue("status");
                cmReleaseWho = attrs.getValue("who");
                cmReleaseEdition = attrs.getValue("edition");
                cmReleaseReleaseSequence = attrs.getValue("release_sequence");
                cmReleaseStepmodRelease = attrs.getValue("stepmod_release");
                cmReleaseReleaseDate = attrs.getValue("when");
                new CmRelease(cmRecord, cmReleaseId, cmReleaseDescription, cmReleaseStatus,
                        cmReleaseWho, cmReleaseEdition, cmReleaseReleaseSequence,
                        cmReleaseStepmodRelease, cmReleaseReleaseDate);
            }
        }
    }
    
    /**
     * Create a new release for the part CmRelease
     * Note - a release must be explicitly written to the cm_record.xml file by
     * writing the record invoking the {@link updateCmRecordFile} on the StepmodPart
     * @return the CmRelese object that has been created.
     */
    public CmRelease makeCmRelease() {
        CmRelease cmRel = new CmRelease(this);
        try {
            this.setModified(CM_RECORD_CHANGED_NOT_SAVED);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return(cmRel);
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
     * Write the CM record to the stream
     */
    void writeToStream(FileWriter out) throws IOException {
        out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        out.write("<!DOCTYPE cm_record SYSTEM \"../../../dtd/cm_record.dtd\">\n");
        out.write("<!-- $Id: CmRecord.java,v 1.3 2006/05/02 18:24:53 RobB Exp $ -->\n");
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
        out.write("  cvs_revision=\""+getCvsRevision()+"\"\n");
        out.write("  cvs_date=\""+getCvsDate()+"\">\n");
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
        out.write("         status\n");
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
        out.write("         release_sequence\n");
        out.write("           an iterative count of the releases\n");
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
    
    public int getModified() {
        return modified;
    }
    
    public void setModified(int modified) throws Exception {
        if ((modified == CmRecord.CM_RECORD_NOT_CHANGED) ||
                (modified == CmRecord.CM_RECORD_CHANGED_NOT_SAVED)||
                (modified == CmRecord.CM_RECORD_CHANGED_SAVED)) {
            this.modified = modified;
        } else {
            throw new Exception("Cannot set modified - use predefined constants");
        }
    }
}
