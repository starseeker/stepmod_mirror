import java.io.*;

import org.apache.log4j.Logger;

public class ErrorCapturer extends Thread {
    InputStream errorStream;
    boolean unable;

    static Logger logger = Logger.getLogger("ErrorCapturer");

    public ErrorCapturer(InputStream errorStream) {
	this.errorStream = errorStream;
    }

    public void run() {
	boolean first = true;
	boolean unable = false;
	String line;
	unable = false;
	try {
	    BufferedReader errorReader = new BufferedReader(new InputStreamReader(errorStream));
	    while ((line = errorReader.readLine()) != null) {
		if (first) {
		    logger.debug("Errors from process:");
		}
		logger.debug(line);
		if (line.startsWith("Unable to open connection:")) {
		    unable = true;
		}
	    }
	    errorReader.close();
	}
	catch (java.io.IOException e) {
	    e.printStackTrace();
	}
    }
}
