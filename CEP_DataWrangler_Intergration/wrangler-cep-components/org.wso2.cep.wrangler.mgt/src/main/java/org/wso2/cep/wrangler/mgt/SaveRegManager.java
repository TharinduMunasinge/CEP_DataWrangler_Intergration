package org.wso2.cep.wrangler.mgt;


/**
 * Created by nisala on 1/7/15.
 */
public class SaveRegManager {
    public void saveRegistry(String sscript){
        SaveReg sr = new SaveReg();
        sr.saveFile(sscript);
    }
}
