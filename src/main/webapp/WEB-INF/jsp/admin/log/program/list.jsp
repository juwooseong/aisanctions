<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7021"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">

<style>
td.logTd.logDetailColumn {
    background-color: #f0feff;
    font-size: 11px;
    color: #222;
    font-weight: bold;
}
td.logTd {
    width: 10%;
    height: 35px;
    line-height: 15px;
    font-size: 12px;
    color: black;
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid #05718b;
    text-align: left;
}
#programLogDetailWrapper {
    position: absolute;
    width: 900px;
    height: 550px;
    background-color: rgb(255, 255, 255);
    font-weight: 600;
    z-index: 100;
    right: calc(50% - 450px);
    top: calc(50% - 275px);
    transition: 0.2s;
    color: white;
    box-sizing: border-box;
    border: 1px solid #000;
    padding-top: 25px;
    display: none;
    opacity: 0;
}
.programLogDetailTitle{
	line-height: 14px; */
    font-size: 14px;
    color: #222;
    padding-left: 10px;
    border-left: 4px solid #05718b;
    font-weight: 600;
    display: block;
    margin-left: 22px;
    margin-bottom: 15px;
}
.programLogTable{
	width: 95%;
    margin: 0 auto;
    border-collapse: collapse;
}
.logParameterWrapper{
    width: 100%;
    height: 100%;
    height: 280px;
    overflow-y: scroll;
    word-break: break-all;
    font-size: 15px;
    line-height: 22px;
    text-align: left;
    padding-top: 10px;
    padding-right: 10px;
}
#programLogBackground {
	transition: 0.2s;
    position: absolute;
    z-index: 50;
    width: 100%;
    height: 98%;
    background-color: rgba(0, 0, 0, 0.5);
    top: 0%;
    left: 0%;
    display: none; 
    opacity: 0;
}
#programLogDetailClsBtn{
	position: absolute;
    top: 15px;
    right: 20px;
    font-size: 20px;
    color: black;
    width: 30px;
    height: 30px;
    text-align: center;
    cursor: pointer;
}
</style>

	<div class="" id="programLogDetailWrapper">
	<span id="programLogDetailClsBtn">ⅹ</span>
	<span class="programLogDetailTitle">프로그램 사용 이력관리 상세</span>
	    <table class="programLogTable">
           <tr>
                <td class="logTd logDetailColumn">거래일련번호</td>
                <td id="logVal-1" class="logTd logDetailValue" colspan="3">VALUE</td>
                <td class="logTd logDetailColumn">거래시각</td>
                <td id="logVal-2" class="logTd logDetailValue" colspan="3">VALUE</td>
            </tr>
            <tr>
                <td class="logTd logDetailColumn">화면번호</td>
                <td id="logVal-3" class="logTd logDetailValue">VALUE</td>
                <td class="logTd logDetailColumn">화면명</td>
                <td id="logVal-4" class="logTd logDetailValue">VALUE</td>
                <td class="logTd logDetailColumn">화면색션</td>
                <td id="logVal-5" class="logTd logDetailValue">VALUE</td>
                <td class="logTd logDetailColumn">행위</td>
                <td id="logVal-6" class="logTd logDetailValue">VALUE</td>
            </tr>
            <tr>
                <td class="logTd logDetailColumn">접속자ID</td>
                <td id="logVal-7" class="logTd logDetailValue">VALUE</td>
                <td class="logTd logDetailColumn">접속자명</td>
                <td id="logVal-8" class="logTd logDetailValue">VALUE</td>
                <td class="logTd logDetailColumn">아이피</td>
                <td id="logVal-9" class="logTd logDetailValue" colspan="3">VALUE</td>
            </tr>
			<tr>
			    <td class="logTd logDetailColumn">접속기기명</td>
			    <td id="logVal-10"  class="logTd logDetailValue" colspan="8">VALUE</td>
			</tr>
            <tr>
                <td class="logTd logDetailColumn" colspan="8">파라미터</td>
            </tr>
            <tr>
                <td class="logTd" colspan="8">
                	<div id="logVal-11" class="logParameterWrapper">VALUE</div>
                </td>
            </tr>
        </table>
	</div>
	<div id="programLogBackground"></div> 
	<h2 class="title">
		<strong>프로그램 사용 이력관리 [7022]</strong>
		<span class="revertStatPageDiscription">프로그램 사용이력을 조회하는 화면</span>
		<span class="location">
			<span>관리자메뉴</span>
			<span>이력관리</span>
			<span>프로그램 사용 이력관리</span>
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
					<span class="label">로그 일자</span>
					<input type="text" class="cal daterange-basic" name="schSdate1" id="cld_schSdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
					<span class="calLine">~</span>
					<input type="text" class="cal daterange-basic" name="schEdate1" id="cld_schEdate1_Search_<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>
				<p class="w24">
					<label for="schUserNo" class="label">직원번호</label>
					<input type="text" class="it w100" id="schUserNo" placeholder="직원번호">
					<input type="hidden" id="schUserNm">
					<button type="button" class="btType4 info" onclick="layer('.layerSt1');" data-toggle="modal" data-target="#schUserModal">
						<i class="fa fa-search fa-lg"></i>
					</button>
				</p>
				<p class="w28">
					<label for="txt_trnLogNo_Search_${pageId}" class="label">거래일련번호</label>
					<input type="text" class="it" name="schUserIp" id="txt_trnLogNo_Search_<c:out value="${pageId}"/>">
					
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
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>

<script>
$(function() {
	var defaultDate = formatYMD(getToDay());
	$('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	$('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
});
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/admin/log/program',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-140' }, // 거래일련번호
		{ targets: 2, className: 'td-text-center td-text-60' }, // 화면번호
		{ targets: 3, className: 'td-text-left td-text-120' }, // 화면명
		{ targets: 4, className: 'td-text-left td-text-100 ' }, // 화면섹션
		{ targets: 5, className: 'td-text-left td-text-80' }, // 행위
		{ targets: 6, className: 'td-text-center td-text-100' }, // 접속자명
		{ targets: 7, className: 'td-text-center td-text-100' }, // 접속시각
		{ targets: 8, className: 'td-text-left td-text-80' }, // IP
		{ targets: 9, className: 'td-text-left td-text-140' }, // 파라미터
		{ targets: 10, className: 'td-text-center td-text-40' }, // 상세버튼
		{ targets: 11, visible: false } // 접속기기명
	],
	columns: [
		{"data": "trnLogSrno", title: '거래일련번호'},
		{"data": "aiInptCnctScrnNo", title: '화면번호'},
    	{"data": "aiInptCnctScrnNm", title: '화면명'},
		{"data": "aiInptCnctFldNm", title: '화면섹션'},
		{"data": "aiInptCnctActiNm", title: '행위'},
		{"data": "aiInptCnctUserNm", title: '접속자명'},
    	{"data": "lstDbChgDtm", title: '접속시각'},
    	{"data": "aiInptCnctIpad", title: '아이피'},
    	{"data": "aiInptCnctParmTxt", title: '파라미터'},
    	{"data": "", title: '상세', render: function(data, type, row, meta){ // 상세버튼
    		return '<button type="button" class="btn btn-primary m-1 p-1 viewDetailBtn">'+
			'<i class="fa fa-search fa-lg"></i>'+
			'</button>';
    	}},
    	{"data": "aiInptCnctMchrNm"}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//권한
		if($("#schAuth").val()){
			options.schAuth = $("#schAuth").val();
		}
		
		//직원번호
		if($("#schUserNo").val()){
			options.schUserNo = $("#schUserNo").val();
		}

		//시작일
		if($("#cld_schSdate1_Search_<c:out value="${pageId}"/>").val()){
			options.schSdate1 = $("#cld_schSdate1_Search_<c:out value="${pageId}"/>").val();
		}

		//종료일
		if($("#cld_schEdate1_Search_<c:out value="${pageId}"/>").val()){
			options.schEdate1 = $("#cld_schEdate1_Search_<c:out value="${pageId}"/>").val();
		}
		
		//거래일련번호
		if($("#txt_trnLogNo_Search_<c:out value="${pageId}"/>").val()){
			options.trnLogSrno = $("#txt_trnLogNo_Search_<c:out value="${pageId}"/>").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7022",null,"01",$.param(options));

		return options;
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
	<jsp:param name="gridOptionScrollY" value="460" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 선택" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>
<script>
//사용자 선택 모달 다이얼로그 스크립트 시작.
var userModalOpenGbn = 1;	//사용자 모달창을 어느 버튼에서 오픈했는지 구분자.
function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	//console.info(row);
	//row.aiInptUserEno
	//row.aiInptUserId
	//row.aiInptUserNm
	if(row){
		if(userModalOpenGbn==1){
			$("#schUserNo").val(row.aiInptUserEno);
			$("#schUserNm").val(row.aiInptUserNm);
		}
	}
}
function chang(){
	$("#schUserNo").val("");
}
function toggleProgramLogDetail(YN){
	var toggleElement = $('#programLogDetailWrapper');
	var toggleBackground = $('#programLogBackground');
	var toggleElementHeight = toggleElement.outerHeight();
	if(!YN){
		// fn hide
		toggleElement.removeClass('active');
		toggleElement.css('opacity', '0');
		toggleBackground.css('opacity', '0');
		toggleElement.css('top', '-550px');
		setTimeout(function(){
			toggleElement.css('display', 'none');
			toggleBackground.css('display', 'none');	
		}, 200); // TRANSITION 0.2S
		
	}else if(YN){
		// fn show
		toggleElement.addClass('active');
		toggleElement.css('display', 'block');
		toggleBackground.css('display', 'block');
		toggleElement.css('opacity', '1');
		toggleBackground.css('opacity', '1');
		toggleElement.css('top', 'calc(50% - 275px)');
		
		setTimeout(function(){
			
		}, 200); // TRANSITION 0.2S
	}
}
$(function(){
	initLoadingDisplay("Y", "class", "container");
	
	// 프로그램 사용 이력 상세보기
	$(document).on('click', '.viewDetailBtn', function(){
		var _row_index = $(this).closest('tr');	
		var data = <c:out value="${dataTableId}"/>listTable.row(_row_index).data();
		var _trnLogSrno = data['trnLogSrno']; // 거래일련번호
		var _aiInptCnctScrnNo = data['aiInptCnctScrnNo']; // 화면번호(null check)
		if(_aiInptCnctScrnNo == null){_aiInptCnctScrnNo = '-';}
		var _aiInptCnctScrnNm = data['aiInptCnctScrnNm']; // 화면명(null check)
		if(_aiInptCnctScrnNm == null){_aiInptCnctScrnNm = '-';}
		var _aiInptCnctFldNm = data['aiInptCnctFldNm']; // 화면색션(null check)
		if(_aiInptCnctFldNm == null){_aiInptCnctFldNm = '-';}
		var _aiInptCnctActiNm = data['aiInptCnctActiNm']; // 행위(null check)
		if(_aiInptCnctActiNm == null){_aiInptCnctActiNm = '-';}
		var _aiInptCnctUserNm = data['aiInptCnctUserNm']; // 접속자명
		var _aiInptCnctUserNo = data['aiInptCnctUserNo']; // 접속자사번
		var _lstDbChgDtm = data['lstDbChgDtm']; //접속시각
		var _aiInptCnctIpad = data['aiInptCnctIpad']; // 아이피
		var _aiInptCnctParmTxt = data['aiInptCnctParmTxt']; // 파라미터(null check)
		if(_aiInptCnctParmTxt == null){_aiInptCnctParmTxt = '-';}
		var _aiInptCnctMchrNm = data['aiInptCnctMchrNm']; // 접속기기명
		
		$("#logVal-1").text(_trnLogSrno); // 거래일련번호
		$("#logVal-2").text(_lstDbChgDtm); // 거래시각
		$("#logVal-3").text(_aiInptCnctScrnNo); // 화면번호
		$("#logVal-4").text(_aiInptCnctScrnNm); // 화면명
		$("#logVal-5").text(_aiInptCnctFldNm); // 화면색션
		$("#logVal-6").text(_aiInptCnctActiNm); // 행위
		$("#logVal-7").text(_aiInptCnctUserNo); // 접속자사번
		$("#logVal-8").text(_aiInptCnctUserNm); // 접속자명
		$("#logVal-9").text(_aiInptCnctIpad); // 아이피
		$("#logVal-10").text(_aiInptCnctMchrNm); // 접속기기명
		$("#logVal-11").text(_aiInptCnctParmTxt); // 파라미터

		toggleProgramLogDetail(true);
	});
	
	$(document).on('click', '#programLogBackground', function(){
		toggleProgramLogDetail(false);
	});
	
	$(document).on('click', '#programLogDetailClsBtn', function(){
		toggleProgramLogDetail(false);
	});
	//modalUserListTable<c:out value ="${pageId}"/>_data.userName = 'schUserNm';
	//modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'cbo_schAuth_Search_<c:out value="${pageId}"/>';
	//modalUserListTable<c:out value ="${pageId}"/>_data.userNoId = 'schUserNo';
});
</script>