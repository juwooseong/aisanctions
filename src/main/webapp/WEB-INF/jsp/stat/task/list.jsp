<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6020"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>		
<div class="container">
	<h2 class="title">
		<strong>업무별 통계 [6020]</strong>
		<span class="revertStatPageDiscription">특정기간 업무별 담당자별 처리한 업무건수 및 총 처리시간을 조회하는 화면</span>
		<span class="location">
			<span>통계</span>
			<span>업무별 통계</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
				<input type="hidden" class="" id="txt_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>">
				<p class="w34">
					<span class="label">업무생성일</span>
					<input type="text" class="cal daterange-basic calStd calRange" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine">~</span>
					<input type="text" class="cal daterange-basic calEd calRange" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">					
					<span class="noticeMaxSearchSpan">(최대 30일)</span>
				</p> 
				<p class="w50"></p>
				<p class="w20">
					<label for="cbo_inptBizAlctCrpeEno_Search_${pageId}" class="label">권한</label>
					<select id="cbo_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>" title="">
						<option value="">선택</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
							<c:if test="${item.aiInptCmnCd ne '04' }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w32 statTaskChkGroup">
					<span class="label">업무</span>
					<c:forEach var="item" items="${inptAtmcBizDscdList2 }" varStatus="status">
				 		<input type="checkbox" class="statTaskChkBox" name="BizDscd" value="${item.aiInptCmnCd }" id="checkbox_BizDscd_Search${status.index }" checked="checked"> 
						<label for="checkbox_BizDscd_Search${status.index }">${item.aiInptCmnCdNm }</label>
					</c:forEach>
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<button type="button" class="xlsDownloadBtn gridRightTopBtn" onclick="downXls<c:out value="${pageId}"/>();" style="margin-bottom:5px;">엑셀다운로드</button>
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
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
});

var n = 0;

function downXls<c:out value="${pageId}"/>(){
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	$('#formXls').html($('#formXls').html()+'<input type="hidden" name="aiInptCnctScrnNo" value="2010">');
	fnCmnDownXls($('#formXls'), '/api/stat/task/xls', searchOption);
}

var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/stat/task',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-100 no-use-sorting', orderable :false },
			{ targets: 1, className: 'td-text-center td-text-80', orderable :false },
			{ targets: 2, className: 'td-text-center td-text-80', orderable :false },
			{ targets: 3, className: 'td-text-center td-text-80', orderable :false },
			{ targets: 4, className: 'td-text-center td-text-80' },
			{ targets: 5, className: 'td-text-center td-text-80' },
			{ targets: 6, className: 'td-text-center td-text-80' },
			{ targets: 7, className: 'td-text-center td-text-80' },
			{ targets: 8, className: 'td-text-center td-text-80', visible: false },
			{ targets: 9, visible: false }

		],
		
		columns: [
	    	{ title: '업무구분', data: 'cate', name: 'one' },
	    	{ title: '일자', data: 'inptRcpDt', name: 'two', render: function(data, type, row, meta){return dataFormat(data);}},
	    	{ title: '권한', data: 'auth', name: 'three' },
	    	{ title: '직원명', data: 'aiInptUserNm', name: 'five' },
	    	{ title: '직원번호', data: 'userId', name: 'four' },
	    	{ title: '처리건',  data: 'countEno', name: 'six' },
	   	 	{ title: '총처리 시간', data: 'totalTime', name: 'seven' },
	     	{ title: '평균처리 시간', data: 'avgTime', name: 'eight'  
	   	 		, render: 
		     		function(data, type, row, meta){
			     		 if(row.cate != "총합계"){
			     			return data;
			     		}
    	    		}
	   	 	},
	   	 {data: 'totalAvgTime'}

	    ],
	    
	    //검색정의
	    getSearchOption : function() {
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];

			var schSdate1 = $("#cld_schSdate1_Search_" + page_id).val();
			var schEdate1 = $("#cld_schEdate1_Search_" + page_id).val();
			var inptBizAlctCrpeAuth = $("#cbo_inptBizAlctCrpeEno_Search_" + page_id).val();
			
		 	var values = document.getElementsByName("BizDscd");
			
			var BizDscdValuesArray = [];
			var j=0;
			for(var i=0; i<values.length; i++){
				if(values[i].checked){
					BizDscdValuesArray[j++] = values[i].value;
				}
			}
			var length = BizDscdValuesArray.length;
			options.inptAtmcBizDscdList = BizDscdValuesArray.toString();			
			
			options.schSdate1 = schSdate1; 
			options.schEdate1 = schEdate1;
			options.inptBizAlctCrpeAuth = inptBizAlctCrpeAuth;
			
			return options;
		},
		
		dateInputIds : [['cld_schSdate1_Search_<c:out value="${pageId}"/>','cld_schEdate1_Search_<c:out value="${pageId}"/>']]
	
	 , fnRowCallback : function(nRow, aData, rowIndex, iDisplayIndexFull){
			var vrow = $(nRow);
			var col = vrow.find('td').eq(0);
			var col2 = vrow.find('td').eq(1);
			var cate = vrow.find('td').eq(0).text();
			var cateCount = [aData.exAuths, aData.exSugis, aData.imAuths, aData.imSugis, aData.qas, aData.qa2s]; // , aData.qa2s]
			var dateCount = [aData.exAuthDateSets, aData.exSugiDateSets, aData.imAuthDateSets, aData.imSugiDateSets, aData.qaDateSets, aData.qa2DateSets]; // , aData.qa2DateSets
		
			var starts = [];
			var starts2 = []; 
			var removes = [];
			var removes2 = []; 
			
			var cnts = [];
			var cnts2 = []; 
			var check = false;
			var a=0;
			var a2=0; 
			var cntIndex;
			var cntIndex2;
			var j2Row = 0;
			
			 for(var i=0; i<cateCount.length; i++){
				if(cateCount[i] != 0){
					starts.push(a);
					if(i!=0){ // 수입 (수기)
						cnts.push(cateCount[i])	
							var t = dateCount[i];
							  for(var j1=0; j1<t.length; j1++){ // ★
								
								 for(var j2=0; j2<t[j1].length; j2++){
									 if(t[j1][j2] != null){
										j2Row++; //1	2 = 2
									 }
								 }
								 if(j2Row != 0){
									cnts2.push(j2Row);	
								  }	
							  	 for(var n2=1; n2<j2Row; n2++){  // ★
							  		 if(check){
								  			removes2.push(parseInt(Number(a2 + 1))+n2);
								  	 }else{
								  		 
								    	removes2.push(parseInt(a2)+n2);// 6
								  	 } 
							     }
							  	if(j2Row != 0){
							  		 if(check){
							  			a2 = Number(a2 + 1);
							  		} 
							  		starts2.push(parseInt(a2));
								}
							 	 a2 = a2 + j2Row;  // 0 + 6	=	6 	// 6 + 6 = 12 // 12 + 5 = 17 // 
								 j2Row=0;
							  } 
							  check = false;
					}else if(i==0 && cateCount[i]==1){
						cnts.push(1);
						cnts2.push(1); // ★
						check = true;
						starts2.push(parseInt(a2));
					}else if(i==0 && cateCount[i]!=1){
						check = false;
						cnts.push(cateCount[i]); 
							var t = dateCount[i];
							for(var j1=0; j1<t.length; j1++){ // ★
								 for(var j2=0; j2<t[j1].length; j2++){
									 if(t[j1][j2] != null){
										 j2Row++;
									 }
								 }
							  	 if(j2Row != 0){
									 cnts2.push(j2Row);	
							  	 }
							  	 for(var n2=1; n2<j2Row; n2++){  // ★
							    	removes2.push(parseInt(a2)+n2);// 6
							     }
							  	if(j2Row != 0){
							  		starts2.push(parseInt(a2));
								}
							 	 a2 = a2 + j2Row;
							 	 j2Row=0;
							} 
					}  
				    for(var n=1; n<cateCount[i]; n++){
				 		removes.push(parseInt(a)+n);
				 	} 
				 	a = a + cateCount[i]; 
				 }
			 }
			 if(starts.indexOf(rowIndex)>=0){ // starts : 0, 6, 12
				 cntIndex = starts.indexOf(rowIndex)
			 	 col.prop('rowspan', cnts[cntIndex]);
			 }else if(removes.indexOf(rowIndex)>=0){
			 	col.remove();
			 }
			 if(starts2.indexOf(rowIndex)>=0){ // starts : 0, 6, 12
				 cntIndex2 = starts2.indexOf(rowIndex)
			 	 col2.prop('rowspan', cnts2[cntIndex2]);
			 }else if(removes2.indexOf(rowIndex)>=0){
				 col2.remove();
			 }	   
			 vrow.find('td').each(function(idx,obj){
				var vtd = $(obj);
				var vtdText = vtd.text();
		 	
				 if($.trim(vtdText)=='총합계'){
						vrow.find('td').eq(1).remove();
						vrow.find('td').eq(1).remove();
						vrow.find('td').eq(1).remove();
						vrow.find('td').eq(1).remove();
						vrow.find('td').eq(0).prop('colspan','5');
						vrow.find('td').eq(0).text('총합계');
						vrow.find('td').eq(3).text(aData.totalAvgTimes);//aData.totalAvgTimes
						vrow.find('td').eq(0).css({'text-align':'center'});
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
	<jsp:param name="numColYN" value="false" />
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="430" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
};
</script>