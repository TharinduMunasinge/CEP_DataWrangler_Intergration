<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.context.CarbonContext" %>
<%@ page import="org.wso2.carbon.registry.api.Registry" %>
<%@ page import="org.wso2.carbon.context.RegistryType" %>
<%@ page import="org.wso2.carbon.registry.api.Resource" %>
<%@ page import="org.wso2.carbon.registry.api.Collection" %>
<%@ page import="org.wso2.carbon.registry.api.RegistryException" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%
        /**
         * access to the registry and get the files 'config' and 'script.js' to preview the existing configuration
         */
    Logger logger = Logger.getLogger("");
    String BASEURL = "/repository/components/org.wso2.cep.wrangler";

    CarbonContext cCtx = CarbonContext.getCurrentContext();
    Registry registry = cCtx.getRegistry(RegistryType.SYSTEM_CONFIGURATION);
    String registryType = RegistryType.SYSTEM_GOVERNANCE.toString();
    if (registryType != null) {
        registry = cCtx.getRegistry(RegistryType.valueOf(registryType));
    }

    Resource script_file = null;
    Resource config_file = null;
    String folderName = request.getParameter("folderName");
    String script_content = "ABC";
    String config_content = "";

    try {
        if (folderName != null || folderName != "") {
            script_file = (Resource) registry.get(BASEURL + "/" + folderName + "/script.js");
            config_file = (Resource) registry.get(BASEURL + "/" + folderName + "/config");
            script_content = new String((byte[]) script_file.getContent());
            config_content = new String((byte[]) config_file.getContent());
        }%>
<p><%=script_content%></p>
<code><%=config_content%></code>


<%   } catch (RegistryException e) {
          logger.error("Error in Registry client" + e.getMessage());
} catch (Exception e) {
        logger.error(e.getMessage());
}
%>