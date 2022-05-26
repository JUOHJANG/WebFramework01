<%
%><%@ page contentType="text/html; charset=utf-8" 
%><!doctype html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ include file="../common/include.base.jsp"
%><style type="text/css">
	button { margin:2px; }
</style>
<script type="text/javascript">
function sendJson(url, data, onsuccess, onerror) {
	$.ajax({
		url: url,
		async: true,
		type: "post",
		dataType: "json",
		contentType: "application/json;charset=utf-8",
		data: JSON.stringify(data),
		success: function(data, textStatus, jqXHR) {
			if (onsuccess) { onsuccess(data, textStatus, jqXHR); } 
		},
		error: function(jqXHR, textStatus, errorThrown) {
			if (onerror) { onerror(jqXHR, textStatus, errorThrown) }
		}
	});
}

function sendJsonParam() {
	var param = {"data": []};
	
	for (var i = 0; i < 10; i++) {
		param["data"].push({"key": "key-" + i, "string-value": "value-" + i, "number-value": i * 1000 / 3});
	}
	
	sendJson(
		"${pageContext.request.contextPath}/app/demo/jsonParam.json",
		param,
		function (data, textStatus, jqXHR) {
			console.log(data);
		},
		function (jqXHR, textStatus, errorThrown) {
			console.log(jqXHR, textStatus, errorThrown);
		}
	);
}

function callErrorUrl() {
	sendJson(
		"${pageContext.request.contextPath}/app/demo/error.json",
		{},
		function (data, textStatus, jqXHR) {
			console.log(data);
		},
		function (jqXHR, textStatus, errorThrown) {
			console.log(jqXHR, textStatus, errorThrown);
		}
	);
}

$(function() {
	$("#btnSendJsonParam").on("click", function() { sendJsonParam(); });
	$("#btnCallErrorUrl").on("click", function() { callErrorUrl(); });
});
</script>
</head>
<body>
<button id="btnSendJsonParam" type="button" class="btn btn-outline-primary btn-sm">sendJsonParam</button><br/>
<button id="btnCallErrorUrl" type="button" class="btn btn-outline-primary btn-sm" >callErrorUrl</button>
</body>
</html>