<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page import="com.microstrategy.web.objects.WebIServerSession"
%><%@ page import="com.hanwhalife.util.CustomProperties"
%><%@ page import="com.mocomsys.MstrUtil"
%><%@ include file="/_custom/jsp/include/pageTagLibs.jsp"
%><%
%><!DOCTYPE html><html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include flush="true" page="/_custom/jsp/include/pageCss.jsp"/>
<jsp:include flush="true" page="/_custom/jsp/include/pageJs.jsp"/>
<style type="text/css">
    body { display:flex; }
    #frameBody { position:relative; margin:auto; }
    .search { height:40px; display:flex; align-items:center; margin-bottom:5px; }
    .search .label { margin:0 20px 0 0; }
    .search .text { height:28px; width:209px; }
    .search button { padding:5px 25px; margin-left:5px; background-color:#0078D4; border:0; color: #ffffff; }
    
    #wrapper .header { width:400px; border:1px solid #b8b8b8; border-bottom:0; }
    #wrapper .body { width:418px; height:400px; overflow-x:hidden; overflow-y:scroll; border:1px solid #b8b8b8; }
    #wrapper .header table td { padding:5px; text-align:center; background-color:#efefef; border-right:1px solid #b8b8b8; }
    #wrapper .header table td:last-child { border-right:0; }
    #wrapper .body table td { padding:5px; border-bottom:1px solid #b8b8b8; border-right:1px solid #b8b8b8; } 
    #wrapper .body table td:first-child { text-align:center; }
    #wrapper.bottom > button { padding:5px 25px; margin-left:5px; background-color:#0078D4; border:0; color: #ffffff; }
    #wrapper.bottom { margin-top:10px; float:right; }
    
    table { table-layout:fixed; }
    td { overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
</style>
<script type="text/javascript">
var popupHandler = undefined;

$(function() {
    popupHandler = opener.__popupHandler;
    
    if (popupHandler && popupHandler.load) {
    	var loadHandler = popupHandler.load;
    	var data = loadHandler();
    	
    	if (data) {
    		var $tbody = $(".body table tbody");
    		$tbody.empty();
	    	$.each(data, function(i, v) {
	            var $tr = $("<tr><td><input type='checkbox' element-id='" + v["id"] + "'/></td><td>" + v["id"] + "</td><td>" + v["displayName"] + "</td></tr>");
	    		$tbody.append($tr);
	    	});
	    };
    } 
    
    $("button#select").click(function() {
        var selected = []; 
        $("input:checked").each(function(i, v) { 
        	var $v = $(v);
        	var o = {};
        	o.id = $v.attr("element-id");
        	o.name = $v.closest("tr").find("td:last").text();
        	
        	selected.push(o);
        });
        
	    if (popupHandler && popupHandler.select) {
	        popupHandler.select(selected);
	    }
	    window.close();
    });
});
</script>
</head>
<body class="ub-page default" style="background:#FFF;">
	<div id="frameBody" class="ub-frame">
        <div id="wrapper" class="search">
            <span class="label">검색</span><input class="text" type="text" value=""/><button type="button">검색</button>
        </div>
		<div id="wrapper">
			<div class="header">
				<table style="width:100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
                        <col style="width:25px;"/>
						<col style="width:100px;"/>
						<col/>
					</colgroup>
					<tbody>
						<tr>
						    <td></td>
							<td>코드</td>
							<td>값</td>
						</tr>
					</tbody>
				</table>
			</div>
            <div class="body">
				<table style="width:100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
                        <col style="width:25px;"/>
						<col style="width:100px;"/>
						<col/>
					</colgroup>    
					<tbody>
						<tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
                        <tr><td><input type="checkbox"/></td><td>1</td><td>2</td></tr>
					</tbody>
				</table>
			</div>
		</div>
        <div id="wrapper" class="bottom">
            <button type="button" onclick="self.close();">닫기</button><button id="select" type="button">선택</button>
        </div>
	</div>
</body>
</html>