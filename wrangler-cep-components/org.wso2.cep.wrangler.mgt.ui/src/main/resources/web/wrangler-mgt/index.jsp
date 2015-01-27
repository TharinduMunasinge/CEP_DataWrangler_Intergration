<%@include file="getStream.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<div id="middle">

    <script>
        function getAllStreamJSON() {	//get stream as a JSON object
            var jsonStream = <%=res%>;
            return jsonStream;
        }
        function checkStream() {	//checks whether there streams in registry 
            return getAllStreamJSON().length;
        }
        function getStreamName(index) {
            var jsonStream = getAllStreamJSON();
            return jsonStream[index].name;
        }
        function getStreamVersion(index) {
            var jsonStream = getAllStreamJSON();
            return jsonStream[index].version;
        }
        function getPayloadNames(index) {
            var jsonStream = getAllStreamJSON();
            var payloadNames = [];
            for (var i = 0; i < jsonStream[index].payloadData.length; i++) {
                payloadNames[i] = jsonStream[index].payloadData[i].name;
            }
            return payloadNames;
        }
        function getDataTypes(index) {
            var jsonStream = getAllStreamJSON();
            var dataTypes = [];
            for (var i = 0; i < jsonStream[index].payloadData.length; i++) {
                dataTypes[i] = jsonStream[index].payloadData[i].type;
            }
        }
        function checkStream() {	//if there is no defined stream in CEP, 0 will return
            return getAllStreamJSON().length;
        }
        function getStreamName(index) {
            var jsonStream = getAllStreamJSON();
            return jsonStream[index].name;
        }
        function getStreamVersion(index) {
            var jsonStream = getAllStreamJSON();
            return jsonStream[index].version;
        }
        function getDataTypes(index) {	//string array of (STRING, INT, FLOAT, LONG, DOUBLE, BOOL)
            var jsonStream = getAllStreamJSON();
            var dataTypes = [];
            for (var i = 0; i < jsonStream[index].payloadData.length; i++) {
                dataTypes[i] = jsonStream[index].payloadData[i].type;
            }
            return dataTypes;
        }

        function onchangeMenu(index) {
            document.getElementById("paramArea").style.display = 'none';
            //document.getElementById("wranglerIframe").src = "wrangler.html?selected=" + index;
            var definition;
            if (index === -1) {
                definition = "";
            }
            else {
                definition = "define stream " + getStreamName(index) + " ( ";
                for (var i = 0; i < getPayloadNames(index).length; i++) {
                    definition += getPayloadNames(index)[i] +
                    " " + getDataTypes(index)[i];
                    if (i != getPayloadNames(index).length - 1)
                        definition += ",";
                }
                definition += " );";
            }
            document.getElementById("txtQuery").value = definition;
        }


        function onClickSubmit(definition) {
            document.getElementById("paramArea").style.display = 'none';
            if (isValidQuery(definition)) {
                document.getElementById("isValid").innerHTML = "";
                document.getElementById("wranglerIframe")
                        .src = "wrangler.html?query=" + definition;
            }
            else {
                document.getElementById("isValid").innerHTML = "*Invalid syntax";
            }
        }

        function onChangeText() {
            document.getElementById("streamSelect").selectedIndex = 0;
        }

        function getQuery() {
            return document.getElementById("txtQuery").value;
        }

        function isValidQuery(query) {
            /*regular expression for input stream definition*/
            var regExp = /^define(\n|\s|\t)+stream(\n|\s|\t)+\w(\.|\w)*\w(\n|\s|\t)*\(((\n|\s|\t)*\w+(\n|\s|\t)+(int|long|float|double|string|bool)(\n|\s|\t)*,)*((\n|\s|\t)*\w+(\n|\s|\t)+(int|long|float|double|string|bool)(\n|\s|\t)*)\)(\n|\s|\t)*;*(\n|\s|\t)*$/i;
            return regExp.test(query);
        }


    </script>
    <script>
        $(document).ready(regAccess(document.getElementById('folderTree').value);
    </script>

    <script type="text/javascript" src="dw.js"></script>

    <script>
        function regAccess(folderName) {
            var resultHTML = "";
            //alert(folderName);
            $.ajax({
                type: "POST",
                url: "registryAccess.jsp",
                data: {folderName: folderName},
                error: function (a, b, c) {
                    //  alert(a+"  "+b+" "+c);

                },
                success: function (s) {
                    $val = s.toString();
                    //           alert(s);
                    console.log(s);

                    var reg1 = /\<p[^>]*\>([^]*)\<\/p/m;
                    var reg2 = /\<code[^>]*\>([^]*)\<\/code/m
                    //             var result = $val.match( reg )[1];

                    var scriptText = $val.match(reg1)[1];

                    var configText = $val.match(reg2)[1];
                    //         alert(result);
                    console.log(scriptText);
                    console.log(configText);
                    document.getElementById("scriptTextArea").value = scriptText;
                    document.getElementById("configTextArea").value = configText;


//                    console.log(result);
//                    var parser = new DOMParser();
//                    var doc = parser.parseFromString(result,"text/xml");
//                    console.log(doc);

                }
            });
        }

    </script>

    <h2>Data Wrangler</h2>

    <div>  <!-- Existing config section begin -->
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
                                    org.wso2.carbon.registry.api.Collection collection = (org.wso2.carbon.registry.api.Collection) resp;

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
                                } catch (Exception e) {

                                }
                            }
                            ;%>
                    </select>
                </form><br>
		<h5 style="display:inline;">Script</h5>
		<h5 style="display:inline;margin-left: 468px;">Definition</h5>
            </div>
            

            <div>
                <textarea id="scriptTextArea" style="display: inline;height: 50px;margin-right: 6px;width: 42%">
                </textarea>

                <textarea id="configTextArea" style="height: 50px;width: 46%;margin-left: 76px;"></textarea><br>
                <button onclick="" style="float: right; margin-right: 20px;">copy</button>


            </div>
        </div>
    </div> <!-- Existing config section end -->

    <div>     <!-- new config section begin -->
        <div>
	    <h1 >&nbsp</h1>
            <h3 style="padding-bottom: 5px;border-bottom: solid 1px #96A9CA; color: #0D4d79;" ;>
                <small>-Create new Configuration-</small>
            </h3>
            <div style="float: left;width: 410px;border: solid 1px #cccccc;margin-left: 7px;
		margin: 3px;border-bottom-style: ridge;border-width: 1px;padding: 5px 5px;">

                <h4 style="display: inline; color: #1c94c4">

                    <small>Import Stream Definition:</small>
                </h4>
                <select id="streamSelect" onchange="onchangeMenu(this.selectedIndex-1)">


                    <script>
                        document.write("<option>--select any stream--</option>");
                        for (var i = 0; i < getAllStreamJSON().length; i++) {
                            var streamNameV = getStreamName(i).concat(" ", getStreamVersion(i));
                            document.write("<option>" + streamNameV + "</option>");
                        }
                    </script>
                </select>

                <!--div>
                    <ol style="list-style-position: inside; margin-top: 6px">
                        <li>Select the stream defintion you want to wrangle</li>
                        <li>Click the "Wrangle" button to wrangle sample data set</li>
                        <li>Do whatever the transformations you need in wrangler interface</li>
                        <li>Click the "PROCEED" button in wrangle interface</li>
                        <li>Fill the output definition details</li>
                        <li>Click the "Done" button to save the configuration</li>
                    </ol>
                </div-->
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
                                onclick="onClickSubmit(document.getElementById('txtQuery').value);">Submit
                        </button>
                        <label id="isValid" style="color:#FF0000; padding-left: 16px;"></label>
                    </form>

                </div>

            </div>
        </div>
        <div id="paramArea"

             style="border: solid 1px #cccccc;padding: 5px 10px;float: right;width: 466px;
			display: none;border-bottom-style: ridge;border-width: 1px;margin: 3px;">

            <form name="outparamForm" id="outputParams" method="post" action="formdata.jsp">
                <table border="0">
                    <tr>
                        <td>
                            Event Stream Name
                            <span class="required">*</span>
                        </td>
                        <td>
                            <input type="text" required='true' name="scrpitName" id="streamName" class="initE"
                                   style="width:130px; margin-right: 12px">

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
        </div>
    </div> <!-- new config section end -->



    <iframe id="wranglerIframe" width="100%" height="500px" src="wrangler.html"
            style="margin-top: 5px;">

    </iframe>

    <div>

        <script>
            //            function test(){
            //                $.ajax({
            //                    type: "POST",
            //                    url: "registryAccess.jsp",
            //                    data: {name: "test"},
            //                    error: function (a, b, c) {
            //                        alert(a+"  "+b+" "+c);
            //
            //                    },
            //                    success: function (s) {
            //                        alert(s);
            //                    }
            //                });
            //            }

            //function for saving form parameters

            var isSaveToReg;

            function saveScriptParams(isPersist) {

                isSaveToReg = false;

                var streamName = document.getElementById("streamName").value;
                var saveScript = "";

                console.log(document.getElementById("wranglerIframe"));
                saveScript = document.getElementById("wranglerIframe").contentWindow.exportedValue;
                // alert(saveScript);

                saveScript = saveScript.slice(16, saveScript.length - 16);
                var funcDef = "function myfunction(x){" +
                        "\n\nw = dw.wrangle()" +
                        "\n\ninitial_transforms = dw.raw_inference(x).transforms;" +
                        "\n\nvar data =dv.table(x);" +
                        "\n\nif(initial_transforms){" +
                        "\ninitial_transforms.forEach(function(t){" +
                        "\nw.add(t);" +
                        "\n})\nw.apply([data]);" +
                        "\n\n}";

                var funcEnd = "w.apply([data])" +
                        "\n\nreturn dw.wrangler_export(data,{});" +
                        "\n}";
                saveScript = funcDef + saveScript + funcEnd;


                var numParams = parseInt(document.getElementById("numParams").value);
                console.log(numParams);
//                var data = [];
//                var paramToJson;
                var params;
                var paramString = "define stream ";

//define stream <nameOfTheStream> ( <attribute1Name> <attribute1Type>, <attribute1Name> <attribute1Type> .....)
                paramString += streamName + "(";

                for (var j = 1; j < numParams; j++) {

                    var name = document.getElementById("colInput" + j + "").value;
                    var type = document.getElementById("optionSelect" + j + "").value;

                    paramString += name + " " + type + ",";
                }

                paramString = paramString.substring(0, paramString.length - 1);
                paramString += ")";

                //             var version = document.getElementById("streamVer").value;


//                console.log(data);
//                params = {name: streamName, version: version, data: data};
//
//                paramToJson = JSON.stringify(params);
//                console.log(paramToJson);

                if (isPersist) {
                    CARBON.showConfirmationDialog("Do you want to save scripts in Registry?", function () {
                        saveToRegistry(saveScript, streamName, paramString)
                    }, null, null);
                } else {
                    document.getElementById("scriptTextArea").value = saveScript;
                    document.getElementById("configTextArea").value = paramString;
                }

            }

            function setSaveToReg(input) {
                alert(input)
            }


            function saveToRegistry(saveScript, streamName, paramString) {

                var isSuccess = false;

                $.ajax({
                    type: "POST",
                    url: "formdata.jsp",
                    data: {formdata: paramString, fileName: streamName},
                    error: function (a, b, c) {
                        //  alert(a+"  "+b+" "+c);
                        isSuccess = false;

                    },
                    success: function (s) {
                        //    alert("Success");
                        isSuccess = true;
                    }
                });


                $.ajax({
                    type: "POST",
                    url: "save.jsp",
                    data: {name: saveScript, streamName: streamName},
                    error: function (a, b, c) {
                        //  alert(a+"  "+b+" "+c);
                        CARBON.showErrorDialog("Error occured in saving script");

                    },
                    success: function (s) {
                        //    alert("Success");
                        CARBON.showInfoDialog("script successfully saved into registry", function () {
                            reloadOutputStreams();
                        });

                    }
                });

            }


            function copyToClipboard() {

            }

            function reloadOutputStreams() {
                console.log("refreshed");
                document.getElementById("submit_form").submit();
//                var content = container.innerHTML;
//                console.log(content);
//                container.innerHTML = content;
            }

        </script>


        <script>

            //function for tabulate the rows to get parameter data
            function setParams() {

                //setting table parameters
                var table = document.getElementById("paramTable");
                var tableBody = document.createElement('tbody');
                var oldTableBody = document.getElementById("paramTableBody");
                var temp = [];

                var input2 = document.createElement("input");

                input2.setAttribute('id', "numParams");
                input2.setAttribute('name', "numParams");
                input2.setAttribute('hidden', "true");
                temp = JSON.parse(localStorage["temp"]);
                input2.setAttribute('value', temp.length + "");

                for (var j = 1; j < temp.length; j++) {

                    var tableRow = document.createElement("TR");
                    var td = document.createElement('TD');
                    td.setAttribute('id', "colName" + j + "");
                    var tdI = document.createElement("TD");
                    var tdList = document.createElement("TD");
                    var tdListElement = document.createElement("select");
                    var input = document.createElement("input");

                    td.setAttribute('class', 'leftCol-med');
                    input.setAttribute('id', "colInput" + j + "");
                    input.setAttribute('name', "colInput" + j + "");
                    input.setAttribute('type', 'text');
                    input.setAttribute('class', 'initE')
                    input.setAttribute('style', 'width:100%');
                    input.setAttribute('required', 'true');
                    tdI.appendChild(input);
                    td.appendChild(document.createTextNode(temp[j]));
                    tdListElement.setAttribute('id', "optionSelect" + j + "");
                    tdListElement.setAttribute('name', "optionSelect" + j + "");

                    var optionArr = [];
                    optionArr = setColumnTypes(j - 1);
                    console.log(optionArr);
                    console.log(optionArr.length);


                    for (var k = 0; k < optionArr.length; k++) {
                        var option = document.createElement("option");
                        option.value = optionArr[k];
                        option.text = optionArr[k];
                        tdListElement.appendChild(option);
                    }
                    tdList.appendChild(tdListElement);
                    tableRow.appendChild(td);
                    tableRow.appendChild(tdI);
                    tableRow.appendChild(tdList);
                    tableBody.setAttribute('id', 'paramTableBody');
                    tableBody.appendChild(tableRow);
                }
                tableBody.appendChild(input2);
                table.replaceChild(tableBody, oldTableBody);
                console.log(temp);
                console.log("clicked");
            }

            function setColumnTypes(i) {

                var colTypes = document.getElementById("wranglerIframe").contentWindow.colDataType;
                var options;

                if (colTypes[i] === "int") {
                    options = ["int", "long"];
                    return options;
                }
                else if (colTypes[i] === "number") {
                    options = ["int", "double", "float", "long"];
                    return options;
                }
                else if (colTypes[i] === "string") {
                    options = ["string", "bool"];
                    return options;
                }
                else {				//country, cities, tags
                    options = ["string"];
                    return options;

                }
            }
        </script>


    </div>
</div>


