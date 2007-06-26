/********************************************************************************
/* MakeCMRecordGui                                                              *
/*                                                                              *
/* Author: Gerald Radack                                                        *
/********************************************************************************/
import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import java.util.Date;
import java.util.Vector;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class MakeCMRecordGui implements ActionListener {
    static public final String[] statusStrings = { "Team review", "Convener review", "Secretariat review", "ISO review", "Ballot", "ISO publication" };

    /*
    static String singleModuleString = "Single Module";
    static String moduleSetString = "Module Set";
    */
    static String moduleListFileString = "Module list file...";

    boolean doModuleSet;

    MakeCMRecord makeCMRecord;

    JFrame guiFrame;
    JPanel guiPanel;
    JTextField fileNameField;

    File stepmodBaseDir;

    StringIf moduleNameIf = new StringIf("Module", "");
    StringIf releaseIf = new StringIf("Release", "");
    StringIf stepmodReleaseIf = new StringIf("STEPMOD release", "");
    StringIf releaseSequenceIf = new StringIf("Release sequence", "");
    StringIf editionIf = new StringIf("Edition", "");
    StringIf whoIf = new StringIf("Who", "");
    StringIf whenIf = new StringIf("When", MakeCMRecord.isoDateFormat.format(new java.util.Date()));
    StringIf descriptionIf = new StringIf("Description", "");
    StringIf tagIf = new StringIf("Tag", "");
    ComboIf statusIf = new ComboIf("Status", statusStrings, 0);

    JButton createButton;
    JButton exitButton;
    JButton openButton;
    JFileChooser fc;

    static Logger logger = Logger.getLogger("MakeCMRecordGui");

    public MakeCMRecordGui(File stepmodBaseDir) {
	PropertyConfigurator.configure("log4j.properties");

	this.stepmodBaseDir = stepmodBaseDir;
	doModuleSet = false;

        //Create and set up the window.
        guiFrame = new JFrame("Make CM record tool");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        guiFrame.setSize(new Dimension(240, 80));

        //Create and set up the panel.
        guiPanel = new JPanel(new GridLayout(11,2));

        //Add the widgets.
        addWidgets();

        //Set the default button.
        guiFrame.getRootPane().setDefaultButton(createButton);

        //Add the panel to the window.
        guiFrame.getContentPane().add(guiPanel, BorderLayout.CENTER);

        //Display the window.
        guiFrame.pack();
        guiFrame.setVisible(true);
    }

    /**
     * Create and add the widgets.
     */
    private void addWidgets() {

        //Create widgets.
        createButton = new JButton("Create CM");
	createButton.setActionCommand("create");
        createButton.addActionListener(this);

	exitButton = new JButton("Exit");
	exitButton.setActionCommand("exit");
        exitButton.addActionListener(this);

	/*
        //Create the radio buttons.
        JRadioButton singleModuleButton = new JRadioButton(singleModuleString);
        singleModuleButton.setMnemonic(KeyEvent.VK_B);
        singleModuleButton.setActionCommand(singleModuleString);
        singleModuleButton.addActionListener(this);
        singleModuleButton.setSelected(true);
	guiPanel.add(singleModuleButton);

        JRadioButton moduleSetButton = new JRadioButton(moduleSetString);
        moduleSetButton.setMnemonic(KeyEvent.VK_C);
        moduleSetButton.setActionCommand(moduleSetString);
        moduleSetButton.addActionListener(this);
	guiPanel.add(moduleSetButton);
	*/

        //Create a file chooser
        fc = new JFileChooser();

        openButton = new JButton(moduleListFileString);
        openButton.addActionListener(this);
	guiPanel.add(openButton);
	fileNameField = new JTextField("", 20);
	guiPanel.add(fileNameField);

        //Add the widgets to the container.
	moduleNameIf.add(guiPanel);
	releaseIf.add(guiPanel);
	stepmodReleaseIf.add(guiPanel);
	releaseSequenceIf.add(guiPanel);
	editionIf.add(guiPanel);
	whoIf.add(guiPanel);
	whenIf.add(guiPanel);
	descriptionIf.add(guiPanel);
	statusIf.add(guiPanel);
	guiPanel.add(createButton);
	guiPanel.add(exitButton);
    }

    public void processModule(String moduleName) throws java.io.IOException, java.io.FileNotFoundException, java.text.ParseException, javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException, InvalidModuleDirException, ConnectionException, InternalErrorException {
	File moduleDir = new File(stepmodBaseDir,"data/modules/" + moduleName);
 	String dateStr = whenIf.getValue();
	java.util.Date date = MakeCMRecord.isoDateFormat.parse(dateStr);
	System.err.println("Processing module " + moduleName + ".");
	makeCMRecord = new MakeCMRecord(moduleDir, "cm_record.xml", descriptionIf.getValue(), releaseIf.getValue(), stepmodReleaseIf.getValue(), statusIf.getValue(), releaseSequenceIf.getValue(), editionIf.getValue(), date, whoIf.getValue());
	makeCMRecord.generateCM();
    }

    public void processSingleModule(String moduleName) throws java.io.IOException, java.io.FileNotFoundException, java.text.ParseException, javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException, InvalidModuleDirException, ConnectionException, InternalErrorException {
	moduleName = moduleName.toLowerCase().trim();
	moduleName = moduleName.replace(" ","_");
	moduleName = moduleName.replace("-","_");
	processModule(moduleName);
    }

    public void processModuleList(File moduleListFile) throws java.io.IOException, java.io.FileNotFoundException, java.text.ParseException, javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException, InvalidModuleDirException, ConnectionException, InternalErrorException {
	BufferedReader rdr = new BufferedReader(new FileReader(moduleListFile));
	Vector<String> moduleVec = new Vector<String>();
	String moduleName;
	String line;
	while ((line = rdr.readLine()) != null) {
	    moduleName = line.replace("_ARM","");
	    moduleName = moduleName.toLowerCase().trim();
	    moduleName = moduleName.replace(" ","_");
	    moduleName = moduleName.replace("-","_");
	    moduleVec.add(moduleName);
	}
	for (int i=0; i<moduleVec.size(); i++) {
	    processModule(moduleVec.get(i));
	}
    }

    public void actionPerformed(ActionEvent event) {
	String cmd = event.getActionCommand();
	String moduleName = null;
	File moduleListFile = null;
	String moduleListPath = null;
	boolean singleModuleP = false;
	boolean moduleListP = false;
	if (cmd.equals("create")) {
	    try {
		moduleName = moduleNameIf.getValue();
		moduleListPath = fileNameField.getText();
		if ((moduleName != null) && (moduleName.length() > 0)) {
		    singleModuleP = true;
		}
		if (moduleListPath.length() > 0) {
		    moduleListP = true;
		}
		if (singleModuleP && moduleListP) {
		    System.err.println("Error: Cannot specify both module name and module list file.");
		}
		else {
		    if (singleModuleP) {
			processSingleModule(moduleName);
		    }
		    if (moduleListP) {
			moduleListFile = new File(moduleListPath);
			processModuleList(moduleListFile);
		    }
		}
	    }
	    catch (ConnectionException e) {
		System.err.println("Unable to open connection to cvs server.");
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	}
	if (cmd.equals("exit")) {
	    System.exit(0);
	}
	if (cmd.equals(moduleListFileString)) {
            int returnVal = fc.showOpenDialog(guiPanel);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fc.getSelectedFile();
		fileNameField.setText(file.getAbsolutePath());
            } else {
                logger.debug("Open command cancelled by user.");
            }
            // log.setCaretPosition(log.getDocument().getLength());
	    
	}
    }

    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from the
     * event-dispatching thread.
     */
    private static void createAndShowGUI(File stepmodBaseDir) {
        //Make sure we have nice window decorations.
        JFrame.setDefaultLookAndFeelDecorated(true);

        MakeCMRecordGui gui = new MakeCMRecordGui(stepmodBaseDir);
    }

    public static void main(String[] arg) {
	String stepmodBasePath = arg[0];
	try {
	    final File stepmodBaseDir = new File((new File(stepmodBasePath)).getCanonicalPath());

	    //Schedule a job for the event-dispatching thread:
	    //creating and showing this application's GUI.
	    javax.swing.SwingUtilities.invokeLater(new Runnable() {
		    public void run() {
			createAndShowGUI(stepmodBaseDir);
		    }
		});
	}
	catch (Exception e) {
	    e.printStackTrace();
	}
    }
}

class StringIf {
    JTextField field;
    JLabel label;

    StringIf(String labelStr, String value) {
        label = new JLabel(labelStr, SwingConstants.LEFT);
        field = new JTextField(value, 20);
    }
    void add(JPanel panel) {
	panel.add(label);
	panel.add(field);
        label.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
    }
    String getValue() {
	return field.getText();
    }
}

class ComboIf {
    JComboBox combo;
    JLabel label;

    ComboIf(String labelStr, String[] values, int initialSelected) {
        label = new JLabel(labelStr, SwingConstants.LEFT);
        combo = new JComboBox (values);
        combo.setSelectedIndex(initialSelected);
    }
    void add(JPanel panel) {
	panel.add(label);
	panel.add(combo);
        label.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
    }
    String getValue() {
	return (String)combo.getSelectedItem();
    }
}
