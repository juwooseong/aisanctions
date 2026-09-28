<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="4020"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>담당자별 진행현황 [4020]</strong>
		<span class="revertStatPageDiscription">담당자별 심사 및 자체점검 진행 중인 목록을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>수출/수입심사현황</span>
			<span>담당자별 진행현황</span>
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
				<%--
					<span class="label">업무생성일</span>
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="rsIndx1" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio"  value="" name="inptRcpDt" id="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx1">전체</label>
					<label for="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" id="rsIndx2" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio" value="당일" checked="checked" name="inptRcpDt" id="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx2">당일</label>
					 --%>
				</p>
				<p class="w26">
					<label for="cbo_inptAtmcBizNm_Search_${pageId}" class="label">업무</label>
					<select class="" name="schGbn" id="cbo_inptAtmcBizNm_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<option value="0102">수출+수입</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w26">
					<label for="cbo_inptAtvtNm_Search_${pageId}" class="label">진행구분</label>
					<select class="" name="schGbn" id="cbo_inptAtvtNm_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<option value="999">진행</option>
						<option value="130">pending</option>
					</select>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>" onclick="searchDaily();">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<p class="w24">
					<label for="txt_inptBizAlctCrpeEno_${pageId}" class="label">담당직원번호</label>
					<input type="text" class="it w52_v2" placeholder="직원번호 입력" id="txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_eno }"/>">
					<button type="button" class="btType4 info" onclick="layer('.layerSt1');" id="detailSanctionButton<c:out value="${pageId}"/>" data-toggle="modal" data-target="#schUserModal">
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
			
			<div class="daySumWrapper">
				<%--
				<span class="daySumRefreshWrapper">
			        <span class="daySumRefreshText">
				        <i class="fa fa-refresh mt-4 dailyIcon"></i>
				      	 새로고침
				    </span>
    			</span>
    			 --%>
				<table class="daySumTb">
					<tr class="daySumTh">
						<td class="daySumColumn">업무생성일</td>
			            <td class="daySumColumn">스캔건수</td>
			            <td class="daySumColumn">AI자동심사</td>
			            <td class="daySumColumn">심사중</td>
			            <td class="daySumColumn">결재중</td>
			            <td class="daySumColumn">완료</td>
			            <td class="daySumColumn">총이미지수</td>
			            <td class="daySumColumn"></td>
			        </tr>
			        <tr class="daySumTd">
			        	<td class="daySumTd" id="valueDate" style="padding: 0;">
			        		<input type="text" readonly class="cal daterange-basic calSingle" name="dailySchDt" id="dailySchDt" pageid="<c:out value="${pageId}"/>">
			        	</td>
			            <td class="daySumTd" id="value0">VALUE</td>
			            <td class="daySumTd" id="value1">VALUE</td>
			            <td class="daySumTd" id="value2">VALUE</td>
			            <td class="daySumTd" id="value3">VALUE</td>
			            <td class="daySumTd" id="value4">VALUE</td>
			            <td class="daySumTd" id="value5">VALUE</td>
			            <td class="daySumTd" id="value6" style="padding: 0;text-align: center;">
				            <span class="daySumRefreshText" id="reProcInfoRegBtn" style="box-sizing: border-box;font-size: 12px;cursor: pointer;">
							<i class="fa fa-refresh search-reset fa-sm"></i>
							새로고침</span>
							<%--
			            	<button type="button" class="daySumRefreshText" style="display: block;margin: 0;width: 100%;height: 100%;border: 1px solid #999;background-color: #fff;color: #666;height: 21px;">새로고침</button>
			            	 --%>
			            </td>
			        </tr>
				</table>
			</div>
		</div>
	</div>
	
	<form id="formRevertDetail" action='/revert/detail' method='POST' target='revertDetailWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='inptAtvtCd' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
	</form>
	
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
	<form id="formCommonRevertHistory" action='/common/revert/history' method='POST' target='commonRevertHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
	<form id="formCommonQaHistory" action='/common/qa/history' method='POST' target='commonQaHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
</div>

<form id="formXls" method="get"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
$(function() {
	
	initLoadingDisplay("Y", "class", "container");
	
	// daily table request
	searchDaily();
	
	var defaultDate = formatYMD(getToDay());
	$('#radio_inptRcpDt_Search_<c:out value="${pageId}"/>').val(defaultDate);
	
	$("#txt_inptBizAlctCrpeFnm_Search_<c:out value="${pageId}"/>").keydown(function(event) {
		if (event.keyCode ===8) {
			$("#txt_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>").val("")
		}
		if (event.keyCode ===13) {
			$('#detailSanctionButton<c:out value="${pageId}"/>').trigger("click");
		}
	});
	
	// 새로고침 클릭 시
	$(document).on('click', '.daySumRefreshText', function(){
		searchDaily();
	});
	
	// 업무생성일 변경 시
	$(document).on('change', '#dailySchDt', function(){
		searchDaily();
	});
	
	// 조회버튼 클릭 시(하단 새로고침)
	$(document).on('click', '.listSearchButton', function(){
		searchDaily();
	});
});


$('#<c:out value="${dataTableId}"/>').on('click', 'td button', function() {
	
	var _row_index = $(this).closest('tr');	
	var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
	var _inptMstSrno = data['inptMstSrno'];
	var _inptAtvtCd = data['inptAtvtCd']; 
	var _aiInptCmnCd = data['aiInptCmnCd']; 
	var _actlFxRefno = data['actlFxRefno']; 
	
	if (_aiInptCmnCd=='1' || _aiInptCmnCd=='2') { 
		
		// 심사상세 팝업
		var formCommonHistory = $('#formCommonHistory')[0];
		formCommonHistory.inptMstSrno.value = _inptMstSrno;
		formCommonHistory.inptAtvtCd.value = _inptAtvtCd;
		formCommonHistory.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formCommonHistory);
	} else {
		// 심사상세 팝업
		var formCommonHistoryQa = $('#formCommonHistoryQa')[0];
		formCommonHistoryQa.inptMstSrno.value = _inptMstSrno;
		formCommonHistoryQa.inptAtvtCd.value = _inptAtvtCd;
		formCommonHistoryQa.actlFxRefno.value = _actlFxRefno;
		fnFullWin(formCommonHistoryQa);
	}
});  


$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
});


$('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
	var _aiInptCmnCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['aiInptCmnCd'];
//	var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['aiInptCmnCd'];
	
	if (3 == _column_index) {
		if (_aiInptCmnCd=='1' || _aiInptCmnCd=='2') { 
			// 심사이력 팝업
			var formCommonRevertHistory = $('#formCommonRevertHistory')[0];
			formCommonRevertHistory.inptMstSrno.value = _inptMstSrno;
			formCommonRevertHistory.actlFxRefno.value = _actlFxRefno;
			formCommonRevertHistory.inptAtmcBizDscd.value = _aiInptCmnCd;
			fnHistoryWin(formCommonRevertHistory);
		} else {
			// 심사이력 팝업
			var formCommonQaHistory = $('#formCommonQaHistory')[0];
			formCommonQaHistory.inptMstSrno.value = _inptMstSrno;
			formCommonQaHistory.actlFxRefno.value = _actlFxRefno;
			formCommonQaHistory.inptAtmcBizDscd.value = _aiInptCmnCd;
			fnHistoryWin(formCommonQaHistory);
		}
	}
});

function downXls<c:out value="${pageId}"/>(){
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("4020",null,"02",$.param(searchOption));
	
	fnCmnDownXls($('#formXls'), '/api/revert/stat/status/xls', searchOption);
	
} 
			
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/revert/stat/status',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-120' },
		{ targets: 4, className: 'td-text-center td-text-40' },
		{ targets: 5, className: 'td-text-left td-text-120' },
		{ targets: 6, className: 'td-text-left td-text-100' },
		{ targets: 7, className: 'td-text-center td-text-60' },
		{ targets: 8, className: 'td-text-left td-text-140' },
		{ targets: 9, className: 'td-text-center td-text-40' },
		{ targets: 10, className: 'td-text-right td-text-80' },
		{ targets: 11, className: 'td-text-center td-text-60' },
		{ targets: 12, className: 'td-text-left td-text-60' },
		{ targets: 13, className: 'td-text-center td-text-60' },
		{ targets: 14, visible: false},
		{ targets: 15, visible: false},
		{ targets: 16, visible: false}
	],
	columns: [
		{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
       	{"data": "inptAtmcBizNm", title: '업무'},
       	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
    		return '<b class="detailBtn">' + data + '</b>'
    	}},
       	{"data": "warrning", title: '주의정보'},
       	{"data": "inptPrcsNm", title: '프로세스'},
       	{"data": "inptAtvtNm", title: '액티비티'},
       	{"data": "aiInptCusNo", title: '고객번호'},
       	{"data": "aiInptCusNm", title: '고객명'},
       	{"data": "fcCuNm", title: '통화'},
       	{"data": "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
       	{"data": "jingheng", title: '진행구분'},
       	{"data": "inptBizAlctCrpeFnm", title: '담당자'},
       	{title: '상세보기', render:function(data, type, row, meta){
    			var html; 
    			var acvtN = Number(row.inptAtvtCd);
    			//alert(acvtN);
       			if(acvtN >= 80){
       				return '<button type="button" class="btn btn-primary m-1 p-1 viewDetailBtn" data-toggle="modal">'+
					'<i class="fa fa-search fa-lg"></i>'+
					'</button>';
       			}else{
       				return null;
       			}
       	}},
       	{"data": "inptAtvtCd"},
    	{"data": "aiInptCmnCd"},
       	
    ],
    //검색정의
    getSearchOption : function() {
    	var page_id = '<c:out value="${pageId}"/>';
    	var options = {};
		var filters = [];
		
		var actlFxRefno = $("#txt_actlFxRefno_Search_"+page_id).val(); // 번호
		var inptAtmcBizId = $("#cbo_inptAtmcBizNm_Search_"+page_id).val(); // 업무
		var aiInptCrpeEno = $("#cbo_inptBizAlctCrpeEno_Search_"+page_id).val(); // 담당자
		var inptAtvtCd = $("#cbo_inptAtvtNm_Search_"+page_id).val(); //진행구분
		var inptRcpDt = $(':radio[name="inptRcpDt"]:checked').val();
		var inptBizAlctCrpeFnm = $("#txt_inptBizAlctCrpeFnm_Search_<c:out value="${pageId}"/>").val();
		var inptBizAlctCrpeEno = $("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val();
		var aiInptCusNo = $("#txt_aiInptCusNo_Search_<c:out value="${pageId}"/>").val();
		
		options.actlFxRefno = actlFxRefno;
		options.aiInptCusNo = aiInptCusNo;
		options.aiInptCrpeEno = aiInptCrpeEno;
		options.inptAtvtCd = inptAtvtCd;
		options.inptRcpDt = inptRcpDt;
		options.aiInptCmnCd = inptAtmcBizId;
		options.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
		
		var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
		var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		options.schSdate1 = schSdate1;
		options.schEdate1 = schEdate1;
		
		fnCmnProgramLog("4020",null,"01",$.param(options));
		
		return options;
	},
	
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		if(aData['inptAtvtCd'] == '80') {
			//$('td', nRow).css('background-color', '#f2dede');
			$(nRow).addClass('rowHandwriting');
		}
		
		if(aData['warrning'] == '오류' || aData['warrning'] == '지연') {
			//$('td', nRow).css('background-color', '#f2dede');
			$(nRow).find('td:eq(4)').css('color', 'red');
		}
		
	}
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

<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 조회" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>

<script>
function modalUserListTable<c:out value="${pageId}"/>_selectCallback(e, dt, type, index, row){
}

function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val(row.aiInptUserEno);
}
/* $(function(){
	modalUserListTable<c:out value ="${pageId}"/>_data.userName = 'schUserNm';
	modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>';
	modalUserListTable<c:out value ="${pageId}"/>_data.userNoId = 'txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>';
}); */
</script>

<script>
function searchDaily(){
	console.log("searchDaily");
	console.log('test2');
	var param = {};	
	param.schSdate = $('#dailySchDt').val();
	//param.schEdate = "none";
	refreshToggle(true);
	$.post('/api/common/status/daily', param, function(data){
		/* if(data.rst == 'success'){
			alert('정상적으로 처리되었습니다.');
			searchTableReload();	
		} */
		refreshToggle(false);
		console.log("data.resultList: ", data.resultList);
		$("#value0").html(numberCommaFormat(data.resultList[0].daily1));
		$("#value1").html(numberCommaFormat(data.resultList[0].daily2));
		$("#value2").html(numberCommaFormat(data.resultList[0].daily3));
		$("#value3").html(numberCommaFormat(data.resultList[0].daily4));
		$("#value4").html(numberCommaFormat(data.resultList[0].daily5));
		$("#value5").html(numberCommaFormat(data.resultList[0].daily6));
		
	});
}

function numberCommaFormat(num){
	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function refreshToggle(YN){
	if(YN){
		$('.dailyIcon').addClass('fa-spin');
		$('.dailyIcon').addClass('dailyRefreshing');
	}else{
		$('.dailyIcon').removeClass('fa-spin');
		$('.dailyIcon').removeClass('dailyRefreshing');
	}
}

function chang(){
	$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val("");
} // 메서드 지워도 될듯

function isCheck() {
	var value = document.getElementById("dateDisable");
	var startDateText = document.getElementById("cld_schSdate1_Search_<c:out value="${pageId}"/>");
	var endDateText = document.getElementById("cld_schEdate1_Search_<c:out value="${pageId}"/>");
	isChecked(value, startDateText, endDateText);
}
</script> 