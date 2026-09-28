<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6030_1"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>항목별 통계 [6030]</strong>
		<span class="revertStatPageDiscription">특정기간 심사항목별/기간별 조건별 거래건수를 그래프로 조회하는 화면</span>
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
			<a href="#" class="search-tab active" data-tab="t1">항목별 통계</a>
			<a href="#" class="search-tab" data-tab="t2">기간별 추이</a>
		</div>
		<div class="tab_contents" style="padding: 10px 0px;">
			<div class="tab_item active" id="t1">
				<div class="tbWrap">
					<form action="">
						<p class="w28">
							<span class="label">대상업무</span>
							<label for="inptAtmcBizDscd1" id="rsIndx1" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd1" value="2" checked style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx1" for="inptAtmcBizDscd1">수출</label>
							<label for="inptAtmcBizDscd2" id="rsIndx2" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd2" value="1" style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx2" for="inptAtmcBizDscd2">수입</label>
						</p>
						<p class="w34">
							<span class="label">업무생성일</span>
							<input type="text" class="cal daterange-basic calRange calStd statCalStd" name="schSdate1" value="" pageid="6030_1" placeholder=""/>
							<span class="calLine">~</span>
							<input type="text" class="cal daterange-basic calRange calEd statCalEd" name="schEdate1" value="" pageid="6030_1" placeholder=""/>
							<span class="noticeMaxSearchSpan">(최대 90일)</span>
						</p>
						<button type="button" class="searchBtnType1" name="searchBtn_<c:out value="${dataTableId}"/>">
							<i class="fa fa-search searchBtn"></i>
							조회
						</button>
					<p class="w42">
					<label for="inptSanctionNo11" class="label">조건1</label>
					<select name="inptSanctionNo1" id="inptSanctionNo11" title="">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptItemList }">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
						</c:forEach>
					</select>
					</p>
					<p class="w42 t1-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t1" >
							<select class="cond-select" name="aiInptListChk1" style="position: absolute;">
								<option value="0">텍스트</option>
								<option value="1">리스트</option>
							</select>
						</label>
						<input type="text" name="aiInptListText1" class="it t1-switch-form" value="" placeholder=""/>
						<select name="aiInptListId1" title="" class="t1-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42">
						<label for="inptSanctionNo12" class="label">조건2</label>
						<select name="inptSanctionNo2" id="inptSanctionNo12" title="">
							<option value="">전체</option>
							<c:forEach var="item" items="${inptItemList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42 t2-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t2" >
							<select class="cond-select" name="aiInptListChk2" style="position: absolute;">
								<option value="0">텍스트</option>
								<option value="1">리스트</option>
							</select>
						</label>
						<input type="text" name="aiInptListText2" class="it t2-switch-form" value="" placeholder=""/>
						<select name="aiInptListId2" title="" class="t2-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
						
						<p class="w28">
							<label for="inptSanctionNoExp1" class="label">x축</label>
							<select id="inptSanctionNoExp1" name="inptSanctionNoExp"  title="">
								<option value="">선택</option>
								<c:forEach var="item" items="${inptItemExpList }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
								</c:forEach>
							</select>
							<select id="inptSanctionNoImp" name="inptSanctionNoImp" title="" style="display:none;">
								<option value="">선택</option>
								<c:forEach var="item" items="${inptItemImpList }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
								</c:forEach>
							</select>
						</p>
					</form>
				</div>
			</div>
			<div class="tab_item" id="t2">
				<div class="tbWrap">
				
				<form action="">
					
						<p class="w28">
							<span class="label">대상업무</span>
							<label for="inptAtmcBizDscd12" id="rsIndx11" class="group2 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd12" value="2" checked style="display:none;"><label id="group2" class="radioSelectorLabel rsIndx11" for="inptAtmcBizDscd12">수출</label>
							<label for="inptAtmcBizDscd22" id="rsIndx22" class="group2 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
							<input type="radio" name="inptAtmcBizDscd" id="inptAtmcBizDscd22" value="1" style="display:none;"><label id="group2" class="radioSelectorLabel rsIndx22" for="inptAtmcBizDscd22">수입</label>
						</p>
						<p class="w34">
							<span class="label">업무생성일</span>
							<input type="text" class="cal daterange-basic calRange calStd moveCalStd" name="schSdate1" value="" pageid="6030_2" placeholder=""/>
							<span class="calLine">~</span>
							<input type="text" class="cal daterange-basic calRange calEd moveCalEd" name="schEdate1" value="" pageid="6030_2" placeholder=""/>
							<span class="noticeMaxSearchSpan">(최대 30일)</span>
						</p>
						<button type="button" class="searchBtnType1" name="searchBtn_dataTable_6030_2">
							<i class="fa fa-search searchBtn"></i>
							조회
						</button>
						
						
						<p class="w42">
					<label for="inptSanctionNo21" class="label">조건1</label>
					<select id="inptSanctionNo21"  name="inptSanctionNo1" title="">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptItemList }">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
						</c:forEach>
					</select>
					</p>
					<p class="w42 t1-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t1" >
							<select class="cond-select" name="aiInptListChk1" style="position: absolute;">
								<option value="0">텍스트</option>
								<option value="1">리스트</option>
							</select>
						</label>
						<input type="text" id="aiInptListText1" name="aiInptListText1" class="it t1-switch-form" value="" placeholder=""/>
						<select id="aiInptListId1" name="aiInptListId1" title="" class="t1-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42">
						<label for="inptSanctionNo22" class="label">조건2</label>
						<select name="inptSanctionNo2"  name="inptSanctionNo22" title="">
							<option value="">전체</option>
							<c:forEach var="item" items="${inptItemList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42 t2-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t2" >
							<select class="cond-select" name="aiInptListChk2" style="position: absolute;">
								<option value="0">텍스트</option>
								<option value="1">리스트</option>
							</select>
						</label>
						<input type="text" name="aiInptListText2" class="it t2-switch-form" value="" placeholder=""/>
						<select name="aiInptListId2" title="" class="t2-switch-form" style="display:none;">
							<option value="">전체</option>
							<c:forEach var="item" items="${watchList }">
							<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42">
						<label for="inptSanctionNo32" class="label">조건3</label>
						<select id="inptSanctionNo32" name="inptSanctionNo3" title="">
							<option value="">전체</option>
							<c:forEach var="item" items="${inptItemList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
							</c:forEach>
						</select>
					</p>
					<p class="w42 t2-switch-check">
						<label class="label switch switch-label switch-primary" data-switch="t3" >
							<select class="cond-select" name="aiInptListChk3" style="position: absolute;">
								<option value="0">텍스트</option>
								<option value="1">리스트</option>
							</select>
						</label>
						<input type="text" id="aiInptListText3" name="aiInptListText3" class="it t3-switch-form" value="" placeholder=""/>
						<select name="aiInptListId3" title="" class="t3-switch-form" style="display:none;">
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
				<div id="noSrchRstNotice1" class="noSrchRstNotice">
					<span class="noSrchRstNoticeSpan">조회된 항목이 없습니다</span>
				</div>
				<div id="noSrchRstNotice2" class="noSrchRstNotice" style="display:none;">
					<span class="noSrchRstNoticeSpan">조회된 항목이 없습니다</span>
				</div>
				<div class="chart flItem" style="height:420px;">
					<canvas id="canvas-1"></canvas>
					<canvas id="canvas-2" style="display:none;"></canvas>
				</div>
				<div id="mapArea"><%@include file="/WEB-INF/jsp/common/map.jsp"%></div>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script>
var t1_chartObj = null;
$(function() {
	initRangeCal();
	initLoadingDisplay("Y", "class", "contents");
	
	//조건1~5 체크박스 클릭시
	$("#t1 form").find('.cond-select').change(function(e){
		var _id = $(this).parent().data('switch').replace('t','');
		//var _checked = this.checked;
		var _thisVal = $(this).val();
		
		var aiInptListText = $("#t1 form").find('[name=aiInptListText'+_id+']');
		var aiInptListId = $("#t1 form").find('[name=aiInptListId'+_id+']');
		
		aiInptListText.hide();
		aiInptListId.hide();
		
		if(_thisVal == "0"){
			aiInptListText.show();
		} else if(_thisVal == "1") {
			aiInptListId.show();
		}
	});
	
	//탭버튼 클릭시 처리
	$('.search-tab').eq(0).click(function(e){
		//검색
		$('#canvas-1').css('display','block');
		$('#noSrchRstNotice1').css('display','block');
		$('#canvas-2').css('display','none');
		$('#noSrchRstNotice2').css('display','none');
		
		// 1204 이후 항목별통계와 기간별추이가 하나의 화면을 쓰므로 두 화면 모두 유효성검증을 하기 위해  아래를 추가함
		$('.statCalStd').addClass('calStd');
		$('.statCalStd').addClass('cal');
		$('.statCalEd').addClass('calEd');
		$('.statCalEd').addClass('cal');
		$('.moveCalStd').removeClass('calStd');
		$('.moveCalStd').removeClass('cal');
		$('.moveCalEd').removeClass('calEd');
		$('.moveCalEd').removeClass('cal');

		// 1204 이후 항목별통계와 기간별추이가 하나의 화면을 쓰므로 제재국가 지도를 출력하기 위해 아래를 추가함
		if($('#graph').hasClass('activeMapGraph')){
			$('#graph').show();
		}
	});
	
	// 여기
	/*
	$("#t1 form").find('[name="inptAtmcBizDscd"]').change(function(e){
		t1_fnGetInptSanctionNoObj(this,true).show();
	});*/
	
	/*
	//텍스트 리스트 클릭
	$('.switch-label').click(function(e){
		var _checked = $(this).find('.switch-input')[0].checked;
		
		$('#aiInptListText1').hide();
		$('#aiInptListId1').hide();
		
		if (_checked) {
			$('#aiInptListText1').show();
		} else {
			$('#aiInptListId1').show();
		}
	});*/
	
	//검색버튼 클릭시
	$("#t1 form").find('[name=searchBtn_<c:out value="${dataTableId}"/>]').click(function(e){
		
		// #1 날짜범위 validation
		// #2 X축선택 validation
		if(validationRangeEvent()){
			if($("#t1 form").find('[name=inptSanctionNoExp]').val() != ""){
				t1_fnSearch();
			}else{
				alert('X 축 항목을 선택해주세요');
				return;
			}
		}else{
			return;
		}
		
	});
	
});

// 통계화면 조회조건들을 선택으로 선택했을 때 해당하는 텍스트와 리스트를 비활성화처리 
function statCondDisable(idx){
	
}

// 통계화면 조회 시 조건이 전체가 아닌데 조회값이 없으면 조회X
function statCondEmptyValidation(){
	
}

function chang() {
	var values = document.getElementsByName("selectBox");
	if($("#t1 form").find('[name=inptSanctionNo2]').val() == 'choose'){
		console.log("choose");
		$("#t1 form").find('[name=aiInptListText2]').prop('disabled',true);
	}else{
		console.log("not choose");
		$("#t1 form").find('[name=aiInptListText2]').prop('disabled',false);
	}
}

//X축, 선택박스 객체 반환. 대상업무 선택에 따라서.
//isInit : 선택박스 전체 안보이게 초기화 여부. boolean(true/false), true : 초기화, false(기본) : 초기화 안함.
//selObj : 현재 클릭한 라디오 버튼 객체(jquery 객체아님), 널이면 알아서, change 이벤트에선 this.
function t1_fnGetInptSanctionNoObj(selObj,isInit){
	var inptAtmcBizDscd = selObj ? selObj.value : $("#t1 form").find('[name="inptAtmcBizDscd"]:checked').val();
	var inptSanctionNoExp = $("#t1 form").find('[name=inptSanctionNoExp]');
	var inptSanctionNoImp = $("#t1 form").find('[name=inptSanctionNoImp]');
	
	if(isInit===true){
		inptSanctionNoExp.hide();
		inptSanctionNoExp[0].options[0].selected = true;
		inptSanctionNoImp.hide();
		inptSanctionNoImp[0].options[0].selected = true;
	}
	
	if(inptAtmcBizDscd=='1'){	//수입
		return inptSanctionNoImp;
	} else {					//수출
		return inptSanctionNoExp;
	}
}




function t1_fnSearch(){

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("6030","01","01",$.param(t1_fnSearchOption()));

	//차트그리기
 	t1_renderChart();
	
}
function t1_fnSearchOption(){
	var opts = {};
	
	opts.inptAtmcBizDscd = $("#t1 form").find(':radio[name="inptAtmcBizDscd"]:checked').val();
	opts.schSdate1 = $("#t1 form").find('[name=schSdate1]').val(); // 시작일
	opts.schEdate1 = $("#t1 form").find('[name=schEdate1]').val(); // 종료일
	//opts.inptSanctionNo1 = $('#inptSanctionNo1').val(); // 대상거래 모수 
	
	//if($("#t1 form").find('[name=aiInptListChk1]').prop('checked')){
	if($("#t1 form").find('[name=aiInptListChk1]').val() == "0"){		
		opts.aiInptListText1 = $("#t1 form").find('[name=aiInptListText1]').val(); // 리스트 선택하면
		opts.aiInptListChk1 = "0";
	} else {
		opts.aiInptListId1 = $("#t1 form").find('[name=aiInptListId1]').val(); // 텍스트 선택하면
		opts.aiInptListChk1 = "1";
	}
	
	if($("#t1 form").find('[name=aiInptListChk2]').val() == "0"){ 
		opts.aiInptListText2 = $("#t1 form").find('[name=aiInptListText2]').val(); // 리스트 선택하면
		opts.aiInptListChk2 = "0";
	} else {
		opts.aiInptListId2 = $("#t1 form").find('[name=aiInptListId2]').val(); // 텍스트 선택하면
		opts.aiInptListChk2 = "1";
	}
	
	opts.inptSanctionNo1 = $("#t1 form").find('[name=inptSanctionNo1]').val(); // 조건 1 선택
	//opts.aiInptListText1 = $('#aiInptListText2').val(); // 조건 1 텍스트(기존화면방식)
	opts.inptSanctionNo2 = $("#t1 form").find('[name=inptSanctionNo2]').val(); // 조건 2 선택
	//opts.aiInptListText2 = $('#aiInptListText2').val(); // 조건 2 텍스트(기존화면방식)
	//opts.inptSanctionNo3 = t1_fnGetInptSanctionNoObj().val(); //inptSanctionNoExp 수출인경우 inptSanctionNoImp 수입인경우
	
	opts.inptSanctionNo3 = $("#t1 form").find('[name=inptSanctionNoExp]').val(); // X 축 선택
	
	
	return opts;
}
function t1_renderChart(){
	$.get('/api/common/stat/item?' + $.now(),t1_fnSearchOption(),function(data){
		if(data.resultCode=='200'){
			var chartDataCnt = 0;
			var chartLabels = [];
			var chartDatas = [];
			var scopeYMax = 0;
			var chartStepSize = 0;
			
			//X축, Y축, 텍스트와 건수 설정
			if(data.resultList && data.resultList.length){
				$('#noSrchRstNotice1').addClass('noSrchRstNoticeDeactive');
				chartDataCnt = data.resultList.length;
				
				
				for(var i=0;i<data.resultList.length;i++){
					var row = data.resultList[i];
					chartLabels.push(row.txt);
					chartDatas.push(row.cnt);
					
				}
			}else{
				chartStepSize = 1;
				$('#noSrchRstNotice1').removeClass('noSrchRstNoticeDeactive')
				$('#noSrchRstNotice1').show();
			}

			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
			scopeYMax = fnCmnGetArrayMaxItem(chartDatas);

			chartStepSize = Math.round(scopeYMax / 10);
			if(chartStepSize < 1){
				chartStepSize = 1;
			}
			

			
			
			//X축 텍스트, 글자수 제한
			if(chartLabels && chartDataCnt > 0){
				for(var i=0;i<chartDataCnt;i++){
					var txt = chartLabels[i] ? chartLabels[i] : '';
					
					if(chartDataCnt > 10){
						txt = fnCmnCutStr(txt,20,'..');
					} else if(5 <= chartDataCnt && chartDataCnt <= 10){
						txt = fnCmnCutStr(txt,30,'..');
					} else {
						txt = fnCmnCutStr(txt,50,'..');
					}
					
					chartLabels[i] = txt;
				}
			}
			
			//차트초기화
			if(t1_chartObj){
				t1_chartObj.destroy();
			}

			//차트출력
			t1_chartObj = new Chart($('#canvas-1'), {
				type: 'bar',
				data: {
					labels: chartLabels,
					datasets: [{
						label: '항목별 통계',
						backgroundColor: 'rgba(000, 000, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						highlightFill: 'rgba(151, 187, 205, 0.75)',
						highlightStroke: 'rgba(151, 187, 205, 1)',
						data: chartDatas
						
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio:false,
					scaleShowValues:true,
					/*
					tooltips: {
						callbacks: {
							label : function(tooltipItem, data) {
								return chartLabelsOrg[tooltipItem.index]; // + " : " + fnNumberCommaFormat(data.datasets[0].data[tooltipItem.index] / totoal * 100) + "%";
							}
						}
					},*/
					scales: {
						xAxes: [{
							ticks:{
								autoSkip: false
							}
						}],
						yAxes: [{
							display: true,
							stacked: true,
							ticks: {
								stepSize: chartStepSize,
								beginAtZero: true,
								suggestedMax: (scopeYMax + 1)		/* 차트 Y축 최대값 범위 지정 */
							}
						}]
					}
				}
			});
		} else {
			t1_fnAlertErrorMsg(data);
		}
		
		//세계지도 그리기
		//renderMap(data);
	});
}
function renderMap(data){
	$('#graph').removeClass('activeMapGraph');
	$('#graph').hide();		//세계지도 안보이게.
	
	var mapInptSanctionNos = ['10','18','22','26','31','36','41','46','49','56','59','62','65','69','73','77','81','85','92','96'];							//지도맵 표시할 심사항목코드(국가코드만)
	var inptSanctionNoExp = $('#inptSanctionNoExp1').val();		//X축 심사항목코드(수출)
	var inptSanctionNoImp = $('#inptSanctionNoImp').val();		//X축 심사항목코드(수입)
	
	//세계지도에 수출입 건수 표시 점 텍스트 표시 정보, 초기화.
	g_ex_im_data = [];
	
	if(data.resultCode=='200' && data.resultList && data.resultList.length){
		for(var i=0;i<data.resultList.length;i++){
			var dataRow = data.resultList[i];
			var row = [];
			
			row.push(dataRow.nacd);								//국가코드(NACD)
			row.push(dataRow.txt3);								//국가 한글명
			row.push(dataRow.txt2);								//국가 영문명
			row.push([dataRow.expCnt,dataRow.impCnt]);			//국가 수출입 건수, [수입건수,수출건수]
			
			g_ex_im_data.push(row);
		}
	}
	
	fn_draw_country_data(g_ex_im_data);
	
	//"~ Country Code" X축 항목코드가 선택되었을때만 세계지도를 표시하도록.
	
	if($.inArray(inptSanctionNoExp,mapInptSanctionNos) > -1 || $.inArray(inptSanctionNoImp,mapInptSanctionNos) > -1){
		$('#graph').addClass('activeMapGraph');
		$('#graph').show();
	}
}

var t2_chartObj = null;
$(function() {
	
	initRangeCal();
	initLoadingDisplay("Y", "class", "contents");
	
	//탭버튼 클릭시 처리
	$('.search-tab').eq(1).click(function(e){
		$('#canvas-1').css('display','none');
		$('#noSrchRstNotice1').css('display','none');
		$('#canvas-2').css('display','block');
		$('#noSrchRstNotice2').css('display','block');
		
		// 1204 이후 항목별통계와 기간별추이가 하나의 화면을 쓰므로 두 화면 모두 유효성검증을 하기 위해  아래를 추가함
		$('.statCalStd').removeClass('calStd');
		$('.statCalStd').removeClass('cal');
		$('.statCalEd').removeClass('calEd');
		$('.statCalEd').removeClass('cal');
		$('.moveCalStd').addClass('calStd');
		$('.moveCalStd').addClass('cal');
		$('.moveCalEd').addClass('calEd');
		$('.moveCalEd').addClass('cal');
		
		// 1204 이후 항목별통계와 기간별추이가 하나의 화면을 쓰므로 제재국가 지도를 출력하기 위해 아래를 추가함
		$('#graph').hide();
	});
	
	//조건1~5 체크박스 클릭시
	$("#t2 form").find('.cond-select').change(function(e){
		var _id = $(this).parent().data('switch').replace('t','');
		//var _checked = this.checked;
		var _thisVal = $(this).val();
		
		var aiInptListText = $("#t2 form").find('[name=aiInptListText'+_id+']');
		var aiInptListId = $("#t2 form").find('[name=aiInptListId'+_id+']');
		
		aiInptListText.hide();
		aiInptListId.hide();
		
		if(_thisVal == "0"){
			aiInptListText.show();
		} else if(_thisVal == "1") {
			aiInptListId.show();
		}
	});
	
	//검색버튼 클릭시
	$("#t2 form").find('[name=searchBtn_dataTable_6030_2]').click(function(e){
		//검색
		if(validationRangeEvent()){
			t2_fnSearch();
		}else{
			return;
		}
	});
	
});
function t2_fnSearch(){

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("6030","02","01",$.param(t2_fnSearchOption()));

	//차트그리기
 	t2_renderChart();
	
}
function t2_fnSearchOption(){
	var opts = {};
	
	opts.inptAtmcBizDscd = $("#t2 form").find(':radio[name="inptAtmcBizDscd"]:checked').val();
	opts.schSdate1 = $("#t2 form").find('[name=schSdate1]').val(); // 시작일
	opts.schEdate1 = $("#t2 form").find('[name=schEdate1]').val(); // 종료일
	
	if($("#t2 form").find('[name=aiInptListChk1]').val() == "0"){ 
		opts.aiInptListText1 = $("#t2 form").find('[name=aiInptListText1]').val(); // 리스트 선택하면
		opts.aiInptListChk1 = "0";
	} else {
		opts.aiInptListId1 = $("#t2 form").find('[name=aiInptListId1]').val(); // 텍스트 선택하면
		opts.aiInptListChk1 = "1";
	}
	
	if($("#t2 form").find('[name=aiInptListChk2]').val() == "0"){ 
		opts.aiInptListText2 = $("#t2 form").find('[name=aiInptListText2]').val(); // 리스트 선택하면
		opts.aiInptListChk2 = "0";
	} else {
		opts.aiInptListId2 = $("#t2 form").find('[name=aiInptListId2]').val(); // 텍스트 선택하면
		opts.aiInptListChk2 = "1";
	}
	
	if($("#t2 form").find('[name=aiInptListChk3]').val() == "0"){ 
		opts.aiInptListText3 = $("#t2 form").find('[name=aiInptListText3]').val(); // 리스트 선택하면
		opts.aiInptListChk3 = "0";
	} else {
		opts.aiInptListId3 = $("#t2 form").find('[name=aiInptListId3]').val(); // 텍스트 선택하면
		opts.aiInptListChk3 = "1";
	}
	
	opts.inptSanctionNo1 = $("#t2 form").find('[name=inptSanctionNo1]').val(); // 조건 1 선택
	opts.inptSanctionNo2 = $("#t2 form").find('[name=inptSanctionNo2]').val(); // 조건 2 선택
	opts.inptSanctionNo3 = $("#t2 form").find('[name=inptSanctionNo3]').val(); // 조건 3 선택
	
	return opts;
	
}
function t2_renderChart(){
	$.get('/api/common/stat/item/move',t2_fnSearchOption(),function(data){
		if(data.resultCode=='200'){
			var chartLabels = [];
			var chartDatas = [];
			var scopeYMax = 0;

			if(data.resultList && data.resultList.length){
				$('#noSrchRstNotice2').addClass('noSrchRstNoticeDeactive');
				for(var i=0;i<data.resultList.length;i++){
					var row = data.resultList[i];
					chartLabels.push(row.txt);
					chartDatas.push(row.cnt);
				}
			}else{
				$('#noSrchRstNotice2').removeClass('noSrchRstNoticeDeactive')
				$('#noSrchRstNotice2').show();
			}
			
			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함.
			scopeYMax = fnCmnGetArrayMaxItem(chartDatas);

			//차트초기화
			if(t2_chartObj){
				t2_chartObj.destroy();
			}

			//차트그리기
			t2_chartObj = new Chart($('#canvas-2'), {
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
			t2_fnAlertErrorMsg(data);
		}
	});
}
</script>