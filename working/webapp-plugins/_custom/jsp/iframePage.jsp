<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%
	String objectId = request.getParameter("objectId");
	String uid = request.getParameter("uid");
	String pwd = request.getParameter("pwd");
	
	if (uid == null || "".equals(uid) || pwd == null || "".equals(pwd)) {
	    uid = CustomProperties.getProperty("mstr.user.id");
	    pwd = CustomProperties.getProperty("mstr.user.pwd");
	}
	
	String sessionStr = (String)session.getAttribute("sessionStr");
	
	if (sessionStr == null || sessionStr.equals("")) {
	    WebIServerSession isession = MstrUtil.connectSession(CustomProperties.getProperty("mstr.server.name"), CustomProperties.getProperty("mstr.project.name"), uid, pwd);
	    sessionStr = isession.saveState();
	} else {
	    WebIServerSession isession = WebObjectsFactory.getInstance().getIServerSession();
	
	    isession.restoreState(sessionStr);
	    if (!isession.isAlive()) {
	        isession = MstrUtil.connectSession(CustomProperties.getProperty("mstr.server.name"), CustomProperties.getProperty("mstr.project.name"), uid, pwd);
	    }
	    sessionStr = isession.saveState();
	}
	
	session.setAttribute("sessionStr", sessionStr);
%><!DOCTYPE html><html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include flush="true" page="/_custom/jsp/include/pageCss.jsp"/>
<jsp:include flush="true" page="/_custom/jsp/include/pageJs.jsp"/>
<style type="text/css">
html, body {
    height:100%;
}

.header { height:70px; background-color:black; }
.navbar { height:50px;  }
.content { height:calc(100% - 170px); background-color:red; }
.footer { height:50px;  }

</style>
<script type="text/javascript">
</script>
</head>
<body>
<div class="header"></div>
<div class="navbar"></div>
<div class="content"></div>
<div class="footer"></div>
</body>
</html>