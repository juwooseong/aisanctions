<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="9020"/>

<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/custom_style.css"/>

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
					
					<div id="canvas_area" class="canvas-overflow">
						<canvas id="canvas" width="535" height="735" class="doc-canvas"></canvas>
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
							<div class="tbCon tbCon-detail-history">
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
							<div class="tbCon tbCon-totalText-history">
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
											<td id="qaStcd_zone">
												<select id="qaStcdList_select" class="std_info_select"></select>	
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
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

<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script src="${ctx_res}/js/revert/genesis.js"></script>
<script src="${ctx_res}/js/common_detail.js"></script>

<script>
var pageParams = [];

pageParams['inptMstSrno'] = '<c:out value="${param.inptMstSrno}"/>';
pageParams['inptAtvtCd'] = '<c:out value="${param.inptAtvtCd}"/>';
pageParams['actlFxRefno'] = '<c:out value="${param.actlFxRefno}"/>';

$(document).ready(function(){
	fnCmnProgramLog("9020", null, "01", $.param({inptMstSrno : g_getUrlVar('inptMstSrno').replace('#', '')}));
	fn_defaultZoom();
	fn_getBLData("F");
});
</script>
