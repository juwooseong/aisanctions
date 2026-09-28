<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="1010"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>본인작업ToDoList [1010]</strong>
		<span class="revertStatPageDiscription">심사자에게 배정된 수기입력 대상 및 심사검토 대상을 조회하고 처리하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>당일작업목록</span>
			<span>본인작업 ToDoList</span>
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
					<label for="cbo_inptAtmcBizDscd_Search_${pageId}" class="label">업무</label>
					<select name="inptAtmcBizDscd" id="cbo_inptAtmcBizDscd_Search_<c:out value="${pageId}"/>">
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
				<p class="w28">
					<label for="txt_masterNum_Search" class="label">마스터번호</label>
					<input type="text" class="it" name="txt_masterNum_Search" id="txt_masterNum_Search" maxlength="<c:out value="${maxLength_mstno }"/>">
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
				<table class="table table-responsive-sm width-100" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
	
	<form id="formRevertDetail" action='/revert/detail' method='POST' target='revertDetailWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
	<form id="formRevertHistory" action='/common/revert/history' method='POST' target='revertHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script>
$(function() {
	
	initLoadingDisplay("Y", "class", "container");
	
	var defaultDate = formatYMD(getToDay());
	$('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	$('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	
});


//팝업에서 목록 조회
tableReload = function(){
	
	<c:out value="${dataTableId}"/>.searchList();
};

// $(document).on('click','.detailBtn', function(e) {
	
// 	//이벤트 전파 제거
// 	e.stopPropagation();
	
// 	var _inptMstSrno = $(this).attr('data-inptMstSrno');
// 	window.open("/revert/detail?inptMstSrno=" + _inptMstSrno, "본인작업TodoList 상세화면", "fullscreen=yes");
	
// });
$(document).on('click','.detailInput', function(e) {
	$(this)[0].select();
});

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

	if (6 == _column_index || 7 == _column_index) {
		
		// 심사상세 팝업
		var formRevertDetail = $('#formRevertDetail')[0];
		formRevertDetail.inptMstSrno.value = _inptMstSrno;
		formRevertDetail.inptAtvtCd.value = _inptAtvtCd;
		formRevertDetail.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formRevertDetail);
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
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
	var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	
	if (3 == _column_index) {
		
		// 심사이력 팝업
		var formRevertHistory = $('#formRevertHistory')[0];
		formRevertHistory.inptMstSrno.value = _inptMstSrno;
		formRevertHistory.actlFxRefno.value = _actlFxRefno;
		formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
		fnHistoryWin(formRevertHistory);
	}
});

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/revert/todo',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-140' },
		{ targets: 4, className: 'td-text-center td-text-60' },
		{ targets: 5, className: 'td-text-center td-text-40' },
		{ targets: 6, className: 'td-text-left td-text-120' },
		{ targets: 7, className: 'td-text-left td-text-80' },
		{ targets: 8, className: 'td-text-center td-text-60' },
		{ targets: 9, className: 'td-text-left td-text-140'},
		{ targets: 10, className: 'td-text-center td-text-40' },
		{ targets: 11, className: 'td-text-right td-text-80' },
		{ targets: 12, className: 'td-text-center td-text-60' },
		{ targets: 13, className: 'td-text-center td-text-60' },
		{ targets: 14, className: 'td-text-center td-text-60' },
		{ targets: 15, className: 'td-text-center td-text-80' },
		{ targets: 16, className: 'td-text-center td-text-80' },
		{ targets: 17, visible: false },
		{ targets: 18, visible: false },
		{ targets: 19, visible: false },
		{ targets: 20, visible: false }
	],
	columns: [
    	{ title: '생성일', data: 'inptRcpDt', render: function(data, type, row, meta){return dataFormat(data);}},
    	{ title: '업무', data: 'inptAtmcBizDsNm' },
    	{ title: 'Ref.No', data: 'actlFxRefno', render : function(data, type, row, meta){
    		if(row.save !=null || row.started !=null){
    			return '<b class="detailBtn2">' + data + '</b>'
    		}else{
    			return '<b class="detailBtn">' + data + '</b>'
    		}
    	}},
    	{ title: '저장', data: 'save' },
    	{ title: '주의', data: 'wrrInfo' },
    	{ title: '프로세스', data: 'inptPrcsNm', render : function(data, type, row, meta){
    		if(row.bliv == 'BLIV'){
    			return '<b class="detailBtn">' + data + '</b>'
    		}else{
    			return '<b class="detailBtn3">' + data + '</b>'
    		}
    	}},
    	{ title: '액티비티', data: 'inptAtvtNm', render: function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{ title: '고객번호', data: 'aiInptCsno'},
    	{ title: '고객명', data: 'aiInptCusNm'},
    	{ title: '통화',  data: 'fcCuNm' },
    	{ title: '금액', data: 'aiInptBuyAm', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    	{ title: 'TotalText', data: 'totaltextAiInptRstNm' },
    	{ title: '항목심사', data: 'itmInptAiInptRstNm' },
    	{ title: 'S/W', data: 'safewatchAiInptRstNm' },
    	{ title: 'DetectionID', data: 'filtDtctNo' },
    	{ title: '마스터ID', data: 'inptMstSrno' },
    	{ data: "inptAtmcBizDscd" },
    	{ data: "inptAtvtCd" },
    	{ data: "started" },
    	{ data: "bliv"} 
    ],
    //검색정의
    getSearchOption : function() {
    	var page_id = '<c:out value="${pageId}"/>';
    	var options = {};
		var filters = [];
		
		var inptAtmcBizDscd = $("#cbo_inptAtmcBizDscd_Search_" + page_id).val();
		var actlFxRefno = $("#txt_actlFxRefno_Search_" + page_id).val();
		var aiInptCsno = $("#txt_aiInptCusNo_Search_" + page_id).val();
		var inptMstSrno = $("#txt_masterNum_Search").val();
		var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
		var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		
		options.inptAtmcBizDscd = inptAtmcBizDscd;
		options.actlFxRefno = actlFxRefno;
		options.aiInptCsno = aiInptCsno;
		options.inptMstSrno = Number(inptMstSrno);
		options.schSdate1 = schSdate1;
		options.schEdate1 = schEdate1;
		
		//프로그램 사용 이력 파라미터
		fnCmnProgramLog("1010", null, "01", $.param(options));
		
		return options;
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		if(aData['inptAtvtCd'] == '80') {
			//$('td', nRow).css('background-color', '#f2dede');
			$(nRow).addClass('rowHandwriting');
			$(nRow).find('.detailInput').css('background-color', '#f2dede');
		}
		
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
		
		$(nRow).find('td:eq(12)').css('color', totaltextAiInptRstColor);
		$(nRow).find('td:eq(13)').css('color', itmInptAiInptRstColor);
		$(nRow).find('td:eq(14)').css('color', safewatchAiInptRstColor);
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
