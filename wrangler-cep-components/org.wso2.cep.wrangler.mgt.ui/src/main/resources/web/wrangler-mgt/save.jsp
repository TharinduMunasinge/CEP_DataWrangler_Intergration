<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.context.CarbonContext" %>
<%@ page import="org.wso2.carbon.registry.api.Registry" %>
<%@ page import="org.wso2.carbon.context.RegistryType" %>
<%@ page import="org.wso2.carbon.registry.api.Resource" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%
        /**
         * takes the javascript code related to transform and save it in the resgistry as script.js
         */
    String s = request.getParameter("name");
    String streamName = request.getParameter("streamName");
    CarbonContext cCtx = CarbonContext.getCurrentContext();
    Registry registry = cCtx.getRegistry(RegistryType.SYSTEM_CONFIGURATION);
    String registryType = RegistryType.SYSTEM_GOVERNANCE.toString();
    if(registryType != null) {
        registry = cCtx.getRegistry(RegistryType.valueOf(registryType));
    }

    Resource resource = registry.newResource();
    resource.setContent(s);
    String resourcePath ="/repository/components/org.wso2.cep.wrangler/"+streamName+"/script.js";                   //create a new path using stream name to save the script.js file
    registry.put(resourcePath, resource);

    String serverURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);




%>
<script type="text/javascript">
    location.href = "../admin/error.jsp";
</script>
<%
    return;

%>