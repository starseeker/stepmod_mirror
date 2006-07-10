/*
 * STEPModFrame.java
 *
 * Created on 24 April 2006, 09:07
 *
 */

package org.stepmod.gui;

import java.awt.Color;
import java.awt.Component;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Iterator;
import java.util.Map;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import javax.swing.JSeparator;
import javax.swing.JTree;
import javax.swing.SwingUtilities;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;
import org.stepmod.CmRecord;
import org.stepmod.CmRelease;
import org.stepmod.STEPmod;
import org.stepmod.StepmodApplicationProtocol;
import org.stepmod.StepmodModule;
import org.stepmod.StepmodPart;
import org.stepmod.StepmodResource;
import org.stepmod.StepmodResourceDoc;
import org.stepmod.cvschk.StepmodCvs;

/**
 *
 * @author  Rob Bodington
 */
public class STEPModFrame extends javax.swing.JFrame {
    
    /**
     * The popup menu associated with a module in the module tree
     */
    private PopupMenuWithObject modulePopupMenu;
    
    /**
     * The popup menu associated with teh list of modules n the module tree
     */
    private PopupMenuWithObject allModulesPopupMenu;
    
    /**
     * The STEPmod object that this is the GUI for.
     */
    private STEPmod stepMod;
    
    
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
     * Cell renderer for the STEPmod repository tree
     */
    private class RepositoryTreeRenderer extends DefaultTreeCellRenderer {
        Icon publishedIcon;
        Icon releasedIcon;
        Icon developmentIcon;
        
        public RepositoryTreeRenderer() {
            java.net.URL publishedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/bullet_go.png");
            publishedIcon = null;
            if (publishedIconURL != null) {
                publishedIcon= new ImageIcon(publishedIconURL);
            }
            java.net.URL releasedIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/bullet_key.png");
            releasedIcon = null;
            if (releasedIconURL != null) {
                releasedIcon= new ImageIcon(releasedIconURL);
            }
            java.net.URL developmentIconURL = STEPModFrame.class.getResource("/org/stepmod/resources/bullet_wrench.png");
            developmentIcon = null;
            if (developmentIconURL != null) {
                developmentIcon= new ImageIcon(developmentIconURL);
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
                if (userNode instanceof StepmodModule) {
                    StepmodModule moduleNode = (StepmodModule) userNode;
                    // Need to get the state
                    if (moduleNode.getCvsState() == StepmodPart.CVSSTATE_DEVELOPMENT) {
                        setIcon(developmentIcon);
                    } else if (moduleNode.getCvsState() == StepmodPart.CVSSTATE_RELEASE) {
                        setIcon(releasedIcon);
                    } else if (moduleNode.getCvsState() == StepmodPart.CVSSTATE_PUBLISHED) {
                        setIcon(publishedIcon);
                    }
                    setToolTipText("Display ,???");
                    // TODO - need to work out from CVS which release is active if any
                    // Probably need a readonly icon to show stickiness
                    if (moduleNode.getCmRecord().getModified() == CmRecord.CM_RECORD_CHANGED_NOT_SAVED) {
                        // Make the text red if the state of cm_record has been changed, but not saved
                        setForeground(Color.RED);
                    }
                } else if (userNode instanceof CmRelease) {
                    setIcon(null);
                    // TODO set checkout release some color
                    // Needs to query CVS and set a variable
                } else {
                    setIcon(null);
                    setToolTipText("Display ????");
                }
            }
            return this;
        }
    }
    
    /**
     * Once the repository has been read, initialize the display of the trees and menus
     */
    public void initialise() {
        // TODO probably should display a splash screen with progress bar as it takes a while to load
        initRepositoryTree();
        initAllModulesPopupMenu();
        initModulePopupMenu();
        setVisible(true);
    }
    
    /**
     * Initialise the display of the repository tree
     */
    private void initRepositoryTree() {
        DefaultMutableTreeNode rootTreeNode = new DefaultMutableTreeNode("STEPMod");
        //Use the tree mode to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = new DefaultTreeModel(rootTreeNode);
        repositoryJTree = new JTree(treeModel);
        repositoryTreeScrollPane.setViewportView(repositoryJTree);
        repositoryJTree.setEditable(true);
        repositoryJTree.setExpandsSelectedPaths(true);
        repositoryJTree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        
        // Iterate through all the modules creating nodes and adding them to the tree
        DefaultMutableTreeNode modulesTreeNode = new DefaultMutableTreeNode("Modules");
        rootTreeNode.add(modulesTreeNode);
        for (Iterator it=getStepMod().getModulesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodModule moduleNode = (StepmodModule)entry.getValue();
            DefaultMutableTreeNode moduleTreeNode = new DefaultMutableTreeNode(moduleNode);
            modulesTreeNode.add(moduleTreeNode);
            DefaultMutableTreeNode attributesTreeNode = new DefaultMutableTreeNode("Attributes");
            moduleTreeNode.add(attributesTreeNode);
            DefaultMutableTreeNode attributeTreeNode;
            attributeTreeNode = new DefaultMutableTreeNode("Name:" + moduleNode.getName());
            attributesTreeNode.add(attributeTreeNode);
            attributeTreeNode = new DefaultMutableTreeNode("Number:" + moduleNode.getPartNumber());
            attributesTreeNode.add(attributeTreeNode);
            
            DefaultMutableTreeNode dependenciesTreeNode = new DefaultMutableTreeNode("Dependencies");
            moduleTreeNode.add(dependenciesTreeNode);
            // TODO - need to deduce the depenencies and create a tree.
            // The dependencies are the modules, resources etc.
            // Need to write the algorithm that recurses through the ARM, and MIM express
            
            DefaultMutableTreeNode filesTreeNode = new DefaultMutableTreeNode("Files");
            moduleTreeNode.add(filesTreeNode);
            // TODO - need to list the files that make up the modules
            // The arm, mim, sys files etc.
            // For each file display the CVS revision and date
            
            DefaultMutableTreeNode releasesTreeNode = new DefaultMutableTreeNode("Releases");
            moduleTreeNode.add(releasesTreeNode);
            for (Iterator j = moduleNode.getCmRecord().getHasCmReleases().iterator(); j.hasNext();) {
                CmRelease cmRelease = (CmRelease) j.next();
                addReleaseToTree(cmRelease, moduleTreeNode, false);
            }
        }
        
        // Iterate through all the Application protocols creating nodes and adding them to the tree
        DefaultMutableTreeNode applicationProtocolsTreeNode = new DefaultMutableTreeNode("Application protocols");
        rootTreeNode.add(applicationProtocolsTreeNode);
        for (Iterator it=getStepMod().getApplicationProtocolsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodApplicationProtocol applicationProtocolNode = (StepmodApplicationProtocol)entry.getValue();
            DefaultMutableTreeNode applicationProtocolTreeNode = new DefaultMutableTreeNode(applicationProtocolNode);
            applicationProtocolsTreeNode.add(applicationProtocolTreeNode);
        }
        
        
        // Iterate through all the Resource documents creating nodes and adding them to the tree
        DefaultMutableTreeNode resourceDocsTreeNode = new DefaultMutableTreeNode("Resource documents");
        rootTreeNode.add(resourceDocsTreeNode);
        for (Iterator it=getStepMod().getResourceDocsHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResourceDoc resourceDocNode = (StepmodResourceDoc)entry.getValue();
            DefaultMutableTreeNode resourceDocTreeNode = new DefaultMutableTreeNode(resourceDocNode);
            resourceDocsTreeNode.add(resourceDocTreeNode);
        }
        
        // Iterate through all the Resource schemas creating nodes and adding them to the tree
        DefaultMutableTreeNode resourceSchemasTreeNode = new DefaultMutableTreeNode("Resource schemas");
        rootTreeNode.add(resourceSchemasTreeNode);
        for (Iterator it=getStepMod().getResourcesHash().entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry)it.next();
            StepmodResource resourceNode = (StepmodResource)entry.getValue();
            DefaultMutableTreeNode resourceTreeNode = new DefaultMutableTreeNode(resourceNode);
            resourceSchemasTreeNode.add(resourceTreeNode);
        }
        
        
        DefaultMutableTreeNode frameworkTreeNode = new DefaultMutableTreeNode("STEPmod Framework");
        rootTreeNode.add(frameworkTreeNode);
        
        // Set up the renderer that displays the icons in the tree
        repositoryJTree.setCellRenderer(new RepositoryTreeRenderer());
        
        // Setup the listeners that get fired when there are mouse events on the tree
        repositoryJTree.addTreeSelectionListener(new TreeSelectionListener() {
            public void valueChanged(TreeSelectionEvent e) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) repositoryJTree.getLastSelectedPathComponent();
                if (node == null) return;
                if (node.getParent() == null) return; // The root
                Object nodeObject = (Object)node.getUserObject();
                if (nodeObject instanceof StepmodModule) {
                    StepmodModule module = (StepmodModule) nodeObject;
                    // Display a summary of the module in the repositoryTextPane
                    String summary = module.summaryHtml();
                    repositoryTextPane.setText(summary);
                } else if (nodeObject instanceof CmRelease) {
                    CmRelease cmRelease = (CmRelease) nodeObject;
                    String summary = cmRelease.summaryHtml();
                    repositoryTextPane.setText(summary);
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
                    if (nodeObject instanceof StepmodModule) {
                        // Make sure that the menu knows about the tree node
                        modulePopupMenu.setUserObject(node);
                        modulePopupMenu.show(e.getComponent(), e.getX(), e.getY());
                    } else if (nodeObject instanceof String) {
                        if (nodeObject.equals("Modules")) {
                            allModulesPopupMenu.show(e.getComponent(), e.getX(), e.getY());
                        }
                    }
                }
            }
        });
        repositoryJTree.setModel( new DefaultTreeModel(rootTreeNode) );
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
                clearAllSelectedModuleNodes();
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
    
    private void openAllModuleNodes() {
        toBeDone("STEPModFrame.openAllModuleNodes");
    }
    
    private void openAllSelectedModuleNodes() {
        toBeDone("STEPModFrame.openAllSelectedModuleNodes");
    }
    
    private void clearAllSelectedModuleNodes() {
        toBeDone("STEPModFrame.clearAllSelectedModuleNodes");
    }
    
    private void initModulePopupMenu() {
        // Setup the popoup menu associated with individual modules
        modulePopupMenu = new PopupMenuWithObject();
        
        // Update development revision
        javax.swing.JMenuItem createCvsUpdateDevelopmentRevisionMenuItem;
        createCvsUpdateDevelopmentRevisionMenuItem = new javax.swing.JMenuItem("Update development revision");
        createCvsUpdateDevelopmentRevisionMenuItem.setToolTipText("Checks out the latest revisions of the module from CVS for development.");
        createCvsUpdateDevelopmentRevisionMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                StepmodCvs stepmodCvs = new StepmodCvs(module.getStepMod());
                stepmodCvs.cvsUpdate(module.getDirectory());
            }
        });
        modulePopupMenu.add(createCvsUpdateDevelopmentRevisionMenuItem);
        
        
        // Checkout a given release
        javax.swing.JMenuItem createCvsCoReleaseMenuItem;
        createCvsCoReleaseMenuItem = new javax.swing.JMenuItem("Checkout specified release");
        createCvsCoReleaseMenuItem.setToolTipText("Checks out a specified release of the module from CVS (Sticky).");
        createCvsCoReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.cvsCoRelease();
            }
        });
        modulePopupMenu.add(createCvsCoReleaseMenuItem);
        
        // Checkout a latest release
        javax.swing.JMenuItem createCvsCoLatestReleaseMenuItem;
        createCvsCoLatestReleaseMenuItem = new javax.swing.JMenuItem("Checkout latest release");
        createCvsCoLatestReleaseMenuItem.setToolTipText("Checks out the latest release of the module from CVS (Sticky).");
        createCvsCoLatestReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.cvsCoLatestRelease();
            }
        });
        modulePopupMenu.add(createCvsCoLatestReleaseMenuItem);
        
        // Checkout a published release
        javax.swing.JMenuItem createCvsCoPublishedReleaseMenuItem;
        createCvsCoPublishedReleaseMenuItem = new javax.swing.JMenuItem("Checkout published release");
        createCvsCoPublishedReleaseMenuItem.setToolTipText("Checks out the latest release of the module published by ISO from CVS (Sticky).");
        createCvsCoPublishedReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.cvsCoPublishedRelease();
            }
        });
        modulePopupMenu.add(createCvsCoPublishedReleaseMenuItem);
        
        modulePopupMenu.add(new JSeparator());
        // Make a new release option
        javax.swing.JMenuItem createCmReleaseMenuItem;
        createCmReleaseMenuItem = new javax.swing.JMenuItem("Create new release");
        createCmReleaseMenuItem.setToolTipText("Creates a new release of the module. The saved record and CVS will only be updated after it has been committed");
        createCmReleaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                new STEPModMkReleaseDialog(module, node).setVisible(true);
                //CmRelease cmRelease = module.mkCmRelease();
                //module.getStepMod().getStepModGui().addReleaseToTree(cmRelease, node);
            }
        });
        modulePopupMenu.add(createCmReleaseMenuItem);
        
        // Commit CM record option
        javax.swing.JMenuItem createCmRecordMenuItem;
        createCmRecordMenuItem = new javax.swing.JMenuItem("Commit CM Record");
        createCmRecordMenuItem.setToolTipText("Save any changes to the CM record to cm_record.xml and use CVS to tag release");
        createCmRecordMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.cvsTagRecord();
                module.getCmRecord().writeCmRecord();
            }
        });
        modulePopupMenu.add(createCmRecordMenuItem);
        
        modulePopupMenu.add(new JSeparator());
        
        // Create publication package
        javax.swing.JMenuItem createModulePublicationPackage;
        createModulePublicationPackage = new javax.swing.JMenuItem("Create publication package (ANT build)");
        createModulePublicationPackage.setToolTipText("Creates the ANT build file for generating the publication package");
        createModulePublicationPackage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.publicationCreatePackage();
            }
        });
        modulePopupMenu.add(createModulePublicationPackage);
        
        // Generate HTML for publication package
        javax.swing.JMenuItem genHtmlModulePublicationPackage;
        genHtmlModulePublicationPackage = new javax.swing.JMenuItem("Generate HTML for publication package ");
        genHtmlModulePublicationPackage.setToolTipText("Generates the HTML for the publication package");
        genHtmlModulePublicationPackage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) modulePopupMenu.getUserObject();
                StepmodModule module = (StepmodModule) node.getUserObject();
                module.publicationGenerateHtml();
            }
        });
        modulePopupMenu.add(genHtmlModulePublicationPackage);
    }
    
    /**
     * Add the release to the tree node of releases for a given StepmodPart
     */
    public void addReleaseToTree(CmRelease cmRelease, DefaultMutableTreeNode stepPartNode, boolean shouldBeVisible) {
        // Find the release nodes - always the last one
        DefaultMutableTreeNode releasesNode = (DefaultMutableTreeNode) stepPartNode.getLastChild();
        DefaultMutableTreeNode releaseNode = new DefaultMutableTreeNode(cmRelease);
        // Use the tree mode to make sure that the added nodes are displayed
        DefaultTreeModel treeModel = (DefaultTreeModel)repositoryJTree.getModel();
        treeModel.insertNodeInto(releaseNode, releasesNode, releasesNode.getChildCount());
        TreePath path = new TreePath(releaseNode.getPath());
        repositoryJTree.expandPath(path);
        //Make sure the user can see the lovely new node.
        if (shouldBeVisible) {
            repositoryJTree.scrollPathToVisible(path);
            repositoryJTree.setSelectionPath(path);
        }
        treeModel.nodeChanged(releasesNode.getParent());
    }
    
    
    
    /**
     * Output the string
     */
    public void output(String string) {
        stepModOutputTextArea.append("\n"+string);
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
        jLabel1 = new javax.swing.JLabel();
        findPartjTextField = new javax.swing.JTextField();
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
        exitMenuItem = new javax.swing.JMenuItem();
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
        jLabel1.setText("Part number: ");
        jToolBar1.add(jLabel1);

        findPartjTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                findPartjTextFieldActionPerformed(evt);
            }
        });

        jToolBar1.add(findPartjTextField);

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
            .add(stepModOutputScrollPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 23, Short.MAX_VALUE)
        );
        stepmodMainSplitPane.setRightComponent(stepModOutputPanel);

        fileMenu.setText("File");
        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(exitMenuItem);

        menuBar.add(fileMenu);

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

    private void findPartjTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_findPartjTextFieldActionPerformed
        toBeDone("findPartjTextFieldActionPerformed");
        
    }//GEN-LAST:event_findPartjTextFieldActionPerformed
    
    private void testCVSMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_testCVSMenuItemActionPerformed
        StepmodCvs stepmodCvs = new StepmodCvs(this.getStepMod());
        stepmodCvs.testCVSconnection();
    }//GEN-LAST:event_testCVSMenuItemActionPerformed
    
    /**
     * Display a new smaller gui to display the contents of stepmod.properties
     *
     */
    private void setStepModPropsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_setStepModPropsActionPerformed
        
        
        
        STEPModPropsFrame stepprops = new STEPModPropsFrame(getStepMod());
        stepprops.stepmodText.setText(getStepMod().readProps());
        stepprops.setSize(700,500);
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
    private javax.swing.JMenuItem clearOutputMenuItem;
    private javax.swing.JMenuItem contentsMenuItem;
    private javax.swing.JMenuItem exitMenuItem;
    private javax.swing.JMenu fileMenu;
    private javax.swing.JTextField findPartjTextField;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JMenuItem mkApMenuItem;
    private javax.swing.JMenuItem mkModuleMenuItem;
    private javax.swing.JMenuItem mkdResDocMenuItem;
    private javax.swing.JPopupMenu outputPopupMenu;
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
    // End of variables declaration//GEN-END:variables
    
}
