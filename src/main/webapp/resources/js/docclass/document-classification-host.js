/* 심사상세 — 문서분류 V4 일괄변경 팝업 호스트 */
(function (window, $) {
	'use strict';

	if (!$) {
		return;
	}

	function dcCtx() {
		return (typeof ctx === 'string') ? ctx : '';
	}

	function dcApi(path) {
		return dcCtx() + path;
	}

	function currentMstSrno() {
		var mst = '';
		if (typeof globalInptMstSrno !== 'undefined' && globalInptMstSrno) {
			mst = String(globalInptMstSrno);
		}
		if ((!mst || mst === '0') && typeof pageParams !== 'undefined' && pageParams && pageParams.inptMstSrno) {
			mst = String(pageParams.inptMstSrno);
		}
		if ((!mst || mst === '0') && typeof g_getUrlVar === 'function') {
			try {
				mst = String(g_getUrlVar('inptMstSrno') || '').replace('#', '');
			} catch (e) {
				mst = mst || '';
			}
		}
		return mst;
	}

	function isReadOnly() {
		return typeof globalCallType !== 'undefined' && (globalCallType === 'E' || globalCallType === 'F');
	}

	function isDirty(modal) {
		if (!modal || typeof modal.getSavePayload !== 'function') {
			return false;
		}
		var p = modal.getSavePayload('delta');
		return !!(p && p.datasets && (
			(p.datasets.pages && p.datasets.pages.length) ||
			(p.datasets.groups && p.datasets.groups.length) ||
			(p.datasets.buckets && p.datasets.buckets.length)
		));
	}

	function reloadDetail() {
		if (typeof fn_getBLData === 'function') {
			fn_getBLData(typeof globalCallType === 'string' && globalCallType ? globalCallType : 'A');
		}
	}

	$(function () {
		if (typeof window.DocumentClassificationModal !== 'function') {
			return;
		}
		if (!$('#documentClassificationModal').length) {
			return;
		}

		var modal = new window.DocumentClassificationModal({
			titleBase: '문서분류 · 그룹 일괄 변경',
			showTitleRefNo: true,
			pluginOptions: {
				autoLoad: false,
				saveUrl: dcApi('/api/doc-class/save'),
				saveDatasetMode: 'delta',
				renumberAfterEmptyDelete: true,
				includeAllBlGroupsInMoveCombo: true,
				allowGroupAdd: true,
				rememberDocTypeScroll: false,
				showRefNoBar: true,
				refNoBarBoxed: true,
				showJsonPreview: false,
				showPerfStats: false,
				showGuide: false,
				showChangeLog: false
			},
			onSaved: function () {
				alert('문서분류가 저장되었습니다.');
				modal.close(true);
				reloadDetail();
			},
			onError: function (err) {
				var msg = (err && err.error && err.error.message) ? err.error.message : '문서분류 처리에 실패했습니다.';
				alert(msg);
			}
		}).mount();

		var origClose = modal.close.bind(modal);
		modal.close = function (force) {
			if (!force && isDirty(modal) && !window.confirm('저장하지 않은 변경이 있습니다. 닫을까요?')) {
				return this;
			}
			return origClose();
		};

		window.dcClassificationModal = modal;

		$(document).on('click', '#docClassBatchBtn', function (e) {
			e.preventDefault();
			var mst = currentMstSrno();
			if (!mst || mst === '0') {
				alert('심사건 번호가 없어 일괄변경을 열 수 없습니다.');
				return;
			}
			if (typeof s_loading === 'function') {
				s_loading();
			}
			$.ajax({
				url: dcApi('/api/doc-class/' + encodeURIComponent(mst)),
				type: 'GET',
				dataType: 'json'
			}).done(function (res) {
				if (typeof h_loading === 'function') {
					h_loading();
				}
				if (!res || String(res.resultCode) !== '200' || !res.data) {
					alert((res && res.resultExMsg) ? res.resultExMsg : '문서분류 데이터를 불러오지 못했습니다.');
					return;
				}
				var readOnly = isReadOnly();
				modal.setOptions({ readOnly: readOnly });
				$('#documentClassificationModal').toggleClass('read-only', readOnly);
				modal.setData(res.data);
				modal.open();
			}).fail(function () {
				if (typeof h_loading === 'function') {
					h_loading();
				}
				alert('문서분류 데이터를 불러오지 못했습니다.');
			});
		});
	});
})(window, window.jQuery);
