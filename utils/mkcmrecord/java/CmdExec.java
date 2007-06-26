import java.io.*;
public class CmdExec {

public static void main(String argv[]) {
    try {
     String line;
     String[] cmd = new String[3];
     cmd[0] = "cvs";
     cmd[1] = "status";
     cmd[2] = argv[0];
     Process p = Runtime.getRuntime().exec(cmd);
     BufferedReader input =
       new BufferedReader
         (new InputStreamReader(p.getInputStream()));
     while ((line = input.readLine()) != null) {
       System.out.println(line);
       }
     input.close();
     }
    catch (Exception err) {
     err.printStackTrace();
     }
  }
}
