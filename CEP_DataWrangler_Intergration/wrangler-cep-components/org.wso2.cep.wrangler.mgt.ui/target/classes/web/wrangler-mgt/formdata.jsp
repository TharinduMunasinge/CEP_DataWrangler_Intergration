<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.context.CarbonContext" %>
<%@ page import="org.wso2.carbon.registry.api.Registry" %>
<%@ page import="org.wso2.carbon.context.RegistryType" %>
<%@ page import="org.wso2.carbon.registry.api.Resource" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.cep.wrangler.mgt.ui.SaveRegClient" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<html>
<body>
<script>console.log("gotHere")</script>
</body>
</html>
<%
    String s = request.getParameter("numParams");
    CarbonContext cCtx = CarbonContext.getCurrentContext();
    Registry registry = cCtx.getRegistry(RegistryType.SYSTEM_CONFIGURATION);
    String registryType = RegistryType.SYSTEM_GOVERNANCE.toString();
    if(registryType != null) {
        registry = cCtx.getRegistry(RegistryType.valueOf(registryType));
    }

    Resource resource = registry.newResource();
    resource.setContent(s);
    String resourcePath = "/_system/savedParams2";
    registry.put(resourcePath, resource);

    String serverURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);

    SaveRegClient client;

    try {
        client = new SaveRegClient(configContext, serverURL, cookie);
        client.saveReg(s);
    } catch (Exception e) {
        CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request, e);




%>
<script type="text/javascript">
    location.href = "../admin/error.jsp";
</script>
<%
        return;
    }
%>



<!--
<script>alert("got Herrre")</script>
<%--<%--%>
    <%--String s = request.getParameter("numParams");--%>
    <%--String result="";--%>
    <%--int length = 0;--%>

    <%--try {--%>
        <%--length = Integer.parseInt(s);--%>
    <%--}catch (Exception e){--%>

    <%--}--%>
<%--%>--%>


   <%--<% for(int i=1;i<length;i++){%>--%>
<%--<script type="text/javascript">--%>
    <%--var paramsToJson;--%>
    <%--var params;--%>
           <%--<%String temp= "colInput"+i+"";%>--%>
           <%--params={name:<%request.getParameter(temp);%>}--%>
           <%--paramsToJson =JSON.stringify(params);--%>
    <%--alert("got hereee2");--%>
<%--</script>--%>
   <%--<%--%>

    <%--}--%>
    <%--%>--%>
<script type="text/javascript">
    alert("got hereee3");
        $.ajax({
            type:"POST",
            url: "saveParam.jsp",
            data:{param:paramsToJson},
            error:function(a,b,c){
                  alert(a+"  "+b+" "+c);
            },
            success :function(s){
                    alert("Success");
            }
        });
    </script>
