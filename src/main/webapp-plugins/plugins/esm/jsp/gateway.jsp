<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><% 
	String url = String.format("%s/plugins/main/jsp/main2.jsp", request.getContextPath());
	//String url = String.format("%s/main", request.getContextPath());
	System.out.println("=> gateway.jsp -> url : " + url);
	
	response.sendRedirect(url);
%>