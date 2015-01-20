package org.wso2.cep.wrangler.mgt;


import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;


/**
 * Created by nisala on 1/7/15.
 */
public class SaveReg {

    public void saveFile(String script) {

        try {
            File file = new File("script.txt");
            BufferedWriter output = new BufferedWriter(new FileWriter(file));
            output.write(script);
            output.close();
        } catch ( IOException e ) {
            e.printStackTrace();
        }
}
    public void saveRegistryFile(){

    }

}
