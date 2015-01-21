<%@include file="getStream.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<div id="middle">

    <script>
        function getAllStreamJSON() {
            var jsonStream = <%=res%>;
            return jsonStream;
        }
        function checkStream() {
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
        function checkStream() {
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
        function getDataTypes(index) {
            var jsonStream = getAllStreamJSON();
            var dataTypes = [];
            for (var i = 0; i < jsonStream[index].payloadData.length; i++) {
                dataTypes[i] = jsonStream[index].payloadData[i].type;
            }
            return dataTypes;
        }
        function sendDataTypes() {
            var index = document.getElementById("streamSelect").selectedIndex;
            var dataTypes = getDataTypes(index);
            var data = "";
            for (var i = 0; i < dataTypes.length; i++) {
                data = data + " " + dataTypes[i];
            }
            alert(data);
        }
        function onchangeMenu(index) {
            document.getElementById("wranglerIframe").src = "wrangler.html?selected=" + index;
        }
    </script>
    <script type="text/javascript" src="dw.js"></script>
    <%--<head>--%>

    <%--<script type="text/javascript" src="dw.js"></script>--%>
    <%--</head>--%>


    <h2>Data Wrangler</h2>

    <div>
        <div>
            <div style="float: left;width: 410px;border: 0.5px solid #CCC;margin-left: 7px;margin: 3px;border-bottom-style: ridge;border-width: 2px;padding: 5px 5px;">
                <h3 style="display: inline; color: #1c94c4">
                    <small>Input Stream Definition</small>
                </h3>
                <select id="streamSelect" onchange="onchangeMenu(this.selectedIndex)">
                    <script>
                        var i = 0;
                        for (var i = 0; i < getAllStreamJSON().length; i++) {
                            var streamNameV = getStreamName(i).concat(" ", getStreamVersion(i));
                            document.write("<option>" + streamNameV + "</option>");
                        }
                    </script>
                </select>

                <div>
                    <ol>
                        <li>Select the stream defintion you want to wrangle</li>
                        <li>Click the "Wrangle" button to wrangle sample data set</li>
                        <li>Do whatever the transformations you need in wrangler interface</li>
                        <li>Click the "PROCEED" button in wrangle interface</li>
                        <li>Fill the output definition details</li>
                        <li>Click the "Done" button to save the configuration</li>
                    </ol>
                </div>
            </div>
            <div id="paramArea"
                 style="border: 0.5px solid #CCC;padding: 5px 10px;float: right;width: 500px;display: none;border-bottom-style: ridge;border-width: 2px;">
                <form name="outparamForm" id="outputParams" method="post" action="formdata.jsp">
                    <table border="0">
                        <tr>
                            <td>
                                Stream Name:
                                <span class="required">*</span>
                            </td>
                            <td>
                                <input type="text" name="scrpitName" id="scriptId" class="initE">

                                <div class="sectionHelp">
                                    Name of the script
                                </div>

                            </td>
                        </tr>
                        <td>
                            Stream Version:
                        </td>
                        <td>
                            <input type="text" name="streamVersion" id="streamVer" class="initE">

                            <div class="sectionHelp">
                                Version of the Stream
                            </div>

                        </td>

                        <tr>

                        </tr>
                    </table>


                    <div id="workArea">
                        <table id="paramTable" style="width:60%" id="paramTable" class="styledLeft">
                            <thead>
                            <tr>
                                <th width="30%">Column Name</th>
                                <th width="30%">Parameter name</th>
                                <th width="30%">Parameter Type</th>
                            </tr>
                            </thead>

                            <tbody id="paramTableBody">
                            </tbody>
                        </table>

                        <input type="button" onclick="saveScriptParams()" value="Save">

                    </div>
                </form>
            </div>
        </div>

    </div>

    <div id="transparent">

    </div>

    <iframe id="wranglerIframe" width="100%" height="500px" src="wrangler.html" style="margin-top: 5px;">

    </iframe>

    <div>


        <script>

            function saveScriptParams() {

                var streamName = document.getElementById("scriptId").value;
                var saveScript = "";

                console.log(document.getElementById("wranglerIframe"));
                saveScript = document.getElementById("wranglerIframe").contentWindow.exportedValue;
                alert(saveScript);
                saveScript = saveScript.slice(16, saveScript.length - 16);
                var funcDef = "function myfunction(x){\n\nw = dw.wrangle()\n\ninitial_transforms = dw.raw_inference(x).transforms;\n\nvar data =dv.table(x);\n\nif(initial_transforms){\ninitial_transforms.forEach(function(t){\nw.add(t);\n})\nw.apply([data]);\n\n}";
                var funcEnd = "w.apply([data])\n\nreturn dw.wrangler_export(data,{});\n}";
                saveScript = funcDef + saveScript + funcEnd;
                $.ajax({
                    type: "POST",
                    url: "save.jsp",
                    data: {name: saveScript, streamName: streamName},
                    error: function (a, b, c) {
                        //  alert(a+"  "+b+" "+c);
                    },
                    success: function (s) {
                        //    alert("Success");
                    }
                });


                var numParams = parseInt(document.getElementById("numParams").value);
                console.log(numParams);
                var data = [];
                var paramToJson;
                var params;


                for (var j = 1; j < numParams; j++) {
                    data[j - 1] = {
                        name: document.getElementById("colInput" + j + "").value,
                        type: document.getElementById("optionSelect" + j + "").value
                    };

                }

                var version = document.getElementById("streamVer").value;


                console.log(data);
                params = {name: streamName, version: version, data: data};

                paramToJson = JSON.stringify(params);
                console.log(paramToJson);

                $.ajax({
                    type: "POST",
                    url: "formdata.jsp",
                    data: {pname: paramToJson, fileName: streamName},
                    error: function (a, b, c) {
                        //  alert(a+"  "+b+" "+c);
                    },
                    success: function (s) {
                        //    alert("Success");
                    }
                });

            }

        </script>


        <script>
            function setParams() {

                //setting table parameters
                var table = document.getElementById("paramTable");
                var tableBody = document.createElement('tbody');
                var oldTableBody = document.getElementById("paramTableBody");
                var temp = [];
                var arr = ["int", "long", "double", "float", "string", "bool"];
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
                    input.setAttribute('style', 'width:30%');
                    tdI.appendChild(input);
                    td.appendChild(document.createTextNode(temp[j]));
                    tdListElement.setAttribute('id', "optionSelect" + j + "");
                    tdListElement.setAttribute('name', "optionSelect" + j + "");
                    for (var k = 0; k < arr.length; k++) {
                        var option = document.createElement("option");
                        option.value = arr[k];
                        option.text = arr[k];
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
        </script>


    </div>
</div>


