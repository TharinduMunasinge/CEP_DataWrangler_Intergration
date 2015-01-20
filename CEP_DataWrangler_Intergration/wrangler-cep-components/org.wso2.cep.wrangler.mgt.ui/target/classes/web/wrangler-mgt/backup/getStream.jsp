<%@ page import="java.util.concurrent.ConcurrentHashMap" %>
<%@ page import="org.wso2.carbon.databridge.commons.StreamDefinition" %>
<%@ page import="org.wso2.carbon.registry.api.Registry" %>
<%@ page import="java.util.Collection" %>
<%@ page import="org.wso2.carbon.context.CarbonContext" %>
<%@ page import="org.wso2.carbon.registry.core.exceptions.RegistryException" %>
<%@ page import="org.wso2.carbon.registry.core.utils.RegistryUtils" %>
<%@ page import="org.wso2.carbon.registry.api.Resource" %>
<%@ page import="org.wso2.carbon.databridge.commons.utils.EventDefinitionConverterUtils" %>
<%@ page import="org.wso2.carbon.databridge.streamdefn.registry.util.RegistryStreamDefinitionStoreUtil" %>
<%@ page import="org.wso2.carbon.context.RegistryType" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>



<%
ConcurrentHashMap<String, StreamDefinition> map = new ConcurrentHashMap<String, StreamDefinition>();
    CarbonContext cCtx = CarbonContext.getCurrentContext();
    int tenantId = cCtx.getTenantId();

try {
Registry registry = cCtx.getRegistry(RegistryType.SYSTEM_GOVERNANCE);

if (!registry.resourceExists(RegistryStreamDefinitionStoreUtil.getStreamDefinitionStorePath())) {
registry.put(RegistryStreamDefinitionStoreUtil.getStreamDefinitionStorePath(), registry.newCollection());
} else {
org.wso2.carbon.registry.core.Collection collection =
(org.wso2.carbon.registry.core.Collection) registry.get(RegistryStreamDefinitionStoreUtil.
getStreamDefinitionStorePath());
for (String streamNameCollection : collection.getChildren()) {

org.wso2.carbon.registry.core.Collection innerCollection =
(org.wso2.carbon.registry.core.Collection) registry.get(streamNameCollection);
for (String streamVersionCollection : innerCollection.getChildren()) {

Resource resource = (Resource) registry.get(streamVersionCollection);
try {
StreamDefinition streamDefinition = EventDefinitionConverterUtils
.convertFromJson(RegistryUtils.decodeBytes((byte[]) resource.getContent()));
map.put(streamDefinition.getStreamId(), streamDefinition);
} catch (Throwable e) {
//log.error("Error in retrieving streamDefinition from the resource at "+ resource.getPath(), e);
}
}
}
}

} catch (RegistryException e) {
//log.error("Error in retrieving streamDefinitions from the registry", e);
}

//return map.values();
    Object[] array = map.values().toArray();

    out.print(array[0].toString());

%>

<div>
<h1>StreamDef</h1>
    <%
        out.print(array[0].toString());
    %>

</div>