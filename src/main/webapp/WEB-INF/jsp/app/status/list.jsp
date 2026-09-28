<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="2020"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>진행업무별 현재상태(결재자) [2020]</strong>
		<span class="revertStatPageDiscription">결재자가 승인, 반려, Block 처리한 심사 및 자체점검 목록을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>당일작업목록</span>
			<span>진행업무별 현재상태(결재자)</span>
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
					<label for="cbo_inptAtmcBizDscd_Search_<c:out value="${pageId}"/>" class="label" name="inptAtmcBizDscd">업무</label>
					<select id="cbo_inptAtmcBizDscd_Search_<c:out value="${pageId}"/>" class="">
						<<option value="">전체</option>
						<option value="0102">수출+수입</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
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
	
	<form id="formCommonHistory" action='/common/history' method='POST' target='commonHistory'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
	<form id="formCommonHistoryQa" action='/common/history/qa' method='POST' target='commonHistoryQa'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
	<form id="formRevertHistory" action='/common/revert/history' method='POST' target='revertHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
	
	<form id="formQaHistory" action='/common/qa/history' method='POST' target='qaHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
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
	var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];

	if (5 == _column_index || 6 == _column_index) {
		
		if ('1' == _inptAtmcBizDscd || '2' == _inptAtmcBizDscd) {
			
			// 심사상세 팝업
			var formCommonHistory = $('#formCommonHistory')[0];
			formCommonHistory.inptMstSrno.value = _inptMstSrno;
			formCommonHistory.inptAtvtCd.value = _inptAtvtCd;
			formCommonHistory.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formCommonHistory);
			
		} else if ('3' == _inptAtmcBizDscd) {
			
			// 심사상세 팝업
			var formCommonHistoryQa = $('#formCommonHistoryQa')[0];
			formCommonHistoryQa.inptMstSrno.value = _inptMstSrno;
			formCommonHistoryQa.inptAtvtCd.value = _inptAtvtCd;
			formCommonHistoryQa.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formCommonHistoryQa);
			
		}
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
	var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
	
	if (3 == _column_index){
		if ('1' == _inptAtmcBizDscd || '2' == _inptAtmcBizDscd) {
			
			var formRevertHistory = $('#formRevertHistory')[0];
			formRevertHistory.inptMstSrno.value = _inptMstSrno;
			formRevertHistory.actlFxRefno.value = _actlFxRefno;
			formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formRevertHistory);
			
		} else if (3 == _inptAtmcBizDscd) {
			
			var formQaHistory = $('#formQaHistory')[0];
			formQaHistory.inptMstSrno.value = _inptMstSrno;
			formQaHistory.actlFxRefno.value = _actlFxRefno;
			formQaHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formQaHistory);
		}
	}
});


var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/app/status',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40', orderable: false}, // no
		{ targets: 1, className: 'td-text-center td-text-60' }, // 생성일
		{ targets: 2, className: 'td-text-center td-text-40' }, // 업무
		{ targets: 3, className: 'td-text-left td-text-120' }, // 레퍼런스넘버
		{ targets: 4, className: 'td-text-center td-text-40' }, // 주의
		{ targets: 5, className: 'td-text-left td-text-120' }, // 프로세스
		{ targets: 6, className: 'td-text-left td-text-100' }, // 액티비티
		{ targets: 7, className: 'td-text-center td-text-60' }, // 고객번호
		{ targets: 8, className: 'td-text-left td-text-140' }, // 고객명
		{ targets: 9, className: 'td-text-center td-text-40' }, // 통화
		{ targets: 10, className: 'td-text-right td-text-80' }, //금액
		{ targets: 11, className: 'td-text-center td-text-60' }, // 토탈
		{ targets: 12, className: 'td-text-center td-text-60' }, // 항목
		{ targets: 13, className: 'td-text-center td-text-60' }, // s/w
		{ targets: 14, className: 'td-text-center td-text-80' }
	],
	columns: [
		{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
    	{"data": "inptAtmcBizDsNm", title: '업무'},
    	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{"data": "wrrInfo", title: '주의' },
    	{"data": "inptPrcsNm", title: '프로세스', render: function(d){
    		return '<p class="detailBtn">' + d + '</p>'
    	}},
    	{"data": "inptAtvtNm", title: '액티비티', render: function(d){
    		return '<p class="detailBtn">' + d + '</p>'
    	}},
    	{"data": "aiInptCsno", title: '고객번호' },
    	{"data": "aiInptCusNm", title: '고객명' },
    	{"data": "fcCuNm", title: '통화'},
    	{"data": "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    	{"data": "totaltextAiInptRstNm", title: 'TotalText' },
    	{"data": "itmInptAiInptRstNm", title: '항목심사' },
    	{"data": "safewatchAiInptRstNm", title: 'S/W' },
    	{"data": "filtDtctNo", title: 'DetectionID'}
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
		fnCmnProgramLog("2020", null, "01", $.param(options));
		
		return options;
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		
		var totaltextAiInptRstColor = "black";
		var itmInptAiInptRstColor = "black";
		var safewatchAiInptRstColor = "black";
		
		if(aData['totaltextAiInptRstNm'] == 'Alert') {
			totaltextAiInptRstColor = "red";
		}else if(aData['totaltextAiInptRstNm'] == 'Release') {
			totaltextAiInptRstColor = "green";
		}
		
		if(aData['itmInptAiInptRstNm'] == 'Alert') {
			itmInptAiInptRstColor = "red";
		}else if(aData['itmInptAiInptRstNm'] == 'Release') {
			itmInptAiInptRstColor = "green";
		}
		
		if(aData['safewatchAiInptRstNm'] == 'Alert') {
			safewatchAiInptRstColor = "red";
		}else if(aData['safewatchAiInptRstNm'] == 'Release') {
			safewatchAiInptRstColor = "green";
		}
		
		$(nRow).find('td:eq(11)').css('color', totaltextAiInptRstColor);
		$(nRow).find('td:eq(12)').css('color', itmInptAiInptRstColor);
		$(nRow).find('td:eq(13)').css('color', safewatchAiInptRstColor);
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="440" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
/* var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
}; */
/* function fnDetail(){
	window.open("/app/todo/bundle","AppTodoBundlePopup","width=1000,height=700");
} */
</script>