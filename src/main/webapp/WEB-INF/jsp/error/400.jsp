<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="clearfix">
				<h1 class="display-3 mr-4">400</h1>
				<h4 class="pt-3">죄송합니다. <br/>잘못된 요청으로 페이지에 접근할 수 없습니다.</h4>
				<p class="text-muted">
			방문하시려는 페이지의 주소가 잘못 입력되었거나,
			페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.<br/>
			입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.
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