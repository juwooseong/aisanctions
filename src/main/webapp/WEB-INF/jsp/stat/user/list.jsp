<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6050"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<c:set var="dataTableId2" value="dataTable2_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>고객별 통계 [6050]</strong>
		<span class="revertStatPageDiscription">특정기간 고객별 거래현황 그래프를 조회하고 Pending/Block 이력을 조회하는 화면</span>
		<span class="location">
			<span>통계</span>
			<span>고객별 통계</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
				<p class="w42">
					<label for="schSdate" class="label">업무생성일</label>
					<input type="text" class="cal calRange calStd statCondCalCustom" id="schSdate" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
					<span class="calLine">~</span>
					<input type="text" class="cal calRange calEd statCondCalCustom" id="schEdate" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
					<span class="noticeMaxSearchSpan">(최대 90일)</span>
				</p>
				<p class="w20">
					<label for="aiInptCsno" class="label">고객번호</label>
					<input type="text" id="aiInptCsno" class="no-it" value="" placeholder="" maxlength="<c:out value="${maxLength_cusno }"/>"/>
				</p>
				<p class="w28">
					<span class="label">업무</span>
					<label for="inptAtmcBizDscd2" id="rsIndx1" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd2" value="1" checked style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx1" for="inptAtmcBizDscd2">수입</label>
					<label for="inptAtmcBizDscd1" id="rsIndx2" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd1" value="2" style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx2" for="inptAtmcBizDscd1">수출</label>
				</p>
				<button type="button" class="searchBtnType1"  onclick="fnSearch();">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="btBox">
			<span class="r">
				<button type="button" class="reportPrintBtn" onclick="fnReport();">
					<i class="icons font-2xl d-block mt-5 cui-print printIcon"></i>
					레포트출력
				</button>
			</span>
		</div>
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>거래국가(상대국)</strong>
				</div>
				<div class="tbCon chartCon">
					<canvas id="canvas-1"></canvas>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>거래상대방</strong>
					<div style="float: right;margin-top: 5px;">
						<label for="chartCount" id="rsIndx11" class="group2 radioSelector radioDeactive"style="margin-left: 7px;"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
						<input class="chart-input" type="radio" name="chartMod" id="chartCount" value="1" style="display:none;">
						<label id="group2" class="radioSelectorLabel rsIndx11" for="chartCount"style="font-size: 12px;vertical-align: middle;">건수</label>
						<label for="chartMoney" id="rsIndx22" class="group2 radioSelector radioActive"style="margin-left: 7px;"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
						<input class="chart-input" type="radio" name="chartMod" id="chartMoney" value="2" checked style="display:none;">
						<label id="group2" class="radioSelectorLabel rsIndx22" for="chartMoney"style="font-size: 12px;vertical-align: middle;">금액</label>
					</div>
				</div>
				<div class="tbCon chartCon">
					<canvas id="canvas-2"></canvas>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>선적항</strong>
				</div>
				<div class="tbCon chartCon">
					<canvas id="canvas-3"></canvas>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>하역항</strong>
				</div>
				<div class="tbCon chartCon">
					<canvas id="canvas-4"></canvas>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>물품</strong>
				</div>
				<div class="tbCon chartCon">
					<canvas id="canvas-5"></canvas>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>거래규모</strong>
				</div>
				<div class="tbCon chartCon">
					<table class="table table-responsive-sm" id="<c:out value="${dataTableId2}"/>"></table>
				</div>
			</div>
		</div>
		<div class="flGroup">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>Pending/Block 이력</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
				</div>
			</div>
		</div>
	</div>
</div>

<form id="formReport" action="/birt/frameset" method="post" target='winReport'>
	<input type="hidden" name="__report" value="report/stat_user.rptdesign">
	<input type="hidden" name="inptAtmcBizDscd" value="">
	<input type="hidden" name="schSdate" value="">
	<input type="hidden" name="schEdate" value="">
	<input type="hidden" name="aiInptCsno" value="">
</form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script>
var chartObj1 = null;
var chartObj2 = null;
var chartObj3 = null;
var chartObj4 = null;
var chartObj5 = null;
var chartdata = [];

$(function(){

	initRangeCal();
	initLoadingDisplay("Y", "class", "container");
});

$('#aiInptCsno').keyup(function(e) {
	
	if(e.keyCode === 13) {
		
		if(!validationRangeEvent()){
			return;
		}
		
		if (!$("#aiInptCsno").val() || $.trim($("#aiInptCsno").val()) == "") {
			alert("고객번호를 입력해주세요");
			return;
		}else{
			fnSearch();
		}
	}
});

$(document).on('change','[name="chartMod"]', function(e) {
	
	if (chartdata.resultList2) {
		if (chartdata.resultList2.length > 0) {
			fnRenderChart2(chartdata);
		}
	}
});

function fnReport() {
	var formReport = $('#formReport')[0];
	
	if(!validationRangeEvent()){
		return;
	}
	
	if (!$("#aiInptCsno").val() || $.trim($("#aiInptCsno").val()) == "") {
		alert("고객번호를 입력해주세요");
		return false;
	}else{
		if(!fnCheckUsingCharForamt(1, $("#aiInptCsno").val())){
			alert("잘못된 고객번호 입니다");
			return false;
		}
	}
	
	formReport.inptAtmcBizDscd.value = $('[name="inptAtmcBizDscd"]:checked').val();
	formReport.aiInptCsno.value = $("#aiInptCsno").val();
	formReport.schSdate.value = $("#schSdate").val();
	formReport.schEdate.value = $("#schEdate").val();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("6050",null,"03",$('#formReport').serialize());
	
	window.open('about:blank','winReport', 'width=780, height=920');
	formReport.submit();
}

function fnSearch(){
	
	if(!validationRangeEvent()){
		return;
	}
	
	if (!$("#aiInptCsno").val() || $.trim($("#aiInptCsno").val()) == "") {
		alert("고객번호를 입력해주세요");
		return false;
	}else{
		if(!fnCheckUsingCharForamt(1, $("#aiInptCsno").val())){
			alert("잘못된 고객번호 입니다");
			return false;
		}
	}
	
	<c:out value="${dataTableId}"/>Config.ajaxUrl = '/api/stat/user/list2';
	<c:out value="${dataTableId2}"/>Config.ajaxUrl = '/api/stat/user/list1';

	//그리드 불러오기
	if(window.<c:out value="${dataTableId2}"/>.searchList){
		<c:out value="${dataTableId2}"/>.searchList();
	}

	//그리드 불러오기
	if(window.<c:out value="${dataTableId}"/>.searchList){
		<c:out value="${dataTableId}"/>.searchList();
	}
	
	//차트표시
	$.get('/api/stat/user/chart?' + $.now(), fnSearchOption(), function(data){
		
		chartdata = data;
		
		fnRenderChart1(data);
		fnRenderChart2(data);
		fnRenderChart3(data);
		fnRenderChart4(data);
		fnRenderChart5(data);
	});
}
function fnSearchOption(){
	var options = {};
	
	var inptAtmcBizDscd = $('[name="inptAtmcBizDscd"]:checked').val();
	var aiInptCsno = $("#aiInptCsno").val();
	var schSdate = $("#schSdate").val();
	var schEdate = $("#schEdate").val();
	
	options.inptAtmcBizDscd = inptAtmcBizDscd;
	options.aiInptCsno = aiInptCsno;
	options.schSdate = schSdate; 
	options.schEdate = schEdate;
	
	//프로그램 사용 이력 로그누적
	options.aiInptCnctScrnNo = "6050",
	options.aiInptCnctFldCd = null,
	options.aiInptCnctActiCd = "01",
	options.aiInptCnctParmTxt = $.param(options)
	
	return options;
}
function fnRenderChart1(data){
	
	//차트초기화
	if(chartObj1){
		chartObj1.destroy();
	}
	
	if(data && data.resultCode=='200'){
		var resultList = data.resultList1;
		var chartDataCnt = 0;
		var chartLabels = [];
		var chartLabelsOrg = [];
		var chartDatas = [];
		var scopeYMax = 0;
		var totoal = 0;
		
		//X축, Y축, 텍스트와 건수 설정
		if(resultList && resultList.length){
			chartDataCnt = resultList.length;
			for(var i=0;i<chartDataCnt;i++){
				var row = resultList[i];
				chartLabels.push(row.title);
				chartLabelsOrg.push(row.title);
				chartDatas.push(row.totCnt);
				totoal += parseInt(row.totCnt);
			}
		}
		
		//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
		scopeYMax = fnCmnGetArrayMaxItem(chartDatas);

		//X축 텍스트, 글자수 제한
		if(chartLabels && chartDataCnt > 0){
			for(var i=0;i<chartDataCnt;i++){
				chartLabels[i] = fnCmnCutStr(chartLabels[i],15);
			}
		} else {
			chartLabels.push('건수');
			chartDatas.push(0);
		}

		//차트그리기
		chartObj1 = new Chart($('#canvas-1'), {
			  type: 'pie',
			  data: {
			    labels: chartLabels,
			    datasets: [{
			      	data: chartDatas,
			      	backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#3366CC', '#DC3912', 
			      		              '#FF9900', '#109618', '#990099', '#3B3EAC', '#0099C6', 
			      		              '#DD4477', '#66AA00', '#B82E2E', '#316395', '#994499',
			      		              '#22AA99', '#AAAA11', '#6633CC', '#E67300', '#E67300',],
			      	hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#3366CC', '#DC3912', 
    		             				   '#FF9900', '#109618', '#990099', '#3B3EAC', '#0099C6', 
      		             				   '#DD4477', '#66AA00', '#B82E2E', '#316395', '#994499',
      		             				   '#22AA99', '#AAAA11', '#6633CC', '#E67300', '#E67300',],
			    }]
			},
			options: {
				maintainAspectRatio: false,
				tooltips: {
					callbacks: {
						label : function(tooltipItem, data) {
							return chartLabelsOrg[tooltipItem.index] + " : " + fnNumberCommaFormat(data.datasets[0].data[tooltipItem.index] / totoal * 100) + "%";
						}
					}
				}
			}
		});
	} else {
		fnAlertErrorMsg(data);
	}
}
function fnRenderChart2(data){
	
	console.log(data);
	
	//차트초기화
	if(chartObj2){
		chartObj2.destroy();
	}
	
	if(data && data.resultCode=='200'){
		var resultList = data.resultList2;
		var chartDataCnt = 0;
		var chartDataCnt2 = 0;
		var chartLabels = [];
		var chartLabelsOrg = [];
		var chartDatas = [];
		var chartDatas2 = [];
		var scopeYMax = 1;
		var scopeYMax2 = 1;
		var stepSize = 1;
		var stepSize2 = 1;
		
		//리스트1 : X축, Y축, 텍스트와 건수 설정
		if(resultList && resultList.length){
			chartDataCnt = resultList.length;
			for(var i=0;i<chartDataCnt;i++){
				var row = resultList[i];
				chartLabels.push(row.title);
				chartLabelsOrg.push(row.title);
				chartDatas.push(row.totCnt);
				chartDatas2.push(row.aiInptBuyAm);
			}
		}
		
		//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
		scopeYMax = fnCmnGetArrayMaxItem(chartDatas);
		scopeYMax2 = fnCmnGetArrayMaxItem(chartDatas2);
		stepSize = ((scopeYMax / 4) > 1) ? (scopeYMax / 4) : scopeYMax;
		stepSize2 = ((scopeYMax2 / 4) > 1) ? (scopeYMax2 / 4) : scopeYMax2;
		
		//X축 텍스트, 글자수 제한
		if(chartLabels && chartDataCnt > 0){
			for(var i=0;i<chartDataCnt;i++){
				chartLabels[i] = fnCmnCutStr(chartLabels[i],15);
			}
		} else {
			
			if (chartObj2) {
				chartObj2.destroy();
			}
			
			return false;
		}
		
		var _label = "";
		var _chartDatas = [];
		var _chartMod = $('[name="chartMod"]:checked').val();
		
		if (_chartMod == "1") {
			_label = "건수";
			_chartDatas = chartDatas;
			scopeYMax = scopeYMax;
			stepSize = stepSize;
		} else {
			_label = "금액 ($)";
			_chartDatas = chartDatas2;
			scopeYMax = scopeYMax2;
			stepSize = stepSize2;
		}
		
		//차트그리기
		chartObj2 = new Chart($('#canvas-2'), {
			  type: 'horizontalBar',
			  data: {
			    labels: chartLabels,
			    datasets: [{
				  	label: _label,
				  	backgroundColor: 'rgba(255, 0, 0, 0.5)',
				  	borderColor: 'rgba(255, 0, 0, 0.5)',
				 	highlightFill: 'rgba(700, 287, 585, 0.35)',
				 	highlightStroke: 'rgba(700, 287, 585, 1)',
			      	data: _chartDatas,
			    }]
			  },
			  options: {
				maintainAspectRatio: false,
			    scales: {
					xAxes: [{
						ticks:{
							stepSize: stepSize,
							beginAtZero: true,
							suggestedMax: (scopeYMax + 1),
							callback: function(value, index, values) {
								
								if (_chartMod == "1") {
									return value;
								} else {
									return Math.floor(value / 1000) * 1000;
								}
							}
						}
					}]
				},
				tooltips: {
					cornerRadius: 5,
					callbacks: {
						label : function(tooltipItem, data) {
							
							return _label + " : " + fnNumberCommaFormat(data.datasets[0].data[tooltipItem.index]);

						},
						title : function(tooltipItem, data) {
							
							var _labelArr = [];
							var _label = chartLabelsOrg[tooltipItem[0].index];
							
							if (_label.length > 30) {
								
								var _mod = Math.ceil(_label.length / 30);
								
								for (var i = 0; i < _mod; i ++) {
									
									if (i == _mod - 1) {
										_labelArr.push(_label.substr((i) * 30));
									} else {
										_labelArr.push(_label.substr(i * 30, 30));
									}
								}
							} else {
								_labelArr.push(_label);
							}
							
							return _labelArr;

						}
					}
				}
			}
		});
	} else {
		fnAlertErrorMsg(data);
	}
	
}
function fnRenderChart3(data){
	
	//차트초기화
	if(chartObj3){
		chartObj3.destroy();
	}

	if(data && data.resultCode=='200'){
		var resultList = data.resultList3;
		var chartDataCnt = 0;
		var chartLabels = [];
		var chartLabelsOrg = [];
		var chartDatas = [];
		var scopeYMax = 1;
		var stepSize = 1;

		//X축, Y축, 텍스트와 건수 설정
		if(resultList && resultList.length){
			chartDataCnt = resultList.length;
			for(var i=0;i<chartDataCnt;i++){
				var row = resultList[i];
				chartLabels.push(row.title);
				chartLabelsOrg.push(row.title);
				chartDatas.push(row.totCnt);
			}
		}

		//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
		scopeYMax = fnCmnGetArrayMaxItem(chartDatas);
		stepSize = ((scopeYMax / 4) > 1) ? (scopeYMax / 4) : scopeYMax;

		//X축 텍스트, 글자수 제한
		if(chartLabels && chartDataCnt > 0){
			for(var i=0;i<chartDataCnt;i++){
				chartLabels[i] = fnCmnCutStr(chartLabels[i],15);
			}
		} else {
			
			if (chartObj3) {
				chartObj3.destroy();
			}
			
			return false;
		}
		
		//차트그리기
		chartObj3 = new Chart($('#canvas-3'), {
			type: 'horizontalBar',
			data: {
			labels: chartLabels,
				datasets: [{
				  	label: '선적항 (건수)',
				  	backgroundColor: 'rgba(000, 000, 255, 0.5)',
				  	borderColor: 'rgba(000, 000, 255, 0.5)',
				  	highlightFill: 'rgba(151, 187, 205, 0.75)',
				  	highlightStroke: 'rgba(151, 187, 205, 1)',
			      	data: chartDatas
				}]
			},
			options: {
				maintainAspectRatio: false,
				scales: {
					xAxes: [{
						ticks:{
							stepSize: stepSize,
							beginAtZero: true,
							suggestedMax: (scopeYMax + 1)		/* 차트 Y축 최대값 범위 지정 */
						}
					}]
				},
				tooltips: {
					cornerRadius: 5,
					callbacks: {
						label : function(tooltipItem, data) {
							
							return "선적항 (건수) : " + data.datasets[0].data[tooltipItem.index];

						},
						title : function(tooltipItem, data) {
							
							var _labelArr = [];
							var _label = chartLabelsOrg[tooltipItem[0].index];
							
							if (_label.length > 30) {
								
								var _mod = Math.ceil(_label.length / 30);
								
								for (var i = 0; i < _mod; i ++) {
									
									if (i == _mod - 1) {
										_labelArr.push(_label.substr((i) * 30));
									} else {
										_labelArr.push(_label.substr(i * 30, 30));
									}
								}
							} else {
								_labelArr.push(_label);
							}
							
							return _labelArr;

						}
					}
				}
			}
		});
	} else {
		fnAlertErrorMsg(data);
	}
	
}
function fnRenderChart4(data){
	
	//차트초기화
	if(chartObj4){
		chartObj4.destroy();
	}

	if(data && data.resultCode=='200'){
		var resultList = data.resultList4;
		var chartDataCnt = 0;
		var chartLabels = [];
		var chartLabelsOrg = [];
		var chartDatas = [];
		var scopeYMax = 1;
		var stepSize = 1;

		//X축, Y축, 텍스트와 건수 설정
		if(resultList && resultList.length){
			chartDataCnt = resultList.length;
			for(var i=0;i<chartDataCnt;i++){
				var row = resultList[i];
				chartLabels.push(row.title);
				chartLabelsOrg.push(row.title);
				chartDatas.push(row.totCnt);
			}
		}

		//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
		scopeYMax = fnCmnGetArrayMaxItem(chartDatas);
		stepSize = ((scopeYMax / 4) > 1) ? (scopeYMax / 4) : scopeYMax;
	

		//X축 텍스트, 글자수 제한
		if(chartLabels && chartDataCnt > 0){
			for(var i=0;i<chartDataCnt;i++){
				chartLabels[i] = fnCmnCutStr(chartLabels[i],15);
			}
		} else {
			
			if (chartObj4) {
				chartObj4.destroy();
			}
			
			return false;
		}
		
		//차트그리기
		chartObj4 = new Chart($('#canvas-4'), {
			type: 'horizontalBar',
			data: {
				labels: chartLabels,
			    datasets: [{
				  	label: '하역항 (건수)',
				  	backgroundColor: 'rgba(000, 000, 255, 0.5)',
				  	borderColor: 'rgba(000, 000, 255, 0.5)',
				  	highlightFill: 'rgba(151, 187, 205, 0.75)',
				  	highlightStroke: 'rgba(151, 187, 205, 1)',
			      	data: chartDatas
			    }]
			},
			options: {
				maintainAspectRatio: false,
				scales: {
					xAxes: [{
						ticks:{
							stepSize: stepSize,
							beginAtZero: true,
							suggestedMax: (scopeYMax + 1)		/* 차트 Y축 최대값 범위 지정 */
						}
					}]
				},
				tooltips: {
					cornerRadius: 5,
					callbacks: {
						label : function(tooltipItem, data) {
							
							return "하역항 (건수) : " + data.datasets[0].data[tooltipItem.index];

						},
						title : function(tooltipItem, data) {
							
							var _labelArr = [];
							var _label = chartLabelsOrg[tooltipItem[0].index];
							
							if (_label.length > 30) {
								
								var _mod = Math.ceil(_label.length / 30);
								
								for (var i = 0; i < _mod; i ++) {
									
									if (i == _mod - 1) {
										_labelArr.push(_label.substr((i) * 30));
									} else {
										_labelArr.push(_label.substr(i * 30, 30));
									}
								}
							} else {
								_labelArr.push(_label);
							}
							
							return _labelArr;

						}
					}
				}
			}
		});
		
	} else {
		fnAlertErrorMsg(data);
	}
	
}
function fnRenderChart5(data){
	
	//차트초기화
	if(chartObj5){
		chartObj5.destroy();
	}

	if(data && data.resultCode=='200'){
		var resultList = data.resultList5;
		var chartDataCnt = 0;
		var chartLabels = [];
		var chartLabelsOrg = [];
		var chartDatas = [];
		var scopeYMax = 1;
		var stepSize = 1;
		
		//X축, Y축, 텍스트와 건수 설정
		if(resultList && resultList.length){
			chartDataCnt = resultList.length;
			for(var i=0;i<chartDataCnt;i++){
				var row = resultList[i];
				chartLabels.push(row.title);
				chartLabelsOrg.push(row.title);
				chartDatas.push(row.totCnt);
			}
		}
		
		//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
		scopeYMax = fnCmnGetArrayMaxItem(chartDatas);
		stepSize = ((scopeYMax / 4) > 1) ? (scopeYMax / 4) : scopeYMax;
		
		//X축 텍스트, 글자수 제한
		if(chartLabels && chartDataCnt > 0){
			for(var i=0;i<chartDataCnt;i++){
				chartLabels[i] = fnCmnCutStr(chartLabels[i],15);
			}
		} else {
			
			if (chartObj5) {
				chartObj5.destroy();
			}
			
			return false;
		}
		
		//차트그리기
		chartObj5 = new Chart($('#canvas-5'), {
			type: 'horizontalBar',
			data: {
				labels: chartLabels,
			    datasets: [{
				  	label: '물품 (건수)',
				  	backgroundColor: 'rgba(000, 000, 255, 0.5)',
				  	borderColor: 'rgba(000, 000, 255, 0.5)',
				  	highlightFill: 'rgba(151, 187, 205, 0.75)',
				  	highlightStroke: 'rgba(151, 187, 205, 1)',
			      	data: chartDatas
			    }]
			},
			options: {
				maintainAspectRatio: false,
				scales: {
					xAxes: [{
						ticks:{
							stepSize: stepSize,
							beginAtZero: true,
							suggestedMax: (scopeYMax + 1)		/* 차트 Y축 최대값 범위 지정 */
						}
					}]
				},
				tooltips: {
					cornerRadius: 5,
					callbacks: {
						label : function(tooltipItem, data) {
							
							return "물품 (건수) : " + data.datasets[0].data[tooltipItem.index];

						},
						title : function(tooltipItem, data) {
							
							var _labelArr = [];
							var _label = chartLabelsOrg[tooltipItem[0].index];
							
							if (_label.length > 30) {
								
								var _mod = Math.ceil(_label.length / 30);
								
								for (var i = 0; i < _mod; i ++) {
									
									if (i == _mod - 1) {
										_labelArr.push(_label.substr((i) * 30));
									} else {
										_labelArr.push(_label.substr(i * 30, 30));
									}
								}
							} else {
								_labelArr.push(_label);
							}
							
							return _labelArr;

						}
					}
				}
			}
		});
		
	} else {
		fnAlertErrorMsg(data);
	}
	
}
var <c:out value="${dataTableId}"/>Config = {
// 	ajaxUrl : '/api/stat/user/list2',
	ajaxUrl : '',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-left td-text-60' },
		{ targets: 3, className: 'td-text-center td-text-60' },
		{ targets: 4, className: 'td-text-right td-text-60' },
		{ targets: 5, className: 'td-text-left td-text-60' },
	],
	columns: [
    	{ title: '생성일', data: 'inptRcpDt', render: function(data, type, row, meta){return dataFormat(data);}},
    	{ title: 'Ref.No', data: 'actlFxRefno' },
    	{ title: '통화', data: 'fcCucd' },
    	{ title: '금액', data: 'aiInptBuyAm', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    	{ title: '액티비티', data: 'aiInptAcvtNm' },
    ],
    //검색정의
    getSearchOption : function() {
		return fnSearchOption();
	}
};
var <c:out value="${dataTableId2}"/>Config = {
// 	ajaxUrl : '/api/stat/user/list1',
	ajaxUrl : '',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-60' },
		{ targets: 2, className: 'td-text-right td-text-60' },
		{ targets: 3, className: 'td-text-right td-text-60' }
	],
	columns: [
    	{ title: '월별', data: 'inptRcpYm' },
    	{ title: '거래건', data: 'cnt' },
    	{ title: '금액', data: 'aiInptBuyAm', render: function(data, type, row, meta){ return fnNumberCommaFormat(data) }},
    ],
    //검색정의
    getSearchOption : function() {
		return fnSearchOption();
	}
		
};
</script>

<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="false" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="300" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="false" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="240" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>