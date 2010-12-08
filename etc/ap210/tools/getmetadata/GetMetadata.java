import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Vector;

class GetMetadata {
    private boolean filterByModule;
    private Vector<String> moduleVec;
    private Vector<Metadata> metadataVec;
    private File currentFile; /* !! */
    private BufferedWriter reportWriter;
    private BufferedWriter errorWriter;
    private BufferedWriter expListWriter;

    public GetMetadata() throws java.io.IOException {
	expListWriter = new BufferedWriter(new FileWriter("exp_list.txt"));
	filterByModule = false;
	metadataVec = new Vector<Metadata>();
    }

    public File getCurrentFile() {
	return currentFile;
    }

    public BufferedWriter getErrorWriter() {
	return errorWriter;
    }

    public void clean() throws java.io.IOException {
	termErrorWriter();
	termReportWriter();
	expListWriter.flush();
    }

    public void init(String reportFilename, String errorFilename) throws java.io.IOException {
	initErrorWriter(errorFilename);
	initReportWriter(reportFilename);
    }

    private void initReportWriter(String filename) throws java.io.IOException {
	reportWriter = new BufferedWriter(new FileWriter(filename));
    }

    private void initErrorWriter(String filename) throws java.io.IOException {
	errorWriter = new BufferedWriter(new FileWriter(filename));
	errorWriter.write("<html>\n");
	errorWriter.write("<head>\n");
	errorWriter.write("</head>\n");
	errorWriter.write("<body>\n");
    }

    private void termReportWriter() throws java.io.IOException {
	reportWriter.flush();
    }

    private void termErrorWriter() throws java.io.IOException {
	errorWriter.write("</body>\n");
	errorWriter.write("</html>\n");
	errorWriter.flush();
    }

    private void error(String msg) {
	try {
	    errorWriter.write("File " + currentFile.getPath() + "\n");
	    errorWriter.write(msg);
	}
	catch (java.io.IOException e) {
	    System.err.print("Unable to write to errorWriter.\n");
	    e.printStackTrace();
	}
    }

    private void writeMetadata(String filename) throws java.io.IOException {
	BufferedWriter metadataWriter;

	metadataWriter = new BufferedWriter(new FileWriter(filename));
	for (int i=0; i<metadataVec.size(); i++) {
	    metadataVec.get(i).write(metadataWriter);
	}
	metadataWriter.flush();
    }

    Metadata getComment(BufferedReader rdr) throws java.io.IOException {
	String line;
	String comment;
	Metadata md;
	boolean inMetadata;

	inMetadata = false;
	comment = "";

	/* The first comment in the file should contain the metadata. */

	while ((line = rdr.readLine()) != null) {
	    line = line.trim();
	    if (line.startsWith("(*")) {
		inMetadata = true;
		
	    }
	    else {
		if (line.endsWith("*)")) {
		    break;
		}
		else {
		    if (line.length() > 0) {
			comment = comment + line + "\n";
		    }
		}
	    }
	}
	md = new Metadata(comment, this);
	md.parse();
	return md;
    }

    void processExp(File f) throws java.io.FileNotFoundException, java.io.IOException {
	String line;
	String[] sarr;
	BufferedReader rdr;
	Metadata md;
	String comment;


	expListWriter.write(f.getPath());
	expListWriter.newLine();

	rdr = new BufferedReader(new FileReader(f));

	while (((line = rdr.readLine()) != null) &&
	       !line.startsWith("(*")) {
	}

	if ((line == null) || line.trim().endsWith("*)")) {
	    return;
	}

	md = getComment(rdr);

	//	if (md.belongsToWg("WG3")) {
	    reportWriter.write("\n\nFile: " + f.getPath() + "\n");
	    md.print(reportWriter);
	    metadataVec.add(md);
	    //	}
    }

    private void printMetadata(Hashtable<String,String> hash) throws java.io.IOException {
	Enumeration<String> e;
	String key;
	String value;

	for (e = hash.keys(); e.hasMoreElements();) {
	    key = e.nextElement();
	    value = hash.get(key);
	    reportWriter.write(key + ": " + value + "\n");
	}
    }

    private void processHtml(File f) throws java.io.FileNotFoundException, java.io.IOException {
	String line;
	BufferedReader rdr;
	Pattern pat;
	Matcher mat;
	Hashtable<String,String> hash;
	String v;

	hash = new Hashtable<String,String>();

	// reportWriter.write("processHtml: File " + f.getPath() + "\n");
	pat = Pattern.compile("\\s*<META name=\"([^\"]+)\" content=\"([^\"]+)\">\\s*");

	rdr = new BufferedReader(new FileReader(f));

	while ((line = rdr.readLine()) != null) {
	    mat = pat.matcher(line);
	    if (mat.matches()) {
		hash.put(mat.group(1), mat.group(2));
	    }
	}
	v = hash.get("DC.Identifier");
	if (v == null) {
	    reportWriter.write("DC.Identifier metadata nout found in file " +  f.getPath() + "\n");
	    return;
	}
	if (v.contains("WG3")) {
	    reportWriter.write("File " + f.getPath() + "\n");
	    printMetadata(hash);
	}
    }

    boolean isInModuleList(File f) {
	String name = f.getName();

	return true;
    }

    void process(File f) throws java.io.FileNotFoundException, java.io.IOException {
	String name;
	File[] farr;

	currentFile = f; /* !! */

	if (f.isFile() && isInModuleList(f)) {
	    name = f.getName();
	    if (name.equals("cover.htm")) {
		processHtml(f);
	    }
	    if (name.endsWith(".exp")) {
		processExp(f);
	    }
	}
	if (f.isDirectory()) {
	    farr = f.listFiles();
	    for (int i=0; i<farr.length; i++) {
		// Do not process resource parts.
		if (!f.getName().equals("resources")) {
		    process(farr[i]);
		}
	    }
	}
    }

    public void loadModuleList(String fileName) throws java.io.FileNotFoundException, java.io.IOException {
	BufferedReader rdr;
	String[] s;
	String line;

	filterByModule = true;
	moduleVec = new Vector<String>();
	rdr = new BufferedReader(new FileReader(fileName));
	while ((line = rdr.readLine()) != null) {
	    moduleVec.add(line);
	}
    }

    public static void processArguments(String argv[], GetMetadata gmd, int start) throws java.io.FileNotFoundException, java.io.IOException {
	for (int i=start; i<argv.length; i++) {
	    if (argv[i].equals("-m")) {
		gmd.loadModuleList(argv[i+1]);
		i++;
	    }
	}
    }

    public static void main(String argv[]) {
	GetMetadata gmd;
	File f = new File(argv[0]);
	try {
	    gmd = new GetMetadata();
	    gmd.init(argv[1], argv[2]);
	    processArguments(argv, gmd, 1);
	    gmd.process(f);
	    gmd.writeMetadata(argv[3]);
	    gmd.clean();
	    // System.execute("iexplore errors.html");
	}
	catch (Exception e) {
	    e.printStackTrace();
	}
    }
}
