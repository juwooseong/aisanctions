<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="1030"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<style>
.revertUngeneratedConfirmBtnTEMP{
	right: 145px;
    position: absolute;
    top: 0;
    margin-top: 10px;
    margin-right: 5px;
    z-index: 1;
}
.revertUngeneratedCancelBtnTEMP{
	right: 234px;
    position: absolute;
    top: 0;
    margin-top: 10px;
    margin-right: 5px;
    z-index: 1;
}

</style>
<div class="container">
	<h2 class="title">
		<strong>업무미생성목록 [1030]</strong>
		<span class="revertStatPageDiscription"></span>
		<span class="location">
			<span>심사</span>
			<span>당일작업목록</span>
			<span>업무미생성목록</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
				<p class="w36">
				 	<input type="checkbox" id="dateDisable" checked="checked" onclick="isCheck();" class="searchBoxCheck"> 
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic w40_v2 calRange calStd" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine">~</span>
					<input type="text" class="cal daterange-basic w40_v2 calRange calEd" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>
				
				<p class="w26">
					<label for="cbo_aiInptXtPrcStsDscd_Search_${pageId}" class="label">처리상태</label>
					<select class="" name="schGbn" id="cbo_aiInptXtPrcStsDscd_Search_<c:out value="${pageId}"/>">
						<option value="11">미확인</option>
						<option value="12">확인완료</option>
						<option value="">전체</option>
					</select>
				</p>
				<p class="w26">
					<label for="cbo_aiInptAplXtRncd_Search_${pageId}" class="label">제외사유</label>
					<select class="" name="schGbn" id="cbo_aiInptAplXtRncd_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<option value="11">중복스캔</option>
						<option value="12">WINI 외환 거래 정보 없음</option>
						<option value="13">WINI 외환 거래 취소</option>
					</select>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>" onclick="afterSchBtn();">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<input type="hidden" class="it" value="" id="schUserNm"/>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<button type="button" class="retryLogEndBtnDisabled revertUngeneratedConfirmBtn revertUngeneratedConfirmBtnTEMP" id="appvCancel" onclick="ungeneratedConfirm();" disabled="disabled">확인완료</button>
				<button type="button" class="retryLogEndBtnDisabled revertUngeneratedCancelBtn revertUngeneratedCancelBtnTEMP" id="appvCancel" onclick="ungeneratedCancel();" disabled="disabled">확인취소</button>
				<button type="button" class="gridRightTopBtn xlsDownloadBtn" onclick="downXls<c:out value="${pageId}"/>();">엑셀다운로드</button>
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
</div>

<form id="formXls" method="get"></form>
<form id="formParamData" style="position: absolute;opacity: 1;"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

	var appvCancelMstNo = null;
	var appvCancelBizCd = null;
	var appvCancelTotalTextRst = null;
	var appvCancelItmRst = null;
	var appvCancelSafeWatchRst = null;

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
			
	 
var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/revert/ungenerated',
		columnDefs: [

			{ targets: 0, className: 'td-text-center td-text-20 no-use-sorting', orderable :false }, // NO
			{ targets: 1, className: 'td-text-center td-text-40' }, // 접수일자
			{ targets: 2, className: 'td-text-left td-text-100' }, // 제외사유
			{ targets: 3, className: 'td-text-center td-text-40' }, // 업무
			{ targets: 4, className: 'td-text-left td-text-80' }, // Ref.No
			{ targets: 5, className: 'td-text-right td-text-40' }, // 회차
			{ targets: 6, className: 'td-text-left td-text-60' }, // 접수담당자(이름)
			{ targets: 7, className: 'td-text-left td-text-60' }, // 스캔담당자(이름)
			{ targets: 8, className: 'td-text-center td-text-80' }, // 스캔일시
			{ targets: 9, className: 'td-text-left td-text-40' }, // 처리상태
			{ targets: 10, className: 'td-text-left td-text-60' }, // 처리자(이름)
			{ targets: 11, className: 'td-text-center td-text-80' }, // 처리일시
			{ targets: 12, visible: false }, // pk
			{ targets: 13, visible: false }, // 조작자번호
			{ targets: 14, visible: false }, // 스캔자번호
			{ targets: 15, visible: false }, // 처리자번호
			
			{ targets: 16, visible: false }, // 수출인지 수입인지 코드
			{ targets: 17, visible: false }, // 제외사유코드
			{ targets: 18, visible: false } // 처리상태코드
		],
		columns: [
			{"data": "inptRcpDt", title: '접수일자', render: function(data, type, row, meta){return dataFormat(data);}},
			{"data": "aiInptAplXtRncdNm", title: '제외사유'},
        	{"data": "inptAtmcBizDscdNm", title: '업무'},
        	{"data": "actlFxRefno", title: 'Ref.No'},
        	{"data": "fxRefnoSrno", title: '회차'},
        	{"data": "trnOprNm", title: '접수자', render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.trnOprNo != null){rstStr += '('+row.trnOprNo+')'; }
        		return rstStr;
        	}}, 
        	{"data": "docScanNm", title: '스캔자', render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.aiInptDocScanChrgEno != null){rstStr += '('+row.aiInptDocScanChrgEno+')'; }
        		return rstStr;
        	}}, 
        	{"data": "aiInptDocScanDtm", title: '스캔일시', render : function(data, type, row, meta){
        		if(data != null){
        			var dateStr = data.substr(0, 8);
            		var timeStr = data.substr(8, 8);
            		
            		var dateStrConv = dateStr.substr(0, 4) + "-" + dateStr.substr(4, 2) + "-" + dateStr.substr(6, 2);
            		var timeStrConv = timeStr.substr(0, 2) + ":" + timeStr.substr(2, 2) + ":" + timeStr.substr(4, 2);
            		
            		return dateStrConv + " " + timeStrConv;	
        		}
        	}},
        	{"data": "aiInptXtPrcStsDscdNm", title: '처리상태'},
        	{"data": "procNm", title: '처리자', render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.aiInptXtPrcEno != null){rstStr += '('+row.aiInptXtPrcEno+')'; }
        		return rstStr;
        	}}, 
        	{"data": "aiInptXtPrcDtm", title: '처리일시', render : function(data, type, row, meta){
        		if(data != null){
        			var dateStr = data.substr(0, 8);
            		var timeStr = data.substr(8, 8);
            		
            		var dateStrConv = dateStr.substr(0, 4) + "-" + dateStr.substr(4, 2) + "-" + dateStr.substr(6, 2);
            		var timeStrConv = timeStr.substr(0, 2) + ":" + timeStr.substr(2, 2) + ":" + timeStr.substr(4, 2);
            		
            		return dateStrConv + " " + timeStrConv;	
        		}else if(data == null){
        			return "";
        		}
        	}},
        	{"data": "aiInptXtSrno"},
        	{"data": "trnOprNo"}, // 조작자번호
        	{"data": "aiInptDocScanChrgEno"}, // 스캔자번호
        	{"data": "aiInptXtPrcEno"},  // 처리자번호
        	
        	{"data": "inptAtmcBizDscd"},  // 수출인지 수입인지 코드
        	{"data": "aiInptAplXtRncd"},  // 제외사유코드
        	{"data": "aiInptXtPrcStsDscd"},  // 처리상태코드
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	
	    	
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
			var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
			
			options.schSdate1 = schSdate1; // 검색옵션 업무생성일(시작일)
			options.schEdate1 = schEdate1; // 검색옵션 업무생성일(종료일)
			options.aiInptAplXtRncd = $("#cbo_aiInptAplXtRncd_Search_" + page_id).val(); // 검색옵션 제외사유
			options.aiInptXtPrcStsDscd = $("#cbo_aiInptXtPrcStsDscd_Search_" + page_id).val(); // 검색옵션 처리상태
			
			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("1030",null,"01",$.param(options));
			
			return options;
			
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
			
			var page_id = '<c:out value="${pageId}"/>';
			var aiInptXtPrcStsDscd = $("#cbo_aiInptXtPrcStsDscd_Search_" + page_id).val(); // 검색옵션 처리상태
			
			tdElementNo = $('.table-responsive-sm').find('thead').find('tr').find('th'); // [No] column selector #1
			tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
			tdElementNoObj.html(""); // [No] column text remove
			
			if(aiInptXtPrcStsDscd == ""){
				tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off" disabled>');
				$(nRow).find('td').eq(0).html('');
			}else if(aiInptXtPrcStsDscd != ""){
				tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off" >');
				$(nRow).find('td').eq(0).html('<input type="checkbox" class="multiRowChkBox" id="multiRowChkBox" style="background-color: transparent !important;">');	
			}
			
			// FOR IE NULL
			//$(nRow).find('td').eq(10).html('');
			
			/*
			if(aData['aiInptUserAutVal']=='S2'){
				var multiChkBox = $(nRow).find('td').eq(0).find('.multiRowChkBox');
				$(multiChkBox).prop('disabled', true);
			}*/
			
		}
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
	console.log(row.aiInptUserAutVal)
	/*
	if(row.aiInptUserAutVal=='S2'){
		<c:out value="${gridId}"/>.deselectItem(index);
	}*/
	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', true);
	}
	
	revertUngeneratedBtnsActive();
	
	var page_id = '<c:out value="${pageId}"/>';
	var aiInptXtPrcStsDscd = $("#cbo_aiInptXtPrcStsDscd_Search_" + page_id).val(); // 검색옵션 처리상태
	
	if(aiInptXtPrcStsDscd == ""){
		<c:out value="${dataTableId}"/>.deselectItem(index);
	}
};

var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', false);	
	}
	
	var testTableObject = <c:out value="${dataTableId}"/>;
	var selectedRowsList = testTableObject.getSelRows();
	if(selectedRowsList.length == 0){
		revertUngeneratedBtnsDeactive();
	}
};

function chang(){
	$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val("");
}

function revertUngeneratedBtnsActive(){
	
	// 만약 처리상태가 미확인 이면 확인취소버튼은 활성화 금지, 확인이면 확인완료버튼은 활성화 금지, 전체면 둘다 활성화금지
	var page_id = '<c:out value="${pageId}"/>';
	var aiInptXtPrcStsDscd = $("#cbo_aiInptXtPrcStsDscd_Search_" + page_id).val(); // 검색옵션 처리상태
	
	if(aiInptXtPrcStsDscd == "11"){
		$('.revertUngeneratedConfirmBtn').attr('disabled', false);
		$('.revertUngeneratedConfirmBtn').removeClass('retryLogEndBtnDisabled');
		$('.revertUngeneratedConfirmBtn').addClass('btType1');
	}else if(aiInptXtPrcStsDscd == "12"){
		$('.revertUngeneratedCancelBtn').attr('disabled', false);
		$('.revertUngeneratedCancelBtn').removeClass('retryLogEndBtnDisabled');
		$('.revertUngeneratedCancelBtn').addClass('btType1');
	}else{
		
	}
}

function revertUngeneratedBtnsDeactive(){
	$('.revertUngeneratedConfirmBtn').attr('disabled', true);
	$('.revertUngeneratedCancelBtn').attr('disabled', true);
	$('.revertUngeneratedConfirmBtn').removeClass('btType1');
	$('.revertUngeneratedCancelBtn').removeClass('btType1');
	$('.revertUngeneratedConfirmBtn').addClass('retryLogEndBtnDisabled');
	$('.revertUngeneratedCancelBtn').addClass('retryLogEndBtnDisabled');
	
	
}

function searchTableReload(){
	<c:out value="${dataTableId}"/>.searchList();
}

function ungeneratedConfirm(){
	
	var selRows = <c:out value="${dataTableId}"/>.getSelRows();
	if(selRows.length == 0){
		alert("확인완료 할 건을 선택해주세요.");
		return;
	}
	
	if(confirm("해당 건을 확인완료 처리 하시겠습니까?")){
		
		var testTableObject = <c:out value="${dataTableId}"/>;
		var selectedRowsList = testTableObject.getSelRows();
		
		var params = []
		var obj = null;
		
		for(var index = 0 ; index < selectedRowsList.length ; index++){
			params.push({n:'actlFxRefnos',v:selectedRowsList[index].actlFxRefno});
			params.push({n:'aiInptXtSrnos',v:selectedRowsList[index].aiInptXtSrno});
		}
		
		fnCmnSetFormParams($('#formParamData'), params);
		
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctScrnNo" value="1030">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');

		$.post('/api/revert/ungenerated/confirm', $('#formParamData').serialize(), function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				revertUngeneratedBtnsDeactive();
				searchTableReload();	
			}
			
		});
	}
}

function ungeneratedCancel(){
	var selRows = <c:out value="${dataTableId}"/>.getSelRows();
	if(selRows.length == 0){
		alert("확인취소 할 건을 선택해주세요,");
		return;
	}
	
	if(confirm("해당 건을 확인취소 처리 하시겠습니까?")){
		
		var testTableObject = <c:out value="${dataTableId}"/>;
		var selectedRowsList = testTableObject.getSelRows();
		
		var params = []
		var obj = null;
		
		for(var index = 0 ; index < selectedRowsList.length ; index++){
			params.push({n:'actlFxRefnos',v:selectedRowsList[index].actlFxRefno});
			params.push({n:'aiInptXtSrnos',v:selectedRowsList[index].aiInptXtSrno});
		}
	
		fnCmnSetFormParams($('#formParamData'), params);
		
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctScrnNo" value="1030">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');

		$.post('/api/revert/ungenerated/cancel', $('#formParamData').serialize(), function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				revertUngeneratedBtnsDeactive();
				searchTableReload();	
			}
			
		});
	}
}

function afterSchBtn(){
	revertUngeneratedBtnsDeactive();
}

function appvAllSelectCheck(){
	console.log("appvAllSelectCheck()");
	
	var allChkBox = $('#appvAllSelector');
	
	if(allChkBox.is(":checked")){
		console.log("all check!");
		testConsoleTable();
	}else if(!allChkBox.is(":checked")){
		console.log("all check not!");
		fnDeselectListTableAll();
	}
}

function fnDeselectListTableAll(){
	var testTableObject = <c:out value="${dataTableId}"/>;
	testTableObject.deselectAllListTableRow();
	$('.multiRowChkBox').prop('checked', false);
}

function testConsoleTable(){
	var testTableObject = <c:out value="${dataTableId}"/>;
	console.log(testTableObject);
	var dataRows = testTableObject.getAllListTableRow();
	dataRowsTest = testTableObject.getAllListTableRow();
	console.log("dataRows: ", dataRows);
	testTableObject.selectAllListTableRow();
	
	var selectedRowsList = testTableObject.getSelRows();
	
	// 조건부 선택 해제
	for(var index = 0 ; index < selectedRowsList.length ; index++){
		var multiChkBox = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
		$(multiChkBox[index]).prop('checked', true);
	}
}

function downXls<c:out value="${pageId}"/>(){
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("1030",null,"02",$.param(searchOption));
	
	fnCmnDownXls($('#formXls'), '/api/revert/ungenerated/xls', searchOption);
	
} 
</script>