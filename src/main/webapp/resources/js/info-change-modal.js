/* 정보변경 레이어 팝업: 심사자(globalCallType == "A") 심사상세 화면 하단 "정보변경" 버튼용. */
(function () {
	"use strict";

	function openModal() {
		$('#infoChangeModal').addClass('open');
	}

	function closeModal() {
		$('#infoChangeModal').removeClass('open');
	}

	$(document).on('click', '#infoChangeBtn', function (e) {
		e.preventDefault();
		openModal();
	});

	$(document).on('click', '[data-ic-close]', function (e) {
		e.preventDefault();
		closeModal();
	});

	$(document).on('click', '#infoChangeModal', function (e) {
		if (e.target && e.target.id === 'infoChangeModal') {
			closeModal();
		}
	});

	$(document).on('click', '[data-ic-save]', function (e) {
		e.preventDefault();
		// TODO: 정보변경 저장 API 연동
		closeModal();
	});
})();
