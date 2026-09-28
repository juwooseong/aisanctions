<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div id="mask">
	<div class="card mask_card">
		<div class="card-header" id="maskTitle"></div>
		<div class="card-body">
			<div class="progress">
				<div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
			</div>
		</div>
	</div>
</div>
<script>

//마스크 세팅
function setMask(maskTitle) {
	
	$('#maskTitle').text(maskTitle);
	
	//화면 높이 너비 구하기
	var _maskHeight = $(document).height();
	var _maskWidth = $(window).width();
	
	//마스크 높이로  화면전체 세팅
	$('#mask').css({'width': _maskWidth, 'height': _maskHeight});
	
	$('#mask').show();
	
}


//마스크 세팅
function removeMask() {
	
	$('#mask').hide();
	
}

</script>