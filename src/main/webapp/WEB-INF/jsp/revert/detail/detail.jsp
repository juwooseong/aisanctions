<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="1010"/>

<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/custom_style.css?v=20260815e"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/theme_mockup.css?v=20260816m"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/annotation.css?v=20260815b"/>

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
					<select id="item_select" class="item_select"></select>
					<strong id="blTitle">BL그룹</strong>
					<select id="bl_select" class="bl_select"></select>
					<button id="reCrfBtn" class="btn btn-sm btn-secondary w-45">변경</button>
					<div id="img-scre"></div>
				</div>
				<div class="cate">
					<strong>이미지선택</strong>
					<div id="blickdiv" class="img-select-type-div">
						<input type="radio" name="imgSelect" id="imgSelectSingle" value="single" checked="" autocomplete="off">
						<label for="imgSelectSingle">현재이미지 </label>
						<input type="radio" name="imgSelect" id="imgSelectMultiple" value="multiple" autocomplete="off">
						<label for="imgSelectMultiple">복수이미지 </label>
					</div>
					<input type="text" id="start_range" class="img-range">
					<label> ~ </label>
					<input type="text" id="end_range" class="img-range">
				</div>
				<div class="doc">
					<input type="hidden" id="active_inptTaskId">
					<input type="hidden" id="active_inptElmtId">
					<input type="hidden" id="active_imexHisCd">
					<input type="hidden" id="active_spdKind">
					<input type="hidden" id="active_inptBlGrpNo">
					<input type="hidden" id="active_aiInptPapsQltScre">
					
					<div class="anno-canvas-wrap">
						<div id="annoToolbar" class="anno-toolbar">
							<button type="button" class="btn btn-sm btn-info P-1 anno-mode-btn active" data-anno-mode="navigate" title="이동">
								<i class="fa fa-arrows fa-lg"></i>
							</button>
							<button type="button" class="btn btn-sm btn-info P-1 anno-mode-btn" data-anno-mode="marker" title="형광펜">
								<i class="fa fa-paint-brush fa-lg"></i>
							</button>
							<button type="button" class="btn btn-sm btn-info P-1 anno-mode-btn" data-anno-mode="pin" title="핀 고정">
								<i class="fa fa-thumb-tack fa-lg"></i>
							</button>
							<span class="anno-marker-palette" aria-label="색상">
								<button type="button" class="anno-swatch yellow active" data-anno-color="rgba(255,235,59,0.45)" data-pin-color="#ca8a04" title="노랑"></button>
								<button type="button" class="anno-swatch pink" data-anno-color="rgba(244,114,182,0.4)" data-pin-color="#db2777" title="분홍"></button>
								<button type="button" class="anno-swatch green" data-anno-color="rgba(74,222,128,0.4)" data-pin-color="#16a34a" title="초록"></button>
								<button type="button" class="anno-swatch blue" data-anno-color="rgba(96,165,250,0.4)" data-pin-color="#2563eb" title="파랑"></button>
								<button type="button" class="anno-swatch orange" data-anno-color="rgba(251,146,60,0.4)" data-pin-color="#ea580c" title="주황"></button>
								<button type="button" class="anno-swatch black" data-anno-color="rgba(15,23,42,0.45)" data-pin-color="#111827" title="검정"></button>
							</span>
							<span class="anno-hint" id="annoHint">핀 클릭=의견 · 형광펜 선택 후 Delete=삭제</span>
						</div>
						<div id="canvas_area" class="canvas-overflow-revert">
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
						<button type="button" class="btn btn-sm btn-info P-1 mt-1" id="docClassBatchBtn" title="문서분류 일괄변경">
							<i class="fa fa-th fa-lg"></i>
						</button>
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
								<span class="revertDetailDiscription">한글, 한문, 전각문자, 개행문자 등은 지원하지 않습니다.</span>
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

<div id="mask">
	<div class="card mask_card">
		<div class="card-header" id="maskTitle"></div>
		<div class="card-body">
			<div class="progress">
				<div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
			</div>
		</div>
	</div>
</div>


<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script src="${ctx_res}/js/common_detail.js?v=20260816d"></script>
<!-- 수기입력 동적 컬럼(수기 추가): 결재자 화면은 조회 전용이므로 컬럼 추가/삭제(+/-)는 비활성화하고
     심사자가 저장해둔 값만 읽기전용으로 보여준다. -->
<script>window.MANUAL_COL_READONLY = true;</script>
<script src="${ctx_res}/js/manual-add-column.js"></script>
<script src="${ctx_res}/js/revert/genesis.js"></script>
<script src="${ctx_res}/js/annotation-host.js?v=20260815c"></script>
<%@include file="/WEB-INF/jsp/common/document-classification-modal.jsp"%>

<div class="anno-pin-modal" id="anno_pin_modal">
	<div class="anno-pin-box">
		<div class="anno-pin-head">핀 심사 의견</div>
		<div class="anno-pin-body">
			<label for="anno_pin_opinion">의견 (핀 옆에 표시)</label>
			<textarea id="anno_pin_opinion" placeholder="해당 위치에 대한 심사 의견을 입력하세요."></textarea>
			<label class="anno-pin-color-label">색상</label>
			<div class="anno-pin-colors" id="anno_pin_colors">
				<button type="button" class="anno-swatch yellow" data-pin-color="#ca8a04" title="노랑"></button>
				<button type="button" class="anno-swatch pink" data-pin-color="#db2777" title="분홍"></button>
				<button type="button" class="anno-swatch green" data-pin-color="#16a34a" title="초록"></button>
				<button type="button" class="anno-swatch blue" data-pin-color="#2563eb" title="파랑"></button>
				<button type="button" class="anno-swatch orange" data-pin-color="#ea580c" title="주황"></button>
				<button type="button" class="anno-swatch black" data-pin-color="#111827" title="검정"></button>
			</div>
		</div>
		<div class="anno-pin-foot">
			<button type="button" class="btn btn-sm btn-danger anno-del" id="anno_pin_delete">삭제</button>
			<button type="button" class="btn btn-sm btn-secondary" id="anno_pin_cancel">취소</button>
			<button type="button" class="btn btn-sm btn-primary" id="anno_pin_save">저장</button>
		</div>
	</div>
</div>

<script>
var pageParams = [];
var imgSelectType = "";

// 국가코드 자동세팅 코드데이터
var countryCodeData = 	{
	'code_40' : '41',
	'code_72' : '73',
	'code_64' : '65',
	'code_55' : '56',
	'code_61' : '62',
	'code_58' : '59',
	'code_48' : '49',
	'code_17' : '18',
	'code_80' : '81',
	'code_21' : '22',
	'code_95' : '96',
	'code_91' : '92',
	'code_25' : '26',
	'code_35' : '36',
	'code_30' : '31',
	'code_76' : '77',
	'code_45' : '46',
	'code_68' : '69',
	'code_84' : '85'
};
pageParams['inptMstSrno'] = '<c:out value="${param.inptMstSrno}"/>';
pageParams['inptAtvtCd'] = '<c:out value="${param.inptAtvtCd}"/>';
pageParams['actlFxRefno'] = '<c:out value="${param.actlFxRefno}"/>';


$(document).ready(function(){
	fn_defaultZoom();
	fn_getBLData("A");
	width_global = $('#canvas').prop("width");
	height_global = $('#canvas').prop("height");
	
	imgSelectType = $('[name="imgSelect"]:checked').val();
	
	if ("single" == imgSelectType) {
		
		$('.img-range').val("");
		$('.img-range').prop('disabled', true);

	} else {
		
		$('.img-range').val("");
		$('.img-range').prop('disabled', false);
	}
});

// 수기입력 했을 경우
function fn_itmInptHndgInpDatTextChage(ele, val, _inptSanctionNo, _inptTaskId, _indexNo) {
	// 항목추출이 안된 항목들도 이 함수가 호출되게 해주어야함
	var _sanctionRst = $globaObjlData.sanctionRst;
	var _tmpCode = "code_" + _inptSanctionNo
	_sanctionRst[_indexNo].itmInptHndgInpDatTxt = val;
	
	// 국가코드 자동세팅 코드데이터
	var _sanctionNo = countryCodeData[_tmpCode];
	if (_sanctionNo) {
		
		val = val.trim();
		
		if (!val == "") {
			fn_getNationCd(val, _sanctionNo, _indexNo);
		}
	}
	
}

// 국가코드 받아오기
function fn_getNationCd(val, _sanctionNo, _indexNo) {
	
	var _sanctionRst = $globaObjlData.sanctionRst;
	
	$.ajax({
		url : "/api/common/detail/getNationCd",
		type : "post",
		cache: false,
		async : false,
		data : {itmInptHndgInpDatTxt : val} ,			
		dataType: "json",
		success : function(data) {
			
			var _nationCd = data.nationCd;

			if (_nationCd) {
				
				for(var i in globalSanctionRstListData) {
					
					if (_sanctionNo == globalSanctionRstListData[i][8]) {
						
						// 추출 데이터에서 국가코드 데이터가 다를때
						if (_nationCd != globalSanctionRstListData[i][3]) {
							$('#index_' + (globalSanctionRstListData[i][0] - 1)).val(_nationCd);
							_sanctionRst[globalSanctionRstListData[i][0] - 1].itmInptHndgInpDatTxt = _nationCd;
						} else {
							
							// 추출 데이터에서 국가코드는 같고 수기데이터의 국가코드가 다를때
							if (_nationCd != $('#index_' + (globalSanctionRstListData[i][0] - 1)).val() && $('#index_' + (globalSanctionRstListData[i][0] - 1)).val() != "") {
								$('#index_' + (globalSanctionRstListData[i][0] - 1)).val("");
								_sanctionRst[globalSanctionRstListData[i][0] - 1].itmInptHndgInpDatTxt = "";
							}
						}
					}
				}
			}
		},
		error : function(e) {
		},
		complete: function() {
			
		}
	});	
}

// 문서분류  selectBox 변경
$(document).on('change','#item_select', function(e) {
	var _arrImgPageInfo = $globaObjlData.imgPageInfo;
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _imgInptTaskId = $('#active_inptTaskId').val();
	var _imgImexHisCd = $('#active_imexHisCd').val();
	var _inptElmtId = $('#active_inptElmtId').val();
	var _aiInptPapsQltScre = $('#active_aiInptPapsQltScre').val();
	var _itemSelectValue = $(this).val();
	var _idx = 0;
	var _altYn = "N";
	
	var _data_imexhisnm = $('.item-active').attr('data-imexhisnm');
	var _data_imexhiscd = $('.item-active').attr('data-imexhiscd');
	var _itemSelectText = $('#item_select option:selected').text();

	
	var _newBlNo = parseInt($('#bl_select option:last').val()) + 1;
	var _newHtml = "";
	
	// BL선택 시
	if (_itemSelectValue == "01") {
		
		$('#bl_select').prop('disabled', false);
		
		if ($('#new_bl').length == 0) {
			_newHtml += "<option id='new_bl' value='" + _newBlNo + "'>신규</option>";
			$('#bl_select').append(_newHtml);
		}
		
	} else {
		
		$('#bl_select').prop('disabled', true);
		
		if ($('#new_bl').length > 0) {
			$('#new_bl').remove();
		}
	}
});

// 문서분류변경
$(document).on('click','#reCrfBtn', function(e) {
	
	var _reCrfListType = $('[name="imgSelect"]:checked').val();

	if(_reCrfListType == "multiple") {
		
		// 복수이미지 범위 데이터 세팅
		var _reCrfStart = parseInt($('#start_range').val());
		var _reCrfEnd =  parseInt($('#end_range').val());
		
		if (_reCrfStart > _reCrfEnd) {
			
			alert("시작 이미지번호가 마지막 이미지번호 보다 큽니다.");
			return false;
			
		}
		
		if (_reCrfStart > globalImglist.length || _reCrfEnd > globalImglist.length) {
			
			alert("이미지번호 범위가 실제 이미지수 보다 큽니다.");
			return false;
			
		}
		
		if (!_reCrfStart || !_reCrfEnd || _reCrfStart == 0 || _reCrfEnd == 0) {
			
			alert("이미지번호 범위를 확인해주세요.");
			return false;
			
		}
		
		var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
		var _itemSelectText = $('#item_select option:selected').text();
		var _itemActive = $('#item_select').val();
		var _blSelectText = $('#bl_select option:selected').text();
		var _blSelectVal = $('#bl_select').val();
		
		var _sanctionObj = null;
		var _reCrfList = new Array();
		var _params = new Object();
		var _reCrfChgList = null;
	
		var _inptBlGrpNo = "";
		var _imexHisCd = "";
		var _inptTaskId = "";
		var _inptMstSrno = "";
		
		// 복수이미지 데이터 세팅	
		for (var i = _reCrfStart; i <= _reCrfEnd; i ++) {
			_sanctionObj = new Object();
			_sanctionObj.inptBlGrpNo = _blSelectVal;
			_sanctionObj.imexHisCd = _itemActive;
			_sanctionObj.inptTaskId = globalImglist[i - 1].inptTaskId;
			_sanctionObj.inptMstSrno = globalInptMstSrno;
			_reCrfList.push(_sanctionObj);
		}
		
		if (_activeInptBlGrpNo == _blSelectVal) {
			_params.spdKind = "matched";
		} else {
			_params.spdKind = "notMatched";
		}
		
		_params.reCrfList = _reCrfList.length == 0 ? null : _reCrfList;
		
		if(confirm(_reCrfEnd - _reCrfStart + 1 + "개의 문서를 " + _itemSelectText + "[" + _blSelectText + "]로 변경 하시겠습니까?")) {
			
			$.ajax({
				url : "/api/common/revertDetail/reCrfMulti",
				type : "post",
				cashe : false,
				data : { jData: JSON.stringify(_params) },		
				dataType: "json",
				global: false,
				success : function(data) {
					h_loading();
					globalChangeData = 'N';
					
					if (!(rotateVal % 180 == 0)) {
						fn_rotate("l");
					}
					$('#canvas').prop("height", height_global);
					$('#canvas').prop("width", width_global);
					
					fn_getBLData("A");
				},
				error : function(e) {
					h_loading();
					globalChangeData = 'N';
					alert('분서분류가 실패했습니다.');
				},
				complete: function() {
					$('.img-range').val("");
				}
			});	
		}
		
	} else {
		
	 	var _arrImgPageInfo = $globaObjlData.imgPageInfo;
	 	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	 	var _imgInptTaskId = $('#active_inptTaskId').val();
	 	var _imgImexHisCd = $('#active_imexHisCd').val();
	 	var _inptElmtId = $('#active_inptElmtId').val();
		
	 	var _activeInptBlGrpNoText = $('.bl-link_active').text();
	 	var _blSelectText = $('#bl_select option:selected').text();
		
	 	var _aiInptPapsQltScre = $('#active_aiInptPapsQltScre').val();
	 	var _itemSelectVal = $('#item_select').val();
	 	var _blSelectVal = $('#bl_select').val();
	 	var _itemActive = $('#item_select').val();
	 	var _idx = 0;
	 	var _altYn = "N";
		
	 	var _data_imexhisnm = $('.item-active').attr('data-imexhisnm');
	 	var _data_imexhiscd = $('.item-active').attr('data-imexhiscd');
	 	var _itemSelectText = $('#item_select option:selected').text();
		
	 	var pros_data = {
	 			inptMstSrno: parseInt(globalInptMstSrno),
	 			inptTaskId : _imgInptTaskId,
	 			imexHisCd : _itemActive,
	 			inptBlGrpNo :parseInt( _blSelectVal)
	 	};
		
	 	//프로그램 사용 이력 로그누적
	 	pros_data.aiInptCnctScrnNo = "1011";
	 	pros_data.aiInptCnctFldCd = null;
	 	pros_data.aiInptCnctActiCd = "12";
	 	pros_data.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
		if (_activeInptBlGrpNo == _blSelectVal) {
			pros_data.spdKind = "matched";
		} else {
			pros_data.spdKind = "notMatched";
		}
		
	 	if(_itemActive == _imgImexHisCd && _blSelectVal == _activeInptBlGrpNo) {
	 		alert("변경된 분서분류가 없습니다.");
	 	} else {
		
	 		if(confirm(_data_imexhisnm + "[" + _activeInptBlGrpNoText + "]을(를) " + _itemSelectText + "[" + _blSelectText + "]로 변경 하시겠습니까?")) {
				
	 			s_loading();
				
	 			$.ajax({
	 				url : "/api/common/revertDetail/reCrf",
	 				type : "post",
	 				cashe : false,
	 				data : pros_data,			
	 				dataType: "json",
	 				global: false,
	 				success : function(data) {
	 					h_loading();
	 					globalChangeData = 'N';
	 					
						if (!(rotateVal % 180 == 0)) {
							fn_rotate("l");
						}
						$('#canvas').prop("height", height_global);
						$('#canvas').prop("width", width_global);
	 					
	 					fn_getBLData("A");
	 				},
	 				error : function(e) {
	 					h_loading();
	 					globalChangeData = 'N';
	 					alert('분서분류가 실패했습니다.');
	 				},
	 				complete: function() {
	 					$('.img-range').val("");
	 				}
	 			});	
	 		}
	 	}
	}
});

// 재추출
$(document).on('click','#reExtractionBtn', function(e) {
	
	var _arrImgPageInfo = $globaObjlData.imgPageInfo;
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _activeInptBlGrpNoText = $('.bl-link_active').text();
	var _imgInptTaskId = $('#active_inptTaskId').val();
	var _imgImexHisCd = $('#active_imexHisCd').val();
	var _inptElmtId = $('#active_inptElmtId').val();
	
	var _aiInptPapsQltScre = $('#active_aiInptPapsQltScre').val();
	var _itemSelectVal = $('#item_select').val();
	var _blSelectVal = $('#bl_select').val();
	var _blSelectText = $('#bl_select option:selected').text();
	var _itemActive = $('#item_select').val();
	var _idx = 0;
	var _altYn = "N";
	
	var _data_imexhisnm = $('.item-active').attr('data-imexhisnm');
	var _data_imexhiscd = $('.item-active').attr('data-imexhiscd');
	var _itemSelectText = $('#item_select option:selected').text();
	
	if(confirm("재추출 시 수기 입력 정보는 모두 삭제 됩니다. \n재추출을 진행 하시겠습니까?")) {
		
		s_loading();
		
		var _arrImgPageInfo = $globaObjlData.imgPageInfo;
		var _arrImexInfo = new Array();
		var _objImexInfo = null;
		
		var _params = new Object();
		_params.inptMstSrno = globalInptMstSrno;
		_params.aiInptBizDscd = $('#active_aiInptBizDscd').val();
		_params.imexHisCd = _itemActive;
		_params.imexHisCdOrg = _imgImexHisCd;
		_params.inptBlGrpNo = _blSelectVal;
		_params.inptBlGrpNoOrg = _activeInptBlGrpNo;
		_params.inptTaskId = _imgInptTaskId;
		_params.aiInptAcvtCd = "40";
		
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "1011";
		_params.aiInptCnctFldCd = null;
		_params.aiInptCnctActiCd = "13";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
	
		$.ajax({
			url : "/api/extraction",
			type : "post",
			cashe : false,
			data : { jData: JSON.stringify(_params) },			
			dataType: "json",
			global: false,
			success : function(data) {
				h_loading();
				globalChangeData = 'N';
				
				if (data.rst == "success") {
					window.close();
				
				} else if (data.rst == "fail") {
					alert('TA서버에 일시적 오류가 발생했습니다.');
				
				} else if (data.rst == "error") {
					alert('재추출이 실패했습니다.');
				}
			},
			error : function(e) {
				h_loading();
				globalChangeData = 'N';
				alert('재추출이 실패했습니다.');
			
			},
			complete: function() {
				
			}
		});	
	}
});

// 임시저장
$(document).on('click','#tmpSaveBtn', function(e) {
	if(confirm("임시저장을 하시겠습니까?")) {
		
		s_loading();
		
		var _params = fn_setTmpParam();
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "1011";
		_params.aiInptCnctFldCd = null;
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

// 심사진행, 재심사
$(document).on('click','#inspection', function(e) {
	
	if(confirm("심사를 진행하시겠습니까?")) {
		var _params = fn_setTmpParam();
		
		// 심사 호출 타입
		_params.inspectionType = "revert";
		
		// 프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "1011";
		_params.aiInptCnctFldCd = null;
		_params.aiInptCnctActiCd = "15";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
		s_loading();
		
		$.ajax({
			url : "/api/common/revertDetail/inspection",
			type : "post",
			data : { jData: JSON.stringify(_params) } ,			
			dataType: "json",
			global: false,
			success : function(data) {
				globalChangeData = 'N';
				
				if (data.rst == "success") {
					
					setTimeout(function() {
						h_loading();
						window.close();
					}, 2000);
					
				} else if (data.rst == "fail") {
					h_loading();
					alert('TA서버에 일시적 오류가 발생했습니다.');
					
				} else if (data.rst == "error") {
					h_loading();
					alert('심사가 실패했습니다.');
				}
			},
			error : function(e) {
				h_loading();
				globalChangeData = 'N';
				alert('심사가 실패했습니다.');
				
			},
			complete: function() {
				
			}
		});
	}
});

// 완료, 완료
$(document).on('click','#porsBtn, #rePorsBtn', function(e) {
	var _btnId = $(this).attr('id');
	var _msg = "";
	var _aler_msg = "";
	var _btnFlag = "";
	
	// S/W 상태가 Aleat이면 경고창열기
	// 10	완료	Clean
	// 20	대기	Wating
	// 30	경보	Alert
	// 40	해소	Release
	var _mstTotaltextAiInptRstCd = $globaObjlData.selectStdInfo.mstTotaltextAiInptRstCd;
	if (_mstTotaltextAiInptRstCd == "20") {
		alert("TotalText 심사결과가 Wating이면 완료할 수 없습니다.");
		return false;
	}		
	var _mstInptItmAiInptRstCd = $globaObjlData.selectStdInfo.mstInptItmAiInptRstCd;
	if (_mstInptItmAiInptRstCd == "20") {
		alert("항목심사 심사결과가 Wating이면 완료할 수 없습니다.");
		return false;
	}		
	var _safewatchAiInptRstCd = $globaObjlData.selectStdInfo.safewatchAiInptRstCd;
	if (_safewatchAiInptRstCd == "20") {
		alert("S/W 심사결과가 Wating이면 완료할 수 없습니다.");
		return false;
	}
	
	if (_mstTotaltextAiInptRstCd == "30") {
		_aler_msg += "[TotalText 심사결과]";
	}
	
	if (_mstInptItmAiInptRstCd == "30") {
		_aler_msg += "[항목심사 심사결과]";
	}
	
	if (_safewatchAiInptRstCd == "30") {
		_aler_msg += "[S/W 심사결과]";
	}
	
	var _inptMstSrno = globalInptMstSrno;
	var _aiInptAppvSrno = $('#active_aiInptAppvSrno').val();
	var _aiInptBizDscd = $('#active_aiInptBizDscd').val();
	var _aiInptPrcOpiTxt = $('#rspt_inpt_apv_req_txt').val();
	var _totaltextAiInptRstCd = "notSelected" == $('#totalTextStcdList_select').val() ? $('#active_mstTotaltextAiInptRstCd').val() : $('#totalTextStcdList_select').val();
	var _itmInptAiInptRstCd = "notSelected" == $('#itmInptlStcdList_select').val() ? $('#active_mstInptItmAiInptRstCd').val() : $('#itmInptlStcdList_select').val();
	
	var _params = fn_setTmpParam();
	
	_params.mstTotaltextAiInptRstCd = _totaltextAiInptRstCd;
	_params.mstInptItmAiInptRstCd = _itmInptAiInptRstCd;
	_params.curtAiInspAtvtCd = $globaObjlData.selectStdInfo.aiInptAcvtCd;

	
	if(_btnId == "porsBtn") {
		_msg = "완료";
		_params.btnFlag = "U";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "1011";
		_params.aiInptCnctFldCd = null;
		_params.aiInptCnctActiCd = "20";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
	} else {
		_msg = "완료";
		_params.btnFlag = "RU";
		//프로그램 사용 이력 로그누적
		_params.aiInptCnctScrnNo = "1011";
		_params.aiInptCnctFldCd = null;
		_params.aiInptCnctActiCd = "31";
		_params.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
	}
	
	// 심사결과 항목 1개라도 alert이면 confirm
	if (_mstTotaltextAiInptRstCd == "30" || _mstInptItmAiInptRstCd == "30" || _safewatchAiInptRstCd == "30") {
		
		if(confirm(_aler_msg + "가 Alert입니다. \n완료 하시겠습니까?")) {
			
			$.ajax({
				url : "/api/common/revertDetail/santionApprv",
				type : "post",
				data : { jData: JSON.stringify(_params) } ,		
				dataType: "json",
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
				error : function(e) {
					h_loading();
					globalChangeData = 'N';
					alert(_msg + '가 실패했습니다.');
				},
				complete: function() {
				}
			});
		}
		
	} else {
		
		$.ajax({
			url : "/api/common/revertDetail/santionApprv",
			type : "post",
			data : { jData: JSON.stringify(_params) } ,		
			dataType: "json",
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
			error : function(e) {
				h_loading();
				globalChangeData = 'N';
				alert(_msg + '가 실패했습니다.');
			},
			complete: function() {
			}
		});
	}
});

// 재스캔
$(document).on('click','#reScanBtn', function(e) {
	
	if(confirm("재스캔을 하시겠습니까?")) {
		
		var _inptMstSrno = globalInptMstSrno;
		var _aiInptBizDscd = $('#active_aiInptBizDscd').val();
		
		var pros_data = {
				inptMstSrno: _inptMstSrno,
				aiInptBizDscd : _aiInptBizDscd
		};
		
		//프로그램 사용 이력 로그누적
		pros_data.aiInptCnctScrnNo = "1011";
		pros_data.aiInptCnctFldCd = null;
		pros_data.aiInptCnctActiCd = "27";
		pros_data.aiInptCnctParmTxt = $.param({inptMstSrno : globalInptMstSrno});
		
		$.ajax({
			url : "/api/common/revertDetail/updateReScanNed",
			type : "post",
			data : pros_data,			
			dataType: "json",
			global: false,
			success : function(data) {
				h_loading();
				globalChangeData = 'N';
				window.close();
			},
			error : function(e) {
				h_loading();
				globalChangeData = 'N';
				alert('재스캔이 실패했습니다.');
			},
			complete: function() {
			}
		});
	}
});

// 문서분류 선택 시 BL그룹 selectBox 데이터 변경
// BL선택 시 신규 추가
// BL이외 선택 시 신규 제거
$(document).on('click','.item-link', function(e) {
	
	//imexHisCd 받기
	var _selectedImexHisCd = $(this).attr('data-imexHisCd');
	
	// BL선택 시
	if (_selectedImexHisCd == "01") {
		
		$('#bl_select').prop('disabled', false);
		
	} else {
		
		$('#bl_select').prop('disabled', true);
	}
});

//데이터 변경 시 globalChangeData Y 세팅
$(document).on('change','.itm-inpt-hndg-inp, .std_info_select, .form-control', function(e) {
	
	globalChangeData = 'Y';
	
});
$(document).on('click','.btn-copy', function(e) {
	
	globalChangeData = 'Y';
	
});

// 심사상세 창 닫을 때 변경하상 있으면 임시저장 확인창 열기
$(window).bind("beforeunload", function(){
	
	opener.tableReload();
	
	if (globalChangeData == 'Y') {
		return "페이지를 이탈하면 변경사항이 저장되지 않을 수 있습니다. 페이지를 닫겠습니까?";
	}
	
});

// 이미지선택 옵션
$(document).on('change','[name="imgSelect"]', function(e) {
	
	imgSelectType = $('[name="imgSelect"]:checked').val();
	
	if ("single" == imgSelectType) {
		
		$('.img-range').val("");
		$('.img-range').prop('disabled', true);

	} else {
		
		$('.img-range').val("");
		$('.img-range').prop('disabled', false);
	}
	
});

// 복수이미지 범위 숫자만 입력가능
$(document).on('keyup', '.img-range', function(e){
	var currValue = $(this).val();
		
	var pattern = /^[0-9]*$/;
	
	if(!pattern.test(currValue)){
		$(this).val("");
		$(this).focus();
		
		alert("숫자만 입력 가능합니다.");
	}
});

</script>