<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="clearfix">
				<h1 class="display-3 mr-4">403</h1>
				<h4 class="pt-3">죄송합니다. <br/>접근이 제한된 페이지에 대한 요청입니다.</h4>
				<p class="text-muted">
	접근이 제한된 사용자입니다.<br/>
	인증정보를 다시 한번 확인 하시거나
	관리자에게 문의하시기 바랍니다.
</p>
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