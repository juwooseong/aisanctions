<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>

<c:set var="pageId" value="5040"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>

<div class="container">
	<h2 class="title">
		<strong>성과 관리[5040]</strong>
		<span class="revertStatPageDiscription">직원별 업무별 처리 건수를 조회하는 화면</span>
		<span class="location">
			<span>업무일지</span>
			<span>성과 관리</span>
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
				<button class="searchBtnType1 calRangeSchBtn" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<button type="button" class="xlsDownloadBtn gridRightTopBtn" id="downloadBtn" onclick="downXls();">엑셀다운로드</button>
				<table class="table table-responsive-sm scrollTb" id="<c:out value="${dataTableId}"/>">
				
					 <thead>
						<tr>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th colspan="3">수출</th>
							<th colspan="3">수입</th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
							<th class="grid_rowspan_top"></th>
						</tr>
						<tr>
							<th class="grid_rowspan_bottom">No</th>
							<th class="grid_rowspan_bottom">시작일</th>
							<th class="grid_rowspan_bottom">종료일</th>
							<th class="grid_rowspan_bottom">권한</th>
							<th class="grid_rowspan_bottom">직원번호</th>
							<th class="grid_rowspan_bottom">직원명</th>
							<th>수출</th>
							<th>수출</th>
							<th>수출</th>
							<th>수입</th>
							<th>수입</th>
							<th>수입</th>
							<th class="grid_rowspan_bottom">QA</th>
							<th class="grid_rowspan_bottom">합계</th>
							<th class="grid_rowspan_bottom">일평균</th>
						</tr>
					</thead> 
				</table>
			</div>
		</div>
	</div>
</div>
<form id="formXls" method="get"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

/*
$('.cal').each(function(idx,obj){
	var input = $(obj);
	var today = formatYMD(getToDay());
	if(input.val()==''){
		input.val(today);
	}
});*/

$(function() {
	initRangeCal();
	
	initLoadingDisplay("Y", "class", "container");
});

var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/blank/api/task/log/result',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-801', width:80}, // NO
			{ targets: 1, className: 'td-text-center td-text-80', orderable: false }, // 시작일
			{ targets: 2, className: 'td-text-center td-text-80', orderable: false }, // 종료일
			{ targets: 3, className: 'td-text-center td-text-40', orderable: false }, // 권한
			{ targets: 4, className: 'td-text-center td-text-80', orderable: false }, // 직원번호
			{ targets: 5, className: 'td-text-center td-text-80', orderable: false }, // 직원명
			{ targets: 6, className: 'td-text-right td-text-80', orderable: false }, // 자동
			{ targets: 7, className: 'td-text-right td-text-80', orderable: false }, // 수기
			{ targets: 8, className: 'td-text-right td-text-80', orderable: false }, // sw
			{ targets: 9, className: 'td-text-right td-text-80', orderable: false }, // 자동
			{ targets: 10, className: 'td-text-right td-text-80', orderable: false }, // 수기
			{ targets: 11, className: 'td-text-right td-text-80', orderable: false }, // SW
			{ targets: 12, className: 'td-text-right td-text-80', orderable: false }, // QA
			{ targets: 13, className: 'td-text-right td-text-80', orderable: false }, // 합계
			{ targets: 14, className: 'td-text-right td-text-80', orderable: false } // 일평균
		],
		columns: [
			{data: "cnt1",type:'', title: '시작일', "render": function ( data, type, full, meta ) {
	    	    return  $('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val();
	    	}},
	    	{data: "cnt1",type:'', title: '종료일', name: 'second', "render": function ( data, type, full, meta ) {
	    	    return  $('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val();
	    	}},
			{"data": "aiInptUserAutVal", title: '권한'},
        	{"data": "aiInptUserEno", title: '직원번호'},
        	{"data": "aiInptUserNm", title: '직원명'},
        	{"data": "cnt1", title: '선적서류 제재심사'},
        	{"data": "cnt2", title: '선적서류 제재심사</br>(수기)'},
        	{"data": "cnt3", title: 'SW'},
        	{"data": "cnt4", title: '선적서류 제재심사'},
        	{"data": "cnt5", title: '선적서류 제재심사</br>(수기)'},
        	{"data": "cnt6", title: 'SW'},
        	{"data": "cnt7", title: 'QA'},
        	{"data": "userSum", title: '합계'},
        	{"data": "dateAvg", title: '일평균'}
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	var options = {};
			var filters = [];
			
			if($("#cld_schSdate1_Search_<c:out value="${pageId}"/>").val()){  
				options.schSdate1 = $("#cld_schSdate1_Search_<c:out value="${pageId}"/>").val();
			}
			
			if($("#cld_schEdate1_Search_<c:out value="${pageId}"/>").val()){  
				options.schEdate1 = $("#cld_schEdate1_Search_<c:out value="${pageId}"/>").val();
			}

			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("5040",null,"01",$.param(options));

			return options;
		}
		
	,
		fnRowCallback : function(nRow, aData, iDisplayIndex, iDisplayIndexFull){
			var vrow = $(nRow);
			vrow.find('td').each(function(idx,obj){
				var vtd = $(obj);
				var vtdText = vtd.text();
				
				//합계 컬럼 셀합치기
				if(idx == 3 && $.trim(vtdText)=='합계'){
					
					vrow.find('td').eq(2).remove();
					vrow.find('td').eq(2).remove();
					vrow.find('td').eq(2).remove();
					vrow.find('td').eq(2).remove();
					vrow.find('td').eq(1).prop('colspan','5');
					vrow.find('td').eq(1).text('합계');
					vrow.find('td').eq(1).parent().addClass('parentTest');
					vrow.find('td').eq(1).css({'text-align':'center'});
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
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="1700px" />
	<jsp:param name="gridOptionScrollY" value="480" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	
};
function downXls(){
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5040",null,"02",$.param(searchOption));

	fnCmnDownXls($('#formXls'), '/api/task/log/result/xls', searchOption);
}
</script>