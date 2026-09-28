<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="clearfix">
				<h1 class="float-left display-3 mr-4">501</h1>
				<h4 class="pt-3">Houston, we have a problem!</h4>
				<p class="text-muted">Method Not Implemented.</p>
			</div>
			<div class="input-prepend input-group">
				<button id="loginBtn" class="btn btn-info" type="button">메인으로 이동</button>
			</div>
		</div>
	</div>
</div>

<script>
$(document).on('click','#loginBtn', function(e) {
	
	// 메인으로 이동
	var loginUrl = '<c:out value="${domain}"/>';
	location.href = loginUrl;
});
</script>