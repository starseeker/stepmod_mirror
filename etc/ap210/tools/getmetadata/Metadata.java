import java.io.BufferedWriter;
import java.io.Writer;
import java.util.Hashtable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Metadata {
    public String workingGroup;
    public String nNumber;
    public String supersededWorkingGroup;
    public String supersededNNumber;
    public String docTypeId;
    public boolean isPart;
    public String partNumber;
    public String title;
    public String date;
    public String author;
    public String comment;
    public String filename;
    public String versionNumber;

    private GetMetadata parent;
    private BufferedWriter errorWriter;
    private boolean errorFlag; /* !! */

    private static Pattern idLinePat = Pattern.compile("\\$Id: ([a-z_]+.exp),v ([0-9.]+) ([0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]) [0-9][0-9]:[0-9][0-9]:[0-9][0-9] ([a-z]+) Exp \\$");
    private static Pattern nNumberPat = Pattern.compile("ISO[/ ]TC184[/ ]SC4[/ ]WG(3|12)[ ]?N([0-9]+)");
    private static Pattern titlePat = Pattern.compile("ISO/(WD|CD-TS|TS|DIS|IS) (10303-[0-9]+) ([a-zA-Z0-9 ]+)");
    private static Pattern superPat = Pattern.compile("Supersedes (.*)");

    private Hashtable<String,String> typeIdHash;

    public Metadata(String comment, GetMetadata parent) {
	this.comment = comment;
	this.parent = parent;
	errorWriter = parent.getErrorWriter();

	typeIdHash = new Hashtable<String,String>();
	typeIdHash.put("EXPRESS ARM","14");
	typeIdHash.put("EXPRESS ARM Long form","15");
	typeIdHash.put("EXPRESS MIM","16");
	typeIdHash.put("EXPRESS MIM Long form","17");
    }

    private void error(String msg) {
	String filePath;

	filePath = parent.getCurrentFile().getPath();

	try {
	    errorWriter.write("\n");
	    errorWriter.write("<b><p>Error in file <a href=\"" + filePath + "\">" + filePath + "</a></p></b>\n");
	    errorWriter.write("<p>" + msg + "</p>\n");
	    errorWriter.write("<pre>" + comment + "</pre>\n");
	}
	catch (java.io.IOException e) {
	    System.err.print("Unable to write to errorWriter.\n");
	    e.printStackTrace();
	}
	errorFlag = true;
    }

    private String lookupDocTypeId(String name) {
	return typeIdHash.get(name);
    }

    public boolean belongsToWg(String wg) {
	return comment.indexOf(wg) >= 0;
    }

    public void print(BufferedWriter writer) throws java.io.IOException {
	writer.write(comment);
	writer.write("N-number: " + nNumber + "\n");
	writer.write("Supersedes: " + supersededNNumber + "\n");
	writer.write("Doc type: " + docTypeId + "\n");
	writer.write("Date: " + date + "\n");
	writer.write("Author: " + author + "\n");
    }

    public void write(Writer writer) throws java.io.IOException {
	writer.write(nNumber + "\t" + date + "\t" + author + "\t" + supersededNNumber + "\t" + docTypeId + "\n");
    }


    private String normalizeDate(String str) {
	String[] comp;

	comp = str.split("/");
	return comp[1] + "/" + comp[2] + "/" + comp[0];
    }

    private void parseIdLine(String line) {
	Matcher mat;

	mat = idLinePat.matcher(line);
	if (mat.matches()) {
	    filename = mat.group(1);
	    versionNumber = mat.group(2);
	    date = normalizeDate(mat.group(3));
	    author = mat.group(4);
	}
	else {
	    if (line.indexOf(".exp") < 0) {
		error("Invalid ID line--file name must have .exp extension: " + line);
	    }
	    else {
		error("Invalid ID line:" + line);
	    }
	}
    }

    private void parseTitleLine(String line) {
	String[] comp;

	comp = line.split(" - ");
	if (comp.length != 3) {
	    error("Invalid title line: " + line);
	    return;
	}
	parseNNumber(comp[0]);
	if (errorFlag) {
	    return;
	}
	parseTitle(comp[1]);
	if (errorFlag) {
	    return;
	}
	parseDocType(comp[2]);
    }

    private void parseNNumber(String str) {
	Matcher mat;

	mat = nNumberPat.matcher(str);
	if (mat.matches()) {
	    workingGroup = mat.group(1);
	    nNumber = mat.group(2);
	}
	else {
	    error("Invalid n-number string: " + str);
	}
    }

    private void parseTitle(String str) {
	Matcher mat;

	mat = titlePat.matcher(str);
	if (mat.matches()) {
	    partNumber = mat.group(1);
	    title = mat.group(2);
	}
	else {
	    if (str.indexOf("_") >= 0) {
		error("Invalid title string--underscores not allowed: " + str);
	    }
	    else {
		error("Invalid title string: " + str);
	    }
	}
    }

    private void parseDocType(String line) {
	docTypeId = lookupDocTypeId(line);
    }

    private void parseSupersedesLine(String str) {
	Matcher matSuper, matNnumber;

	matSuper = superPat.matcher(str);
	if (matSuper.matches()) {
	    matNnumber = nNumberPat.matcher(matSuper.group(1));
	    if (matNnumber.matches()) {
		supersededWorkingGroup = matNnumber.group(1);
		supersededNNumber = matNnumber.group(2);
	    }
	    else {
		error("Invalid n-number string: " + str);
	    }
	}
	else {
	    error("Invalid n-number string: " + str);
	}
    }

    /* The Metadata should look like this:

    $Id: arm.exp,v 1.4 2005/04/13 22:50:25 thendrix Exp $
    ISO TC184/SC4/WG3 N1870 - ISO/TS 10303-403 AP203 configuration controlled 3d design of mechanical parts and assemblies - EXPRESS ARM
    Supersedes ISO TC184/SC4/WG3 N1584

    */

    public void parse() {
	String lines[];
	int nlines;
	int currentLine;

	lines = comment.split("\n");
	nlines = lines.length;
	currentLine = 0;

	if (nlines <= currentLine) {
	    error("Header comment is empty.");
	    return;
	}
	if (!lines[currentLine].startsWith("$Id:")) {
	    error("Missing id line.");
	    return;
	}
	parseIdLine(lines[currentLine]);
	if (errorFlag) {
	    return;
	}
	currentLine++;
	if (nlines <= currentLine) {
	    error ("Header does not contain enough lines.");
	    return;
	}
	if (lines[currentLine].equals("part of:")) {
	    isPart = true;
	    currentLine++;
	}
	if (nlines <= currentLine) {
	    error ("Header does not contain enough lines.");
	    return;
	}
	parseTitleLine(lines[currentLine]);
	if (errorFlag) {
	    return;
	}
	currentLine++;
	if (nlines <= currentLine) {
	    return;
	}
	parseSupersedesLine(lines[currentLine]);
	currentLine++;
    }
}
