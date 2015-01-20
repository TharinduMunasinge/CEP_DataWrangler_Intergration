<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<head>

    <script type="text/javascript" src="dw.js"></script>
</head>



<div id="middle">
    <h2 id="wranglerHeader">Data Wrangler </h2>

<div>


<iframe id="pc" width="100%" height="400px" src="wrangler.html"
   >
</iframe>
</div>

  <!--<form action="getStream.jsp" method="post"  >
      <input type="text" hidden="true" name="nm" value="Nisla Niroshana Nanayakkara"> </input>
     <input type="submit" value="Save Script"> </input>
  </form>-->

    <div>
        <button onclick="saveScript()" id="saveBtn" name="saveBtn">Save Script</button>

        <script>
         $(document).ready(function(){
         $("#outputParams").submit(function(){
             alert("got Here");
//            $("#outputParams").submit();
             $.post($(this).attr('action'), $(this).serialize(), function(response){
                 alert(response);
             },'json');
             return false;
            })
            });
        </script>

        <form name="outparamForm" id="outputParams" method="post" action="formdata.jsp">
        <table border="0">
            <tr>
                <td>

                </td>
                <td>
                    Script Name:
                    <span class="required">*</span>
                </td>
                <td>
                    <input type="text" name="scrpitName" id="scriptId" class="initE">

                    <div class="sectionHelp">
                        Name of the script
                    </div>

                </td>
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

           <input type="submit" value="Save">
    </div>
    </form>


    <script>
        function saveScript(){

            var saveScript="";
            saveScript=document.getElementById("pc").contentWindow.document.getElementById("wranglerInput").value;

            saveScript=saveScript.slice(16,saveScript.length-16);
            var funcDef = "function myfunction(x){\n\nw = dw.wrangle()\n\ninitial_transforms = dw.raw_inference(x).transforms;\n\nvar data =dv.table(x);\n\nif(initial_transforms){\ninitial_transforms.forEach(function(t){\nw.add(t);\n})\nw.apply([data]);\n\n}";
            var funcEnd = "w.apply([data])\n\nreturn dw.wrangler_export(data,{format:'rowjson'});\n}";

            saveScript = funcDef + saveScript + funcEnd;

            $.ajax({
                type:"POST",
                url: "save.jsp",
                data:{name:saveScript},
                error:function(a,b,c){
                  //  alert(a+"  "+b+" "+c);
                },
                success :function(s){
                    //    alert("Success");
                }
            });

            //getting table parameters
                            var table = document.getElementById("paramTable");
                            var tableBody = document.createElement('tbody');
                            var oldTableBody = document.getElementById("paramTableBody");
                            var temp=[];
                            var arr = ["int","long","double","float","string","boolean"];

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
//        upload.append(
//                //    console.log(dw.vtable.columns[1].sTitle);
//                saveScriptBtn.mouseup(function() {
//                            console.log("got here");
//
//                            var table = document.getElementById("paramTable");
//                            var tableBody = document.createElement('tbody');
//                            var oldTableBody = document.getElementById("paramTableBody");
//                            //table.appendChild(tableBody);
//
//                            var temp=[];
////            temp= window.localStorage.getItem("myItem");
//
//                            //           console.log(temp);
//
//                            temp=JSON.parse(localStorage["temp"]);
//
//                            for(var j=1;j<temp.length;j++){
//                                var tableRow = document.createElement("TR");
//                                var td = document.createElement('TD');
//                                var tdI = document.createElement("TD");
//                                var input=document.createElement("input");
//
//                                td.setAttribute('class','leftCol-med');
//                                input.setAttribute('type','text');
//                                input.setAttribute('class','initE')
//                                input.setAttribute('style','width:50%');
//                                tdI.appendChild(input);
//                                td.appendChild(document.createTextNode(temp[j]));
//                                tableRow.appendChild(td);
//                                tableRow.appendChild(tdI);
//                                tableBody.setAttribute('id','paramTableBody');
//                                tableBody.appendChild(tableRow);
//                            }
//
//                            table.replaceChild(tableBody,oldTableBody);
//                            console.log(temp);
//                            console.log("clicked");
//                        }
//                ))

    </script>


    </div>
</div>

