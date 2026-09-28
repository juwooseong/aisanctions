<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script>
console.log('[proc.jsp] script run');
console.log('[proc.jsp] sessionStorage ' + sessionStorage);
sessionStorage.clear();
location.href = '/index';

</script>