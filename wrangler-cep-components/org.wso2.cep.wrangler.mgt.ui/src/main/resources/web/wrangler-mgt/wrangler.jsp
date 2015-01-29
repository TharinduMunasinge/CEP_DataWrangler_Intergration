<%@include file="getStream.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<script type="text/javascript" src="dw.js"></script>
<script type="text/javascript" src="wranglerUIHandler.js"></script>

<script>
    function getAllStreamJSON() {	//get stream as a JSON object
        var jsonStream = <%=res%>;
        return jsonStream;
    }
</script>

<div id="middle">
    <h2>Data Wrangler</h2>

    <div id="workArea">

        <form id="dataForm" name="dataForm" method="post">


            <!--Wrangler section begin-->
            <script>
                jQuery(document).ready(function () {
                    jQuery("#optionalPropertyRow").hide();
                    /*Hide (Collapse) the toggle containers on load use show() instead of hide() 	in the 			above code if you want to keep the content section expanded. */
                    jQuery("h2.trigger").click(function () {
                        if (jQuery(this).next().is(":visible")) {
                            this.className = "active trigger";
                        } else {
                            this.className = "trigger";
                        }
                        jQuery(this).next().slideToggle("fast");
                        return false; //Prevent the browser jump to the link anchor
                    });
                });
            </script>
            <h2 class="active trigger">
                <a href="#"> - Data Wrangler -</a>
            </h2>
            <p>&nbsp</p>

            <div id="wrangler_div">
                <table id="wranglerTable">
                    <tr>
                        <div>
                            <iframe id="wranglerIframe" width="100%" height="500px"
                                    src="wrangler.html?req=<%=request.getParameter("dataArea")%>"></iframe>
                        </div>
                        <div onload="test()">

                        </div>
                    </tr>
                </table>
            </div>
            <!--Wrangler section end-->



            <!--Output config begin-->
            <div class="sectionSeperator">Output Configuration</div>
            <div class="sectionSub">
                <table>
                    <tr>
                        <td>
                            Output Configuration Name
                            <span class="required">*</span>
                        </td>
                        <td>
                            <input type="text" required='true' name="scrpitName" id="streamName"
                                   class="initE">

                            <div class="sectionHelp">
                                Stream Name
                            </div>
                        </td>
                    </tr>
                </table>
                <div>
                    <table id="paramTable" style="width:100%;margin-bottom: 7px" class="styledLeft">
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
                    <input class="buttonRow" type="button" onclick="saveScriptParams(true)"
                           value="Save to Registry">
                    <input class="buttonRow" type="button" onclick="saveScriptParams(false)"
                           value="Preview">
                </div>
            </div>
            <!--Output config end-->


            <!--Preview section begin-->
            <div id="preview_div" style="display: none">
            <div class="sectionSeperator">Preview</div>
            <div class="sectionSub">
                <table>
                    <tbody>
                    <tr>
                        <td class="formRaw">
                            <table id="previewInputTable" class="normal-nopadding" width="100%">
                                <tbody>
                                <tr>
                                    <td class="leftcol-small">
                                        Output Definition
                                    </td>
                                    <td>
                                <textarea id="outputDefTextArea" class="expandedTextarea" cols="80"
                                          readonly="true" style="height: 60px"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="leftcol-small">
                                        Wrangling Script
                                    </td>
                                    <td>
                                <textarea id="wranglingScriptTextArea" class="expandedTextarea" cols="80"
                                          readonly="true" style="height: 90px"></textarea>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            </div>
            <!--Preview section end-->



        </form>
    </div>

</div>