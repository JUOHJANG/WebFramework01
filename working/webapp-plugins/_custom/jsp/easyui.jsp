<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page import="com.microstrategy.web.objects.WebIServerSession"
%><%@ page import="com.microstrategy.web.objects.WebObjectsFactory"
%><%@ page import="com.mococo.web.util.CustomProperties"
%><%@ page import="com.mococo.microstrategy.sdk.util.MstrUtil"
%><%@ include file="/_custom/jsp/include/pageTagLibs.jsp"
%><%
%><!DOCTYPE html><html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include flush="true" page="/_custom/jsp/include/pageCss.jsp"/>
<jsp:include flush="true" page="/_custom/jsp/include/pageJs.jsp"/>
<style type="text/css">
    body { font-family:"Malgun Gothic"; font-size:12px; }
    button#run { float:right; margin-bottom:10px; padding:5px 10px; background-color:#0078D4; border:0; color:#ffffff; }
    button.popup { padding:5px 10px; background-color:#0078D4; border:0; color:#ffffff; }
    
    #frameBody { padding:10px; }
    #wrapper { width:100%; height:100%; } 
    #divReportDetail { width:100%; height:100%; }
    #promptWrapper { /* height:100px; */ }
    #reportName { font-size:25px; line-height:55px; }
    .elemWrapper { display:inline-flex; align-items:center; margin:5px 10px; }
    .elemWrapper .popElem { display:inline-flex; align-items:center; }
    .elemLabel { padding:0 10px 0 0; font-size:13px; }
    .elemWrapper input[type=text] { height:30px; font-size:13px; width:150px; }
    .elemWrapper select { width:150px; }
    .elemWrapper > .ms-options-wrap > button { width:150px; } 
    .elemWrapper .hasDatepicker { height:30px; font-size:13px; width:150px; }
    option { font-size:12px; }
    
	.ui-datepicker span.ui-datepicker-year { color:#686D7B; }
	.ui-datepicker span.ui-datepicker-month { color:#686D7B; }
	.ui-datepicker .ui-datepicker-title { color:#686D7B; }
</style>
<script type="text/javascript">
	$(function() {
		$("#s1").combobox();
		$("#s1").combobox({"onSelect": function(a, b) {
			console.log(a, b)
			
			if (a.value === "") {
				var $this = $(this);
				
				if ($this.attr("custom-handler-state") === "run") {
					$this.removeAttr("custom-handler-state");
					
					return; 
				} else {
					setTimeout(function() {
						$this.attr("custom-handler-state", "run");
						
						$("#s1").combobox("clear");										
						$("#s1").combobox("setValues", [""]);										
					}, 10);			
				}
			} else {
				var values = $("#s1").combobox("getValues");
				
				if ($.inArray("", values) > -1) {
					setTimeout(function() {
						$("#s1").combobox("unselect", "");	
					}, 10);
				}
			}
		}})
	});
</script>
</head>
<body class="" style="height:100%;background:#FFF;">
<select id="s1" style="width:300px; margin:10px;" multiple="multiple">
	<option value="">전체</option>
	<option value="generation">generation</option>
	<option value="contained">contained</option>
	<option value="detected">detected</option>
</select>
</body>
</html>