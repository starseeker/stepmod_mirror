/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * STEPModMkReleaseDialog.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */


package org.stepmod.gui;

import java.util.ArrayList;
import java.util.Iterator;
import javax.swing.JOptionPane;
import javax.swing.tree.DefaultMutableTreeNode;
import org.stepmod.CmRecord;
import org.stepmod.CmRelease;
import org.stepmod.StepmodPart;
import org.stepmod.cvschk.StepmodCvs;

/**
 *
 * @author  Rob Bodington
 */
public class STEPModMkReleaseDialog extends javax.swing.JDialog {
    
    private StepmodPart part;
    private DefaultMutableTreeNode node;
    private CmRelease cmRelease;
    private ArrayList selectedParts;
    private String existingTag;
    
    private STEPModFrame stepmodGui;
    
    /**
     * Creates new form STEPModMkReleaseDialog for creating a new release
     */
    public STEPModMkReleaseDialog(StepmodPart part, DefaultMutableTreeNode node) {
        super(part.getStepMod().getStepModGui(), true);
        this.stepmodGui = part.getStepMod().getStepModGui();
        initComponents();
        this.part = part;
        this.node = node;
        releasePartNamejTextField.setText(part.getName());
        releasePartNumberjTextField.setText("ISO 10303-"+part.getPartNumber());
        releasePartIsoStatusjTextField.setText(part.getIsoStatus());
        releaseDatejTextField.setText(part.getReleaseDate());
        releaseIdjTextField.setText(part.getNextReleaseId());
        releaseWhojTextField.setText(part.getStepMod().getStepmodProperty("SFORGE_USERNAME"));
    }
    
    
    /**
     * Creates new form STEPModMkReleaseDialog for creating a  release from an existing tag
     */
    public STEPModMkReleaseDialog(StepmodPart part, DefaultMutableTreeNode node, String tag) {
        super(part.getStepMod().getStepModGui(), true);
        this.stepmodGui = part.getStepMod().getStepModGui();
        initComponents();
        this.part = part;
        this.node = node;
        this.existingTag = tag;
        releasePartNamejTextField.setText(part.getName());
        releasePartNumberjTextField.setText("ISO 10303-"+part.getPartNumber());
        releasePartIsoStatusjTextField.setText(part.getIsoStatus());
        releaseDatejTextField.setText("??");
        releaseIdjTextField.setText(tag);
        releaseWhojTextField.setText(part.getStepMod().getStepmodProperty("SFORGE_USERNAME"));
    }
    
    /**
     * Creates new form STEPModMkReleaseDialog for altering the status of a new release
     */
    public STEPModMkReleaseDialog(StepmodPart part, DefaultMutableTreeNode node, CmRelease cmRelease) {
        super(part.getStepMod().getStepModGui(), true);
        this.stepmodGui = part.getStepMod().getStepModGui();
        initComponents();
        this.part = part;
        this.node = node;
        this.cmRelease = cmRelease;
        this.titleLabel.setText("Change the status of release");
        releasePartNamejTextField.setText(part.getName());
        releasePartNumberjTextField.setText("ISO 10303-"+part.getPartNumber());
        releasePartIsoStatusjTextField.setText(part.getIsoStatus());
        releaseDatejTextField.setText(cmRelease.getReleaseDate());
        releaseIdjTextField.setText(cmRelease.getId());
        releaseWhojTextField.setText(part.getStepMod().getStepmodProperty("SFORGE_USERNAME"));
    }
    
    private void createReleaseOnSinglePart() {
        STEPModFrame stepmodGui = part.getStepMod().getStepModGui();
        CmRecord cmRecord = part.getCmRecord();
        if (cmRelease == null) {
            if (existingTag == null) {
                // Create a new release
                String releaseId = part.getNextReleaseId();
                int answer = JOptionPane.showConfirmDialog(this,
                        "You are about to create the CVS tag \""+releaseId+"\" on \""+part.getName()+"\"\nDo you want to continue?",
                        "CVS action ....",
                        JOptionPane.YES_NO_OPTION);
                if (answer == JOptionPane.YES_OPTION) {
                    StepmodCvs stepmodCvs = part.cvsTag(releaseId);
                    stepmodGui.outputCvsResults(stepmodCvs);
                    if (stepmodCvs.getCvsErrorVal() == 0) {
                        // successfully tagged the part, so create the record
                        String releaseSequence = "r"+cmRecord.getHasCmReleases().size();
                        CmRelease cmRelease = new CmRelease(
                                releaseId, part,
                                releaseWhojTextField.getText(),
                                (String)releaseStatusjComboBox.getSelectedItem(),
                                releaseDescriptionjEditorPane.getText());
                        stepmodGui.addReleaseToTree(part, cmRelease, node, true);
                        // now check out the tagged version
                        part.cvsCoRelease(cmRelease);
                        stepmodGui.outputCvsResults(stepmodCvs);
                        // Successfully tagged the part, so save the record
                        cmRecord.writeCmRecord();
                    } else {
                        JOptionPane.showMessageDialog(this,"CVS tagging action failed.","CVS action ....",JOptionPane.WARNING_MESSAGE);
                    }
                }
            } else {
                // Create a new release from an exisitng tag
                int answer = JOptionPane.showConfirmDialog(this,
                        "You are about to convert the CVS tag \""+existingTag+"\" on \""+part.getName()+" to a release.\"\nDo you want to continue?",
                        "CVS action ....",
                        JOptionPane.YES_NO_OPTION);
                if (answer == JOptionPane.YES_OPTION) {
                    CmRelease cmRelease = new CmRelease(
                            existingTag, part,
                            releaseWhojTextField.getText(),
                            (String)releaseStatusjComboBox.getSelectedItem(),
                            releaseDescriptionjEditorPane.getText());
                    stepmodGui.addReleaseToTree(part, cmRelease, node, true);
                    // Successfully tagged the part, so save the record
                    cmRecord.writeCmRecord();
                }
            }
        } else {
            stepmodGui.updateReleaseStatus(part, cmRelease, (String)releaseStatusjComboBox.getSelectedItem(), (String)releaseDescriptionjEditorPane.getText(), node, true);
            cmRecord.writeCmRecord();
        }
        this.setVisible(false);
        this.dispose();
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc=" Generated Code ">//GEN-BEGIN:initComponents
    private void initComponents() {
        jLabel1 = new javax.swing.JLabel();
        canceljButton = new javax.swing.JButton();
        okjButton = new javax.swing.JButton();
        releaseStatusjComboBox = new javax.swing.JComboBox();
        titleLabel = new javax.swing.JLabel();
        releaseDatejLabel = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        releaseDescriptionjEditorPane = new javax.swing.JEditorPane();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        releasePartNumberjTextField = new javax.swing.JTextField();
        releaseIdjTextField = new javax.swing.JTextField();
        releaseDatejTextField = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        releasePartNamejTextField = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        releaseWhojTextField = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        releasePartIsoStatusjTextField = new javax.swing.JTextField();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        jLabel1.setText("Release identifier:");

        canceljButton.setText("Cancel");
        canceljButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                canceljButtonActionPerformed(evt);
            }
        });

        okjButton.setText("OK");
        okjButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                okjButtonActionPerformed(evt);
            }
        });

        releaseStatusjComboBox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Team review", "Convener review", "Secretariat review", "ISO review", "Ballot", "ISO publication" }));

        titleLabel.setFont(new java.awt.Font("Tahoma", 1, 12));
        titleLabel.setText("Create a new release");

        releaseDatejLabel.setText("Release date:");

        jLabel4.setText("Release status:");

        jScrollPane1.setViewportView(releaseDescriptionjEditorPane);

        jLabel5.setText("Description:");

        jLabel6.setText("Part number:");

        releasePartNumberjTextField.setEditable(false);
        releasePartNumberjTextField.setHorizontalAlignment(javax.swing.JTextField.LEFT);
        releasePartNumberjTextField.setText("jTextField1");

        releaseIdjTextField.setEditable(false);
        releaseIdjTextField.setText("jTextField2");

        releaseDatejTextField.setEditable(false);
        releaseDatejTextField.setText("jTextField3");

        jLabel3.setText("Part name:");

        releasePartNamejTextField.setEditable(false);
        releasePartNamejTextField.setText("jTextField1");

        jLabel7.setText("Released by:");

        releaseWhojTextField.setText("jTextField1");

        jLabel8.setText("Part ISO status:");

        releasePartIsoStatusjTextField.setEditable(false);
        releasePartIsoStatusjTextField.setText("jTextField1");

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, 256, Short.MAX_VALUE)
                        .add(okjButton)
                        .add(14, 14, 14)
                        .add(canceljButton))
                    .add(layout.createSequentialGroup()
                        .add(22, 22, 22)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(jLabel5)
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
                                    .add(layout.createSequentialGroup()
                                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                                            .add(releaseDatejLabel)
                                            .add(jLabel1)
                                            .add(jLabel6)
                                            .add(jLabel3)
                                            .add(jLabel8))
                                        .add(12, 12, 12)
                                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                                            .add(releaseDatejTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                                            .add(releaseIdjTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                                            .add(releasePartNamejTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                                            .add(releasePartNumberjTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                                            .add(releasePartIsoStatusjTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)))
                                    .add(org.jdesktop.layout.GroupLayout.LEADING, layout.createSequentialGroup()
                                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                                            .add(jLabel4)
                                            .add(jLabel7))
                                        .add(12, 12, 12)
                                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                                            .add(releaseWhojTextField, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                                            .add(releaseStatusjComboBox, 0, 238, Short.MAX_VALUE))))
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)))
                        .add(23, 23, 23))
                    .add(titleLabel)
                    .add(layout.createSequentialGroup()
                        .add(22, 22, 22)
                        .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 349, Short.MAX_VALUE)
                        .add(11, 11, 11)))
                .addContainerGap())
        );

        layout.linkSize(new java.awt.Component[] {jLabel1, jLabel4, jLabel5, releaseDatejLabel}, org.jdesktop.layout.GroupLayout.HORIZONTAL);

        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(titleLabel)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel6)
                    .add(releasePartNumberjTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel3)
                    .add(releasePartNamejTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel8)
                    .add(releasePartIsoStatusjTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel1)
                    .add(releaseIdjTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(releaseDatejLabel)
                    .add(releaseDatejTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel4)
                    .add(releaseStatusjComboBox, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(jLabel7)
                    .add(releaseWhojTextField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(jLabel5)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 143, Short.MAX_VALUE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(okjButton)
                    .add(canceljButton))
                .addContainerGap())
        );
        pack();
    }// </editor-fold>//GEN-END:initComponents
    
    private void canceljButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_canceljButtonActionPerformed
        this.setVisible(false);
        this.dispose();
    }//GEN-LAST:event_canceljButtonActionPerformed
    
    private void okjButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_okjButtonActionPerformed
        createReleaseOnSinglePart();
    }//GEN-LAST:event_okjButtonActionPerformed
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton canceljButton;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JButton okjButton;
    private javax.swing.JLabel releaseDatejLabel;
    private javax.swing.JTextField releaseDatejTextField;
    private javax.swing.JEditorPane releaseDescriptionjEditorPane;
    private javax.swing.JTextField releaseIdjTextField;
    private javax.swing.JTextField releasePartIsoStatusjTextField;
    private javax.swing.JTextField releasePartNamejTextField;
    private javax.swing.JTextField releasePartNumberjTextField;
    private javax.swing.JComboBox releaseStatusjComboBox;
    private javax.swing.JTextField releaseWhojTextField;
    private javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
    
}
