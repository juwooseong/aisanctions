<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
	사용자 선택 레이어 (user-picker)
	- 심사상세, window.open 팝업 등 작은 화면에서 사용하는 사용자 조회 레이어
	- DataTables 그리드 사용 (Bootstrap 모달 미사용 → 페이지에서 jQuery 재로딩해도 동작)
	- DataTables 가 없는 페이지는 이 파일보다 먼저 datatable.jsp 를 include
	  (이미 include 한 페이지에서 중복 include 하지 않도록 이 파일에서는 include 하지 않음)
	- 사용 : <%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
	         <%@include file="/WEB-INF/jsp/common/user-picker.jsp"%>
	         fnUserPickerOpen({
	             keyword : '',           // 검색어 초기값 (직원번호 또는 직원명)
	             auth    : '',           // 권한코드 고정 (생략 시 전체)
	             userYn  : 'Y',          // 사용여부 (생략 시 Y)
	             pageSize: 8,            // 페이지당 건수 (생략 시 8, 최초 오픈 시에만 적용)
	             onSelect: function(row){ row.aiInptUserEno, row.aiInptUserNm, row.aiInptUserAutVal }
	         });
--%>
<div class="user-picker" id="userPickerLayer">
	<div class="user-picker-box">
		<div class="user-picker-head">
			<span>사용자 조회</span>
			<button type="button" class="user-picker-x" title="닫기">&times;</button>
		</div>
		<div class="user-picker-sch">
			<input type="text" id="userPickerKeyword" placeholder="직원번호 또는 직원명" maxlength="50" autocomplete="off">
			<button type="button" class="user-picker-btn" id="userPickerSearchBtn">조회</button>
		</div>
		<div class="user-picker-list">
			<table class="user-picker-table" id="userPickerTable"></table>
		</div>
		<div class="user-picker-foot">
			<button type="button" class="user-picker-btn user-picker-btn-primary" id="userPickerSelectBtn">선택</button>
			<button type="button" class="user-picker-btn user-picker-x">닫기</button>
		</div>
	</div>
</div>
<style>
.user-picker {
	display: none;
	position: fixed;
	top: 0; right: 0; bottom: 0; left: 0;
	z-index: 10000;
	align-items: center;
	justify-content: center;
	background: rgba(15, 23, 42, 0.45);
}
.user-picker.open { display: flex; }
.user-picker-box {
	display: flex;
	flex-direction: column;
	width: 660px;
	max-width: calc(100vw - 16px);
	max-height: calc(100vh - 16px);
	background: #fff;
	border: 1px solid #05718b;
	border-radius: 4px;
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
	font-size: 12px;
}
.user-picker-head {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 7px 10px;
	background: #05718b;
	color: #fff;
	font-weight: bold;
}
.user-picker-head .user-picker-x {
	border: 0;
	background: none;
	color: #fff;
	font-size: 18px;
	line-height: 1;
	cursor: pointer;
}
.user-picker-sch {
	display: flex;
	gap: 6px;
	padding: 8px 10px;
}
.user-picker-sch input {
	flex: 1;
	min-width: 0;
	height: 24px;
	padding: 0 6px;
	border: 1px solid #ccc;
}
.user-picker-list {
	flex: 1;
	min-height: 80px;
	overflow-y: auto;
	margin: 0 10px;
}
/* 그리드 : datatables.min.css 기본값(넓은 padding, 파란 선택색)을 작은 레이어에 맞게 덮어씀 */
#userPickerLayer table.dataTable {
	width: 100% !important;
	table-layout: fixed;
	border-top: 1px solid #05718b;
	border-bottom: 1px solid #05718b;
}
#userPickerLayer table.dataTable thead th,
#userPickerLayer table.dataTable tbody td {
	height: 22px;
	padding: 2px 5px;
	border-bottom: 1px solid #e2e8f0;
	text-align: center;
	font-size: 11px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
/* 데이터 행 높이 : 8행 기준 레이어 높이 확보 */
#userPickerLayer table.dataTable tbody td {
	height: 33px;
}
#userPickerLayer table.dataTable thead th {
	padding-right: 16px;
	background-color: #f0feff;
	color: #222;
}
#userPickerLayer table.dataTable tbody tr { cursor: pointer; }
#userPickerLayer table.dataTable tbody tr:hover > td { background: #f3fbfe; }
/* 선택 행 강조 (user.jsp 와 동일 색상) */
#userPickerLayer table.dataTable tbody > tr.selected > td {
	background: #cce9f7 !important;
	font-weight: bold;
}
#userPickerLayer table.dataTable tbody td.dataTables_empty {
	color: #888;
	cursor: default;
}
#userPickerLayer .dataTables_wrapper .dataTables_processing {
	top: 40%;
	height: auto;
	margin-top: 0;
	padding: 6px 0;
	font-size: 11px;
}
#userPickerLayer .user-picker-page {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 6px 0 0;
}
#userPickerLayer .dataTables_wrapper .dataTables_info,
#userPickerLayer .dataTables_wrapper .dataTables_paginate {
	float: none;
	padding: 0;
	font-size: 11px;
	color: #555;
}
#userPickerLayer .dataTables_wrapper .dataTables_paginate .paginate_button {
	min-width: 33px;
	padding: 5px 9px;
	margin: 0 2px;
	font-size: 12px;
}
.user-picker-foot {
	display: flex;
	justify-content: center;
	gap: 6px;
	padding: 8px 10px;
}
/* 버튼 : 공통 css(btType1 등) 없는 팝업에서도 동일하게 보이도록 자체 스타일 */
.user-picker .user-picker-btn {
	height: 24px;
	padding: 0 12px;
	border: 1px solid #05718b;
	border-radius: 3px;
	background: #fff;
	color: #05718b;
	font-size: 12px;
	cursor: pointer;
}
.user-picker .user-picker-btn:hover { background: #f0feff; }
.user-picker .user-picker-btn-primary { background: #05718b; color: #fff; }
.user-picker .user-picker-btn-primary:hover { background: #045a6f; }
</style>
<script>
(function () {
	var opts = {};
	var grid = null;

	// 그리드 생성 : 최초 오픈 시 1회 (레이어가 보이는 상태에서 생성해야 컬럼 폭이 맞음)
	function fnInitGrid() {
		grid = $('#userPickerTable').DataTable({
			serverSide : true,
			processing : true,
			autoWidth  : false,
			pageLength : opts.pageSize || 8,
			pagingType : 'simple_numbers',
			dom        : 'rt<"user-picker-page"ip>',
			select     : { style: 'single', info: false },
			language   : {
				processing : '조회중...',
				emptyTable : '조회된 사용자가 없습니다.',
				zeroRecords: '조회된 사용자가 없습니다.',
				info       : '총 <b>_TOTAL_</b>건',
				infoEmpty  : '총 <b>0</b>건',
				paginate   : { previous: '&lt;', next: '&gt;' }
			},
			columns: [
				{ data: 'aiInptUserAutVal', title: '권한',     width: '28%', render: $.fn.dataTable.render.text() },
				{ data: 'aiInptUserEno',    title: '직원번호', width: '36%', render: $.fn.dataTable.render.text() },
				{ data: 'aiInptUserNm',     title: '직원명',   width: '36%', render: $.fn.dataTable.render.text() }
			],
			ajax: function (data, callback) {
				$.ajax({
					url: '/api/common/user',
					type: 'get',
					cache: false,
					dataType: 'json',
					data: {
						schUserNoNm       : $.trim($('#userPickerKeyword').val()),	// 직원번호 또는 직원명
						aiInptCmnCd       : opts.auth || '',
						schUserYn         : opts.userYn || 'Y',
						pageIndex         : data.start / data.length + 1,
						pageUnit          : data.length,
						recordCountPerPage: data.length,
						sortItem          : data.columns[data.order[0].column].data,
						sortDir           : data.order[0].dir
					},
					success: function (res) {
						var total = (res.paginationInfo && res.paginationInfo.totalRecordCount) || 0;
						callback({ recordsTotal: total, recordsFiltered: total, data: res.resultList || [] });
					},
					error: function () {
						callback({ recordsTotal: 0, recordsFiltered: 0, data: [] });
						alert('사용자 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.');
					}
				});
			}
		});
	}

	function fnSearch() {
		if (grid) {
			grid.ajax.reload();	// 1페이지부터 재조회 (선택 해제됨)
		} else {
			fnInitGrid();
		}
	}

	function fnClose() {
		$('#userPickerLayer').removeClass('open');
	}

	function fnSelect(row) {
		row = row || (grid && grid.rows({ selected: true }).data()[0]);
		if (!row) {
			alert('선택 대상이 없습니다.');
			return;
		}
		fnClose();
		if (typeof opts.onSelect === 'function') {
			opts.onSelect(row);
		}
	}

	window.fnUserPickerOpen = function (o) {
		opts = o || {};
		$('#userPickerKeyword').val(opts.keyword || '');
		$('#userPickerLayer').addClass('open');
		$('#userPickerKeyword').focus();
		fnSearch();
	};
	window.fnUserPickerClose = fnClose;

	$(document).on('click', '#userPickerSearchBtn', fnSearch);
	$(document).on('keyup', '#userPickerKeyword', function (e) {
		if (e.keyCode === 13) { fnSearch(); }
	});

	// 행 클릭 : 선택(Select 확장) / 더블클릭 : 바로 선택 완료
	$(document).on('dblclick', '#userPickerTable tbody tr', function () {
		if (grid && grid.row(this).data()) {
			fnSelect(grid.row(this).data());
		}
	});
	$(document).on('click', '#userPickerSelectBtn', function () { fnSelect(); });

	// 닫기 : X / 닫기 버튼, 바깥 영역 클릭, ESC
	$(document).on('click', '#userPickerLayer .user-picker-x', fnClose);
	$(document).on('click', '#userPickerLayer', function (e) {
		if (e.target && e.target.id === 'userPickerLayer') { fnClose(); }
	});
	$(document).on('keydown', function (e) {
		if (e.keyCode === 27 && $('#userPickerLayer').hasClass('open')) { fnClose(); }
	});
})();
</script>
