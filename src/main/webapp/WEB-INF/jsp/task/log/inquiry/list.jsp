<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>

<c:set var="pageId" value="5030"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>

<c:set var="apdrDsNm01" value=""/>
<c:set var="apdrDsNm02" value=""/>
<c:set var="apdrDsNm03" value=""/>
<c:set var="apdrDsNm04" value=""/>
<c:set var="apdrDsNm05" value=""/>
<c:forEach var="item" items="${apdrDsCdList}">
<c:if test="${item.aiInptCmnCd eq '01'}"><c:set var="apdrDsNm01" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '02'}"><c:set var="apdrDsNm02" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '03'}"><c:set var="apdrDsNm03" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '04'}"><c:set var="apdrDsNm04" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '05'}"><c:set var="apdrDsNm05" value="${item.aiInptCmnCdNm}"/></c:if>
</c:forEach>

<c:set var="apdrItmNm01" value=""/>
<c:set var="apdrItmNm02" value=""/>
<c:set var="apdrItmNm03" value=""/>
<c:set var="apdrItmNm04" value=""/>
<c:set var="apdrItmNm05" value=""/>
<c:set var="apdrItmNm06" value=""/>
<c:set var="apdrItmNm07" value=""/>
<c:set var="apdrItmNm08" value=""/>
<c:set var="apdrItmNm09" value=""/>
<c:set var="apdrItmNm10" value=""/>
<c:set var="apdrItmNm11" value=""/>
<c:set var="apdrItmNm12" value=""/>
<c:set var="apdrItmNm13" value=""/>
<c:set var="apdrItmNm14" value=""/>
<c:set var="apdrItmNm15" value=""/>
<c:set var="apdrItmNm16" value=""/>
<c:set var="apdrItmNm17" value=""/>
<c:set var="apdrItmNm18" value=""/>
<c:set var="apdrItmNm19" value=""/>
<c:set var="apdrItmNm20" value=""/>
<c:forEach var="item" items="${apdrItmCdList}">
<c:if test="${item.aiInptCmnCd eq '01'}"><c:set var="apdrItmNm01" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '02'}"><c:set var="apdrItmNm02" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '03'}"><c:set var="apdrItmNm03" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '04'}"><c:set var="apdrItmNm04" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '05'}"><c:set var="apdrItmNm05" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '06'}"><c:set var="apdrItmNm06" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '07'}"><c:set var="apdrItmNm07" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '08'}"><c:set var="apdrItmNm08" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '09'}"><c:set var="apdrItmNm09" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '10'}"><c:set var="apdrItmNm10" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '11'}"><c:set var="apdrItmNm11" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '12'}"><c:set var="apdrItmNm12" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '13'}"><c:set var="apdrItmNm13" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '14'}"><c:set var="apdrItmNm14" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '15'}"><c:set var="apdrItmNm15" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '16'}"><c:set var="apdrItmNm16" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '17'}"><c:set var="apdrItmNm17" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '18'}"><c:set var="apdrItmNm18" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '19'}"><c:set var="apdrItmNm19" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '20'}"><c:set var="apdrItmNm20" value="${item.aiInptCmnCdNm}"/></c:if>
</c:forEach>

<div class="container">
	<h2 class="title">
		<strong>업무일지 조회 [5030]</strong>
		<span class="revertStatPageDiscription">기 등록된 업무일지를 기간별로 조회하는 화면</span>
		<span class="location">
			<span>업무일지</span>
			<span>업무일지 조회</span>
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
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic calRange calStd" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine">~</span>
					<input type="text" class="cal daterange-basic calRange calEd" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="noticeMaxSearchSpan">(최대 7일)</span>
				</p>
				<button class="searchBtnType1" id="searchBtn" onclick="return false;">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="btBox">
			<span class="r">
				<button type="button" class="reportPrintBtn" id="printBtn" onclick="fnReport('780', '900');">
					<i class="icons font-2xl d-block mt-5 cui-print printIcon"></i>
					레포트출력
				</button>
				<button type="button" class="xlsDownloadBtn" id="downloadBtn" onclick="downXls();">엑셀다운로드</button>
			</span>
		</div>
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>1. <c:out value="${apdrDsNm01}"/></strong>
				</div>
				<div class="tbCon">
					<table class="scrollTb" id="section01">
						<thead>
							<tr>
								<th scope="col" colspan="2">구분</th>
								<th scope="col">수출</th>
								<th scope="col">수입</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td rowspan="4">심사완료명세</td>
								<td>전체</td>
								<td id="cell1_1_1"></td>
								<td id="cell1_1_2"></td>
								<td id="cell1_1_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm02}"/></td>
								<td id="cell1_2_1"></td>
								<td id="cell1_2_2"></td>
								<td id="cell1_2_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm03}"/></td>
								<td id="cell1_3_1"></td>
								<td id="cell1_3_2"></td>
								<td id="cell1_3_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm04}"/></td>
								<td id="cell1_4_1"></td>
								<td id="cell1_4_2"></td>
								<td id="cell1_4_3"></td>
							</tr>
							<tr>
								<td rowspan="3">심사오류명세</td>
								<td>전체</td>
								<td id="cell1_5_1"></td>
								<td id="cell1_5_2"></td>
								<td id="cell1_5_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm06}"/></td>
								<td id="cell1_6_1"></td>
								<td id="cell1_6_2"></td>
								<td id="cell1_6_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm07}"/></td>
								<td id="cell1_7_1"></td>
								<td id="cell1_7_2"></td>
								<td id="cell1_7_3"></td>
							</tr>
							<tr>
								<td rowspan="4">경보발생명세</td>
								<td>전체</td>
								<td id="cell1_8_1"></td>
								<td id="cell1_8_2"></td>
								<td id="cell1_8_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm08}"/></td>
								<td id="cell1_9_1"></td>
								<td id="cell1_9_2"></td>
								<td id="cell1_9_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm09}"/></td>
								<td id="cell1_10_1"></td>
								<td id="cell1_10_2"></td>
								<td id="cell1_10_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm10}"/></td>
								<td id="cell1_11_1"></td>
								<td id="cell1_11_2"></td>
								<td id="cell1_11_3"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>2. <c:out value="${apdrDsNm02}"/></strong>
				</div>
				<div class="tbCon">
					<table class="scrollTb" id="section02">
						<thead>
							<tr>
								<th scope="col" class="td-text-100">구분</th>
								<th scope="col">수출</th>
								<th scope="col">수입</th>
								<th scope="col">당발</th>
								<th scope="col">타발</th>
								<th scope="col">기타</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><c:out value="${apdrItmNm11}"/></td>
								<td id="cell2_1_1"></td>
								<td id="cell2_1_2"></td>
								<td id="cell2_1_3"></td>
								<td id="cell2_1_4"></td>
								<td id="cell2_1_5"></td>
								<td id="cell2_1_6"></td>
							</tr>
							<tr>
								<td id=""><c:out value="${apdrItmNm12}"/></td>
								<td id="cell2_2_1"></td>
								<td id="cell2_2_2"></td>
								<td id="cell2_2_3"></td>
								<td id="cell2_2_4"></td>
								<td id="cell2_2_5"></td>
								<td id="cell2_2_6"></td>
							</tr>
							<tr>
								<td id=""><c:out value="${apdrItmNm10}"/></td>
								<td id="cell2_3_1"></td>
								<td id="cell2_3_2"></td>
								<td id="cell2_3_3"></td>
								<td id="cell2_3_4"></td>
								<td id="cell2_3_5"></td>
								<td id="cell2_3_6"></td>
							</tr>
							<tr>
								<td id=""><c:out value="${apdrItmNm13}"/></td>
								<td id="cell2_4_1"></td>
								<td id="cell2_4_2"></td>
								<td id="cell2_4_3"></td>
								<td id="cell2_4_4"></td>
								<td id="cell2_4_5"></td>
								<td id="cell2_4_6"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>3. <c:out value="${apdrDsNm03}"/></strong>
				</div>
				<div class="tbCon">
					<table class="scrollTb" id="section03">
						<thead>
							<tr>
								<th scope="col">구분</th>
								<th scope="col">수신전문</th>
								<th scope="col">발신전문</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><c:out value="${apdrItmNm14}"/></td>
								<td id="cell3_1_1"></td>
								<td id="cell3_1_2"></td>
								<td id="cell3_1_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm10}"/></td>
								<td id="cell3_2_1"></td>
								<td id="cell3_2_2"></td>
								<td id="cell3_2_3"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm13}"/></td>
								<td id="cell3_3_1"></td>
								<td id="cell3_3_2"></td>
								<td id="cell3_3_3"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>4. <c:out value="${apdrDsNm04}"/></strong>
				</div>
				<div class="tbCon">
					<table class="scrollTb" id="section04">
						<thead>
							<tr>
								<th scope="col">구분</th>
								<th scope="col">수출</th>
								<th scope="col">수입</th>
								<th scope="col">당발</th>
								<th scope="col">타발</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><c:out value="${apdrItmNm15}"/></td>
								<td id="cell4_1_1"></td>
								<td id="cell4_1_2"></td>
								<td id="cell4_1_3"></td>
								<td id="cell4_1_4"></td>
								<td id="cell4_1_5"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm16}"/></td>
								<td id="cell4_2_1"></td>
								<td id="cell4_2_2"></td>
								<td id="cell4_2_3"></td>
								<td id="cell4_2_4"></td>
								<td id="cell4_2_5"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm10}"/></td>
								<td id="cell4_3_1"></td>
								<td id="cell4_3_2"></td>
								<td id="cell4_3_3"></td>
								<td id="cell4_3_4"></td>
								<td id="cell4_3_5"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm17}"/></td>
								<td id="cell4_4_1"></td>
								<td id="cell4_4_2"></td>
								<td id="cell4_4_3"></td>
								<td id="cell4_4_4"></td>
								<td id="cell4_4_5"></td>
							</tr>
							<tr>
								<td><c:out value="${apdrItmNm18}"/></td>
								<td id="cell4_5_1"></td>
								<td id="cell4_5_2"></td>
								<td id="cell4_5_3"></td>
								<td id="cell4_5_4"></td>
								<td id="cell4_5_5"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>5. 수출/수입 전체 건수 추이</strong>
				</div>
				<div class="tbCon">
					<div class="chart">
						<canvas id="canvas-1"></canvas>
					</div>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>6. Alert(경보) 내역 추이</strong>
				</div>
				<div class="tbCon">
					<div class="chart">
						<canvas id="canvas-1_2"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="flGroup">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>7. <c:out value="${apdrDsNm05}"/></strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${dataTableId}"/>"></table>
				</div>
			</div>
		</div>
	</div>
</div>


<form id="formXls" method="get"></form>

<form id="formReport" action='/birt/frameset' method='POST' target='winReport'>
<input TYPE='hidden' name='__report' value='report/task_log_inquiry.rptdesign'><br>
<input TYPE='hidden' name='schSdate1' value='1900-01-01'><br>
<input TYPE='hidden' name='schEdate1' value='1900-01-01'><br>
</form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>
<script>
var isPageInit = false;
var chart1Obj = null;
var chart2Obj = null;
$(function(){

	initLoadingDisplay("Y", "class", "container");
	
	fnInitPage();
	
	
	initRangeCal();
	$('#searchBtn').click(function(e){
		if(validationRangeEvent()){
			fnSearch();
		}else{
			return;
		}
		
	});

	fnSearch();
	
	isPageInit = true;

});
function fnSearchOptions(){
	var options = {};
	var schSdate1 = $('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val();
	var schEdate1 = $('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val();
	
	options.schSdate1 = schSdate1;
	options.schEdate1 = schEdate1;
	
	return options;
}
function fnSearch(){
	fnInitData();

	s_loading();
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5030",null,"01",$.param(fnSearchOptions()));

	//통계건수 설정하기
	$.get('/api/task/log/inquiry?' + $.now(),fnSearchOptions(),function(data){
		if(data.resultCode=='200'){
			h_loading();
			var list = data.list;
			var list2 = data.list2;
			var list3 = data.list3;
			var list4 = data.list4;
			var list5 = data.list5;
			
			//리스트1
			if(list && list.length){
				for(var i=0;i<list.length;i++){
					var num = i + 1;
					var row = list[i];
					$('#cell1_'+num+'_1').html(row.col1 ? row.col1 : '0');
					$('#cell1_'+num+'_2').html(row.col2 ? row.col2 : '0');
					$('#cell1_'+num+'_3').html(row.col3 ? row.col3 : '0');
				}
			}
			
			//리스트2
			if(list2 && list2.length){
				for(var i=0;i<list2.length;i++){
					var num = i + 1;
					var row = list2[i];
					$('#cell2_'+num+'_1').html(row.col1 ? row.col1 : '0');
					$('#cell2_'+num+'_2').html(row.col2 ? row.col2 : '0');
					$('#cell2_'+num+'_3').html(row.col3 ? row.col3 : '0');
					$('#cell2_'+num+'_4').html(row.col4 ? row.col4 : '0');
					$('#cell2_'+num+'_5').html(row.col5 ? row.col5 : '0');
					$('#cell2_'+num+'_6').html(row.col6 ? row.col6 : '0');
				}
			}
			
			//리스트3
			if(list3 && list3.length){
				for(var i=0;i<list3.length;i++){
					var num = i + 1;
					var row = list3[i];
					$('#cell3_'+num+'_1').html(row.col1 ? row.col1 : '0');
					$('#cell3_'+num+'_2').html(row.col2 ? row.col2 : '0');
					$('#cell3_'+num+'_3').html(row.col3 ? row.col3 : '0');
				}
			}

			//리스트4
			if(list4 && list4.length){
				for(var i=0;i<list4.length;i++){
					var num = i + 1;
					var row = list4[i];
					$('#cell4_'+num+'_1').html(row.col1 ? row.col1 : '0');
					$('#cell4_'+num+'_2').html(row.col2 ? row.col2 : '0');
					$('#cell4_'+num+'_3').html(row.col3 ? row.col3 : '0');
					$('#cell4_'+num+'_4').html(row.col4 ? row.col4 : '0');
					$('#cell4_'+num+'_5').html(row.col5 ? row.col5 : '0');
				}
			}

			//리스트5 그리드 검색 초기화
			if(isPageInit){
				<c:out value="${dataTableId}"/>.searchList();
			}

		} else {
			fnAlertErrorMsg(data);
		}
	});	//통계건수 설정하기 종료
	
	//차트1 표기
	fnInitChart1();
	
	//차트2 표기
	fnInitChart2();
}
//출력/입력항목들 초기화.
function fnInitData(){
	//섹션1 초기화
	for(var rowIdx=1;rowIdx<=11;rowIdx++){
		for(var colIdx=1;colIdx<=3;colIdx++){
			$('#cell1_'+rowIdx+'_'+colIdx).html('0');
		}
	}
	//섹션2 초기화
	for(var rowIdx=1;rowIdx<=4;rowIdx++){
		for(var colIdx=1;colIdx<=5;colIdx++){
			$('#cell2_'+rowIdx+'_'+colIdx).html('0');
		}
	}
	//섹션3 초기화
	for(var rowIdx=1;rowIdx<=3;rowIdx++){
		for(var colIdx=1;colIdx<=3;colIdx++){
			$('#cell3_'+rowIdx+'_'+colIdx).val('0');
		}
	}
	//섹션4 초기화
	for(var rowIdx=1;rowIdx<=5;rowIdx++){
		for(var colIdx=1;colIdx<=5;colIdx++){
			$('#cell4_'+rowIdx+'_'+colIdx).html('0');
		}
	}
}
function fnInitPage(){
	
	// Basic initialization
	/*
	$('.daterange-basic').daterangepicker({
		singleDatePicker: true,
		locale: {
			format: 'YYYY-MM-DD'
		}
	});
	*/
	$('#section01 td[id^="cell"]').css({'text-align':'right'});
	$('#section02 td[id^="cell"]').css({'text-align':'right'});
	$('#section03 td[id^="cell"]').css({'text-align':'right'});
	$('#section04 td[id^="cell"]').css({'text-align':'right'});

	//차트1 초기화, 차트영역ID : canvas-1
	fnInitChart1();

	//차트2 초기화, 차트영역ID : canvas-1_2
	fnInitChart2();
	
}
//차트1 초기화, 차트영역ID : canvas-1
function fnInitChart1(){
	//차트1 초기화, 차트영역ID : canvas-1
	$.get("/api/task/log/inquiry/chart1?" + $.now(), fnSearchOptions(), function(res, a, bs){
		if(res.resultCode=='200'){
			var chartList = res.chartList;
			console.log(chartList);
			var dataLabels = [];
			var dataExports = [];
			var dataImports = [];
			var scopeYMax = 0;
			var scopeYMaxExp = 0;
			var scopeYMaxImp = 0;
			
			//데이터 각 종류별로 배열설정
			if(chartList && chartList.length){
				//차트 데이터 설정.
				for(var i=0;i<chartList.length;i++){
					var row = chartList[i];
					dataLabels.push(row['day']);
					dataExports.push(row['export']);
					dataImports.push(row['importt']);
				}
		    }
			
			/*
			console.log("데이터개수");
			console.log(dataLabels.length);
			
			if(dataLabels.length == 1){
				for(var i = 0 ; i < 2 ; i++){
					dataLabels.push(dataLabels[0]);
					dataExports.push(dataExports[0]);
					dataImports.push(dataImports[0]);
				}
				dataLabels[0] = "";
				dataExports[0] = NaN;
				dataImports[0] = NaN;
				dataLabels[2] = "";
				dataExports[2] = NaN;
				dataImports[2] = NaN;
			}*/
			
			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함. (수출 데이터)
			scopeYMaxExp = fnCmnGetArrayMaxItem(dataExports);
			
			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함. (수입 데이터)
			scopeYMaxImp = fnCmnGetArrayMaxItem(dataImports);
			
			//차트 Y축 범위값 설정을 위해서, 데이터 건수 중 가장 최대값을 구함. (전체 데이터)
			scopeYMax = Math.max(scopeYMaxExp,scopeYMaxImp);
			
			console.log("scopeYmax");
			console.log(scopeYMax);
			
			//차트초기화
			if(chart1Obj){
				chart1Obj.destroy();
			}
			
			//차트표기.
			chart1Obj = new Chart($('#canvas-1'), {
				type: 'line',
				data: {
					labels: dataLabels,
					datasets: [
						{
							label: '수출',
							backgroundColor: 'transparent',//'rgba(220, 220, 220, 0.2)',
							borderColor: 'rgba(220, 220, 220, 1)',
							pointBackgroundColor: 'rgba(220, 220, 220, 1)',
							pointBorderColor: '#fff',
							data: dataExports
						}, 
						{
							label: '수입',
							backgroundColor: 'transparent',//'rgba(151, 187, 205, 0.2)',
							borderColor: 'rgba(151, 187, 205, 1)',
							pointBackgroundColor: 'rgba(151, 187, 205, 1)',
							pointBorderColor: '#fff',
							data: dataImports
						}
					]
				},
				options: {
					responsive: true,
					scales: {
						yAxes: [{
							display: true,
							stacked: false,
							ticks: {
								//min: 0,
								beginAtZero: true,
								suggestedMax: (scopeYMax + 10)	// 차트 Y축 최대값 범위 지정 
							}
						}]
					}// end sacles
				}
			});	//차트표기 종료.
		}
	});
}
//차트2 초기화, 차트영역ID : canvas-1_2
function fnInitChart2(){
	$.get("/api/task/log/inquiry/chart2?" + $.now(), fnSearchOptions(), function(res, a, bs){
		if(res.resultCode=='200'){
			var chartList = res.chartList;
			var dataLabels = [];
			var dataSf = [];
			var dataIt = [];
			var dataTt = [];
			
			if(chartList && chartList.length){
				//차트 데이터 설정.
				for(var i=0;i<chartList.length;i++){
					var row = chartList[i];
					dataLabels.push(row['day']);
					dataSf.push(row['sw']);
					dataIt.push(row['hang']);
					dataTt.push(row['tot']);
				}
		    }
			
			scopeA = fnCmnGetArrayMaxItem(dataSf);
			scopeB = fnCmnGetArrayMaxItem(dataIt);
			scopeC = fnCmnGetArrayMaxItem(dataIt);
			
			scopeYMax = Math.max(scopeA, scopeB, scopeC);

			//차트초기화
			if(chart2Obj){
				chart2Obj.destroy();
			}

			//차트표기.
			chart2Obj = new Chart($('#canvas-1_2'), {
				type: 'line',
				data: {
					labels: dataLabels,
					datasets: [
						{
							label: 'TotalText',
							backgroundColor: 'rgba(300, 400, 105, 0.2)',
							borderColor: 'rgba(600, 187, 205, 1)',
							pointBackgroundColor: 'rgba(255, 195, 194, 1)',
							pointBorderColor: '#fff',
							data: dataTt
						},
						{
							label: '항목심사',
							backgroundColor: 'rgba(151, 187, 205, 0.2)',
							borderColor: 'rgba(151, 187, 205, 1)',
							pointBackgroundColor: 'rgba(151, 187, 205, 1)',
							pointBorderColor: '#fff',
							data: dataIt
						},
						{
							label: 'SafeWatch',
							backgroundColor: 'rgba(220, 220, 220, 0.2)',
							borderColor: 'rgba(220, 220, 220, 1)',
							pointBackgroundColor: 'rgba(220, 220, 220, 1)',
							pointBorderColor: '#fff',
							data: dataSf
						} 
					]
				},
				options: {
					responsive: true,
					scales: {
						yAxes: [{
							display: true,
							stacked: false,
							ticks: {
								//min: 0,
								beginAtZero: true,
								suggestedMax: (scopeYMax + 10)	// 차트 Y축 최대값 범위 지정 
							}
						}]
					}// end sacles
				}
			});	//차트표기 종료.
		}
	});
}
//그리드 초기화
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/task/log/inquiry/etc',
	columnDefs: [
		{ targets: 0, width: '20px', className: 'td-text-center' },
		{ targets: 1, width: '120px', className: 'td-text-center' },
		{ targets: 2, width: '300px', className: 'td-text-left' },
	],
	columns: [
		{"data": "col2", title: '업무생성일', render: function(data, type, row, meta){return dataFormat(data);}},
		{"data": "col1", title: '내용'}
    ],
    //검색정의
    getSearchOption : function() {
    	var page_id = '<c:out value="${pageId}"/>';
    	var options = {};
		var filters = [];
		
		var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
		var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
		
		options.schSdate1 = schSdate1;
		options.schEdate1 = schEdate1;
		
		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="gridRowCallback" value="N" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="${grid_height}" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){

};
function downXls(){
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5030",null,"02",$.param(searchOption));

	fnCmnDownXls($('#formXls'), '/api/task/log/inquiry/xls', searchOption);
}
function fnReport(displayW, displayH){
	var formReport = $('#formReport')[0];
	formReport.schSdate1.value = $('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val();
	formReport.schEdate1.value = $('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5030",null,"03",$(formReport).serialize());
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = displayW;
	var popupSizeH = displayH;
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);	
	var resultTop = curY + (clientH / 2); // - (popupSizeH / 2);
	
	
	window.open('about:blank','winReport','left='+resultLeft+', top=0, width='+popupSizeW+', height='+popupSizeH);
	formReport.submit();
}
</script>