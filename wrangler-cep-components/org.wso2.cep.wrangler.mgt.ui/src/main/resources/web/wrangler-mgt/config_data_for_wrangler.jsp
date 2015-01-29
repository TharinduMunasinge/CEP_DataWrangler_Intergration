<%@include file="getStream.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<script type="text/javascript" src="dw.js"></script>
<script type="text/javascript" src="wranglerUIHandler.js"></script>
<script type="text/javascript" src="test/wso2_sample_gen.js"></script>

<script>
    function getAllStreamJSON() {	//get stream as a JSON object
        var jsonStream = <%=res%>;
        return jsonStream;
    }


</script>

<div id="middle">
    <h2>Data Wrangler</h2>
    <!--start of workArea div-->
    <div id="workArea">
        <!--Start of Existing Configuration Preview-->
        <table id="previewTable" class="styledLeft" width="100%">
            <thead>
            <tr>
                <th>
                    Existing Configurations
                </th>
            </tr>
            </thead>

            <tbody>
            <tr>
                <td class="formRaw">
                    <table id="previewInputTable" class="normal-nopadding" width="100%">
                        <tbody>
                        <tr>
                            <td>Load Configuration</td>
                            <td>
                                <select id="folderTree"
                                        onchange="regAccess(document.getElementById('folderTree').value)">
                                    <% String BASEURL = "/repository/components/org.wso2.cep.wrangler/";

                                        CarbonContext cntx = CarbonContext.getCurrentContext();
                                        Registry registry = cntx.getRegistry(RegistryType.SYSTEM_CONFIGURATION);
                                        String registryType = RegistryType.SYSTEM_GOVERNANCE.toString();
                                        if (registryType != null) {
                                            registry = cntx.getRegistry(RegistryType.valueOf(registryType));

                                            try {
                                                Resource resp = (Resource) registry.get(BASEURL);
                                                org.wso2.carbon.registry.api.Collection collection =
                                                        (org.wso2.carbon.registry.api.Collection) resp;
                                                String[] resources;
                                                resources = collection.getChildren();

                                    %>
                                    <option>--select any configuration--</option>
                                    <%for (int i=0; i<resources.length; i++) {
                                            resources[i] = resources[i].replace(BASEURL, "");%>
                                    <option><%=resources[i]%>
                                    </option>

                                    <%
                                                }
                                            } catch (RegistryException e) { //handle

                                            }
                                        }
                                        ;%>

                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftcol-small">Output Stream Definition</td>
                            <td>
                                <textarea id="configTextArea" class="expandedTextarea" cols="80"
                                          readonly="true" style="height: 60px"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftcol-small">
                                Generated Script
                            </td>
                            <td>
                                <textarea id="scriptTextArea" class="expandedTextarea" cols="80"
                                          readonly="true" style="height: 90px"></textarea>
                            </td>
                        </tr>
                        <%--<tr>--%>
                            <%--<td colspan="3" class="middle-header">Create new Configuration</td>--%>
                        <%--</tr>--%>
                        <%--<tr>--%>
                            <%--<td>Import Stream Definition</td>--%>
                            <%--<td>--%>
                                <%--<select id="streamSelect" onchange="onchangeMenu(this.selectedIndex-1)">--%>

                                    <%--<!--generate stream name for the drop down list-->--%>
                                    <%--<script>--%>
                                        <%--document.write("<option>--select any stream--</option>");--%>
                                        <%--for (var i = 0; i < getAllStreamJSON().length; i++) {--%>
                                            <%--var streamNameV = getStreamName(i).concat(" ", getStreamVersion(i));--%>
                                            <%--document.write("<option>" + streamNameV + "</option>");--%>
                                        <%--}--%>
                                    <%--</script>--%>
                                <%--</select>--%>
                            <%--</td>--%>
                        <%--</tr>--%>
                        <%--<tr>--%>
                            <%--<td>--%>
                                <%--Type new Definition:--%>
                            <%--</td>--%>
                            <%--<td></td>--%>
                        <%--</tr>--%>
                        </tbody>
                    </table>
                </td>
            </tr>
            </tbody>
        </table>
        <!--End of Existing Configuration Preview-->

        <!--Link to add New Configuration-->
        <div class="icon-link-ouside registryWriteOperation">
            <a href="#" class="icon-link" style="background-image:url(../wrangler-mgt/images/add.gif);" onclick="onClickAddNewConfig();">Add New Configuration</a>
            <div style="clear:both"></div>
        </div>


        <!--start of creating new configuration-->
        <div id="newConfigDiv" style="display: none">
            <form id="form_config" method="post" action="wrangler.jsp">
                <table cellpadding="0" cellspacing="0" border="0" class="styledLeft noBorders">
                    <thead>
                        <tr>
                            <th colspan="2">Create New Configuration</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="formRaw">
                                <table id="newConfigTable" name="newConfig" class="normal-nopadding" width="100%">
                                    <tbody>
                                        <tr>
                                            <td class="leftcol-small">
                                                Import Input Stream Definition
                                            </td>
                                            <td>
                                                <select id="streamSelect" onchange="onchangeMenu(this.selectedIndex-1)">

                                                    <!--generate stream name for the drop down list-->
                                                    <script>
                                                        document.write("<option>--select any stream--</option>");
                                                        for (var i = 0; i < getAllStreamJSON().length; i++) {
                                                            var streamNameV = getStreamName(i).concat(" ", getStreamVersion(i));
                                                            document.write("<option>" + streamNameV + "</option>");
                                                        }
                                                    </script>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>OR</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td class="leftcol-small">
                                                Type New Input Stream Definition
                                            </td>
                                            <td>
                                                <textarea id="txtQuery" class="expandedTextarea" cols="80"
                                                           style="height: 60px" onchange="onChangeText()"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="leftCol-small"></td>
                                            <td> <label id="isValid" style="color:#FF0000;"></label></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="buttonRow">
                                                <input id="1" type="radio" name="populateTypeBtn" value="real data" onclick=
                                                        "document.getElementById('dataPopulatedArea').readOnly=false;document.getElementById('dataPopulatedArea').focus();">
                                                <label>Real Data</label>
                                                <input id="2" type="radio" name="populateTypeBtn" value="sample data" onclick=
                                                        "onClickPushToWrangler(document.getElementById('txtQuery').value);document.getElementById('dataPopulatedArea').readOnly=true;">
                                                <label>Populate Sample Data</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="leftcol-small"></td>
                                            <td>
                                                <textarea id="dataPopulatedArea" value="ttt" name="dataArea"class="expandedTextarea" readonly cols="80"
                                                           style="height: 90px"></textarea></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="buttonRow">
                                                <input type="submit" value="wrangle">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
        <!--end of creating new configuration-->
    </div>
    <!--end of workArea div-->

</div>