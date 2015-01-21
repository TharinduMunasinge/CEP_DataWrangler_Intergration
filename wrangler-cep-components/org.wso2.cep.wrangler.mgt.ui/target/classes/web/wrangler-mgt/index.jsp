<%@include file="getStream.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<script>
    function getAllStreamJSON() {
        var jsonStream = <%=res%>;
        return jsonStream;
    }
    function checkStream(){
        return getAllStreamJSON().length;
    }
    function getStreamName(index){
        var jsonStream = getAllStreamJSON();
        return jsonStream[index].name;
    }
    function getStreamVersion(index){
        var jsonStream = getAllStreamJSON();
        return jsonStream[index].version;
    }
    function getPayloadNames(index){
        var jsonStream = getAllStreamJSON();
        var payloadNames = [];
        for(var i = 0 ; i < jsonStream[index].payloadData.length ; i++ ){
            payloadNames[i] = jsonStream[index].payloadData[i].name;
        }
        return payloadNames;
    }
    function getDataTypes(index){
        var jsonStream = getAllStreamJSON();
        var dataTypes = [];
        for(var i = 0 ; i < jsonStream[index].payloadData.length ; i++){
            dataTypes[i] = jsonStream[index].payloadData[i].type;
        }
        return dataTypes;
    }
    function sendDataTypes(){
        var index = document.getElementById("streamSelect").selectedIndex;
        var dataTypes =getDataTypes(index);
        var data="";
        for(var i = 0 ; i < dataTypes.length ; i++){
            data=data+" "+dataTypes[i];
        }
        alert(data);
    }
    function onchangeMenu(index){
        document.getElementById("wranglerIframe").src = "wrangler.html?selected="+index;
    }
</script>

<head>

    <script type="text/javascript" src="dw.js"></script>
</head>

<div>
    <select id="streamSelect" onchange="onchangeMenu(this.selectedIndex)">
        <script>
            var i =0;
            for(var i = 0 ; i < getAllStreamJSON().length ; i++) {
                var streamNameV = getStreamName(i).concat(" ",getStreamVersion(i));
                document.write("<option>"+streamNameV+"</option>");
            }
        </script>
    </select>
</div>
<iframe id="wranglerIframe" width="100%" height="500px" src="wrangler.html">

</iframe>

<div>
    <button onclick="setParams()" id="saveBtn" name="saveBtn">add Parameters</button>

    <script>
//        $(document).ready(function(){
//            $("#outputParams").submit(function(){
//                alert("got Here");
////            $("#outputParams").submit();
//                $.post($(this).attr('action'), $(this).serialize(), function(response){
//                    alert(response);
//                },'json');
//                return false;
//            })
//        });

        function saveScriptParams(){

            var streamName = document.getElementById("scriptId").value;
            var saveScript="";

            console.log(document.getElementById("wranglerIframe"));
            saveScript=document.getElementById("wranglerIframe").contentWindow.document.getElementById("wranglerInput").value;
            saveScript=saveScript.slice(16,saveScript.length-16);
            var funcDef = "function myfunction(x){\n\nw = dw.wrangle()\n\ninitial_transforms = dw.raw_inference(x).transforms;\n\nvar data =dv.table(x);\n\nif(initial_transforms){\ninitial_transforms.forEach(function(t){\nw.add(t);\n})\nw.apply([data]);\n\n}";
            var funcEnd = "w.apply([data])\n\nreturn dw.wrangler_export(data,{});\n}";
            saveScript = funcDef + saveScript + funcEnd;
            $.ajax({
                type:"POST",
                url: "save.jsp",
                data:{name:saveScript,fileName:streamName},
                error:function(a,b,c){
                    //  alert(a+"  "+b+" "+c);
                },
                success :function(s){
                    //    alert("Success");
                }
            });







            var numParams=parseInt(document.getElementById("numParams").value);
            console.log(numParams);
            var data=[];
            var paramToJson;
            var params;


            for(var j=1;j<numParams;j++){
                data[j-1]={name:document.getElementById("colInput"+j+"").value,type:document.getElementById("optionSelect"+j+"").value};

            }

            var version = document.getElementById("streamVer").value;

<<<<<<< HEAD
            saveScript=saveScript.slice(16,saveScript.length-16);
            var funcDef = "function myfunction(x){\n\nw = dw.wrangle()\n\ninitial_transforms = dw.raw_inference(x).transforms;\n\nvar data =dv.table(x);\n\nif(initial_transforms){\ninitial_transforms.forEach(function(t){\nw.add(t);\n})\nw.apply([data]);\n\n}";
            var funcEnd = "w.apply([data])\n\nreturn dw.wrangler_export(data,{});\n}";
=======
>>>>>>> 974d5a3ac5eb2ea6dcd7925376e435b2fcd42e9b

            console.log( data);
            params = {name:streamName,version:version,data:data};

            paramToJson=JSON.stringify(params);
            console.log(paramToJson);

            $.ajax({
                type:"POST",
                url: "formdata.jsp",
                data:{pname:paramToJson,fileName:streamName+"Params"},
                error:function(a,b,c){
                    //  alert(a+"  "+b+" "+c);
                },
                success :function(s){
                    //    alert("Success");
                }
            });

        }

    </script>

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
            <table id ="paramTable" style="width:60%" id="paramTable" class="styledLeft">
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


    <script>
        function setParams(){

            //setting table parameters
            var table = document.getElementById("paramTable");
            var tableBody = document.createElement('tbody');
            var oldTableBody = document.getElementById("paramTableBody");
            var temp=[];
            var arr = ["int","long","double","float","string","bool"];
            var input2 = document.createElement("input");
            input2.setAttribute('id',"numParams");
            input2.setAttribute('name',"numParams");
            input2.setAttribute('hidden',"true");
            temp=JSON.parse(localStorage["temp"]);
            input2.setAttribute('value',temp.length+"");
            for(var j=1;j<temp.length;j++){
                var tableRow = document.createElement("TR");
                var td = document.createElement('TD');
                td.setAttribute('id',"colName"+j+"");
                var tdI = document.createElement("TD");
                var tdList = document.createElement("TD");
                var tdListElement = document.createElement("select");
                var input = document.createElement("input");
                td.setAttribute('class','leftCol-med');
                input.setAttribute('id',"colInput"+j+"");
                input.setAttribute('name',"colInput"+j+"");
                input.setAttribute('type','text');
                input.setAttribute('class','initE')
                input.setAttribute('style','width:30%');
                tdI.appendChild(input);
                td.appendChild(document.createTextNode(temp[j]));
                tdListElement.setAttribute('id',"optionSelect"+j+"");
                tdListElement.setAttribute('name',"optionSelect"+j+"");
                for(var k=0;k<arr.length;k++){
                    var option = document.createElement("option");
                    option.value = arr[k];
                    option.text = arr[k];
                    tdListElement.appendChild(option);
                }
                tdList.appendChild(tdListElement);
                tableRow.appendChild(td);
                tableRow.appendChild(tdI);
                tableRow.appendChild(tdList);
                tableBody.setAttribute('id','paramTableBody');
                tableBody.appendChild(tableRow);
            }
            tableBody.appendChild(input2);
            table.replaceChild(tableBody,oldTableBody);
            console.log(temp);
            console.log("clicked");
        }
    </script>


</div>
