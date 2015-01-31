var isSaveToReg;
var isSaveDefault= false;
var errorMsg = "";
var savingParamDef = "";
////////////////////////////////////////
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
        function getDataTypes(index) { // INT, LONG, BOOL STRING, FLOAT, DOUBLE
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


            var definition;
            if (index === -1) { 	// --select any stream--
                definition = "";
            }
            else {		// generate the definition
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
            document.getElementById("dataPopulatedArea").value="";
            document.getElementById("isValid").innerHTML="";
            document.getElementById("1").checked=false;
            document.getElementById("2").checked=false;
            window.scrollTo(0,document.body.scrollHeight);
        }

        function onClickAddNewConfig(){
//            $("#previewTable").slideUp("fast",null);
            document.getElementById("previewTable").style.display = "none";
            $("#newConfigDiv").slideToggle(500,null);
//            window.scrollTo(0,document.body.scrollHeight);

        }

        function onClickPushToWrangler(definition){

		if(isValidQuery(definition)){
			document.getElementById("isValid").innerHTML="";
            document.getElementById("dataPopulatedArea").value=writeSampleForQuery(definition);
		}
		else{
			document.getElementById("isValid").innerHTML="*Invalid syntax";
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


function formSubmit(){
    var definition = document.getElementById("txtQuery").value;
    var data = document.getElementById("dataPopulatedArea").value;
    var form = document.getElementById("form_config");

    if(definition=="" && data ==""){
        CARBON.showErrorDialog("configuration definition and no data set added");
        return;
    }else if(definition == ""){
        CARBON.showErrorDialog("configuration definition not added");
        return;
    }else if(data == ""){
        CARBON.showErrorDialog(" dataset not added");
        return;
    }

    form.submit();
}

function saveScriptParams(isPersist) {

    isSaveToReg = false;
    var isErrorInParams = false;

    var streamName = document.getElementById("streamName").value;
    var saveScript = "";


    saveScript = document.getElementById("wranglerIframe").contentWindow.exportedValue;


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

    var params;
    var paramString = "define stream ";
    var paramStringWtPlaceholder = "define stream ";

//define stream <nameOfTheStream> ( <attribute1Name> <attribute1Type>, <attribute1Name> <attribute1Type> .....)
    paramString += streamName + "(";

    for (var j = 1; j < numParams; j++) {

        var name = document.getElementById("colInput" + j + "").value;
        var type = document.getElementById("optionSelect" + j + "").value;
        var placeholder = document.getElementById("colInput" + j + "").getAttribute("placeholder");

        if(name==""){
       //CARBON.showConfirmationDialog("Default column names will be saved as parameters!!",function(){},null,null);
            isErrorInParams = true;
        }

        paramString += name + " " + type + ",";
        paramStringWtPlaceholder += placeholder + " " + type + ",";
    }

    paramString = paramString.substring(0, paramString.length - 1);
    paramString += ")";

    paramStringWtPlaceholder = paramStringWtPlaceholder.substring(0, paramStringWtPlaceholder.length - 1);
    paramStringWtPlaceholder += ")";


    if(validate(streamName,isErrorInParams)){
        if (isPersist) {
            CARBON.showConfirmationDialog("Do you want to save scripts in Registry?", function () {
                saveToRegistry(saveScript, streamName, paramString);

            }, null, null);

        }
        else {
            document.getElementById("wranglingScriptTextArea").value = saveScript;
            document.getElementById("outputDefTextArea").value = paramString;
            $('#preview_div').slideToggle(500, function () {

            });
            window.scrollTo(0,document.body.scrollHeight);
        }

    }else if(streamName!=""){
        CARBON.showConfirmationDialog("Do you want to keep parameter names as default values",
            function(){
                if (isPersist) {
                    CARBON.showConfirmationDialog("Do you want to save scripts in Registry?", function () {
                        saveToRegistry(saveScript, streamName, paramStringWtPlaceholder);

                    }, null, null);

                }
                else {
                    document.getElementById("wranglingScriptTextArea").value = saveScript;
                    document.getElementById("outputDefTextArea").value = paramStringWtPlaceholder;
                    $('#preview_div').slideToggle(500, function () {

                    });
                    window.scrollTo(0,document.body.scrollHeight);
                }

            },function(){CARBON.showErrorDialog(errorMsg);},null);

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
                    window.location="config_data_for_wrangler.jsp";
            });

        }
    });

}


function copyToClipboard() {

}

function reloadOutputStreams() {

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
        input.setAttribute('placeholder',temp[j]);
        tdI.appendChild(input);
        td.appendChild(document.createTextNode(temp[j]));
        tdListElement.setAttribute('id', "optionSelect" + j + "");
        tdListElement.setAttribute('name', "optionSelect" + j + "");

        var optionArr = [];
        optionArr = setColumnTypes(j - 1);



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


    $("#wrangler_div").slideUp(500,null);
    document.getElementById("output_div").style.display = "block"
    $("#output_div").slideDown(500, null);

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




