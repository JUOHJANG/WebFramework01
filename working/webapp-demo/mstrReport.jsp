<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page import="com.mocomsys.microstrategy.demo.properties.CustomProperties"
%><%@ include file="/page/common/include/pageTagLibs.jsp"
%><html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include flush="true" page="/page/common/include/pageCss.jsp"/>
<jsp:include flush="true" page="/page/common/include/pageJs.jsp"/>
<style type="text/css">
	span.dynatree-connector {
	    background-image: none !important;
	}
	
	.ub-frame.body .ub-layout.location { font:normal 12px '맑은 고딕',Arial,serif; color:#989898;}
</style>
<script type="text/javascript">
	$(function() {
		init();		
	});
	
	function init(){
		$('td.lenavi-btn').on('click', function() {
			var naviId = $(this).find("img").filter(function(){
				return $(this).css("display") != "none";
			}).attr("id");
			
			if (naviId == 'navi_toMax') {
				$('#table_list_td').show();
				$("#navi_toMin").attr("style", "display:inline;");
				$("#navi_toMax").attr("style", "display:none;");
			} else {
				$('#table_list_td').hide();
				$("#navi_toMin").attr("style", "display:none;");
				$("#navi_toMax").attr("style", "display:inline;");
			}
		});
		
		$("#expandAll").bind("click", function(){
			controlTree("expand");
		});
		
		$("#collapseAll").bind("click", function(){
			controlTree("collapse");
		});
		
		$(window).resize(function() {
			// Report IFrame Resize
			var height	= $(window).height();
			
			$("#divReportList").height(height - 92);
			$("#divReportDetail").height(height);
			$("#mstrReport").height(height - 72);
		});
	}
	
	//================================================
	// Init Data Load
	//================================================
	function getReportList(result, menuId, menuName) {
		$(window).trigger('resize');
		
		window.parent.wait();
		
		$("#divReportDetail").show();
		$(".lenavi-tit").empty().text(menuName);
		
		try {
			$('#divReportList').dynatree('destroy');
		} catch(e) { }
		
		$("#mstrReport").contents().find("body").html("");
		
		var option = {
			isReloading: true,
			clickFolderMode: 2, // 1:activate, 2:expand, 3:activate and expand
			minExpandLevel: 1, // 기본펼침 [선택 1~3 기본 1]
			selectMode: 1, // 선택모드 [기본값 : 1] 1:single, 2:multi, 3:multi-hier
			children: result,
			onActivate: function(node){ //node 선택시 이벤트	
				if (!window.parent.mstrSessionCheck()) {
					alert("세션이 종료되었습니다. 다시 접속하세요.");
					return;
				};
				
				$("#mstrReport").contents().find("body").html("");
				var path = "";
				var parentNode = node.getParent();
			
				for (var i = 0 ; i < 10 ; i ++) {
					if (parentNode.getLevel() == 0) {
						path	= '<span class="ico-home"></span><span>' + menuName  + '</span><span class="ico-arrow"></span>' + path;
						break;
					} else if (i == 0){
						path	= '<span class="acolor">' + parentNode.data.title  + '</span>';								
						parentNode	= parentNode.getParent();
					} else {
						path	= '<span>' + parentNode.data.title  + '</span><span class="ico-arrow"></span>' + path;								
						parentNode	= parentNode.getParent();
					}
				}
				
				$('.location').html(path);
				$('.title').html('<span>' + node.data.title + '</span>');
				
				if ($.inArray(node.data.type, [3, 55]) > -1) {
					callForm(node.data.id, node.data.type);
				}
			},
			onClick:function(node) {
				if (!node.data.isFolder) {
					if ($(node.li.children).hasClass('dynatree-active')) {
						node.deactivate();
					}
				}
			},
			onPostInit:function(){
				$("#divReportList").dynatree("getRoot").visit(function(dtnode) {
					if (dtnode.data.children && dtnode.data.children.length > 0) {
						dtnode.expand(true);
					} else {
						dtnode.activate();
						return false;
					}
	            });
			}
		};				
		$("#divReportList").dynatree(option);
	}
	
	function callForm(objId, objTp) {
		window.parent.wait();
		
		$('#objId').val(objId);
		$('#objTp').val(objTp);
		$("#documentID").val(objId);
		$("#reportID").val(objId);
		
		switch (objTp) {
		case 3:
			$("#frmReport").submit();
			break;
		case 55:
			$("#frmDocument").submit();
			break;
		default:
		}
	}
	
	function controlTree(controlTp) {
		if (controlTp == "expand") {
			$("#divReportList").dynatree("getRoot").visit(function(dtnode){
				dtnode.expand(true);
            });
		} else 
		if (controlTp == "collapse") {
			$("#divReportList").dynatree("getRoot").visit(function(dtnode){
				dtnode.expand(false);
            });
		}
	}
	
</script>
</head>
<body class="ub-page default" style="height:100%;background:#FFF;">
	<div id="frameBody" class="ub-frame body" style="height:100%;">
		<form id='frmReport' name='frmReport' action='<%= CustomProperties.getProperty("mstr.url.mstrWeb") %>' method="post" target="mstrReport">
			<input type='hidden' id='hiddenSections' name='hiddenSections' value="path,header,footer,dockLeft"/>
			<input type='hidden' id='usrSmgr' name='usrSmgr' value="<%= session.getAttribute("usrSmgr") %>"/>
			<input type='hidden' id='reportID' name='reportID' value=''/>
			<input type='hidden' id='evt' name='evt' value='4001'/>
			<input type='hidden' id='src' name='src' value='mstrWeb.4001'/>
		</form>
		<form id='frmDocument' name='frmDocument' action='<%= CustomProperties.getProperty("mstr.url.mstrWeb") %>' method="post" target="mstrReport">
			<input type='hidden' id='hiddenSections' name='hiddenSections' value="path,header,footer,dockTop"/>
			<input type='hidden' id='usrSmgr' name='usrSmgr' value="<%= session.getAttribute("usrSmgr") %>"/>
			<input type='hidden' id='documentID' name='documentID' value=''/>
			<input type='hidden' id='evt' name='evt' value='2048001'/>
			<input type='hidden' id='src' name='src' value='mstrWeb.2048001'/>
		</form>
		<div>
			<table>
				<tr>
					<td id="table_list_td" class="lenavi" valign='top'>
						<div class="lenavi-tit">KPI</div>
						<div id='divReportList' style='overflow:auto;width:220px;' class="lenavi-list"></div>
						<div class="ub-layout lenavi-button bottom">
							<ul class="navi-btn">
								<li class="expandAll"><a class="ub-control button bottom" id="expandAll">Expand All</a></li>
								<li class="collapseAll"><a class="ub-control button bottom" id="collapseAll">Collapse All</a></li>
							</ul>
						</div>
					</td>
					<td height="100%" class="lenavi-btn" valign='middle'>
						<img id="navi_toMax" src="./page/images/common/btn_nav_show.png" alt="toMaxSize" title="toMaxSize" style="display:none;">
						<img id="navi_toMin" src="./page/images/common/btn_nav_hide.png" alt="toMinSize" title="toMinSize" style="display:inline;">
					</td>
					<td valign="top" style="width:100%;height:100%;">
						<div id="divReportDetail" style="overflow:auto;">
							<div style="padding:15px 25px;">
								<h2 class="ub-control title"><span id="reportName"></span></h2>
								<p class="ub-layout location">
									<span class="ico-home"></span>
									<span>Home</span>
									<span class="ico-arrow"></span>
									<span>Game KPI</span>
									<span class="ico-arrow"></span>
									<span class="acolor">Daily KPI by All</span>
								</p>
								<iframe name="mstrReport" id="mstrReport" src="" style="width:100%; border:1px solid silver; margin:0px;" marginWidth=0 marginHeight=0 frameBorder=0 scrolling="auto"></iframe>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>