import java.io.*;

import org.apache.log4j.Logger;

public class Capturer1 extends Thread {
    private InputStream inputStream;
    public String cvsStatus;
    public String workingRevision;

    static Logger logger = Logger.getLogger("Capturer1");

    public Capturer1(InputStream inputStream) {
	this.inputStream = inputStream;
    }

    public void run () {
	String line;
	cvsStatus = "";
	workingRevision = "";
	try {
	    BufferedReader inputReader = new BufferedReader(new InputStreamReader(inputStream));
	    while ((line = inputReader.readLine()) != null) {
		// logger.debug("Line = " + line);
		line = line.trim();
		if (line.startsWith("File:")) {
		    int n = line.indexOf("Status:");
		    cvsStatus = line.substring(n+7).trim();
		}
		if (line.startsWith("Working revision:")) {
		    workingRevision = line.replace("Working revision:","").trim();
		}
	    }
	    inputReader.close();
	}
	catch (java.io.IOException e) {
	    e.printStackTrace();
	}
    }
}

