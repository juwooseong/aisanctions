<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="4010"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>업무생성목록 [4010]</strong>
		<span class="revertStatPageDiscription">WINI에서 접수된 업무명세로  이미지가 스캔되기 이전의 심사대상목록을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>수출/수입심사현황</span>
			<span>업무생성목록</span>
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
					<span class="label">업무생성일</span>
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="rsIndx1" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio" name="inptRcpDt" value="" id="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx1">전체</label>
					<label for="radio_inptRcpDt2_search_<c:out value="${pageId}"/>" id="rsIndx2" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio" name="inptRcpDt" value="당일" checked="checked" id="radio_inptRcpDt2_search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt2_search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx2">당일</label>
				</p>
				<p class="w28">
					<label for="cbo_inptAtmcBizDscd_Search_${pageId}" class="label">업무</label>
					<select class="" name="inptAtmcBizDscd" id="cbo_inptAtmcBizDscd_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<c:if test="${item.aiInptCmnCd ne '3' }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w28">
					<label for="cbo_aiInspAtvtStsCd_Search_${pageId}" class="label">생성구분</label>
					<select class="" name="schGbn" id="cbo_aiInspAtvtStsCd_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList2 }">
							<c:if test="${item.aiInptCmnCd eq '10' || item.aiInptCmnCd eq '60'}">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<p class="w28">
					<label for="txt_actlFxRefno_Search_${pageId}" class="label">Ref.No</label>
					<input type="text" class="it" id="txt_actlFxRefno_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_refno }"/>">
				</p>
				<p class="w28">
					<label for="txt_aiInptCusNo_Search_${pageId}" class="label">고객번호</label>
					<input type="text" class="it" id="txt_aiInptCusNo_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_cusno }"/>">
				</p>
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
	<form id="formRevertHistory" action='/common/revert/history' method='POST' target='revertHistoryWin'>
		<input TYPE='hidden' name='inptMstSrno' value=''>
		<input TYPE='hidden' name='actlFxRefno' value=''>
		<input TYPE='hidden' name='inptAtmcBizDscd' value=''>
	</form>
</div>

<form id="formXls" method="get"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script>
$(function() {
	var today = getToDay();
	$('#radio_inptRcpDt2_search_<c:out value="${pageId}"/>').val(today);
	
	initLoadingDisplay("Y", "class", "container");
});

$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
});



 $('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
	var _row_index = $(this).closest('tr');	
	var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
	var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
	var _inptMstSrno = data['inptMstSrno'];
	var _actlFxRefno = data['actlFxRefno']; 
	var _aiInspAtvtStsCd = data['aiInspAtvtStsCd']; 
	var _inptAtmcBizDscd = data['bizDscd']; 
	console.log("1113232!!" + _inptAtmcBizDscd);
	var _bizDscd = data['bizDscd']; 
	
 		if(_aiInspAtvtStsCd == '10'){
			_inptMstSrno=0;
		}
		if(_inptMstSrno != null){
		 if (3 == _column_index) {
			 var formRevertHistory = $('#formRevertHistory')[0];
			formRevertHistory.inptMstSrno.value = _inptMstSrno;
			formRevertHistory.actlFxRefno.value = _actlFxRefno;
			formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
			fnHistoryWin(formRevertHistory);
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
	fnCmnProgramLog("4010",null,"02",$.param(searchOption));
	
	fnCmnDownXls($('#formXls'), '/api/revert/stat/all/xls', searchOption);
	
} 
 
 
var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/revert/stat/all',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-40' }, // No
			{ targets: 1, className: 'td-text-center td-text-60' }, // 생성일
			{ targets: 2, className: 'td-text-center td-text-40' }, // 업무
			{ targets: 3, className: 'td-text-left td-text-100' }, //REFNO
			{ targets: 4, className: 'td-text-center td-text-60' }, // 고객번호
			{ targets: 5, className: 'td-text-left td-text-120' }, // 고객명
			{ targets: 6, className: 'td-text-center td-text-40' }, // 통화
			{ targets: 7, className: 'td-text-right td-text-80' }, // 금액
			{ targets: 8, className: 'td-text-center td-text-60' }, // 생성구분
			{ targets: 9, className: 'td-text-center td-text-60' }, // 접수자
			{ targets: 10, className: 'td-text-left td-text-80' }, // 영업점명코드
			{ targets: 11, visible: false },
			{ targets: 12, visible: false },
			{ targets: 13, visible: false },
			{ targets: 14, className: 'td-text-center td-text-40'}
		],
		columns: [
			//{data: "inptRcpDt", title: '생성일'},
			{data: "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
			/*, render : function(data, type, row, meta){
				return dataFormat(data);
			}},*/
        	{data: "inptAtmcBizDsNm", title: '업무'},
        	{data: "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
        		if(row.inptMstSrno != null){
        			return '<b class="detailBtn">' + data + '</b>';
        		}else{
        			return data;
        		}
        	}},
        	{data: "aiInptCusNo", title: '고객번호'},
        	{data: "aiInptCusNm", title: '고객명'},
        	{data: "fcCuNm", title: '통화'},
        	{data: "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
        	{data: "aiInspAtvtStsNm", title: '생성구분'},
        	{data: "aiInptAtpeEno", title: '접수자'},
        	{data: "aiInptBzbrNm", title: '영업점명(코드)'},
        	{data: "inptMstSrno"},
        	{data: "aiInspAtvtStsCd"},
        	{data: "bizDscd"},
        	{data: "inptAtmcReqDscd", title: '상태', render : function(data, type, row, meta){
        		if(data == '1'){
        			return '정상';
        		}else if(data == '2'){
        			return '변경';
        		}else if(data == '3'){
        			return '취소';
        		}else{
        			return '기타';
        		}
        	}}
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	var page_id = '<c:out value="${pageId}"/>';
			var options = {};
			var filters = [];
			
			var actlFxRefno = $("#txt_actlFxRefno_Search_"+page_id).val();
			var aiInspAtvtStsCd = $("#cbo_aiInspAtvtStsCd_Search_"+page_id).val();
			var inptAtmcBizDscd = $("#cbo_inptAtmcBizDscd_Search_"+page_id).val();
			var aiInptCusNo = $("#txt_aiInptCusNo_Search_"+page_id).val();
			var inptRcpDt = $(':radio[name="inptRcpDt"]:checked').val();
			options.actlFxRefno = actlFxRefno;
			options.aiInspAtvtStsCd = aiInspAtvtStsCd;
			options.inptRcpDt = inptRcpDt;
			options.inptAtmcBizDscd = inptAtmcBizDscd;
			options.aiInptCusNo = aiInptCusNo;
			
			fnCmnProgramLog("4010",null,"01",$.param(options));
			
			return options;
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
	<jsp:param name="gridOptionScrollX" value="false" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="440" />
</jsp:include>
