/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Properties;
import java.io.*;

/**
 *
 * @author radack
 */
public class Config {

    private String cvsRootStr;

    public Config() {
        Properties properties = new Properties();
        InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("mkcmrecord.properties");
        if (inputStream == null) {
            System.err.println("Could not open properties file.");
        } else {
            try {
                properties.load(inputStream);
                inputStream.close();
            } catch (java.io.IOException e) {
                e.printStackTrace();
            }
            cvsRootStr = properties.getProperty("cvs.root");
        }
    }
    
    public String getCvsRootStr() {
        return cvsRootStr;
    }
}
