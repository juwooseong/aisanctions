<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/custom_style.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/annotation.css"/>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<%@include file="/WEB-INF/jsp/common/nacrd.jsp"%>
<%@include file="/WEB-INF/jsp/common/extc.jsp"%>

<div class="wrap layout_type_popup">
	<div class="layout_container">
		
		<div class="tab_menu type2">
			<h2 class="title">
				<strong id="refNo"></strong>
			</h2>
			<div class="type2" id="bl_list"></div>
		</div>
		
		<div class="section_wrapper">
			<div class="nav">
				<ul id="item_list"></ul>
			</div>
			<div class="section_cate">
				<div class="cate">
					<strong>문서분류명</strong>
					<h6 id="item_select"></h6>
					<div id="img-scre"></div>
				</div>
				<div class="doc">
					<input type="hidden" id="active_inptTaskId">
					<input type="hidden" id="active_inptElmtId">
					<input type="hidden" id="active_imexHisCd">
					<input type="hidden" id="active_spdKind">
					<input type="hidden" id="active_inptBlGrpNo">
					<input type="hidden" id="active_aiInptPapsQltScre">
					
					<div class="anno-canvas-wrap">
						<div id="canvas_area" class="canvas-overflow">
							<canvas id="canvas" width="535" height="735" class="doc-canvas"></canvas>
						</div>
					</div>
				</div>
				<p class="footBt custom-m-b-5">
					<span class="l">
						<input type="text" id="imgIndexNo" class="img-page-no">
						<strong> / </strong>
						<strong id="imgTotalNo"></strong>
					</span>
					<span class="c">
						<button id="doubleLeftBtn" class="btn btn-sm btn-info P-1 left-btn img-index-btn" btntype="doubleLeft" type="button">
							<i class="fa fa-angle-double-left fa-lg"></i>
						</button>
						<button id="singleLeftBtn" class="btn btn-sm btn-info P-1 mr-1 left-btn img-index-btn" btntype="singleLeft" type="button">
						<i class="fa fa-angle-left fa-lg"></i>
						</button>
						<span id="img_index_btn" class="img-btn-div"></span>
						<button id="singleRightBtn" class="btn btn-sm btn-info P-1 ml-1 right-btn img-index-btn" btntype="singleRight" type="button">
							<i class="fa fa-angle-right fa-lg"></i>
						</button>
						<button id="doubleRightBtn" class="btn btn-sm btn-info P-1 right-btn img-index-btn" btntype="doubleRight" type="button">
							<i class="fa fa-angle-double-right fa-lg"></i>
						</button>
					</span>
					<span class="r">
						<button class="btn btn-sm btn-info P-1 mt-1" id="zoomRefreshBtn">
							<i class="fa fa-refresh fa-lg"></i>
						</button>
						<button class="btn btn-sm btn-info P-1 mt-1" id="zoomOutBtn" onclick="fn_Zoom('-');">
							<i class="fa fa-search-minus fa-lg"></i>
						</button>
						<button class="btn btn-sm btn-info P-1 mt-1" id="zoomInBtn" onclick="fn_Zoom('+');">
							<i class="fa fa-search-plus fa-lg"></i>
						</button>
						<button class="btn btn-sm btn-info P-1 mt-1" id="rotateLeftBtn" type="button" onclick="fn_rotate('l');">
							<i class="fa fa-rotate-left fa-lg"></i>
						</button>
						<button class="btn btn-sm btn-info P-1 mt-1" id="rotaterightBtn" type="button" onclick="fn_rotate('r');">
							<i class="fa fa-rotate-right fa-lg"></i>
						</button>
					</span>
				</p>
			</div>
			<div class="center"></div>
			<div class="section_view">
				<div class="tab_menu" id="tab_list">
					<a href="#" class="inpt-tab-link active" data-tab="t2" data-spdkind="SANC" >항목심사</a>
					<a href="#" class="inpt-tab-link" data-tab="t1" data-spdkind="TOTAL" >TotalText/SW</a>
					<a href="#" class="" data-tab="t3">전달정보</a>
					<div id="blickdiv" class="blink-type-div">
						<input type="radio" name="blinkType" id="selectedBlink" value="selected" checked="" autocomplete="off">
						<label for="selectedBlink">선택 </label>
						<input type="radio" name="blinkType" id="allBlink" value="all" autocomplete="off">
						<label for="allBlink">전체 </label>
					</div>
				</div>
				<div class="tab_contents">
					<div class="tab_item active" id="t2">
						<div class="tbWrap">
							<div class="tbTop">
								<strong>항목심사</strong>
							</div>
							<div class="tbCon tbCon-detail">
								<table class="table table-responsive-sm width-100" id="sanctionRstTable"></table>
								<p class="display-inline">항목심사 결과 : </p>
								<select id="itmInptlStcdList_select" class="std_info_select"></select>
							</div>
						</div>
					</div>
					
					<div class="tab_item" id="t1">
						<div class="tbWrap">
							<div class="tbTop">
								<strong>TotalText심사</strong>
							</div>
							<div class="tbCon tbCon-totalText-detail">
								<table class="table table-responsive-sm width-100" id="totalTextRstTable"></table>
								<p class="display-inline">TotalText심사 결과 : </p>
								<select id="totalTextStcdList_select" class="std_info_select"></select>
							</div>
						</div>
						<div class="tbWrap">
							<div class="tbTop">
								<strong>SafeWatch심사</strong>
								<p class="reset-btn" id="safeWatchResetBtn">
									<i class="fa fa-refresh search-reset fa-sm"></i>
									 새로고침
							    </p>
							</div>
							<div class="tbCon tbCon-safeWatch-detail">
								<table class="table table-responsive-sm width-100" id="safeWatchRstTable"></table>
								<p class="display-inline">SafeWatch심사 결과 : </p>
								<select id="sw_select" class="std_info_select"></select>
							</div>
						</div>
					</div>
					
					<div class="tab_item" id="t3">
						<div class="tbWrap">
							<div class="tbTop">
								<strong>전달이력</strong>
							</div>
							<div class="tbCon">
								<input type="hidden" id="active_aiInptBizDscd">
								<input type="hidden" id="active_aiInptAppvSrno">
								<input type="hidden" id="active_mstTotaltextAiInptRstCd">
								<input type="hidden" id="active_mstInptItmAiInptRstCd">
								<input type="hidden" id="active_mstQltGrnAiInptRstCd">
							
								<table class="table table-responsive-sm width-100" id="appvRecodeTable"></table>
							</div>
						</div>
						<div class="tbWrap">
							<div class="tbTop">
								<strong>처리상태</strong>
							</div>
							<div class="tbCon">
								<table class="">
									<tbody>
										<tr>
											<th class="width-80">TotalText</th>
											<td id="totalTextStcd_zone"></td>
											<th class="width-80">항목심사</th>
											<td id="itmInptlStcd_zone"></td>
										</tr>
										<tr>
											<th class="width-80">SafeWatch</th>
											<td id="sw_zone"></td>
											<th class="width-80">자체점검결과</th>
											<td id="qaStcd_zone"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="tbWrap">
					<div class="tbCon">
						<table class="">
							<tbody>
								<tr>
									<th class="width-80">전달내용</th>
									<td id="totalTextStcd_zone">
										<textarea class="form-control opi-text-check" id="rspt_inpt_apv_req_txt" name="textarea-input" wrap="physical"></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<p class="footBt">
			<span class="left-btn-zone" id="left_btn_zone"></span>
			<span class="right-btn-zone" id="right_btn_zone"></span>
		</p>
	</div>
</div>

<div class="anno-pin-modal" id="anno_pin_view_modal">
	<div class="anno-pin-box">
		<div class="anno-pin-head">핀 심사의견</div>
		<div class="anno-pin-body">
			<label>의견</label>
			<div class="anno-pin-view-text" id="anno_pin_view_opinion"></div>
		</div>
		<div class="anno-pin-foot">
			<button type="button" class="btn btn-sm btn-secondary" id="anno_pin_view_close">닫기</button>
		</div>
	</div>
</div>

<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script src="${ctx_res}/js/revert/genesis.js"></script>
<script src="${ctx_res}/js/common_detail.js"></script>
<!-- 수기입력 동적 컬럼(수기 추가): 결재자 화면은 조회 전용이므로 컬럼 추가/삭제(+/-)는 비활성화하고
     심사자가 저장해둔 값만 읽기전용으로 보여준다. -->
<script>window.MANUAL_COL_READONLY = true;</script>
<script src="${ctx_res}/js/manual-add-column.js"></script>
<!-- 어노테이션(형광펜/핀)도 결재자 화면에서는 조회 전용: 저장된 내용만 보여주고 편집은 막는다. -->
<script>window.ANNO_READONLY = true;</script>
<script src="${ctx_res}/js/annotation-host.js"></script>

<script>
var pageParams = [];
pageParams['inptMstSrno'] = '<c:out escapeXml="true" value="${param.inptMstSrno}"/>';
pageParams['inptAtvtCd'] = '<c:out value="${param.inptAtvtCd}"/>';
pageParams['actlFxRefno'] = '<c:out value="${param.actlFxRefno}"/>';

$(document).ready(function(){
	fnCmnProgramLog("2011", null, "01", $.param({inptMstSrno : g_getUrlVar('inptMstSrno').replace('#', '')}));
	fn_defaultZoom();
	fn_getBLData("B");
});

//임시저장
$(document).on('click','#tmpSaveBtn', function(e) {
	if(confirm("임시저장을 하시겠습니까?")) {
		
		var _params = fn_setTmpParam();
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "2011";
		_params.aiInptCnctActiCd = "14";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
		$.ajax({
			url : "/api/common/revertDetail/santionSave",
			type : "post",
			data : { jData: JSON.stringify(_params) } ,			
			dataType: "json",
			global: false,
			success : function(data) {
				h_loading();
				globalChangeData = 'N';
				fn_getReBLData();
			},
			error : function(e) {
				h_loading();
				globalChangeData = 'N';
				alert('임시저장이 실패했습니다.');
			},
			complete: function() {
			}
		});
	}
});

// 승인, 반려, Pending, Block
$(document).on('click','#apprBtn, #returnBtn, #pendingBtn, #blockBtn', function(e) {
	var _btnId = $(this).attr('id');
	var _msg = "";
	var _btnFlag = "";
	
	var _opiTextLength = fnCheckByteSize($('#rspt_inpt_apv_req_txt').val());
	if (_opiTextLength > 4000) {
		alert("전달정보는 4000자를 넘을 수 없습니다.");
		return false;
	}
	
	var _params = {
			inptMstSrno: globalInptMstSrno,
			aiInptBizDscd: $('#active_aiInptBizDscd').val(),
			aiInptAppvSrno: $('#active_aiInptAppvSrno').val(),
			curtAiInspAtvtCd: $globaObjlData.selectStdInfo.aiInptAcvtCd,
			mstTotaltextAiInptRstCd: $('#active_mstTotaltextAiInptRstCd').val(),
			mstInptItmAiInptRstCd: $('#active_mstInptItmAiInptRstCd').val(),
			aiInptPrcOpiTxt: $('#rspt_inpt_apv_req_txt').val()
	};
	
	if(_btnId == "apprBtn") {
		
		// S/W 상태가 Aleat이면 경고창열기
		// 10	완료	Clean
		// 20	대기	Wating
		// 30	경보	Alert
		// 40	해소	Release
		var _safewatchAiInptRstCd = $globaObjlData.selectStdInfo.safewatchAiInptRstCd;
		if (_safewatchAiInptRstCd == "30") {
			alert("S/W 심사결과가 Alert이면 승인할 수 없습니다.");
			return false;
		}	
		
		_msg = "승인";
		_params.btnFlag = "A";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "2011";
		_params.aiInptCnctActiCd = "19";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
	} else if(_btnId == "returnBtn") {
		_msg = "반려";
		_params.btnFlag = "R";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "2011";
		_params.aiInptCnctActiCd = "18";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
	} else if(_btnId == "pendingBtn") {
		_msg = "Pending";
		_params.btnFlag = "P";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "2011";
		_params.aiInptCnctActiCd = "17";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
	} else if(_btnId == "blockBtn") {
		_msg = "Block";
		_params.btnFlag = "B";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "2011";
		_params.aiInptCnctActiCd = "16";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
	}
	
	if(confirm(_msg + "을(를) 하시겠습니까?")) {
		
		$.ajax({
			url : "/api/common/revertDetail/santionApprv",
			data : { jData: JSON.stringify(_params) } ,			
			dataType: "json",
			method: 'post',
			global: false,
			success : function(data) {
				h_loading();
				globalChangeData = 'N';
				if(data.resultCode=="200"){

					window.close();
					
				} else {
					alert(data.resultExMsg);
				}

			},
			error : function(e, s, err) {
				h_loading();
				globalChangeData = 'N';
				alert(_msg + '이(가) 실패했습니다.');
			},
			complete: function() {
			}
		});
	}
});


//데이터 변경 시 globalChangeData Y 세팅
$(document).on('change','.itm-inpt-hndg-inp, .std_info_select, .form-control', function(e) {
	
	globalChangeData = 'Y';
	
});

//심사상세 창 닫을 때 변경하상 있으면 임시저장 확인창 열기
$(window).bind("beforeunload", function(){
	
	opener.tableReload();
	
	if (globalChangeData == 'Y') {
		return "페이지를 이탈하면 변경사항이 저장되지 않을 수 있습니다. 페이지를 닫겠습니까?";
	}
	
});
</script>