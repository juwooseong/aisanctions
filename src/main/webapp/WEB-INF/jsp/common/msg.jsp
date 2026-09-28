<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script>
var msg = '<c:out value="${msg}"/>';
var closeYN = '<c:out value="${closeYN}"/>';
alert(msg);
if(closeYN=='Y'){
	window.close();
}
</script>