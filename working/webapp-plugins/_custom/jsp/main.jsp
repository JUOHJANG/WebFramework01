<%
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
%><%@ page import="java.util.Map"
%><%@ page import="java.util.Arrays"
%><%@ page import="java.util.List"
%><%@ page import="java.util.Iterator"
%><%@ page import="java.io.BufferedReader"
%><%@ page import="java.io.DataOutputStream"
%><%@ page import="java.io.InputStreamReader"
%><%@ page import="java.io.IOException"
%><%@ page import="java.net.URL"
%><%@ page import="java.net.HttpURLConnection"
%><%@ page import="java.net.MalformedURLException"
%><%@ page import="com.microstrategy.web.objects.WebObjectsFactory"
%><%@ page import="com.microstrategy.web.objects.WebIServerSession"
%><%@ page import="com.microstrategy.webapi.EnumDSSXMLApplicationType"
%><%@ page import="com.microstrategy.webapi.EnumDSSXMLAuthModes"
%><%@ page import="com.microstrategy.web.objects.WebObjectSource"
%><%@ page import="com.microstrategy.webapi.EnumDSSXMLFolderNames"
%><%@ page import="com.microstrategy.webapi.EnumDSSXMLObjectTypes"
%><%@ page import="com.mococo.web.util.CustomProperties"
%><%
	String folderId = CustomProperties.getProperty("mstr.menu.folder.id");
%><!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/_custom/javascript/jquery/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
	function loadSubMenu(result, objectId, objectName) {
		if ($('#ifrmContReport')[0].contentWindow.getReportList == undefined) {
			setTimeout(function() { loadSubMenu(result, objectId, objectName); }, 100); 
		} else {
			$('#divContReport').show();
			$('#divContPortal').hide();
			$('#ifrmContReport')[0].contentWindow.getReportList(result, objectId, objectName);
		}
	}
	
	function onMenu() {
		uxl.SimpleMenu("#menu", function(event, item){
			wait();
			
			var objectId = item.menuId;
			var objectName = item.menuName;
			
			$('#ifrmContReport').contents().find('#divReportDetail').hide();
			
			var option = {
				url: "./app/main/subMenu.json",			
				type: "post",
				data: JSON.stringify({
					SERVER_NAME: "<%= SERVER_NAME %>",
					PROJECT: "<%= PROJECT_NAME %>",
					USER_ID: "<%= USER_ID %>",
					USER_PWD: "<%= USER_PWD %>",
					FOLDER_ID: objectId
				}),
				contentType: "application/json;charset=utf-8",
				dataType: "json",
				success: function(result) {
					loadSubMenu(result["list"], objectId, objectName);
					unwait();
				},
				error: function() { 
					unwait();
				},
				async: true
			};				
			
			$.ajax(option);
		});			
	}
	
	function mstrSessionCheck(callback) {
		var ok = false;
		var option = {
				url: "./app/main/mstrSessionCheck.json",			
				type: "post",
				contentType: "application/json;charset=utf-8",
				dataType: "json",
				success: function(result) {
					ok = result.result;
				},
				error: function() { },
				async: false
			};				
			
		$.ajax(option);
		return ok;
	}
	
	function wait() {
		$("#divLoding").show();
	}
	
	function unwait() {
		$("#divLoding").hide();
	}
	
	$(function() {
		setTopMenu();
		onMenu();
		
		// Window Resize Event bind
 		$(window).resize(function(){
 			var height	= $(this).height();
 			
 			$("body").height(height);
 			$("#divContReport").height(height - 114);
 			$("#ifrmContReport").height(height - 114);
 		});
		
 		$(window).trigger("resize");		
	});
</script>
</head>
<body style="overflow:auto;">
	<div id="header">
		<div class="header_bg">
			<h1><a href="javascript:location.reload(true);"><img src="./page/images/common/spcnetworks.gif" alt="Demo" style="width:140px;"/></a></h1>
			<div class="topmenu_wrap">
				<div class="gnb">
					<div id='divTopMenu' class="gnb_navi">
						<ul id='topMenu'></ul>
					</div>
					<div class="log_info">
						<ul>
							<li class="user"><img src="./page/images/common/ico_user.png" alt="" /> <span id='btnProfile' style='cursor:pointer;'>홍길동</span></li>
							<li class="logout"><div class="btn_logout_wrap"><a href="javascript:;" onclick="javascript:fnLogout();"><span class="btn_logout">Logout</span></a></div></li>
						</ul>
					</div>
					<div class="confidential"><img src="./page/images/common/img_confidential.png" alt="Confidential"/></div>
				</div>
				<div id="lnb">
					<div class="pure-menu pure-menu-open pure-menu-horizontal" style="z-index:9999;float:left;">
						<ul id="menu" class="pure-menu-children">				
<c:forEach var="item" items="${list}">						
							<li class="pure-menu-can-have-children">
								<a  menuId="${item['id']}" menuPath="${item['path']}" menuName="${item['name']}" class="pure-menu-label" title="move to ${item['name']}">${item['name']}</a>
								<c:if test="${item['children'] != null && fn:length(item['children']) > 0}">
									<ul class="pure-menu-children">
	<c:forEach var="subItem" items="${item['children']}">
										<div class="menu-sub-box2"><li class="pure-menu-li">
											<a class='pure-menu-label2' menuId="${subItem['id']}" menuPath="${subItem['path']}"  menuName="${subItem['name']}" title="move to ${subItem['name']}">${subItem['name']}</a>
										</li></div>
	</c:forEach>
									</ul> 
								</c:if>
							</li>
</c:forEach>							
						</ul>
					</div>		
				</div>
			</div>
		</div>
		<div class="header_bgB"></div>
	</div>
	<div id='divContPortal' style='padding-top:76px;'>
		<div id="contents_wrapper">
			<div id="contents">
				<div id="main_visual"></div>
				<div id="area">
					<div class="board">
						<div class="tabs_wrapper">
							<div class="tabs">
									<span><img src="./page/images/common/tit_main_pmnotice.gif" /></span>
									<span class="more"><a id='pmNoticeMore'>more</a></span>
							</div>
							<div class="tab_container">
								<div id="tab1" class="tab_content">
									<table class="ub-control table notice" id='tbPMNotice' style="margin-bottom:20px;">
										<colgroup>
											<col width="60%"/><col width="20%"/><col/>
										</colgroup>
										<tr><th>제목</th><th>등록자</th><th>일시</th></tr>
										<tr><td class="cont"><a href="#">정기 서버작업 공지</a></td><td class="writer">관리자</td><td class="date">2016.6.13</td></tr>
										<tr><td class="cont"><a href="#">DB 증설 작업 공지</a></td><td class="writer">관리자</td><td class="date">2016.4.13</td></tr>
										<tr><td class="cont"><a href="#">DB 점검 공지</a></td><td class="writer">관리자</td><td class="date">2016.3.3</td></tr>
									</table>
								</div>
							</div>
						</div>
						<div class="tabs_wrapper" style="margin-left:45px;">
							<div class="tabs">
									<span><img src="./page/images/common/tit_main_notice.gif" /></span>
									<span class="more"><a id='noticeMore'>more</a></span>
							</div>
							<div class="tab_container">
								<div id="tab1" class="tab_content">
									<table class="ub-control table notice" id='tbNotice' style="margin-bottom:20px;">		
										<colgroup>
											<col width="60%"/><col width="20%"/><col/>
										</colgroup>
										<tr><th>제목</th><th>등록자</th><th>일시</th></tr>
										<tr><td class="cont"><a href="#">신규 지표 안내</a></td><td class="writer">관리자</td><td class="date">2016.8.13</td></tr>
										<tr><td class="cont"><a href="#">매출 데이터 수정 공지</a></td><td class="writer">관리자</td><td class="date">2016.1.13</td></tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Contents Layer -->
	<div id='divContReport' style='padding-top:76px;display:none'>
		<iframe name='ifrmContReport' id='ifrmContReport' src='mstrReport.jsp' style='width:100%;min-width:1200px;height:695px; margin:0px' marginWidth=0 marginHeight=0 frameBorder=0 scrolling='no'></iframe>
	</div>
	<!--// Contents Layer -->
	<!-- footer -->
	<div id="footer">
		<span class="copyright">Copyright &copy; 2016 SPC Networks Co., Ltd. All rights reserved.</span>
		<span class="policy"><a href="#">Privacy Policy</a></span>
	</div>
	
	<div id="divLoding" style="position:absolute; top:0px; left:0px; width:100%; height:100%; z-index:99009; display:none;">
		<div style="position:absolute; top:50%; left:50%; width:250px; height:50px; margin-left:-125px; margin-top:-50px; z-index:99010">
		<div class="loading-wrap"><ul><li class="loading"></li><li class="txt"><span>Please wait...</span></li></ul></div>
		</div>
		
		<div style="position:absolute;top:0px;left:0px;opacity:0.2;background:#FFF;width:100%;height:100%;z-index:99009"></div>
	</div>
	
	<!--// footer -->		
	<form id='frmMain' name='frmMain'></form>
</body>
</html>