<%
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
%><%@ page import="com.mococo.web.util.CustomProperties"
%><%@ page import="java.util.Date" 
%><%@ page import="java.text.SimpleDateFormat" %>
<%
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd a hh:mm");
%>
<%
	String folderId = CustomProperties.getProperty("mstr.menu.folder.id");
%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${pageContext.request.contextPath}/plugins/main/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/plugins/main/css/mstr.css" rel="stylesheet">
<style type="text/css">
	#reportMenu { width:300px; }
	#reportMenu .menu-node .menu-node { padding-left:20px; }
	#reportMenu:hover .menu-node:hover .menu-node:hover { background-color:#16b0ff; color:white;}
	#reportMenu div[type='3'] span, #reportMenu div[type='8'] span, #reportMenu div[type='55'] span { cursor: pointer; }
</style>
<script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/plugins/main/javascript/jquery-1.8.3.min.js"></script>
<script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/plugins/main/javascript/tree.js"></script>
<script type="text/javascript">

function renderMenu(folder) {
	navigateDepthFirst(
		{"id":"root", "child":folder},
		function (ref, stack) { // javascript 객체를 트리 탐색 시 각 노드에 대해 호출되는 콜백함수
			var parentId = undefined;
			if (stack && stack.length > 0) { parentId = stack[stack.length - 1]["id"]; }
			
			var $parent = $("#reportMenu [report-id='" + parentId + "']");
			if ($parent.get(0) != undefined) {
				var $child = $("<div class='menu-node' report-id='" + ref["id"] + "' type='" + ref["type"] + "' is-vi='" + ref["isVI"] + "'><span>" + ref["name"] + "</span></div>");

				$("span", $child).on("click", function() { 
					var $parent = $(this).parent();
					var type = $parent.attr("type");
					
					var reportID = ref["id"];
					var documentID = ref["id"];
					var Server = 'DESKTOP-NE4ATKU';
					var Project = 'MicroStrategy%20Tutorial';
					

					var sLinkURL = "";
					if (type == "3" ) {
						var evt = '4001';
						var src = 'mstrWeb.4001';
						sLinkURL = '/MicroStrategy/servlet/mstrWeb?evt='+evt+'&src='+src+'&visMode=0&reportViewMode=1&reportID='+ref["id"]+'&Server='+Server+'&Project='+Project+'&Port=0&share=1';

					} else if (type =="55"){
						var evt = '2048001';
						var src = 'mstrWeb.2048001';
						sLinkURL = '/MicroStrategy/servlet/mstrWeb?evt='+evt+'&src='+src+'&documentID=' +ref["id"]+'&currentViewMedia=2&visMode=0'+'&Server='+Server+'&Project='+Project+'&Port=0&share=1';
					} 
					else if (type =="8") {
						$('div.menu-node', $child).children().toggle();
					}
					
					try {
						
						if(type =="3" || type =="55"){
							$('#frmMstr').attr('method', 'post').attr('action', sLinkURL).attr('target','sample1').submit();
						} 
					} catch (e) {
						console.log(e);
					} finally {
						$('#frmMstr').removeAttr('action').removeAttr('target');
					}
					
				
				});
				$parent.append($child);
				/*$parent.append($child);
				  $("#show").click(function() {
						 $parent.append($child).show();
				 });
				 $("#hide").click(function() {
						 $parent.append($child).hide();
				  });*/
			} 
		},
		"child"
	);		
}

	function loadMenu() {
		// json으로 메뉴정보를 조회
		var option = {
			url: "${pageContext.request.contextPath}/app/getFolderList.json",			
			type: "post",
			data: JSON.stringify({folderId: "<%= folderId %>"}),
			contentType: "application/json;charset=utf-8",
			dataType: "json",
			success: function(result) {
				// 서버로부터 응답을 받는 시점에서 호출되는 콜백함수
				if (result && result["errorCode"] == "success") {
					renderMenu(result["folder"]);
				} else {
					alert("메뉴정보 조회 중 오류가 발생하였습니다.");
				}
			},
			error: function() { 
				alert("메뉴정보 조회 중 오류가 발생하였습니다.");
			},
			async: true
		};				
		
		$.ajax(option);
	}
	
	$(function() {
		loadMenu();
	});
</script>
</head>
<body>
<%@ include file="/plugins/main/jsp/module/top.jsp" %>

<form id='frmMstr' name='frmMstr' >
		<input type='hidden' id='hiddenSections' name='hiddenSections' value='path,header,footer,dockTop,dockLeft'/>
		<input type='hidden' id='promptAnswerXML' name='promptAnswerXML' />
</form>
<iframe id="frmMstr" name="sample1" src="${pageContext.request.contextPath}/servlet/mstrWeb?evt=3140&src=mstrWeb.3140&documentID=3943B01311E6695B0F6D0080EF6EAE56&Server=DESKTOP-NE4ATKU&Project=MicroStrategy%20Tutorial&Port=0&share=1" height="700" width="1500" style="position: absolute; left: 300px; ">
</iframe>



<div id="reportMenu"><div report-id="root"></div></div>
</body>
</html>