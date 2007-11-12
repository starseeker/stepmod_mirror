public class StatusProcessor implements CvsOutputProcessor {
    MetadataCollection metadataCollection;
    private String cvsStatus;
    private String repositoryRevision;
    private String workingRevision;
    private String repositoryPath;

    public StatusProcessor(MetadataCollection coll) {
	metadataCollection = coll;
	init();
    }

    public void init() {
	cvsStatus = null;
	workingRevision = null;
	repositoryPath = null;
    }

    public void putLine(String line) {
	line = line.trim();
	if (line.startsWith("File:")) {
	    int n = line.indexOf("Status:");
	    cvsStatus = line.substring(n+7).trim();
	}
	if (line.startsWith("Working revision:")) {
	    workingRevision = line.replace("Working revision:","").trim();
	}
	if (line.startsWith("Repository revision:")) {
	    String s = line.substring(20).trim();
	    String[] comp = s.split("\\s+");
	    repositoryRevision = comp[0];
	    repositoryPath = comp[1];
	    if (repositoryPath.endsWith(",v")) {
		repositoryPath = repositoryPath.substring(0,repositoryPath.length() - 2);
	    }
	}
	if (line.startsWith("====")) {
	    flush();
	}
    }

    public void flush() {
	if (cvsStatus != null) {
	    Metadata metadata = new Metadata();
	    metadata.repositoryPath = repositoryPath;
	    metadata.revision = workingRevision;
	    metadataCollection.put(repositoryPath, metadata);
	}
	init();
    }
}
