<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6010"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>성능분석 [6010]</strong>
		<span class="revertStatPageDiscription">특정기간 심사 정상, 오류(수기등록, 저품질, 문서재추출) 건수를 조회하여 시스템 성능을 일자별로 조회하는 화면</span>
		<span class="location">
			<span>통계</span>
			<span>성능분석</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="" name="analysis" onsubmit="return dateCheck();">
				<input type="hidden" class="" id="txt_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>"">
				<p class="w36">
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic calRange calStd" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine">~</span>
					<input type="text" class="cal daterange-basic calRange calEd" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="noticeMaxSearchSpan">(최대 30일)</span>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>" >
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="btBox" style="padding-top: 5px; height: 10px;">
			<span class="r">
			<form action="/birt/frameset" method="post" target="winReport" id="reportId">
				<input type="hidden" name="__report" value="report/stat_analysis.rptdesign">
				<input type="hidden" name="startDate" value="'">
				<input type="hidden" name="endDate" value="">
				<input type="hidden" name="startDate2" value="'">
				<input type="hidden" name="endDate2" value="">
				<input type="hidden" name="startDate3" value="'">
				<input type="hidden" name="endDate3" value="">
			</form>
 			
			</span>
		</div>
		<div class="tbWrap">
			<div class="tbTop">
				<strong>정상&오류</strong>
			</div>
			<div class="tbCon">
				 <div class="flGroup item_1"> 
					<div class="chart flItem" style="width:100%;">
						<canvas id="canvas-2_2" style="display: block;width: 1684px;height: 420px;"></canvas>
					</div>
				 </div>
			</div>
		</div>
		<div class="tbWrap">
			<div class="tbTop">
			</div> 
			<div class="tbCon">
				
					<div class="flGroup item_1">
						<div id="noSrchRstNotice" style="
											display: none;
										    width: 100%;
										    height: 500%;
										    position: absolute;
										    background-color: #fff;
										    left: 0;
										    top: 0;
										    opacity: 0.5;">
										    <span style="
										    width: 40%;
										    display: block;
										    margin: 0 auto;
										    text-align: center;
										    margin-top: 200px;
										    font-size: 13px;
										    color: #000;
										    font-weight: 600;
										">조회된 항목이 없습니다
						</span></div>
						<div class="chart flItem" style="width:100%;">
							<canvas id="canvas-1_2" style="display: block;width: 1684px;height: 420px;"></canvas>
						</div>
					</div>
			</div>
		</div>
		
		<div class="btBox">
			<span class="r">
				<button type="button" class="xlsDownloadBtn" onclick="downXls<c:out value="${pageId}"/>();" style="margin-bottom:5px;">엑셀다운로드</button>
			</span>
		</div>
		<div class="tbWrap">
		<div class="tbTop">
				<strong>업무처리 건수내역</strong>
			</div>
			<div class="tbCon">
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
	
	<div style="margin-left: 15px;margin-top: 10px;margin-bottom: 10px;">
		<span style="color: #222;font-size: 12px;">업무생성일</span>
		<input type="text" readonly class="cal daterange-basic calSingle" name="performDate" id="performDate" pageid="<c:out value="${pageId}"/>" style="width: 90px;height: 25px;text-align: center;">
		<button type="button" class="performXlsDownBtn" id="xlsDownSet_1" style="width: 140px;">일 주요 성능지표</button>
	</div>
	
</div>
<form id="formXls" method="get"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script src="${ctx_res}/js/stat/charts_analysis.js"></script>
<script>

$(function() {
	initRangeCal();
	initLoadingDisplay("Y", "class", "container");
	
	// 엑셀다운로드 임시
	$(document).on('click', '.performXlsDownBtn', function(){
		
		var urlKey = $(this).attr('id');
		var urlMapper = {
				'xlsDownSet_1' : '/api/inpt/result/analy/xls/daily/performance'
		}
		var urlValue = urlMapper[urlKey];
		var searchOption = {};
		searchOption.schSdate = $("#performDate").val().replace('-', '').replace('-', '');
		
		fnCmnDownXls($('#formXls'), urlValue, searchOption);
	});
});

function downXls<c:out value="${pageId}"/>(){
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	fnCmnDownXls($('#formXls'), '/api/stat/analysis/xls', searchOption);
}

/* function fnReport(displayW, displayH) {
	var form = $("#reportId")[0];
	var test = $("#reportId");
	var startDate = $("#cld_schSdate1_Search_<c:out value="${pageId}"/>").val();
	var endDate = $("#cld_schEdate1_Search_<c:out value="${pageId}"/>").val();
	form.startDate.value = startDate;
	form.startDate2.value = startDate;
	form.startDate3.value = startDate;
	form.endDate.value = endDate;
	form.endDate2.value = endDate;
	form.endDate3.value = endDate;
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = displayW;
	var popupSizeH = displayH;
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
	var resultTop = curY + (clientH / 2); 
	
	window.open('about:blank','winReport','left='+resultLeft+', top=0, width='+popupSizeW+', height='+popupSizeH);
	form.submit();
	return false;
} */

var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/stat/analysis',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-40' },
			{ targets: 1, className: 'td-text-right td-text-60' },
			{ targets: 2, className: 'td-text-right td-text-60' },
			{ targets: 3, className: 'td-text-right td-text-60' },
			{ targets: 4, className: 'td-text-right td-text-60' },
			{ targets: 5, className: 'td-text-right td-text-60' }
		],
		columns: [
	    	{ title: '일자', data: 'day' , render: function(data, type, row, meta){
	    		if(data=='합계(건)' || data=='비율(%)'){
	    			return data;
	    		}else{
	    			return dataFormat(data);
	    		}
	    	}},
	    	{ title: '총 업무건수', data: 'mas' },
	    	{ title: '자동건수', data: 'nomal' },
	    	{ title: '수기등록', data: 'textNonExtr' },
	    	{ title: '저품질',  data: 'aicr' },
	    	{ title: '재추출', data: 'ta' },
	    ],
	    getSearchOption : function() {
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
			var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		
			drawChart(schSdate1, schEdate1);
			options.schSdate1 = schSdate1; 
			options.schEdate1 = schEdate1;
			return options;
		},
		fnRowCallback : function(nRow, aData, iDisplayIndex, iDisplayIndexFull){
			var vrow = $(nRow);
			vrow.find('td').each(function(idx,obj){
				var vtd = $(obj);
				var vtdText = vtd.text();
				
				//합계 컬럼 셀합치기
				if((idx == 0 && $.trim(vtdText)=='합계(건)') || (idx == 0 && $.trim(vtdText)=='비율(%)')){
					vrow.addClass('taskResultSumRow');
				}
			});
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
	<jsp:param name="gridOptionScrollY" value="430" />
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="numColYN" value="false" />
</jsp:include>
