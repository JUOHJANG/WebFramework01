<%
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
%><%@ page import="com.mococo.web.core.util.CustomProperties"
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
<link href="http://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<style type="text/css">
	#reportMenu { width:300px; }
	#reportMenu .menu-node .menu-node { padding-left:20px; }
	#reportMenu div[type='3'] span, #reportMenu div[type='55'] span { cursor: pointer; }
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
						
						if (type == "3" || type == "55") {
							alert("id:[" + $parent.attr("report-id") + "], type:[" + type + "], isVI:[" + $parent.attr("is-vi") + "]");
						}
					});
					
					$parent.append($child);
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
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
      <div class="navbar-nav">
        <a class="nav-link" aria-current="page" href="#">Home</a>
		<a class="nav-link" href="#"><%= sf.format(nowTime) %></a>
		<a class="nav-link" href="#">도움말</a>
        <a class="nav-link" href="#">로그아웃</a>
      </div>
    </div>
  </div>
</nav>
<script src="http://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<div id="reportMenu"><div report-id="root"></div></div>
</body>
</html>