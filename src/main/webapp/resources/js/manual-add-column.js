/* ============================================================================
 * manual-add-column.js
 * ----------------------------------------------------------------------------
 * "수기 추가" 동적 컬럼 기능 (1011 상세 화면, 항목심사 그리드) — 완전 분리 애드온.
 *
 * 설계 원칙: common_detail.js(기존 소스)는 단 한 글자도 수정하지 않는다.
 * 이 파일이 common_detail.js보다 "나중에" 로드된다는 점을 이용해, common_detail.js가
 * 전역으로 정의해 둔 함수 2개(fn_dataTableComplete, fn_setTmpParam)를 "몽키패치"
 * (원본 함수를 감싸는 새 함수로 교체)해서 동작을 덧붙인다. 이 파일을 로드하지 않으면
 * common_detail.js는 원래 동작 그대로 완전히 정상 작동한다(이 파일 존재 여부에
 * 의존하지 않음).
 *
 * 핵심 아이디어 — DataTables의 columns[].data 옵션 활용:
 *   원래 항목심사 그리드는 "컬럼 순서 = 데이터 배열 순서"였다(암묵적 매핑).
 *   이 파일은 각 컬럼에 명시적으로 columns[].data = <원본 데이터 배열 인덱스> 를
 *   지정해서, "화면에 보이는 컬럼 순서"와 "데이터 배열 안에서의 위치"를 분리한다.
 *   그 결과 common_detail.js의 fn_setSanctionRst()가 만드는 13칸짜리 원본 데이터
 *   배열([No,≠,항목,항목내용,수기입력,Alert내용,계산기아이콘,altYn,sanctionNo,
 *   imexHisCd,taskId,stRstKind,concatImexHisCd])은 전혀 손대지 않고 그대로 두면서,
 *   "수기 추가" 컬럼들(data:null, 자체 render 함수로 입력칸을 그림)만 "수기입력"
 *   (data-index 4) 바로 뒤에 화면상으로만 끼워 넣을 수 있다.
 *
 * 서버 저장/조회 연동은 docs/feature-manual-add-column.md 문서와 아래 파일들 참고
 * (이쪽은 순수 UI 파일 분리와 무관하게 그대로 유지됨):
 *   - sql/34_manual_add_extra_cols.sql (CSPD004TF 컬럼 3개)
 *   - CommonRevertDetail_SQL.xml / CommonRevertDetailVO.java /
 *     CommonRevertDetailApiController.java / CommonRevertDetailServiceImpl.java
 * ============================================================================ */
(function () {
	"use strict";

	// ---- 읽기전용 모드(결재자 화면 등): true면 컬럼 추가/삭제 버튼과 입력칸을 비활성화하고
	//      이미 저장된 "수기 추가" 컬럼/값만 조회용으로 보여준다. 화면 jsp에서
	//      <script>보다 먼저 window.MANUAL_COL_READONLY = true; 를 세팅해서 사용한다. ----
	var READONLY = window.MANUAL_COL_READONLY === true;

	// ---- 최대 개수 ----
	var MANUAL_COL_MAX_CNT = 3;

	// ---- 현재 화면에 떠 있는 "수기 추가" 컬럼 목록. 배열 순서 = 화면 표시 순서이자
	//      서버 저장 시 Add1/Add2/Add3에 대응되는 순번(position)이기도 하다. ----
	var extraManualCols = [];
	var extraManualColSeq = 0;

	// ---- "수기 추가" 입력칸 최대 글자수 ----
	var MANUAL_COL_MAX_LEN = 200;

	// ---- 입력값 저장소: { colId : { rowKey : 값 } }. rowKey는 "taskId_sanctionNo". ----
	window.extraManualColValues = window.extraManualColValues || {};

	function manualColRowKey(inptTaskId, inptSanctionNo) {
		return inptTaskId + '_' + inptSanctionNo;
	}

	// 국가코드 자동세팅(수기 추가 컬럼 전용): detail.jsp의 fn_itmInptHndgInpDatTextChage와 같은 규칙
	// (countryCodeData로 소스sanctionNo → 타겟sanctionNo 매핑)을 쓰되, 원본 fn_getNationCd는
	// 항상 원본 "수기입력" <input id="index_N">만 갱신하도록 고정되어 있어 재사용할 수 없다.
	// 그래서 "수기 추가" 컬럼 안에서는(같은 colId의, 타겟 행 칸에) 직접 채워 넣는 전용 로직을 둔다.
	function applyNationCdAutoSetForManualCol(val, colId, rowKey) {
		if (typeof window.countryCodeData !== 'object') {
			return;
		}
		var sep = rowKey.lastIndexOf('_');
		if (sep < 0) { return; }
		var inptSanctionNo = rowKey.substring(sep + 1);
		var tmpCode = "code_" + inptSanctionNo;
		var mappedSanctionNo = window.countryCodeData[tmpCode];
		if (!mappedSanctionNo) { return; }
		var trimmed = (val || '').trim();
		if (trimmed === '') { return; }

		$.ajax({
			url: "/api/common/detail/getNationCd",
			type: "post",
			cache: false,
			data: { itmInptHndgInpDatTxt: trimmed },
			dataType: "json",
			success: function (data) {
				var nationCd = data && data.nationCd;
				if (!nationCd) { return; }

				var list = window.globalSanctionRstListData || [];
				for (var i = 0; i < list.length; i++) {
					if (String(list[i][8]) !== String(mappedSanctionNo)) { continue; }

					var targetRowKey = manualColRowKey(list[i][10], list[i][8]);
					if (!window.extraManualColValues[colId]) {
						window.extraManualColValues[colId] = {};
					}
					window.extraManualColValues[colId][targetRowKey] = nationCd;

					var $targetInput = $('input.manual-col-input[data-colid="' + colId + '"][data-rowkey="' + targetRowKey + '"]');
					if ($targetInput.length > 0) {
						$targetInput.val(nationCd);
					}
				}
			}
		});
	}

	// input onchange 시 값 기록 (렌더링된 <input>의 인라인 onchange에서 이 전역 함수를 호출한다)
	window.fn_manualColValueChange = function (ele, colId, rowKey) {
		if (ele.value && ele.value.length > MANUAL_COL_MAX_LEN) {
			ele.value = ele.value.substring(0, MANUAL_COL_MAX_LEN);
		}
		if (!window.extraManualColValues[colId]) {
			window.extraManualColValues[colId] = {};
		}
		window.extraManualColValues[colId][rowKey] = ele.value;
		applyNationCdAutoSetForManualCol(ele.value, colId, rowKey);
	};

	// 서버에서 조회해온 sanctionRst 데이터에 이미 저장된 "수기 추가" 값이 있으면
	// 그 개수만큼 extraManualCols를 미리 채워 자동으로 컬럼이 노출되게 한다.
	function ensureColsFromLoadedData() {
		var arr = (window.$globaObjlData && window.$globaObjlData.sanctionRst) ? window.$globaObjlData.sanctionRst : [];
		if (!arr || arr.length === 0) { return; }

		var needed = 0;
		for (var i = 0; i < arr.length; i++) {
			var row = arr[i];
			if (row.itmInptHndgAdd3Txt) { needed = Math.max(needed, 3); }
			else if (row.itmInptHndgAdd2Txt) { needed = Math.max(needed, 2); }
			else if (row.itmInptHndgAdd1Txt) { needed = Math.max(needed, 1); }
		}
		if (needed === 0) { return; }
		if (needed > MANUAL_COL_MAX_CNT) { needed = MANUAL_COL_MAX_CNT; }

		while (extraManualCols.length < needed) {
			extraManualColSeq++;
			extraManualCols.push({ colId: 'manualCol' + extraManualColSeq });
		}

		for (var p = 0; p < extraManualCols.length; p++) {
			var colId = extraManualCols[p].colId;
			if (!window.extraManualColValues[colId]) { window.extraManualColValues[colId] = {}; }
			for (var j = 0; j < arr.length; j++) {
				var r = arr[j];
				var key = manualColRowKey(r.inptTaskId, r.inptSanctionNo);
				var val = (p === 0 ? r.itmInptHndgAdd1Txt : (p === 1 ? r.itmInptHndgAdd2Txt : r.itmInptHndgAdd3Txt)) || '';
				if (window.extraManualColValues[colId][key] === undefined) {
					window.extraManualColValues[colId][key] = val;
				}
			}
		}
	}

	// fnHtmlEscape는 common_detail.js가 전역으로 이미 정의해 둔 유틸을 그대로 재사용한다.
	function escapeHtml(v) {
		return (typeof window.fnHtmlEscape === 'function') ? window.fnHtmlEscape(v || '') : String(v || '');
	}

	// 특정 "수기 추가" 컬럼(colId)의 렌더 함수를 만들어 반환한다.
	// row(=aData)는 항상 원본 13칸 데이터 배열 그대로이므로, sanctionNo=row[8], taskId=row[10]로
	// common_detail.js(fn_setSanctionRst)가 만든 위치를 그대로 참조한다.
	// "수기입력" 옆 복사 아이콘(원본 .btn-copy, 항목내용을 입력칸에 복사)과 동일한 기능을
	// 이 컬럼에도 붙인다 — 아이콘 클릭 핸들러는 아래 .manual-col-copy-btn 참고.
	function makeManualCellRenderer(colId) {
		return function (data, type, row) {
			if (type !== 'display') { return ''; }
			var inptSanctionNo = row[8];
			var inptTaskId = row[10];
			var rowKey = manualColRowKey(inptTaskId, inptSanctionNo);
			var saved = (window.extraManualColValues[colId] && window.extraManualColValues[colId][rowKey]) ? window.extraManualColValues[colId][rowKey] : '';

			// 읽기전용 모드(결재자 화면)에서는 원본 "수기입력" 컬럼과 동일하게 입력칸 없이
			// 텍스트만 그대로 노출한다(common_detail.js:935 globalCallType != 'A' 분기와 동일한 방식).
			if (READONLY) {
				return escapeHtml(saved);
			}

			var html = "<input type='text' class='form-control manual-col-input' maxlength='" + MANUAL_COL_MAX_LEN + "' data-colid='" + colId + "' data-rowkey='" + rowKey + "' value='" + escapeHtml(saved) + "'"
				+ " onchange=\"fn_manualColValueChange(this,'" + colId + "','" + rowKey + "')\">";
			html += "<i class='fa fa-copy fa-lg mt-1 manual-col-copy-btn' data-colid='" + colId + "' title='항목내용 복사'></i>";
			return html;
		};
	}

	// [수기 추가 복사 버튼] 원본 .btn-copy(common_detail.js:2384, "추출내용 복사")와 동일하게,
	// 해당 행의 "항목내용"(rowData[3])을 이 "수기 추가" 입력칸에 복사해 넣는다.
	// common_detail.js는 건드리지 않고, 이 파일 안에서 별도 클래스(.manual-col-copy-btn)로 처리한다.
	$(document).on('click', '.manual-col-copy-btn', function (e) {
		e.preventDefault();
		var $input = $(this).closest('td').find('input.manual-col-input');
		if ($input.length === 0) { return; }

		var trIndex = $(this).closest('tr').index();
		var rowData = window.globalSanctionRstListTable.row(trIndex).data();
		var inptSanctionDatTxt = rowData[3]; // 항목내용
		if (inptSanctionDatTxt && inptSanctionDatTxt.length > MANUAL_COL_MAX_LEN) {
			inptSanctionDatTxt = inptSanctionDatTxt.substring(0, MANUAL_COL_MAX_LEN);
		}

		var colId = $input.data('colid');
		var rowKey = $input.data('rowkey');

		$input.val(inptSanctionDatTxt);
		// 저장소에도 즉시 반영 (onchange를 거치지 않고 값을 직접 넣었으므로 수동 호출)
		window.fn_manualColValueChange($input[0], colId, rowKey);
	});

	// 현재 extraManualCols 기준으로 항목심사 그리드 전체 컬럼 구성을 만든다.
	// data: 숫자는 원본 데이터 배열의 인덱스(변경 없음) — "수기 추가" 컬럼만 data:null + 자체 render.
	function buildColumns() {
		var cols = [
			{ data: 0, title: 'No', className: 'td-text-center td-text-26' },
			{ data: 1, title: '≠', className: 'td-text-center td-text-10',
				render: function (data) { return (data === 'Y') ? '<span class="nacrd-y nacrd_modal" data-toggle="modal" data-target="#nacrd_modal" type="button"></span>' : ''; } },
			{ data: 2, title: '항목', className: 'td-text-left td-text-140 text-wrap',
				render: function (data) { return '<span> ' + data + '</span>'; } },
			{ data: 3, title: '항목내용', className: 'td-text-left td-text-200 text-wrap' },
			{ data: 4, title: '수기입력' + (READONLY ? '' : ' <button type="button" id="btnAddManualCol" class="btn btn-sm btn-outline-primary manual-col-add-btn"'
				+ (extraManualCols.length >= MANUAL_COL_MAX_CNT ? ' disabled' : '')
				+ ' title="컬럼 추가(최대 ' + MANUAL_COL_MAX_CNT + '개)">+</button>'), className: 'td-text-left td-text-400' }
		];

		for (var i = 0; i < extraManualCols.length; i++) {
			var colId = extraManualCols[i].colId;
			cols.push({
				data: null,
				title: '수기 추가' + (READONLY ? '' : ' <button type="button" class="btn btn-sm btn-outline-danger manual-col-remove-btn" data-colid="' + colId + '" title="컬럼 삭제">삭제</button>'),
				className: 'td-text-left td-text-140',
				render: makeManualCellRenderer(colId)
			});
		}

		cols.push({ data: 5, title: 'Alert내용', className: 'td-text-left td-text-140 text-wrap' });
		cols.push({ data: 6, title: '', className: 'td-text-center td-text-20' });
		cols.push({ data: 7, visible: false });
		cols.push({ data: 8, visible: false });
		cols.push({ data: 9, visible: false });
		cols.push({ data: 10, visible: false });
		cols.push({ data: 11, visible: false });
		cols.push({ data: 12, visible: false });

		return cols;
	}

	function currentTableHeightOffset() {
		return (window.globalCallType === 'E' || window.globalCallType === 'F') ? 107 : 0;
	}

	// 항목심사 DataTable을 (재)생성한다. 기존 인스턴스가 있으면 destroy 후 다시 만든다.
	// common_detail.js의 fn_dataTableComplete()가 원본 13컬럼짜리 테이블을 이미 한 번
	// 만들어 둔 상태에서 호출되므로(아래 몽키패치 참고), 그 인스턴스를 우리 컬럼 구성으로 교체한다.
	function rebuildSanctionTable() {
		if (window.globalSanctionRstListTable) {
			window.globalSanctionRstListTable.destroy();
			$(window.globalSanctionRstTableId).empty();
		}

		var extraCnt = extraManualCols.length;
		// "Alert내용"이 화면에서 실제로 그려지는 <td> 순번(숨김 컬럼은 DOM에 렌더링 안 됨):
		// No,≠,항목,항목내용,수기입력(5개) + 수기추가(N개) 다음이 Alert내용이므로 인덱스는 5+N.
		var alertVisibleIdx = 5 + extraCnt;

		window.globalSanctionRstListTable = $(window.globalSanctionRstTableId).DataTable({
			data: window.globalSanctionRstListData,
			pageLength: 1000,
			scrollY: 611 + currentTableHeightOffset(),
			scrollX: true,
			scrollXInner: '100%',
			paging: false,
			info: false,
			filter: false,
			length: false,
			columns: buildColumns(),
			createdRow: function (aRow, aData) {
				// aData는 항상 원본 13칸 배열 그대로이므로 fn_setSanctionRst()가 넣어준
				// 인덱스(7:altYn, 8:sanctionNo)를 그대로 쓴다 — common_detail.js 원본과 동일.
				if ('Y' === aData[7]) {
					$(aRow).addClass('rowHandwriting');
					$(aRow).find('td:eq(' + alertVisibleIdx + ')').css('color', 'red');
				}
				if (window.boldCodeData && window.boldCodeData.indexOf(aData[8]) > -1) {
					$(aRow).find('td:eq(2)').find('span').css('font-weight', '700');
					$(aRow).find('td:eq(2)').find('span').css('background-color', '#fff7ac');
					$(aRow).find('td:eq(2)').find('span').css('padding', '2px');
				}
			},
			fnRowCallback: function (nRow, aData, iDisplayIndex) {
				$(nRow).find('td').eq(0).text(iDisplayIndex + 1);
			}
		});
	}

	function addColumn() {
		if (READONLY) { return; }
		if (extraManualCols.length >= MANUAL_COL_MAX_CNT) {
			alert('수기 추가는 ' + MANUAL_COL_MAX_CNT + '개까지 가능합니다.');
			return;
		}
		extraManualColSeq++;
		extraManualCols.push({ colId: 'manualCol' + extraManualColSeq });
		rebuildSanctionTable();
		if (typeof window.fn_setSanctionRst === 'function') { window.fn_setSanctionRst(); }
	}

	function removeColumn(colId) {
		if (READONLY) { return; }
		extraManualCols = extraManualCols.filter(function (c) { return c.colId !== colId; });
		delete window.extraManualColValues[colId];
		rebuildSanctionTable();
		if (typeof window.fn_setSanctionRst === 'function') { window.fn_setSanctionRst(); }
	}

	$(document).on('click', '#btnAddManualCol', function (e) { e.preventDefault(); addColumn(); });
	$(document).on('click', '.manual-col-remove-btn', function (e) { e.preventDefault(); removeColumn($(this).data('colid')); });

	/* ------------------------------------------------------------------------
	 * 몽키패치 지점 (common_detail.js는 무수정)
	 * ------------------------------------------------------------------------ */

	// 1) fn_dataTableComplete: 원본 호출 → sanctionRst 테이블만 우리 컬럼 구성으로 재생성.
	var _origDataTableComplete = window.fn_dataTableComplete;
	if (typeof _origDataTableComplete === 'function') {
		window.fn_dataTableComplete = function () {
			// 원본 데이터에 이미 저장된 "수기 추가" 값이 있으면 미리 컬럼 수를 맞춰둔다.
			ensureColsFromLoadedData();
			// 원본: 안전왓치/전달정보/TotalText/항목심사(13컬럼 고정) 4개 테이블을 그대로 생성.
			var ret = _origDataTableComplete.apply(this, arguments);
			// 항목심사 테이블만 우리 컬럼 구성(수기추가 N개 포함)으로 즉시 재생성.
			rebuildSanctionTable();
			return ret;
		};
	}

	// 2) fn_setTmpParam: 원본 호출로 만들어진 저장 파라미터에 "수기 추가" 값(Add1/2/3)만 덧붙인다.
	//    (원본은 sanctionList의 각 항목에 inptTaskId/inptSanctionNo를 이미 채워서 반환하므로,
	//     그 값으로 rowKey를 다시 계산해 저장소에서 값을 읽어오면 된다.)
	var _origSetTmpParam = window.fn_setTmpParam;
	if (typeof _origSetTmpParam === 'function') {
		window.fn_setTmpParam = function () {
			var params = _origSetTmpParam.apply(this, arguments);

			if (params && params.sanctionList) {
				for (var i = 0; i < params.sanctionList.length; i++) {
					var obj = params.sanctionList[i];
					var rowKey = manualColRowKey(obj.inptTaskId, obj.inptSanctionNo);
					var vals = ['', '', ''];
					for (var p = 0; p < extraManualCols.length && p < 3; p++) {
						var colId = extraManualCols[p].colId;
						vals[p] = (window.extraManualColValues[colId] && window.extraManualColValues[colId][rowKey]) ? window.extraManualColValues[colId][rowKey] : '';
					}
					obj.itmInptHndgAdd1Txt = vals[0];
					obj.itmInptHndgAdd2Txt = vals[1];
					obj.itmInptHndgAdd3Txt = vals[2];
				}
			}
			return params;
		};
	}

})();
