<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mococo.web.util.CustomProperties"%>
<%@ page import="com.mococo.microstrategy.sdk.util.MstrUtil"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd a hh:mm");
	String wizardId = CustomProperties.getProperty("mstr.menu.wizard.id");
    String lvl4Id = CustomProperties.getProperty("mstr.menu.lvl4.id");
    
    /*서버정보와 프로젝트이름정보를 가져옴*/
	String server = MstrUtil.getLiveServer(CustomProperties.getProperty("mstr.default.server"));
	String project = CustomProperties.getProperty("mstr.default.project.name");
	
%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="${pageContext.request.contextPath}/plugins/main/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/plugins/main/css/mstr.css" rel="stylesheet">
<style type="text/css">
	#reportMenu { width:300px; }
	#reportMenu .menu-node .menu-node { padding-left:10px; }
	#reportMenu div[type='3'] span, 
	#reportMenu div[type='8'] span, 
	#reportMenu div[type='12'] span, 
	#reportMenu div[type='4'] span,
	 #reportMenu div[type='55'] span { cursor: pointer; }
</style>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">


  <style>
  .ui-menu {    width: max-content;
    min-width: 150px; }
  </style>
</head>
<body>

<%@ include file="/plugins/main/jsp/module/top.jsp" %>

<div class="container-fluid">
  <div class="row">
    <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
      <ul id="menu">
   
</ul>
    </nav>

    <main >
    <form id='frmMstr' name='frmMstr' >
		<input type='hidden' id='hiddenSections' name='hiddenSections' value='path,header,footer,dockTop,dockLeft'/>
		<input type='hidden' id='promptAnswerXML' name='promptAnswerXML' />
</form>
    
    <div class="row">
    	<div class="col-12">
	    	<div class="d-grid gap-2 d-md-flex justify-content-md-between">
	    		<h3 style="">비정형 분석</h3>
        		<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-bs-whatever="@getbootstrap" style="height: 38px;">리포트 저장</button>
            </div>
     	</div>
    </div>
    
    <div class="row">
    	<div class="col-2"> 
      		대상주제영역<br>
			<ul id="sortable1" class="connectedSortable connectedSortable1"> 
			</ul> 
		</div>
	    <div class="col-2">
		    선택주제영역<br>
			<ul id="sortable1-2" class="connectedSortable connectedSortable1"> 
			</ul>
			
		</div>
	    <div class="col-2">
		    대상관점<br>
			<div id="attribute">
			  
			</div>
			필수 대상관점<br>
			<div id="attributeRequired">
			  
			</div>
			<!-- <ul id="sortable2" class="connectedSortable connectedSortable2"> 
			</ul> -->
		</div>
	    <div class="col-2">
	    	선택관점<br>
		
			<div id="selectAttribute">
			  <div></div>
			</div>
	<!-- 	<ul id="sortable2-2" class="connectedSortable connectedSortable2"> 
		</ul> -->
		
		</div>
	    <div class="col-2">
		    대상지표<br>
		       
			<ul id="sortable3" class="connectedSortable connectedSortable3"> 
			</ul>
			 
		</div>
	    <div class="col-2">
		    선택지표<br>
			<ul id="sortable3-2" class="connectedSortable connectedSortable3"> 
			</ul>
		
		</div>
	</div>
	<div class="row">
    	<div class="col-12" style="margin-top: 50px;">
		   <div class="d-grid gap-2 d-md-flex justify-content-md-end">
    	
	   <!--  <div class ="list" style="position : absolute; left:400px; width:300px; height:400px; border:1px solid blue; overflow:auto; float:right;"><p>테이블</p></div> 
        <div class="attribute" style="position : absolute; left:800px; width:300px; height:400px; border:1px solid green; overflow:auto; float:right;"><p>관점</p></div>
        <div class="metric" style="position : absolute; left:1200px; width:300px; height:400px; border:1px solid orange;overflow:auto;  float:right;"><p>지표</p></div>
        <div class="selectObjectAttr" style="position : absolute; left: 800px; bottom:80px;  width:300px; height:400px; border:1px solid grey; overflow:auto;  float:right;"><p>선택관점</p></div>
        <div class="selectObjectMetric" style="position : absolute; left: 1200px; bottom:80px;  width:300px; height:400px; border:1px solid grey; overflow:auto;  float:right;"><p>선택지표</p></div> -->
        <!-- <input id="save_report" type="button" value="리포트 저장" style="position : absolute;  bottom:300px; " onclick="save_report();" /> -->
        		<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-bs-whatever="@getbootstrap">리포트 저장</button>
        
        	</div>
        </div>
    </div>
        
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">리포트 저장</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <form>
	          <div class="mb-3">
	            <label for="recipient-name" class="col-form-label">리포트 제목 : </label>
	            <input type="text" class="form-control" id="recipient-name">
	          </div> 
	        </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary"  onclick="saveReport();">저장</button>
	      </div>
	    </div>
	  </div>
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<!-- <div id="reportMenu"><div report-id="root"></div></div>
    </main>
  </div> -->
</div>


    <script src="${pageContext.request.contextPath}/plugins/main/javascript/bootstrap.bundle.min.js"></script>

      <script src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js" integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js" integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha" crossorigin="anonymous"></script><script src="dashboard.js"></script>
       <script src="https://code.jquery.com/jquery-3.6.0.js"></script>  
  <script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
    <script>
    const required_prefix = "A_";
    const wizardId = "<%= wizardId %>";
    const server = "<%= server %>";
    const project ="<%= project %>";
    const contextPath ="${pageContext.request.contextPath}";
    $( function() {
        $( "#menu1" ).menu({
          items: "> :not(.ui-widget-header)"
        }); 
        /* 	 
    $( "#sortable1, #sortable1-2" ).sortable({
      connectWith: ".connectedSortable1",
      remove: function( event, ui ) {
    	 console.log(event);
    	 console.log(ui)
    	 loadObject(ui.item[0].dataset.obj_id);
      }
    }).disableSelection();
  
   $( "#sortable2, #sortable2-2" ).sortable({
	      connectWith: ".connectedSortable2"
	    }).disableSelection();
 
	    $( "#sortable3, #sortable3-2" ).sortable({
	      connectWith: ".connectedSortable3"
	    }).disableSelection();
	     */
   		$( "#attribute" ).accordion({
			collapsible: true
		}); 
		$( "#attributeRequired" ).accordion({
    		collapsible: true
		});
	  } ); 
  </script> 
<%-- <script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/plugins/main/javascript/jquery-1.8.3.min.js"></script> --%>
<script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/plugins/main/javascript/tree.js"></script>
<script type="text/javascript" charset="UTF-8" src="${pageContext.request.contextPath}/plugins/main/javascript/wizard.js"></script>
 
  </body>
</html>