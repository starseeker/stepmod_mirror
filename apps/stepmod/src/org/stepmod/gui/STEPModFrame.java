/*
 * $Id: CmRecordFrmwk.java,v 1.4 2006/12/12 13:59:08 robbod Exp $
 *
 * STEPModFrame.java
 *
 * Owner: Developed by Eurostep Limited and supplied to ATI/NIST under contract.
 * Author: Rob Bodington, Eurostep Limited
 */

package org.stepmod.gui;

import java.awt.Color;
import java.awt.Component;
import java.awt.Insets;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.security.CodeSource;
import java.security.ProtectionDomain;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.EventObject;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;
import javax.swing.AbstractCellEditor;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.JSeparator;
import javax.swing.JTree;
import javax.swing.SwingUtilities;
import javax.swing.ToolTipManager;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.event.TreeExpansionEvent;
import javax.swing.event.TreeExpansionListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeCellEditor;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;
import org.stepmod.CmRecord;
import org.stepmod.CmRecordFrmwk;
import org.stepmod.CmRelease;
import org.stepmod.CmReleaseFrmwk;
import org.stepmod.STEPmod;
import org.stepmod.StepmodApplicationProtocol;
import org.stepmod.StepmodFile;
import org.stepmod.StepmodModule;
import org.stepmod.StepmodPart;
import org.stepmod.StepmodPartCM;
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
     * The popup menu associated with a release in the parts tree
     */
    private PopupMenuWithObject releasePopupMenu;
    
    
    /**
     * The popup menu associated with a release of the framework
     */
    private PopupMenuWithObject frmwkReleasePopupMenu;
    
    /**
     * The popup menu associated with a new release of the framework
     */
    private PopupMenuWithObject frmwkNewReleasePopupMenu;
    
    
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
    private javax.swing.JMenuItem createCmReleaseMenuItem;
    private javax.swing.JMenuItem createCmReleaseFromTagMenuItem;
    
    
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
    
    
    /**
     * A object used in the repository tree to indicate whether the cm release of the common files or stepmod framework
     * has been selected or not
     */
    private class CmReleaseFrmwkTreeNode {
        CmReleaseFrmwk cmRelease;
        CmRecordFrmwk cmRecord;
        String text;
        boolean selected;
        boolean checkedOutRevision;
        
        public CmReleaseFrmwkTreeNode(CmRecordFrmwk cmRecord, CmReleaseFrmwk cmRelease, boolean selected) {
            this.cmRecord = cmRecord;
            this.cmRelease = cmRelease;
            this.text = cmRelease.toString();
            this.selected = selected;
        }
        
        public CmReleaseFrmwkTreeNode(CmRecordFrmwk cmRecord, String text, boolean selected) {
            this.cmRecord = cmRecord;
            this.cmRelease = null;
            this.text = text;
            this.selected = selected;
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
        
        private CmReleaseFrmwk getCmRelease() {
            return cmRelease;
        }
        
        private CmReleaseFrmwk getCurrentCmRelease() {
            return(this.cmRecord.getCheckedOutRelease());
        }
        
        private CmRecordFrmwk getCmRecord() {
            return(cmRecord);
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
        
        private Icon developmentIcon;
        private Icon releasedIcon;
        private Icon publishedIcon;
        
        
        private Icon relSelCvsIcon;
        private Icon relUnSelCvsIcon;
        private Icon relSelCvsModIcon;
        private Icon relUnSelCvsModIcon;
        private Icon relSelCvsUnknownIcon;
        private Icon relUnSelCvsUnknownIcon;
        private Icon relSelCvsAddIcon;
        private Icon relUnSelCvsAddIcon;
        private Icon relSelCvsNoFileIcon;
        private Icon relUnSelCvsNoFileIcon;
        
        private Icon pubSelCvsIcon;
        private Icon pubUnSelCvsIcon;
        private Icon pubSelCvsModIcon;
        private Icon pubUnSelCvsModIcon;
        private Icon pubSelCvsUnknownIcon;
        private Icon pubUnSelCvsUnknownIcon;
        private Icon pubSelCvsAddIcon;
        private Icon pubUnSelCvsAddIcon;
        private Icon pubSelCvsNoFileIcon;
        private Icon pubUnSelCvsNoFileIcon;
        
        private Icon devSelCvsIcon;
        private Icon devUnSelCvsIcon;
        private Icon devSelCvsModIcon;
        private Icon devUnSelCvsModIcon;
        private Icon devSelCvsUnknownIcon;
        private Icon devUnSelCvsUnknownIcon;
        private Icon devSelCvsAddIcon;
        private Icon devUnSelCvsAddIcon;
        private Icon devSelCvsNoFileIcon;
        private Icon devUnSelCvsNoFileIcon;
        
        private Icon cvsUnModifiedIcon;
        private Icon cvsModifiedIcon;
        
        private JCheckBox checkBoxRenderer = new JCheckBox();
        private Color selectionForeground;
        private Color selectionBackground;
        private Color textForeground;
        private Color textBackground;
        private Color currentBackground;
        private java.awt.Font fontBoldItalic = new java.awt.Font("Tahoma", 3, 11);
        private java.awt.Font fontPlain = new java.awt.Font("Tahoma", 0, 11);
        private java.awt.Font fontBold = new java.awt.Font("Tahoma", 1, 11);
        private java.awt.Font fontItalic = new java.awt.Font("Tahoma", 2, 11);
        private STEPmod stepMod;
        
        public RepositoryTreeRenderer() {
            this.stepMod = stepMod;
            
            java.net.URL cvsUnModifiedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/file-cvs-unmodified.png");
            cvsUnModifiedIcon = null;
            if (cvsUnModifiedIconURL != null) {
                cvsUnModifiedIcon = new ImageIcon(cvsUnModifiedIconURL);
            }
            java.net.URL cvsModifiedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/file-cvs-modified.png");
            cvsModifiedIcon = null;
            if (cvsModifiedIconURL != null) {
                cvsModifiedIcon = new ImageIcon(cvsModifiedIconURL);
            }
            
            java.net.URL developmentIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/development.png");
            developmentIcon = null;
            if (developmentIconURL != null) {
                developmentIcon = new ImageIcon(developmentIconURL);
            }
            
            java.net.URL publishedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/published.png");
            publishedIcon = null;
            if (publishedIconURL != null) {
                publishedIcon = new ImageIcon(publishedIconURL);
            }
            
            java.net.URL releasedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/released.png");
            releasedIcon = null;
            if (releasedIconURL != null) {
                releasedIcon = new ImageIcon(releasedIconURL);
            }
            
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
            java.net.URL relSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_selected_cvsunknown.png");
            relSelCvsUnknownIcon = null;
            if (relSelCvsUnknownIconURL != null) {
                relSelCvsUnknownIcon= new ImageIcon(relSelCvsUnknownIconURL);
            }
            java.net.URL relUnSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_unselected_cvsunknown.png");
            relUnSelCvsUnknownIcon = null;
            if (relUnSelCvsUnknownIconURL != null) {
                relUnSelCvsUnknownIcon= new ImageIcon(relUnSelCvsUnknownIconURL);
            }
            java.net.URL relSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_selected_cvsadd.png");
            relSelCvsAddIcon = null;
            if (relSelCvsAddIconURL != null) {
                relSelCvsAddIcon= new ImageIcon(relSelCvsAddIconURL);
            }
            java.net.URL relUnSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_unselected_cvsadd.png");
            relUnSelCvsAddIcon = null;
            if (relUnSelCvsAddIconURL != null) {
                relUnSelCvsAddIcon= new ImageIcon(relUnSelCvsAddIconURL);
            }
            java.net.URL relSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_selected_cvsnofile.png");
            relSelCvsNoFileIcon = null;
            if (relSelCvsNoFileIconURL != null) {
                relSelCvsNoFileIcon= new ImageIcon(relSelCvsNoFileIconURL);
            }
            java.net.URL relUnSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/rel_unselected_cvsnofile.png");
            relUnSelCvsNoFileIcon = null;
            if (relUnSelCvsNoFileIconURL != null) {
                relUnSelCvsNoFileIcon= new ImageIcon(relUnSelCvsNoFileIconURL);
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
            java.net.URL pubSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_selected_cvsunknown.png");
            pubSelCvsUnknownIcon = null;
            if (pubSelCvsUnknownIconURL != null) {
                pubSelCvsUnknownIcon= new ImageIcon(pubSelCvsUnknownIconURL);
            }
            java.net.URL pubUnSelCvsUnknownIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_unselected_cvsunknown.png");
            pubUnSelCvsUnknownIcon = null;
            if (pubUnSelCvsUnknownIconURL != null) {
                pubUnSelCvsUnknownIcon= new ImageIcon(pubUnSelCvsUnknownIconURL);
            }
            java.net.URL pubSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_selected_cvsadd.png");
            pubSelCvsAddIcon = null;
            if (pubSelCvsAddIconURL != null) {
                pubSelCvsAddIcon= new ImageIcon(pubSelCvsAddIconURL);
            }
            java.net.URL pubUnSelCvsAddIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_unselected_cvsadd.png");
            pubUnSelCvsAddIcon = null;
            if (pubUnSelCvsAddIconURL != null) {
                pubUnSelCvsAddIcon= new ImageIcon(pubUnSelCvsAddIconURL);
            }
            java.net.URL pubSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_selected_cvsnofile.png");
            pubSelCvsNoFileIcon = null;
            if (pubSelCvsNoFileIconURL != null) {
                pubSelCvsNoFileIcon= new ImageIcon(pubSelCvsNoFileIconURL);
            }
            java.net.URL pubUnSelCvsNoFileIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/pub_unselected_cvsnofile.png");
            pubUnSelCvsNoFileIcon = null;
            if (pubUnSelCvsNoFileIconURL != null) {
                pubUnSelCvsNoFileIcon= new ImageIcon(pubUnSelCvsNoFileIconURL);
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
            checkBoxRenderer.setFont(fontPlain);
            // Highlight according to whether the tree node is selected (as opposed to the checkbox)
            if (sel) {
                checkBoxRenderer.setForeground(selectionForeground);
                checkBoxRenderer.setBackground(selectionBackground);
            } else if (checkedOutrel) {
                checkBoxRenderer.setForeground(textForeground);
                checkBoxRenderer.setBackground(currentBackground);
                if (cmRelease != null) {
                    if (!cmRelease.isDependenciesCheckedOut()) {
                        checkBoxRenderer.setFont(fontBoldItalic);
                    }
                }
            } else {
                checkBoxRenderer.setForeground(textForeground);
                checkBoxRenderer.setBackground(textBackground);
            }
        }
        
        
        /**
         * Called from getTreeCellRendererComponent. Draws the nodes for the cmReleaseTreeNode in the tree
         */
        private void setupIconsForCmReleaseFrmwk(JTree tree, boolean sel, CmReleaseFrmwkTreeNode cmReleaseTreeNode) {
            setText(cmReleaseTreeNode.toString());
            CmReleaseFrmwk cmRelease = cmReleaseTreeNode.getCmRelease();
            CmReleaseFrmwk cmCoRelease = cmReleaseTreeNode.getCurrentCmRelease();
            boolean checkedOutrel = false;
            setFont(fontPlain);
            setIcon(null);
            // Highlight according to whether the tree node is selected (as opposed to the checkbox)
            if (cmRelease == cmCoRelease) {
                setForeground(textForeground);
                setBackground(currentBackground);
            } else {
                setForeground(textForeground);
                setBackground(textBackground);
            }
        }
        
        
        
        /**
         * Called from getTreeCellRendererComponent. Draws the nodes for the stepmod part in the tree
         */
        private void setupIconsForStepmodPart(JTree tree, boolean sel, StepmodPartTreeNode stepmodPartTreeNode, boolean developmentPart) {
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
                if (developmentPart) {
                    checkBoxRenderer.setIcon(developmentIcon);
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(devUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file has been modified and changes not commited to CVS");
                } else if ((cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) || (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED)){
                    // cm record file does not exist
                    checkBoxRenderer.setIcon(devUnSelCvsUnknownIcon);
                    checkBoxRenderer.setSelectedIcon(devSelCvsUnknownIcon);
                    checkBoxRenderer.setToolTipText("Development revision. Cm record file exists, but has not been committed to CVS");
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
                if (developmentPart) {
                    checkBoxRenderer.setIcon(publishedIcon);
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(pubUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Release is published by ISO. Cm record file has been modified and changes not commited to CVS");
                } else if ((cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) || (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED)){
                    // cm record file does not exist
                    checkBoxRenderer.setIcon(pubUnSelCvsUnknownIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsUnknownIcon);
                    checkBoxRenderer.setToolTipText("Published revision. Cm record file exists, but has not been committed to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_ADDED) {
                    checkBoxRenderer.setIcon(pubUnSelCvsAddIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsAddIcon);
                    checkBoxRenderer.setToolTipText("Published revision. Cm record file exists, but has not been added to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                    checkBoxRenderer.setIcon(pubUnSelCvsNoFileIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsNoFileIcon);
                    checkBoxRenderer.setToolTipText("Published revision. Cm record file exists, but has not been added to CVS");
                } else {
                    checkBoxRenderer.setIcon(pubUnSelCvsIcon);
                    checkBoxRenderer.setSelectedIcon(pubSelCvsIcon);
                    checkBoxRenderer.setToolTipText("Release is published by ISO. Cm record file is committed to CVS");
                }
            } else if (stepmodPart.isCheckedOutRelease()) {
                if (developmentPart) {
                    checkBoxRenderer.setIcon(releasedIcon);
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                    checkBoxRenderer.setIcon(relUnSelCvsModIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsModIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file has been modified and changes not commited to CVS");
                } else if ((cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) || (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED)){
                    // cm record file does not exist
                    checkBoxRenderer.setIcon(relUnSelCvsUnknownIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsUnknownIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file exists, but has not been committed to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_CVS_ADDED) {
                    checkBoxRenderer.setIcon(relUnSelCvsAddIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsAddIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file exists, but has not been added to CVS");
                } else if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                    checkBoxRenderer.setIcon(relUnSelCvsNoFileIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsNoFileIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file exists, but has not been added to CVS");
                } else {
                    checkBoxRenderer.setIcon(relUnSelCvsIcon);
                    checkBoxRenderer.setSelectedIcon(relSelCvsIcon);
                    checkBoxRenderer.setToolTipText("Released revision. Cm record file is committed to CVS");
                }
            }
            if (stepmodPart.isDependenciesCheckedOut()) {
                checkBoxRenderer.setFont(fontPlain);
            } else {
                checkBoxRenderer.setFont(fontBoldItalic);
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
            setFont(fontPlain);
            setOpaque(true);
            setBackground(textBackground);
            setForeground(textForeground);
            STEPmod stepMod = (STEPmod)((DefaultMutableTreeNode)tree.getModel().getRoot()).getUserObject();
            
            if (node != null) {
                Object userNode = (Object)node.getUserObject();
                // Get the part
                StepmodPart stepmodPart = null;
                if (userNode instanceof CmReleaseTreeNode) {
                    CmReleaseTreeNode cmReleaseTreeNode = (CmReleaseTreeNode) node.getUserObject();
                    setupIconsForCmRelease(tree,sel,cmReleaseTreeNode);
                    String text = userNode.toString();
                    if (text.equals("Dependencies")) {
                        setToolTipText("Dependencies for the part");
                    }
                    return(checkBoxRenderer);
                } else if (userNode instanceof CmReleaseFrmwkTreeNode) {
                    CmReleaseFrmwkTreeNode cmReleaseTreeNode = (CmReleaseFrmwkTreeNode) node.getUserObject();
                    setupIconsForCmReleaseFrmwk(tree,sel,cmReleaseTreeNode);
                } else if (userNode instanceof StepmodPartTreeNode) {
                    StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                    if (node.getParent().toString().equals("Dependencies")) {
                        setupIconsForStepmodPart(tree,sel,stepmodPartTreeNode, true);
                    } else {
                        setupIconsForStepmodPart(tree,sel,stepmodPartTreeNode, false);
                    }
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
                    
                    if (text.equals("Development revision")) {
                        // looking at the release of stepmod or basic
                        TreeNode parentNode = node.getParent();
                        String parentText = parentNode.toString();
                        
                    } else if (text.equals("STEPmod Framework")) {
                        if (stepMod.getStepmodCmRecord().getCmRecordCvsStatus() == CmRecordFrmwk.CM_RECORD_CVS_CHANGED) {
                            setIcon(cvsModifiedIcon);
                        } else {
                            setIcon(cvsUnModifiedIcon);
                        }
                    } else if (text.equals("Common files")) {
                        if (stepMod.getBasicCmRecord().getCmRecordCvsStatus() == CmRecordFrmwk.CM_RECORD_CVS_CHANGED) {
                            setIcon(cvsModifiedIcon);
                        } else {
                            setIcon(cvsUnModifiedIcon);
                        }
                    }
                    setForeground(Color.BLACK);
                    setFont(fontPlain);
                }  else if (userNode instanceof StepmodPartCM) {
                    StepmodPartCM stepmodPartCM = (StepmodPartCM) userNode;
                    if (stepmodPartCM.isCheckedOut()) {
                        setFont(fontPlain);
                    } else {
                        setFont(fontBoldItalic);
                    }
                    setToolTipText("Dependencies for this revision of the part");
                    setIcon(null);
                } else {
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
                        // RBN - I only want the selection to take place if the box is selected - not just the whole line
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
        // No repository loaded yet
        reloadRepositoryIndexMenuItem.setEnabled(false);
        repositoryJTree.setVisible(false);
        initAllModulesPopupMenu();
        initStepmodPartPopupMenu();
        initReleasePopupMenu();
        initFrmwkReleasePopupMenu();
        initFrmwkNewReleasePopupMenu();
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
        treeModel.insertNodeInto(partTreeNode, partTreeRoot, partTreeRoot.getChildCount());
        
        DefaultMutableTreeNode attributesTreeNode = new DefaultMutableTreeNode("Attributes");
        treeModel.insertNodeInto(attributesTreeNode, partTreeNode, partTreeNode.getChildCount());
        
        DefaultMutableTreeNode attributeTreeNode;
        attributeTreeNode = new DefaultMutableTreeNode("Name: " + part.getName());
        treeModel.insertNodeInto(attributeTreeNode, attributesTreeNode, attributesTreeNode.getChildCount());
        
        
        attributeTreeNode = new DefaultMutableTreeNode("Number: " + part.getPartNumber());
        treeModel.insertNodeInto(attributeTreeNode, attributesTreeNode, attributesTreeNode.getChildCount());
        
        DefaultMutableTreeNode dependenciesTreeNode = new DefaultMutableTreeNode("Dependencies");
        treeModel.insertNodeInto(dependenciesTreeNode, partTreeNode, partTreeNode.getChildCount());
        // Note the dependencies tree gets loaded by this updateDependencies(dependenciesTreeNode, stepmodPartTreeNode);
        // This is done whenever the user opens the node therefore a TreeExpansionListener has been added
        
        DefaultMutableTreeNode usedByTreeNode = new DefaultMutableTreeNode("Used by");
        treeModel.insertNodeInto(usedByTreeNode, partTreeNode, partTreeNode.getChildCount());
        this.updateUsedBy(usedByTreeNode);
        
        DefaultMutableTreeNode filesTreeNode = new DefaultMutableTreeNode("Files");
        treeModel.insertNodeInto(filesTreeNode, partTreeNode, partTreeNode.getChildCount());
        this.updateFiles(filesTreeNode);
        
        DefaultMutableTreeNode releasesTreeNode = new DefaultMutableTreeNode("Releases");
        partTreeNode.add(releasesTreeNode);
        
        // Add the development revision - a CmReleaseTreeNode with no CMRelease
        addReleaseToTree(part, null, partTreeNode, false);
        for (Iterator j = part.getCmRecord().getHasCmReleases().iterator(); j.hasNext();) {
            CmRelease cmRelease = (CmRelease) j.next();
            addReleaseToTree(part, cmRelease, partTreeNode, false);
        }
        return (partTreeNode);
    }
    
    private void updateUsedBy(DefaultMutableTreeNode usedByTreeNodes) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) usedByTreeNodes.getParent();
        Object parentUsrObj = parentNode.getUserObject();
        StepmodPart stepmodPart = null;
        TreeSet usedByParts = null;
        
        if (parentUsrObj instanceof StepmodPartTreeNode) {
            StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) parentUsrObj;
            stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
            usedByParts = stepmodPart.getUsedBy();
        } else if (parentUsrObj instanceof CmReleaseTreeNode) {
            // must be dependencies on the release
            CmRelease cmRelease = ((CmReleaseTreeNode)parentUsrObj).getCmRelease();
            stepmodPart = ((CmReleaseTreeNode)parentUsrObj).getStepmodPart();
            usedByParts = stepmodPart.getUsedBy();
        }
        if (usedByParts != null) {
            // test just in case the record has no files - shouldn't happen
            for (Iterator it=usedByParts.iterator(); it.hasNext(); ) {
                StepmodPart part = (StepmodPart)it.next();
                DefaultMutableTreeNode usedByTreeNode = new DefaultMutableTreeNode();
                usedByTreeNode.setUserObject(part);
                treeModel.insertNodeInto(usedByTreeNode, usedByTreeNodes, usedByTreeNode.getChildCount());
            }
        }
    }
    
    private void updateFiles(DefaultMutableTreeNode filesTreeNode) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) filesTreeNode.getParent();
        Object parentUsrObj = parentNode.getUserObject();
        StepmodPart stepmodPart = null;
        TreeMap dependentFiles = null;
        if (parentUsrObj instanceof StepmodPartTreeNode) {
            StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) parentUsrObj;
            stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
            dependentFiles = stepmodPart.getDependentFiles();
        } else if (parentUsrObj instanceof CmReleaseTreeNode) {
            // must be dependencies on the release
            CmRelease cmRelease = ((CmReleaseTreeNode)parentUsrObj).getCmRelease();
            if (cmRelease == null) {
                // No release associated with the cmReleaseTreeNode so
                // must be a development release
                // so use the parts files
                stepmodPart = ((CmReleaseTreeNode)parentUsrObj).getStepmodPart();
                dependentFiles = stepmodPart.getDependentFiles();
            } else {
                dependentFiles = cmRelease.getDependentFiles();
            }
        }
        if (dependentFiles != null) {
            // test just in case the record has no files - shouldn't happen
            for (Iterator it=dependentFiles.entrySet().iterator(); it.hasNext(); ) {
                Map.Entry entry = (Map.Entry)it.next();
                StepmodFile file = (StepmodFile)entry.getValue();
                DefaultMutableTreeNode fileTreeNode = new DefaultMutableTreeNode();
                fileTreeNode.setUserObject(file);
                treeModel.insertNodeInto(fileTreeNode, filesTreeNode, filesTreeNode.getChildCount());
            }
        }
    }
    
    
    private void updateDependencies(DefaultMutableTreeNode dependencyNode, StepmodPartTreeNode stepmodPartNode) {
        // The dependencies may have changed, so first remove any old dependencies
        Object usrObj = dependencyNode.getUserObject();
        StepmodPartTreeNodeCollection dependenciesTreeNodeCollection = null;
        if (usrObj instanceof StepmodPartTreeNodeCollection) {
            dependenciesTreeNodeCollection = (StepmodPartTreeNodeCollection) usrObj;
            DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
            TreeMap treeMap = dependenciesTreeNodeCollection.getHasStepmodPartTreeNodes();
            for (Iterator it=treeMap.entrySet().iterator(); it.hasNext(); ) {
                Map.Entry entry = (Map.Entry)it.next();
                DefaultMutableTreeNode moduleNode = (DefaultMutableTreeNode)entry.getValue();
                treeModel.removeNodeFromParent(moduleNode);
            }
        }
        
        dependenciesTreeNodeCollection
                = new StepmodPartTreeNodeCollection("Dependencies", dependencyNode);
        dependencyNode.setUserObject(dependenciesTreeNodeCollection);
        DefaultMutableTreeNode parentNode = (DefaultMutableTreeNode) dependencyNode.getParent();
        StepmodPart stepmodPart = null;
        //Object parentUsrObj = parentNode.getUserObject();
        stepmodPart = (StepmodPart)stepmodPartNode.getStepmodPart();
        StepmodPartTreeNodeCollection partsCollection = null;
        
        // get all the dependent parts
        //stepmodPart.setupDependencies();
        // draw the dependency tree
        for (Iterator it = stepmodPart.getDependentParts().iterator(); it.hasNext();) {
            String dependentPartName = (String)it.next();
            StepmodPart dependentPart = stepmodPart.getStepMod().getPartByName(dependentPartName);
            this.addRepositoryTreeNode(dependentPart, dependencyNode, dependenciesTreeNodeCollection);
        }
    }
    
    
    /**
     * Initialise the display of the repository tree
     */
    public void initRepositoryTree() {
        DefaultMutableTreeNode rootTreeNode = new DefaultMutableTreeNode(this.getStepMod());
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
        
        DefaultMutableTreeNode basicTreeNode = new DefaultMutableTreeNode("Common files");
        rootTreeNode.add(basicTreeNode);
        addStepmodReleaseToTree(this.getStepMod().getBasicCmRecord(), null, basicTreeNode,false);
        for (Iterator it = getStepMod().getBasicCmRecord().getHasCmReleases().iterator(); it.hasNext();) {
            CmReleaseFrmwk cmRel = (CmReleaseFrmwk) it.next();
            addStepmodReleaseToTree(this.getStepMod().getBasicCmRecord(), cmRel,basicTreeNode,false);
        }
        
        DefaultMutableTreeNode frameworkTreeNode = new DefaultMutableTreeNode("STEPmod Framework");
        rootTreeNode.add(frameworkTreeNode);
        addStepmodReleaseToTree(this.getStepMod().getStepmodCmRecord(), null,frameworkTreeNode,false);
        for (Iterator it = getStepMod().getStepmodCmRecord().getHasCmReleases().iterator(); it.hasNext();) {
            CmReleaseFrmwk cmRel = (CmReleaseFrmwk) it.next();
            addStepmodReleaseToTree(this.getStepMod().getStepmodCmRecord(), cmRel,frameworkTreeNode,false);
        }
        
        repositoryTreeScrollPane.setViewportView(repositoryJTree);
        repositoryJTree.setEditable(true);
        repositoryJTree.setExpandsSelectedPaths(true);
        repositoryJTree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        
        
        // Make sure that the Resource schemas node is visible
        repositoryJTree.makeVisible(new TreePath(resourceSchemasTreeNode.getPath()));
        
        ToolTipManager.sharedInstance().registerComponent(repositoryJTree);
        
        // Set up the renderer that displays the icons in the tree
        RepositoryTreeRenderer renderer = new RepositoryTreeRenderer();
        repositoryJTree.setCellRenderer(renderer);
        RepositoryTreeCellEditor cellEditor = new RepositoryTreeCellEditor(repositoryJTree, renderer);
        repositoryJTree.setCellEditor(cellEditor);
        initRepositoryTreeListeners();
    }
    
    /**
     * Initialise the listeners on the repository tree
     */
    public void initRepositoryTreeListeners() {
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
                } else if (nodeObject instanceof StepmodPartCM) {
                    StepmodPartCM stepmodPartCM = (StepmodPartCM) nodeObject;
                    String summary = stepmodPartCM.summaryHtml();
                    repositoryTextPane.setText(summary);
                    setCurrentDisplayedObject(nodeObject);
                }
            }
        });
        
        // Listen for a tree expansion, then set up the dependencies tree
        // If this is done ahead of time, end up an endless recursive loop
        repositoryJTree.addTreeExpansionListener(new TreeExpansionListener() {
            // Required by TreeExpansionListener interface.
            public void treeExpanded(TreeExpansionEvent e) {
                TreePath path = e.getPath();
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) path.getLastPathComponent();
                Object nodeObject = (Object)node.getUserObject();
                if (nodeObject instanceof StepmodPartTreeNode) {
                    StepmodPartTreeNode stepmodPartNode = (StepmodPartTreeNode) nodeObject;
                    DefaultMutableTreeNode dependenciesNode = (DefaultMutableTreeNode) node.getChildAt(1);
                    updateDependencies(dependenciesNode, stepmodPartNode);
                }
            }
            
            // Required by TreeExpansionListener interface.
            public void treeCollapsed(TreeExpansionEvent e) {}
        });
        
        repositoryJTree.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                JTree tree = (JTree)e.getComponent();
                TreePath path = tree.getClosestPathForLocation(e.getX(), e.getY());
                tree.setSelectionPath(path);
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) path.getLastPathComponent();
                Object nodeObject = (Object)node.getUserObject();
                if (SwingUtilities.isRightMouseButton(e)) {
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
                            createCmReleaseMenuItem.setEnabled(false);
                            createCmReleaseFromTagMenuItem.setEnabled(false);
                        } else if (state == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(false);
                            createCmReleaseMenuItem.setEnabled(true);
                            if (part.isCheckedOutTag()) {
                                createCmReleaseFromTagMenuItem.setEnabled(true);
                            } else {
                                createCmReleaseFromTagMenuItem.setEnabled(false);
                            }
                        } else if (part.getCmRecord().needsCvsAction()) {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(true);
                            createCmReleaseMenuItem.setEnabled(true);
                            if (part.isCheckedOutTag()) {
                            } else {
                                createCmReleaseFromTagMenuItem.setEnabled(false);
                            }
                        } else {
                            createCmRecordMenuItem.setEnabled(false);
                            commitCmRecordMenuItem.setEnabled(false);
                            createCmReleaseMenuItem.setEnabled(true);
                            if (part.isCheckedOutTag()) {
                                createCmReleaseFromTagMenuItem.setEnabled(true);
                            } else {
                                createCmReleaseFromTagMenuItem.setEnabled(false);
                            }
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
                    } else if (nodeObject instanceof CmReleaseFrmwkTreeNode) {
                        frmwkReleasePopupMenu.setUserObject(node);
                        frmwkReleasePopupMenu.show(e.getComponent(), e.getX(), e.getY());
                    } else if (nodeObject instanceof String) {
                        if (nodeObject.equals("Common files")) {
                            frmwkNewReleasePopupMenu.setUserObject(getStepMod().getBasicCmRecord());
                            frmwkNewReleasePopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        } else if (nodeObject.equals("STEPmod Framework")) {
                            frmwkNewReleasePopupMenu.setUserObject(getStepMod().getStepmodCmRecord());
                            frmwkNewReleasePopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        }
                    }
                } else if (SwingUtilities.isLeftMouseButton(e)) {
                    if (nodeObject instanceof CmReleaseFrmwkTreeNode) {
                        CmReleaseFrmwkTreeNode cmReleaseFrmwkTreeNode = (CmReleaseFrmwkTreeNode) nodeObject;
                        CmReleaseFrmwk cmRelease = cmReleaseFrmwkTreeNode.getCmRelease();
                        CmRecordFrmwk cmRecord = cmReleaseFrmwkTreeNode.getCmRecord();
                        String summary = cmRecord.summaryHtml(cmRelease);
                        repositoryTextPane.setText(summary);
                        setCurrentDisplayedObject(nodeObject);
                    } else if (nodeObject instanceof String) {
                        String text = nodeObject.toString();
                        STEPmod stepMod = (STEPmod)((DefaultMutableTreeNode)tree.getModel().getRoot()).getUserObject();
                        if (text.equals("Common files")) {
                            CmRecordFrmwk cmRecordFrmwk = stepMod.getBasicCmRecord();
                            String summary = cmRecordFrmwk.summaryHtml(cmRecordFrmwk.getCheckedOutRelease());
                            repositoryTextPane.setText(summary);
                        } else if (text.equals("STEPmod Framework")) {
                            CmRecordFrmwk cmRecordFrmwk = stepMod.getStepmodCmRecord();
                            String summary = cmRecordFrmwk.summaryHtml(cmRecordFrmwk.getCheckedOutRelease());
                            repositoryTextPane.setText(summary);
                        }
                    }
                }
            }
        });
    }
    
    
    /**
     * Load a repository and display it
     */
    public void loadRepository(File repository) {
        if (getStepMod().isValidStepmodRoot()) {
            // TODO - should add a progress monitor
            output("Loading "+repository);
            repositoryJTree.collapseRow(0);
            // Clear any output being displayed
            setCurrentDisplayedObject(null);
            repositoryTextPane.setText("");
            getStepMod().readRepositoryIndex(repository);
            initRepositoryTree();
        } else {
            warning("The properties have not been set correctly.\n"+"" +
                    "The STEPMODROOT directory does not exist.\n"+
                    "Set the properties in the Tools->Set stepmod properties menu");
        }
    }
    
    /**
     * Load a repository and display it
     */
    public void loadRepository(String repository) {
        loadRepository(new File(repository));
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
    
    private DefaultMutableTreeNode findTopNodeByPrefix(String prefix) {
        DefaultMutableTreeNode rootNode = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        // Iterate thro the top level, modules, resources etc
        for (Enumeration e1=rootNode.children(); e1.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e1.nextElement();
            for (Enumeration e2=n.children(); e2.hasMoreElements(); ) {
                DefaultMutableTreeNode partNode = (DefaultMutableTreeNode)e2.nextElement();
                StepmodPartTreeNode partTreeNode = (StepmodPartTreeNode)partNode.getUserObject();
                StepmodPart part = partTreeNode.getStepmodPart();
                if (part.getPartNumber().startsWith(prefix)) {
                    return(partNode);
                }
            }
        }
        return(null);
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
    
    private void applySelectAllPartsHash(StepmodPartTreeNodeCollection partTreeNodeCollection, boolean selection) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        TreeMap treeMap = partTreeNodeCollection.getHasStepmodPartTreeNodes();
        for (Iterator it=treeMap.entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            DefaultMutableTreeNode moduleNode = (DefaultMutableTreeNode)entry.getValue();
            StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) moduleNode.getUserObject();
            if (selection != stepmodPartTreeNode.isSelected()) {
                // only change state if required
                stepmodPartTreeNode.setSelected(selection);
                treeModel.nodeChanged(moduleNode);
            }
        }
    }
    
    private void applySelectAllParts(DefaultMutableTreeNode root, boolean selection) {
        for (Enumeration e=root.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
            Object userObj = n.getUserObject();
            if (userObj instanceof StepmodPartTreeNodeCollection) {
                StepmodPartTreeNodeCollection partTreeNodeCollection = (StepmodPartTreeNodeCollection) userObj;
                // iterate through the children of the node
                applySelectAllPartsHash(partTreeNodeCollection, selection);
            }
        }
    }
    
    
    private void clearAllSelectedParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        applySelectAllParts(root, false);
    }
    
    
    private void selectAllSelectedParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        applySelectAllParts(root, true);
    }
    
    
    private void applySelectionToSubTree(int childPos, boolean selection) {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        DefaultMutableTreeNode node = (DefaultMutableTreeNode)root.getChildAt(childPos);
        Object userObj = node.getUserObject();
        if (userObj instanceof StepmodPartTreeNodeCollection) {
            StepmodPartTreeNodeCollection partTreeNodeCollection = (StepmodPartTreeNodeCollection) userObj;
            // iterate through the children of the node
            applySelectAllPartsHash(partTreeNodeCollection, selection);
        }
    }
    
    
    private void viewPartsInCollection(DefaultTreeModel treeModel,
            DefaultMutableTreeNode collectionTreeNode, StepmodPartTreeNodeCollection partCollection) {
        // Iterate through all the StepmodPartTreeNode in the collection
        for (Iterator it=partCollection.getHasStepmodPartTreeNodes().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            DefaultMutableTreeNode stepPartNode = (DefaultMutableTreeNode)entry.getValue();
            if (stepPartNode.getParent() != null) {
                // remove the parent then add the node back to ensure that the order is the same as before
                treeModel.removeNodeFromParent(stepPartNode);
            }
            treeModel.insertNodeInto(stepPartNode,collectionTreeNode,collectionTreeNode.getChildCount());
        }
        treeModel.nodeStructureChanged(collectionTreeNode);
        this.updateNode(collectionTreeNode);
    }
    
    
    private void viewAllParts() {
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        // TODO count the child nodes of the module and see if it is the same as the colleciton, then change
        
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
     * Return a list of all the parts that have been selected
     */
    private ArrayList getSelectedParts() {
        ArrayList selectedParts = new ArrayList();
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        for (Enumeration e=root.children(); e.hasMoreElements(); ) {
            DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
            Object usrObj = n.getUserObject();
            if (usrObj instanceof StepmodPartTreeNodeCollection) {
                StepmodPartTreeNodeCollection partCollection = (StepmodPartTreeNodeCollection) usrObj;
                for (Iterator it=partCollection.getHasStepmodPartTreeNodes().entrySet().iterator(); it.hasNext(); ) {
                    Map.Entry entry = (Map.Entry)it.next();
                    DefaultMutableTreeNode stepPartNode = (DefaultMutableTreeNode)entry.getValue();
                    StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) stepPartNode.getUserObject();
                    if (stepmodPartTreeNode.isSelected()) {
                        selectedParts.add(stepmodPartTreeNode.getStepmodPart());
                    }
                }
            }
        }
        return(selectedParts);
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
        createCvsUpdateDevelopmentRevisionMenuItem = new javax.swing.JMenuItem("Checkout development revision");
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
        createCmReleaseMenuItem = new javax.swing.JMenuItem("Create new release");
        createCmReleaseMenuItem.setToolTipText("Creates a new release of the module. The saved record and CVS will only be updated after it has been committed");
        createCmReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                int check = part.okToRelease();
                if (check == StepmodPart.RELEASE_CHECK_ERROR_DEPENDENT_PARTS) {
                    warning("Cannot create a release as a number of the dependent parts are not checked out as releases.\n Check out the released versions");
                    return;
                } else if (check == StepmodPart.RELEASE_CHECK_ERROR_DEVELOPMENT_PART) {
                    warning("Cannot create a release the part is checked out as a release.\nCheck out a development release");
                    return;
                } else {
                    new STEPModMkReleaseDialog(part, node).setVisible(true);
                }
            }
        });
        cvsReleaseSubmenu.add(createCmReleaseMenuItem);
        
        // Make a new release option
        createCmReleaseFromTagMenuItem = new javax.swing.JMenuItem("Convert tagged revision to a release");
        createCmReleaseFromTagMenuItem.setToolTipText("Converts the existing tagged revision into a release. Useful for retrospectively created CM records");
        createCmReleaseFromTagMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) stepmodPartPopupMenu.getUserObject();
                StepmodPart part = ((StepmodPartTreeNode) node.getUserObject()).getStepmodPart();
                boolean check = part.isCheckedOutTag();
                if (!check) {
                    warning("Cannot create a release as the part has not been checked out as a using a tag");
                    return;
                } else {
                    String tag = part.getCvsTag();
                    new STEPModMkReleaseDialog(part, node, tag).setVisible(true);
                }
            }
        });
        cvsReleaseSubmenu.add(createCmReleaseFromTagMenuItem);
        
        
        // Commit CM record option
        //javax.swing.JMenuItem createCmRecordMenuItem;
        createCmRecordMenuItem = new javax.swing.JMenuItem("Create & save CM Record");
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
                StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
                stepmodPart.publicationCreatePackage();
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
                StepmodPartTreeNode stepmodPartTreeNode = (StepmodPartTreeNode) node.getUserObject();
                StepmodPart stepmodPart = stepmodPartTreeNode.getStepmodPart();
                stepmodPart.publicationGenerateHtml();
            }
        });
        cvsPublicationSubmenu.add(genHtmlModulePublicationPackage);
    }
    
    /**
     * Setup the menu called from a mouse click on the part release
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
     * Setup the menu called from a mouse click on the framework release
     */
    private void initFrmwkReleasePopupMenu() {
        // Setup the popoup menu associated with individual modules
        frmwkReleasePopupMenu = new PopupMenuWithObject();
        
        // Checkout a given release
        javax.swing.JMenuItem createCvsCoReleaseMenuItem;
        createCvsCoReleaseMenuItem = new javax.swing.JMenuItem("Checkout specified release");
        createCvsCoReleaseMenuItem.setToolTipText("Checks out a specified release of the module from CVS (Sticky).");
        createCvsCoReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) frmwkReleasePopupMenu.getUserObject();
                CmReleaseFrmwkTreeNode cmReleaseTreeNode = ((CmReleaseFrmwkTreeNode) node.getUserObject());
                CmRecordFrmwk cmRecord = cmReleaseTreeNode.getCmRecord();
                CmReleaseFrmwk cmRelease = cmReleaseTreeNode.getCmRelease();
                cmReleaseTreeNode.getCmRecord().getStepMod().getStepModGui().cvsCoFrmwkRelease(cmRecord, cmRelease);
                getStepMod().getStepModGui().updateNode((DefaultMutableTreeNode)node.getParent());
            }
        });
        frmwkReleasePopupMenu.add(createCvsCoReleaseMenuItem);
    }
    
    /**
     * Setup the menu called from a mouse click on the framework release
     */
    private void initFrmwkNewReleasePopupMenu() {
        // Setup the popoup menu associated with individual modules
        frmwkNewReleasePopupMenu = new PopupMenuWithObject();
        
        
        // Commits the CM record
        javax.swing.JMenuItem commitNewReleaseMenuItem;
        commitNewReleaseMenuItem = new javax.swing.JMenuItem("Commit CM record");
        commitNewReleaseMenuItem.setToolTipText("Commits the CM record.");
        commitNewReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CmRecordFrmwk cmRecord = (CmRecordFrmwk) frmwkNewReleasePopupMenu.getUserObject();
                cmRecord.getStepMod().getStepModGui().cvsComitFrmwkRecord(cmRecord);
            }
        });
        frmwkNewReleasePopupMenu.add(commitNewReleaseMenuItem);
        
        // Create a new release
        javax.swing.JMenuItem createNewReleaseMenuItem;
        createNewReleaseMenuItem = new javax.swing.JMenuItem("Create a new release");
        createNewReleaseMenuItem.setToolTipText("Creates a new release from the checkout files.");
        createNewReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CmRecordFrmwk cmRecord = (CmRecordFrmwk) frmwkNewReleasePopupMenu.getUserObject();
                //int check = cmRecord.okToRelease();
                String title;
                if (cmRecord.getStepMod().getBasicCmRecord() == cmRecord) {
                    title = "Create a new release for all common files";
                } else {
                    title = "Create a new release for all XSL framework";
                }
                new STEPModMkFrmwkReleaseDialog(cmRecord.getStepMod().getStepModGui(), title, cmRecord).setVisible(true);
            }
        });
        frmwkNewReleasePopupMenu.add(createNewReleaseMenuItem);
        
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
        // Use the tree model to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        // Find the release nodes - always the last one
        DefaultMutableTreeNode releasesNode = (DefaultMutableTreeNode) stepPartNode.getLastChild();
        DefaultMutableTreeNode releaseNode;
        if (cmRelease == null) {
            releaseNode = new DefaultMutableTreeNode(new CmReleaseTreeNode(part, "Development revision", false));
            //releaseNode = new DefaultMutableTreeNode("Development revision");
            treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
        } else {
            releaseNode = new DefaultMutableTreeNode(new CmReleaseTreeNode(part, cmRelease, false));
            treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
            
            DefaultMutableTreeNode filesTreeNode = new DefaultMutableTreeNode("Files");
            treeModel.insertNodeInto(filesTreeNode, releaseNode, releaseNode.getChildCount());
            this.updateFiles(filesTreeNode);
            
            DefaultMutableTreeNode dependencyNode = new DefaultMutableTreeNode("Dependencies");
            treeModel.insertNodeInto(dependencyNode, releaseNode, releaseNode.getChildCount());
            // Add the released parts
            for (Iterator it = cmRelease.getDependentParts().iterator(); it.hasNext();) {
                StepmodPartCM dependentPart = (StepmodPartCM)it.next();
                DefaultMutableTreeNode dependentPartTreeNode = new DefaultMutableTreeNode();
                dependentPartTreeNode.setUserObject(dependentPart);
                treeModel.insertNodeInto(dependentPartTreeNode, dependencyNode, dependencyNode.getChildCount());
            }
            
            //Make sure the user can see the lovely new node.
            treeModel.nodeStructureChanged(releasesNode.getParent());
            //treeModel.nodeChanged(releasesNode.getParent());
            if (shouldBeVisible) {
                TreePath path = new TreePath(releaseNode.getPath());
                repositoryJTree.expandPath(path);
                repositoryJTree.setSelectionPath(path);
                repositoryJTree.scrollPathToVisible(path);
            }
        }
    }
    
    
    public void updateReleaseStatus(StepmodPart part, CmRelease cmRelease, String status, String description, DefaultMutableTreeNode repoTreeNode, boolean shouldBeVisible) {
        cmRelease.setReleaseStatus(status, true);
        cmRelease.setDescription(description);
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        treeModel.nodeChanged(repoTreeNode);
    }
    
    
    /**
     * Add the release to the tree node of releases for a Stepmod
     */
    public void addStepmodReleaseToTree(CmRecordFrmwk cmRecord, CmReleaseFrmwk cmRelease, DefaultMutableTreeNode releasesNode, boolean shouldBeVisible) {
        // Use the tree model to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        DefaultMutableTreeNode releaseNode;
        if (cmRelease == null) {
            releaseNode = new DefaultMutableTreeNode(new CmReleaseFrmwkTreeNode(cmRecord, "Development revision", false));
            treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
        } else {
            releaseNode = new DefaultMutableTreeNode(new CmReleaseFrmwkTreeNode(cmRecord, cmRelease, false));
            treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
            
            //Make sure the user can see the lovely new node.
            treeModel.nodeStructureChanged(releasesNode.getParent());
            //treeModel.nodeChanged(releasesNode.getParent());
            if (shouldBeVisible) {
                TreePath path = new TreePath(releaseNode.getPath());
                repositoryJTree.expandPath(path);
                repositoryJTree.setSelectionPath(path);
                repositoryJTree.scrollPathToVisible(path);
            }
        }
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
    
    public JTree getRepositoryJTree() {
        return(repositoryJTree);
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
    
    public DefaultMutableTreeNode getNodeForPart(StepmodPart part) {
        if (part instanceof StepmodModule) {
            return(getModulesTreeNodeCollection().getNodeForPart(part));
        } else if (part instanceof StepmodApplicationProtocol) {
            return(getApTreeNodeCollection().getNodeForPart(part));
        } else if (part instanceof StepmodResourceDoc) {
            return(getResourceDocsTreeNodeCollection().getNodeForPart(part));
        } else if (part instanceof StepmodResource) {
            return(getSchemasTreeNodeCollection().getNodeForPart(part));
        }
        return(null);
    }
    
    
    
    private void deleteCmRelease(StepmodPart part, DefaultMutableTreeNode node, CmRelease cmRelease) {
        int answer = JOptionPane.showConfirmDialog(this,
                "You are about to delete the release "+cmRelease.getId()+"\nDo you want to continue?",
                "CM release action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            // Remove tag from CVS
            StepmodCvs stepmodCvs = part.cvsDeleteTag(cmRelease.getId());
            outputCvsResults(stepmodCvs);
            if (stepmodCvs.getCvsErrorVal() == 0) {
                CmRecord cmRecord = part.getCmRecord();
                // successfully tagged the part, so delete the record
                // Delete the release
                cmRecord.deleteCmRelease(cmRelease);
                // Now delete the release from the tree
                DefaultTreeModel model = (DefaultTreeModel)repositoryJTree.getModel();
                model.removeNodeFromParent(node);
                // sucessfully deleted the tag, so save the record
                cmRecord.writeCmRecord();
            } else {
                JOptionPane.showMessageDialog(this,"CVS delete tag action failed.","CVS action ....",JOptionPane.WARNING_MESSAGE);
            }
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
                    "Do you want to check out the CM record for "+part.getName()+" to CVS?",
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
    
    
    private void cvsCoFrmwkRelease(CmRecordFrmwk cmRecord, CmReleaseFrmwk cmRelease) {
        if (cmRelease == null) {
            // checkout the development revision
            int answer = JOptionPane.showConfirmDialog(this,
                    "Do you want to check out the development release?",
                    "CVS action ....",
                    JOptionPane.YES_NO_OPTION);
            if (answer == JOptionPane.YES_OPTION) {
                StepmodCvs stepmodCvs = cmRecord.cvsUpdate();
                outputCvsResults(stepmodCvs);
            }
        } else {
            int answer = JOptionPane.showConfirmDialog(this,
                    "Do you want to check out the release " +cmRelease.getId() +"?",
                    "CVS action ....",
                    JOptionPane.YES_NO_OPTION);
            if (answer == JOptionPane.YES_OPTION) {
                StepmodCvs stepmodCvs = cmRecord.cvsCoRelease(cmRelease);
                outputCvsResults(stepmodCvs);
            }
        }
    }
    
    
    
    private void cvsComitFrmwkRecord(CmRecordFrmwk cmRecord) {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to commit the CM record to CVS?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            StepmodCvs stepmodCvs = cmRecord.cvsCommitRecord();
            outputCvsResults(stepmodCvs);
        }
    }
    
    /**
     * Run a cvs update on stepmod/config_management
     */
    private void cvsUpdateConfigManagement() {
        int answer = JOptionPane.showConfirmDialog(this,
                "Do you want to run a CVS update on stepmod/config_management?",
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            StepmodCvs stepmodCvs = getStepMod().cvsUpdateConfigManagement();
            outputCvsResults(stepmodCvs);
        }
    }
    
    public void outputCvsResults(StepmodCvs stepmodCvs) {
        output("********* CVS ***********");
        output("Executing in directory " + stepmodCvs.getCvsExecDirectory());
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
                "CVS action ....",
                JOptionPane.YES_NO_OPTION);
        if (answer == JOptionPane.YES_OPTION) {
            part.getCmRecord().writeCmRecord();
            updateNode(part);
        }
    }
    
    
    public Object getCurrentDisplayedObject() {
        return currentDisplayedObject;
    }
    
    public void setCurrentDisplayedObject(Object currentDisplayedObject) {
        this.currentDisplayedObject = currentDisplayedObject;
    }
    
    
    public static void openURLinBrowser(String url) {
        String osName = System.getProperty("os.name");
        try {
            if (osName.startsWith("Mac OS")) {
                Class fileMgr = Class.forName("com.apple.eio.FileManager");
                Method openURL = fileMgr.getDeclaredMethod("openURL",
                        new Class[] {String.class});
                openURL.invoke(null, new Object[] {url});
            } else if (osName.startsWith("Windows"))
                Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
            else { //assume Unix or Linux
                String[] browsers = {
                    "firefox", "opera", "konqueror", "epiphany", "mozilla", "netscape" };
                String browser = null;
                for (int count = 0; count < browsers.length && browser == null; count++)
                    if (Runtime.getRuntime().exec(
                        new String[] {"which", browsers[count]}).waitFor() == 0)
                        browser = browsers[count];
                if (browser == null)
                    throw new Exception("Could not find web browser");
                else
                    Runtime.getRuntime().exec(new String[] {browser, url});
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error attempting to launch web browser:\n" + e.getLocalizedMessage());
        }
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
        stepmodPanel = new javax.swing.JPanel();
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
        cvsUpdateCMMenuItem = new javax.swing.JMenuItem();
        loadRepositoryMenuItem = new javax.swing.JMenuItem();
        reloadRepositoryIndexMenuItem = new javax.swing.JMenuItem();
        selectAndLoadRepositoryMenuItem = new javax.swing.JMenuItem();
        exitMenuItem = new javax.swing.JMenuItem();
        viewMenu = new javax.swing.JMenu();
        viewSelectedMenuItem = new javax.swing.JMenuItem();
        vewAllMenuItem = new javax.swing.JMenuItem();
        selectedMenu = new javax.swing.JMenu();
        selSelectionMenu = new javax.swing.JMenu();
        selectAllMenuItem = new javax.swing.JMenuItem();
        selectAllModulesMenuItem = new javax.swing.JMenuItem();
        selectAllResMenuItem = new javax.swing.JMenuItem();
        selectAllApsMenuItem = new javax.swing.JMenuItem();
        selectAllResDocsMenuItem = new javax.swing.JMenuItem();
        selUnselectionjMenu = new javax.swing.JMenu();
        unselectAllMenuItem = new javax.swing.JMenuItem();
        unselectAllModulesMenuItem = new javax.swing.JMenuItem();
        unselectAllResMenuItem = new javax.swing.JMenuItem();
        unselectAllApsMenuItem = new javax.swing.JMenuItem();
        unselectAllResDocsMenuItem = new javax.swing.JMenuItem();
        cvsPartjMenu = new javax.swing.JMenu();
        selUpdateReleaseMenuItem = new javax.swing.JMenuItem();
        selLatestReleaseMenuItem = new javax.swing.JMenuItem();
        selPublishedReleaseMenuItem = new javax.swing.JMenuItem();
        selCmRecordjMenu = new javax.swing.JMenu();
        selCommitMenuItem = new javax.swing.JMenuItem();
        selReleaseMenu = new javax.swing.JMenu();
        selRelMenuItem = new javax.swing.JMenuItem();
        selEditMenuItem = new javax.swing.JMenuItem();
        selCreateCmReleaseFromTagMenuItem = new javax.swing.JMenuItem();
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
        stepmodPanel.setLayout(new java.awt.BorderLayout());

        stepmodPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("STEPmod Repository"));
        stepmodPanel.setMinimumSize(new java.awt.Dimension(0, 0));
        stepmodPanel.setPreferredSize(new java.awt.Dimension(150, 200));
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
        viewSelectedToggleButton.setToolTipText("View the selected parts");
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

        stepmodPanel.add(jToolBar1, java.awt.BorderLayout.NORTH);

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

        stepmodPanel.add(repositorySplitPane, java.awt.BorderLayout.CENTER);

        stepmodMainSplitPane.setLeftComponent(stepmodPanel);

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
        cvsUpdateCMMenuItem.setText("CVS update CM records");
        cvsUpdateCMMenuItem.setToolTipText("Run a CVS update on all CM records in stepmod/config_management");
        cvsUpdateCMMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cvsUpdateCMMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(cvsUpdateCMMenuItem);

        loadRepositoryMenuItem.setText("Load default repository_index.xml");
        loadRepositoryMenuItem.setToolTipText("loads all the parts identified in the repository indexL");
        loadRepositoryMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadRepositoryMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(loadRepositoryMenuItem);

        reloadRepositoryIndexMenuItem.setText("Reload current repsoitory_index.xml ");
        reloadRepositoryIndexMenuItem.setToolTipText("Reload the repository index that was previously loaded");
        reloadRepositoryIndexMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                reloadRepositoryIndexMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(reloadRepositoryIndexMenuItem);

        selectAndLoadRepositoryMenuItem.setText("Load repository_index.xml");
        selectAndLoadRepositoryMenuItem.setToolTipText("Select a repository index and load it");
        selectAndLoadRepositoryMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAndLoadRepositoryMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(selectAndLoadRepositoryMenuItem);

        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(exitMenuItem);

        menuBar.add(fileMenu);

        viewMenu.setText("View");
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

        selectedMenu.setText("Selected");
        selectedMenu.setToolTipText("Acions that are applied to selected parts");
        selSelectionMenu.setText("Select parts");
        selSelectionMenu.setToolTipText("");
        selectAllMenuItem.setText("Select all");
        selectAllMenuItem.setToolTipText("Select all the parts");
        selectAllMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAllMenuItemActionPerformed(evt);
            }
        });

        selSelectionMenu.add(selectAllMenuItem);

        selectAllModulesMenuItem.setText("Select all modules");
        selectAllModulesMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAllModulesMenuItemActionPerformed(evt);
            }
        });

        selSelectionMenu.add(selectAllModulesMenuItem);

        selectAllResMenuItem.setText("Select all resource schemas");
        selectAllResMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAllResMenuItemActionPerformed(evt);
            }
        });

        selSelectionMenu.add(selectAllResMenuItem);

        selectAllApsMenuItem.setText("Select all application protocols");
        selectAllApsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAllApsMenuItemActionPerformed(evt);
            }
        });

        selSelectionMenu.add(selectAllApsMenuItem);

        selectAllResDocsMenuItem.setText("Select all resource documents");
        selectAllResDocsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectAllResDocsMenuItemActionPerformed(evt);
            }
        });

        selSelectionMenu.add(selectAllResDocsMenuItem);

        selectedMenu.add(selSelectionMenu);

        selUnselectionjMenu.setText("Unselect parts");
        unselectAllMenuItem.setText("Unselect all");
        unselectAllMenuItem.setToolTipText("Unselect allparts currently selected ");
        unselectAllMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                unselectAllMenuItemActionPerformed(evt);
            }
        });

        selUnselectionjMenu.add(unselectAllMenuItem);

        unselectAllModulesMenuItem.setText("Unselect all modules");
        unselectAllModulesMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                unselectAllModulesMenuItemActionPerformed(evt);
            }
        });

        selUnselectionjMenu.add(unselectAllModulesMenuItem);

        unselectAllResMenuItem.setText("Unselect all resource schemas");
        unselectAllResMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                unselectAllResMenuItemActionPerformed(evt);
            }
        });

        selUnselectionjMenu.add(unselectAllResMenuItem);

        unselectAllApsMenuItem.setText("Unselect all application protocols");
        unselectAllApsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                unselectAllApsMenuItemActionPerformed(evt);
            }
        });

        selUnselectionjMenu.add(unselectAllApsMenuItem);

        unselectAllResDocsMenuItem.setText("Unselect all resource documents");
        unselectAllResDocsMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                unselectAllResDocsMenuItemActionPerformed(evt);
            }
        });

        selUnselectionjMenu.add(unselectAllResDocsMenuItem);

        selectedMenu.add(selUnselectionjMenu);

        cvsPartjMenu.setText("CVS - Part");
        cvsPartjMenu.setToolTipText("CVS actions on selected parts");
        selUpdateReleaseMenuItem.setText("Update development release of selected parts");
        selUpdateReleaseMenuItem.setToolTipText("Checks out the development release of the selected parts");
        selUpdateReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selUpdateReleaseMenuItemActionPerformed(evt);
            }
        });

        cvsPartjMenu.add(selUpdateReleaseMenuItem);

        selLatestReleaseMenuItem.setText("Checkout latest release for selected parts");
        selLatestReleaseMenuItem.setToolTipText("Checkout latest release of the selected parts");
        selLatestReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selLatestReleaseMenuItemActionPerformed(evt);
            }
        });

        cvsPartjMenu.add(selLatestReleaseMenuItem);

        selPublishedReleaseMenuItem.setText("Checkout published releases for selected parts");
        selPublishedReleaseMenuItem.setToolTipText("Checkout published releases for the selected parst");
        selPublishedReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selPublishedReleaseMenuItemActionPerformed(evt);
            }
        });

        cvsPartjMenu.add(selPublishedReleaseMenuItem);

        selectedMenu.add(cvsPartjMenu);

        selCmRecordjMenu.setText("CM record");
        selCmRecordjMenu.setToolTipText("Actions of teh CM records of the selected parts");
        selCommitMenuItem.setText("Create & Commit CM records for selected parts");
        selCommitMenuItem.setToolTipText("For each selected part, create a CM record if it does not exist, commit CM records to CVS if not already committed ");
        selCommitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selCommitMenuItemActionPerformed(evt);
            }
        });

        selCmRecordjMenu.add(selCommitMenuItem);

        selectedMenu.add(selCmRecordjMenu);

        selReleaseMenu.setText("Release");
        selReleaseMenu.setToolTipText("Actions on the releases of the selected parts");
        selRelMenuItem.setText("Release selected parts");
        selRelMenuItem.setToolTipText("Create releases for each selected part");
        selRelMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selRelMenuItemActionPerformed(evt);
            }
        });

        selReleaseMenu.add(selRelMenuItem);

        selEditMenuItem.setText("Change status of release of selected parts");
        selEditMenuItem.setToolTipText("Change the status of the current release of selected parts");
        selEditMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selEditMenuItemActionPerformed(evt);
            }
        });

        selReleaseMenu.add(selEditMenuItem);

        selCreateCmReleaseFromTagMenuItem.setText("Convert tagged revisions of selected parts to a release");
        selCreateCmReleaseFromTagMenuItem.setToolTipText("Converts the existing tagged revision of selected parts into a release. Useful for retrospectively created CM records\"");
        selCreateCmReleaseFromTagMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selCreateCmReleaseFromTagMenuItemActionPerformed(evt);
            }
        });

        selReleaseMenu.add(selCreateCmReleaseFromTagMenuItem);

        selectedMenu.add(selReleaseMenu);

        menuBar.add(selectedMenu);

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
    
    private void selCreateCmReleaseFromTagMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selCreateCmReleaseFromTagMenuItemActionPerformed
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            // tag each selected part
            StepmodPart part = (StepmodPart) it.next();
            DefaultMutableTreeNode node = findNodeByPart(root, part);
            boolean check = part.isCheckedOutTag();
            if (!check) {
                warning("Cannot create a release as the part "+ part +" has not been checked out a using a tag");
            } else {
                String tag = part.getCvsTag();
                new STEPModMkReleaseDialog(part, node, tag).setVisible(true);
            }
        }
    }//GEN-LAST:event_selCreateCmReleaseFromTagMenuItemActionPerformed
    
    private void unselectAllResMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_unselectAllResMenuItemActionPerformed
        applySelectionToSubTree(3, false);
    }//GEN-LAST:event_unselectAllResMenuItemActionPerformed
    
    private void selectAllResMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAllResMenuItemActionPerformed
        applySelectionToSubTree(3, true);
    }//GEN-LAST:event_selectAllResMenuItemActionPerformed
    
    private void unselectAllResDocsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_unselectAllResDocsMenuItemActionPerformed
        applySelectionToSubTree(2, false);
    }//GEN-LAST:event_unselectAllResDocsMenuItemActionPerformed
    
    private void selectAllResDocsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAllResDocsMenuItemActionPerformed
        applySelectionToSubTree(2, true);
    }//GEN-LAST:event_selectAllResDocsMenuItemActionPerformed
    
    private void unselectAllApsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_unselectAllApsMenuItemActionPerformed
        applySelectionToSubTree(1, false);
    }//GEN-LAST:event_unselectAllApsMenuItemActionPerformed
    
    private void selectAllApsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAllApsMenuItemActionPerformed
        applySelectionToSubTree(1, true);
    }//GEN-LAST:event_selectAllApsMenuItemActionPerformed
    
    private void unselectAllModulesMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_unselectAllModulesMenuItemActionPerformed
        applySelectionToSubTree(0, false);
    }//GEN-LAST:event_unselectAllModulesMenuItemActionPerformed
    
    private void selectAllModulesMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAllModulesMenuItemActionPerformed
        applySelectionToSubTree(0, true);
    }//GEN-LAST:event_selectAllModulesMenuItemActionPerformed
    
    private void selectAllMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAllMenuItemActionPerformed
        selectAllSelectedParts();
    }//GEN-LAST:event_selectAllMenuItemActionPerformed
    
    private void cvsUpdateCMMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cvsUpdateCMMenuItemActionPerformed
        cvsUpdateConfigManagement();
    }//GEN-LAST:event_cvsUpdateCMMenuItemActionPerformed
    
    private void selPublishedReleaseMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selPublishedReleaseMenuItemActionPerformed
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            StepmodPart part = (StepmodPart) it.next();
            cvsCoPublishedRelease(part);
        }
    }//GEN-LAST:event_selPublishedReleaseMenuItemActionPerformed
    
    private void selLatestReleaseMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selLatestReleaseMenuItemActionPerformed
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            StepmodPart part = (StepmodPart) it.next();
            cvsCoLatestRelease(part);
        }
    }//GEN-LAST:event_selLatestReleaseMenuItemActionPerformed
    
    private void selUpdateReleaseMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selUpdateReleaseMenuItemActionPerformed
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            StepmodPart part = (StepmodPart) it.next();
            cvsUpdate(part);
        }
    }//GEN-LAST:event_selUpdateReleaseMenuItemActionPerformed
    
    private void selCommitMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selCommitMenuItemActionPerformed
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            StepmodPart part = (StepmodPart) it.next();
            CmRecord cmRecord = part.getCmRecord();
            int cvsStatus = cmRecord.getCmRecordCvsStatus();
            if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                writeCmRecord(part);
                cvsCommitRecord(part);
            } else if (cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) {
                cvsCommitRecord(part);
            } else if (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED) {
                cvsCommitRecord(part);
            } else if (cvsStatus == CmRecord.CM_RECORD_CVS_CHANGED) {
                cvsCommitRecord(part);
            } else if (cmRecord.getRecordState() == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
                cvsCommitRecord(part);
            }
        }
    }//GEN-LAST:event_selCommitMenuItemActionPerformed
    
    private void selEditMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selEditMenuItemActionPerformed
        for (Iterator it = getSelectedParts().iterator(); it.hasNext();) {
            // tag each selected part
            StepmodPart part = (StepmodPart) it.next();
            int cvsStatus = part.getCmRecord().getCmRecordCvsStatus();
            if (cvsStatus == CmRecord.CM_RECORD_FILE_NOT_EXIST) {
                warning("The CM record file, cm_record.xml, does not exist for the part\""+part+"\"");
                return;
            } else if (cvsStatus == CmRecord.CM_RECORD_CVS_NOT_ADDED) {
                warning("The CM record file, cm_record.xml, for part\""+part+"\" exists but has not been added to CVS");
                return;
            } else if (cvsStatus == CmRecord.CM_RECORD_CVS_DIR_NOT_ADDED) {
                warning("The CM record file, cm_record.xml, for part\""+part+"\" exists but the record directory has not been added to CVS");
                return;
            } else if (part.isCheckedOutDevelopment()) {
                // error
                warning("The part \""+part+"\" is not a released version");
                return;
            }
        }
        new STEPModMkReleaseSetDialog(this, getSelectedParts(), false).setVisible(true);
    }//GEN-LAST:event_selEditMenuItemActionPerformed
    
    private void selRelMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selRelMenuItemActionPerformed
        new STEPModMkReleaseSetDialog(this, getSelectedParts(), true).setVisible(true);
    }//GEN-LAST:event_selRelMenuItemActionPerformed
    
    private void reloadRepositoryIndexMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_reloadRepositoryIndexMenuItemActionPerformed
        if (getStepMod().isValidStepmodRoot()) {
            File currentRepo = getStepMod().getCurrentRepositoryIndex();
            if (currentRepo != null) {
                int answer = JOptionPane.showConfirmDialog(this,
                        "You are about to reload the repository_index\n"+currentRepo+"\nDo you want to continue?",
                        "Loading repository_index.xml ....",
                        JOptionPane.YES_NO_OPTION);
                if (answer == JOptionPane.YES_OPTION) {
                    loadRepository(currentRepo);
                }
            } else {
                JOptionPane.showMessageDialog(this,"No repository loaded","Error ....", JOptionPane.OK_OPTION);
            }
        } else {
            warning("The properties have not been set correctly.\n"+"" +
                    "The STEPMODROOT directory does not exist.\n"+
                    "Set the properties in the Tools->Set stepmod properties menu");
        }
    }//GEN-LAST:event_reloadRepositoryIndexMenuItemActionPerformed
    
    private void selectAndLoadRepositoryMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectAndLoadRepositoryMenuItemActionPerformed
        if (getStepMod().isValidStepmodRoot()) {
            File repoFile = getStepMod().getCurrentRepositoryIndex();
            if (repoFile == null) {
                repoFile = new File(getStepMod().getStepmodProperty("STEPMODROOT") + "/repository_index.xml");
            }
            JFileChooser fileChooser = new JFileChooser(repoFile);
            fileChooser.setSelectedFile(repoFile);
            int result = fileChooser.showOpenDialog(this);
            // Determine which button was clicked to close the dialog
            if (result == JFileChooser.APPROVE_OPTION) {
                // Approve (Open or Save) was clicked
                File selectedFile = fileChooser.getSelectedFile();
                loadRepository(selectedFile);
            }
        } else {
            warning("The properties have not been set correctly.\n"+"" +
                    "The STEPMODROOT directory does not exist.\n"+
                    "Set the properties in the Tools->Set stepmod properties menu");
        }
    }//GEN-LAST:event_selectAndLoadRepositoryMenuItemActionPerformed
    
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
    
    private void unselectAllMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_unselectAllMenuItemActionPerformed
        clearAllSelectedParts();
    }//GEN-LAST:event_unselectAllMenuItemActionPerformed
    
    private void clearSelectedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearSelectedButtonActionPerformed
        clearAllSelectedParts();
    }//GEN-LAST:event_clearSelectedButtonActionPerformed
    
    private void loadRepositoryMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadRepositoryMenuItemActionPerformed
        if (getStepMod().isValidStepmodRoot()) {
            String currentRepo = getStepMod().getStepmodProperty("STEPMODROOT")+"/repository_index.xml";
            int answer = JOptionPane.showConfirmDialog(this,
                    "You are about to load the repository_index\n "+currentRepo+"\nThis will overwrite everything already loaded.\n\nDo you want to continue?",
                    "Loading repository_index.xml ....",
                    JOptionPane.YES_NO_OPTION);
            if (answer == JOptionPane.YES_OPTION) {
                loadRepository(currentRepo);
            }
        } else {
            warning("The properties have not been set correctly.\n"+"" +
                    "The STEPMODROOT directory does not exist.\n"+
                    "Set the properties in the Tools->Set stepmod properties menu");
        }
    }//GEN-LAST:event_loadRepositoryMenuItemActionPerformed
    
    private void viewAllButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_viewAllButtonActionPerformed
        viewAllParts();
    }//GEN-LAST:event_viewAllButtonActionPerformed
    
    private void findPartjTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_findPartjTextFieldActionPerformed
        String part = findPartjTextField.getText();
        DefaultMutableTreeNode root = (DefaultMutableTreeNode)repositoryJTree.getModel().getRoot();
        // Find the node for the part
        //DefaultMutableTreeNode node = this.findNodeByPrefix(root, part);
        DefaultMutableTreeNode node = this.findTopNodeByPrefix(part);
        if (node != null) {
            TreePath path = new TreePath(node.getPath());
            repositoryJTree.expandPath(path);
            repositoryJTree.setSelectionPath(path);
            repositoryJTree.scrollPathToVisible(path);
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
        displayAbout();
    }//GEN-LAST:event_aboutMenuItemActionPerformed
    
    private void contentsMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_contentsMenuItemActionPerformed
        // This seems a bit of a hack to get the lcoation of the help directory relative to the jar file
        // Get the location of this class
        Class cls = this.getClass();
        ProtectionDomain pDomain = cls.getProtectionDomain();
        CodeSource cSource = pDomain.getCodeSource();
        String path = cSource.getLocation().getPath();
        System.out.println("p: "+path);
        path = "file:"+path.substring(0, path.length()-12) + "/help/index.html";
        System.out.println("Opening: "+path);
        openURLinBrowser(path);
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
    
    private void displayAbout() {
        String aboutStr="Developed by Eurostep (http://www.eurostep.com) under contract to NIST and ATI\n";
        aboutStr += "Build number: = "+ getStepMod().getBuildNumber();
        JOptionPane.showMessageDialog(this,
                aboutStr,
                "STEPmod CM tool",
                JOptionPane.INFORMATION_MESSAGE);
    }
    
    
    
    
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem aboutMenuItem;
    private javax.swing.JMenuItem clearOutputMenuItem;
    private javax.swing.JButton clearSelectedButton;
    private javax.swing.JMenuItem contentsMenuItem;
    private javax.swing.JMenu cvsPartjMenu;
    private javax.swing.JMenuItem cvsUpdateCMMenuItem;
    private javax.swing.JMenuItem exitMenuItem;
    private javax.swing.JMenu fileMenu;
    private javax.swing.JTextField findPartjTextField;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JMenuItem loadRepositoryMenuItem;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JMenuItem mkApMenuItem;
    private javax.swing.JMenuItem mkModuleMenuItem;
    private javax.swing.JMenuItem mkdResDocMenuItem;
    private javax.swing.JPopupMenu outputPopupMenu;
    private javax.swing.JMenuItem reloadRepositoryIndexMenuItem;
    private javax.swing.JTree repositoryJTree;
    private javax.swing.JScrollPane repositoryScrollPane;
    private javax.swing.JSplitPane repositorySplitPane;
    private javax.swing.JTextPane repositoryTextPane;
    private javax.swing.JScrollPane repositoryTreeScrollPane;
    private javax.swing.JMenu selCmRecordjMenu;
    private javax.swing.JMenuItem selCommitMenuItem;
    private javax.swing.JMenuItem selCreateCmReleaseFromTagMenuItem;
    private javax.swing.JMenuItem selEditMenuItem;
    private javax.swing.JMenuItem selLatestReleaseMenuItem;
    private javax.swing.JMenuItem selPublishedReleaseMenuItem;
    private javax.swing.JMenuItem selRelMenuItem;
    private javax.swing.JMenu selReleaseMenu;
    private javax.swing.JMenu selSelectionMenu;
    private javax.swing.JMenu selUnselectionjMenu;
    private javax.swing.JMenuItem selUpdateReleaseMenuItem;
    private javax.swing.JMenuItem selectAllApsMenuItem;
    private javax.swing.JMenuItem selectAllMenuItem;
    private javax.swing.JMenuItem selectAllModulesMenuItem;
    private javax.swing.JMenuItem selectAllResDocsMenuItem;
    private javax.swing.JMenuItem selectAllResMenuItem;
    private javax.swing.JMenuItem selectAndLoadRepositoryMenuItem;
    private javax.swing.JMenu selectedMenu;
    private javax.swing.JMenuItem setStepModProps;
    private javax.swing.JPanel stepModOutputPanel;
    private javax.swing.JScrollPane stepModOutputScrollPane;
    private javax.swing.JTextArea stepModOutputTextArea;
    private javax.swing.JSplitPane stepmodMainSplitPane;
    private javax.swing.JPanel stepmodPanel;
    private javax.swing.JMenuItem testCVSMenuItem;
    private javax.swing.JMenu toolsMenu;
    private javax.swing.JMenuItem unselectAllApsMenuItem;
    private javax.swing.JMenuItem unselectAllMenuItem;
    private javax.swing.JMenuItem unselectAllModulesMenuItem;
    private javax.swing.JMenuItem unselectAllResDocsMenuItem;
    private javax.swing.JMenuItem unselectAllResMenuItem;
    private javax.swing.JMenuItem vewAllMenuItem;
    private javax.swing.JButton viewAllButton;
    private javax.swing.JMenu viewMenu;
    private javax.swing.JMenuItem viewSelectedMenuItem;
    private javax.swing.JToggleButton viewSelectedToggleButton;
    // End of variables declaration//GEN-END:variables
    
    
    
}
