var isSaveToReg;
var errorMsg = "";

function saveScriptParams(isPersist) {

    isSaveToReg = false;
    var isErrorInParams = false;

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
    var params;
    var paramString = "define stream ";

//define stream <nameOfTheStream> ( <attribute1Name> <attribute1Type>, <attribute1Name> <attribute1Type> .....)
    paramString += streamName + "(";

    for (var j = 1; j < numParams; j++) {

        var name = document.getElementById("colInput" + j + "").value;
        var type = document.getElementById("optionSelect" + j + "").value;

        if(name==""){
            isErrorInParams = true;
            break;
        }

        paramString += name + " " + type + ",";
    }

    paramString = paramString.substring(0, paramString.length - 1);
    paramString += ")";

    if(validate(streamName,isErrorInParams)){
        if (isPersist) {
            CARBON.showConfirmationDialog("Do you want to save scripts in Registry?", function () {
                saveToRegistry(saveScript, streamName, paramString)
            }, null, null);
        } else {
            document.getElementById("scriptTextArea").value = saveScript;
            document.getElementById("configTextArea").value = paramString;
        }
    }else{
        CARBON.showErrorDialog(errorMsg);
    }



}

function regAccess(folderName) {
    var resultHTML = "";
    $.ajax({
        type: "POST",
        url: "registryAccess.jsp",
        data: {folderName: folderName},
        error: function (a, b, c) {

        },
        success: function (s) {
            $val = s.toString();

            var reg1 = /\<p[^>]*\>([^]*)\<\/p/m;
            var reg2 = /\<code[^>]*\>([^]*)\<\/code/m

            var scriptText = $val.match(reg1)[1];
            var configText = $val.match(reg2)[1];

            document.getElementById("scriptTextArea").value = scriptText;
            document.getElementById("configTextArea").value = configText;

        }
    });
}

function saveToRegistry(saveScript, streamName, paramString) {

    var isSuccess = false;
    console.log("got here");
    console.log(saveScript);
    console.log(streamName);

    $.ajax({
        type: "POST",
        url: "formdata.jsp",
        data: {formdata: paramString, fileName: streamName},
        error: function (a, b, c) {
            isSuccess = false;

        },
        success: function (s) {
            isSuccess = true;
        }
    });


    $.ajax({
        type: "POST",
        url: "save.jsp",
        data: {name: saveScript, streamName: streamName},
        error: function (a, b, c) {
            CARBON.showErrorDialog("Error occured in saving script");

        },
        success: function (s) {
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
}

function validate(streamName,isErrorInParams){

    if(streamName=="" && isErrorInParams){
        errorMsg = "stream name and parameter definitions are missing"
        return false;
    }
    if(streamName==""){
        errorMsg = "stream name is not defined";
        return false;
    }
    if(isErrorInParams) {
        errorMsg = "parameter definitions missing";
        return false;
    }

    return true;
}

//function for tabulate the rows to get parameter data
function setParams() {

    //setting table parameters
    var table = document.getElementById("paramTable");
    var tableBody = document.createElement('tbody');
    var oldTableBody = document.getElementById("paramTableBody");
//                var temp = [];

    var input2 = document.createElement("input");

    input2.setAttribute('id', "numParams");
    input2.setAttribute('name', "numParams");
    input2.setAttribute('hidden', "true");
    var temp = document.getElementById("wranglerIframe").contentWindow.colNamesDefault;
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
        td.setAttribute('style','width:30%');
        tdI.setAttribute('style','width:30%');
        tdListElement.setAttribute('style','width:30%');

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
        options = ["int","long"];
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




