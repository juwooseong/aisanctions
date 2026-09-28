<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="container">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<form action="${ctx}/login" method="post" id="tnt_login">
				<div class="card-group">
					<div class="card p-4">
						<div class="card-body">
							<h1>Login</h1>
							<p class="text-muted">Sign In to your account</p>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"> <i class="icon-user"></i>
									</span>
								</div>
								<input id="txt_id" name="id" value="review01" class="form-control" type="text" placeholder="Username">
							</div>
							<div class="input-group mb-4">
								<div class="input-group-prepend">
									<span class="input-group-text"> <i class="icon-lock"></i>
									</span>
								</div>
								<input id="txt_pw" name="pw" class="form-control" type="password" placeholder="Password">
							</div>
							<div class="row">
								<div class="col-6">
									<button class="btn btn-primary px-4" type="button" id="login_submit" onclick="fnLogin();">Login</button>
								</div>
							</div>
						</div>
					</div>
				
				</div>
			</form>
		</div>
	</div>
</div>

<script src="${ctx_res}/vendors/jquery/js/jquery.validate.js"></script>
<script src="${ctx_res}/js/validation.js"></script>
<script>
$(function(){
	if(self !== top){
		// iframe
		parent.document.location.reload();
	}else 
		if(opener){
		// 팝업일 경우
		alert('세션이 만료되었습니다.');
		opener.document.location.reload();
		window.close();
	} 
});

$(document).on('keyup', '#txt_id, #txt_pw', function(e) {
	if(e.keyCode === 13) {
		fnLogin();
	}
});

function fnLogin(){
	var formLogin = $("#tnt_login")[0];
	
	if($.trim(formLogin.id.value).length > 8){
		alert("아이디는 8자리입니다.");
		formLogin.id.focus();
		return;
	}
	
	if($.trim(formLogin.id.value)==""){
		alert("아이디를 입력해주세요.");
		formLogin.id.focus();
		return;
	}

	$.ajax({
		url: '/api/common/login',
		data: $(formLogin).serialize(),
		method: 'post'
	}).done(function(data){
		if(data.resultCode=="200"){
			
			//sessionStorage 초기화
			sessionStorage.clear();
			
			//auth sessionStorage에 추가
			var _auth_data = {
				"auth" : data.auth,
				"name" : data.name,
				"admin_yn" : data.adminYN,
				"loginDtm" : data.loginDtm,
				"finloginDtm" : data.finloginDtm,
				"absence" : data.absence,
				"eno" : data.eno
			};
			sessionStorage.auth_data = JSON.stringify(_auth_data);
			
			location.href = '/index';
		} else {
			alert(data.resultMsg);
		}
	});
}
</script>