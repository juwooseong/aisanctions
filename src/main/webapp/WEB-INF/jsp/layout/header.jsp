<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="gnbWrap">
	<ul class="gnb" id="main_menu_zone">
	</ul>
	<p>
		<a id="user_logout" href="javascript:void(0);">
<%-- 			<img src="${ctx_res}/img/userIcon.png" alt=""/> --%>
			<i class="fa fa-sign-out fa-lg logout" data-toggle="tooltip" data-placement="top" title="로그아웃"></i>
		</a>
	</p>
	<p id="loginInfo" class="login-info"></p>
	<span class="absenceInfoWrapper" id="absenceChangeBtn">
        <span class="absenceInfoWrap">
            <i class="fa fa-user fa-lg mt-4 absenceInfoIcon"></i>
        </span>
    </span>
    <form id="selfAbsenceProcParams"></form>
</div>
