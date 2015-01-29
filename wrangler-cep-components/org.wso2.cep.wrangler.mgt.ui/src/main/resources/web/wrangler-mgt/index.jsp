<%@include file="getStream.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

    <script>
        function getAllStreamJSON() {	//get stream as a JSON object
            var jsonStream = <%=res%>;
            return jsonStream;
        }
    </script>
<script type="text/javascript" src = "dw.js"></script>
<script type="text/javascript" src="wranglerUIHandler.js"></script>

<div id="middle">



    <h2>Data Wrangler</h2>

    <!-- Existing config section begin -->
    <div id="existing_config">
	<h3 style="display: inline; color: #0D4d79;">

                    <small>-Existing Configurations-</small>
                </h3>
        <div style="float: left;width: 984px;border: solid 1px #cccccc;margin-left: 7px;
		margin: 3px;border-bottom-style: ridge;border-width: 1px;padding: 5px 5px;">
            <div id="submit_form_div">

                
                <form method="get" id="submit_form" style="padding-top: 20px;">
                    <h4 style="display: inline; color: #1c94c4">
                        <small>Load Configuration:</small>
                    </h4>
			
		 <!--directory structure at org.wso2.cep.wrangler-->
                    <select id="folderTree" style="display: inline" name="folderName"
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

                                    //     response.setContentType("text/plain");

                                    String[] resources;
                                    resources = collection.getChildren();

                        %>
                        <option>--select any configuration--</option>
                        <% for (String resrc : resources) {
                            resrc = resrc.replace(BASEURL, "");%>
                        <option><%=resrc%>
                        </option>

                        <%
                                    }
                                } catch (RegistryException e) {

                                }
                            }
                            ;%>
                    </select>
                </form><br>
		<h5 style="display:inline;">Wrangling Script</h5>
		<h5 style="display:inline;margin-left: 468px;">Output Definition</h5>
            </div>
            

            <div>
		<!--Script area -->
                <textarea id="scriptTextArea" style="display: inline;height: 50px;margin-right: 
		6px;width: 42%" readonly>
                </textarea>
		<!--Definition area-->
                <textarea id="configTextArea"  name= "configTextArea" style="height: 50px;width:
		 46%;margin-left: 76px;" readonly>
		</textarea><br>
		<p id="targetCopyText" style="display: none">Text copied.</p>
                <button id ="copyBtn" onclick="" data-clipboard-target="configTextArea"
		 style="float: right; margin-right: 20px;">copy to Clipboard</button>

            </div>
        </div>
    </div> <!-- Existing config section end -->

    <!-- new config section begin -->
    <div id="new_cofig">
        <div>
	    <h1 >&nbsp</h1>
            <h3 style="padding-bottom: 5px;border-bottom: solid 1px #96A9CA; color: #0D4d79;" ;>
                <small>-Create new Configuration-</small>
            </h3>
            <div style="float: left;width: 410px;border: solid 1px #cccccc;margin-left: 7px;
		margin: 3px;border-bottom-style: ridge;border-width: 1px;padding: 5px 5px;">

                <h4 style="display: inline; color: #1c94c4">

                    <small>Import Input Stream:</small>
                </h4>
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

               
                <br>
                <h4 style="padding-left: 96px; margin-top: 10px; margin-bottom: 10px;">
                    <small>or</small>
                </h4>
                <h4 style="display: inline; color: #1c94c4">

                    <small>Type new Definition:</small>
                </h4>

                <div style="float: left;width: 390px;border: 0.5px solid #CCC;margin-left: 7px;
		margin: 3px; padding: 5px 5px;">
                    <form>
                        <textarea id="txtQuery" style="margin: 3px; height: 58px; width: 375px;"
                                  onchange="onChangeText()"></textarea><br>
                        <button type="button" id="submit" style="margin: 3px;"
                                onclick="onClickPushToWrangler(document.getElementById('txtQuery').value);">
				Push to Wrangle
                        </button>
                        <label id="isValid" style="color:#FF0000; padding-left: 16px;"></label>
                    </form>

                </div>

            </div>
        </div>


    </div> <!-- new config section end -->


    <div id="wrangler" style="display: none;">
    	<iframe id="wranglerIframe" width="100%" height="500px" src="wrangler.html"
            style="margin-top: 5px;">

    	</iframe>
    </div>

    <!--output cofiguration table area begin-->
    <div id="paramArea"

         style="border: solid 1px #cccccc;padding: 5px 10px;float: right;width: 466px;
			display: none;border-bottom-style: ridge;border-width: 1px;margin: 3px;">

        <form name="outparamForm" id="outputParams" method="post" action="formdata.jsp">
            <table border="0">
                <tr>
                    <td>
                        Output Configuration Name
                        <span class="required">*</span>
                    </td>
                    <td>
                        <input type="text" required='true' name="scrpitName" id="streamName"
                               class="initE" style="width:130px; margin-right: 12px">

                        <div class="sectionHelp">
                            Stream Name
                        </div>


                    </td>


                </tr>
            </table>


            <div id="workArea" style="padding: 0px">
                <table id="paramTable" style="width:100%;margin-bottom: 7px"
                       class="styledLeft">

                    <thead>
                    <tr>
                        <th width="30%">Column Name</th>
                        <th width="30%">Parameter name</th>
                        <th width="30%">Parameter Type</th>
                    </tr>
                    </thead>
                    <%--</table>--%>
                    <%--<div id="scrollTable" style="overflow-y: auto ; height: 100px">--%>
                    <%--<table id="paramTable" class="styledLeft" style="width:64%">--%>
                    <%--<thead style="height: 0px">--%>
                    <%--<tr>--%>
                    <%--<th width="30%"></th>--%>
                    <%--<th width="30%"></th>--%>
                    <%--<th width="30%"></th>--%>
                    <%--</tr>--%>
                    <%--</thead>--%>
                    <tbody id="paramTableBody">
                    </tbody>
                </table>
                <%--</div>--%>

                <input type="button" onclick="saveScriptParams(true)" value="Save to Registry"
                       style="margin-bottom: 3px;display: inline;margin-left: 2px;">
                <input type="button" onclick="saveScriptParams(false)" value="copy to workspace"
                       style="margin-bottom: 3px;margin-left: 48px;">

            </div>
        </form>

    </div><!-- output configuration table area end -->

    <div>

    </div>
</div>


