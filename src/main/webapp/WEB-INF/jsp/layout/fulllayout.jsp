<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="Cache-Controll" content="no-store"/>
		<meta http-equiv="Pragma" content="no-cashe"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
		<meta name="description" content="심사자동화 시스템">
		<meta name="author" content="Łukasz Holeczek">
		<meta name="keyword" content="Bootstrap,Admin,Template,Open,Source,jQuery,CSS,HTML,RWD,Dashboard">
		<title>심사자동화</title>
		<link rel="shortcut icon" type="image/x-icon"  href="${ctx_res}/img/logo_s.png" rel="stylesheet">
		<link href="${ctx_res}/vendors/@coreui/icons/css/coreui-icons.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/flag-icon-css/css/flag-icon.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/simple-line-icons/css/simple-line-icons.css" rel="stylesheet">
		<link href="${ctx_res}/css/style.css" rel="stylesheet">
		<link href="${ctx_res}/vendors/pace-progress/css/pace.min.css" rel="stylesheet">
		
		<script src="${ctx_res}/vendors/jquery/js/jquery.min.js"></script>
		<script src="${ctx_res}/vendors/jquery/js/jquery.form.js"></script>
		<script src="${ctx_res}/vendors/popper.js/js/popper.min.js"></script>
		<script src="${ctx_res}/vendors/bootstrap/js/bootstrap.min.js"></script>
		<script src="${ctx_res}/vendors/pace-progress/js/pace.min.js"></script>
		<script src="${ctx_res}/vendors/perfect-scrollbar/js/perfect-scrollbar.min.js"></script>
		<script src="${ctx_res}/vendors/@coreui/coreui/js/coreui.min.js"></script>
		<script type="text/javascript" src="${ctx_res}/js/common_popup.js"></script>

		<script type="text/javascript">
			var startpos, diffpos=0, min=80, endw;
			var isEnable = false;
			function init(){
				var lw = $('.section_cate').width(),
					rw = $('.section_view').width(),
					ww = $('.section_wrapper').width() - 60;
				
				$('.center').eq(0).on('mousedown',function(e){
					ww = $('.section_wrapper').width() - 60;
					isEnable = true;
					return false;
				});
				$(document).on('mouseup',function(e){
					endw = $('.section_cate').width(); 
					isEnable = false;
					return false;
				});
				$('body').on('mousemove',function(e){
					if(isEnable){
						
						diffpos = event.clientX;
						ww = $('.section_wrapper').width();
						
						if (diffpos > 740 && ww - diffpos > 465) {
							
							$('.section_cate').css('width' ,(diffpos - 100) + 'px');
							$('.section_view').css('width' ,(ww - diffpos) + 'px');
							
							$('.title').height($('#bl_list').height());
						}
					}
				});
			}
			
			$(window).on('resize', function(){
				
				setTimeout(function() {
					$('.section_cate').css('width' , '640px');
					ww = $('.section_wrapper').width() - 60;
					$('.section_view').css('width' ,(ww - 680) + 'px');
					
					$('.title').height($('#bl_list').height());
				}, 100);
			})
		</script>
	</head>
   
<body class="app flex-row align-items-center" onload="init();">
	<script>
    	var bprUrl = '<c:out value="${bpr_url}"/>';
		var loginUrl = '<c:out value="${portal_login}"/>';
	</script>

	<div class="app-body">
		<tiles:insertAttribute name="contents" />
	</div>

</body>
</html>

