<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<!--
	Bootstrap .modal 구조 + 전역 $ 재할당(이 페이지가 레이아웃 jQuery+Bootstrap 위에
	jquery-1.11.3.js를 다시 로드함) 조합에서 레이어가 보이지 않는 문제가 있어, 이 화면에서
	이미 정상 동작 중인 anno_pin_modal(annotation.css .anno-pin-modal/.open)과 동일한
	방식으로 구성한다.
-->
<style>
#infoChangeModal {
	display: none;
	position: fixed;
	top: 0; right: 0; bottom: 0; left: 0;
	z-index: 4100;
	align-items: center;
	justify-content: center;
	background: rgba(15, 23, 42, 0.45);
}
#infoChangeModal.open {
	display: flex;
}
#infoChangeModal .info-chg-box {
	width: 480px;
	max-width: 92vw;
	max-height: 90vh;
	overflow-y: auto;
	background: #fff;
	border-radius: 6px;
	box-shadow: 0 8px 24px rgba(0,0,0,0.2);
}
#infoChangeModal .info-chg-head {
	padding: 12px 16px;
	background: #1e3a5f;
	color: #fff;
	font-weight: 700;
	font-size: 14px;
}
#infoChangeModal .info-chg-body {
	padding: 16px;
	min-height: 80px;
}
#infoChangeModal .info-chg-foot {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	padding: 10px 16px;
	border-top: 1px solid #e2e8f0;
	background: #f8fafc;
}
#infoChangeModal .info-chg-row {
	margin-bottom: 10px;
}
#infoChangeModal .info-chg-row label {
	display: block;
	font-size: 12px;
	color: #64748b;
	margin-bottom: 4px;
}
</style>
<div id="infoChangeModal">
	<div class="info-chg-box">
		<div class="info-chg-head">정보변경</div>
		<div class="info-chg-body" id="infoChangeBody">
			<!-- TODO: 정보변경 항목/입력 폼 -->
		</div>
		<div class="info-chg-foot">
			<button type="button" class="btn btn-sm btn-secondary" id="infoChangeCancelBtn">취소</button>
			<button type="button" class="btn btn-sm btn-primary" id="infoChangeSaveBtn">저장</button>
		</div>
	</div>
</div>
<script>

// TODO: 실제 엔드포인트 확정되면 이 URL만 교체.
var INFO_CHANGE_GET_URL = "/api/common/detail/getInfoChangeData";

function fn_openInfoChangeModal() {
	$('#infoChangeModal').addClass('open');
}

function fn_closeInfoChangeModal() {
	$('#infoChangeModal').removeClass('open');
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

$(document).on('click', '#infoChangeModal', function (e) {
	if (e.target && e.target.id === 'infoChangeModal') {
		fn_closeInfoChangeModal();
	}
});

$(document).on('click', '#infoChangeSaveBtn', function (e) {
	// TODO: 정보변경 저장 API 연동
	fn_closeInfoChangeModal();
});

</script>
