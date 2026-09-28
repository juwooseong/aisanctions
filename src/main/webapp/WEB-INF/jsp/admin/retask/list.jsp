<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7080"/>
<c:set var="dataGridId1" value="dataGrid1"/>
<c:set var="dataGridId2" value="dataGrid2"/>

<div class="container">
	<h2 class="title">
		<strong>업무 재할당 관리 [7080]</strong>
		<span class="revertStatPageDiscription">사용자별 이미 배정된 업무를 다른 사용자에게 재배정 처리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>업무 재할당 관리</span>
		</span>
	</h2>

	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form id="formSearch" onsubmit="return false;">
			<input type="hidden" id="schSenderAuth" />
				<p class="w18">
					<label for="schAuth" class="label">권한</label>
					<select class="" name="schAuth" id="schAuth">
						<option value="">전체</option>
							<c:forEach var="item" items="${userAuthList}">
								<c:if test="${item.aiInptCmnCd ne '04' and item.aiInptCmnCd ne '05' }">
									<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
								</c:if>
							</c:forEach>
					</select>
				</p>
				<p class="w20">
					<label for="schUserNo" class="label">직원번호</label>
					<input type="text" class="it" value="" id="schUserNo" placeholder="직원번호" title="직원번호"/>
					<button type="button" class="btType4 info" id="btn_appUserNo" data-toggle="modal" data-target="#schUserModal" onclick="fnUserModalSelect(1);">
						<i class="fa fa-search fa-lg"></i>
					</button>
				</p>
				<p class="w20">
					<span>
						<label for="schUserNm" class="label">직원명</label>
						<input type="text" class="it" value="" id="schUserNm" placeholder="직원명" title="직원명"/>
						
					</span>
				</p>
				<p class="w20">
					<span>
						<label for="userFaReYn" class="label">부재여부</label>
						<select class="" name="userFaReYn"" id="userFaReYn">
							<option value="">전체</option>
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</span>
				</p>
				<button class="searchBtnType1" id="searchBtn_<c:out value="${dataGridId1}"/>" onclick="resetFun();">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<input type="hidden" id="schSenderAuthAll" value="">
			</form>
		</div>
	</div>

	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${dataGridId1}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="schSenderNo" class="label">인계자</label>
								<input type="text" id="schSenderNo" class="it" value="" placeholder="직원번호" title="직원번호" readonly/>
							</p>
							<p class="">
								<input type="text" class="it" value="" id="schSenderNm" placeholder="직원명" title="직원명" readonly/>
								</span>
							</p>
							<p class="">
								<label for="schReceiverNo" class="label">인수자</label>
								<input type="text" class="it" value="" id="schReceiverNo" placeholder="직원번호" title="직원번호" disabled="disabled"/>
							</p>
							<p class="">
								<span>
									<input type="text" class="it" value="" id="schReceiverNm" placeholder="직원명" title="직원명" disabled="disabled"/>
									<button type="button" class="btType4 info" id="btn_appUserNo" data-toggle="modal" data-target="#schUserModal" onclick="fnUserModalSelect(2);">
										<i class="fa fa-search fa-lg"></i>
									</button>
								</span>
							</p>
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType1" id="retaskBtn" onclick="fnReTask();">변경</a>
						</span>
					</div>
				</div>
			</div>
		</div>
		<div class="tbWrap">
			<div class="tbCon">
				<button type="button" class="gridRightTopBtn delete" id="delBtn" onclick="deleteBtn<c:out value="${dataGridId2}"/>();">삭제</button>
				<table class="table table-responsive-sm scrollTb grid_2" id="<c:out value="${dataGridId2}"/>"></table>
			</div>
		</div>
	</div>
</div>

<form id="formCommonHistory" action='/common/history' method='POST' target='commonHistoryWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
</form>

<form id="formCommonHistoryQa" action='/common/history/qa' method='POST' target='commonHistoryQaWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
</form>

<form id="formRevertHistory" action='/common/revert/history' method='POST' target='revertHistoryWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
</form>

<form id="formQaHistory" action='/common/qa/history' method='POST' target='commonQaHistoryWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
</form>

<form id="formDelParams" onsubmit="return false;"></form>
<form id="formProcParams" onsubmit="return false;"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
$(function() {
	$('#delBtn').css('display','none');
});

$('#<c:out value="${dataGridId2}"/>').on('click', 'td', function() {
	
	if (!checkLogin()) {
		fnLoginAlert();
		return false;
	}
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataGridId2}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataGridId2}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['inptMstSrno']; //
	var _inptAtvtCd = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['inptAtvtCd']; //
	var _actlFxRefno = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['actlFxRefno']; //
	var _inptAtmcBizDscd = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	var formDetail;
	
	if (6 == _column_index || 7 == _column_index) {
		if(_inptAtmcBizDscd != '3'){
			formDetail = $('#formCommonHistory')[0];
		}else{
			formDetail = $('#formCommonHistoryQa')[0];
		}
			formDetail.inptMstSrno.value = _inptMstSrno;
			formDetail.inptAtvtCd.value = _inptAtvtCd;
			formDetail.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formDetail);			
	}
});


$('#<c:out value="${dataGridId2}"/>').on('dblclick', 'td', function() {
	
	if (!checkLogin()) {
		fnLoginAlert();
		return false;
	}
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataGridId2}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataGridId2}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['inptMstSrno'];
	var _actlFxRefno = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['actlFxRefno'];
	var _inptAtmcBizDscd = <c:out value="${dataGridId2}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
	var formDetail;
	
	if (3 == _column_index) {
		if(_inptAtmcBizDscd != '3'){
			formDetail = $('#formRevertHistory')[0];
		}else{
			formDetail = $('#formQaHistory')[0];
		}
		// 심사이력 팝업
		formDetail.inptMstSrno.value = _inptMstSrno;
		formDetail.actlFxRefno.value = _actlFxRefno;
		formDetail.inptAtmcBizDscd.value = _inptAtmcBizDscd;
		fnHistoryWin(formDetail);
	}
});

var <c:out value="${dataGridId1}"/>Config = {
	ajaxUrl : '/api/admin/retask/user',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-60' },
		{ targets: 4, className: 'td-text-right td-text-40' },
		{ targets: 5, className: 'td-text-center td-text-40' }
	],
	columns: [
    	{"data": "aiInptUserAutVal", title: '권한'},
    	{"data": "aiInptUserEno", title: '직원번호'},
    	{"data": "aiInptUserNm", title: '직원명'},
    	{"data": "taskCnt", title: '업무건수'},
    	{"data": "aiInptUserFaReYn", title: '부재여부'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//권한
		if($("#schAuth").val()){
			options.schAuth = $("#schAuth").val();
		}
		
		//직원번호
		if($("#schUserNo").val()){
			options.schUserNo = $("#schUserNo").val();
		}
		
		//직원명
		if($("#schUserNm").val()){
			options.schUserNm = $("#schUserNm").val();
		}
		
		//부재여부
		if($("#userFaReYn").val()){
			options.aiInptUserFaReYn = $("#userFaReYn").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7080",null,"01",$.param(options));

		return options;
	}
};
var <c:out value="${dataGridId2}"/>Config = {
	ajaxUrl : '/api/admin/retask/task',
	columnDefs: [{
		orderable: false,
		className: 'select-checkbox',
		targets: 0
	}],
	columnDefs: [
		{ 	
			targets: 0, 
			className: 'text-center td-text-20 no-use-sorting', orderable :false
		},
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-letf td-text-120 ' },
		{ targets: 4, className: 'td-text-center td-text-50' }, // 저장
		{ targets: 5, className: 'td-text-center td-text-50' }, // 주의
		{ targets: 6, className: 'td-text-left td-text-100' },
		{ targets: 7, className: 'td-text-letf td-text-100' },
		{ targets: 8, className: 'td-text-center td-text-80' }, // 고객번호
		{ targets: 9, className: 'td-text-letf td-text-120' },
		{ targets: 10, className: 'td-text-center td-text-50' }, // 통화
		{ targets: 11, className: 'td-text-right td-text-80' }, // 금액 
		{ targets: 12, className: 'td-text-center td-text-60' }, // total
		{ targets: 13, className: 'td-text-center td-text-60' }, // 항목심사
		{ targets: 14, className: 'td-text-center td-text-60' }, // s/w 
		{ targets: 15, className: 'td-text-center td-text-80' }, // detec
		{ targets: 16, className: 'td-text-center td-text-80' }, // mset
		{ targets: 17, visible: false},
		{ targets: 18, visible: false},
		{ targets: 19, visible: false},
		{ targets: 20, visible: false}
	],
	columns: [
		{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}}, // 생성일
    	{"data": "inptAtmcBizDsNm", title: '업무'},
    	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
    		if(row.save !=null || row.started !=null){
    			return '<b class="detailBtn2">' + data + '</b>'
    		}else{
    			return '<b class="detailBtn">' + data + '</b>'
    		}
    	}},
    	{"data": "save", title: '저장'}, // 저장
    	{"data": "wrrInfo", title: '주의'}, // 주의
    	{"data": "inptPrcsNm", title: '프로세스', render : function(data, type, row, meta){
    		if(row.bliv == 'BLIV'){
    			return '<b class="detailBtn">' + data + '</b>'
    		}else{
    			return '<b class="detailBtn3">' + data + '</b>'
    		}
    	}},
    	{"data": "inptAtvtNm", title: '액티비티', render: function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{"data": "aiInptCsno", title: '고객번호'},
    	{"data": "aiInptCusNm", title: '고객명'},
    	{"data": "fcCuNm", title: '통화'}, // 통화
    	{"data": "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }}, // 금액
    	{"data": "totaltextAiInptRstNm", title: 'TotalText'},
    	{"data": "itmInptAiInptRstNm", title: '항목심사'},
    	{"data": "safewatchAiInptRstNm", title: 'SafeWatch'},
    	{"data": "filtDtctNo", title: 'Detection ID'}, // detection ID
    	{"data": "inptMstSrno", title: 'master ID'}, // master ID
    	{"data": "inptAtmcBizDscd"},
    	{"data": "inptAtvtcd"}, 
    	{"data": "started" },
    	{"data": "bliv"}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//인계자[][]
		if($("#schSenderNo").val()){
			options.userId = $("#schSenderNo").val();
		}
		
		//인계자 권한
		if($("#schSenderAuth").val()){
			options.schAuth = $("#schSenderAuth").val();
		}
		return options;
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		tdElementNo = $('.grid_2').find('thead').find('tr').find('th'); // [No] column selector #1
		tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
		tdElementNoObj.html(""); // [No] column text remove
		tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off">');
		
		$(nRow).find('td').eq(0).html('<input type="checkbox" class="multiRowChkBox" id="multiRowChkBox" style="background-color: transparent !important;">');
	
	
		
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
};

function resetFun() {
	$("#schSenderNo").val("");
	$("#schSenderNm").val("");
	$("#schSenderAuth").val("");
	<c:out value="${dataGridId2}"/>.searchList();
}

function deleteBtn<c:out value="${dataGridId2}"/>(){
	var gridSelRows = <c:out value="${dataGridId2}"/>.getSelRows();
	var f = $('#formDelParams');
	var params = [];
//	params.push('<input type="hidden" name="aiInptListId" value="'+$('#aiInptListId').val()+'" />');				
//	params.push('<input type="hidden" name="aiInptCtgrId" value="'+$('#aiInptCtgrId').val()+'" />');		
	for(var i=0;i<gridSelRows.length;i++){
		var row = gridSelRows[i];
		params.push('<input type="hidden" name="inptMstSrno" value="'+row.inptMstSrno+'" />');
	}
	f.html(params.join(''));
	
	//프로그램 사용 이력 로그누적
	params.push('<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	params.push('<input type="hidden" name="aiInptCnctScrnNo" value="7080">');
	params.push('<input type="hidden" name="aiInptCnctFldCd" value="04">');
	params.push('<input type="hidden" name="aiInptCnctActiCd" value="06">');
	f.html(params.join(''));
	//fnCmnProgramLog("7040","05","06",$.param({'aiInptCtgrId' : $('#aiInptCtgrId').val(), 'aiInptListId' : $('#aiInptListId').val(), 'aiInptRsptTxtSrno' : $('#aiInptRsptTxtSrno').val()}));
	if(gridSelRows.length == 0){
		alert("삭제할 항목을 선택해주세요.");
		return;
	}
	
 	 if(confirm("삭제하시겠습니까?")){
 		 if(gridSelRows[0].inptAtmcBizDscd == '3'){
			$.ajax({
				url: '/api/admin/retask/delete/qa',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${dataGridId1}"/>.searchList();
					<c:out value="${dataGridId2}"/>.searchList();
					fnSetDetail(null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
 	 }else{
 		$.ajax({
			url: '/api/admin/retask/delete/sOne',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				<c:out value="${dataGridId1}"/>.searchList();
				<c:out value="${dataGridId2}"/>.searchList();
				fnSetDetail(null);
			} else {
				fnAlertErrorMsg(data);
			}
		});
 	 }
	}  
}
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataGridId1}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="false" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="201" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataGridId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="multi" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="201" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
var <c:out value="${dataGridId1}"/>_selectCallback = function(e, dt, type, index, row){
	$("#schSenderNo").val(row.aiInptUserEno);
	$("#schSenderNm").val(row.aiInptUserNm);
	$("#schSenderAuth").val(row.aiInptUserAutCd);
	
	$("#schReceiverNo").val("");
	$("#schReceiverNm").val("");
	
	$('#schSenderNo').prop('disabled',true);
	$('#schSenderNm').prop('disabled',true);
	if(row.aiInptUserAutCd == '03' || row.aiInptUserAutCd == '01'){
		$('#delBtn').css('display','block');
	}else{
		$('#delBtn').css('display', 'none');
	}
	
	<c:out value="${dataGridId2}"/>.searchList();
};
var <c:out value="${dataGridId2}"/>_selectCallback = function(e, dt, type, index, row){
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', true);
	}
};

var <c:out value="${dataGridId2}"/>_deselectCallback = function(e, dt, type, index, row){	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', false);	
	}
};

function fnReTask(){
	var gridSelRows = <c:out value="${dataGridId2}"/>.getSelRows();
	var f = $('#formProcParams');
	var params = [];
	params.push('<input type="hidden" name="inptBizAlctCrpeEno" value="'+$('#schReceiverNo').val()+'" />');		//인수자 번호
	params.push('<input type="hidden" name="oldUserEno" value="'+$('#schSenderNo').val()+'" />');				//인계자 번호
	for(var i=0;i<gridSelRows.length;i++){
		var row = gridSelRows[i];
		params.push('<input type="hidden" name="inptMstSrnos" value="'+row.inptMstSrno+'" />');
		params.push('<input type="hidden" name="inptAtmcBizDscds" value="'+row.inptAtmcBizDscd+'" />');
	}
	f.html(params.join(''));
	
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7080">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="12">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	
	//프로그램 사용 이력 로그누적
	//fnCmnProgramLog("7080",null,"12",f.serialize());

	if($.trim($('#schReceiverNo').val())==""){
		alert("인수자를 입력해주세요.");
		$('#schReceiverNo').focus();
		return;
	}
	if(gridSelRows.length==0){
		alert("재할당할 업무를 선택 해주세요.");
		return;
	}
	if($('#schReceiverNo').val()==$('#schSenderNo').val()){
		alert("인계자와 인수자가 동일합니다.");
		return;
	}
	if(confirm('선택하신 업무를 재할당 하시겠습니까?')){
		$.ajax({
			url: '/api/admin/retask/task/change',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				<c:out value="${dataGridId1}"/>.searchList();
				<c:out value="${dataGridId2}"/>.searchList();
				$('#schReceiverNo').val("");
				$('#schReceiverNm').val("");
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}
</script>
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 선택" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>
<script>

//사용자 선택 모달 다이얼로그 스크립트 시작.
var userModalOpenGbn = 1;	//사용자 모달창을 어느 버튼에서 오픈했는지 구분자.
function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	if(userModalOpenGbn==1){
		$("#schUserNo").val(row.aiInptUserEno);
		$("#schUserNm").val(row.aiInptUserNm);
	} else {
		$("#schReceiverNo").val(row.aiInptUserEno);
		$("#schReceiverNm").val(row.aiInptUserNm);
	}
	
}
 function fnUserModalSelect(gbn){
	userModalOpenGbn = gbn;
	
	if(userModalOpenGbn==2){
		
		modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'schSenderAuth';
	}else{
		$("#schSenderAuthAll").val('');
		modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'schSenderAuthAll';
	}
} 
 
$(function(){
	
	tdElementNo = $('.grid_2').find('thead').find('tr').find('th'); // [No] column selector #1
	tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
	tdElementNoObj.html(""); // [No] column text remove
	tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off">');
	
	initLoadingDisplay("Y", "class", "container");
	
	fnCmnDoEnterEvent($('#schUserNm').add('#schReceiverNm'),function(obj) {
		var btnModals = $('button[data-target="#schUserModal"]');
		if(obj.id=='schUserNm'){
			fnUserModalSelect(1);
			btnModals.eq(0).click();
		} else if(obj.id=='schReceiverNm'){
			fnUserModalSelect(2);
			btnModals.eq(1).click();
		}
	});
	
});

function appvAllSelectCheck(){
	var allChkBox = $('#appvAllSelector');
	
	if(allChkBox.is(":checked")){
		testConsoleTable();
	}else if(!allChkBox.is(":checked")){
		fnDeselectListTableAll();
	}
}

function fnDeselectListTableAll(){
	var testTableObject = <c:out value="${dataGridId2}"/>;
	testTableObject.deselectAllListTableRow();
	
	$('.multiRowChkBox').prop('checked', false);
}

function testConsoleTable(){
	var testTableObject = <c:out value="${dataGridId2}"/>;
	var dataRows = testTableObject.getAllListTableRow();
	dataRowsTest = testTableObject.getAllListTableRow();
	testTableObject.selectAllListTableRow();
	
	var selectedRowsList = testTableObject.getSelRows();
	
	$('.multiRowChkBox').prop('checked', true);
}
</script>