<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="4040"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>심사오류명세 [4040]</strong>
		<span class="revertStatPageDiscription">심사완료 건 중 수기보정, 재스캔, 재추출 이력이 있는 심사목록을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>수출/수입심사현황</span>
			<span>심사오류명세</span>
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
					<label for="cbo_inptAtmcBizNm_Search_${pageId}" class="label">업무</label>
					<select class="" name="schGbn" id="cbo_inptAtmcBizNm_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<c:if test="${item.aiInptCmnCd ne '3' }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w26">
					<label for="cbo_inptAtvtNm_Search_${pageId}" class="label">오류구분</label>
					<select class="" name="schGbn" id="cbo_inptAtvtNm_Search_<c:out value="${pageId}"/>">
						<c:forEach var="item" items="${errCdList}">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:forEach>
					</select>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<p class="w24">
					<label for="txt_inptBizAlctCrpeEno_${pageId}" class="label">담당직원번호</label>
					<input type="text" class="it w52_v2" id="txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>" placeholder="직원번호 입력" maxlength="<c:out value="${maxLength_eno }"/>">
					<button type="button" class="btType4 info" onclick="layer('.layerSt1');" data-toggle="modal" id="detailSanctionButton<c:out value="${pageId}"/>" data-target="#schUserModal">
						<i class="fa fa-search fa-lg"></i>
					</button>
				</p>
				<p class="w12"></p>
				<p class="w26">
					<label for="txt_actlFxRefno_Search_${pageId}" class="label">Ref.No</label>
					<input type="text" class="it" id="txt_actlFxRefno_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_refno }"/>">
				</p>
				<p class="w26">
					<label for="txt_aiInptCusNo_Search_${pageId}" class="label">고객번호</label>
					<input type="text" class="it" id="txt_aiInptCusNo_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_cusno }"/>">
				</p>
				<input type="hidden" class="it" value="" id="schUserNm"/>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<button type="button" class="gridRightTopBtn xlsDownloadBtn" onclick="downXls<c:out value="${pageId}"/>();">엑셀다운로드</button>
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
</div>

<form id="formXls" method="get"></form>

<form id="formHistoryRevert" action='/common/history' method='POST' target='historyRevertWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
</form>

<form id="formHistoryQa" action='/common/history/qa' method='POST' target='historyQatWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
</form>

<form id="formQaHistory" action='/common/qa/history' method='POST' target='qaHistoryWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
</form>

<form id="formRevertHistory" action='/common/revert/history' method='POST' target='revertHistoryWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
</form>


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
	
	$("#schUserNo").keydown(function(event) {
		
			 if(event.keyCode ===13){
				$('#detailSanctionButton<c:out value="${pageId}"/>').trigger("click");
			} 
		}); 
	
});

function isCheck() {
	var value = document.getElementById("dateDisable");
	var startDateText = document.getElementById("cld_schSdate1_Search_<c:out value="${pageId}"/>");
	var endDateText = document.getElementById("cld_schEdate1_Search_<c:out value="${pageId}"/>");
	isChecked(value, startDateText, endDateText);
}

$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
	var _inptAtvtCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtvtCd'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
});

 $('#<c:out value="${dataTableId}"/>').on('click', 'td button', function() {
	
	var _row_index = $(this).closest('tr');	
	var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
	var _inptMstSrno = data['inptMstSrno'];
	var _inptAtvtCd = data['inptAtvtCd']; 
	var _aiInptCmnCd = data['aiInptCmnCd']; 
	var _actlFxRefno = data['actlFxRefno']; 
	
	
	if(_aiInptCmnCd=='1' || _aiInptCmnCd=='2'){ 
		var formHistoryRevert = $('#formHistoryRevert')[0];
		formHistoryRevert.inptMstSrno.value = _inptMstSrno;
		formHistoryRevert.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formHistoryRevert);
		//window.open("/common/history?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
	}else{
		var formHistoryQa = $('#formHistoryQa')[0];
		formHistoryQa.inptMstSrno.value = _inptMstSrno;
		formHistoryQa.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formHistoryQa);
		//window.open("/common/history/qa?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
	}
});

$('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
    var _row_index = $(this).closest('tr');	
    var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = data['inptMstSrno'];
	var _inptAtvtCd = data['inptAtvtCd']; 
	var _aiInptCmnCd = data['inptAtmcBizDscd']; 
	var _actlFxRefno = data['actlFxRefno']; 
	var _inptAtmcBizDscd = data['aiInptCmnCd'];
	
	if (3 == _column_index) {
		if (1 == _aiInptCmnCd || 2 == _aiInptCmnCd) {
			var formRevertHistory = $('#formRevertHistory')[0];
			formRevertHistory.inptMstSrno.value = _inptMstSrno;
			formRevertHistory.actlFxRefno.value = _actlFxRefno;
			formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formRevertHistory);
			
		} else if (3 == _aiInptCmnCd) {
			var formQaHistory = $('#formQaHistory')[0];
			formQaHistory.inptMstSrno.value = _inptMstSrno;
			formQaHistory.actlFxRefno.value = _actlFxRefno;
			formQaHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formQaHistory);
		}
	}
});   

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/revert/stat/error',
	columnDefs: [

		{ targets: 0, className: 'td-text-center td-text-40', orderable: false }, // no
		{ targets: 1, className: 'td-text-center td-text-60' }, // 생성일
		{ targets: 2, className: 'td-text-center td-text-60' }, // 업무
		{ targets: 3, className: 'td-text-left td-text-120' }, // refno
		{ targets: 4, className: 'td-text-center td-text-40' }, // 액티비티
		{ targets: 5, className: 'td-text-center td-text-60' }, // 고객번호
		{ targets: 6, className: 'td-text-left td-text-120' }, // 고객명
		{ targets: 7, className: 'td-text-center td-text-40' }, // 통화
		{ targets: 8, className: 'td-text-right td-text-80' }, // 금액
		{ targets: 9, className: 'td-text-center td-text-60' }, // 오류구분
		//{ targets: 9, className: 'td-text-center td-text-40' }, // 담당자
		{ targets: 10, className: 'td-text-center td-text-60' }, // S1
		{ targets: 11, className: 'td-text-center td-text-60' }, // S2
		{ targets: 12, className: 'td-text-center td-text-60' }, // 상세보기
		{ targets: 13, visible: false }
	],
	columns: [
		{"data": "inptRcpDtStr", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
		{"data": "inptAtmcBizDsNm", title: '업무'},
    	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
    	{"data": "inptAtvtNm", title: '액티비티'},
    	{"data": "aiInptCusNo", title: '고객번호'},
    	{"data": "aiInptCusNm", title: '고객명' },
    	{"data": "fcCuNm", title: '통화'},
    	{"data": "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
		{"data": "errTxt", title: '오류구분'},
		/*
		{"data": "errTxt", title: '고객번호', render: function(d){
    		return $('#schUserNo').val();
    	}},*/
		{"data": "aiInspeEnm", title: 'S1'},
		{"data": "aiAppvEnm", title: 'S2'},
		{"title": '상세보기', "render":function(){
    		return '<button type="button" class="btn btn-primary m-1 p-1 viewDetailBtn" data-toggle="modal">'+
			'<i class="fa fa-search fa-lg"></i>'+
			'</button>';
    	}},
    	{"data": "aiInptCmnCd"}
    ],
  //검색정의
    getSearchOption : function() {
    	
    	var page_id = '<c:out value="${pageId}"/>';
    	var options = {};
		var filters = [];
		
		var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
		var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		
		var errCd = $("#cbo_inptAtvtNm_Search_" + page_id).val(); // 오류구분
		
		var actlFxRefno = $("#txt_actlFxRefno_Search_"+page_id).val(); // 번호
		var inptAtmcBizId = $("#cbo_inptAtmcBizNm_Search_"+page_id).val(); // 업무
		var inptBizAlctCrpeEno = $("#txt_inptBizAlctCrpeEno_"+page_id).val(); // 담당자 번호 
		var inptBizAlctCrpeAuth = $("#cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>").val(); // 담당자 권한
		var inptRcpDt = $(':radio[name="inptRcpDt"]:checked').val();
		var aiInptCusNo = $("#txt_aiInptCusNo_Search_<c:out value="${pageId}"/>").val();
		
		options.actlFxRefno = actlFxRefno;
		options.aiInptCusNo = aiInptCusNo;
		options.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
		options.errCd = errCd;
		options.inptRcpDt = inptRcpDt;
		options.aiInptCmnCd = inptAtmcBizId;
		options.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
		options.schSdate1 = schSdate1;
		options.schEdate1 = schEdate1;
		options.inptBizAlctCrpeAuth = inptBizAlctCrpeAuth;
    	
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("4040",null,"01",$.param(options));
		
		return options;
		
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		if(aData['inptAtvtCd'] == '3') {
			//$('td', nRow).css('background-color', '#f2dede');
			$(nRow).addClass('rowHandwriting');
		}
		
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
		
		$(nRow).find('td:eq(9)').css('color', totaltextAiInptRstColor);
		$(nRow).find('td:eq(10)').css('color', itmInptAiInptRstColor);
		$(nRow).find('td:eq(11)').css('color', safewatchAiInptRstColor);
	}
};
function downXls<c:out value="${pageId}"/>(){
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("4040",null,"02",$.param(searchOption));
	
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	
	fnCmnDownXls($('#formXls'), '/api/revert/stat/error/xls', searchOption);
}
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
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 선택" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
};
</script>
<script>
//사용자 선택 모달 다이얼로그 스크립트 시작.
var userModalOpenGbn = 1;	//사용자 모달창을 어느 버튼에서 오픈했는지 구분자.
function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	//console.info(row);
	//row.aiInptUserEno
	//row.aiInptUserId
	//row.aiInptUserNm
	if(row){
		if(userModalOpenGbn==1){
			$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val(row.aiInptUserEno);
			$("#schUserNm").val(row.aiInptUserNm);
		}
	}
}
function fnUserModalSelect(gbn){
	userModalOpenGbn = gbn;
}
$(function(){
	//modalUserListTable<c:out value ="${pageId}"/>_data.userName = 'schUserNm';
	//modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>';
//	modalUserListTable<c:out value ="${pageId}"/>_data.userNoId = 'txt_inptBizAlctCrpeEno_';
	
	//상세보기버튼 클릭시 팝업오픈 처리.
	$('#<c:out value="${dataTableId}"/>').on('click', 'td button', function() {
		/*
		var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _inptMstSrno = data['inptMstSrno'];
		var _inptAtvtCd = data['inptAtvtCd']; 
		var _aiInptCmnCd = data['aiInptCmnCd']; 
		var _actlFxRefno = data['actlFxRefno']; 
		if(_aiInptCmnCd=='1' || _aiInptCmnCd=='2'){ 
			window.open("/common/history?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
		}else{
			window.open("/common/history/qa?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
		}*/
		
		
		var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _inptMstSrno = data['inptMstSrno'];
		var _inptAtvtCd = data['inptAtvtCd']; 
		var _aiInptCmnCd = data['aiInptCmnCd']; 
		var _actlFxRefno = data['actlFxRefno']; 
		
		
		if(_aiInptCmnCd=='1' || _aiInptCmnCd=='2'){
			var formHistoryRevert = $('#formHistoryRevert')[0];
			formHistoryRevert.inptMstSrno.value = _inptMstSrno;
			formHistoryRevert.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formHistoryRevert);
			
			// window.open("/common/history?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
		}else{
			var formHistoryQa = $('#formHistoryQa')[0];
			formHistoryQa.inptMstSrno.value = _inptMstSrno;
			formHistoryQa.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formHistoryQa);
			
		//	window.open("/common/history/qa?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
		}
		
		
		
	});
	
});
function chang(){
	$("#schUserNo").val("");
}


</script>