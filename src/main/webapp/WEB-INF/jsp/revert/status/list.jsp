<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="1020"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>진행업무별 현재상태 [1020]</strong>
		<span class="revertStatPageDiscription">심사자에게 배정된 심사건 중 문서재추출, (재)심사, 결재진행, 결재완료된 건을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>당일작업목록</span>
			<span>진행업무별 현재상태</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
		
				<p class="w28">
					<label for="cbo_inptAtmcBizDscd_Search_${pageId}" class="label" name="inptAtmcBizDscd">업무</label>
					<select class="" id="cbo_inptAtmcBizDscd_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<c:if test="${item.aiInptCmnCd ne '3' }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w28">
					<label for="txt_actlFxRefno_Search_${pageId}" class="label">Ref.No</label>
					<input type="text" class="it" name="actlFxRefno" id="txt_actlFxRefno_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_refno }"/>">
				</p>
				<p class="w28">
					<label for="txt_aiInptCusNo_Search_${pageId}" class="label">고객번호</label>
					<input type="text" class="it" name="aiInptCsno" id="txt_aiInptCusNo_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_cusno }"/>">
				</p>
				  <p class="w36">
				 	<input type="checkbox" id="dateDisable" checked="checked" onclick="isCheck();" class="searchBoxCheck">  
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic w40_v2" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine w60">~</span>
					<input type="text" class="cal daterange-basic w40_v2" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>   
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
	
	<form id="formCommonHistory" action='/common/history' method='POST' target='commonHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
	<form id="formCommonRevertHistory" action='/common/revert/history' method='POST' target='commonRevertHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script>
$(function() {
	
	initLoadingDisplay("Y", "class", "container");
	
	var values = document.getElementById("dateDisable");
	var startDateText = document.getElementById("cld_schSdate1_Search_<c:out value="${pageId}"/>");
	var endDateText = document.getElementById("cld_schEdate1_Search_<c:out value="${pageId}"/>");
	startDateText.disabled=false;
	endDateText.disabled=false;
	
	var defaultDate = formatYMD(getToDay());
	$('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	$('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	
});

function isCheck() {
	var value = document.getElementById("dateDisable");
	var startDateText = document.getElementById("cld_schSdate1_Search_<c:out value="${pageId}"/>");
	var endDateText = document.getElementById("cld_schEdate1_Search_<c:out value="${pageId}"/>");
	isChecked(value, startDateText, endDateText);
} 


/*table.dataTable{width:100%;margin:0 auto;clear:both;border-collapse:separate;border-spacing:0}table.dataTable thead th,table.dataTable tfoot th{font-weight:bold}table.dataTable thead th,table.dataTable thead td{padding:10px 18px;border-bottom:1px solid #111}table.dataTable thead th:active,table.dataTable thead td:active{outline:none}table.dataTable tfoot th,table.dataTable tfoot td{padding:10px 18px 6px 18px;border-top:1px solid #111}table.dataTable thead .sorting,table.dataTable thead .sorting_asc,table.dataTable thead .sorting_desc,table.dataTable thead .sorting_asc_disabled,table.dataTable thead .sorting_desc_disabled{cursor:pointer;*cursor:hand;background-repeat:no-repeat;background-position:center right}table.dataTable thead .sorting{background-image:url("DataTables-1.10.18/images/sort_both.png")}table.dataTable thead .sorting_asc{background-image:url("DataTables-1.10.18/images/sort_asc.png")}table.dataTable thead .sorting_desc{background-image:url("DataTables-1.10.18/images/sort_desc.png")}table.dataTable thead .sorting_asc_disabled{background-image:url("DataTables-1.10.18/images/sort_asc_disabled.png")}table.dataTable thead .sorting_desc_disabled{background-image:url("DataTables-1.10.18/images/sort_desc_disabled.png")}table.dataTable tbody tr{background-color:#ffffff}table.dataTable tbody tr.selected{background-color:#B0BED9}table.dataTable tbody th,table.dataTable tbody td{padding:8px 10px}table.dataTable.row-border tbody th,table.dataTable.row-border tbody td,table.dataTable.display tbody th,table.dataTable.display tbody td{border-top:1px solid #ddd}table.dataTable.row-border tbody tr:first-child th,table.dataTable.row-border tbody tr:first-child td,table.dataTable.display tbody tr:first-child th,table.dataTable.display tbody tr:first-child td{border-top:none}table.dataTable.cell-border tbody th,table.dataTable.cell-border tbody td{border-top:1px solid #ddd;border-right:1px solid #ddd}table.dataTable.cell-border tbody tr th:first-child,table.dataTable.cell-border tbody tr td:first-child{border-left:1px solid #ddd}table.dataTable.cell-border tbody tr:first-child th,table.dataTable.cell-border tbody tr:first-child td{border-top:none}table.dataTable.stripe tbody tr.odd,table.dataTable.display tbody tr.odd{background-color:#f9f9f9}table.dataTable.stripe tbody tr.odd.selected,table.dataTable.display tbody tr.odd.selected{background-color:#acbad4}table.dataTable.hover tbody tr:hover,table.dataTable.display tbody tr:hover{background-color:#f6f6f6}table.dataTable.hover tbody tr:hover.selected,table.dataTable.display tbody tr:hover.selected{background-color:#aab7d1}table.dataTable.order-column tbody tr>.sorting_1,table.dataTable.order-column tbody tr>.sorting_2,table.dataTable.order-column tbody tr>.sorting_3,table.dataTable.display tbody tr>.sorting_1,table.dataTable.display tbody tr>.sorting_2,table.dataTable.display tbody tr>.sorting_3{background-color:#fafafa}table.dataTable.order-column tbody tr.selected>.sorting_1,table.dataTable.order-column tbody tr.selected>.sorting_2,table.dataTable.order-column tbody tr.selected>.sorting_3,table.dataTable.display tbody tr.selected>.sorting_1,table.dataTable.display tbody tr.selected>.sorting_2,table.dataTable.display tbody tr.selected>.sorting_3{background-color:#acbad5}table.dataTable.display tbody tr.odd>.sorting_1,table.dataTable.order-column.stripe tbody tr.odd>.sorting_1{background-color:#f1f1f1}table.dataTable.display tbody tr.odd>.sorting_2,table.dataTable.order-column.stripe tbody tr.odd>.sorting_2{background-color:#f3f3f3}table.dataTable.display tbody tr.odd>.sorting_3,table.dataTable.order-column.stripe tbody tr.odd>.sorting_3{background-color:whitesmoke}table.dataTable.display tbody tr.odd.selected>.sorting_1,table.dataTable.order-column.stripe tbody tr.odd.selected>.sorting_1{background-color:#a6b4cd}table.dataTable.display tbody tr.odd.selected>.sorting_2,table.dataTable.order-column.stripe tbody tr.odd.selected>.sorting_2{background-color:#a8b5cf}table.dataTable.display tbody tr.odd.selected>.sorting_3,table.dataTable.order-column.stripe tbody tr.odd.selected>.sorting_3{background-color:#a9b7d1}table.dataTable.display tbody tr.even>.sorting_1,table.dataTable.order-column.stripe tbody tr.even>.sorting_1{background-color:#fafafa}table.dataTable.display tbody tr.even>.sorting_2,table.dataTable.order-column.stripe tbody tr.even>.sorting_2{background-color:#fcfcfc}table.dataTable.display tbody tr.even>.sorting_3,table.dataTable.order-column.stripe tbody tr.even>.sorting_3{background-color:#fefefe}table.dataTable.display tbody tr.even.selected>.sorting_1,table.dataTable.order-column.stripe tbody tr.even.selected>.sorting_1{background-color:#acbad5}table.dataTable.display tbody tr.even.selected>.sorting_2,table.dataTable.order-column.stripe tbody tr.even.selected>.sorting_2{background-color:#aebcd6}table.dataTable.display tbody tr.even.selected>.sorting_3,table.dataTable.order-column.stripe tbody tr.even.selected>.sorting_3{background-color:#afbdd8}table.dataTable.display tbody tr:hover>.sorting_1,table.dataTable.order-column.hover tbody tr:hover>.sorting_1{background-color:#eaeaea}table.dataTable.display tbody tr:hover>.sorting_2,table.dataTable.order-column.hover tbody tr:hover>.sorting_2{background-color:#ececec}table.dataTable.display tbody tr:hover>.sorting_3,table.dataTable.order-column.hover tbody tr:hover>.sorting_3{background-color:#efefef}table.dataTable.display tbody tr:hover.selected>.sorting_1,table.dataTable.order-column.hover tbody tr:hover.selected>.sorting_1{background-color:#a2aec7}table.dataTable.display tbody tr:hover.selected>.sorting_2,table.dataTable.order-column.hover tbody tr:hover.selected>.sorting_2{background-color:#a3b0c9}table.dataTable.display tbody tr:hover.selected>.sorting_3,table.dataTable.order-column.hover tbody tr:hover.selected>.sorting_3{background-color:#a5b2cb}table.dataTable.no-footer{border-bottom:1px solid #111}table.dataTable.nowrap th,table.dataTable.nowrap td{white-space:nowrap}table.dataTable.compact thead th,table.dataTable.compact thead td{padding:4px 17px 4px 4px}table.dataTable.compact tfoot th,table.dataTable.compact tfoot td{padding:4px}table.dataTable.compact tbody th,table.dataTable.compact tbody td{padding:4px}table.dataTable th.dt-left,table.dataTable td.dt-left{text-align:left}table.dataTable th.dt-center,table.dataTable td.dt-center,table.dataTable td.dataTables_empty{text-align:center}table.dataTable th.dt-right,table.dataTable td.dt-right{text-align:right}table.dataTable th.dt-justify,table.dataTable td.dt-justify{text-align:justify}table.dataTable th.dt-nowrap,table.dataTable td.dt-nowrap{white-space:nowrap}table.dataTable thead th.dt-head-left,table.dataTable thead td.dt-head-left,table.dataTable tfoot th.dt-head-left,table.dataTable tfoot td.dt-head-left{text-align:left}table.dataTable thead th.dt-head-center,table.dataTable thead td.dt-head-center,table.dataTable tfoot th.dt-head-center,table.dataTable tfoot td.dt-head-center{text-align:center}table.dataTable thead th.dt-head-right,table.dataTable thead td.dt-head-right,table.dataTable tfoot th.dt-head-right,table.dataTable tfoot td.dt-head-right{text-align:right}table.dataTable thead th.dt-head-justify,table.dataTable thead td.dt-head-justify,table.dataTable tfoot th.dt-head-justify,table.dataTable tfoot td.dt-head-justify{text-align:justify}table.dataTable thead th.dt-head-nowrap,table.dataTable thead td.dt-head-nowrap,table.dataTable tfoot th.dt-head-nowrap,table.dataTable tfoot td.dt-head-nowrap{white-space:nowrap}table.dataTable tbody th.dt-body-left,table.dataTable tbody td.dt-body-left{text-align:left}table.dataTable tbody th.dt-body-center,table.dataTable tbody td.dt-body-center{text-align:center}table.dataTable tbody th.dt-body-right,table.dataTable tbody td.dt-body-right{text-align:right}table.dataTable tbody th.dt-body-justify,table.dataTable tbody td.dt-body-justify{text-align:justify}table.dataTable tbody th.dt-body-nowrap,table.dataTable tbody td.dt-body-nowrap{white-space:nowrap}table.dataTable,table.dataTable th,table.dataTable td{box-sizing:content-box}.dataTables_wrapper{position:relative;clear:both;*zoom:1;zoom:1}.dataTables_wrapper .dataTables_length{float:left}.dataTables_wrapper .dataTables_filter{float:right;text-align:right}.dataTables_wrapper .dataTables_filter input{margin-left:0.5em}.dataTables_wrapper .dataTables_info{clear:both;float:left;padding-top:0.755em}.dataTables_wrapper .dataTables_paginate{float:right;text-align:right;padding-top:0.25em}.dataTables_wrapper .dataTables_paginate .paginate_button{box-sizing:border-box;display:inline-block;min-width:1.5em;padding:0.5em 1em;margin-left:2px;text-align:center;text-decoration:none !important;cursor:pointer;*cursor:hand;color:#333 !important;border:1px solid transparent;border-radius:2px}.dataTables_wrapper .dataTables_paginate .paginate_button.current,.dataTables_wrapper .dataTables_paginate .paginate_button.current:hover{color:#333 !important;border:1px solid #979797;background-color:white;background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #fff), color-stop(100%, #dcdcdc));background:-webkit-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:-moz-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:-ms-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:-o-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:linear-gradient(to bottom, #fff 0%, #dcdcdc 100%)}.dataTables_wrapper .dataTables_paginate .paginate_button.disabled,.dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover,.dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active{cursor:default;color:#666 !important;border:1px solid transparent;background:transparent;box-shadow:none}.dataTables_wrapper .dataTables_paginate .paginate_button:hover{color:white !important;border:1px solid #111;background-color:#585858;background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #585858), color-stop(100%, #111));background:-webkit-linear-gradient(top, #585858 0%, #111 100%);background:-moz-linear-gradient(top, #585858 0%, #111 100%);background:-ms-linear-gradient(top, #585858 0%, #111 100%);background:-o-linear-gradient(top, #585858 0%, #111 100%);background:linear-gradient(to bottom, #585858 0%, #111 100%)}.dataTables_wrapper .dataTables_paginate .paginate_button:active{outline:none;background-color:#2b2b2b;background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #2b2b2b), color-stop(100%, #0c0c0c));background:-webkit-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);background:-moz-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);background:-ms-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);background:-o-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);background:linear-gradient(to bottom, #2b2b2b 0%, #0c0c0c 100%);box-shadow:inset 0 0 3px #111}.dataTables_wrapper .dataTables_paginate .ellipsis{padding:0 1em}.dataTables_wrapper .dataTables_processing{position:absolute;top:50%;left:50%;width:100%;height:40px;margin-left:-50%;margin-top:-25px;padding-top:20px;text-align:center;font-size:1.2em;background-color:white;background:-webkit-gradient(linear, left top, right top, color-stop(0%, rgba(255,255,255,0)), color-stop(25%, rgba(255,255,255,0.9)), color-stop(75%, rgba(255,255,255,0.9)), color-stop(100%, rgba(255,255,255,0)));background:-webkit-linear-gradient(left, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 25%, rgba(255,255,255,0.9) 75%, rgba(255,255,255,0) 100%);background:-moz-linear-gradient(left, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 25%, rgba(255,255,255,0.9) 75%, rgba(255,255,255,0) 100%);background:-ms-linear-gradient(left, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 25%, rgba(255,255,255,0.9) 75%, rgba(255,255,255,0) 100%);background:-o-linear-gradient(left, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 25%, rgba(255,255,255,0.9) 75%, rgba(255,255,255,0) 100%);background:linear-gradient(to right, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 25%, rgba(255,255,255,0.9) 75%, rgba(255,255,255,0) 100%)}.dataTables_wrapper .dataTables_length,.dataTables_wrapper .dataTables_filter,.dataTables_wrapper .dataTables_info,.dataTables_wrapper .dataTables_processing,.dataTables_wrapper .dataTables_paginate{color:#333}.dataTables_wrapper .dataTables_scroll{clear:both}.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody{*margin-top:-1px;-webkit-overflow-scrolling:touch}.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>thead>tr>th,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>thead>tr>td,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>tbody>tr>th,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>tbody>tr>td{vertical-align:middle}.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>thead>tr>th>div.dataTables_sizing,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>thead>tr>td>div.dataTables_sizing,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>tbody>tr>th>div.dataTables_sizing,.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>tbody>tr>td>div.dataTables_sizing{height:0;overflow:hidden;margin:0 !important;padding:0 !important}.dataTables_wrapper.no-footer .dataTables_scrollBody{border-bottom:1px solid #111}.dataTables_wrapper.no-footer div.dataTables_scrollHead table.dataTable,.dataTables_wrapper.no-footer div.dataTables_scrollBody>table{border-bottom:none}.dataTables_wrapper:after{visibility:hidden;display:block;content:"";clear:both;height:0}@media screen and (max-width: 767px){.dataTables_wrapper .dataTables_info,.dataTables_wrapper .dataTables_paginate{float:none;text-align:center}.dataTables_wrapper .dataTables_paginate{margin-top:0.5em}}@media screen and (max-width: 640px){.dataTables_wrapper .dataTables_length,.dataTables_wrapper .dataTables_filter{float:none;text-align:center}.dataTables_wrapper .dataTables_filter{margin-top:0.5em}}*/
//프로세트, 엑티비티 클릭
$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
	
	if (!checkLogin()) {
		fnLoginAlert();
		return false;
	}
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
	var _inptAtvtCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtvtCd'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];

	if (5 == _column_index || 6 == _column_index) {
		
		// 심사상세 팝업
		var formCommonHistory = $('#formCommonHistory')[0];
		formCommonHistory.inptMstSrno.value = _inptMstSrno;
		formCommonHistory.inptAtvtCd.value = _inptAtvtCd;
		formCommonHistory.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formCommonHistory);
	}
});


$('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
	
	if (!checkLogin()) {
		fnLoginAlert();
		return false;
	}
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
	var _inptAtvtCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtvtCd'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
	var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	
	if (3 == _column_index) {
		
		// 심사이력 팝업
		var formCommonRevertHistory = $('#formCommonRevertHistory')[0];
		formCommonRevertHistory.inptMstSrno.value = _inptMstSrno;
		formCommonRevertHistory.actlFxRefno.value = _actlFxRefno;
		formCommonRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
		fnHistoryWin(formCommonRevertHistory);
	}
});

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/revert/status',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-center td-text-60' },
		{ targets: 3, className: 'td-text-left td-text-120' },
		{ targets: 4, className: 'td-text-center td-text-40' },
		{ targets: 5, className: 'td-text-left td-text-120' },
		{ targets: 6, className: 'td-text-left td-text-100' },
		{ targets: 7, className: 'td-text-center td-text-60' },
		{ targets: 8, className: 'td-text-left td-text-140' },
		{ targets: 9, className: 'td-text-center td-text-40' },
		{ targets: 10, className: 'td-text-right td-text-80' },
		{ targets: 11, className: 'td-text-center td-text-60' },
		{ targets: 12, className: 'td-text-center td-text-60' },
		{ targets: 13, className: 'td-text-center td-text-60' },
		{ targets: 14, className: 'td-text-center td-text-80' },
		{ targets: 15, visible: false },
		{ targets: 16, visible: false }
	],
	columns: [
		{ title: '생성일', data: 'inptRcpDt', render: function(data, type, row, meta){return dataFormat(data);}},
		{ title: '업무', data: 'inptAtmcBizDsNm' },
		{ title: 'Ref.No', data: 'actlFxRefno', render : function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{ title: '주의', data: 'warningInfo' },
    	{ title: '프로세스', data: 'inptPrcsNm', render : function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{ title: '액티비티', data: 'inptAtvtNm', render: function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{ title: '고객번호', data: 'aiInptCsno' },
    	{ title: '고객명', data: 'aiInptCusNm' },
    	{ title: '통화',  data: 'fcCuNm' },
    	{ title: '금액', data: 'aiInptBuyAm', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    	{ title: 'TotalText', data: 'totaltextAiInptRstNm' },
    	{ title: '항목심사', data: 'itmInptAiInptRstNm' },
    	{ title: 'S/W', data: 'safewatchAiInptRstNm' },
    	{ title: 'DetectionID', data: 'filtDtctNo' },
    	{ data: "inptAtmcBizDscd" },
    	{ data: "inptAtvtCd" }
    ],
    //검색정의
    getSearchOption : function() {
    	var page_id = '<c:out value="${pageId}"/>';
    	var options = {};
		var filters = [];
		
		var inptAtmcBizDscd = $("#cbo_inptAtmcBizDscd_Search_" + page_id).val();
		var actlFxRefno = $("#txt_actlFxRefno_Search_" + page_id).val();
		var aiInptCsno = $("#txt_aiInptCusNo_Search_" + page_id).val();
		var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
		var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		
		options.inptAtmcBizDscd = inptAtmcBizDscd;
		options.actlFxRefno = actlFxRefno;
		options.aiInptCsno = aiInptCsno;
		options.schSdate1 = schSdate1;
		options.schEdate1 = schEdate1;
		
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("1020", null, "01", $.param(options));
		
		return options;
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		
		var totaltextAiInptRstColor = "black";
		var itmInptAiInptRstColor = "black";
		var safewatchAiInptRstColor = "black";
		
		if(aData['totaltextAiInptRstCd'] == '30') {
			totaltextAiInptRstColor = "red";
		}else if(aData['totaltextAiInptRstCd'] == '40') {
			totaltextAiInptRstColor = "green";
		}
		
		if(aData['itmInptAiInptRstCd'] == '30') {
			itmInptAiInptRstColor = "red";
		}else if(aData['itmInptAiInptRstCd'] == '40') {
			itmInptAiInptRstColor = "green";
		}
		
		if(aData['safewatchAiInptRstCd'] == '30') {
			safewatchAiInptRstColor = "red";
		}else if(aData['safewatchAiInptRstCd'] == '40') {
			safewatchAiInptRstColor = "green";
		}
		
		$(nRow).find('td:eq(11)').css('color', totaltextAiInptRstColor);
		$(nRow).find('td:eq(12)').css('color', itmInptAiInptRstColor);
		$(nRow).find('td:eq(13)').css('color', safewatchAiInptRstColor);
		
		
		if(aData['warningInfo'] == '오류' || aData['warningInfo'] == '지연') {
			//$('td', nRow).css('background-color', '#f2dede');
			$(nRow).find('td:eq(4)').css('color', 'red');
		}
	}
	//,
	//dateInputIds : [['cld_schSdate1_Search_<c:out value="${pageId}"/>','cld_schEdate1_Search_<c:out value="${pageId}"/>']]
};
</script>

<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="440" />
</jsp:include>
