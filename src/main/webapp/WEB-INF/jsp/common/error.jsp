<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>오류</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/egovframework/sample.css'/>" />
<style>
.error-container {
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 100vh;
	padding-top: 150px;
}
.error-message {
	font-family: Tahoma, sans-serif;
	font-weight: bold;
	color: #000000;
	line-height: 150%;
	width: 440px;
	min-height: 70px;
}
</style>
</head>
<body>
<div class="error-container">
	<div class="error-message">
		<span class="<spring:message code='image.errorBg' />"></span>
	</div>
</div>
</body>
</html>
