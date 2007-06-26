import java.io.*;

public class Capturer2 extends Thread {
    private InputStream inputStream;
    private String cvsRevision;
    public String cvsDate;

    public Capturer2(InputStream inputStream, String cvsRevision) {
	this.inputStream = inputStream;
	this.cvsRevision = cvsRevision;
    }

    public void run () {
	String line;
	cvsDate = "";
	try {
	    BufferedReader inputReader = new BufferedReader(new InputStreamReader(inputStream));
	    while ((line = inputReader.readLine()) != null) {
		// logger.debug("Line = " + line);
		line = line.trim();
		if (line.equals("revision " + cvsRevision)) {
		    line = inputReader.readLine();
		    if (line.startsWith("date: ")) {
			String[] comp = line.split(";");
			cvsDate = comp[0].substring(6).trim();
		    }
		}
	    }
	    inputReader.close();
	}
	catch (java.io.IOException e) {
	    e.printStackTrace();
	}
    }
}

