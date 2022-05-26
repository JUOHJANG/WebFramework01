<%
    /*
     * Logout_Links.jsp
     * Copyright 2001 MicroStrategy Incorporated. All rights reserved.
     */
%>

<%@ page errorPage="Error_Links.jsp"%>
<%@ taglib uri="/webUtilTL.tld" prefix="web"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.microstrategy.web.app.beans.PageComponent"%>

<%
PageComponent mstrPage = (PageComponent)request.getAttribute("mstrPage");

// TODO : MSTR세션정보를 담은 웹세션애트리뷰트 초기화 
%>
<%--
 Display the "links" section of the template as specified in pageConfig.xml (i.e. Admin_Links.jsp)
 <jsp:include page="[a page section]" />
--%>
<jsp:include page='<%=mstrPage.getTemplateInfo().getDefaultTemplate().getSection("links")%>' flush="true" />
<script>
<web:pageState attribute="var pageState" stateLevel="0"/>;
</script>

<web:resource type="style" name="mstr/pageLoggedOut.css"/>

