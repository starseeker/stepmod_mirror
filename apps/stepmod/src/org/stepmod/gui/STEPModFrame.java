/*
 * STEPModFrame.java
 *
 * Created on 24 April 2006, 09:07
 *
 */

package org.stepmod.gui;

import java.awt.Color;
import java.awt.Component;
import java.awt.Insets;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Enumeration;
import java.util.EventObject;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import javax.swing.AbstractCellEditor;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JOptionPane;
import javax.swing.JSeparator;
import javax.swing.JTree;
import javax.swing.SwingUtilities;
import javax.swing.ToolTipManager;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeCellEditor;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;
import org.stepmod.CmRecord;
import org.stepmod.CmRelease;
import org.stepmod.STEPmod;
import org.stepmod.StepmodApplicationProtocol;
import org.stepmod.StepmodFile;
import org.stepmod.StepmodModule;
import org.stepmod.StepmodPart;
import org.stepmod.StepmodResource;
import org.stepmod.StepmodResourceDoc;
import org.stepmod.cvschk.CvsStatus;
import org.stepmod.cvschk.StepmodCvs;

/**
 *
 * @author  Rob Bodington
 */
public class STEPModFrame extends javax.swing.JFrame {
    
    /**
     * The popup menu associated with a module in the module tree
     */
    private PopupMenuWithObject stepmodPartPopupMenu;
    
    /**
     * The popup menu associated with a release in the module tree
     */
    private PopupMenuWithObject releasePopupMenu;
    
    /**
     * The popup menu associated with a development revisions in the module tree
     */
    private PopupMenuWithObject devRevisionPopupMenu;
    
    
    /**
     * The popup menu associated with teh list of modules n the module tree
     */
    private PopupMenuWithObject allModulesPopupMenu;
    
    /**
     * The STEPmod object that this is the GUI for.
     */
    private STEPmod stepMod;
    
    /**
     * The object being currently displayed in the ouput pane
     */
    private Object currentDisplayedObject;
    
    /**
     * The sub tree for the modules
     */
    private DefaultMutableTreeNode modulesTreeNode;
    
    /**
     * The sub tree for the application protocols
     */
    private DefaultMutableTreeNode applicationProtocolsTreeNode;
    
    /**
     * The sub tree for the resource docs
     */
    private DefaultMutableTreeNode resourceDocsTreeNode;
    
    /**
     * The sub tree for the resources
     */
    private DefaultMutableTreeNode resourceSchemasTreeNode;
    
    /**
     * The collection of module nodes
     */
    private StepmodPartTreeNodeCollection modulesTreeNodeCollection;
    
    /**
     * The collection of application protocol nodes
     */
    private StepmodPartTreeNodeCollection apTreeNodeCollection;
    
    /**
     * The collection of resource doc nodes
     */
    private StepmodPartTreeNodeCollection resourceDocsTreeNodeCollection;
    
    /**
     * The collection of schema nodes
     */
    private StepmodPartTreeNodeCollection schemasTreeNodeCollection;
    
    private javax.swing.JMenuItem createCmRecordMenuItem;
    private javax.swing.JMenuItem commitCmRecordMenuItem;
    private javax.swing.JMenuItem saveCmRecordMenuItem;
    
    
    /**
     * Creates new form STEPModFrame
     */
    public STEPModFrame() {
        initComponents();
    }
    
    /**
     * Creates new form STEPModFrame
     */
    public STEPModFrame(STEPmod stepMod) {
        this.stepMod = stepMod;
        initComponents();
        repositoryTextPane.setContentType("text/html");
        
        stepModOutputTextArea.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent evt) {
                outputPopupMenu.show(evt.getComponent(), evt.getX(), evt.getY());
            }
            public void mouseReleased(MouseEvent evt) {
                if (evt.isPopupTrigger()) {
                    outputPopupMenu.show(evt.getComponent(), evt.getX(), evt.getY());
                }
            }
        });
    }
    
    
    /**
     * A object used in the repository tree to indicate whether the cm release has been
     * selected or not
     */
    private class CmReleaseTreeNode {
        CmRelease cmRelease;
        StepmodPart part;
        String text;
        boolean selected;
        boolean checkedOutRevision;
        
        public CmReleaseTreeNode(StepmodPart part, CmRelease cmRelease, boolean selected) {
            this.part = part;
            this.cmRelease = cmRelease;
            this.text = cmRelease.toString();
            this.selected = selected;
        }
        
        public CmReleaseTreeNode(StepmodPart part, String text, boolean selected) {
            this.part = part;
            this.cmRelease = null;
            this.text = text;
            this.selected = selected;
            if (part instanceof StepmodModule) {
                StepmodModule module = (StepmodModule) part;
                if (module.getCvsState() == CvsStatus.CVSSTATE_DEVELOPMENT) {
                    this.checkedOutRevision = true;
                } else {
                    this.checkedOutRevision = false;
                }
            }
        }
        
        public boolean isSelected() {
            return selected;
        }
        
        public void setSelected(boolean newValue) {
            selected = newValue;
        }
        
        public String getText() {
            return(text);
        }
        
        public String toString() {
            String str = "";
            if (cmRelease != null) {
                str = getText();
            } else {
                str = text;
            }
            return str;
        }
        
        private CmRelease getCmRelease() {
            return cmRelease;
        }
        
        private StepmodPart getStepmodPart() {
            return part;
        }
    }
    
    
    private class StepmodPartTreeNodeCollection {
        private TreeMap hasStepmodPartTreeNodes;
        private DefaultMutableTreeNode treeNode;
        private String text;
        
        public StepmodPartTreeNodeCollection(String text, DefaultMutableTreeNode treeNode) {
            this.treeNode = treeNode;
            this.hasStepmodPartTreeNodes = new TreeMap();
            this.text = text;
        }
        
        public TreeMap getHasStepmodPartTreeNodes() {
            return hasStepmodPartTreeNodes;
        }
        
        public void setHasStepmodPartTreeNodes(TreeMap hasStepmodPartTreeNodes) {
            this.hasStepmodPartTreeNodes = hasStepmodPartTreeNodes;
        }
        
        public DefaultMutableTreeNode getNodeForPart(String partName) {
            return((DefaultMutableTreeNode) hasStepmodPartTreeNodes.get(partName));
        }
        
        public DefaultMutableTreeNode getNodeForPart(StepmodPart part) {
            return((DefaultMutableTreeNode) hasStepmodPartTreeNodes.get(part.getName()));
        }
        
        public void addPart(String partName, DefaultMutableTreeNode partTreeNode) {
            hasStepmodPartTreeNodes.put(partName, partTreeNode);
        }
        
        public void addPart(StepmodPart part, DefaultMutableTreeNode partTreeNode) {
            hasStepmodPartTreeNodes.put(part.getName(), partTreeNode);
        }
        
        public DefaultMutableTreeNode getTreeNode() {
            return(treeNode);
        }
        
        public String toString() {
            return(text);
        }
        
    }
    
    /**
     * A object used in the repository tree to indicate whether the StepmodPart has been
     * selected or not
     */
    private class StepmodPartTreeNode {
        CmRelease cmRelease;
        StepmodPart part;
        String text;
        boolean selected;
        boolean checkedOutRevision;
        
        public StepmodPartTreeNode(StepmodPart part, boolean selected) {
            this.part = part;
            this.text = part.toString();
            this.selected = selected;
            if (part instanceof StepmodPart) {
                if (part.getCvsState() == CvsStatus.CVSSTATE_DEVELOPMENT) {
                    this.checkedOutRevision = true;
                } else {
                    this.checkedOutRevision = false;
                }
            }
        }
        
        public boolean isSelected() {
            return selected;
        }
        
        public void setSelected(boolean newValue) {
            selected = newValue;
        }
        
        public String getText() {
            return(text);
        }
        
        
        public String toString() {
            String str = "";
            if (cmRelease != null) {
                str = getText();
            } else {
                str = text;
            }
            return str;
        }
        
        private CmRelease getCmRelease() {
            return cmRelease;
        }
        
        private StepmodPart getStepmodPart() {
            return part;
        }
    }
    
    /**
     * Cell renderer for the STEPmod repository tree
     */
    private class RepositoryTreeRenderer extends DefaultTreeCellRenderer {
        private Icon publishedIconSelected;
        private Icon releasedIconSelected;
        private Icon developmentIconSelected;
        private Icon publishedIconUnSelected;
        private Icon releasedIconUnSelected;
        private Icon developmentIconUnSelected;
        
        private Icon devSelCvsModIcon;
        private Icon devUnSelCvsModIcon;
        private Icon relSelCvsModIcon;
        private Icon relUnSelCvsModIcon;
        private Icon pubSelCvsModIcon;
        private Icon pubUnSelCvsModIcon;
        private Icon devSelCvsIcon;
        private Icon devUnSelCvsIcon;
        private Icon relSelCvsIcon;
        private Icon relUnSelCvsIcon;
        private Icon pubSelCvsIcon;
        private Icon pubUnSelCvsIcon;
        private Icon devSelCvsUnknownIcon;
        private Icon devUnSelCvsUnknownIcon;
        private Icon devSelCvsAddIcon;
        private Icon devUnSelCvsAddIcon;
        private Icon devSelCvsNoFileIcon;
        private Icon devUnSelCvsNoFileIcon;
        
        private JCheckBox checkBoxRenderer = new JCheckBox();
        private Color selectionForeground;
        private Color selectionBackground;
        private Color textForeground;
        private Color textBackground;
        private Color currentBackground;
        
        public RepositoryTreeRenderer() {
            java.net.URL devSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_selected_cvsmod.png");
            devSelCvsModIcon = null;
            if (devSelCvsModIconURL != null) {
                devSelCvsModIcon= new ImageIcon(devSelCvsModIconURL);
            }
            java.net.URL devUnSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_unselected_cvsmod.png");
            devUnSelCvsModIcon = null;
            if (devUnSelCvsModIconURL != null) {
                devUnSelCvsModIcon= new ImageIcon(devUnSelCvsModIconURL);
            }
            java.net.URL relSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_selected_cvsmod.png");
            relSelCvsModIcon = null;
            if (relSelCvsModIconURL != null) {
                relSelCvsModIcon= new ImageIcon(relSelCvsModIconURL);
            }
            java.net.URL relUnSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_unselected_cvsmod.png");
            relUnSelCvsModIcon = null;
            if (relUnSelCvsModIconURL != null) {
                relUnSelCvsModIcon= new ImageIcon(relUnSelCvsModIconURL);
            }
            java.net.URL pubSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_selected_cvsmod.png");
            pubSelCvsModIcon = null;
            if (pubSelCvsModIconURL != null) {
                pubSelCvsModIcon= new ImageIcon(pubSelCvsModIconURL);
            }
            java.net.URL pubUnSelCvsModIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_unselected_cvsmod.png");
            pubUnSelCvsModIcon = null;
            if (pubUnSelCvsModIconURL != null) {
                pubUnSelCvsModIcon= new ImageIcon(pubUnSelCvsModIconURL);
            }
            
            java.net.URL devSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_selected_cvs.png");
            devSelCvsIcon = null;
            if (devSelCvsIconURL != null) {
                devSelCvsIcon= new ImageIcon(devSelCvsIconURL);
            }
            java.net.URL devUnSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_unselected_cvs.png");
            devUnSelCvsIcon = null;
            if (devUnSelCvsIconURL != null) {
                devUnSelCvsIcon= new ImageIcon(devUnSelCvsIconURL);
            }
            java.net.URL relSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_selected_cvs.png");
            relSelCvsIcon = null;
            if (relSelCvsIconURL != null) {
                relSelCvsIcon= new ImageIcon(relSelCvsIconURL);
            }
            java.net.URL relUnSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_unselected_cvs.png");
            relUnSelCvsIcon = null;
            if (relUnSelCvsIconURL != null) {
                relUnSelCvsIcon= new ImageIcon(relUnSelCvsIconURL);
            }
            java.net.URL pubSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_selected_cvs.png");
            pubSelCvsIcon = null;
            if (pubSelCvsIconURL != null) {
                pubSelCvsIcon= new ImageIcon(pubSelCvsIconURL);
            }
            java.net.URL pubUnSelCvsIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_unselected_cvs.png");
            pubUnSelCvsIcon = null;
            if (pubUnSelCvsIconURL != null) {
                pubUnSelCvsIcon= new ImageIcon(pubUnSelCvsIconURL);
            }
            java.net.URL devSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_selected_cvsunknown.png");
            devSelCvsUnknownIcon = null;
            if (devSelCvsUnknownIconURL != null) {
                devSelCvsUnknownIcon= new ImageIcon(devSelCvsUnknownIconURL);
            }
            java.net.URL devUnSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_unselected_cvsunknown.png");
            devUnSelCvsUnknownIcon = null;
            if (devUnSelCvsUnknownIconURL != null) {
                devUnSelCvsUnknownIcon= new ImageIcon(devUnSelCvsUnknownIconURL);
            }
            java.net.URL devSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_selected_cvsadd.png");
            devSelCvsAddIcon = null;
            if (devSelCvsAddIconURL != null) {
                devSelCvsAddIcon= new ImageIcon(devSelCvsAddIconURL);
            }
            java.net.URL devUnSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_unselected_cvsadd.png");
            devUnSelCvsAddIcon = null;
            if (devUnSelCvsAddIconURL != null) {
                devUnSelCvsAddIcon= new ImageIcon(devUnSelCvsAddIconURL);
            }
            java.net.URL devSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_selected_cvsnofile.png");
            devSelCvsNoFileIcon = null;
            if (devSelCvsNoFileIconURL != null) {
                devSelCvsNoFileIcon= new ImageIcon(devSelCvsNoFileIconURL);
            }
            java.net.URL devUnSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/dev_unselected_cvsnofile.png");
            devUnSelCvsNoFileIcon = null;
            if (devUnSelCvsNoFileIconURL != null) {
                devUnSelCvsNoFileIcon= new ImageIcon(devUnSelCvsNoFileIconURL);
            }
            java.net.URL publishedIconUnSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/published_box.png");
            publishedIconUnSelected = null;
            if (publishedIconUnSelectedURL != null) {
                publishedIconUnSelected= new ImageIcon(publishedIconUnSelectedURL);
            }
            java.net.URL releasedIconUnSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/released_box.png");
            releasedIconUnSelected = null;
            if (releasedIconUnSelectedURL != null) {
                releasedIconUnSelected= new ImageIcon(releasedIconUnSelectedURL);
            }
            java.net.URL developmentIconUnSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/development_box.png");
            developmentIconUnSelected = null;
            if (developmentIconUnSelectedURL != null) {
                developmentIconUnSelected= new ImageIcon(developmentIconUnSelectedURL);
            }
            java.net.URL publishedIconSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/published_box_selected.png");
            publishedIconSelected = null;
            if (publishedIconSelectedURL != null) {
                publishedIconSelected= new ImageIcon(publishedIconSelectedURL);
            }
            java.net.URL releasedIconSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/released_box_selected.png");
            releasedIconSelected = null;
            if (releasedIconSelectedURL != null) {
                releasedIconSelected= new ImageIcon(releasedIconSelectedURL);
            }
            java.net.URL developmentIconSelectedURL = STEPModFrame.class.getResource("/org/stepmod/resources/development_box_selected.png");
            developmentIconSelected = null;
            if (developmentIconSelectedURL != null) {
                developmentIconSelected= new ImageIcon(developmentIconSelectedURL);
            }
            
            selectionForeground = UIManager.getColor("Tree.selectionForeground");
            selectionBackground = UIManager.getColor("Tree.selectionBackground");
            textForeground = UIManager.getColor("Tree.textForeground");
            textBackground = UIManager.getColor("Tree.textBackground");
            currentBackground = Color.YELLOW;
        }
        
        protected JCheckBox getCheckBoxRenderer() {
            return checkBoxRenderer;
        }
        
        /**
         * Called from getTreeCellRendererComponent. Draws the nodes for the cmReleaseTreeNode in the tree
         */
        private void setupIconsForCmRelease(JTree tree, boolean sel, CmReleaseTreeNode cmReleaseTreeNode) {
            StepmodPart stepmodPart = cmReleaseTreeNode.getStepmodPart();
            checkBoxRenderer.setText(cmReleaseTreeNode.toString());
            checkBoxRenderer.setSelected(cmReleaseTreeNode.isSelected());
            checkBoxRenderer.setEnabled(tree.isEnabled());
            // make sure that the icon is as far left as possible
            checkBoxRenderer.setMargin(new Insets(0,-2,0,0));
            CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
            StepmodPart part = cmReleaseTreeNode.getStepmodPart();
            boolean checkedOutrel = false;
            if (cmRelease == null) {
                if (cmReleaseTreeNode.getStepmodPart().getCvsState() == CvsStatus.CVSSTATE_NOT_CHECKED_OUT) {
                    // The module has not been checked out
                    // TODO - need to check the state correctly
                    // Need to first see if the part file has been correctly read
                    checkBoxRenderer.setIcon(devUnSelCvsNoFileIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsNoFileIcon);
                    checkBoxRenderer.setToolTipText("Not checked out");
                } else {
                    // The part has no tag therefore must be a development release
                    checkedOutrel = cmReleaseTreeNode.getStepmodPart().getCvsTag().length() == 0;
                    checkBoxRenderer.setIcon(developmentIconUnSelected);
                    checkBoxRenderer.setSelectedIcon(developmentIconSelected);
                    checkBoxRenderer.setToolTipText("Development revision");
                }
            } else  {
                checkedOutrel = cmRelease.isCheckedOutRelease();
                if (cmRelease.isPublishedIsoRelease()) {
                    checkBoxRenderer.setIcon(publishedIconUnSelected);
                    checkBoxRenderer.setSelectedIcon(publishedIconSelected);
                    checkBoxRenderer.setToolTipText("Release is published by ISO");
                } else {
                    checkBoxRenderer.setIcon(releasedIconUnSelected);
                    checkBoxRenderer.setSelectedIcon(releasedIconSelected);
                    checkBoxRenderer.setToolTipText("Release");
                }
            }
            // Highlight according to whether the tree node is selected (as opposed to the checkbox)
            if (sel) {
                checkBoxRenderer.setForeground(selectionForeground);
                checkBoxRenderer.setBackground(selectionBackground);
            } else if (checkedOutrel) {
                checkBoxRenderer.setForeground(textForeground);
                checkBoxRenderer.setBackground(currentBackground);
            } else {
                checkBoxRenderer.setForeground(textForeground);
                checkBoxRenderer.setBackground(textBackground);
            }
        }
        
        /**
         * Called from getTreeCellRendererComponent. Draws the nodes for the stepmod part in the tree
         */
        private void setupIconsForStepmodPart(JTree tree, boolean sel, StepmodPartTreeNode stepmodPartTreeNode) {
            StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
            checkBoxRenderer.setText(stepmodPartTreeNode.toString());
            checkBoxRenderer.setSelected(stepmodPartTreeNode.isSelected());
            checkBoxRenderer.setEnabled(tree.isEnabled());
            
            // Color the text according to the state of the record in memory, as opposed to
            // to the cm_record file
            Color foregroundColor = textForeground;
            int cmRecordState = stepmodPart.getCmRecord().getRecordState();
            if (cmRecordState == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
                // Make the text red if the state of cm_record has been changed, but not saved
                foregroundColor = Color.RED;
            } else if (cmRecordState == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                // Make the text DARK_GRAY if cm_record file does not exist
                foregroundColor = Color.DARK_GRAY;
            } else {
                foregroundColor = Color.BLUE;
            }
            
            // Highlight according to whether the tree node is selected (as opposed to the checkbox)
            if (sel) {
                checkBoxRenderer.setForeground(selectionForeground);
                checkBoxRenderer.setBackground(selectionBackground);
            } else {
                checkBoxRenderer.setForeground(foregroundColor);
                checkBoxRenderer.setBackground(textBackground);
            }
            // make sure that the icon is as far left as possible
            checkBoxRenderer.setMargin(new Insets(0,-2,0,0));
            int cvsStatus = stepmodPart.getCmRecord().getCmRecordCvsStatus();
            if (stepmodPart.isCheckedOutDevelopment()) {
                if ((cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) || (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED)){
                    // cm record file does not exist
                    checkBoxRenderer.setIcon(devUnSelCvsUnknownIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsUnknownIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file exists, but has not been committed to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(devUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file has been modified and changes not commited to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_ADDED) {
                    checkBoxRenderer.setIcon(devUnSelCvsAddIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsAddIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file exists, but has not been added to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                    checkBoxRenderer.setIcon(devUnSelCvsNoFileIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsNoFileIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file exists, but has not been added to CVS");
                } else {
                    checkBoxRenderer.setIcon(devUnSelCvsIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file is committed to CVS");
                }
            } else if (stepmodPart.isCheckedOutPublishedIsoRelease()) {
                if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(pubUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Release is published by ISO. Cm record file has been modified and changes not commited to CVS");
                } else {
                    checkBoxRenderer.setIcon(pubUnSelCvsIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsIcon);
                    checkBoxRenderer.setToolTipText("Release is published by ISO. Cm record file is committed to CVS");
                }
            } else if (stepmodPart.isCheckedOutRelease()) {
                if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(relUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file has been modified and changes not commited to CVS");
                } else {
                    checkBoxRenderer.setIcon(pubUnSelCvsIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file is committed to CVS");
                }
            }
        }
        
        public Component getTreeCellRendererComponent(
                JTree tree,
                Object value,
                boolean sel,
                boolean expanded,
                boolean leaf,
                int row,
                boolean hasFocus) {
            
            super.getTreeCellRendererComponent(
                    tree, value, sel,
                    expanded, leaf, row,
                    hasFocus);
            
            DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
            if (node != null) {
                Object userNode = (Object)node.getUserObject();
                // Get the part
                StepmodPart stepmodPart = null;
                if (userNode instanceof CmReleaseTreeNode) {
                    CmReleaseTreeNode cmReleaseTreeNode = (CmReleaseTreeNode) node.getUserObject();
                    setupIconsForCmRelease(tree,sel,cmReleaseTreeNode);
                    return(checkBoxRenderer);
                } else if (userNode instanceof StepmodPartTreeNode) {
                    StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                    setupIconsForStepmodPart(tree,sel,stepmodPartTreeNode);
                    return(checkBoxRenderer);
                } else if (userNode instanceof StepmodPartTreeNodeCollection) {
                    setIcon(null);
                    String text = userNode.toString();
                    if (text.equals("Dependencies")) {
                        setToolTipText("Dependencies for the part");
                    }
                } else if (userNode instanceof String) {
                    setIcon(null);
                    String text = userNode.toString();
                    if (text.equals("Dependencies")) {
                        setForeground(Color.GRAY);
                    } else {
                        setForeground(Color.BLACK);
                    }
                }  else {
                    setIcon(null);
                    setToolTipText("??");
                }
            }
            return this;
        }
    }
    
    private class RepositoryTreeCellEditor extends AbstractCellEditor  implements TreeCellEditor{
        
        RepositoryTreeRenderer renderer = new RepositoryTreeRenderer();
        ChangeEvent changeEvent = null;
        JTree tree;
        
        public RepositoryTreeCellEditor(JTree tree, RepositoryTreeRenderer renderer) {
            // this.renderer = renderer;
            this.tree = tree;
        }
        
        public Object getCellEditorValue() {
            Object returnObj = null;
            JCheckBox checkbox = renderer.getCheckBoxRenderer();
            // get the CmReleaseTreeNode being edited
            TreePath path = tree.getEditingPath();
            if (path != null) {
                Object node = path.getLastPathComponent();
                if ((node != null) && (node instanceof DefaultMutableTreeNode)) {
                    DefaultMutableTreeNode treeNode = (DefaultMutableTreeNode) node;
                    Object userObj = treeNode.getUserObject();
                    if (userObj instanceof CmReleaseTreeNode) {
                        CmReleaseTreeNode cmReleaseTreeNode = null;
                        cmReleaseTreeNode = (CmReleaseTreeNode) userObj;
                        // Un select all other releases in this record
                        // Get the node "Releases"
                        TreePath parentPath = path.getParentPath();
                        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) parentPath.getLastPathComponent();
                        // Iterate through all the releases
                        for (Enumeration e=parent.children(); e.hasMoreElements(); ) {
                            DefaultMutableTreeNode child = (DefaultMutableTreeNode)e.nextElement();
                            if (child != treeNode) {
                                TreePath childPath = parentPath.pathByAddingChild(child);
                                CmReleaseTreeNode childCmReleaseTreeNode = (CmReleaseTreeNode) child.getUserObject();
                                childCmReleaseTreeNode.setSelected(false);
                                tree.removeSelectionPath(childPath);
                            }
                        }
                        // Now select the one that the mouse click was on
                        cmReleaseTreeNode.setSelected(checkbox.isSelected());
                        returnObj = cmReleaseTreeNode;
                    } else {
                        StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) userObj;
                        // Now select the one that the mouse click was on
                        stepmodPartTreeNode.setSelected(checkbox.isSelected());
                        returnObj = stepmodPartTreeNode;
                    }
                }
            }
            return returnObj;
        }
        
        public Component getTreeCellEditorComponent(JTree tree, Object value,
                boolean selected, boolean expanded, boolean leaf, int row) {
            
            Component editor = renderer.getTreeCellRendererComponent(tree, value,
                    true, expanded, leaf, row, true);
            
            // editor always selected / focused
            ItemListener itemListener = new ItemListener() {
                public void itemStateChanged(ItemEvent itemEvent) {
                    if (stopCellEditing()) {
                        fireEditingStopped();
                    }
                }
            };
            if (editor instanceof JCheckBox) {
                ((JCheckBox) editor).addItemListener(itemListener);
            }
            return editor;
        }
        
        public boolean isCellEditable(EventObject event) {
            boolean returnValue = false;
            if (event instanceof MouseEvent) {
                MouseEvent mouseEvent = (MouseEvent) event;
                TreePath path = tree.getPathForLocation(mouseEvent.getX(),
                        mouseEvent.getY());
                if (path != null) {
                    Object node = path.getLastPathComponent();
                    if ((node != null) && (node instanceof DefaultMutableTreeNode)) {
                        DefaultMutableTreeNode treeNode = (DefaultMutableTreeNode) node;
                        Object userObject = treeNode.getUserObject();
                        // RBN - I only want the selection to take place if the box is slected - not just the whole line
                        // I could not work out anyother way of checking this ....
                        // so ...a real hack to see if the user clicked in the box of the checkbox
                        // could not work out how to get the dimensions off the checkbox .... so get 85 to 95 by trial and error
                        
                        int x = mouseEvent.getX();
                        int checkBoxMinX ;
                        int checkBoxMaxX;
                        if (userObject instanceof CmReleaseTreeNode) {
                            checkBoxMinX = (path.getPathCount() * 20);
                            checkBoxMaxX = checkBoxMinX + 10;
                            returnValue = ((x < checkBoxMaxX) && (x > checkBoxMinX));
                        } else if (userObject instanceof StepmodPartTreeNode) {
                            checkBoxMinX = ((path.getPathCount() - 1) * 20);
                            checkBoxMaxX = checkBoxMinX + 10;
                            returnValue = ((x < checkBoxMaxX) && (x > checkBoxMinX));
                        }
                    }
                }
            }
            return returnValue;
        }
        
    }
    
    /**
     * Once the repository has been read, initialize the display of the trees and menus
     */
    public void initialise() {
        // TODO probably should display a splash screen with progress bar as it takes a while to load
        // initRepositoryTree();
        repositoryJTree.setVisible(false);
        initAllModulesPopupMenu();
        initStepmodPartPopupMenu();
        initReleasePopupMenu();
        initDevRevisionPopupMenu();
        setVisible(true);
    }
    
    
    
    private DefaultMutableTreeNode addRepositoryTreeNode(StepmodPart part, DefaultMutableTreeNode partTreeRoot,
            StepmodPartTreeNodeCollection partTreeNodeCollection) {
        StepmodPartTreeNode stepmodPartTreeNode = new StepmodPartTreeNode(part, false);
        DefaultMutableTreeNode partTreeNode = new DefaultMutableTreeNode(stepmodPartTreeNode);
        TreeMap partNodeHash = partTreeNodeCollection.getHasStepmodPartTreeNodes();
        partNodeHash.put(part.getName(), partTreeNode);
        
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        partTreeRoot.add(partTreeNode);
        
        DefaultMutableTreeNode attributesTreeNode = new DefaultMutableTreeNode("Attributes");
        treeModel.insertNodeInto(attributesTreeNode, partTreeNode, partTreeNode.getChildCount());
        
        DefaultMutableTreeNode attributeTreeNode;
        attributeTreeNode = new DefaultMutableTreeNode("Name: " + part.getName());
        treeModel.insertNodeInto(attributeTreeNode, attributesTreeNode, attributesTreeNode.getChildCount());
        
        
        attributeTreeNode = new DefaultMutableTreeNode("Number: " + part.getPartNumber());
        treeModel.insertNodeInto(attributeTreeNode, attributesTreeNode, attributesTreeNode.getChildCount());
        
        DefaultMutableTreeNode dependenciesTreeNode = new DefaultMutableTreeNode("Dependencies");
        // Note that the dependencies are added on demand by a user
        // See updateDependencies()
        //partTreeNode.add(dependenciesTreeNode);
        treeModel.insertNodeInto(dependenciesTreeNode, partTreeNode, partTreeNode.getChildCount());
        DefaultMutableTreeNode filesTreeNode = new DefaultMutableTreeNode("Files");
        //partTreeNode.add(filesTreeNode);
        treeModel.insertNodeInto(filesTreeNode, partTreeNode, partTreeNode.getChildCount());
        this.updateFiles(filesTreeNode);
        // TODO - need to list the files that make up the modules
        // The arm, mim, sys files etc.
        // For each file display the CVS revision and date
        
        DefaultMutableTreeNode releasesTreeNode = new DefaultMutableTreeNode("Releases");
        partTreeNode.add(releasesTreeNode);
        
        // Add the development revision - a CmReleaseTreeNode with no CMRelease
        DefaultMutableTreeNode releaseNode = new DefaultMutableTreeNode(new CmReleaseTreeNode(part, "Development revision", false));
        treeModel.insertNodeInto(releaseNode, releasesTreeNode, releasesTreeNode.getChildCount());
        
        for (Iterator j = part.getCmRecord().getHasCmReleases().iterator(); j.hasNext();) {
            CmRelease cmRelease = (CmRelease) j.next();
            addReleaseToTree(part, cmRelease, partTreeNode, false);
        }
        return (partTreeNode);
    }
    
    private void updateFiles(DefaultMutableTreeNode filesTreeNode) {
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) filesTreeNode.getParent();
        StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) parentNode.getUserObject();
        StepmodPart stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        
        for (Iterator it=stepmodPart.getHasFiles().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodFile file = (StepmodFile)entry.getValue();
            DefaultMutableTreeNode fileTreeNode = new DefaultMutableTreeNode();
            fileTreeNode.setUserObject(file);
            treeModel.insertNodeInto(fileTreeNode, filesTreeNode, filesTreeNode.getChildCount());
        }
    }
    
    
    private void updateDependencies(DefaultMutableTreeNode dependencyNode) {
        StepmodPartTreeNodeCollection dependenciesTreeNodeCollection
                = new StepmodPartTreeNodeCollection("Dependencies", dependencyNode);
        dependencyNode.setUserObject(dependenciesTreeNodeCollection);
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) dependencyNode.getParent();
        StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) parentNode.getUserObject();
        StepmodPartTreeNodeCollection partsCollection = null;
        boolean treeChanged = false;
        StepmodPart stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
        // get all the dependent parts
        // TODO - set up monitor
        // ProgressMonitorWindow monitor = new ProgressMonitorWindow(part.getStepMod().getStepModGui(), true);
        // monitor.setVisible(true);
        stepmodPart.setupDependencies();
        // draw the dependency tree
        for (Iterator it = stepmodPart.getDependencies().iterator(); it.hasNext();) {
            String dependentPartName = (String)it.next();
            StepmodPart dependentPart = stepmodPart.getStepMod().getPartByName(dependentPartName);
            this.addRepositoryTreeNode(dependentPart, dependencyNode, dependenciesTreeNodeCollection);
            // make sure that the node is displayed in the top listing
            // Some parts may be loaded as not the complete repository index was loaded
            if (dependentPart instanceof StepmodModule) {
                partsCollection = this.getModulesTreeNodeCollection();
            } else if (dependentPart instanceof StepmodApplicationProtocol) {
                partsCollection = this.getApTreeNodeCollection();
            } else if (dependentPart instanceof StepmodResourceDoc) {
                partsCollection = this.getResourceDocsTreeNodeCollection();
            } else if (dependentPart instanceof StepmodResource) {
                partsCollection = this.getSchemasTreeNodeCollection();
            }
            DefaultMutableTreeNode partsCollectionNode = partsCollection.getTreeNode();
            
            DefaultMutableTreeNode partNode = partsCollection.getNodeForPart(dependentPart);
            if (partNode == null) {
                this.addRepositoryTreeNode(dependentPart, partsCollectionNode, partsCollection);
                treeChanged = true;
            }
        }
        DefaultMutableTreeNode rootTreeNode = new DefaultMutableTreeNode("STEPMod");
        // Use the tree model to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        // Comented out the code to redraw the tree as it will close all the nodes.
        // leave it t the user to redraw
        if (treeChanged) {
            treeModel.nodeStructureChanged(this.modulesTreeNode);
            treeModel.nodeStructureChanged(this.resourceSchemasTreeNode);
            TreePath path = new TreePath(dependencyNode.getPath());
            repositoryJTree.expandPath(path);
            repositoryJTree.scrollPathToVisible(path);
            repositoryJTree.setSelectionPath(path);
        }
        //this.updateNode(modulesNode);
    }
    
    
    
    private void updateDependenciesxxx(DefaultMutableTreeNode dependencyNode) {
        StepmodPartTreeNodeCollection dependenciesTreeNodeCollection
                = new StepmodPartTreeNodeCollection("Dependencies", dependencyNode);
        dependencyNode.setUserObject(dependenciesTreeNodeCollection);
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) dependencyNode.getParent();
        StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) parentNode.getUserObject();
        StepmodPartTreeNodeCollection partsCollection = null;
        StepmodPart stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
        if (stepmodPart instanceof StepmodModule) {
            partsCollection = this.getModulesTreeNodeCollection();
        } else if (stepmodPart instanceof StepmodApplicationProtocol) {
            partsCollection = this.getApTreeNodeCollection();
        } else if (stepmodPart instanceof StepmodResourceDoc) {
            partsCollection = this.getResourceDocsTreeNodeCollection();
        } else if (stepmodPart instanceof StepmodResource) {
            partsCollection = this.getSchemasTreeNodeCollection();
        }
        // get all the dependent parts
        // TODO - set up monitor
        // ProgressMonitorWindow monitor = new ProgressMonitorWindow(part.getStepMod().getStepModGui(), true);
        // monitor.setVisible(true);
        stepmodPart.setupDependencies();
        DefaultMutableTreeNode modulesNode = partsCollection.getTreeNode();
        // draw the dependency tree
        for (Iterator it = stepmodPart.getDependencies().iterator(); it.hasNext();) {
            String dependentPartName = (String)it.next();
            StepmodPart dependentPart = stepmodPart.getStepMod().getPartByName(dependentPartName);
            this.addRepositoryTreeNode(dependentPart, dependencyNode, dependenciesTreeNodeCollection);
            // make sure that the node is displayed in the top listing
            // Some parts may be loaded as not the complete repository index was loaded
            DefaultMutableTreeNode partNode = partsCollection.getNodeForPart(dependentPart);
            if (partNode == null) {
                if (dependentPart instanceof StepmodModule) {
                    this.addRepositoryTreeNode(dependentPart, modulesNode, partsCollection);
                }
            }
        }
        
        DefaultMutableTreeNode rootTreeNode = new DefaultMutableTreeNode("STEPMod");
        // Use the tree model to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        // Comented out the code to redraw the tree as it will close all the nodes.
        // leave it t the user to redraw
        //treeModel.nodeStructureChanged(modulesNode);
        //this.updateNode(modulesNode);
    }
    
    /**
     * Initialise the display of the repository tree
     */
    public void initRepositoryTree() {
        DefaultMutableTreeNode rootTreeNode = new DefaultMutableTreeNode("STEPMod");
        // Use the tree mode to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = new DefaultTreeModel(rootTreeNode);
        repositoryJTree = new JTree(treeModel);
        
        // Iterate through all the modules creating nodes and adding them to the tree
        modulesTreeNode = new DefaultMutableTreeNode();
        rootTreeNode.add(modulesTreeNode);
        modulesTreeNodeCollection = new StepmodPartTreeNodeCollection("Modules", modulesTreeNode);
        modulesTreeNode.setUserObject(modulesTreeNodeCollection);
        for (Iterator it=getStepMod().getModulesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodModule moduleNode = (StepmodModule)entry.getValue();
            addRepositoryTreeNode(moduleNode, modulesTreeNode, modulesTreeNodeCollection);
        }
        
        // Iterate through all the Application protocols creating nodes and adding them to the tree
        applicationProtocolsTreeNode = new DefaultMutableTreeNode("Application protocols");
        rootTreeNode.add(applicationProtocolsTreeNode);
        apTreeNodeCollection = new StepmodPartTreeNodeCollection("Application protocols", applicationProtocolsTreeNode);
        applicationProtocolsTreeNode.setUserObject(apTreeNodeCollection);
        for (Iterator it=getStepMod().getApplicationProtocolsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodApplicationProtocol applicationProtocolNode = (StepmodApplicationProtocol)entry.getValue();
            addRepositoryTreeNode(applicationProtocolNode, applicationProtocolsTreeNode, apTreeNodeCollection);
        }
        
        // Iterate through all the Resource documents creating nodes and adding them to the tree
        resourceDocsTreeNode = new DefaultMutableTreeNode("Resource documents");
        rootTreeNode.add(resourceDocsTreeNode);
        resourceDocsTreeNodeCollection
                = new StepmodPartTreeNodeCollection("Resource documents", resourceDocsTreeNode);
        resourceDocsTreeNode.setUserObject(resourceDocsTreeNodeCollection);
        for (Iterator it=getStepMod().getResourceDocsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResourceDoc resourceDocNode = (StepmodResourceDoc)entry.getValue();
            addRepositoryTreeNode(resourceDocNode, resourceDocsTreeNode, resourceDocsTreeNodeCollection);
        }
        
        // Iterate through all the Resource schemas creating nodes and adding them to the tree
        resourceSchemasTreeNode = new DefaultMutableTreeNode("Resource schemas");
        rootTreeNode.add(resourceSchemasTreeNode);
        schemasTreeNodeCollection = new StepmodPartTreeNodeCollection("Resource schemas", resourceSchemasTreeNode);
        resourceSchemasTreeNode.setUserObject(schemasTreeNodeCollection);
        
        for (Iterator it=getStepMod().getResourcesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResource resourceNode = (StepmodResource)entry.getValue();
            StepmodPartTreeNode stepmodPartTreeNode = new StepmodPartTreeNode(resourceNode, false);
            addRepositoryTreeNode(resourceNode, resourceSchemasTreeNode, schemasTreeNodeCollection);
        }
        
        DefaultMutableTreeNode frameworkTreeNode = new DefaultMutableTreeNode("STEPmod Framework");
        rootTreeNode.add(frameworkTreeNode);
        
        repositoryTreeScrollPane.setViewportView(repositoryJTree);
        repositoryJTree.setEditable(true);
        repositoryJTree.setExpandsSelectedPaths(true);
        repositoryJTree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        
        
        // Make sure that the modules node is visible
        //repositoryJTree.scrollPathToVisible(new TreePath(modulesTreeNode.getPath()));
        // Make sure that the Application protocols node is visible
        //repositoryJTree.scrollPathToVisible(new TreePath(applicationProtocolsTreeNode.getPath()));
        // Make sure that the Resource documents node is visible
        //repositoryJTree.makeVisible(new TreePath(resourceDocsTreeNode.getPath()));
        // Make sure that the Resource schemas node is visible
        //repositoryJTree.scrollPathToVisible(new TreePath(resourceSchemasTreeNode.getPath()));
        repositoryJTree.makeVisible(new TreePath(resourceSchemasTreeNode.getPath()));
        
        ToolTipManager.sharedInstance().registerComponent(repositoryJTree);
        
        // Set up the renderer that displays the icons in the tree
        RepositoryTreeRenderer renderer = new RepositoryTreeRenderer();
        repositoryJTree.setCellRenderer(renderer);
        RepositoryTreeCellEditor cellEditor = new RepositoryTreeCellEditor(repositoryJTree, renderer);
        repositoryJTree.setCellEditor(cellEditor);
        
        // Setup the listeners that get fired when there are mouse events on the tree
        repositoryJTree.addTreeSelectionListener(new TreeSelectionListener() {
            public void valueChanged(TreeSelectionEvent e) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) repositoryJTree.getLastSelectedPathComponent();
                if (node == null) return;
                if (node.getParent() == null) return; // The root
                Object nodeObject = (Object)node.getUserObject();
                if (nodeObject instanceof StepmodPartTreeNode) {
                    StepmodPart part = ((StepmodPartTreeNode) nodeObject).getStepmodPart();
                    // Display a summary of the module in the repositoryTextPane
                    String summary = part.summaryHtml();
                    repositoryTextPane.setText(summary);
                    setCurrentDisplayedObject(nodeObject);
                } else if (nodeObject instanceof CmReleaseTreeNode) {
                    CmReleaseTreeNode cmReleaseTreeNode = (CmReleaseTreeNode) nodeObject;
                    CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
                    CmRecord cmRecord = cmReleaseTreeNode.getStepmodPart().getCmRecord();
                    String summary = cmRecord.summaryHtml(cmRelease);
                    repositoryTextPane.setText(summary);
                    setCurrentDisplayedObject(nodeObject);
                } else if (nodeObject instanceof String) {
                    String nodeString = nodeObject.toString();
                    if (nodeString.equals("Dependencies")) {
                        updateDependencies(node);
                    }
                }
            }
        });
        
        repositoryJTree.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                if (SwingUtilities.isRightMouseButton(e)) {
                    JTree tree = (JTree)e.getComponent();
                    TreePath path = tree.getClosestPathForLocation(e.getX(), e.getY());
                    DefaultMutableTreeNode node = (DefaultMutableTreeNode) path.getLastPathComponent();
                    Object nodeObject = (Object)node.getUserObject();
                    
                    if (nodeObject instanceof StepmodPartTreeNode) {
                        StepmodPart part = ((StepmodPartTreeNode) nodeObject).getStepmodPart();
                        // Make sure that the menu knows about the tree node
                        stepmodPartPopupMenu.setUserObject(node);
                        
                        // Only display relevant menu items
                        int state = part.getCmRecord().getRecordState();
                        int cvsStatus = part.getCmRecord().getCmRecordCvsStatus();
                        if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                            createCmRecordMenuItem.setEnabled(true);
                            commitCmRecordMenuItem.setEnabled(false);
                            saveCmRecordMenuItem.setEnabled(false);
                        } else if (state == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(false);
                            saveCmRecordMenuItem.setEnabled(true);
                        } else if (part.getCmRecord().needsCvsAction()) {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(true);
                            saveCmRecordMenuItem.setEnabled(false);
                        } else {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(false);
                            saveCmRecordMenuItem.setEnabled(false);
                        }
                        stepmodPartPopupMenu.show(e.getComponent(), e.getX(), e.getY());
                    } else if (nodeObject instanceof CmReleaseTreeNode) {
                        if (((CmReleaseTreeNode) nodeObject).getCmRelease() != null) {
                            releasePopupMenu.setUserObject(node);
                            releasePopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        } else {
                            devRevisionPopupMenu.setUserObject(node);
                            devRevisionPopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        }
                    } else if (nodeObject instanceof String) {
                        if (nodeObject.equals("Modules")) {
                            allModulesPopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        }
                    }
                }
            }
        });
    }
    
    
    /**
     * Setup the popup menu associated with the modules
     */
    private void initAllModulesPopupMenu() {
        allModulesPopupMenu = new PopupMenuWithObject();
        
        // Open all module nodes
        javax.swing.JMenuItem openModuleNodesMenuItem;
        openModuleNodesMenuItem = new javax.swing.JMenuItem("Open all module nodes");
        openModuleNodesMenuItem.setToolTipText("Open all module nodes in the tree.");
        openModuleNodesMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                openAllModuleNodes();
            }
        });
        allModulesPopupMenu.add(openModuleNodesMenuItem);
        
        // Open all module selected nodes
        javax.swing.JMenuItem openSelectedModuleNodesMenuItem;
        openSelectedModuleNodesMenuItem = new javax.swing.JMenuItem("Open all selected module nodes");
        openSelectedModuleNodesMenuItem.setToolTipText("Open all module nodes that have been in the tree.");
        openSelectedModuleNodesMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                openAllSelectedModuleNodes();
            }
        });
        allModulesPopupMenu.add(openSelectedModuleNodesMenuItem);
        
        // Clear all module selected nodes
        javax.swing.JMenuItem clearSelectedModuleNodesMenuItem;
        clearSelectedModuleNodesMenuItem = new javax.swing.JMenuItem("Clear all selected module nodes");
        clearSelectedModuleNodesMenuItem.setToolTipText("Clear all module nodes that have been in the tree.");
        clearSelectedModuleNodesMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                // TODO clearAllSelectedPartshash(hasModulesNodes);
            }
        });
        allModulesPopupMenu.add(clearSelectedModuleNodesMenuItem);
        
        allModulesPopupMenu.add(new javax.swing.JSeparator());
        
        // Update to development revisions
        javax.swing.JMenuItem createCvsUpdateAllDevelopmentRevisionMenuItem;
        createCvsUpdateAllDevelopmentRevisionMenuItem = new javax.swing.JMenuItem("Update ALL modules to latest develop revisions");
        createCvsUpdateAllDevelopmentRevisionMenuItem.setToolTipText("Update all the modules to the latest revisions from CVS.");
        createCvsUpdateAllDevelopmentRevisionMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                getStepMod().cvsUpdateAllModulesDevelopmentRevision();
            }
        });
        allModulesPopupMenu.add(createCvsUpdateAllDevelopmentRevisionMenuItem);
        
        // Update all to latest releases
        javax.swing.JMenuItem createCvsUpdateAllLatestRevisionMenuItem;
        createCvsUpdateAllLatestRevisionMenuItem = new javax.swing.JMenuItem("Update ALL modules to latest releases");
        createCvsUpdateAllLatestRevisionMenuItem.setToolTipText("Update all the modules to the latest released versions.");
        createCvsUpdateAllLatestRevisionMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                getStepMod().cvsUpdateAllModulesLatestRevision();
            }
        });
        allModulesPopupMenu.add(createCvsUpdateAllLatestRevisionMenuItem);
        
        
        // Update all to latest published edition
        javax.swing.JMenuItem createCvsUpdateAllLatestPublicationsMenuItem;
        createCvsUpdateAllLatestPublicationsMenuItem = new javax.swing.JMenuItem("Update ALL modules to latest published editions");
        createCvsUpdateAllLatestPublicationsMenuItem.setToolTipText("Update all the modules to the latest published edition (CD, DIS, TS, IS). If not published");
        createCvsUpdateAllLatestPublicationsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                getStepMod().cvsUpdateAllModulesLatestPublications();
            }
        });
        allModulesPopupMenu.add(createCvsUpdateAllLatestPublicationsMenuItem);
        
        // Update all to selected revisions
        javax.swing.JMenuItem createCvsUpdateAllModulesSelectedRevisionsMenuItem;
        createCvsUpdateAllModulesSelectedRevisionsMenuItem = new javax.swing.JMenuItem("Update ALL modules to selected revisions");
        createCvsUpdateAllModulesSelectedRevisionsMenuItem.setToolTipText("Update all the modules to the revisions selected.");
        createCvsUpdateAllModulesSelectedRevisionsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                // TODO - iterate through all the selected revsions and update.
                //getStepMod().cvsUpdateAllModulesSelectedRevisions();
            }
        });
        allModulesPopupMenu.add(createCvsUpdateAllModulesSelectedRevisionsMenuItem);
    }
    
    
    /**
     * Forces a redraw on the part node in the tree and all its children
     */
    private void updateNode(StepmodPart stepmodPart) {
        DefaultMutableTreeNode node
                = findNodeByPart((DefaultMutableTreeNode)repositoryJTree.getModel().getRoot(), stepmodPart);
        updateNode(node);
        
        // Now refresh the HTML display in the output pane
        Object displayedObject = getCurrentDisplayedObject();
        if (displayedObject != null) {
            if (displayedObject instanceof StepmodPartTreeNode) {
                StepmodPart part = ((StepmodPartTreeNode)displayedObject).getStepmodPart();
                String summary = part.summaryHtml();
                repositoryTextPane.setText(summary);
            } else if (displayedObject instanceof CmReleaseTreeNode) {
                CmReleaseTreeNode cmReleaseTreeNode = (CmReleaseTreeNode)displayedObject;
                CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
                StepmodPart part = cmReleaseTreeNode.getStepmodPart();
                String summary = part.getCmRecord().summaryHtml(cmRelease);
                repositoryTextPane.setText(summary);
            }
        }
    }
    
    /**
     * Forces a redraw on the node in the tree and all its children
     */
    private void updateNode(DefaultMutableTreeNode node) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        treeModel.nodeChanged(node);
        for (Enumeration e=node.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode child = (DefaultMutableTreeNode)e.nextElement();
            treeModel.nodeChanged(child);
            updateNode(child);
        }
    }
    
    /**
     * Finds the first node that is a child of startNode that has the given stepmodPart as a userObject
     */
    private DefaultMutableTreeNode findNodeByPart(DefaultMutableTreeNode startNode, StepmodPart stepmodPart) {
        Object obj = startNode.getUserObject();
        StepmodPart foundPart = null;
        if ((obj != null) && (obj instanceof StepmodPartTreeNode)) {
            foundPart = ((StepmodPartTreeNode) obj).getStepmodPart();
        }
        if (stepmodPart == foundPart) {
            return(startNode);
        } else if (startNode.getChildCount() >= 0) {
            for (Enumeration e=startNode.children(); e.hasMoreElements(); ) {
                DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
                DefaultMutableTreeNode result = findNodeByPart(n, stepmodPart);
                // Found a match
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }
    
    
    
    /**
     * Finds the first node that is a child of startNode that has the given name
     */
    private DefaultMutableTreeNode findNodeByName(DefaultMutableTreeNode startNode, String name) {
        String nodeName = startNode.toString();
        if (nodeName.equals(name)) {
            // found the node so return the path
            //return(new TreePath(startNode.getPath()));
            return(startNode);
        } else if (startNode.getChildCount() >= 0) {
            for (Enumeration e=startNode.children(); e.hasMoreElements(); ) {
                DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
                DefaultMutableTreeNode result = findNodeByName(n, name);
                // Found a match
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }
    
    
    /**
     * Finds the first node that is a child of startNode that has a name starting with the prefix.
     */
    private DefaultMutableTreeNode findNodeByPrefix(DefaultMutableTreeNode startNode, String prefix) {
        String nodeName = startNode.toString();
        if (nodeName.startsWith(prefix)) {
            // found the node so return the path
            //return(new TreePath(startNode.getPath()));
            return(startNode);
        } else if (startNode.getChildCount() >= 0) {
            for (Enumeration e=startNode.children(); e.hasMoreElements(); ) {
                DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
                DefaultMutableTreeNode result = findNodeByPrefix(n, prefix);
                // Found a match
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }
    
    
    /**
     * For a given part node, find the selected release
     */
    private CmRelease getSelectedCmRelease(DefaultMutableTreeNode node) {
        // Find the "Releases" node
        DefaultMutableTreeNode releasesNode = this.findNodeByName(node,"Releases");
        DefaultMutableTreeNode releaseNode = null;
        CmReleaseTreeNode selectedCmReleaseTreeNode = null;
        CmRelease selectedCmRelease = null;
        for (Enumeration e=releasesNode.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode child = (DefaultMutableTreeNode)e.nextElement();
            CmReleaseTreeNode cmReleaseTreeNode = (CmReleaseTreeNode)child.getUserObject();
            if (cmReleaseTreeNode.isSelected()) {
                selectedCmReleaseTreeNode = cmReleaseTreeNode;
            }
        }
        if (selectedCmReleaseTreeNode != null) {
            selectedCmRelease = selectedCmReleaseTreeNode.getCmRelease();
        }
        return selectedCmRelease;
    }
    
    private void openAllModuleNodes() {
        toBeDone("STEPModFrame.openAllModuleNodes");
    }
    
    private void openAllSelectedModuleNodes() {
        toBeDone("STEPModFrame.openAllSelectedModuleNodes");
    }
    
    private void clearAllSelectedPartsHash(StepmodPartTreeNodeCollection partTreeNodeCollection) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        TreeMap treeMap = partTreeNodeCollection.getHasStepmodPartTreeNodes();
        for (Iterator it=treeMap.entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            DefaultMutableTreeNode moduleNode = (DefaultMutableTreeNode)entry.getValue();
            StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) moduleNode.getUserObject();
            if (stepmodPartTreeNode.isSelected()) {
                stepmodPartTreeNode.setSelected(false);
                treeModel.nodeChanged(moduleNode);
            }
        }
    }
    
    private void clearAllSelectedParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        clearAllChildSelectedParts(root);
    }
    
    private void clearAllChildSelectedParts(DefaultMutableTreeNode root) {
        for (Enumeration e=root.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
            Object userObj = n.getUserObject();
            if (userObj instanceof StepmodPartTreeNodeCollection) {
                StepmodPartTreeNodeCollection partTreeNodeCollection = (StepmodPartTreeNodeCollection) userObj;
                // iterate through the children of the node
                clearAllSelectedPartsHash(partTreeNodeCollection);
            }
        }
    }
    
    
    
    private void viewAllPartsHash(TreeMap partsHash, TreeMap treeNodesHash, DefaultMutableTreeNode subTreeNode) {
        // TODO
//           DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
//           DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
//           this.updateNode(root);
//           for (Iterator it=partsHash.entrySet().iterator(); it.hasNext(); ) {
//               Map.Entry entry = (Map.Entry)it.next();
//               String stepmodPartName = (String)entry.getKey();
//               DefaultMutableTreeNode partNode = (DefaultMutableTreeNode)treeNodesHash.get(stepmodPartName);
//               if (partNode == null) {
//                   StepmodPart part = this.getStepMod().getPartByName(stepmodPartName);
//                   partNode = addRepositoryTreeNode(part, subTreeNode, treeNodesHash);
//               } else if (partNode.getParent() != null) {
//                   // remove the parent then add the node back to ensure that the order is the same as before
//                   treeModel.removeNodeFromParent(partNode);
//               }
//               subTreeNode.add(partNode);
//           }
//           treeModel.nodeStructureChanged(subTreeNode);
//           this.updateNode(subTreeNode);
    }
    private void viewPartsInCollection(DefaultTreeModel treeModel,
            DefaultMutableTreeNode collectionTreeNode, StepmodPartTreeNodeCollection partCollection) {
        // Iterate through all the StepmodPartTreeNode in the collection
        // TODO - this shoudl recurse down the hierarchy of dependencies
        for (Iterator it=partCollection.getHasStepmodPartTreeNodes().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            DefaultMutableTreeNode stepPartNode = (DefaultMutableTreeNode)entry.getValue();
            if (stepPartNode.getParent() != null) {
                // remove the parent then add the node back to ensure that the order is the same as before
                treeModel.removeNodeFromParent(stepPartNode);
            }
            collectionTreeNode.add(stepPartNode);
        }
        treeModel.nodeStructureChanged(collectionTreeNode);
        this.updateNode(collectionTreeNode);
    }
    
    
    private void viewAllParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        // TODO count the child nodes of the module and see if it is teh same as the colleciton, then change
        
        treeModel.nodeStructureChanged(root);
        //this.updateNode(root);
        for (Enumeration e=root.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
            Object usrObj = n.getUserObject();
            if (usrObj instanceof StepmodPartTreeNodeCollection) {
                StepmodPartTreeNodeCollection partCollection = (StepmodPartTreeNodeCollection) usrObj;
                viewPartsInCollection(treeModel, n, partCollection);
            }
        }
        viewSelectedToggleButton.setSelected(false);
    }
    
    
    
    
    
    private void viewSelectedPartsInCollection(DefaultTreeModel treeModel,
            DefaultMutableTreeNode collectionTreeNode, StepmodPartTreeNodeCollection partCollection) {
        // Iterate through all the StepmodPartTreeNode in the collection
        // TODO - this shoudl recurse down the hierarchy of dependencies
        for (Iterator it=partCollection.getHasStepmodPartTreeNodes().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            DefaultMutableTreeNode stepPartNode = (DefaultMutableTreeNode)entry.getValue();
            StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) stepPartNode.getUserObject();
            if (!stepmodPartTreeNode.isSelected()) {
                if (stepPartNode.getParent() != null) {
                    treeModel.removeNodeFromParent(stepPartNode);
                }
            }
        }
    }
    
    
    private void viewSelectedParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        this.updateNode(root);
        for (Enumeration e=root.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
            Object usrObj = n.getUserObject();
            if (usrObj instanceof StepmodPartTreeNodeCollection) {
                StepmodPartTreeNodeCollection partCollection = (StepmodPartTreeNodeCollection) usrObj;
                viewSelectedPartsInCollection(treeModel, n, partCollection);
            }
        }
    }
    
    /**
     * Setup the menu called from a mouse click on a module
     */
    private void initStepmodPartPopupMenu() {
        // Setup the popoup menu associated with individual modules
        stepmodPartPopupMenu = new PopupMenuWithObject();
        
        javax.swing.JMenu cvsModuleSubmenu = new javax.swing.JMenu("CVS - Part");
        stepmodPartPopupMenu.add(cvsModuleSubmenu);
        javax.swing.JMenu cvsCmRecSubmenu = new javax.swing.JMenu("CM record");
        stepmodPartPopupMenu.add(cvsCmRecSubmenu);
        javax.swing.JMenu cvsReleaseSubmenu = new javax.swing.JMenu("Release");
        stepmodPartPopupMenu.add(cvsReleaseSubmenu);
        javax.swing.JMenu cvsPublicationSubmenu = new javax.swing.JMenu("Publication");
        stepmodPartPopupMenu.add(cvsPublicationSubmenu);
        
        
        // Update development revision
        javax.swing.JMenuItem createCvsUpdateDevelopmentRevisionMenuItem;
        createCvsUpdateDevelopmentRevisionMenuItem = new javax.swing.JMenuItem("Update development revision");
        createCvsUpdateDevelopmentRevisionMenuItem.setToolTipText("Checks out the latest revisions of the module from CVS for development.");
        createCvsUpdateDevelopmentRevisionMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                part.getStepMod().getStepModGui().cvsUpdate(part);
            }
        });
        cvsModuleSubmenu.add(createCvsUpdateDevelopmentRevisionMenuItem);
        
        
        // Checkout a latest release
        javax.swing.JMenuItem createCvsCoLatestReleaseMenuItem;
        createCvsCoLatestReleaseMenuItem = new javax.swing.JMenuItem("Checkout latest release");
        createCvsCoLatestReleaseMenuItem.setToolTipText("Checks out the latest release of the module from CVS (Sticky).");
        createCvsCoLatestReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                part.getStepMod().getStepModGui().cvsCoLatestRelease(part);
            }
        });
        cvsModuleSubmenu.add(createCvsCoLatestReleaseMenuItem);
        
        // Checkout a published release
        javax.swing.JMenuItem createCvsCoPublishedReleaseMenuItem;
        createCvsCoPublishedReleaseMenuItem = new javax.swing.JMenuItem("Checkout published release");
        createCvsCoPublishedReleaseMenuItem.setToolTipText("Checks out the latest release of the module published by ISO from CVS (Sticky).");
        createCvsCoPublishedReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                part.getStepMod().getStepModGui().cvsCoPublishedRelease(part);
            }
        });
        cvsModuleSubmenu.add(createCvsCoPublishedReleaseMenuItem);
        
        // Make a new release option
        javax.swing.JMenuItem createCmReleaseMenuItem;
        createCmReleaseMenuItem = new javax.swing.JMenuItem("Create new release");
        createCmReleaseMenuItem.setToolTipText("Creates a new release of the module. The saved record and CVS will only be updated after it has been committed");
        createCmReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                new STEPModMkReleaseDialog(part, node).setVisible(true);
            }
        });
        cvsReleaseSubmenu.add(createCmReleaseMenuItem);
        
        
        // Commit CM record option
        //javax.swing.JMenuItem createCmRecordMenuItem;
        createCmRecordMenuItem = new javax.swing.JMenuItem("Create CM Record");
        createCmRecordMenuItem.setToolTipText("Create the CM record for the part. Creates cm_record.xml");
        createCmRecordMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
                stepmodPart.getStepMod().getStepModGui().writeCmRecord(stepmodPart);
            }
        });
        cvsCmRecSubmenu.add(createCmRecordMenuItem);
        
        // Commit CM record option
        //javax.swing.JMenuItem saveCmRecordMenuItem;
        saveCmRecordMenuItem = new javax.swing.JMenuItem("Save CM Record");
        saveCmRecordMenuItem.setToolTipText("Save any changes to the CM record to cm_record.xml");
        saveCmRecordMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
                stepmodPart.getStepMod().getStepModGui().saveCmRecord(stepmodPart);
            }
        });
        cvsCmRecSubmenu.add(saveCmRecordMenuItem);
        
        // Commit CM record option
        //javax.swing.JMenuItem commitCmRecordMenuItem;
        commitCmRecordMenuItem = new javax.swing.JMenuItem("Commit CM Record");
        commitCmRecordMenuItem.setToolTipText("Save any changes to the CM record to cm_record.xml and use CVS to tag release");
        commitCmRecordMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
                stepmodPart.getStepMod().getStepModGui().cvsCommitRecord(stepmodPart);
            }
        });
        cvsCmRecSubmenu.add(commitCmRecordMenuItem);
        
        stepmodPartPopupMenu.add(new JSeparator());
        
        // Create publication package
        javax.swing.JMenuItem createModulePublicationPackage;
        createModulePublicationPackage = new javax.swing.JMenuItem("Create publication package (ANT build)");
        createModulePublicationPackage.setToolTipText("Creates the ANT build file for generating the publication package");
        createModulePublicationPackage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.publicationCreatePackage();
            }
        });
        cvsPublicationSubmenu.add(createModulePublicationPackage);
        
        // Generate HTML for publication package
        javax.swing.JMenuItem genHtmlModulePublicationPackage;
        genHtmlModulePublicationPackage = new javax.swing.JMenuItem("Generate HTML for publication package ");
        genHtmlModulePublicationPackage.setToolTipText("Generates the HTML for the publication package");
        genHtmlModulePublicationPackage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.publicationGenerateHtml();
            }
        });
        cvsPublicationSubmenu.add(genHtmlModulePublicationPackage);
    }
    
    /**
     * Setup the menu called from a mouse click on the release
     */
    private void initReleasePopupMenu() {
        // Setup the popoup menu associated with individual modules
        releasePopupMenu = new PopupMenuWithObject();
        
        // Checkout a given release
        javax.swing.JMenuItem createCvsCoReleaseMenuItem;
        createCvsCoReleaseMenuItem = new javax.swing.JMenuItem("Checkout specified release");
        createCvsCoReleaseMenuItem.setToolTipText("Checks out a specified release of the module from CVS (Sticky).");
        createCvsCoReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) releasePopupMenu.getUserObject();
                CmReleaseTreeNode cmReleaseTreeNode = ((CmReleaseTreeNode) node.getUserObject());
                StepmodPart part = cmReleaseTreeNode.getStepmodPart();
                STEPModFrame frame = part.getStepMod().getStepModGui();
                CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
                if (cmRelease != null) {
                    part.getStepMod().getStepModGui().cvsCoRelease(part, cmRelease);
                } else {
                    JOptionPane.showMessageDialog(frame,
                            "No release selected - choose a release",
                            "Warning",
                            JOptionPane.WARNING_MESSAGE);
                }
            }
        });
        releasePopupMenu.add(createCvsCoReleaseMenuItem);
        
        // Change a release option
        javax.swing.JMenuItem changeCmReleaseMenuItem;
        changeCmReleaseMenuItem = new javax.swing.JMenuItem("Change status release");
        changeCmReleaseMenuItem.setToolTipText("Allows the status of the release to be changed. The saved record and CVS will only be updated after it has been committed");
        changeCmReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) releasePopupMenu.getUserObject();
                CmReleaseTreeNode cmReleaseTreeNode = ((CmReleaseTreeNode) node.getUserObject());
                StepmodPart part = cmReleaseTreeNode.getStepmodPart();
                STEPModFrame frame = part.getStepMod().getStepModGui();
                CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
                if (cmRelease != null) {
                    new STEPModMkReleaseDialog(part, node, cmRelease).setVisible(true);
                } else {
                    JOptionPane.showMessageDialog(frame,
                            "Trying to change the development revision - choose a release",
                            "Warning",
                            JOptionPane.WARNING_MESSAGE);
                }
            }
        });
        releasePopupMenu.add(changeCmReleaseMenuItem);
        
        // Change a release option
        javax.swing.JMenuItem deleteCmReleaseMenuItem;
        deleteCmReleaseMenuItem = new javax.swing.JMenuItem("Delete release");
        deleteCmReleaseMenuItem.setToolTipText("Allows the status of the release to be changed. The saved record and CVS will only be updated after it has been committed");
        deleteCmReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) releasePopupMenu.getUserObject();
                CmReleaseTreeNode cmReleaseTreeNode = ((CmReleaseTreeNode) node.getUserObject());
                StepmodPart part = cmReleaseTreeNode.getStepmodPart();
                STEPModFrame frame = part.getStepMod().getStepModGui();
                CmRelease cmRelease = cmReleaseTreeNode.getCmRelease();
                if (cmRelease != null) {
                    frame.deleteCmRelease(part, node, cmRelease);
                } else {
                    JOptionPane.showMessageDialog(frame,
                            "Trying to delete the development revision - choose a release",
                            "Warning",
                            JOptionPane.WARNING_MESSAGE);
                }
            }
        });
        releasePopupMenu.add(deleteCmReleaseMenuItem);
    }
    
    
    
    /**
     * Setup the menu called from a mouse click on the development revision
     */
    private void initDevRevisionPopupMenu() {
        // Setup the popoup menu associated with individual modules
        devRevisionPopupMenu = new PopupMenuWithObject();
        
        // Update development revision
        javax.swing.JMenuItem createCvsUpdateDevelopmentRevisionMenuItem;
        createCvsUpdateDevelopmentRevisionMenuItem = new javax.swing.JMenuItem("Update development revision");
        createCvsUpdateDevelopmentRevisionMenuItem.setToolTipText("Checks out the latest revisions of the module from CVS for development.");
        createCvsUpdateDevelopmentRevisionMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) devRevisionPopupMenu.getUserObject();
                CmReleaseTreeNode cmReleaseTreeNode = ((CmReleaseTreeNode) node.getUserObject());
                StepmodPart part = cmReleaseTreeNode.getStepmodPart();
                STEPModFrame frame = part.getStepMod().getStepModGui();
                part.getStepMod().getStepModGui().cvsUpdate(part);
            }
        });
        devRevisionPopupMenu.add(createCvsUpdateDevelopmentRevisionMenuItem);
    }
    
    /**
     * Add the release to the tree node of releases for a given StepmodPart
     */
    public void addReleaseToTree(StepmodPart part, CmRelease cmRelease, DefaultMutableTreeNode stepPartNode, boolean shouldBeVisible) {
        // Find the release nodes - always the last one
        DefaultMutableTreeNode releasesNode = (DefaultMutableTreeNode) stepPartNode.getLastChild();
        DefaultMutableTreeNode releaseNode = new DefaultMutableTreeNode(new CmReleaseTreeNode(part, cmRelease, false));
        // Use the tree model to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
        
        TreePath path = new TreePath(releaseNode.getPath());
        repositoryJTree.expandPath(path);
        //Make sure the user can see the lovely new node.
        if (shouldBeVisible) {
            repositoryJTree.scrollPathToVisible(path);
            repositoryJTree.setSelectionPath(path);
        }
        treeModel.nodeStructureChanged(releasesNode.getParent());
        //treeModel.nodeChanged(releasesNode.getParent());
    }
    
    public void updateReleaseStatus(StepmodPart part, CmRelease cmRelease, String status, DefaultMutableTreeNode repoTreeNode, boolean shouldBeVisible) {
        cmRelease.setReleaseStatus(status, true);
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        treeModel.nodeChanged(repoTreeNode);
    }
    
    
    
    /**
     * Output the string
     */
    public void output(String string) {
        stepModOutputTextArea.append(string+"\n");
        stepModOutputTextArea.setCaretPosition(stepModOutputTextArea.getDocument().getLength());
    }
    
    
    
    /**
     * Display a popup warning that the functionality is still to be implemented.
     */
    public void toBeDone(String operationName) {
        String message = "Operation: " + operationName + " still to be implemented";
        JOptionPane.showMessageDialog(this,
                message,
                "Method not yet implemented",
                JOptionPane.WARNING_MESSAGE);
    }
    
    /**
     * Display a popup warning and outputthe string
     */
    public void warning(String message) {
        output(message);
        JOptionPane.showMessageDialog(this,
                message,
                "Warning",
                JOptionPane.WARNING_MESSAGE);
    }
    
    public STEPmod getStepMod() {
        return stepMod;
    }
    
    private StepmodPartTreeNodeCollection getModulesTreeNodeCollection() {
        return(modulesTreeNodeCollection);
    }
    
    public StepmodPartTreeNodeCollection getApTreeNodeCollection() {
        return apTreeNodeCollection;
    }
    
    public StepmodPartTreeNodeCollection getResourceDocsTreeNodeCollection() {
        return resourceDocsTreeNodeCollection;
    }
    
    public StepmodPartTreeNodeCollection getSchemasTreeNodeCollection() {
        return schemasTreeNodeCollection;
    }
    
    private void saveCmRecord(StepmodPart part) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to save the CM record for "+part.getName()+" to CVS?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            part.getCmRecord().writeCmRecord();
            updateNode(part);
        }
    }
    
    
    
    
    
    
    
    private void deleteCmRelease(StepmodPart part, DefaultMutableTreeNode node, CmRelease cmRelease) {
        int answer = JOptionPane.showConfirmDialog(this,
                "You are about to delete the release "+cmRelease.getId()+"\nDo you want to continue?",
                "CM release action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            // Delete the release
            part.getCmRecord().deleteCmRelease(cmRelease);
            // Now delete the release from the tree
            DefaultTreeModel model = (DefaultTreeModel)repositoryJTree.getModel();
            model.removeNodeFromParent(node);
            updateNode(part);
        }
    }
    
    
    private void cvsTest() {
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        int exitVal = stepmodCvs.testCVSconnection();
        
        outputCvsResults(stepmodCvs);
        if (stepmodCvs.getCvsErrorVal() == StepmodCvs.CVS_ERROR_OK) {
            JOptionPane.showMessageDialog(this,
                    "Succesfully connected to CVS @ SourceForge",
                    "CVS OK",
                    JOptionPane.PLAIN_MESSAGE);
        }
        
    }
    
    private void cvsUpdate(StepmodPart part) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to do a CVS update on "+part.getName()+"?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            StepmodCvs stepmodCvs = part.cvsUpdate();
            updateNode(part);
            outputCvsResults(stepmodCvs);
        }
    }
    
    private void cvsCommitRecord(StepmodPart part) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to commit the CM record for "+part.getName()+" to CVS?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            StepmodCvs stepmodCvs = part.cvsCommitRecord();
            updateNode(part);
            outputCvsResults(stepmodCvs);
        }
    }
    
    
    private void cvsCoRelease(StepmodPart part, CmRelease cmRelease) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to check out the release " +cmRelease.getId() + "for "+part.getName()+"?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            StepmodCvs stepmodCvs = part.cvsCoRelease(cmRelease);
            updateNode(part);
            outputCvsResults(stepmodCvs);
        }
    }
    
    private void cvsCoLatestRelease(StepmodPart part) {
        CmRelease cmRelease = part.getCmRecord().getLatestRelease();
        if (cmRelease != null) {
            int answer = JOptionPane.showConfirmDialog(this,
                    "Do you want to check out the latest release (" +cmRelease.getId()+") for "+part.getName()+"?",
                    "CVS action ....",
                    JOptionPane.YES_NO_OPTION);
            if (answer == JOptionPane.YES_OPTION) {
                StepmodCvs stepmodCvs = part.cvsCoRelease(cmRelease);
                updateNode(part);
                outputCvsResults(stepmodCvs);
            }
        } else {
            JOptionPane.showMessageDialog(this,
                    "There are no releases",
                    "Warning",
                    JOptionPane.WARNING_MESSAGE);
        }
    }
    
    
    
    private void cvsCoPublishedRelease(StepmodPart part) {
        CmRelease cmRelease = part.getCmRecord().getLatestPublishedRelease();
        if (cmRelease != null) {
            int answer = JOptionPane.showConfirmDialog(this,
                    "Do you want to commit the CM record for "+part.getName()+" to CVS?",
                    "CVS action ....",
                    JOptionPane.YES_NO_OPTION);
            if (answer == JOptionPane.YES_OPTION) {
                StepmodCvs stepmodCvs = part.cvsCoRelease(cmRelease);
                updateNode(part);
                outputCvsResults(stepmodCvs);
            }
        } else {
            JOptionPane.showMessageDialog(this,
                    "There are no releases published by ISO",
                    "Warning",
                    JOptionPane.WARNING_MESSAGE);
        }
    }
    
    
    
    public void outputCvsResults(StepmodCvs stepmodCvs) {
        output("********* CVS ***********");
        output(stepmodCvs.getCvsCommand());
        output(stepmodCvs.getCvsMessages());
        output("CVS exiting with: "+stepmodCvs.getCvsExitVal());
        String message = null;
        int cvsError = stepmodCvs.getCvsErrorVal();
        switch (cvsError) {
            case StepmodCvs.CVS_ERROR_PROPS_CVSEXE:
                message = "Property CVSEXE is not set. Setup StepMod properties";
                break;
            case StepmodCvs.CVS_ERROR_PROPS_CVS_RSH:
                message = "Property CVS_RSH is not set. Setup StepMod properties";
                break;
            case StepmodCvs.CVS_ERROR_PROPS_SFORGE_USERNAME:
                message = "Property SFORGE_USERNAME is not set. Setup StepMod properties";
                break;
            case StepmodCvs.CVS_ERROR_SSH:
                message =
                        "Unable to connect to CVS @ SourceForge\nCVS is asking for a password, so SSH is not setup correctly";
                break;
        }
        if (message != null) {
            output("CVS error: "+message);
            JOptionPane.showMessageDialog(this, message, "Warning",JOptionPane.WARNING_MESSAGE);
        }
    }
    
    
    private void writeCmRecord(StepmodPart part) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to save the CM record for "+part.getName()+"?",
                "Save CM record ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            CmRecord cmRecord= part.getCmRecord();
            cmRecord.writeCmRecord();
            updateNode(part);
        }
    }
    
    
    public Object getCurrentDisplayedObject() {
        return currentDisplayedObject;
    }
    
    public void setCurrentDisplayedObject(Object currentDisplayedObject) {
        this.currentDisplayedObject = currentDisplayedObject;
    }
    
    
    
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc=" Generated Code ">//GEN-BEGIN:initComponents
    private void initComponents() {
        outputPopupMenu = new javax.swing.JPopupMenu();
        clearOutputMenuItem = new javax.swing.JMenuItem();
        stepmodMainSplitPane = new javax.swing.JSplitPane();
        jPanel1 = new javax.swing.JPanel();
        jToolBar1 = new javax.swing.JToolBar();
        clearSelectedButton = new javax.swing.JButton();
        viewAllButton = new javax.swing.JButton();
        viewSelectedToggleButton = new javax.swing.JToggleButton();
        jLabel1 = new javax.swing.JLabel();
        findPartjTextField = new javax.swing.JTextField();
        jButton1 = new javax.swing.JButton();
        repositorySplitPane = new javax.swing.JSplitPane();
        repositoryTreeScrollPane = new javax.swing.JScrollPane();
        repositoryJTree = new javax.swing.JTree();
        repositoryScrollPane = new javax.swing.JScrollPane();
        repositoryTextPane = new javax.swing.JTextPane();
        stepModOutputPanel = new javax.swing.JPanel();
        stepModOutputScrollPane = new javax.swing.JScrollPane();
        stepModOutputTextArea = new javax.swing.JTextArea();
        menuBar = new javax.swing.JMenuBar();
        fileMenu = new javax.swing.JMenu();
        reloadRepositoryMenuItem = new javax.swing.JMenuItem();
        exitMenuItem = new javax.swing.JMenuItem();
        viewMenu = new javax.swing.JMenu();
        clearAllMenuItem = new javax.swing.JMenuItem();
        viewSelectedMenuItem = new javax.swing.JMenuItem();
        vewAllMenuItem = new javax.swing.JMenuItem();
        toolsMenu = new javax.swing.JMenu();
        mkModuleMenuItem = new javax.swing.JMenuItem();
        mkApMenuItem = new javax.swing.JMenuItem();
        mkdResDocMenuItem = new javax.swing.JMenuItem();
        setStepModProps = new javax.swing.JMenuItem();
        testCVSMenuItem = new javax.swing.JMenuItem();
        helpMenu = new javax.swing.JMenu();
        contentsMenuItem = new javax.swing.JMenuItem();
        aboutMenuItem = new javax.swing.JMenuItem();

        clearOutputMenuItem.setText("Clear text");
        clearOutputMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clearOutputMenuItemActionPerformed(evt);
            }
        });

        outputPopupMenu.add(clearOutputMenuItem);

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("STEPMod App");
        stepmodMainSplitPane.setDividerLocation(500);
        stepmodMainSplitPane.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        stepmodMainSplitPane.setOneTouchExpandable(true);
        stepmodMainSplitPane.setPreferredSize(new java.awt.Dimension(302, 400));
        stepmodMainSplitPane.setRequestFocusEnabled(false);
        jPanel1.setLayout(new java.awt.BorderLayout());

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("STEPmod Repository"));
        jPanel1.setMinimumSize(new java.awt.Dimension(0, 0));
        jPanel1.setPreferredSize(new java.awt.Dimension(150, 200));
        jToolBar1.setFloatable(false);
        jToolBar1.setMinimumSize(new java.awt.Dimension(0, 0));
        clearSelectedButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/org/stepmod/resources/box.png")));
        clearSelectedButton.setToolTipText("Clear all selections");
        clearSelectedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clearSelectedButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(clearSelectedButton);

        viewAllButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/org/stepmod/resources/arrow_refresh.png")));
        viewAllButton.setToolTipText("View all the parts");
        viewAllButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                viewAllButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(viewAllButton);

        viewSelectedToggleButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/org/stepmod/resources/box_selected.png")));
        viewSelectedToggleButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                viewSelectedToggleButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(viewSelectedToggleButton);

        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel1.setText("Part number: ");
        jLabel1.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        jToolBar1.add(jLabel1);

        findPartjTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                findPartjTextFieldActionPerformed(evt);
            }
        });

        jToolBar1.add(findPartjTextField);

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/org/stepmod/resources/find.png")));
        jButton1.setToolTipText("Find the part");
        jButton1.setMargin(new java.awt.Insets(0, 0, 0, 4));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                findPartjTextFieldActionPerformed(evt);
            }
        });

        jToolBar1.add(jButton1);

        jPanel1.add(jToolBar1, java.awt.BorderLayout.NORTH);

        repositorySplitPane.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 1, 1, 1));
        repositorySplitPane.setDividerLocation(400);
        repositorySplitPane.setMinimumSize(new java.awt.Dimension(0, 0));
        repositorySplitPane.setOneTouchExpandable(true);
        repositorySplitPane.setPreferredSize(new java.awt.Dimension(100, 500));
        repositoryTreeScrollPane.setAutoscrolls(true);
        repositoryTreeScrollPane.setMinimumSize(new java.awt.Dimension(0, 0));
        repositoryTreeScrollPane.setPreferredSize(new java.awt.Dimension(75, 200));
        repositoryTreeScrollPane.setViewportView(repositoryJTree);

        repositorySplitPane.setLeftComponent(repositoryTreeScrollPane);

        repositoryScrollPane.setAutoscrolls(true);
        repositoryScrollPane.setMinimumSize(new java.awt.Dimension(0, 0));
        repositoryScrollPane.setPreferredSize(new java.awt.Dimension(75, 200));
        repositoryScrollPane.setViewportView(repositoryTextPane);

        repositorySplitPane.setRightComponent(repositoryScrollPane);

        jPanel1.add(repositorySplitPane, java.awt.BorderLayout.CENTER);

        stepmodMainSplitPane.setLeftComponent(jPanel1);

        stepModOutputPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("STEPmod output"));
        stepModOutputPanel.setMinimumSize(new java.awt.Dimension(0, 0));
        stepModOutputTextArea.setColumns(20);
        stepModOutputTextArea.setRows(5);
        stepModOutputScrollPane.setViewportView(stepModOutputTextArea);

        org.jdesktop.layout.GroupLayout stepModOutputPanelLayout = new org.jdesktop.layout.GroupLayout(stepModOutputPanel);
        stepModOutputPanel.setLayout(stepModOutputPanelLayout);
        stepModOutputPanelLayout.setHorizontalGroup(
            stepModOutputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(stepModOutputScrollPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 706, Short.MAX_VALUE)
        );
        stepModOutputPanelLayout.setVerticalGroup(
            stepModOutputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(stepModOutputScrollPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 167, Short.MAX_VALUE)
        );
        stepmodMainSplitPane.setRightComponent(stepModOutputPanel);

        fileMenu.setText("File");
        reloadRepositoryMenuItem.setText("Reload repository_index.xml");
        reloadRepositoryMenuItem.setToolTipText("Reloads all the parts identified in the repository index");
        reloadRepositoryMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                reloadRepositoryMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(reloadRepositoryMenuItem);

        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(exitMenuItem);

        menuBar.add(fileMenu);

        viewMenu.setText("View");
        clearAllMenuItem.setText("Unselect all");
        clearAllMenuItem.setToolTipText("Unselect allparts currently selected ");
        clearAllMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clearAllMenuItemActionPerformed(evt);
            }
        });

        viewMenu.add(clearAllMenuItem);

        viewSelectedMenuItem.setText("View all selected parts");
        viewSelectedMenuItem.setToolTipText("Only display thel selected parts");
        viewSelectedMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                viewSelectedMenuItemActionPerformed(evt);
            }
        });

        viewMenu.add(viewSelectedMenuItem);

        vewAllMenuItem.setText("View all parts");
        vewAllMenuItem.setToolTipText("Display all the parts in the tree");
        vewAllMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                vewAllMenuItemActionPerformed(evt);
            }
        });

        viewMenu.add(vewAllMenuItem);

        menuBar.add(viewMenu);

        toolsMenu.setText("Tools");
        mkModuleMenuItem.setText("Create new module");
        mkModuleMenuItem.setToolTipText("Creates all files necessary for a new module");
        mkModuleMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mkModuleMenuItemActionPerformed(evt);
            }
        });

        toolsMenu.add(mkModuleMenuItem);

        mkApMenuItem.setText("Create new Application protocol");
        mkApMenuItem.setToolTipText("Creates all files necessary for a new application protocol");
        mkApMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mkApMenuItemActionPerformed(evt);
            }
        });

        toolsMenu.add(mkApMenuItem);

        mkdResDocMenuItem.setText("Create new Resource document");
        mkdResDocMenuItem.setToolTipText("Creates all files necessary for a new reosurce document");
        mkdResDocMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mkdResDocMenuItemActionPerformed(evt);
            }
        });

        toolsMenu.add(mkdResDocMenuItem);

        setStepModProps.setText("Set stepmod properties");
        setStepModProps.setToolTipText("Change the contents of the stepmod properties file ");
        setStepModProps.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                setStepModPropsActionPerformed(evt);
            }
        });

        toolsMenu.add(setStepModProps);

        testCVSMenuItem.setText("Test CVS connection");
        testCVSMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                testCVSMenuItemActionPerformed(evt);
            }
        });

        toolsMenu.add(testCVSMenuItem);

        menuBar.add(toolsMenu);

        helpMenu.setText("Help");
        contentsMenuItem.setText("Contents");
        contentsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                contentsMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(contentsMenuItem);

        aboutMenuItem.setText("About");
        aboutMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aboutMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(aboutMenuItem);

        menuBar.add(helpMenu);

        setJMenuBar(menuBar);

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(stepmodMainSplitPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 724, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .add(stepmodMainSplitPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 703, Short.MAX_VALUE))
        );
        pack();
    }// </editor-fold>//GEN-END:initComponents
    
    private void viewSelectedToggleButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_viewSelectedToggleButtonActionPerformed
        if (viewSelectedToggleButton.isSelected()) {
            viewSelectedParts();
        } else {
            viewAllParts();
        }
    }//GEN-LAST:event_viewSelectedToggleButtonActionPerformed
    
    private void vewAllMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_vewAllMenuItemActionPerformed
        viewAllParts();
    }//GEN-LAST:event_vewAllMenuItemActionPerformed
    
    private void viewSelectedMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_viewSelectedMenuItemActionPerformed
        viewSelectedParts();
    }//GEN-LAST:event_viewSelectedMenuItemActionPerformed
    
    private void clearAllMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearAllMenuItemActionPerformed
        clearAllSelectedParts();
    }//GEN-LAST:event_clearAllMenuItemActionPerformed
    
    private void clearSelectedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearSelectedButtonActionPerformed
        clearAllSelectedParts();
    }//GEN-LAST:event_clearSelectedButtonActionPerformed
    
    private void reloadRepositoryMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_reloadRepositoryMenuItemActionPerformed
        int answer = JOptionPane.showConfirmDialog(this,
                "You are about to reload the repository_index. Do you want to continue?",
                "Loading repository_index.xml ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            repositoryJTree.collapseRow(0);
            // Clear any ouput being displayed
            setCurrentDisplayedObject(null);
            repositoryTextPane.setText("");
            getStepMod().readRepositoryIndex();
            initRepositoryTree();
        }
    }//GEN-LAST:event_reloadRepositoryMenuItemActionPerformed
    
    private void viewAllButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_viewAllButtonActionPerformed
        viewAllParts();
    }//GEN-LAST:event_viewAllButtonActionPerformed
    
    private void findPartjTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_findPartjTextFieldActionPerformed
        String part = findPartjTextField.getText()+":";
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        // Find the node for the part
        DefaultMutableTreeNode node = this.findNodeByPrefix(root, part);
        if (node != null) {
            TreePath path = new TreePath(node.getPath());
            repositoryJTree.expandPath(path);
            repositoryJTree.setSelectionPath(path);
        } else {
            // not found
            JOptionPane.showMessageDialog(this,
                    "Unable to find part"+part,
                    "Warning",
                    JOptionPane.WARNING_MESSAGE);
        }
    }//GEN-LAST:event_findPartjTextFieldActionPerformed
    
    private void testCVSMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_testCVSMenuItemActionPerformed
        this.cvsTest();
    }//GEN-LAST:event_testCVSMenuItemActionPerformed
    
    /**
     * Display a new smaller gui to display the contents of stepmod.properties
     *
     */
    private void setStepModPropsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_setStepModPropsActionPerformed
        STEPModPropsFrame stepprops = new STEPModPropsFrame(getStepMod());
        stepprops.setVisible(true);
    }//GEN-LAST:event_setStepModPropsActionPerformed
    
    private void aboutMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aboutMenuItemActionPerformed
        getStepMod().about();
    }//GEN-LAST:event_aboutMenuItemActionPerformed
    
    private void contentsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_contentsMenuItemActionPerformed
        getStepMod().help();
    }//GEN-LAST:event_contentsMenuItemActionPerformed
    
    private void mkdResDocMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mkdResDocMenuItemActionPerformed
        getStepMod().mkNewResourceDoc();
    }//GEN-LAST:event_mkdResDocMenuItemActionPerformed
    
    private void mkApMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mkApMenuItemActionPerformed
        getStepMod().mkNewApplicationProtocol();
    }//GEN-LAST:event_mkApMenuItemActionPerformed
    
    private void clearOutputMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearOutputMenuItemActionPerformed
        stepModOutputTextArea.setText("");
    }//GEN-LAST:event_clearOutputMenuItemActionPerformed
    
    private void mkModuleMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mkModuleMenuItemActionPerformed
        getStepMod().mkNewModule();
    }//GEN-LAST:event_mkModuleMenuItemActionPerformed
    
    private void exitMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_exitMenuItemActionPerformed
        System.exit(0);
    }//GEN-LAST:event_exitMenuItemActionPerformed
    
    
    
    
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem aboutMenuItem;
    private javax.swing.JMenuItem clearAllMenuItem;
    private javax.swing.JMenuItem clearOutputMenuItem;
    private javax.swing.JButton clearSelectedButton;
    private javax.swing.JMenuItem contentsMenuItem;
    private javax.swing.JMenuItem exitMenuItem;
    private javax.swing.JMenu fileMenu;
    private javax.swing.JTextField findPartjTextField;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JMenuItem mkApMenuItem;
    private javax.swing.JMenuItem mkModuleMenuItem;
    private javax.swing.JMenuItem mkdResDocMenuItem;
    private javax.swing.JPopupMenu outputPopupMenu;
    private javax.swing.JMenuItem reloadRepositoryMenuItem;
    private javax.swing.JTree repositoryJTree;
    private javax.swing.JScrollPane repositoryScrollPane;
    private javax.swing.JSplitPane repositorySplitPane;
    private javax.swing.JTextPane repositoryTextPane;
    private javax.swing.JScrollPane repositoryTreeScrollPane;
    private javax.swing.JMenuItem setStepModProps;
    private javax.swing.JPanel stepModOutputPanel;
    private javax.swing.JScrollPane stepModOutputScrollPane;
    private javax.swing.JTextArea stepModOutputTextArea;
    private javax.swing.JSplitPane stepmodMainSplitPane;
    private javax.swing.JMenuItem testCVSMenuItem;
    private javax.swing.JMenu toolsMenu;
    private javax.swing.JMenuItem vewAllMenuItem;
    private javax.swing.JButton viewAllButton;
    private javax.swing.JMenu viewMenu;
    private javax.swing.JMenuItem viewSelectedMenuItem;
    private javax.swing.JToggleButton viewSelectedToggleButton;
    // End of variables declaration//GEN-END:variables
    
    
    
}
