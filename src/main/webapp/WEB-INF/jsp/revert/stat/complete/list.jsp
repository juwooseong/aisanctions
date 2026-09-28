<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="4030"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>심사완료명세 [4030]</strong>
		<span class="revertStatPageDiscription">심사 및 자체점검이 완료(승인, Block)된 목록을 조회하는 화면</span>
		<span class="location">
			<span>심사</span>
			<span>수출/수입심사현황</span>
			<span>심사완료명세</span>
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
					<select class="rvtCompleteSelect1" name="schGbn" id="cbo_inptAtmcBizNm_Search_<c:out value="${pageId}"/>">
						<option value="0102">수출+수입</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w26">
					<label for="cbo_inptAtvtNm_Search_${pageId}" class="label">완료구분</label>
					<select class="rvtCompleteSelect2" name="schGbn" id="cbo_inptAtvtNm_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList3 }">
						<c:if test="${item.aiInptCmnCd ne '90' && item.aiInptCmnCd ne '100' && item.aiInptCmnCd ne '120' && item.aiInptCmnCd ne '130' && item.aiInptCmnCd ne '150'}">
					 		<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:if> 
						</c:forEach>
					</select>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>" onclick="afterSchBtn();">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<p class="w24">
					<label for="txt_inptBizAlctCrpeEno_${pageId}" class="label">담당직원번호</label>
					<input type="text" class="it w52_v2" id="txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>" placeholder="직원번호 입력" maxlength="<c:out value="${maxLength_eno }"/>">
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
				<button type="button" class="retryLogEndBtnDisabled appvCancelTopBtn" id="appvCancel" onclick="appvCancel();" disabled="disabled">결재취소</button>
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
		
		$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").keydown(function(event) {
		/* 	if(event.keyCode ===8){
				$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val("")
			} */
			 if(event.keyCode ===13){
				$('#detailSanctionButton<c:out value="${pageId}"/>').trigger("click");
			} 
		}); 
		
		$(document).on('change', '.rvtCompleteSelect1', function(){
			if($(this).val() == '3'){
				$('.rvtCompleteSelect2').html('<option value="">전체</option>'+
											  '<option value="10">적정</option>'+
											  '<option value="20">비적정</option>');
			}else{
				$('.rvtCompleteSelect2').html('<option value="">전체</option>'+
						  					  '<option value="140">Block</option>'+
						  					  '<option value="160">승인</option>');
			}
		});
	});
	
	 function isCheck() {
		var value = document.getElementById("dateDisable");
		var startDateText = document.getElementById("cld_schSdate1_Search_<c:out value="${pageId}"/>");
		var endDateText = document.getElementById("cld_schEdate1_Search_<c:out value="${pageId}"/>");
		isChecked(value, startDateText, endDateText);
	} 
	
	function downXls<c:out value="${pageId}"/>(){
		if(<c:out value="${dataTableId}"/>.dataCount() < 1){
			alert('데이터가 존재하지 않습니다.');
			return;
		}
		
		var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
		
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("4030",null,"02",$.param(searchOption));
		
		fnCmnDownXls($('#formXls'), '/api/revert/stat/complete/xls', searchOption);
		
	}
	
	// 목록 자동새로고침
	$(document).on('click', '#autoRefreshBtn', function(e){
		
		// 이벤트 전파 제거
		e.stopPropagation();
		
		if($(this).hasClass('autoFalse')){
			
			//클릭후 1회 즉시 새로고침
			searchTableReloadNoPageChange();
			
			$(this).removeClass('autoFalse');
			$(this).addClass('autoTrue');
			$('.autoRefreshIcon').addClass('fa-spin');
			$('.autoRefreshIcon').removeClass('autoIconFalse');
			$('.autoRefreshIcon').addClass('autoIconTrue');
			listInterval = setInterval(function(){
				searchTableReloadNoPageChange();
			}, 3000);
		}else if($(this).hasClass('autoTrue')){
			$(this).removeClass('autoTrue');
			$(this).addClass('autoFalse');
			$(this).html('<i class="fa fa-refresh mt-4 autoRefreshIcon autoIconFalse" style="margin-right: 3px;"></i>목록 자동새로고침');
			/*
			$('.autoRefreshIcon').removeClass('fa-spin');
			$('.autoRefreshIcon').removeClass('autoIconTrue');
			$('.autoRefreshIcon').addClass('autoIconFalse');*/
			clearInterval(listInterval);
		}
		
	});
	
	$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
		//클릭한 td 컬럼 데이터 받기
		var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
		var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
		var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
		var _inptAtvtCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtvtCd'];
		var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
		
		var _inptRcpDt = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptRcpDt'];
		var _inptAtmcBizNm = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizNm'];
		
		var _bizCode = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['aiInptCmnCd'];
		var _totalTextRst = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['totaltextAiInptRstCd'];
		var _itmRst = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['itmInptAiInptRstCd'];
		var _safeWatchRst = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['safewatchAiInptRstCd'];
		
		var _processCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['aiInptQlasProsCd'];
		//var _inptRcpDt = data['inptRcpDt']; 
		//var _inptAtmcBizNm = data['inptAtmcBizNm'];
		appvCancelMstNo = _inptMstSrno;
		appvCancelBizCd = _bizCode;
		appvCancelTotalTextRst = _totalTextRst;
		appvCancelItmRst = _itmRst;
		appvCancelSafeWatchRst = _safeWatchRst;
		
		appvCancelBtnActive(_inptRcpDt, _inptAtmcBizNm, _totalTextRst, _itmRst, _safeWatchRst, _bizCode);
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
				
				// window.open("/common/history?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
			}else{
				var formHistoryQa = $('#formHistoryQa')[0];
				formHistoryQa.inptMstSrno.value = _inptMstSrno;
				formHistoryQa.actlFxRefno.value = _actlFxRefno;
				fnFullWin(formHistoryQa);
				
			//	window.open("/common/history/qa?inptMstSrno=" + _inptMstSrno + "&inptAtvtCd=" + _inptAtvtCd + "&actlFxRefno=" + _actlFxRefno, "심사상세 및 수기처리", "fullscreen=yes");
			}
		});
	
		$('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
		    var _row_index = $(this).closest('tr');	
			var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
			var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
			var _inptMstSrno = data['inptMstSrno'];
			var _inptAtvtCd = data['inptAtvtCd']; 
			var _aiInptCmnCd = data['aiInptCmnCd']; 
			var _actlFxRefno = data['actlFxRefno']; 
			var _inptAtmcBizDscd = data['aiInptCmnCd'];
			
			if (5 == _column_index) {
				if (1 == _aiInptCmnCd || 2 == _aiInptCmnCd) {
					
					var formRevertHistory = $('#formRevertHistory')[0];
					formRevertHistory.inptMstSrno.value = _inptMstSrno;
					formRevertHistory.actlFxRefno.value = _actlFxRefno;
					formRevertHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
					fnHistoryWin(formRevertHistory);
					
					/* var w = window.open("/common/revert/history?inptMstSrno=" + _inptMstSrno + "&actlFxRefno=" + _actlFxRefno, "심사이력 [9080]", "resizable=1, scrollbars=1");
					setTimeout(function(){
						w.document.title = _actlFxRefno;
					}, 1000); */
					
				} else if (3 == _aiInptCmnCd) {
					
					var formQaHistory = $('#formQaHistory')[0];
					formQaHistory.inptMstSrno.value = _inptMstSrno;
					formQaHistory.actlFxRefno.value = _actlFxRefno;
					formQaHistory.inptAtmcBizDscd.value = _inptAtmcBizDscd;
					fnHistoryWin(formQaHistory);
					
					/* var w = window.open("/common/qa/history?inptMstSrno=" + _inptMstSrno + "&actlFxRefno=" + _actlFxRefno, "QA이력 [9090]", "resizable=1, scrollbars=1");
					setTimeout(function(){
						w.document.title = _actlFxRefno;
					}, 1000); */
				}
			}
		});  
	 
var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/revert/stat/complete',
		columnDefs: [

			{ targets: 0, className: 'td-text-center td-text-40' }, // NO
			{ targets: 1, className: 'td-text-center td-text-60' }, // 생성일
			{ targets: 2, className: 'td-text-center td-text-40' }, // 업무
			
			{ targets: 3, className: 'td-text-left td-text-80' }, // 프로세스
			
			{ targets: 4, className: 'td-text-center td-text-40' }, // 완료구분
			{ targets: 5, className: 'td-text-left td-text-120' }, // REFNO
			{ targets: 6, className: 'td-text-center td-text-60' }, // 고객번호
			{ targets: 7, className: 'td-text-left td-text-120' }, // 고객명
			{ targets: 8, className: 'td-text-center td-text-40' }, // 통화
			{ targets: 9, className: 'td-text-right td-text-80' }, // 금액
			{ targets: 10, className: 'td-text-center td-text-50' }, // s1
			{ targets: 11, className: 'td-text-center td-text-50' }, // s2
			
			{ targets: 12, className: 'td-text-center td-text-50' }, // QA1
			{ targets: 13, className: 'td-text-center td-text-50' }, // QA2
			
			{ targets: 14, className: 'td-text-left td-text-100' }, // 접수자명
			{ targets: 15, className: 'td-text-left td-text-100' }, // 스캔자명
			
			{ targets: 16, className: 'td-text-left td-text-120' }, // 영업점명(코드)
			
			{ targets: 17, className: 'td-text-center td-text-60' }, // totaltext
			{ targets: 18, className: 'td-text-center td-text-60' }, // 항목심사
			{ targets: 19, className: 'td-text-center td-text-60' }, // s/w
			{ targets: 20, visible: false }, // 적정 비적정
			{ targets: 21, className: 'td-text-center td-text-30' }, // 상세보기
			{ targets: 22, visible: false },
			{ targets: 23, visible: false },
			{ targets: 24, visible: false },
			{ targets: 25, visible: false },
			{ targets: 26, visible: false }, // 영업점코드
			{ targets: 27, visible: false },  // 엑셀
			{ targets: 28, visible: false },  // 접수자ID*/
			{ targets: 29, visible: false } // 스캔자ID*/
		],
		columns: [
			{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
        	{"data": "inptAtmcBizNm", title: '업무'},
        	
        	{"data": "aiInptQlasProsCd", title: '프로세스'},
        	
        	{"data": "aiInptBizNm", title: '구분', render: function(data, type, row, meta){
        		if(row.aiInptCmnCd == '3'){
        			return row.qarstNm;
        		}else{
        			return data;
        		}
        	}},
        	{"data": "actlFxRefno", title: 'Ref.No', render : function(data, type, row, meta){
        		return '<b class="detailBtn">' + data + '</b>'
        	}},
        	{"data": "aiInptCusNo", title: '고객번호'},
        	{"data": "aiInptCusNm", title: '고객명'},
        	{"data": "fcCuNm", title: '통화'},
        	{"data": "aiInptBuyAm", title: '금액', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
        	{"data": "s1User", title: 'S1'},
        	{"data": "s2User", title: 'S2'},
        	
        	{"data": "s1UserQa", title: 'QA1', render: function(data, type, row, meta){
        		if(row.aiInptCmnCd == '3'){
        			return data;
        		}else{
        			return " ";
        		}
        	}},
        	{"data": "s2UserQa", title: 'QA2', render: function(data, type, row, meta){
        		if(row.aiInptCmnCd == '3'){
        			return data;
        		}else{
        			return " ";
        		}
        	}},
        	{"data": "trnOprNoEr", title: '접수자' , render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.trnOprNo != null){rstStr += '('+row.trnOprNo+')'; }
        		return rstStr;
        	}},
        	{"data": "aiInptDocScanChrgEnoEr", title: '스캔자' , render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.aiInptDocScanChrgEno != null){ rstStr += '('+row.aiInptDocScanChrgEno+')'; }
        		return rstStr;
        	}},
        	{"data": "krbrNm", title: '영업점명' , render: function(data, type, row, meta){
        		var rstStr = "";
        		if(data != null){ rstStr += data; }
        		if(row.daccBrcd != null){ rstStr += '('+row.daccBrcd+')'; }
        		return rstStr;
        	}}, // 영업점명
        	
        	{"data": "totaltextAiInptRstNm", title: 'TotalText'},
        	{"data": "itmInptAiInptRstNm", title: '항목심사'},
        	{"data": "safewatchAiInptRstNm", title: 'S/W'},
        	{"data": "qarstNm"},
        	{"title": '상세', "render":function(){
        		return '<button type="button" class="btn btn-primary m-1 p-1 viewDetailBtn" data-toggle="modal">'+
				'<i class="fa fa-search fa-lg"></i>'+
				'</button>';
        	}},
        	{"data": "aiInptCmnCd" },
        	{"data": "totaltextAiInptRstCd" },
        	{"data": "itmInptAiInptRstCd" },
        	{"data": "safewatchAiInptRstCd" },
        	{"data": "daccBrcd" },
        	{"data": "completeBizNmXls" },
        	{"data": "trnOprNo" }, // 접수자ID
        	{"data": "aiInptDocScanChrgEno" } // 스캔자ID
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
			var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
			
			var inptAtvtCd = $("#cbo_inptAtvtNm_Search_"+page_id).val(); //완료구분
			
			var actlFxRefno = $("#txt_actlFxRefno_Search_"+page_id).val(); // 번호
			var inptAtmcBizId = $("#cbo_inptAtmcBizNm_Search_"+page_id).val(); // 업무
			var inptBizAlctCrpeEno = $("#txt_inptBizAlctCrpeEno_"+page_id).val(); // 담당자 번호 
			var inptBizAlctCrpeAuth = $("#cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>").val(); // 담당자 권한
			var inptRcpDt = $(':radio[name="inptRcpDt"]:checked').val();
			var aiInptCusNo = $("#txt_aiInptCusNo_Search_<c:out value="${pageId}"/>").val();
			
			options.actlFxRefno = actlFxRefno;
			options.aiInptCusNo = aiInptCusNo;
			options.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
			options.inptAtvtCd = inptAtvtCd;
			options.inptRcpDt = inptRcpDt;
			options.aiInptCmnCd = inptAtmcBizId;
			options.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
			options.schSdate1 = schSdate1;
			options.schEdate1 = schEdate1;
			options.inptBizAlctCrpeAuth = inptBizAlctCrpeAuth;
			
			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("4030",null,"01",$.param(options));
			
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
			
			$(nRow).find('td:eq(17)').css('color', totaltextAiInptRstColor);
			$(nRow).find('td:eq(18)').css('color', itmInptAiInptRstColor);
			$(nRow).find('td:eq(19)').css('color', safewatchAiInptRstColor);
			
			/*
			if(aData['aiInptQlasProsCd'] == '1'){
				$(nRow).find('td:eq(3)').html("수입 선적서류 제재심사");
				$(nRow).find('td:eq(3)').attr("title", "수입 선적서류 제재심사");
			}else if(aData['aiInptQlasProsCd'] == '2'){
				$(nRow).find('td:eq(3)').html("수출 선적서류 제재심사");
				$(nRow).find('td:eq(3)').attr("title", "수출 선적서류 제재심사");
			}else if(aData['aiInptQlasProsCd'] == '3'){
				$(nRow).find('td:eq(3)').html("자체점검(QA)-TotalText");
				$(nRow).find('td:eq(3)').attr("title", "자체점검(QA)-TotalText");
			}else if(aData['aiInptQlasProsCd'] == '4'){
				$(nRow).find('td:eq(3)').html("자체점검(QA)-항목심사");
				$(nRow).find('td:eq(3)').attr("title", "자체점검(QA)-항목심사");
			}else if(aData['aiInptQlasProsCd'] == '5'){
				$(nRow).find('td:eq(3)').html("자체점검(QA)-SafeWatch");
				$(nRow).find('td:eq(3)').attr("title", "자체점검(QA)-SafeWatch");
			}*/
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
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	
};

var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){
	

};

</script>
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 조회" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>
<script>
function modalUserListTable<c:out value="${pageId}"/>_selectCallback(e, dt, type, index, row){
}

function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	if(row.aiInptUserEno != null){
		$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val(row.aiInptUserEno);
		$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val(row.aiInptUserEno);
	}
}
/*
$(function(){
	modalUserListTable<c:out value ="${pageId}"/>_data.userName = 'schUserNm';
	modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>';
	modalUserListTable<c:out value ="${pageId}"/>_data.userNoId = 'txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>';
});*/

function chang(){
	$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val("");
}

function appvCancelBtnActive(dateStr, biz, totalTextRst, itmRst, safeWatchRst, bizCode){
	var authSessData = JSON.parse(sessionStorage.getItem('auth_data'));
	var loginAuth = authSessData.auth;
	var loginAdmin = authSessData.admin_yn;
	
	// 권한체크
	if(loginAuth == "02" && loginAdmin == "Y"){
		$('#appvCancel').attr('disabled', false);
		$('#appvCancel').removeClass('retryLogEndBtnDisabled');
		$('#appvCancel').addClass('btType1');
		
	}else{
		$('#appvCancel').attr('disabled', true);
		
		$('#appvCancel').removeClass('btType1');
		$('#appvCancel').addClass('retryLogEndBtnDisabled');
		return;
	}
	
	// 업무구분 체크
	if(bizCode != "3"){
		$('#appvCancel').attr('disabled', false);
		$('#appvCancel').removeClass('retryLogEndBtnDisabled');
		$('#appvCancel').addClass('btType1');
		
	}else{
		$('#appvCancel').attr('disabled', true);
		$('#appvCancel').removeClass('btType1');
		$('#appvCancel').addClass('retryLogEndBtnDisabled');
		return;
	}
	
	// 날짜체크
	var calElementValueConvt = dateStr;
	var todayString = new Date().getFullYear() + "" + (new Date().getMonth()+1 >= 10 ? new Date().getMonth()+1 : '0' + (new Date().getMonth()+1)) + (new Date().getDate() >= 10 ? new Date().getDate() : '0' + new Date().getDate());
	
	if(calElementValueConvt == todayString){  
		$('#appvCancel').attr('disabled', false);
		$('#appvCancel').removeClass('retryLogEndBtnDisabled');
		$('#appvCancel').addClass('btType1');
		
	}else if(calElementValueConvt != todayString){
		$('#appvCancel').attr('disabled', true);
		$('#appvCancel').removeClass('btType1');
		$('#appvCancel').addClass('retryLogEndBtnDisabled');
		return;
	}
}

function searchTableReload(){
	<c:out value="${dataTableId}"/>.searchList();
}

function searchTableReloadNoPageChange(){
	<c:out value="${dataTableId}"/>.searchListCurrentPage();
}

function appvCancel(){
	
	var selRows = <c:out value="${dataTableId}"/>.getSelRows();
	if(selRows.length == 0){
		alert("결재취소 할 건을 선택해주세요.");
		return;
	}
	
	if(confirm("해당 완료건을 결재 취소 하시겠습니까?")){
		var param = {
				inptMstSrno : appvCancelMstNo,
				aiInptBizDscd : appvCancelBizCd,
				mstTotaltextAiInptRstCd : appvCancelTotalTextRst,
				mstInptItmAiInptRstCd : appvCancelItmRst,
				
				aiInptCnctScrnNo : "4030",
				aiInptCnctActiCd : "29",
				aiInptCnctParmTxt : "inptMstSrno="+appvCancelMstNo
			};
		
		$.post('/api/common/revertDetail/cancelApprv', param, function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				$('#appvCancel').attr('disabled', true);
				$('#appvCancel').removeClass('btType1');
				$('#appvCancel').addClass('retryLogEndBtnDisabled');
				searchTableReload();	
			}
			
			/*
			if(callbackFunc){
				callbackFunc(data);
			}*/
		});
	}
}

function afterSchBtn(){
	$('#appvCancel').attr('disabled', true);
	$('#appvCancel').removeClass('btType1');
	$('#appvCancel').addClass('retryLogEndBtnDisabled');
}
</script>