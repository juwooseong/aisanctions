<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="clearfix">
				<h1 class="display-3 mr-4">500</h1>
				<h4 class="pt-3">시스템에서 요청을 수행할 수 없습니다.</h4>
				<p class="text-muted">서버에 오류가 발생했습니다. 잠시후에 다시 접속하시거나<br/>
				지속적으로 문제가 발생할 시 관리자에게 문의해 주시길 바랍니다.<br/>
				불편을 끼쳐드려 죄송합니다.<br/>
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