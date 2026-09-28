<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="2010"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>본인작업ToDoList(결재자) [2010]</strong>
		<span class="revertStatPageDiscription">결재자에게 상신된 심사 및 자체점검 결재 대상을 조회하고 처리하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>당일작업목록</span>
			<span>본인작업 ToDoList(결재자)</span>
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
				<%-- <p class="w28">
				 	<input type="checkbox" id="dateDisable" checked="checked" onclick="isCheck();" class="cal daterange-basic w30"> 
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic w100" readonly="readonly" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine w60">~</span>
					<input type="text" class="cal daterange-basic w100" readonly="readonly" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>  --%>
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
				<button type="button" class="allAppvBtn gridRightTopBtn" onclick="fnOpenAppTodoBundlePopup();">
				일괄승인
				</button>
				<table class="table table-responsive-sm width-100" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
	
	<form id="formAppRevertDetail" action='/app/detail/revert' method='POST' target='appRevertDetailWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
	<form id="formAppQaDetail" action='/app/detail/qa' method='POST' target='appQaDetailWin'>
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

var tdElementNo = null;
var tdElementNoObj = null;

$(function() {
	
	initLoadingDisplay("Y", "class", "container");
	
	var defaultDate = formatYMD(getToDay());
	$('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	$('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
});

tableReload = function(){
	
	<c:out value="${dataTableId}"/>.searchList();
};

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
	
	if (7 == _column_index || 6 == _column_index) {
		if (1 == _inptAtmcBizDscd || 2 == _inptAtmcBizDscd) {
			
			// 심사상세 팝업
			var formRevertDetail = $('#formAppRevertDetail')[0];
			formAppRevertDetail.inptMstSrno.value = _inptMstSrno;
			formAppRevertDetail.inptAtvtCd.value = _inptAtvtCd;
			formAppRevertDetail.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formAppRevertDetail);
			
		} else if (3== _inptAtmcBizDscd) {
			
			// 심사상세 팝업
			var formAppQaDetail = $('#formAppQaDetail')[0];
			formAppQaDetail.inptMstSrno.value = _inptMstSrno;
			formAppQaDetail.inptAtvtCd.value = _inptAtvtCd;
			formAppQaDetail.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formAppQaDetail);
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
	
	if(3 == _column_index){
		
		if (1 == _inptAtmcBizDscd || 2 == _inptAtmcBizDscd) {
			
			// 심사이력 팝업
			var formRevertHistory = $('#formRevertHistory')[0];
			formRevertHistory.inptMstSrno.value = _inptMstSrno;
			formRevertHistory.actlFxRefno.value = _actlFxRefno;
			formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formRevertHistory);
			
		} else if (3 == _inptAtmcBizDscd) {
			
			// 심사이력 팝업
			var formQaHistory = $('#formQaHistory')[0];
			formQaHistory.inptMstSrno.value = _inptMstSrno;
			formQaHistory.actlFxRefno.value = _actlFxRefno;
			formQaHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formQaHistory);
		}
	}
});

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/app/todo',
	columnDefs: [
		{ targets: 0, className: 'text-center td-text-40 no-use-sorting' , orderable :false 
			/* , render: function(data, type, row, meta){
				if(row.inptAtvtCd=='130' || row.totaltextAiInptRstCd=='30' || row.itmInptAiInptRstCd=='30' || row.safewatchAiInptRstCd=='30'){
					return "a";
				}
			} */
		}, // 'text-center td-text-40'
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-120' },
		{ targets: 4, className: 'td-text-center td-text-50' },
		{ targets: 5, className: 'td-text-center td-text-50' },
		
		
		{ targets: 6, className: 'td-text-left td-text-120' },
		{ targets: 7, className: 'td-text-left td-text-120' },
		{ targets: 8, className: 'td-text-center td-text-100' },
		{ targets: 9, className: 'td-text-center td-text-60' },
		{ targets: 10, className: 'td-text-left td-text-140' },
		{ targets: 11, className: 'td-text-center td-text-40' },
		{ targets: 12, className: 'td-text-right td-text-80' },
		{ targets: 13, className: 'td-text-center td-text-60' },
		{ targets: 14, className: 'td-text-center td-text-60' },
		{ targets: 15, className: 'td-text-center td-text-60' },
		{ targets: 16, className: 'td-text-center td-text-60' },
		{ targets: 17, visible: false },
		{ targets: 18, visible: false },
		{ targets: 19, visible: false },
		{ targets: 20, visible: false },
		{ targets: 21, visible: false },
		{ targets: 22, visible: false },
		{ targets: 23, visible: false },
		{ targets: 24, visible: false },
		{ targets: 25, visible: false },
		{ targets: 26, visible: false },
		{ targets: 27, visible: false },
		{ targets: 28, visible: false }
	],
	columns: [
    	{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
    	{"data": "inptAtmcBizDsNm", title: '업무'},
    	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
    		if(row.save !=null || row.started !=null){
    			return '<b class="detailBtn2">' + data + '</b>'
    		}else {
    			return '<b class="detailBtn">' + data + '</b>'
    		}
    	}},
    	{"data": "save", title: '저장'},
    	{"data": "wrrInfo", title: '주의' },
    	
    	{"data": "inptPrcsNm", title: '프로세스', render : function(data, type, row, meta){
    		if(row.bliv == 'BLIV'){
    			return '<b class="detailBtn">' + data + '</b>'
    		}else{
    			return '<b class="detailBtn3">' + data + '</b>'
    		}
    	}},
    	{"data": "inptAtvtNm", title: '액티비티', render: function(d){
    		return '<p class="detailBtn">' + d + '</p>'
    	}},
    	
    	{"data": "workerNm", title: '담당자' },
    	
    	{"data": "aiInptCsno", title: '고객번호' },
    	{"data": "aiInptCusNm", title: '고객명' },
    	{"data": "fcCuNm", title: '통화'},
    	{"data": "aiInptBuyAm", title: '금액',  render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    	{"data": "totaltextAiInptRstNm", title: 'TotalText' },
    	{"data": "itmInptAiInptRstNm", title: '항목심사' },
    	{"data": "safewatchAiInptRstNm", title: 'S/W' },
    	{"data": "filtDtctNo", title: 'DetectionID'},
    	{"data": "aiInptAppvHstId"},
    	{"data": "inptAtmcBizDscd"},
    	{"data": "aiInptTpySaveYn"},
    	{"data": "aiInptCrpeEno"},
    	{"data": "totaltextAiInptRstCd"},
    	{"data": "itmInptAiInptRstCd"},
    	{"data": "aiInptQlasPrgStsCd"},
    	{"data": "inptAtvtCd"},
    	{"data": "safewatchAiInptRstCd"},
    	{"data": "started" },
    	{"data": "qltGrnAiInptRstCd" },
    	{"data": "bliv"} 
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
		fnCmnProgramLog("2010", null, "01", $.param(options));
		
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
		
		$(nRow).find('td:eq(13)').css('color', totaltextAiInptRstColor);
		$(nRow).find('td:eq(14)').css('color', itmInptAiInptRstColor);
		$(nRow).find('td:eq(15)').css('color', safewatchAiInptRstColor);
		
		
		tdElementNo = $('.table-responsive-sm').find('thead').find('tr').find('th'); // [No] column selector #1
		tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
		tdElementNoObj.html(""); // [No] column text remove
		tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off">');
		
		$(nRow).find('td').eq(0).html('<input type="checkbox" class="multiRowChkBox" id="multiRowChkBox" style="background-color: transparent !important;">');
		
		if(aData['inptAtvtCd']=='130' || aData['totaltextAiInptRstCd']=='30' || aData['itmInptAiInptRstCd']=='30' || aData['safewatchAiInptRstCd']=='30' || (aData['qltGrnAiInptRstCd'] != null && aData['qltGrnAiInptRstCd'] =='20')){
			var multiChkBox = $(nRow).find('td').eq(0).find('.multiRowChkBox');
			$(multiChkBox).css('display','none');
			//$(multiChkBox).prop('disabled', true);
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
	<jsp:param name="select" value="multi" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="440" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){	
	if(row.inptAtvtCd=='130' || row.totaltextAiInptRstCd=='30' || row.itmInptAiInptRstCd=='30' || row.safewatchAiInptRstCd=='30'|| row.qltGrnAiInptRstCd=='20'){
		<c:out value="${dataTableId}"/>.deselectItem(index);
	}
	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', true);
	}
};
var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', false);	
	}
};


function fnDeleteFormPopup(){
	$('[name=formPopup]').remove();
}

function fnDeselectListTableAll(){
	var testTableObject = <c:out value="${dataTableId}"/>;
	testTableObject.deselectAllListTableRow();
	
	$('.multiRowChkBox').prop('checked', false);
}

function testConsoleTable(){
	var testTableObject = <c:out value="${dataTableId}"/>;
	var dataRows = testTableObject.getAllListTableRow();
	dataRowsTest = testTableObject.getAllListTableRow();
	testTableObject.selectAllListTableRow();
	
	var selectedRowsList = testTableObject.getSelRows();
	for(var index = 0 ; index < selectedRowsList.length ; index++){
		//console.log("in for-loop: ", abc[i]);
		//console.log("get in: ", abc[i].inptAtvtCd);
		if(selectedRowsList[index].inptAtvtCd=='130' || selectedRowsList[index].totaltextAiInptRstCd=='30' || selectedRowsList[index].itmInptAiInptRstCd=='30' || selectedRowsList[index].safewatchAiInptRstCd=='30'|| selectedRowsList[index].qltGrnAiInptRstCd=='20'){
			testTableObject.deselectItem(index);
		}else{
			var multiChkBox = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
			$(multiChkBox[index]).prop('checked', true);
		}
	}
}

function appvAllSelectCheck(){
	
	var allChkBox = $('#appvAllSelector');
	
	if(allChkBox.is(":checked")){
		testConsoleTable();
	}else if(!allChkBox.is(":checked")){
		fnDeselectListTableAll();
	}
	
}

function fnOpenAppTodoBundlePopup(){
	var selRows = <c:out value="${dataTableId}"/>.getSelRows();
	if(selRows.length){
		$(document.body).append('<form name="formPopup" method="post" target="AppTodoBundlePopup" action="/app/todo/bundle"></form>');
		var form = $('form[name="formPopup"]');
			var v_id =[];
			var aiInptAppvHstId =[];
			var inptAtmcBizDscd =[]; 
			var aiInptAppvHstId =[];
			var aiInptTpySaveYn =[];
			var aiInptAppvHstId =[];
			var aiInptCrpeEno =[];
			var totaltextAiInptRstCd =[];
			var itmInptAiInptRstCd =[];
			var aiInptQlasPrgStsCd =[];
			var inptAtvtCd =[];
		for(var i=0;i<selRows.length;i++){
			var row = selRows[i];
			v_id[i] = row.inptMstSrno;
			aiInptAppvHstId[i] = row.aiInptAppvHstId;
			inptAtmcBizDscd[i] = row.inptAtmcBizDscd;
			aiInptAppvHstId[i] = row.aiInptAppvHstId;
			aiInptTpySaveYn[i] = row.aiInptTpySaveYn;
			aiInptAppvHstId[i] = row.aiInptAppvHstId;
			aiInptCrpeEno[i] = row.aiInptCrpeEno;
			totaltextAiInptRstCd[i] = row.totaltextAiInptRstCd;
			itmInptAiInptRstCd[i] = row.itmInptAiInptRstCd;
			if(row.aiInptQlasPrgStsCd == null){
				aiInptQlasPrgStsCd[i] = " ";
			}else{
				aiInptQlasPrgStsCd[i] = row.aiInptQlasPrgStsCd;
			}
			inptAtvtCd[i] = row.inptAtvtCd;
		}
		form.append('<input type="hidden" name="ids" value="'+v_id+'" />')
		form.append('<input type="hidden" name="aiInptAppvHstIds" value="'+aiInptAppvHstId+'" />')
		form.append('<input type="hidden" name="inptAtmcBizDscd" value="'+inptAtmcBizDscd+'" />')
		form.append('<input type="hidden" name="aiInptTpySaveYn" value="'+aiInptTpySaveYn+'" />')
		form.append('<input type="hidden" name="aiInptCrpeEno" value="'+aiInptCrpeEno+'" />')
		form.append('<input type="hidden" name="totaltextAiInptRstCd" value="'+totaltextAiInptRstCd+'" />')
		form.append('<input type="hidden" name="itmInptAiInptRstCd" value="'+itmInptAiInptRstCd+'" />')
		form.append('<input type="hidden" name="aiInptQlasPrgStsCd" value="'+aiInptQlasPrgStsCd+'" />')
		form.append('<input type="hidden" name="inptAtvtCd" value="'+inptAtvtCd+'" />')
		var vwin = window.open("about:blank","AppTodoBundlePopup","width=962,height=700,resizable=0");
		vwin.document.write("<title>일괄결재</title>");
		fnCmnProgramLog("2010", "11", "01", null);
		form.submit();
		vwin.focus();
	} else {
		alert("승인할 항목을 한개이상 선택해주세요.")
	}
}
</script>