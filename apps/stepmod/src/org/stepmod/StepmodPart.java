/*
 * $Id: StepmodPart.java,v 1.24 2006/07/27 15:13:54 robbod Exp $
 *
 * StepmodPart.java
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
import java.io.IOException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.stepmod.cvschk.CvsStatus;
import org.stepmod.cvschk.StepmodCvs;
import org.xml.sax.SAXException;

/**
 *
 * @author rbn
 */
public abstract class StepmodPart implements Comparable {
    
    private String name;
    private String nameFrench;
    private String partNumber;
    private String version;
    protected String stepmodType;
    
    private String sc4WorkingGroup;
    private String wgNumber;
    private String wgNumberSupersedes;
    private String checklistInternalReview;
    private String checklistProjectLeader;
    private String checklistConvener;
    private String isoStatus;
    private String language;
    private String publicationYear;
    private String publicationDate;
    private boolean published;
    private String rcsDate;
    private String rcsRevision;
    
    private CmRecord cmRecord;
    private STEPmod stepMod;
    
    /**
     * If the part currently checked out, is OK for release.
     */
    public static final int RELEASE_CHECK_OK = 0;
    
    /**
     * If the part currently checked out not OK for release as some dependent parts are not released
     */
    public static final int RELEASE_CHECK_ERROR_DEPENDENT_PARTS = -1;
    
    /**
     * If the part currently checked out not OK for release as teh part is a release
     */
    public static final int RELEASE_CHECK_ERROR_DEVELOPMENT_PART = -2;
    
    
    /**
     * The CVS status of the part that has been checked out
     * The status is read from the CVS/Entries file for the part
     */
    private CvsStatus cvsStatusObject;
    
    
    /**
     * A map of all the parts that this part depends on.
     */
    private TreeSet dependentParts = null;
    
    /**
     * A map of all the parts that use this part
     */
    private TreeSet usedBy;
    
    /**
     * A map of all the files that this part depends on.
     */
    private TreeMap dependentFiles = null;
    
    private TrappedErrorMap errors = null;
    
    /**
     * Creates a new instance of StepmodPart
     */
    public StepmodPart(STEPmod stepMod, String partName) {
        setName(partName);
        setStepMod(stepMod);
        setStepmodType();
        errors = new TrappedErrorMap(this);
        setUsedBy(new TreeSet());
        setupDependentFiles();
    }
    
    /**
     * Creates a new instance of StepmodPart
     */
    public StepmodPart() {
    }
    
    
    protected abstract void setStepmodType();
    
    /**
     * Returns the full path to the module directory
     * @return The full path to the module directory
     */
    public abstract String getDirectory();
    
    /**
     * Returns a string containing the full part number.
     * E.g. "Module: ISO 10303-439"
     * @return a string containing the full part number
     */
    public abstract String getPartNumberString();
    
    /**
     * Reads the module.xml, application_protocol.xml file and populates
     * the relevant attributes
     */
    public abstract void loadXml();
    
    
    /**
     * Deduce which parts this part is dependent on and store the results in
     * the TreeMap hasDependencies
     */
    public abstract void setupDependencies();
    
    public void setupDependentFiles() {
        dependentFiles = new TreeMap();
        setupDependentFiles("");
    }
    
    private void setupDependentFiles(String subDirectory) {
        String cvsEntriesFile;
        if (subDirectory.length() == 0) {
            cvsEntriesFile = this.getDirectory() + "/CVS/Entries";
        } else {
            cvsEntriesFile = this.getDirectory() + "/" + subDirectory + "/CVS/Entries";
        }
        try {
            BufferedReader in = new BufferedReader(new FileReader(cvsEntriesFile));
            String str;
            while ((str = in.readLine()) != null) {
                String[] fields = str.split("/");
                if (fields.length > 1) {
                    if (fields[0].equals("D")) {
                        // found a directory
                        String subDir = fields[1];
                        if (subDirectory.length() == 0) {
                            setupDependentFiles(subDir);
                        } else {
                            setupDependentFiles(subDirectory+"/"+subDir);
                        }
                    } else {
                        String name = fields[1];
                        String cvsRelease = fields[2];
                        String cvsDate = fields[3];
                        StepmodFile file = new StepmodFile(name, subDirectory, this, cvsRelease, cvsDate);
                        this.dependentFiles.put(file.toString(),file);
                    }
                }
            }
            in.close();
        } catch (IOException e) {
            // no file
        }
    }
    
    /**
     * Provide an HTML summary of the part
     */
    public String summaryHtml() {
        String summary = "<html><body>"
                + "<h2>"+getPartNumberString()+"</h2>"
                + this.summaryHtmlBody()
                + "</body></html>";
        return(summary);
    }
    
    
    /**
     * Provide the HTML body that is the summary of the part
     */
    public String summaryHtmlBody() {
        String cvsStateDscr = "";
        int cvsState = getCvsState();
        if (cvsState == CvsStatus.CVSSTATE_UNKNOWN) {
            cvsStateDscr = "ERROR -- Release status cannot be established";
        } else if (cvsState == CvsStatus.CVSSTATE_DEVELOPMENT) {
            cvsStateDscr = "Development release";
        } else if (cvsState == CvsStatus.CVSSTATE_RELEASE) {
            cvsStateDscr =  this.getCvsTag();
        }
        
        String cmDescr = "";
        int cmRecordState = getCmRecord().getCmRecordCvsStatus();
//        if (cmRecordState == CmRecord.CM_RECORD_NOT_CHANGED) {
//            cmDescr = "CM record modified but not saved to cm_record.xml";
//        } else
        if (cmRecordState == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
            cmDescr = "CM record modified but not saved to cm_record.xml";
        }
//        else if (cmRecordState == CmRecord.CM_RECORD_CHANGED_SAVED) {
//            cmDescr = " CM record modified and saved to cm_record.xml";
//        }else
        else if (cmRecordState == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
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
        
        String depDescr = "";
        if (this.isDependenciesCheckedOut()) {
            depDescr = "All dependent parts are checked out at the correct release.";
        } else {
            depDescr = "A number of dependent parts are not at the correct release.";
        }
        String summary =
                "<table>"
                + "<tr><td>Part Number:</td><td>"+getPartNumberString()+"</td></tr>"
                + "<tr><td>Part Name:</td><td>"+getName()+"</td></tr>"
                + "<tr><td>Checked out release:</td><td>" + cvsStateDscr +"</td></tr>"
                + "<tr><td>CM record revision:</td><td>" + getCmRecord().getCvsRevision() +"</td></tr>"
                + "<tr><td>CM record date:</td><td>" + getCmRecord().getCvsDate() +"</td></tr>"
                + "<tr><td>CM record status:</td><td>" + cmDescr +"</td></tr>"
                + "<tr><td>Dependency status:</td><td>" + depDescr +"</td></tr>"
                + "</table>";
        return(summary);
    }
    
    
    
    /**
     *  Read the cm_record.xml into the Cmrecord instance
     */
    public void readCmRecord() {
        cmRecord = new CmRecord(this);
        cmRecord.readCmRecord();
    }
    
    /**
     * Returns the name of StepmodPart
     * @return return the name of StepmodPart
     */
    public String getName() {
        return name;
    }
    
    /**
     * Sets the name of StepmodPart
     * @param name a String representing the name of StepmodPart
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * Returns the French name of StepmodPart
     * @return return the French name of StepmodPart
     */
    public String getNameFrench() {
        return nameFrench;
    }
    
    /**
     * Sets the French name of StepmodPart
     * @param nameFrench a String representing the French name of StepmodPart
     */
    public void setNameFrench(String nameFrench) {
        this.nameFrench = nameFrench;
    }
    
    /**
     * Returns a part number
     * @return return a part number
     *
     */
    public String getPartNumber() {
        return partNumber;
    }
    
    /**
     * Sets a part number
     * @param partNumber a String representing a partNumber
     */
    public void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }
    
    /**
     * Returns the version number of StepmodPart
     * @return return the version of StepmodPart
     */
    public String getVersion() {
        return version;
    }
    
    /**
     * Sets the version number of StepmodPart
     * @param version a String representing the version number of StepmodPart
     */
    
    public void setVersion(String version) {
        this.version = version;
    }
    
    /**
     * Returns the STEPmod type of the StepmodPart. Either:
     * module, resource_doc, application_protocol, resource
     */
    public String getStepmodType() {
        return stepmodType;
    }
    
    /**
     * Returns the wgNumber of the StepmodPart
     * @return return  the wgNumber of the StepmodPart
     */
    
    public String getWgNumber() {
        return wgNumber;
    }
    
    /**
     * Sets the wgNumber of the StepmodPart
     * @param wgNumber a String representing the wgNumber of the StepmodPart
     */
    public void setWgNumber(String wgNumber) {
        this.wgNumber = wgNumber;
    }
    
    /**
     * Returns the superseding wgNumber of the StepmodPart
     * @return return the wgNumberSupersedes of the StepmodPart
     */
    public String getWgNumberSupersedes() {
        return wgNumberSupersedes;
    }
    
    /**
     * Sets the superseding wgNumber of the StepmodPart
     * @param wgNumberSupersedes a String representing the wgNumberSupersedes
     * of the StepmodPart
     */
    public void setWgNumberSupersedes(String wgNumberSupersedes) {
        this.wgNumberSupersedes = wgNumberSupersedes;
    }
    
    /**
     * Returns the checklist for Internal review of the StepmodPart
     * @ return return the checklist for Internal Review of the StepmodPart
     */
    public String getChecklistInternalReview() {
        return checklistInternalReview;
    }
    
    /**
     * Sets the checklist for Internal review of the StepmodPart
     * @param checklistInternalReview a String representing the checklist for Internal Review
     * of the StepmodPart
     */
    public void setChecklistInternalReview(String checklistInternalReview) {
        this.checklistInternalReview = checklistInternalReview;
    }
    
    /**
     *  Returns the checklist for a Project leader of the StepmodPart
     *  @return return the checklist for a Project Leader of the StepmodPart
     */
    public String getChecklistProjectLeader() {
        return checklistProjectLeader;
    }
    
    /**
     * Sets the checklist for a Project leader of the StepmodPart
     * @param checklistProjectLeader a String representing the checklist for a Project Leader
     * of the StepmodPart
     */
    public void setChecklistProjectLeader(String checklistProjectLeader) {
        this.checklistProjectLeader = checklistProjectLeader;
    }
    
    /**
     * Returns the checklistconvener of the StepmodPart
     * @return return the checklistConvener of the StepmodPart
     */
    public String getChecklistConvener() {
        return checklistConvener;
    }
    
    /**
     * Sets the checklistConvener of the StepmodPart
     * @param checklistConvener a String representing the checklistConvener
     * of the StepmodPart
     */
    
    public void setChecklistConvener(String checklistConvener) {
        this.checklistConvener = checklistConvener;
    }
    
    /**
     * Returns the ISO status of the part. E.g. CD CD-TS TS DIS FDIS IS
     * @return return ISO stage of the part.
     */
    public String getIsoStatus() {
        return isoStatus;
    }
    
    /**
     * Sets the ISO status of the part. E.g. CD CD-TS TS DIS FDIS IS
     * @param status a String representing the status of the part
     */
    public void setIsoStatus(String status) {
        this.isoStatus = status;
    }
    
    /**
     * Returns the language of the StepmodPart
     * @return return the language of the StepmodPart
     */
    public String getLanguage() {
        return language;
    }
    
    /**
     * Sets the language of the StepmodPart
     * @param language a String representig the language of the StepmodPart
     */
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    /**
     * Return the publication year
     * @return return the year of publication for the StepmodPart
     */
    public String getPublicationYear() {
        return publicationYear;
    }
    
    /**
     * Sets the publication year
     * @param publicationYear a String representing the year of publication of the StepmodPart
     */
    public void setPublicationYear(String publicationYear) {
        this.publicationYear = publicationYear;
    }
    
    /**
     * Returns a publication date for a StepmodPart
     * @return return the publication date for the StepmodPart
     */
    public String getPublicationDate() {
        return publicationDate;
    }
    
    /**
     * Sets the publication date
     * @param publicationDate a String representing the date of publication for
     * the StepmodPart
     */
    public void setPublicationDate(String publicationDate) {
        this.publicationDate = publicationDate;
    }
    
    /**
     * Returns whether the StepmodPart has been published or not
     * @return boolean published
     */
    public boolean getPublished() {
        return published;
    }
    
    /**
     * Sets whether the StepmodPart has been published or not
     * @param published a boolean stating true or false
     */
    public void setPublished(boolean published) {
        this.published = published;
    }
    
    public void setSc4WorkingGroup(String sc4WorkingGroup) {
        this.sc4WorkingGroup = sc4WorkingGroup;
    }
    
    public String getSc4WorkingGroup() {
        return sc4WorkingGroup;
    }
    
    
    /**
     * Returns the configuration management record
     * @return the configuration management record for the StepmodPart
     */
    public CmRecord getCmRecord() {
        return cmRecord;
    }
    
    /**
     * Sets the configuration management record for the StepmodPart
     * @param cmRecord an instance of a CmRecord
     */
    public void setCmRecord(CmRecord cmRecord) {
        this.cmRecord = cmRecord;
    }
    
    /**
     * returns the part number and name
     * @return the Stepmodpart number and name as a String
     */
    public String toString() {
        return(getPartNumber() + ": "+ getName());
    }
    
    /**
     * prints out the StepmodPart type and name
     */
    
    public void print() {
        System.out.println(getStepmodType()+": " + getName());
    }
    
    /**
     * Returns an instance of StepMod
     * @return return the created instance of StepMod
     */
    public STEPmod getStepMod() {
        return stepMod;
    }
    
    /**
     * Sets the value of Stepmod to the created instance
     * @param stepMod is an instance of StepMod
     */
    public void setStepMod(STEPmod stepMod) {
        this.stepMod = stepMod;
    }
    
    /**
     * Execute a CVS update on this part
     *
     */
    public StepmodCvs cvsUpdate() {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        stepmodCvs.cvsUpdate(this.getDirectory());
        // The part may well have changed so reload it.
        this.loadXml();
        this.getCvsStatusObject().updateCvsStatus();
        return stepmodCvs;
    }
    
    
    /**
     * Execute a CVS Tag on this part
     *
     */
    public StepmodCvs cvsTag(String tag) {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        stepmodCvs.cvsTag(this.getDirectory(), tag);
        this.getCvsStatusObject().updateCvsStatus();
        return stepmodCvs;
    }
    
    
    /**
     * Delete an existing tag on this part
     */
    public StepmodCvs cvsDeleteTag(String tag) {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        stepmodCvs.cvsDeleteTag(this.getDirectory(), tag);
        this.getCvsStatusObject().updateCvsStatus();
        return stepmodCvs;
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of
     * a specified release
     *
     */
    public StepmodCvs cvsCoRelease(CmRelease cmRelease) {
        String tag = cmRelease.getId(); 
        return(cvsCoRelease(tag));
    }
    
        /**
     * Use StepModAnt to execute a CVS checkout of
     * a specified release
     *
     */
    public StepmodCvs cvsCoRelease(String tag) {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        stepmodCvs.cvsCoRelease(this.getDirectory(), tag);
        // The part may well have changed so reload it.
        this.loadXml();
        this.getCvsStatusObject().updateCvsStatus();
        return stepmodCvs;
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of the
     * latest release
     *
     */
    public StepmodCvs cvsCoLatestRelease() {
        CmRelease cmRelease = this.getCmRecord().getLatestRelease();
        return(cvsCoRelease(cmRelease));
    }
    
    /**
     * Use StepModAnt to execute a CVS checkout of the latest
     * published release
     *
     */
    public StepmodCvs cvsCoPublishedRelease() {
        CmRelease cmRelease = this.getCmRecord().getLatestPublishedRelease();
        return(cvsCoRelease(cmRelease));
    }
    
    /**
     * Commit the CMRecord to CVS
     */
    public StepmodCvs cvsCommitRecord() {
        CmRecord cmRecord = this.getCmRecord();
        cmRecord.writeCmRecord();
        
        StepmodCvs stepmodCvs = cmRecord.cvsCommit();
        if (stepmodCvs.getCvsExitVal() == StepmodCvs.CVS_ERROR_OK) {
            cmRecord.readCmRecord();
        }
        return(stepmodCvs);
    }
    
    
    /**
     * Updates the cm_record.xml file with the new releases that are stored in CmRecord class
     */
    public void updateCmRecordFile() {
        getStepMod().getStepModGui().toBeDone("STEPmod.updateCmRecordFile");
    }
    
    
    
    /**
     * Generates the identifier for a release of a part
     *
     * @return The release identifier.
     */
    public String getNextReleaseId() {
        // Get today's date
        Date date = new Date();
        Format formatter = new SimpleDateFormat("yyyyMMdd");
        String formattedDate = formatter.format(date);
        
        String type = "";
        if (this instanceof StepmodModule) {
            type = "mod";
        } else if (this instanceof StepmodApplicationProtocol) {
            type = "ap";
        } else if (this instanceof StepmodResourceDoc) {
            type = "resdoc";
        } else if (this instanceof StepmodResource) {
            type = "res";
        }
        String releaseId;
        /*
         * Count the number of releases of a part at a given edition and stage
         * increment. This is a component used to create the release identifier.
         */
        int relCount = 0;
        if (this instanceof StepmodResource) {
            relCount += this.getCmRecord().getHasCmReleases().size();
            String releaseSeq = "r"+relCount++;
            releaseId =
                    type + "-" + this.getName() +
                    "-" + releaseSeq +
                    "-" + formattedDate;
        } else {
            for (Iterator it = this.getCmRecord().getHasCmReleases().iterator(); it.hasNext();) {
                CmRelease cmRelease = (CmRelease) it.next();
                if (cmRelease.getEdition().equals(this.getVersion()) &&
                        cmRelease.getIsoStatus().equals(this.getIsoStatus())) {
                    relCount++;
                }
            }
            String releaseSeq = "r"+relCount++;
            releaseId =
                    type + "-" + this.getName() +
                    "-ed" + this.getVersion()  +
                    "-" + this.getIsoStatus() +
                    "-" + releaseSeq +
                    "-" + formattedDate;
        }
        
        
        return(releaseId);
    }
    
    /**
     * Generates the release date for the part
     */
    public String getReleaseDate() {
        Date date = new Date();
        Format formatter = new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss");
        return(formatter.format(date));
    }
    
    
    
    public CvsStatus getCvsStatusObject() {
        return cvsStatusObject;
    }
    
    public void setCvsStatusObject(CvsStatus cvsStatus) {
        this.cvsStatusObject = cvsStatus;
    }
    
    public int getCvsState() {
        return(this.getCvsStatusObject().getCvsState());
    }
    
    
    public String getCvsTag() {
        return (this.getCvsStatusObject().getCvsTag());
    }
    
    /**
     * Answer if the revision of the part checked out is a development revision
     * @return true if the revisions of the part checked out is a development revision
     */
    public boolean isCheckedOutDevelopment() {
        return(getCvsState() == CvsStatus.CVSSTATE_DEVELOPMENT);
    }
    
    /**
     * Answer if the revision of the part checked out is a release published by ISO
     * @return true if the revisions of the part checked out is a release published by ISO
     */
    public boolean isCheckedOutPublishedIsoRelease() {
        CmRecord cmRecord =  getCmRecord();
        CmRelease coRelease = null;
        if (cmRecord != null) {
            coRelease = cmRecord.getCheckedOutRelease();
            if (coRelease != null) {
                return(coRelease.isPublishedIsoRelease());
            }
        }
        return(false);
    }
    
    /**
     * Answer if the revisions of the part checked out is a revision that has been released.
     * I.e. Tagged in CVS and releases
     * @return true if the revisions of the part checked out is a revision that has been released
     */
    public boolean isCheckedOutRelease() {
        return(getCvsState() == CvsStatus.CVSSTATE_RELEASE);
    }
    
    /**
     * Answer true if all the dependencies of the current revision are the expected revisions
     */
    public boolean isDependenciesCheckedOut() {
        if (isCheckedOutDevelopment()) {
            return(true);
        } else {
            CmRelease checkedOutRel = this.getCmRecord().getCheckedOutRelease();
            if (checkedOutRel != null) {
                return(checkedOutRel.isDependenciesCheckedOut());
            }
        }
        return(true);
    }
    
    /**
     * Answer RELEASE_CHECK_OK if the part currently checked out, is OK for release.
     * Checks that all dependent parts are releases. If not return RELEASE_CHECK_ERROR_DEPENDENT_PARTS
     * Checks that the part is development part, not a release. If not return RELEASE_CHECK_ERROR_DEVELOPMENT_PART
     */
    public int okToRelease() {
        if (!isCheckedOutDevelopment()) {
            // make sure that the part is a development release
            return(StepmodPart.RELEASE_CHECK_ERROR_DEVELOPMENT_PART);
        } else {
            // make sure that all dependent parts have been checked out as releases
            for (Iterator it = this.getDependentParts().iterator(); it.hasNext();) {
                String dependentPartName = (String)it.next();
                StepmodPart part = stepMod.getPartByName(dependentPartName);
                // make sure that the part is not a development release and that the hecked out release is
                if (!part.isCheckedOutRelease()) {
                    return(StepmodPart.RELEASE_CHECK_ERROR_DEPENDENT_PARTS);
                }
            }
        }
        return(StepmodPart.RELEASE_CHECK_OK);
    }
    
    public String getRcsDate() {
        return rcsDate;
    }
    
    public void setRcsDate(String rcsDate) {
        this.rcsDate = rcsDate;
    }
    
    public String getRcsRevision() {
        return rcsRevision;
    }
    
    public void setRcsRevision(String rcsRevision) {
        this.rcsRevision = rcsRevision;
    }
    
    public TrappedErrorMap getErrors() {
        return errors;
    }
    
    /**
     * Return the tree map that lists all the parts on which this is dependent.
     */
    public TreeSet getDependentParts() {
        return this.dependentParts;
    }
    
    /**
     * Return the tree map that lists all the parts that are used by this part.
     */
    public TreeSet getUsedBy() {
        return usedBy;
    }
    
    public void setDependentParts(TreeSet dependencies) {
        this.dependentParts = dependencies;
    }
    
    public void setUsedBy(TreeSet usedBy) {
        this.usedBy = usedBy;
    }
    
    public void addUsedBy(StepmodPart part) {
        this.usedBy.add(part);
    }
    
    public void addDependentPart(StepmodPart part) {
        this.dependentParts.add(part.getName());
        part.addUsedBy(this);
    }
    
    public boolean isDependentPart(StepmodPart part) {
        return(this.dependentParts.contains(part.getName()));
    }
    
    public void addDependencies(TreeSet dependencySet) {
        this.getDependentParts().addAll(dependencySet);
    }
    
    
    
    
    public ExpressSaxHandler readExpressInterface(String expressFileName) {
        ExpressSaxHandler expressSaxHandler = new ExpressSaxHandler(this.getStepMod(),this, expressFileName);
        // Use the default (non-validating) parser
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            // Parse the input
            SAXParser saxParser = factory.newSAXParser();
            File expressFile =  new File(expressFileName);
            saxParser.parse(expressFile, expressSaxHandler);
        } catch (ParserConfigurationException ex) {
            TrappedError error = this.getErrors().addError(this,expressFileName,ex);
            error.output();
        } catch (SAXException ex) {
            // a bit of a hack -- only need to read the interfaces
            // so  parser throws StepmodReadSAXException once all have been read
            if (ex instanceof StepmodReadSAXException) {
                // finished reading the interfaces
                // for each interface, check that the module already exists,
                if (expressSaxHandler.foundInterfacedFiles()) {
                    for (Iterator it=expressSaxHandler.getInterfacedFiles().entrySet().iterator(); it.hasNext(); ) {
                        Map.Entry entry = (Map.Entry)it.next();
                        String partName = (String)entry.getKey();
                        Object partValue = entry.getValue();
                        StepmodPart part = null;
                        if (partValue instanceof String) {
                            String partType = (String) partValue;
                            if (partType.equals("module")) {
                                // indicates that the part is a module that has not been loaded
                                // make sure that the part has not been loaded elsewhere.
                                part = this.stepMod.getModuleByName(partName);
                                if (part == null) {
                                    if (this.getStepMod().partExists(partName, "module")) {
                                        part = new StepmodModule(this.getStepMod(), partName);
                                    } else {
                                        this.getStepMod().output("Error: reading  "+ expressFileName +"\n " +partName+" does not exist");
                                        //TrappedError error = this.getErrors().addError(this,expressFileName,ex);
                                    }
                                }
                            } else if (partType.equals("resource")) {
                                // indicates that the part is a resources schema that has not been loaded
                                part = this.stepMod.getResourceByName(partName);
                                if (part == null) {
                                    if (this.getStepMod().partExists(partName, "resource")) {
                                        part = new StepmodResource(this.getStepMod(), partName);
                                    } else {
                                        this.getStepMod().output("Error: reading  "+ expressFileName +"\n " +partName+" does not exist");
                                    }
                                }
                            }
                        } else {
                            part = (StepmodPart) partValue;
                        }
                        if (part != null) {
                            if (!this.isDependentPart(part)) {
                                // add the part
                                this.addDependentPart(part);
                                // a new dependency, so add all its dependencies
                                this.addDependencies(part.getDependentParts());
                            }
                        }
                    }
                }
            } else {
                // A real error
                TrappedError error = this.getErrors().addError(this,expressFileName,ex);
                error.output();
            }
        } catch (IOException ex) {
            TrappedError error = this.getErrors().addError(this,expressFileName,ex);
            error.output();
        }
        return(expressSaxHandler);
    }
    
    public TreeMap getDependentFiles() {
        return dependentFiles;
    }
    
    public int compareTo(Object o) {
        StepmodPart stepmodPart = (StepmodPart) o;
        return(name.compareTo(stepmodPart.getName()));
    }
    
    public int compare(Object o1, Object o2) {
        StepmodPart stepmodPart1 = (StepmodPart) o1;
        StepmodPart stepmodPart2 = (StepmodPart) o2;
        return(stepmodPart1.getName().compareTo(stepmodPart2.getName()));
    }
}
