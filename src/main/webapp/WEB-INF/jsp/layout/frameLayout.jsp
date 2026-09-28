<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="Cache-Controll" content="no-store"/>
		<meta http-equiv="Pragma" content="no-cashe"/>
		<meta http-equiv="Expires" content="0"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
		<meta name="description" content="심사자동화">
		<meta name="author" content="심사자동화">
		<meta name="keyword" content="Bootstrap,Admin,Template,Open,Source,jQuery,CSS,HTML,RWD,Dashboard">
		<title>심사자동화</title>
		<link rel="shortcut icon" type="image/x-icon"  href="${ctx_res}/img/logo_s.png" rel="stylesheet">
		<link href="${ctx_res}/vendors/@coreui/icons/css/coreui-icons.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/flag-icon-css/css/flag-icon.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/simple-line-icons/css/simple-line-icons.css" rel="stylesheet">
		<link href="${ctx_res}/css/custom_style.css" rel="stylesheet">
	
		<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
		<script src="${ctx_res}/vendors/jquery/js/jquery.form.js"></script>
	    <script src="${ctx_res}/vendors/popper.js/js/popper.min.js"></script>
	    <script src="${ctx_res}/vendors/bootstrap/js/bootstrap.min.js"></script>
	    <script src="${ctx_res}/vendors/pace-progress/js/pace.min.js"></script>
	    <script src="${ctx_res}/vendors/perfect-scrollbar/js/perfect-scrollbar.min.js"></script>
	    <script src="${ctx_res}/vendors/@coreui/coreui/js/coreui.min.js"></script>
	    <script src="${ctx_res}/vendors/moment/moment.min.js"></script>
	    <script src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
	    <script src="${ctx_res}/vendors/pickers/datepicker.js"></script>
	    <script src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
	    <script src="${ctx_res}/js/sweet_alert.min.js"></script>
	    
		<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
		<script type="text/javascript" src="${ctx_res}/js/common.js"></script>
		<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
		<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
		<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
		<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
	</head>
	<body style="overflow-y:auto;">
	    <script>
// 	    	var env_mode = '<c:out value="${env_mode}"/>';
// 		   	var env_mode_name = "";
// 		   	if (env_mode == 'local') {
// 		   		env_mode_name = "로컬";
// 		   	} else if (env_mode == 'dev') {
// 		   		env_mode_name = "개발";
// 		   	} else if (env_mode == 'op') {
// 		   		env_mode_name = "운영";
// 		   	}
			var loginUrl = '<c:out value="${portal_login}"/>';
	    </script>
	
	
		<tiles:insertAttribute name="contents" />
		
		<script>
		    
			APP.setCtx('${pageContext.request.contextPath}');
		
			document.addEventListener('DOMContentLoaded', function() {
			let $active_menu = $('div.sidebar a[href=\''+document.location.pathname+'\']');
			$('#dev-s-title').text($active_menu.text().trim());
			let _stitle = $active_menu.parents('ul.nav-dropdown-items').prev('a').text();
			if(_stitle){
				$('#dev-m-title').text(_stitle).show();
			}else{
				$('#dev-m-title').hide();
			}
		}, true);
			
		</script>
	</body>
</html>