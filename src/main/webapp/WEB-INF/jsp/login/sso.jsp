<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<form name="ssoForm" method="post" target="_self" action='<c:out value="${domain}"/>/login/sso/prx2'>
<input type="hidden" name="userID" value="<c:out value="${id}"/>" />
<input type="hidden" name="rand" value="<c:out value="${rand}"/>" />
</form>
<script>document.ssoForm.submit();</script>