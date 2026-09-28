<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6030_2"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>항목별 통계 [6030]</strong>
		<span class="location">
			<span>통계</span>
			<span>항목별 통계</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
		<div class="tab_menu">
			<a href="#" class="search-tab" data-tab="t1">항목별 통계</a>
			<a href="#" class="search-tab active" data-tab="t2">기간별 추이</a>
		</div>
		<div class="tab_contents">
			<div class="tab_item active" id="t1">
				<div class="tbWrap"></div>
			</div>
			<div class="tab_item" id="t2">
				<div class="tbWrap">
					<form action="">
						<p class="w28">
							<span class="label">대상업무</span>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd1" value="2" checked><label for="inptAtmcBizDscd1">수출</label>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd2" value="1"><label for="inptAtmcBizDscd2">수입</label>
						</p>
						<p class="w34">
							<label for="schSdate1" class="label">대상기간</label>
							<input type="text" class="cal daterange-basic calRange calStd" id="schSdate1" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
							<span class="calLine">~</span>
							<input type="text" class="cal daterange-basic calRange calEd" id="schEdate1" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
						</p>
						<button type="button" class="btType1" id="searchBtn_<c:out value="${dataTableId}"/>">조회</button>
						<p class="w42">
							<label for="inptSanctionNo1" class="label">조건1</label>
							<select id="inptSanctionNo1" title="">
								<option value="">전체</option>
								<c:forEach var="item" items="${inptItemList }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
								</c:forEach>
							</select>
						</p>
					<p class="w42 t1-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t1" >
							<input class="switch-input" type="checkbox" checked="" id="aiInptListChk1">
							<span class="switch-slider" data-checked="텍스트" data-unchecked="리스트"></span>
						</label>
						<input type="text" id="aiInptListText1" class="it t1-switch-form" value="" placeholder=""/>
						<select id="aiInptListId1" title="" class="t1-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42">
						<label for="inptSanctionNo2" class="label">조건2</label>
						<select id="inptSanctionNo2" title="">
							<option value="">전체</option>
							<c:forEach var="item" items="${inptItemList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42 t2-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t2" >
							<input class="switch-input" type="checkbox" checked="" id="aiInptListChk2">
							<span class="switch-slider" data-checked="텍스트" data-unchecked="리스트"></span>
						</label>
						<input type="text" id="aiInptListText2" class="it t2-switch-form" value="" placeholder=""/>
						<select id="aiInptListId2" title="" class="t2-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42">
						<label for="inptSanctionNo3" class="label">조건3</label>
						<select id="inptSanctionNo3" title="">
							<option value="">전체</option>
							<c:forEach var="item" items="${inptItemList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42 t2-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t3" >
							<input class="switch-input" type="checkbox" checked="" id="aiInptListChk3">
							<span class="switch-slider" data-checked="텍스트" data-unchecked="리스트"></span>
						</label>
						<input type="text" id="aiInptListText3" class="it t3-switch-form" value="" placeholder=""/>
						<select id="aiInptListId3" title="" class="t3-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
			<div id="noSrchRstNotice" style="
										display: none;
									    width: 100%;
									    height: 100%;
									    position: absolute;
									    background-color: #fff;
									    left: 0;
									    top: 0;
									    opacity: 0.5;
									            "><span style="
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
				<div class="chart flItem" style="height:420px;">
					<canvas id="canvas-2"></canvas>
				</div>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script>
var chartObj = null;
$(function() {
	
	initRangeCal();
	initLoadingDisplay("Y", "class", "contents");
	
	//탭버튼 클릭시 처리
	$('.search-tab').eq(0).click(function(e){
		dolocateMenu('/stat/item', '403000');
	});
	$('.search-tab').eq(1).trigger('click');
	
	//텍스트 리스트 클릭
	/*
	$(document).on('click','.switch-label', function() {
		var _checked = $(this).find('.switch-input')[0].checked;
		
		$('#aiInptListText1').hide();
		$('#aiInptListId1').hide();
		
		if (_checked) {
			$('#aiInptListText1').show();
		} else {
			$('#aiInptListId1').show();
		}
	});*/
	
	//조건1~5 체크박스 클릭시
	$('.switch-input').change(function(e){
		var _id = $(this).parent().data('switch').replace('t','');
		var _checked = this.checked;
		
		var aiInptListText = $('#aiInptListText'+_id);
		var aiInptListId = $('#aiInptListId'+_id);
		
		aiInptListText.hide();
		aiInptListId.hide();
		
		if(_checked){
			aiInptListText.show();
		} else {
			aiInptListId.show();
		}
	});
	
	//검색버튼 클릭시
	$('#searchBtn_<c:out value="${dataTableId}"/>').click(function(e){
		//검색
		if(validationRangeEvent()){
			fnSearch();
		}else{
			return;
		}
	});
	
	//검색
	setTimeout(function(){
		fnSearch();
	},2000);

	
});
function fnSearch(){

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("6030","02","01",$.param(fnSearchOption()));

	//차트그리기
 	renderChart();
	
}
function fnSearchOption(){
	var opts = {};
	
	opts.inptAtmcBizDscd = $(':radio[name="inptAtmcBizDscd"]:checked').val();
	opts.schSdate1 = $('#schSdate1').val(); // 시작일
	opts.schEdate1 = $('#schEdate1').val(); // 종료일
	
	if($('#aiInptListChk1').prop('checked')){ 
		opts.aiInptListText1 = $('#aiInptListText1').val(); // 리스트 선택하면
		opts.aiInptListChk1 = "0";
	} else {
		opts.aiInptListId1 = $('#aiInptListId1').val(); // 텍스트 선택하면
		opts.aiInptListChk1 = "1";
	}
	
	if($('#aiInptListChk2').prop('checked')){ 
		opts.aiInptListText2 = $('#aiInptListText2').val(); // 리스트 선택하면
		opts.aiInptListChk2 = "0";
	} else {
		opts.aiInptListId2 = $('#aiInptListId2').val(); // 텍스트 선택하면
		opts.aiInptListChk2 = "1";
	}
	
	if($('#aiInptListChk3').prop('checked')){ 
		opts.aiInptListText3 = $('#aiInptListText3').val(); // 리스트 선택하면
		opts.aiInptListChk3 = "0";
	} else {
		opts.aiInptListId3 = $('#aiInptListId3').val(); // 텍스트 선택하면
		opts.aiInptListChk3 = "1";
	}
	
	opts.inptSanctionNo1 = $('#inptSanctionNo1').val(); // 조건 1 선택
	opts.inptSanctionNo2 = $('#inptSanctionNo2').val(); // 조건 2 선택
	opts.inptSanctionNo3 = $('#inptSanctionNo3').val(); // 조건 3 선택
	
	return opts;
	
}
function renderChart(){
	$.get('/api/common/stat/item/move',fnSearchOption(),function(data){
		if(data.resultCode=='200'){
			var chartLabels = [];
			var chartDatas = [];
			var scopeYMax = 0;

			if(data.resultList && data.resultList.length){
				$('#noSrchRstNotice').hide();
				for(var i=0;i<data.resultList.length;i++){
					var row = data.resultList[i];
					chartLabels.push(row.txt);
					chartDatas.push(row.cnt);
				}
			}else{
				$('#noSrchRstNotice').show();
			}
			
			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
			scopeYMax = fnCmnGetArrayMaxItem(chartDatas);

			//차트초기화
			if(chartObj){
				chartObj.destroy();
			}

			//차트그리기
			chartObj = new Chart($('#canvas-2'), {
				type: 'line',
				data: {
					labels: chartLabels,
					datasets: [{
						label: '기간별 추이',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						pointBackgroundColor: 'rgba(000, 000, 255, 0.5)',
						pointBorderColor: 'FFB4B9',
						data: chartDatas
						
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio:false,
					scales: {
						yAxes: [{
							display: true,
							stacked: true,
							ticks: {
								beginAtZero: true,
								suggestedMax: (scopeYMax + 10)		/* 차트 Y축 최대값 범위 지정 */
							}
						}]
					}
				}
			});
		} else {
			fnAlertErrorMsg(data);
		}
	});
}
</script>