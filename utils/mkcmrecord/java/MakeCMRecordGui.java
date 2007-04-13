/********************************************************************************
/* MakeCMRecordGui                                                              *
/*                                                                              *
/* Author: Gerald Radack                                                        *
/********************************************************************************/
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import java.util.Date;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class MakeCMRecordGui implements ActionListener {
    static public final String[] statusStrings = { "Team review", "Convener review", "Secretariat review", "ISO review", "Ballot", "ISO publication" };

    MakeCMRecord makeCMRecord;

    JFrame guiFrame;
    JPanel guiPanel;

    String moduleDir;

    StringIf releaseIf = new StringIf("Release", "");
    StringIf releaseSequenceIf = new StringIf("Release sequence", "");
    StringIf editionIf = new StringIf("Edition", "");
    StringIf whoIf = new StringIf("Who", "");
    StringIf whenIf = new StringIf("When", MakeCMRecord.isoDateFormat.format(new java.util.Date()));
    StringIf descriptionIf = new StringIf("Description", "");
    ComboIf statusIf = new ComboIf("Status", statusStrings, 0);

    JButton createButton;
    JButton cancelButton;

    public MakeCMRecordGui(String moduleDir) {
	this.moduleDir = moduleDir;

        //Create and set up the window.
        guiFrame = new JFrame("Enter metadata for CM record");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        guiFrame.setSize(new Dimension(240, 80));

        //Create and set up the panel.
        guiPanel = new JPanel(new GridLayout(8,2));

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
        //Listen to events from the Create button.
        createButton = new JButton("Create CM");
	createButton.setActionCommand("create");
        createButton.addActionListener(this);

	cancelButton = new JButton("Cancel");
	cancelButton.setActionCommand("cancel");
        cancelButton.addActionListener(this);

        //Add the widgets to the container.
	releaseIf.add(guiPanel);
	releaseSequenceIf.add(guiPanel);
	editionIf.add(guiPanel);
	whoIf.add(guiPanel);
	whenIf.add(guiPanel);
	descriptionIf.add(guiPanel);
	statusIf.add(guiPanel);
	guiPanel.add(createButton);
	guiPanel.add(cancelButton);
    }

    public void actionPerformed(ActionEvent event) {
	String cmd = event.getActionCommand();
	if (cmd.equals("create")) {
	    try {
		String dateStr = whenIf.getValue();
		java.util.Date date = MakeCMRecord.isoDateFormat.parse(dateStr);
		/*
		// The following code is needed because isoDateFormat.parse is not picking up
		// the hours, minutes and seconds.
		String[] comp = dateStr.split(" ");
		String[] comp1 = comp[1].split(":");
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(date);
		cal.set(GregorianCalendar.HOUR, Integer.parseInt(comp1[0]));
		cal.set(GregorianCalendar.MINUTE, Integer.parseInt(comp1[1]));
		cal.set(GregorianCalendar.SECOND, Integer.parseInt(comp1[2]));
		date = cal.getTime();
		*/
		makeCMRecord = new MakeCMRecord(moduleDir, "cm_record.xml", descriptionIf.getValue(), releaseIf.getValue(), statusIf.getValue(), releaseSequenceIf.getValue(), editionIf.getValue(), date, whoIf.getValue());
		makeCMRecord.transform();
		makeCMRecord.write();

		System.exit(1);
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	}
	if (cmd.equals("cancel")) {
	    System.exit(0);
	}
    }

    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from the
     * event-dispatching thread.
     */
    private static void createAndShowGUI(String moduleDir) {
        //Make sure we have nice window decorations.
        JFrame.setDefaultLookAndFeelDecorated(true);

        MakeCMRecordGui gui = new MakeCMRecordGui(moduleDir);
    }

    public static void main(final String[] arg) {
        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI(arg[0]);
            }
        });
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
