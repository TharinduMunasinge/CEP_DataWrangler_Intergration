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
		if(index===-1){
			definition = "";
		}
		else{
	   		definition = "define stream "+getStreamName(index)+" ( ";
			for(var i=0; i<getPayloadNames(index).length; i++){
				definition+=getPayloadNames(index)[i]+
					" "+getDataTypes(index)[i];
				if(i != getPayloadNames(index).length-1)
					definition += ",";
			}
			definition += " );";
		}
		document.getElementById("txtQuery").value=definition;
        }
	
	function onClickSubmit(definition){
		document.getElementById("paramArea").style.display = 'none';
		if(isValidQuery(definition)){
			document.getElementById("isValid").innerHTML="";
			document.getElementById("wranglerIframe")
			.src = "wrangler.html?query=" + definition;
		}
		else{
			document.getElementById("isValid").innerHTML="*Invalid syntax";
		}
	}

	function onChangeText(){
		document.getElementById("streamSelect").selectedIndex=0;
	}
	
	function getQuery(){
		return document.getElementById("txtQuery").value;	
	}

	function isValidQuery(query){
		/*regular expression for input stream definition*/
		var regExp=/^define(\n|\s|\t)+stream(\n|\s|\t)+\w+(\n|\s|\t)*\(((\n|\s|\t)*\w+(\n|\s|\t)+(int|long|float|double|string|bool)(\n|\s|\t)*,)*((\n|\s|\t)*\w+(\n|\s|\t)+(int|long|float|double|string|bool)(\n|\s|\t)*)\)(\n|\s|\t)*;*(\n|\s|\t)*$/i;
		return regExp.test(query);
	}	
    </script>
    <script type="text/javascript" src="dw.js"></script>

    <h2>Data Wrangler</h2>

    <div>
        <div>

            <div style="float: left;width: 410px;border: 0.5px solid #CCC;margin-left: 7px;
		margin: 3px;border-bottom-style: ridge;border-width: 2px;padding: 5px 5px;">
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
			<textarea id="txtQuery" style="margin: 3px; height: 58px; width: 375px;" onchange="onChangeText()"></textarea><br>
			<button type="button" id="submit" style="margin: 3px;" onclick="onClickSubmit(document.getElementById('txtQuery').value);">Submit</button>
			<label id="isValid" style="color:#FF0000; padding-left: 16px;"></label>
		</form>
		
	    	</div>
		
            </div>
	    
            <div id="paramArea"

                 style="border: 0.5px solid #CCC;padding: 5px 10px;float: right;width: 500px;
			display: none;border-bottom-style: ridge;border-width: 2px;">

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
                            <td>
                                Event Stream Version:
                            </td>
                            <td>
                                <input type="text" required='true' name="streamVersion" id="streamVer" class="initE"
                                       style="width:70px">

                                <div class="sectionHelp">
                                    (eg:1.0.0)
                                </div>

                            </td>

                        </tr>
                    </table>



                    <div id="workArea" style="padding: 0px">
                        <table id="paramTable" style="width:64%;margin-bottom: 7px" 
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

                            <input type="button" onclick="saveScriptParams()" value="Done"
                                   style="margin-bottom: 3px;display: inline">
                            <input type="button" onclick="" value="Back to Wrangling" style="margin-bottom: 3px">

                    </div>
                </form>
            </div>
        </div>
	

    </div>

    <div id="transparent">

    </div>

    <iframe id="wranglerIframe" width="100%" height="500px" src="wrangler.html" 
		style="margin-top: 5px;">

    </iframe>

    <div>


        <script>
            //function for saving form parameters
            function saveScriptParams() {

                var streamName = document.getElementById("streamName").value;
                var saveScript = "";

                console.log(document.getElementById("wranglerIframe"));
                saveScript = document.getElementById("wranglerIframe").contentWindow.exportedValue;
                // alert(saveScript);

                saveScript = saveScript.slice(16, saveScript.length - 16);
                var funcDef = "function myfunction(x){"+
				"\n\nw = dw.wrangle()"+
				"\n\ninitial_transforms = dw.raw_inference(x).transforms;"+
				"\n\nvar data =dv.table(x);"+
				"\n\nif(initial_transforms){"+
					"\ninitial_transforms.forEach(function(t){"+
						"\nw.add(t);"+
					"\n})\nw.apply([data]);"+
					"\n\n}";
                var funcEnd = 	"w.apply([data])"+
				"\n\nreturn dw.wrangler_export(data,{});"+
			      "\n}";
                saveScript = funcDef + saveScript + funcEnd;
                $.ajax({
                    type: "POST",
                    url: "save.jsp",
                    data: {name: saveScript, streamName: streamName},
                    error: function (a, b, c) {
                        //  alert(a+"  "+b+" "+c);
                        CARBON.showErrorDialog("Error occured");

                    },
                    success: function (s) {
                        //    alert("Success");
                        CARBON.showInfoDialog("script successfully saved into registry");
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

            //function for tabulate the rows to get parameter data
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
                    input.setAttribute('style', 'width:100%');
                    input.setAttribute('required', 'true');
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


