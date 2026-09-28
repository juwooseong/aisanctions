<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7021"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>로그인 이력관리 [7021]</strong>
		<span class="revertStatPageDiscription">사용자 로그인이력을 조회하는 화면</span>
		<span class="location">
			<span>관리자메뉴</span>
			<span>이력관리</span>
			<span>로그인 이력관리</span>
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
					<span class="label">로그인 일자</span>
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
					<label for="txt_userIp_Search_${pageId}" class="label">아이피</label>
					<input type="text" class="it" name="schUserIp" id="txt_userIp_Search_<c:out value="${pageId}"/>">
					
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
	
	initLoadingDisplay("Y", "class", "container");
	
	var defaultDate = formatYMD(getToDay());
	$('#cld_schSdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
	$('#cld_schEdate1_Search_<c:out value="${pageId}"/>').val(defaultDate);
});
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/admin/log/login',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-10' },
		{ targets: 1, className: 'td-text-left td-text-10' },
		{ targets: 2, className: 'td-text-center td-text-10 ' },
		{ targets: 3, className: 'td-text-left td-text-10' },
		{ targets: 4, className: 'td-text-left td-text-80' },
		{ targets: 5, className: 'td-text-center td-text-10' }
	],
	columns: [
    	{"data": "aiInptLginUserNm", title: '직원명'},
    	{"data": "aiInptLginDtm", title: '로그인 시간'},
    	{"data": "aiInptLginUsgIpad", title: '로그인 아이피'},
    	{"data": "aiInptLginUserMchrNm", title: '로그인 기기명'},
    	{"data": "aiInptLginYn", title: '성공여부', render: function(data, type, row, meta){
    		
    		if (data == "Y") {
    			return "성공"
    		} else {
    			return "성공"
    		}
    	}},
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
		
		//아이피
		if($("#txt_userIp_Search_<c:out value="${pageId}"/>").val()){
			options.schUserIp = $("#txt_userIp_Search_<c:out value="${pageId}"/>").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7021",null,"01",$.param(options));

		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	
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
/* $(function(){
	modalUserListTable<c:out value ="${pageId}"/>_data.userName = 'schUserNm';
	modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'cbo_schAuth_Search_<c:out value="${pageId}"/>';
	modalUserListTable<c:out value ="${pageId}"/>_data.userNoId = 'schUserNo';
}); */
</script>