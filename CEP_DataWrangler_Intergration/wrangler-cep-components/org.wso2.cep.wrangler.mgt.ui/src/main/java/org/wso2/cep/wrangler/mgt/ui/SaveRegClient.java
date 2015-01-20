package org.wso2.cep.wrangler.mgt.ui;

import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.ConfigurationContext;
import org.wso2.cep.wrangler.mgt.*;
import org.wso2.cep.wrangler.mgt.stub.*;

import java.rmi.RemoteException;

/**
 * Created by nisala on 1/12/15.
 */
public class SaveRegClient {
    private SaveRegManagerStub stub;

    public SaveRegClient(ConfigurationContext configCtx, String backendServerURL, String cookie) throws Exception{
        String serviceURL = backendServerURL + "SaveRegManager";
        stub = new SaveRegManagerStub(configCtx, serviceURL);
        ServiceClient client = stub._getServiceClient();
        Options options = client.getOptions();
        options.setManageSession(true);
        options.setProperty(org.apache.axis2.transport.http.HTTPConstants.COOKIE_STRING, cookie);
    }

    public void saveReg(String script) throws Exception{
        try{
            System.out.println("Nisala");
            stub.saveRegistry(script);
        }catch (RemoteException e) {
            String msg = "Cannot get the list of students"
                    + " . Backend service may be unavailable";
            throw new Exception(msg, e);
        }
    }

}
