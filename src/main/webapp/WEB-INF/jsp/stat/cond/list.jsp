<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="6040"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>		
	<div class="container">
	<h2 class="title">
		<strong>조건별 통계 [6040]</strong>
		<span class="revertStatPageDiscription">특정기간 조건별 심사명세를 조회하는 화면</span>
		<span class="location">
			<span>통계</span>
			<span>조건별 통계</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
				<input type="hidden" class="" id="txt_inptBizAlctCrpeEno_Search_<c:out value="${pageId}"/>"">
				<p class="w42">
					<label for="schSdate1" class="label">업무생성일</label>
					<input type="text" id="schSdate1" class="cal daterange-basic calRange calStd statCondCalCustom" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
					<span class="calLine">~</span>
					<input type="text" id="schEdate1" class="cal daterange-basic calRange calEd statCondCalCustom" value="" pageid="<c:out value="${pageId}"/>" placeholder=""/>
					<span class="noticeMaxSearchSpan">(최대 90일)</span>
				</p>
				<p class="w20">
					<label for="inptAtmcBizDscd" class="label">업무</label>
					<select id="inptAtmcBizDscd" title="">
						<option value="">전체</option>
						<c:forEach var="item" items="${inptAtmcBizDscdList }">
						<c:if test="${item.aiInptCmnCd ne '3'}">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w22">
					<label for="actlFxRefno" class="label">Ref.No</label>
					<input type="text" id="actlFxRefno" class="it" value="" placeholder=""  maxlength="<c:out value="${maxLength_refno }"/>"/>
				</p>
				<button type="button" class="searchBtnType1" name="searchThing" id="searchBtn_<c:out value="${dataTableId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<p class="w42">
					<label for="inptSanctionNo1" class="label">조건1</label>
					<select id="inptSanctionNo1" title="" class="t1-switch-form">
						<option value="">선택</option>
						<c:forEach var="item" items="${statiSanctionList }">
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
					<input type="text" id="aiInptListText1" class="it t1-switch-form" value="" placeholder=""/>
					<select id="aiInptListId1" title="" class="t1-switch-form" style="display:none;">
						<option value="">선택</option>
						<c:forEach var="item" items="${watchList }">
						<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42">
					<label for="inptSanctionNo2" class="label">조건2</label>
					<select id="inptSanctionNo2" title="">
						<option value="">선택</option>
						<c:forEach var="item" items="${statiSanctionList }">
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
					<input type="text" id="aiInptListText2" class="it t2-switch-form" value="" placeholder=""/>
					<select id="aiInptListId2" title="" class="t2-switch-form" style="display:none;">
						<option value="">선택</option>
						<c:forEach var="item" items="${watchList }">
						<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42">
					<label for="inptSanctionNo3" class="label">조건3</label>
					<select id="inptSanctionNo3" title="">
						<option value="">선택</option>
						<c:forEach var="item" items="${statiSanctionList }">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42 t3-switch-check">
					<label class="label switch switch-label switch-primary" data-switch="t3" >
						<select class="cond-select" name="aiInptListChk3" style="position: absolute;">
							<option value="0">텍스트</option>
							<option value="1">리스트</option>
						</select>
					</label>
					<input type="text" id="aiInptListText3" class="it t3-switch-form" value="" placeholder=""/>
					<select id="aiInptListId3" title="" class="t3-switch-form" style="display:none;">
						<option value="">선택</option>
						<c:forEach var="item" items="${watchList }">
						<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42">
					<label for="inptSanctionNo4" class="label">조건4</label>
					<select id="inptSanctionNo4" title="">
						<option value="">선택</option>
						<c:forEach var="item" items="${statiSanctionList }">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42 t4-switch-check">
					<label class="label switch switch-label switch-primary" data-switch="t4" >
						<select class="cond-select" name="aiInptListChk4" style="position: absolute;">
							<option value="0">텍스트</option>
							<option value="1">리스트</option>
						</select>
					</label>
					<input type="text" id="aiInptListText4" class="it t4-switch-form" value="" placeholder=""/>
					<select id="aiInptListId4" title="" class="t4-switch-form" style="display:none;">
						<option value="">선택</option>
						<c:forEach var="item" items="${watchList }">
						<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42">
					<label for="inptSanctionNo5" class="label">조건5</label>
					<select id="inptSanctionNo5" title="">
						<option value="">선택</option>
						<c:forEach var="item" items="${statiSanctionList }">
						<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w42 t5-switch-check">
					<label class="label switch switch-label switch-primary" data-switch="t5" >
						<select class="cond-select" name="aiInptListChk5" style="position: absolute;">
							<option value="0">텍스트</option>
							<option value="1">리스트</option>
						</select>
					</label>
					<input type="text" id="aiInptListText5" class="it t5-switch-form" value="" placeholder=""/>
					<select id="aiInptListId5" title="" class="t5-switch-form" style="display:none;">
						<option value="">선택</option>
						<c:forEach var="item" items="${watchList }">
						<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
						</c:forEach>
					</select>
				</p>
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

<form id="formHistoryRevert" action='/common/history' method='POST' target='historyRevertWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
</form>

<form id="formHistoryQa" action='/common/history/qa' method='POST' target='historyQatWin'>
	<input TYPE='hidden' name='inptMstSrno' value=''>
	<input TYPE='hidden' name='actlFxRefno' value=''>
	<input TYPE='hidden' name='inptAtvtCd' value=''>
</form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>


$(function() {
	initRangeCal();
	initLoadingDisplay("Y", "class", "container");
	
	//조건1~5 체크박스 클릭시
	$('.cond-select').change(function(e){
		var _id = $(this).parent().data('switch').replace('t','');
		//var _checked = this.checked;
		var _thisVal = $(this).val();
		
		var aiInptListText = $('#aiInptListText'+_id);
		var aiInptListId = $('#aiInptListId'+_id);
		
		aiInptListText.val("");
		aiInptListId.val("");
		
		aiInptListText.hide();
		aiInptListId.hide();
		
		if(_thisVal == "0"){
			aiInptListText.show();
		} else if(_thisVal == "1") {
			aiInptListId.show();
		}
	});
	
});


/* function isChOrListFun() {
	if($('[id="isChOrList"]:checked').val() == 'on'){
		$('#aiInptListId1').val("");
	}else{
		$('#aiInptListText1').val("");
	}
} */


function downXls<c:out value="${pageId}"/>(){
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("6040",null,"02",$.param(searchOption));

	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	fnCmnDownXls($('#formXls'), '/api/stat/cond/xls', searchOption);
}




$('#<c:out value="${dataTableId}"/>').on('click', 'td button', function() {
	   var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _inptMstSrno = data['inptMstSrno'];
		var _inptAtvtCd = data['inptAtvtCd']; 
		var _aiInptCmnCd = data['inptAtmcBizDscd']; 
		var _actlFxRefno = data['actlFxRefno']; 
		
		if(_aiInptCmnCd=='1' || _aiInptCmnCd=='2'){
			var formHistoryRevert = $('#formHistoryRevert')[0];
			formHistoryRevert.inptMstSrno.value = _inptMstSrno;
			formHistoryRevert.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formHistoryRevert);
		}else{
			var formHistoryQa = $('#formHistoryQa')[0];
			formHistoryQa.inptMstSrno.value = _inptMstSrno;
			formHistoryQa.actlFxRefno.value = _actlFxRefno;
			fnFullWin(formHistoryQa);
			
		}
}); 

var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/stat/cond',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-80' }, // NO
			{ targets: 1, className: 'td-text-center td-text-80' }, // 업무
			{ targets: 2, className: 'td-text-left td-text-80' }, // REFNO
			{ targets: 3, className: 'td-text-center td-text-80' }, // BL
			{ targets: 4, className: 'td-text-center td-text-80' }, // 고객번호
			{ targets: 5, className: 'td-text-left td-text-80' }, // 고객명
			{ targets: 6, className: 'td-text-center td-text-80' }, // 통화
			{ targets: 7, className: 'td-text-left td-text-80' }, // 영업점
			{ targets: 8, className: 'td-text-left td-text-80' }, // 수출상
			{ targets: 9, className: 'td-text-left td-text-80' }, // 수입상
			{ targets: 10, className: 'td-text-left td-text-80' }, // 선적항
			{ targets: 11, className: 'td-text-left td-text-80' }, // 하역항
			{ targets: 12, className: 'td-text-left td-text-80' }, // 원산지
			{ targets: 13, className: 'td-text-center td-text-80' } // 상세보기
		],
		columns: [
	    	{ title: '업무', data: 'inptAtmcBizDsNm' },
	    	{ title: 'Ref.No', data: 'actlFxRefno' },
	    	{ title: 'R/N 일련번호', data: 'fxRefnoSrno' },
	    	{ title: '고객번호', data: 'aiInptCsno' },
	    	{ title: '고객명', data: 'aiInptCusNm' },
	    	{ title: '통화',  data: 'fcCuNm' },
	    	{ title: '영업점', data: 'krbrNm' },
	    	{ title: '수출상', data: 'exptNm' },
	    	{ title: '수입상', data: 'imptNm' },
	    	{ title: '선적항', data: 'portLoading' },
	    	{ title: '하역항', data: 'portDisch' },
	    	{ title: '원산지', data: 'orignNm' },
        	{"title": '상세보기', "render":function(){
        		return '<button type="button" class="btn btn-primary m-1 p-1 viewDetailBtn" data-toggle="modal">'+
				'<i class="fa fa-search fa-lg"></i>'+
				'</button>';
        	}}
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			options.schSdate1 = $('#schSdate1').val();
			options.schEdate1 = $('#schEdate1').val();
			options.inptAtmcBizDscd = $('#inptAtmcBizDscd').val();
			options.actlFxRefno = $('#actlFxRefno').val();
			options.inptSanctionNo1 = $('#inptSanctionNo1').val();
			options.aiInptListText1 = $('#aiInptListText1').val();
			options.aiInptListId1 = $('#aiInptListId1').val();
			options.inptSanctionNo2 = $('#inptSanctionNo2').val();
			options.aiInptListText2 = $('#aiInptListText2').val();
			options.aiInptListId2 = $('#aiInptListId2').val();
			options.inptSanctionNo3 = $('#inptSanctionNo3').val();
			options.aiInptListText3 = $('#aiInptListText3').val();
			options.aiInptListId3 = $('#aiInptListId3').val();
			options.inptSanctionNo4 = $('#inptSanctionNo4').val();
			options.aiInptListText4 = $('#aiInptListText4').val();
			options.aiInptListId4 = $('#aiInptListId4').val();
			options.inptSanctionNo5 = $('#inptSanctionNo5').val();
			options.aiInptListText5 = $('#aiInptListText5').val();
			options.aiInptListId5 = $('#aiInptListId5').val();

			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("6040",null,"01",$.param(options));

			return options;
		},
		dateInputIds : [['schSdate1','schEdate1']]
	};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="430" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
};
</script>