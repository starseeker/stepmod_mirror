import java.io.File;

public class FileNotUpToDateException extends Exception {
    private File file;

    public FileNotUpToDateException(File file) {
	this.file = file;
    }

    public File getFile() {
	return file;
    }
}
