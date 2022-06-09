<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.mococo.web.core.util.CustomProperties"%>
<%@ page import="com.mococo.microstrategy.sdk.core.vo.MstrUser"%>
<%
	// http://localhost:8081/MicroStrategy/plugins/esm/jsp/sso.jsp?mstrUserId=jang
	
	String mstrUserId = request.getParameter("mstrUserId");	
	String mstrUserPwd = request.getParameter("mstrUserPwd");	

	/*
	  세션을 이용한 인증정보 전달 예시
	*/
	MstrUser mstrUser = new MstrUser(request.getParameter("mstrUserId"));
	
	session.setAttribute("mstr-user-vo", mstrUser);
	
	String url = String.format(
			"%s/servlet/mstrWeb?pg=gateway&server=%s&project=%s&port=%s", 
			request.getContextPath(),
			CustomProperties.getProperty("mstr.server.name"),
			CustomProperties.getProperty("mstr.default.project.name"),
			CustomProperties.getProperty("mstr.server.port")
	);
	
	System.out.println("=> sso.jsp -> url : " + url);
	System.out.println("==========================");
	response.sendRedirect(url);
	System.out.println(url);
	System.out.println("--------------------------");
	
%>