/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.File;

/**
 *
 * @author radack
 */
public class FileUtil {
    public static File getStepmodRoot() {
        File file = new File(System.getProperty("user.dir"));
        while ((file != null) && !file.getName().equals("stepmod")) {
            file = file.getParentFile();
        }
        return file;
    }
}
