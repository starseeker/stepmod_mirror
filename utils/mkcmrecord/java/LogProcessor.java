public class LogProcessor implements CvsOutputProcessor {
    MetadataCollection metadataCollection;
    private String cvsRevision;
    private String cvsDate;
    private String repositoryPath;
    private String workingFile;
    private Metadata metadata;
    private boolean correctRevision;

    public LogProcessor(MetadataCollection coll) {
	metadataCollection = coll;
	init();
    }

    public void init() {
	cvsRevision = null;
	cvsDate = null;
	repositoryPath = null;
	workingFile = null;
	metadata = null;
	correctRevision = false;
    }

    public void putLine(String line) {
	line = line.trim();
	if (line.startsWith("RCS file:")) {
	    repositoryPath = line.replace("RCS file:","").trim();
	    if (repositoryPath.endsWith(",v")) {
		repositoryPath = repositoryPath.substring(0,repositoryPath.length() - 2);
	    }
	    metadata = metadataCollection.get(repositoryPath);
	    if (metadata == null) {
		System.err.println("Could not find metadata for " + repositoryPath);
	    }
	}
	if (line.startsWith("Working file:")) {
	    workingFile = line.replace("Working file:","").trim();
	}
	if (line.startsWith("revision")) {
	    if (metadata != null) {
		line = line.replace("revision","").trim();
		if (line.equals(metadata.revision)) {
		    correctRevision = true;
		}
	    }
	}
	if (line.startsWith("date:") && correctRevision) {
	    cvsDate = line.replace("date:","").trim();
	    cvsDate = cvsDate.substring(0, cvsDate.indexOf(";"));
	    if (metadata != null) {
		metadata.date = cvsDate;
	    }
	}
	if (line.startsWith("----")) {
	    correctRevision = false;
	}
	if (line.startsWith("====")) {
	    flush();
	}
    }

    public void flush() {
	if (metadata != null) {
	    metadata.repositoryPath = repositoryPath;
	    metadata.workingFile = workingFile;
	    metadata.date = cvsDate;
	}
	init();
    }
}
