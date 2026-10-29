<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>정보변경</title>
	<link rel="shortcut icon" type="image/x-icon" href="${ctx_res}/img/logo_s.png">
	<link href="${ctx_res}/css/info-change.css" rel="stylesheet">
	<script src="${ctx_res}/vendors/jquery/js/jquery.min.js"></script>
	<%-- 사용자 조회 레이어(user-picker.jsp) 그리드용 --%>
	<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
	<style>
	body { margin: 0; background: #fff; }
	</style>
</head>
<body>
	<!-- .info-chg 블록은 다른 엘리먼트 안에 그대로 넣어도 동일하게 표시된다 (info-change.css) -->
	<div class="info-chg">
		<div class="info-chg-head">정보변경</div>
		<div class="info-chg-body">
			<form id="infoChangeForm" onsubmit="return false;">
				<input type="hidden" name="inptMstSrno" value="<c:out value="${inptMstSrno}"/>">
				<!-- TODO: 실제 항목 확정 시 아래 샘플(입력 종류별 1개씩)을 교체 -->
				<!-- 입력 폭: class="info-chg-w60 ~ info-chg-w300"(20px 단위) 지정, 미지정 시 칸 폭 100% -->
				<!--
					행(.info-chg-row)마다 항목(.info-chg-item) 수 자유, 같은 행 항목은 폭 균등
					항목 안 라벨(.info-chg-th) : 입력(.info-chg-td) = 3 : 7 유지
					넓은 항목은 info-chg-span-N (N칸 차지, 라벨 폭은 1칸 항목과 동일)
					기본 3칸 기준 : 모든 행의 칸 합계를 3으로 맞추면 라벨 줄이 맞고 colspan 처럼 보임
				-->
				<div class="info-chg-form">
					<!-- 3칸: 1 + 1 + 1 -->
					<div class="info-chg-row">
						<div class="info-chg-item">
							<div class="info-chg-th">텍스트&nbsp;<span class="info-chg-req">*</span></div>
							<div class="info-chg-td">
								<!-- 사용자 조회 레이어(user-picker.jsp) 연동 : 조회 버튼 / Enter -->
								<div class="info-chg-search info-chg-w180">
									<input type="text" class="info-chg-input" name="sampleText" maxlength="50" placeholder="직원번호/직원명">
									<input type="hidden" name="sampleTextEno">
									<button type="button" class="info-chg-btn info-chg-btn-secondary" id="sampleTextSearchBtn">조회</button>
								</div>
							</div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">읽기전용</div>
							<div class="info-chg-td"><input type="text" class="info-chg-input info-chg-w120" name="sampleReadonly" value="수정 불가 값" readonly></div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">숫자</div>
							<div class="info-chg-td"><input type="number" class="info-chg-input info-chg-w80 is-num" name="sampleNumber" min="0" placeholder="0"></div>
						</div>
					</div>
					<!-- 3칸: 1 + 1 + 1 -->
					<div class="info-chg-row">
						<div class="info-chg-item">
							<div class="info-chg-th">금액</div>
							<div class="info-chg-td"><input type="text" class="info-chg-input info-chg-w140 is-num" name="sampleAmount" placeholder="0"></div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">날짜</div>
							<div class="info-chg-td"><input type="date" class="info-chg-input info-chg-w140" name="sampleDate"></div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">시간</div>
							<div class="info-chg-td"><input type="time" class="info-chg-input info-chg-w100" name="sampleTime"></div>
						</div>
					</div>
					<!-- 3칸: 1 + 1 + 1 -->
					<div class="info-chg-row">
						<div class="info-chg-item">
							<div class="info-chg-th">전화번호</div>
							<div class="info-chg-td"><input type="tel" class="info-chg-input info-chg-w120" name="sampleTel" maxlength="13" placeholder="010-0000-0000"></div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">선택(콤보)</div>
							<div class="info-chg-td">
								<select class="info-chg-input info-chg-w120" name="sampleSelect">
									<option value="">선택하세요</option>
									<option value="01">항목1</option>
									<option value="02">항목2</option>
									<option value="03">항목3</option>
								</select>
							</div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">라디오</div>
							<div class="info-chg-td">
								<label class="info-chg-opt"><input type="radio" name="sampleRadio" value="Y" checked> 예</label>
								<label class="info-chg-opt"><input type="radio" name="sampleRadio" value="N"> 아니오</label>
							</div>
						</div>
					</div>
					<!-- 3칸: 2 + 1 -->
					<div class="info-chg-row">
						<div class="info-chg-item info-chg-span-2">
							<div class="info-chg-th">이메일</div>
							<div class="info-chg-td"><input type="email" class="info-chg-input info-chg-w200" name="sampleEmail" placeholder="name@example.com"></div>
						</div>
						<div class="info-chg-item">
							<div class="info-chg-th">조회</div>
							<div class="info-chg-td">
								<div class="info-chg-search info-chg-w160">
									<input type="text" class="info-chg-input" name="sampleSearch" placeholder="코드" readonly>
									<button type="button" class="info-chg-btn info-chg-btn-secondary" id="sampleSearchBtn">조회</button>
								</div>
							</div>
						</div>
					</div>
					<!-- 3칸: 3 (한 행 전체) -->
					<div class="info-chg-row">
						<div class="info-chg-item info-chg-span-3">
							<div class="info-chg-th">체크박스</div>
							<div class="info-chg-td">
								<label class="info-chg-opt"><input type="checkbox" name="sampleCheck" value="A"> A</label>
								<label class="info-chg-opt"><input type="checkbox" name="sampleCheck" value="B"> B</label>
								<label class="info-chg-opt"><input type="checkbox" name="sampleCheck" value="C"> C</label>
							</div>
						</div>
					</div>
					<!-- 3칸: 3 (한 행 전체) -->
					<div class="info-chg-row">
						<div class="info-chg-item info-chg-span-3">
							<div class="info-chg-th">여러 줄 텍스트</div>
							<div class="info-chg-td"><textarea class="info-chg-input" name="sampleTextarea" maxlength="1000" placeholder="내용 입력"></textarea></div>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="info-chg-foot">
			<button type="button" class="info-chg-btn info-chg-btn-secondary" id="infoChangeCancelBtn">닫기</button>
			<button type="button" class="info-chg-btn info-chg-btn-primary" id="infoChangeSaveBtn">저장</button>
		</div>
	</div>

<%@include file="/WEB-INF/jsp/common/user-picker.jsp"%>

<script>
// TODO: 실제 엔드포인트 확정되면 URL 교체
var INFO_CHANGE_GET_URL = "/api/common/detail/getInfoChangeData";

// 팝업 창 크기 고정 : Chrome/Edge 는 window.open 의 resizable=0 을 무시하므로 크기가 바뀌면 처음 크기로 되돌림
$(window).on('load', function () {
	if (!window.opener) {
		return;
	}
	var _fixW = window.outerWidth;
	var _fixH = window.outerHeight;
	var _resizeTimer = null;

	$(window).on('resize', function () {
		clearTimeout(_resizeTimer);
		_resizeTimer = setTimeout(function () {
			if (window.outerWidth !== _fixW || window.outerHeight !== _fixH) {
				window.resizeTo(_fixW, _fixH);
			}
		}, 100);
	});
});

// 금액: 숫자만 입력 + 천단위 콤마
$(document).on('input', '[name="sampleAmount"]', function () {
	var _num = this.value.replace(/[^0-9]/g, '');
	this.value = _num ? Number(_num).toLocaleString() : '';
});

// 텍스트: 사용자 조회 레이어 호출 → 선택 시 직원명 표시, 직원번호는 hidden 에 보관
function fn_openUserPickerForText() {
	fnUserPickerOpen({
		keyword : $.trim($('[name="sampleText"]').val()),
		onSelect: function (row) {
			$('[name="sampleText"]').val(row.aiInptUserNm);
			$('[name="sampleTextEno"]').val(row.aiInptUserEno);
		}
	});
}
$(document).on('click', '#sampleTextSearchBtn', fn_openUserPickerForText);
$(document).on('keyup', '[name="sampleText"]', function (e) {
	if (e.keyCode === 13) {
		fn_openUserPickerForText();
	}
});
// 직접 수정하면 이전에 선택한 직원번호는 무효
$(document).on('input', '[name="sampleText"]', function () {
	$('[name="sampleTextEno"]').val('');
});

// 조회: 코드 검색 팝업 등 연동 자리 (샘플은 값만 세팅)
$(document).on('click', '#sampleSearchBtn', function () {
	// TODO: 검색 팝업/API 연동
	$('[name="sampleSearch"]').val('A001');
});

// 전화번호: 숫자만 입력 + 하이픈 자동
$(document).on('input', '[name="sampleTel"]', function () {
	var _num = this.value.replace(/[^0-9]/g, '').slice(0, 11);
	this.value = _num.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, '$1-$2-$3');
});

$(document).on('click', '#infoChangeCancelBtn', function () {
	window.close();
});

$(document).on('click', '#infoChangeSaveBtn', function () {
	if (!$.trim($('[name="sampleText"]').val())) {
		alert('텍스트 항목을 입력하세요.');
		$('[name="sampleText"]').focus();
		return;
	}
	// TODO: 정보변경 저장 API 연동 ($('#infoChangeForm').serialize())
	//       저장 후 부모(심사상세) 재조회가 필요하면 opener.fn_getBLData("A") 호출
	window.close();
});
</script>
</body>
</html>
