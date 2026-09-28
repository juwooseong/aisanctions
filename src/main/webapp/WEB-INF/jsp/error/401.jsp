<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="clearfix">
				<h1 class="display-3 mr-4"></h1>
				<h4 class="pt-3">사용자 정보가 존재하지 않습니다. </h4>
				<p class="text-muted">
			관리자에게 문의 부탁드립니다.
</p>
			</div>
			<div class="input-prepend input-group">
				<button id="loginBtn" class="btn btn-info" type="button">통합그룹웨어로 이동</button>
			</div>
		</div>
	</div>
</div>


<script>
$(document).on('click','#loginBtn', function(e) {
	
	// 통합그룹웨어로 이동
	var loginUrl = '<c:out value="${portal_login}"/>';
	location.href = loginUrl;
// 	if(opener){
// 		window.close();		
// 	}else{
// 		location.href = loginUrl;
// 	}
});

if(self !== top){
	// iframe
	$('#loginBtn').hide();
}else if(opener){
	$('#loginBtn').text('닫기');
}
</script>