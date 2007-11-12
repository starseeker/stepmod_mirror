public class Metadata {
    public String repositoryPath;
    public String workingFile;
    public String date;
    public String revision;

    public void print() {
	System.out.println("========================================");
	System.out.println("repositoryPath = " + repositoryPath);
	System.out.println("workingFile = " + workingFile);
	System.out.println("date = " + date);
	System.out.println("revision = " + revision);
    }

}
