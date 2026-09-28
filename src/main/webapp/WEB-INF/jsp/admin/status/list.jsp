<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="8050"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">

	<div class="" id="adminStatusRegInput">
	    <span class="adminStatusRegContentWrapper">
	    <i class="fa fa-lock fa-lg mt-4"></i>
		    재처리 정보등록을 위한 추가정보가 필요합니다
		</span>
	    <span class="adminStatusRegContents">
	    	<input type="password" id="adminStatusRegPwd" />
	    	<button type="button" id="adminStatusRegConfirm">확인</button>
	    </span>
	</div>
	<div id="adminStatusRegBackground"></div>

	<h2 class="title">
		<strong>시스템심사진행현황 [8050]</strong>
		<span class="revertStatPageDiscription"></span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>시스템심사진행현황</span>
		</span>
	</h2>
	
	<div class="tbWrap adminQAwrap" style="margin-bottom: 10px;">
			<span class="adminQAspan">※ 이미지스캔 신규 건과 재스캔 건을 삭제하는 경우 해당 건에 대한 모든 정보가 삭제됩니다. 반드시 BPR 에서 이미지 재전송 처리 하시기 바랍니다.</span>
	</div>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
			<%--
			<span class="" id="reProcInfoRegBtn" style="float: right;box-sizing: border-box;padding: 10px;font-size: 12px;cursor: pointer;">
			<i class="fa fa-code fa-lg mt-4 autoRefreshIcon"></i>
			재처리 정보등록</span> --%>
			<%--
			<span class="autoRefreshBtn autoFalse" id="autoRefreshBtn">
				<i class="fa fa-refresh mt-4 autoRefreshIcon autoIconFalse"></i>
				목록 자동새로고침
			</span>
			 --%>
			
		</div>
		<div class="searchBox">
			<form action="">
			
				<p class="w30">
					<span class="label">업무생성일</span>
					<label for="radio_total_Search_<c:out value="${pageId}"/>" id="rsIndx3" class="group2 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio"  value="" name="aiInptRcpDtCustom" id="radio_total_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_total_Search_<c:out value="${pageId}"/>" id="group2" class="radioSelectorLabel rsIndx3">전체</label>
					
					<label for="radio_day_Search_<c:out value="${pageId}"/>" id="rsIndx4" class="group2 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio" value="1" checked="checked" name="aiInptRcpDtCustom" id="radio_day_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_day_Search_<c:out value="${pageId}"/>" id="group2" class="radioSelectorLabel rsIndx4">당일</label>
				</p>
			
				<p class="w30">
					<label for="cbo_aiSysInptPrgStcd_Search_${pageId}" class="label">심사진행상태</label>
					<select class="" name="schGbn" id="cbo_aiSysInptPrgStcd_Search_<c:out value="${pageId}"/>">
						<option value="">전체</option>
						<c:forEach var="item" items="${processCdList }" varStatus="status">
							<option value="${item.aiInptCmnCd }"><c:out value="${item.aiInptCmnCdNm }"/></option>
						</c:forEach>
					</select>
				</p>
				<p class="w26">
					<label for="schRefNo_Search_${pageId}" class="label">Ref.No</label>
					<input type="text" class="it" id="schRefNo_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_refno }"/>">
				</p>
				
				<p class="w30">
					<span class="label">처리구분</span>
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="rsIndx1" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio"  value="" checked="checked" name="aiInptPrcDscd" id="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt1_Search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx1">전체</label>
					
					<label for="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" id="rsIndx2" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio" value="1" name="aiInptPrcDscd" id="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" style="display:none;">
					<label for="radio_inptRcpDt_Search_<c:out value="${pageId}"/>" id="group1" class="radioSelectorLabel rsIndx2">(재)심사 제외</label>
				</p>
				<p class="w30">
					<label for="schAiInptSvrInfTxt" class="label">수행서버</label>
					<input type="text" class="it" id="schAiInptSvrInfTxt">
				</p>
				
				<p class="w26">
					<label for="aiInptProcTime_Search_${pageId}" class="label">경과시간(분)</label>
					<input type="text" class="it" id="aiInptProcTime_Search_<c:out value="${pageId}"/>" maxlength="<c:out value="${maxLength_refno }"/>">
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
				<div class="grid-process-wrapper">
					<span class="grid-process-cta-wrapper">
						<span class="grid-process-contents grid-process-cta-content-2" style="display:inline-block;">
							<span style="font-size: 12px;margin-right: 10px;">액티비티 강제변경</span>
							<select class="grid-process-select" id="chgAcvtSelect">
								<option value="80">수기심사대상</option>
								<option value="90">심사결과검토</option>
							</select>
							<button type="button" class="gridFunctionBtn acvtChgBtnDeactive" id="statusModBtn" disabled="disabled">변경</button>
							<%--<button type="button" class="" id="reProcInfoRegBtn">재처리 정보등록</button> --%>
						</span>
					</span>
				</div>
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>		
		</div>
	</div>
</div>

<div style="margin-left: 15px;">
	<span style="color: #222;font-size: 12px;">업무생성일</span>
	<input type="text" readonly class="cal daterange-basic calSingle" name="performDate" id="performDate" pageid="<c:out value="${pageId}"/>" style="width: 90px;height: 25px;text-align: center;">
	<button type="button" class="performXlsDownBtn" id="xlsDownSet_1">심사결과분석(세트별)</button>
	<button type="button" class="performXlsDownBtn" id="xlsDownSet_2">심사결과분석(항목별)</button>
	<button type="button" class="performXlsDownBtn" id="xlsDownSet_3" style="width: 130px;">처리성능 분석</button>
	<button type="button" class="performXlsDownBtn" id="xlsDownSet_4" style="width: 150px;">심사수기등록 현황</button>
</div>

<form id="formXls" method="get"></form>

<form id="formadminStatusReg" action='/admin/status/reg' method='POST' target='adminStatusReg'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
</form>

 
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
<form id="formParamData" style="position: absolute;opacity: 1;"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>


$(function() {
	initLoadingDisplay("Y", "class", "container");
	
	$(document).on('change', '.grid-process-radio', function(){
		var myClassName = $(this).attr("class");
		var myValue = $(this).val();
		
		$('.grid-process-contents').css('display','none');
		$('.grid-process-cta-content-'+myValue).css('display','inline-block');
	})
	
	// 엑셀다운로드 임시
	$(document).on('click', '.performXlsDownBtn', function(){
		//console.log("임시 테스트");
		
		var urlKey = $(this).attr('id');
		var urlMapper = {
				'xlsDownSet_1' : '/api/inpt/result/analy/xls/ref',
				'xlsDownSet_2' : '/api/inpt/result/analy/xls/category',
				'xlsDownSet_3' : '/api/inpt/result/analy/xls/performance',
				'xlsDownSet_4' : '/api/inpt/result/analy/xls/sugi'
		}
		var urlValue = urlMapper[urlKey];
		
		console.log('mapping url: ', urlValue);
		
		var searchOption = {};
		searchOption.schSdate = $("#performDate").val().replace('-', '').replace('-', '');
		
		console.log("substr result2: ", searchOption.schSdate);
		
		fnCmnDownXls($('#formXls'), urlValue, searchOption);
	});
	
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
			$(this).html('<i class="fa fa-refresh mt-4 autoRefreshIcon autoIconFalse" style="margin-right: 3px;"></i>목록 자동새로고침'); // FOR IE
			/*
			$('.autoRefreshIcon').removeClass('fa-spin');
			$('.autoRefreshIcon').removeClass('autoIconTrue');
			$('.autoRefreshIcon').addClass('autoIconFalse');*/
			clearInterval(listInterval);
		}
		
	});
	
	$(document).on('click', '#adminStatusRegBackground', function(){
		$(this).css('display', 'none');
		$('#adminStatusRegInput').css('display', 'none');
	});
	
	// 재처리 정보등록(구)
	$(document).on('click', '#reProcInfoRegBtn', function(e){
		
		// 이벤트 전파 제거
		e.stopPropagation();
		
		$('#adminStatusRegBackground').css('display', 'block');
		$('#adminStatusRegInput').css('display', 'block');
		$('#adminStatusRegPwd').val("");
		$('#adminStatusRegPwd').focus();
	});
	
	//console
	$(document).keydown(function(e){
		if (e.shiftKey && e.keyCode == "49") {
			console.log("render key");
			
			$('#adminStatusRegBackground').css('display', 'block');
			$('#adminStatusRegInput').css('display', 'block');
			$('#adminStatusRegPwd').focus();
			$('#adminStatusRegPwd').val("");
		}
	});
	
	// P KEYUP
	$('#adminStatusRegPwd').keyup(function(e) {
		if(e.keyCode === 13) {
			$('#adminStatusRegConfirm').click();
		}
	});
	
	// P CONFIRM
	$(document).on('click', '#adminStatusRegConfirm', function(){
		console.log('confirm!!');
		var regPwd = $('#adminStatusRegPwd').val();
		
		var param = {};
		// FOR 900 UPDATE
		param.aiInptUserYn = regPwd;

		$.post('/api/admin/status/reg/confirm', param, function(data){
			if(data.rst == 'success'){
				$('#adminStatusRegBackground').css('display', 'none');
				$('#adminStatusRegInput').css('display', 'none');
				
				var formadminStatusReg = $('#formadminStatusReg')[0];
				var winName = formadminStatusReg.target;
				var selectedMstSrno = null;
				
				var selRows = <c:out value="${dataTableId}"/>.getSelRows();
				if(selRows.length == 0){
					selectedMstSrno = '';
					console.log(selectedMstSrno);
				}else{
					console.log(selRows[0].inptMstSrno);
				}
				
				// 창 가운데정렬추가 #2(듀얼모니터 체크)
				var popupSizeW = "1100";
				var popupSizeH = "800";
				
				var curX = window.screenLeft;
				var curY = window.screenTop;
				
				var clientW = document.body.clientWidth;
				var clientH = document.body.clientHeight;
				
				var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
				var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
				
				window.open('about:blank', winName, 'left='+resultLeft+', top='+resultTop+', width=1100, height=950, resizable=1, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
				
				formadminStatusReg.submit();
			}else{
				$('#adminStatusRegPwd').val("");
				$('#adminStatusRegPwd').focus();
			}
		});
	});
	
	// 심사상세 window
	$('#<c:out value="${dataTableId}"/>').on('click', 'td', function() {
	
		if (!checkLogin()) {
			fnLoginAlert();
			return false;
		}
		
		//클릭한 td 컬럼 데이터 받기
		var _row_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['row'];
		var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
		var _inptMstSrno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptMstSrno'];
		var _inptAtvtCd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['aiInptAcvtCd'];
		var _inptAtmcBizDscd = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['inptAtmcBizDscd'];
		var _actlFxRefno = <c:out value="${dataTableId}"/>listTable.data()[_row_index]['actlFxRefno'];
	
		if (3 == _column_index && _inptAtvtCd != '20') {
			
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
	
	// 이력 window
	$('#<c:out value="${dataTableId}"/>').on('dblclick', 'td', function() {
		    var _row_index = $(this).closest('tr');	
			var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
			var _column_index = <c:out value="${dataTableId}"/>listTable.cell(this).index()['column'];
			var _inptMstSrno = data['inptMstSrno'];
			var _inptAtvtCd = data['aiInptAcvtCd']; 
			var _aiInptCmnCd = data['inptAtmcBizDscd']; 
			var _actlFxRefno = data['actlFxRefno']; 
			var _inptAtmcBizDscd = data['inptAtmcBizDscd'];
			
			if (2 == _column_index) {
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
	// 재처리(재처리버튼)
	$('#<c:out value="${dataTableId}"/>').on('click', '#reProcBtn', function(){
		var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _inptMstSrno = data['inptMstSrno'];
		var _inptAtvtCd = data['aiInptAcvtCd'];
		var _aiInptPrcDscd = data['aiInptPrcDscd'];
		var _aiInptBizDscd = data['inptAtmcBizDscd'];
		var _aiInptAppvSrno = data['aiInptAppvStcd'];
		var _aiSysInptPrgStcd = data['aiSysInptPrgStcd'];
		
		// 재처리 룰
		// 1 정상   2 재추출   3 (재)심사   4 재분류
		if(_aiInptPrcDscd == '1' || _aiInptPrcDscd == '4'){
			// 1) 정상(1), 재분류(4) 인 경우 심사진행상태코드 01번 update 처리횟수 update	
			
			if(Number(_aiSysInptPrgStcd) >= 17){
				// 정상(1), 재분류(4) 이면서 심사상태코드가 17 보다 크면 15 로직
				console.log("1-4:15");
				if(confirm("해당 건을 회전각도 추출완료 상태로 재처리 하시겠습니까?")){
					var param = {};
					// FOR 900 UPDATE
					param.inptMstSrno = _inptMstSrno;
					//param.aiSysInptPrgStcd = "01"; // 01이미지입수(01/16 이후 수정) 
					param.aiSysInptPrgStcd = "15"; // 15회전각도 추출완료
					param.aiInptPrcDscd = "4";
					
					// FOR LOG
					param.aiInptCnctParmTxt = $.param(param);
					param.aiInptCnctScrnNo = "8050";
					param.aiInptCnctActiCd = "12";

					$.post('/api/admin/status/reprocess', param, function(data){
						if(data.rst == 'success'){
							alert('정상적으로 처리되었습니다.');
							searchTableReload();	
						}
					});
				}
				
			}else if(Number(_aiSysInptPrgStcd) < 17){
				//alert("해당 상태코드에 대한 재처리는 추가 반영 예정입니다.");
				// 정상(1), 재분류(4) 이면서 심사상태코드가 15보다 작으면  01 로직
				console.log("1-4:01");
				if(confirm("해당 건을 이미지입수 상태로 재처리 하시겠습니까?")){
					var param = {};
					// FOR 900 UPDATE
					param.inptMstSrno = _inptMstSrno;
					param.aiSysInptPrgStcd = "01"; // 01이미지입수(01/16 이후 수정) 
					//param.aiSysInptPrgStcd = "15"; // 15회전각도 추출완료
					param.aiInptPrcDscd = "4";
					
					// FOR LOG
					param.aiInptCnctParmTxt = $.param(param);
					param.aiInptCnctScrnNo = "8050";
					param.aiInptCnctActiCd = "12";

					$.post('/api/admin/status/reprocess', param, function(data){
						if(data.rst == 'success'){
							alert('정상적으로 처리되었습니다.');
							searchTableReload();	
						}
					});
				}
			}
			
		}else if(_aiInptPrcDscd == '2'){
			// 2) 재추출(2)         인 경우 심사진행상태코드 15번 update 처리횟수 update	
			if(confirm("해당 건을 회전각도 추출완료 상태로 재처리 하시겠습니까?")){
				var param = {};
				// FOR 900 UPDATE
				param.inptMstSrno = _inptMstSrno;
				param.aiSysInptPrgStcd = "15"; // 15회전각도 추출완료
				param.aiInptPrcDscd = "2";
				
				// FOR LOG
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8050";
				param.aiInptCnctActiCd = "12";

				$.post('/api/admin/status/reprocess', param, function(data){
					if(data.rst == 'success'){
						alert('정상적으로 처리되었습니다.');
						searchTableReload();	
					}
				});
			}
		}else if(_aiInptPrcDscd == '3'){
			// 3) 재심사(3)         인 경우 액티비티에 따라 재추출, 심사 로직 수행 
			if(_inptAtvtCd == '30' || _inptAtvtCd == '40'){
				
				if(confirm("해당건에 대해 재추출을 수행하시겠습니까?")){
					
					// 재추출
					var _params = new Object();
					// 재추출 파라미터
					_params.inptMstSrno = _inptMstSrno;
					_params.aiInptAcvtCd = _inptAtvtCd;

					// 프로그램 사용 이력 로그누적 파라미터
					_params.aiInptCnctScrnNo = "8050";
					_params.aiInptCnctFldCd = null;
					_params.aiInptCnctActiCd = "13";
					_params.aiInptCnctParmTxt = $.param({inptMstSrno : _inptMstSrno});

					$.ajax({
						url : "/api/admin/status/extraction",
						type : "post",
						cashe : false,
						data : { jData: JSON.stringify(_params) },			
						dataType: "json",
						global: false,
						success : function(data) {
							alert('재추출을 시작합니다.');
							searchTableReload();
						},
						error : function(e) {
							alert('재추출 오류');
						},
						complete: function() {
							// 수행 후 로직
						}
					});
				}
				
				
			}else if(_inptAtvtCd == '50' || _inptAtvtCd == '60' || _inptAtvtCd == '70'){
				
				if(confirm("해당 건에 대해 심사를 진행하시겠습니까?")){
					
					var _params = new Object();
					// 심사 파라미터
					_params.inptMstSrno = _inptMstSrno.toString();
					_params.aiInptAcvtCd = _inptAtvtCd;
					
					
					_params.aiInptAppvSrno = "50"; // 현재상태의 001 결재진행상태코드
					_params.aiInptBizDscd = _aiInptBizDscd; // 수출수입
					//_params.aiInptPrcOpiTxt = ""; // 
					_params.inptBlGrpNo = "1"; // B/L GROUP NUMBER
					

					
					_params.inspectionType = "status";

					// 프로그램 사용 이력 로그누적 파라미터
					_params.aiInptCnctScrnNo = "8050";
					_params.aiInptCnctFldCd = null;
					_params.aiInptCnctActiCd = "13";
					_params.aiInptCnctParmTxt = $.param({inptMstSrno : _inptMstSrno});

					$.ajax({
						url : "/api/admin/status/inspection",
						type : "post",
						cashe : false,
						data : { jData: JSON.stringify(_params) },			
						dataType: "json",
						global: false,
						success : function(data) {
							alert('심사를 시작합니다.');
							searchTableReload();
						},
						error : function(e) {
							alert('심사 오류');
						},
						complete: function() {
							// 수행 후 로직
						}
					});
				}
			}
		}
	});
	// 재처리(삭제버튼)
	$('#<c:out value="${dataTableId}"/>').on('click', '#deleteProcBtn', function(){
		var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _inptMstSrno = data['inptMstSrno'];
		var _inptAtvtCd = data['aiInptAcvtCd'];
		
		if(confirm("해당 심사마스터가 삭제됩니다.\n반드시 BPR 에서 이미지 재전송 처리하시기 바랍니다.")){
			if(confirm("해당 심사건을 삭제하시겠습니까?")){
				var param = {};
				
				// FOR 001 002 008 900 DELETE
				param.inptMstSrno = _inptMstSrno;
				
				// FOR LOG
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8050";
				param.aiInptCnctActiCd = "06";
				
				$.post('/api/admin/status/delete', param, function(data){
					if(data.rst == 'success'){
						alert('정상적으로 처리되었습니다.');
						searchTableReload();	
					}
				});
			}
		}
	});
	// 변경(액티비티 강제변경)
	$(document).on('click', '#statusModBtn', function(){
		var selRows = <c:out value="${dataTableId}"/>.getSelRows();
		if(selRows.length == 0){
			alert("액티비티 변경 할 건을 선택해주세요.");
			return;
		}
		
		var masterCode = selRows[0].inptMstSrno;
		var activityCode = selRows[0].aiInptAcvtCd;
		var statusCode = selRows[0].aiSysInptPrgStcd;
		var chgAcvtSelectCode = $("#chgAcvtSelect").val();
		var inptAtmcBizDscd = selRows[0].inptAtmcBizDscd;
		
		// 아래 조건 0226 이후로 사용하지 않음(주석처리), 두경우 모두 이미지 스캔, 이미지 재스캔일때만 변경할 수 없음
		// ● 수기심사대상은 해당 건의 액티비티코드(AI_INPT_ACVT_CD) 를 80 으로 UPDATE(FROM 001TM)
		// ● 이력을 INSERT(INTO 008TH) AI_INPT_ACVT_CD = 80 AI_INPT_ACVT_STS_CD = 50
		// ▶ 수기심사대상 은 액티비티 코드가 20, 21 이 아니면 가능
		
		// ● 심사결과검토는 해당 건의 액티비티코드(AI_INPT_ACVT_CD) 를 90 으로 UPDATE(FROM 001TM)
		// ● 이력을 INSERT(INTO 008TH) AI_INPT_ACVT_CD = 90 AI_INPT_ACVT_STS_CD = 50
		// ▶ 심사결과검토 은 액티비티 코드가 20, 21, 30, 50, 60 이 아니면 가능 
		
		// 변경 가능 체크
		if(chgAcvtSelectCode == "80"){
			if(confirm("해당 건을 수기심사대상 액티비티로 변경하시겠습니까?")){
				var param = {};
				// FOR 001 UPDATE
				param.inptMstSrno = masterCode;
				param.aiInptAcvtCd = chgAcvtSelectCode;
				
				// FOR 008 INSERT
				param.inptAtmcBizDscd = inptAtmcBizDscd;
				param.aiSysInptPrgStcd = "50"; // 대기상태
				
				// FOR LOG
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8050";
				param.aiInptCnctActiCd = "12";

				$.post('/api/admin/status/activty/mod', param, function(data){
					if(data.rst == 'success'){
						alert('정상적으로 처리되었습니다.');
						searchTableReload();	
					}
				});
			}
			/*
			if(activityCode == "20" || activityCode == "21"){
				alert("해당 건은 수기심사대상 액티비티로 변경할 수 없습니다.");
				return;
			}else{
				if(confirm("해당 건을 수기심사대상 액티비티로 변경하시겠습니까?")){
					var param = {};
					// FOR 001 UPDATE
					param.inptMstSrno = masterCode;
					param.aiInptAcvtCd = chgAcvtSelectCode;
					
					// FOR 008 INSERT
					param.inptAtmcBizDscd = inptAtmcBizDscd;
					param.aiSysInptPrgStcd = "50"; // 대기상태
					
					// FOR LOG
					param.aiInptCnctParmTxt = $.param(param);
					param.aiInptCnctScrnNo = "8050";
					param.aiInptCnctActiCd = "12";

					$.post('/api/admin/status/activty/mod', param, function(data){
						if(data.rst == 'success'){
							alert('정상적으로 처리되었습니다.');
							searchTableReload();	
						}
					});
				}
			} */
		}else if(chgAcvtSelectCode = "90"){
			if(confirm("해당 건을 심사결과검토 액티비티로 변경하시겠습니까?")){
				var param = {};
				// FOR 001 UPDATE
				param.inptMstSrno = masterCode;
				param.aiInptAcvtCd = chgAcvtSelectCode;
				
				// FOR 008 INSERT
				param.inptAtmcBizDscd = inptAtmcBizDscd;
				param.aiSysInptPrgStcd = "50"; // 대기상태
				
				// FOR LOG
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8050";
				param.aiInptCnctActiCd = "12";

				$.post('/api/admin/status/activty/mod', param, function(data){
					if(data.rst == 'success'){
						alert('정상적으로 처리되었습니다.');
						searchTableReload();	
					}
				});
			}
		}
			/*
			if(activityCode == "20" || activityCode == "21"){
				alert("해당 건은 심사결과검토 액티비티로 변경할 수 없습니다.");
				return;
			}else{
				if(confirm("해당 건을 심사결과검토 액티비티로 변경하시겠습니까?")){
					var param = {};
					// FOR 001 UPDATE
					param.inptMstSrno = masterCode;
					param.aiInptAcvtCd = chgAcvtSelectCode;
					
					// FOR 008 INSERT
					param.inptAtmcBizDscd = inptAtmcBizDscd;
					param.aiSysInptPrgStcd = "50"; // 대기상태
					
					// FOR LOG
					param.aiInptCnctParmTxt = $.param(param);
					param.aiInptCnctScrnNo = "8050";
					param.aiInptCnctActiCd = "12";

					$.post('/api/admin/status/activty/mod', param, function(data){
						if(data.rst == 'success'){
							alert('정상적으로 처리되었습니다.');
							searchTableReload();	
						}
					});
				}
			}
		}*/// end of if check chgAcvtSelectCode
	});
});


var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/admin/status',
		columnDefs: [
			/*{ targets: 0, className: 'td-text-center td-text-20 no-use-sorting', orderable :false }, // NO*/
			{ targets: 0, className: 'td-text-center td-text-80' }, // 생성일
			{ targets: 1, className: 'td-text-center td-text-50' }, // 업무
			{ targets: 2, className: 'td-text-left td-text-120', render : function(data, type, row, meta){
        		return '<b class="detailBtn">' + data + '</b>'
        	}}, // Ref.No
			{ targets: 3, className: 'td-text-left td-text-160', render : function(data, type, row, meta){
				if(row.aiInptAcvtCd == '20'){
					return data;
				}else{
					return '<b class="detailBtn">' + data + '</b>'	
				}
        	}}, // 액티비티
			{ targets: 4, className: 'td-text-center td-text-100' }, // 담당자
			{ targets: 5, className: 'td-text-center td-text-40', orderable :false }, // 이미지처리
			{ targets: 6, className: 'td-text-center td-text-40', orderable :false }, // CNN
			{ targets: 7, className: 'td-text-center td-text-40', orderable :false }, // 회전각도
			{ targets: 8, className: 'td-text-center td-text-40', orderable :false }, // OCR추출
			{ targets: 9, className: 'td-text-center td-text-40', orderable :false }, // 항목추출
			{ targets: 10, className: 'td-text-center td-text-40', orderable :false }, // 심사
			{ targets: 11, className: 'td-text-center td-text-40', orderable :false }, // S/W
			
			{ targets: 12, className: 'td-text-center td-text-80' }, // 경과시간
			{ targets: 13, className: 'td-text-center td-text-40' }, // 처리횟수
			{ targets: 14, className: 'td-text-left td-text-100' }, // 심사진행상태
			
			
			{ targets: 15, visible: false }, // 마스터번호
			{ targets: 16, visible: false }, // 외환참조일련변호
			{ targets: 17, visible: false }, // 심사자동화업무구분코드
			{ targets: 18, visible: false }, // ai심사프로세스코드
			{ targets: 19, visible: false }, // 심사자동화업무구분명
			{ targets: 20, visible: false }, // ai심사활동코드
			{ targets: 21, visible: false }, // ai심사처리구분코드
			{ targets: 22, visible: false }, // ai심사진행상태코드
			{ targets: 23, visible: false }, // DB최종저장시간
			{ targets: 24, visible: false }, // 경과분
			{ targets: 25, visible: false }, // 경과시간
			{ targets: 26, visible: false }, // 경과데이
			
			{ targets: 27, className: 'td-text-left td-text-60'},	// 처리구분
			{ targets: 28, className: 'td-text-center td-text-60'}, // 수행서버
			{ targets: 29, className: 'td-text-center td-text-60', orderable :false }, // 재처리 및 삭제버튼
			{ targets: 30, visible: false }, // 결재진행상태코드
			{ targets: 31, className: 'td-text-center td-text-40'}, // 마스터
			
			{ targets: 32, className: 'td-text-center td-text-60'}, // 페이지수
			{ targets: 33, className: 'td-text-center td-text-100', render : function(data, type, row, meta){
				var convDateStr = data.substring(0,4)+'-'+data.substring(4,6)+'-'+data.substring(6,8)+' '+data.substring(8,10)+':'+data.substring(10,12)+':'+data.substring(12,14);
				return convDateStr;
			}} // 최종DB변경시간
		],
		columns: [
			{"data": "inptRcpDt", title: '생성일', render: function(data, type, row, meta){return dataFormat(data);}},
			{"data": "inptAtmcBizDsnm", title: '업무'},
        	{"data": "actlFxRefno", title: 'Ref.No'},
        	{"data": "aiInptAcvtNm", title: '액티비티'},
        	{"data": "aiInspeEno", title: '담당자'},
        	{"data": "", title: '이미지'},
        	{"data": "", title: 'CNN'},
        	{"data": "", title: '회전<br/>각도'},
        	{"data": "", title: 'OCR<br/>추출'},
        	{"data": "", title: '항목<br/>추출'},
        	{"data": "", title: '심사'},
        	{"data": "", title: 'S/W'},
        	{"data": "procDay", title: '경과시간'},
        	{"data": "rprocTcn", title: '처리<br/>횟수'},
        	{"data": "aiSysInptPrgStnm", title: '심사진행상태'},
        	{"data": "inptMstSrno"},
        	{"data": "fxRefnoSrno"},
        	{"data": "inptAtmcBizDscd"},
        	{"data": "aiInptProsCd"},
        	{"data": "aiInptProsNm"},
        	{"data": "aiInptAcvtCd"},
        	{"data": "aiInptPrcDscd"},
        	{"data": "aiSysInptPrgStcd"},
        	{"data": "lstDbChgDtm"},
        	{"data": "procMinute"},
        	{"data": "procHour"},
        	{"data": "procDay"},
        	//aiSysInptPrgStnm
        	{"data": "aiInptPrcDsnm", title: '처리구분'},
        	{"data": "aiInptSvrInfTxt", title: '수행서버'},
        	
        	{"data": ""},
        	{"data": "aiInptAppvStcd"},
        	{"data": "inptMstSrno", title: '마스터'},
        	
        	{"data": "docPageNum", title: '페이지수'},
        	{"data": "lstDbChgDtm", title: '최종DB변경시간'}
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			options.aiSysInptPrgStcd = $("#cbo_aiSysInptPrgStcd_Search_"+page_id).val();	// 심사진행상태 조건
			options.aiInptProcTime = $("#aiInptProcTime_Search_"+page_id).val();			// 처리경과시간 조건
			options.schRefNo = $("#schRefNo_Search_"+page_id).val();						// RefNo 조건
			options.schUserYn = $(':radio[name="aiInptPrcDscd"]:checked').val();			// 처리구분 조건
			options.schSdate = $(':radio[name="aiInptRcpDtCustom"]:checked').val();			// 업무생성일 전체 || 당일
			options.btnFlag = $("#schAiInptSvrInfTxt").val();								// 수행서버 조건
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("8050",null,"01",$.param(options));
			
			return options;
			
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

			// 경과시간 랜더링
			var proc_d = aData['procDay'];
			var proc_h = aData['procHour'];
			var proc_h_conv = (Number(proc_d) * 24) + Number(proc_h);
			var proc_m = aData['procMinute'];
			var proc_s = aData['procSec'];
			var proc_formatted = "";
			
			var titleContent = "";
			titleContent += (proc_d != "0") ? (proc_d+" 일 ") : "";
			titleContent += (proc_h != "0") ? (proc_h+" 시간 ") : "";
			titleContent += (proc_m != "0") ? (proc_m+" 분 ") : "";
			titleContent += (proc_s != "0") ? (proc_s+" 초") : "";
			
			proc_formatted += (proc_h_conv > 99) ? "99:" : proc_h_conv + ":";
			proc_formatted += (proc_m < 10) ? "0" + proc_m + ":" : proc_m + ":";
			proc_formatted += (proc_s < 10) ? "0" + proc_s : proc_s;
			
			$(nRow).find('td:eq(12)').html(proc_formatted);
			$(nRow).find('td:eq(12)').attr("title", titleContent);
			
			// ▶  랜더링
			var indexEdMapper = {
					'이미지처리'	: 5,
					'CNN'    	: 6,
					'회전각도' 	: 7,
					'OCR추출'		: 8,
					'항목추출'		: 9,
					'심사' 		: 10,
					'S/W'		: 11
			};
			// ▶ 시작위치
			var indexStMapper = {
					'1' : 5,
					'4' : 5,
					'2' : 7,
					'3' : 10
			};
			
			// null check for IE
			for(var index = 5 ; index < 12 ; index++){
				$(nRow).find('td:eq('+index+')').html("");
			}
			
			// ▶ 시작위치
			var startPoint = indexStMapper[aData['aiInptPrcDscd']];
			if(aData['aiInptAcvtCd'] == '20' || aData['aiInptAcvtCd'] == '21'){
				startPoint = 5; // 이미지스캔(신규) 혹은 이미지스캔(재스캔) 인 경우 [이미지] 부터
			}else if(aData['aiInptAcvtCd'] == '30'){
				startPoint = 5; // 문자인식 및 항목추출(정상) 인 경우 [이미지] 부터
			}else if(aData['aiInptAcvtCd'] == '40'){
				startPoint = 7; // 문자인식 및 항목추출(재추출) 인 경우 [회전각도] 부터
			}else if(aData['aiInptAcvtCd'] == '60'){
				startPoint = 7; // AI 자동심사(정상) 인 경우 [회전각도] 부터
			}
			
			var processGroup = aData['processGroup'];
			
			// ▶ 에러여부
			var errorYN = (aData['aiSysInptPrgStnm'].indexOf("오류") !== -1) ? "Y" : "N";
			var currentPointClassName = (errorYN == "Y" ? "pointError" : "pointNormal");
			// ▶ td background-color
			for(var index = 5; index < 12; index++){
				$(nRow).find('td:eq('+index+')').attr("title", "");
				$(nRow).find('td:eq('+index+')').css('background-color', '#fff');
			}
			// ▶ 현재위치
			//<i class="fa fa-play fa-lg mt-4"></i>
			$(nRow).find('td:eq('+indexEdMapper[processGroup]+')').attr("title", aData['aiSysInptPrgStnm']);
			$(nRow).find('td:eq('+indexEdMapper[processGroup]+')').html('<i class="fa fa-play fa-lg mt-4 '+currentPointClassName+'"></i>');
			// ▶ 시작위치 ~ forloop
			for(var index = startPoint; index < indexEdMapper[processGroup]; index++){
				$(nRow).find('td:eq('+index+')').html('<i class="fa fa-play fa-lg mt-4 pointPast"></i>');
			}
			// ▶ 재처리&삭제 버튼 생성
			// 1) [액티비티코드] 심사건(처리구분코드 3) 이면서 액티비티코드가 이미지신규스캔(20) & 이미지신규재스캔(21) 인 경우 삭제버튼
			// 2) []
			if((aData['aiInptAcvtCd'] == '20' || aData['aiInptAcvtCd'] == '21') && aData['aiInptPrcDscd'] == '3'){
				$(nRow).find('td:eq(17)').html('<button type="button" class="adminStatusReproBtn" id="deleteProcBtn">삭제</button>');	
			}else if(aData['aiSysInptPrgStcd'] == '01' && (aData['aiInptPrcDscd'] == '1' || aData['aiInptPrcDscd'] == '4')){
				$(nRow).find('td:eq(17)').html('<button type="button" class="adminStatusReproBtn" id="deleteProcBtn">삭제</button>');	
			}else{
				$(nRow).find('td:eq(17)').html('<button type="button" class="adminStatusReproBtn" id="reProcBtn">재처리</button>');
			}
			// ▶재처리&삭제 버튼 css
			$(nRow).find('td:eq(17)').css('padding', '0');
			
			// thead height
			var headerTR = $('.dataTables_scrollHeadInner').find('.table-responsive-sm').find('thead').find('tr');
			headerTR.css('height','30px');
		}
	};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="numColYN" value="false" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="400" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>

var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){	
	$('.gridFunctionBtn').attr('disabled', false);
	$('.gridFunctionBtn').addClass('searchBtnType1');
	$('.gridFunctionBtn').removeClass('acvtChgBtnDeactive');
	
	for(var idx = 5; idx < 12; idx++){
		$(e.currentTarget).find('tr:eq('+(Number(index)+1)+')').find('td:eq('+idx+')').css('background-color','#b0bed9');
	}
};

var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){	
	$('.gridFunctionBtn').attr('disabled', true);
	$('.gridFunctionBtn').addClass('acvtChgBtnDeactive');
	$('.gridFunctionBtn').removeClass('searchBtnType1');
	
	for(var idx = 5; idx < 12; idx++){
		$(e.currentTarget).find('tr:eq('+(Number(index)+1)+')').find('td:eq('+idx+')').css('background-color','#fff');
	}
};

function searchTableReload(){
	<c:out value="${dataTableId}"/>.searchList();
}

function searchTableReloadNoPageChange(){
	<c:out value="${dataTableId}"/>.searchListCurrentPage();
}



function afterSchBtn(){

}

</script>