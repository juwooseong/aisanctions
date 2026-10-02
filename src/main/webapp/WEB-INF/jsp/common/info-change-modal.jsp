<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<!--
	이 페이지는 레이아웃에서 로드한 jQuery+Bootstrap 위에 구버전 jQuery(jquery-1.11.3.js)를
	다시 로드해서 전역 $를 덮어쓰기 때문에, Bootstrap의 $(...).modal() JS 플러그인을 쓸 수 없다
	(data-toggle/data-dismiss로 동작하는 nacrd_modal/extc_modal은 Bootstrap 내부 바인딩이라
	문제 없지만, 여기서처럼 AJAX 성공 후 직접 .modal('show')를 호출하면 "modal is not a function"
	에러가 난다). 그래서 보이는 모양은 Bootstrap 모달 구조를 그대로 쓰되, 열기/닫기는 순수 CSS
	클래스 토글(.info-chg-open)로 직접 제어한다.
-->
<style>
#infoChangeModal.info-chg-open {
	display: block;
}
</style>
<div class="modal fade" id="infoChangeModal" tabindex="-1" role="dialog" aria-labelledby="infoChangeModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<span class="width-100">
					<h4 class="modal-title" id="infoChangeModalLabel">정보변경</h4>
				</span>
			</div>
			<div class="modal-body" id="infoChangeBody">
				<!-- TODO: 정보변경 항목/입력 폼 -->
			</div>
			<div class="modal-footer" id="infoChangeModalFooter">
				<button class="btn btn-sm btn-secondary pl-xl-3 pr-xl-3 m-1" id="infoChangeCancelBtn">취소</button>
				<button class="btn btn-sm btn-primary pl-xl-3 pr-xl-3 m-1" id="infoChangeSaveBtn">저장</button>
			</div>
		</div>
	</div>
</div>
<script>

// TODO: 실제 엔드포인트 확정되면 이 URL만 교체.
var INFO_CHANGE_GET_URL = "/api/common/detail/getInfoChangeData";

$('#infoChangeModal').draggable({ handle: '.modal-header' });

function fn_openInfoChangeModal() {
	$('#infoChangeModal').addClass('info-chg-open').attr('aria-hidden', 'false');
}

function fn_closeInfoChangeModal() {
	$('#infoChangeModal').removeClass('info-chg-open').attr('aria-hidden', 'true');
}

// 조회된 정보로 모달 body를 채운다. 실제 필드가 정해지면 이 함수만 수정하면 된다.
function fn_renderInfoChangeData(data) {
	$('#infoChangeBody').empty();
	if (!data) { return; }
	$.each(data, function (key, val) {
		$('#infoChangeBody').append(
			$('<div class="info-chg-row"></div>')
				.append($('<label></label>').text(key))
				.append($('<input type="text" class="form-control" readonly>').val(val).attr('data-field', key))
		);
	});
}

// "정보변경" 버튼 클릭 - API 조회 후 성공 시에만 팝업 오픈
$(document).on('click', '#infoChangeBtn', function (e) {
	e.preventDefault();

	var _inptMstSrno = globalInptMstSrno;

	$.ajax({
		url: INFO_CHANGE_GET_URL,
		type: "post",
		cache: false,
		data: { inptMstSrno: _inptMstSrno },
		dataType: "json",
		success: function (data) {
			fn_renderInfoChangeData(data);
			fn_openInfoChangeModal();
		},
		error: function (e) {
			alert('정보변경 조회에 실패했습니다.');
		}
	});
});

$(document).on('click', '#infoChangeCancelBtn', function (e) {
	fn_closeInfoChangeModal();
});

$(document).on('click', '#infoChangeSaveBtn', function (e) {
	// TODO: 정보변경 저장 API 연동
	fn_closeInfoChangeModal();
});

</script>
