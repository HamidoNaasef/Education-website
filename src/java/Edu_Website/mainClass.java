package Edu_Website;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class mainClass {
    public static void main(String[] args) throws Exception {
        File file = new File("D:\\p_0000001.spec");
        String data = "";
        boolean write = false;
        try (FileReader fr = new FileReader(file)) {
            int content;
            while((content = fr.read()) != -1) {
                data += (char)content;
                
            }
            fr.close();
        }catch(Exception efile){
            System.err.println("Error in reading from file in exam:");
        }
        
        File file2 = new File("D:\\abdo.spec");
        FileWriter fw = new FileWriter(file2);
//        String oldText = data.substring(data.indexOf("Name=\"")+1,  data.);
        
        fw.write(data);
    }
}