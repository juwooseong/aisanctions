<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7040"/>
<c:set var="admWatchTblId" value="admCtgrTbl_${pageId}"/>
<c:set var="admWatchTblId2" value="admGrpTbl_${pageId}"/>
<c:set var="admWatchTblId3" value="admContsTbl_${pageId}"/>

<div class="container">
	<h2 class="title">
		<strong>WatchList 등록 [7040]</strong>
		<span class="revertStatPageDiscription">제재 대상 단어 및 정보를 관리하기 위해 WatchList 카테고리, 리스트, 내용을 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>WatchList 관리</span>
			<span>WatchList 등록</span>
		</span>
	</h2>
	
	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>카테고리</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${admWatchTblId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>카테고리 생성</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="aiInptCtgrNm" class="label">카테고리명</label>
								<input type="text" id="aiInptCtgrNm" class="it" value="" placeholder="카테고리명" title="카테고리명"/>
							</p>
							<p class="">
								<label for="texts" class="label">비고</label>
								<input type="text" id="aiInptCtgrTxt" class="it" value="" placeholder="비고" title="비고"/>
							</p>
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType2" id="newBtn1">신규</a>
							<a href="javascript:void(0);" class="btType2" id="delBtn1">삭제</a>
							<a href="javascript:void(0);" class="btType1" id="saveBtn1">저장</a>
						</span>
					</div>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>리스트</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${admWatchTblId2}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>리스트 생성</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="aiInptListNm" class="label">리스트명</label>
								<input type="text" id="aiInptListNm" class="it" value="" placeholder="리스트명" title="리스트명"/>
							</p>
							<p class="">
								<label for="aiInptListDesTxt" class="label" id="text">비고</label>
								<input type="text" id="aiInptListDesTxt" class="it" name="text" value="" placeholder="비고" title="비고"/>
							</p>
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType2" id="newBtn2">신규</a>
							<a href="javascript:void(0);" class="btType2" id="delBtn2">삭제</a>
							<a href="javascript:void(0);" class="btType1" id="saveBtn2">저장</a>
						</span>
					</div>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>내용</strong>
				</div>
				<div class="tbCon">
					<select id="userYn" onchange="fnSelect()" style="width: 60px; margin-bottom: 6px; text-align-last: center;">
						<option value="01">사용</option>
						<option value="02">미사용</option>
						<option value="">전체</option>
					</select>
					<table class="table table-responsive-sm scrollTb grid3" id="<c:out value="${admWatchTblId3}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>내용 생성</strong>
					<div class="adminWatchListContentSpan">※ 업로드하실 엑셀파일은은 제공되는 '엑셀샘플'과 같은 형식에 맞추어주시고, 복호화 처리된 엑셀파일만 업로드해주시길 바랍니다.</div>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="aiInptRsptTxtDesTxt" class="label">내용</label>
								<input type="text" id="aiInptRsptTxtDesTxt" class="it" value="" placeholder="내용" title="내용"/>
							</p>
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType2" id="xlsSampleBtn3">엑셀샘플</a>
							<a href="javascript:void(0);" class="btType2" id="xlsBtn3" data-toggle="modal" data-target="#primaryFileUploadModal">엑셀업로드</a>
							<a href="javascript:void(0);" class="btType2" id="newBtn3">신규</a>
							<a href="javascript:void(0);" class="btType2" id="delBtn3">삭제</a>
							<a href="javascript:void(0);" class="btType1" id="saveBtn3">저장</a>
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<form id="formXls" method="get"></form>
<input type="hidden" id="aiInptCtgrId" value="" />
<input type="hidden" id="aiInptListId" value="" />
<input type="hidden" id="aiInptRsptTxtSrno" value="" />
<input type="hidden" id="tempListId" value="" />
<form id="formProcParams" onsubmit="return false;"></form>
<%-- 
<jsp:include page="/common/file" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="fileLayerId" value="primaryFileUploadModal" />
	<jsp:param name="fileFormId" value="formFile" />
	<jsp:param name="fileFormAction" value="/api/admin/watchlist/excel/upload" />
	<jsp:param name="pageTitle" value="Watchlist 엑셀업로드" />
</jsp:include> 
--%>
<jsp:include page="/common/file" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="fileLayerId" value="primaryFileUploadModal" />
	<jsp:param name="fileFormId" value="formFile" />
	<jsp:param name="fileFormAction" value="/api/admin/watchlist/excel/upload" />
	<jsp:param name="pageTitle" value="Watchlist 엑셀업로드" />
	<jsp:param name="fileListYN" value="N" />
	<jsp:param name="paramName1" value="cate_cd" />
	<jsp:param name="paramName2" value="list_cd" />
	<jsp:param name="fileExtLimit" value="xlsx" />
</jsp:include>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
$(function() {
	$("#delBtn1").css('display','inline-block');
});
var <c:out value="${admWatchTblId}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/ctgrList',
	columns : [
		{ data: "aiInptCtgrNm", title: '카테고리명' },
		{ data: "aiInptCtgrId", title: '카테고리 ID' }
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-left td-text-100' },
		{ targets: 2, className: 'td-text-center td-text-20' }
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		/*
		if($("#schUserAuth<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth<c:out value="${pageId}"/>").val();
		} */

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7040","03","01",$.param(options));

		return options;
	}
};
var <c:out value="${admWatchTblId2}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/groupList',
	columns : [
		{ data: "aiInptListNm", title: '리스트' },
		{ data: "aiInptListId", title: '리스트 ID' }
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-left td-text-100' },
		{ targets: 2, className: 'td-text-center td-text-20' }
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		if($("#aiInptCtgrId").val()){
			options.aiInptCtgrId = $("#aiInptCtgrId").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7040","04","01",$.param(options));

		return options;
	}
};
var <c:out value="${admWatchTblId3}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/contList',
	columns : [
    	{"data": "aiInptRsptTxtDesTxt", title: '내용'},
    	{"data": "aiInptRsptTxtRgsDtm", title: '등록일자', render: function(data, type, row, meta){
    		if(data != null){
        		data = data.substr(0,8);
        		return dataFormat(data);
       		}else{
       			return "";
       		}
    	}},
    	{"data": "aiInptRsptTxtEndDtm", title: '삭제일자', render: function(data, type, row, meta){
    		if(data != null){
	    		data = data.substr(0,8);
	    		return dataFormat(data);
    		}else{
    			return "";
    		}
    	}},
    	{"data": "aiInptCtgrId"},
    	{"data": "aiInptListId"},
    ],
	columnDefs: [
		{ targets: 0, className: 'text-center td-text-40 no-use-sorting' , orderable :false  },
		{ targets: 1, className: 'td-text-left td-text-130' },
		{ targets: 2, className: 'td-text-center td-text-100' },
		{ targets: 3, className: 'td-text-center td-text-100' },
		{ targets: 4, visible: false },
		{ targets: 5, visible: false }
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		if($("#aiInptCtgrId").val()){
			options.aiInptCtgrId = $("#aiInptCtgrId").val();
		}
		if($("#aiInptListId").val()){
			options.aiInptListId = $("#aiInptListId").val();
		}
		if($("#userYn").val()){
			options.userYn = $("#userYn").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7040","05","01",$.param(options));

		return options;
	},
	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
		
		tdElementNo = $('.grid3').find('thead').find('tr').find('th'); // [No] column selector #1
		tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
		tdElementNoObj.html(""); // [No] column text remove
		tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off">');
		
		$(nRow).find('td').eq(0).html('<input type="checkbox" class="multiRowChkBox" id="multiRowChkBox" style="background-color: transparent !important;">');
		
		if(aData['aiInptRsptTxtEndDtm'] != null){
			var multiChkBox = $(nRow).find('td').eq(0).find('.multiRowChkBox');
			$(multiChkBox).css('display','none');
			//$(multiChkBox).prop('disabled', true);
		}
		
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId3}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="multi" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>

var <c:out value="${admWatchTblId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail(row);
};
var <c:out value="${admWatchTblId2}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail2(row);
};
var <c:out value="${admWatchTblId3}"/>_selectCallback = function(e, dt, type, index, row){
	// 삭제된 항목인 경우 선택불가
	if(row.aiInptRsptTxtEndDtm != null){
		<c:out value="${admWatchTblId3}"/>.deselectItem(index);
	}else{
		//상세정보 설정
		fnSetDetail3(row);
		
		var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
		if($(multiChkBoxList[index]).is(':enabled')){
			$(multiChkBoxList[index]).prop('checked', true);
		}
	}
};
var <c:out value="${admWatchTblId3}"/>_deselectCallback = function(e, dt, type, index, row){	
	var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
	if($(multiChkBoxList[index]).is(':enabled')){
		$(multiChkBoxList[index]).prop('checked', false);	
	}
};

//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail(row){
	$("#userYn").val('01');
	if(row){
		if(row.aiInptCtgrId == '5' || row.aiInptCtgrId == '24'){
			$("#delBtn1").css('display','none');
			if(row.aiInptCtgrId != '24'){
				$("#text").text("영문국가명");
				 document.getElementsByName('text')[0].placeholder = '영문국가명';
			//	$("label[for='texts']").text("영문국가명");
				$("#tempListId").val("5");
			}else{
				$("#text").text("비고");
			//	$("label[for='texts']").text("비고");
				document.getElementsByName('text')[0].placeholder = '비고';
				$("#tempListId").val("");
			}
		}else{
			$("#text").text("비고");
		//	$("label[for='texts']").text("비고");
			document.getElementsByName('text')[0].placeholder = '비고';
			$("#tempListId").val("");
			$("#delBtn1").css('display','inline-block');
		}
		//상세/수정 모드
		$("#aiInptCtgrId").val(row.aiInptCtgrId);
		$("#aiInptCtgrNm").val(fnCmnXssUnescape(row.aiInptCtgrNm));
		$("#aiInptCtgrTxt").val(fnCmnXssUnescape(row.aiInptCtgrTxt));
	} else {
		//신규모드
		$("#aiInptCtgrId").val("");
		$("#aiInptCtgrNm").val("");
		$("#aiInptCtgrTxt").val("");
	}
	
	//하위 목록 및 상세 초기화
	$("#aiInptListId").val("");
	$("#aiInptRsptTxtSrno").val("");
	$("#aiInptListNm").val("");
	$("#aiInptRsptTxtDesTxt").val("");
	$("#aiInptListDesTxt").val("");
	
	//하위 그리드 갱신.
	<c:out value="${admWatchTblId2}"/>.searchList();
	<c:out value="${admWatchTblId3}"/>.searchList();
}

function fnSelect() {
	$("#aiInptRsptTxtDesTxt").val("");
	<c:out value="${admWatchTblId3}"/>.searchList();
}
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail2(row){
	if($("#tempListId").val() == '5'){
		$("#text").text("영문국가명");
	//	$("label[for='texts']").text("영문국가명");
		 document.getElementsByName('text')[0].placeholder = '영문국가명';
	}else{
		$("#text").text("비고");
	//	$("label[for='texts']").text("비고");
		document.getElementsByName('text')[0].placeholder = '비고';
	}
	$("#userYn").val('01');
	if(row){
		//상세/수정 모드
		$("#aiInptListId").val(row.aiInptListId);
		$("#aiInptListNm").val(fnCmnXssUnescape(row.aiInptListNm));
		//$("#aiInptListId").val(row.aiInptListId);
		$("#aiInptListDesTxt").val(row.aiInptListDesTxt);
	} else {
		
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7040","04","05",$.param({}));

		//신규모드
		$("#aiInptListId").val("");
		$("#aiInptListNm").val("");
		$("#aiInptListDesTxt").val("");
	}
	
	//하위 목록 및 상세 초기화
	$("#aiInptRsptTxtSrno").val("");
	$("#aiInptRsptTxtDesTxt").val("");
	
	//하위 그리드 갱신.
	<c:out value="${admWatchTblId3}"/>.searchList();
}
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail3(row){
	if(row){
		//상세/수정 모드
		$("#aiInptRsptTxtSrno").val(row.aiInptRsptTxtSrno);
		$("#aiInptRsptTxtDesTxt").val(fnCmnXssUnescape(row.aiInptRsptTxtDesTxt));
	} else {

		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7040","05","05",$.param({}));

		//신규모드
		$("#aiInptRsptTxtSrno").val("");
		$("#aiInptRsptTxtDesTxt").val("");
	}
}
$(function(){

	tdElementNo = $('.grid3').find('thead').find('tr').find('th'); // [No] column selector #1
	tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
	tdElementNoObj.html(""); // [No] column text remove
	tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off">');
	
	initLoadingDisplay("Y", "class", "container");
	//############# 카테고리 #############
	
	//카테고리 신규버튼
	$("#newBtn1").click(function(e){
		<c:out value="${admWatchTblId}"/>.deselectAllListTableRow();
		
		fnSetDetail(null);
	});
	
	//카테고리 저장버튼
	$("#saveBtn1").click(function(e){
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptCtgrNm = $('#aiInptCtgrNm').val();
		param.aiInptCtgrTxt = $('#aiInptCtgrTxt').val();
		
		param.aiInptCnctParmTxt = $.param(param);
		param.aiInptCnctScrnNo = "7040";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "03";
		
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7040","03","04",$.param(param));
		
		if($.trim($('#aiInptCtgrNm').val())==""){
			alert("카테고리명을 입력해주세요.");
			$('#aiInptCtgrNm').focus();
			return;
		}
		if($.trim($('#aiInptCtgrTxt').val())==""){
			alert("비고를 입력해주세요.");
			$('#aiInptCtgrTxt').focus();
			return;
		}
		$.post('/api/admin/watchlist/ctgr',param,function(data){
			if(data.resultCode=='200'){
				alert('정상적으로 처리되었습니다.');
				<c:out value="${admWatchTblId}"/>.searchList();
				fnSetDetail(null);
			} else {
				alert(data.resultMsg);
			}
		});
	});

	//카테고리 삭제처리
	$("#delBtn1").click(function(e){
		
		var param = {};

		param.aiInptCtgrId =  $('#aiInptCtgrId').val();
		param.aiInptCnctParmTxt = $.param(param);
		param.aiInptCnctScrnNo = "7040";
		param.aiInptCnctFldCd = "03";
		param.aiInptCnctActiCd = "06";
		
		
		if($.trim($('#aiInptCtgrId').val())==""){
			alert("카테고리 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/watchlist/ctgr/delete/' + $('#aiInptCtgrId').val() + '/7040/03/06/' + $.param({'aiInptCtgrId' : $('#aiInptCtgrId').val()}),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admWatchTblId}"/>.searchList();
					fnSetDetail(null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
	//############# 리스트 #############
	
	//리스트 신규버튼
	$("#newBtn2").click(function(e){
		<c:out value="${admWatchTblId2}"/>.deselectAllListTableRow();
		
		fnSetDetail2(null);
	});
	
	//리스트 저장버튼
	$("#saveBtn2").click(function(e){
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptListId = $('#aiInptListId').val();
		param.aiInptListNm = $('#aiInptListNm').val();
		param.aiInptListDesTxt = $('#aiInptListDesTxt').val();
		
		param.aiInptCnctParmTxt = $.param(param);
		param.aiInptCnctScrnNo = "7040";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "04";
		
		if($.trim($('#aiInptCtgrId').val())==""){
			alert("카테고리를 선택해주세요.");
			return;
		}
		if($.trim($('#aiInptListNm').val())==""){
			alert("리스트명을 입력해주세요.");
			$('#aiInptListNm').focus();
			return;
		}
		
		if(document.getElementsByName('text')[0].placeholder=='영문국가명' && $.trim($('#aiInptListDesTxt').val())==""){
			alert("영문국가명을 입력해주세요.");
			$('#text').focus();
			return;
		}
		
		$.post('/api/admin/watchlist/group',param,function(data){
			if(data.resultCode=='200'){
				
				if (parent.menu_503020) {
					
					parent.menu_503020.location.reload(true);
				}
				
				alert('정상적으로 처리되었습니다.');
				<c:out value="${admWatchTblId2}"/>.searchList();
				fnSetDetail2(null);
				parent.document.getElementById("menu-tabContent-503010").style.height = _height;
				
			} else {
				alert(data.resultMsg);
			}
		});
	});
	
	//리스트 삭제처리
	$("#delBtn2").click(function(e){
		
		if($.trim($('#aiInptListId').val())==""){
			alert("리스트 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/watchlist/group/delete/'+$('#aiInptCtgrId').val()+'/'+$('#aiInptListId').val() + '/7040/04/06/' + $.param({'aiInptCtgrId' : $('#aiInptCtgrId').val(), 'aiInptListId' : $('#aiInptListId').val()}),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					
					if (parent.menu_503020) {

						parent.menu_503020.location.reload(true);
					}
					
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admWatchTblId2}"/>.searchList();
					fnSetDetail2(null);
					parent.document.getElementById("menu-tabContent-503010").style.height = _height;
					
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});

	//############# 내용 #############
	
	//내용 신규버튼
	$("#newBtn3").click(function(e){
		<c:out value="${admWatchTblId3}"/>.deselectAllListTableRow();
		
		fnSetDetail3(null);
	});
	
	//내용 저장버튼
	$("#saveBtn3").click(function(e){
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptListId = $('#aiInptListId').val();
		param.aiInptRsptTxtSrno = $('#aiInptRsptTxtSrno').val() ? $('#aiInptRsptTxtSrno').val() : "0";
		param.aiInptRsptTxtDesTxt = $('#aiInptRsptTxtDesTxt').val();
		
		param.aiInptCnctScrnNo = "7040";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "05";
		param.aiInptCnctParmTxt = $.param(param);
		
		if($.trim($('#aiInptCtgrId').val())==""){
			alert("카테고리를 선택해주세요.");
			return;
		}
		if($.trim($('#aiInptListId').val())==""){
			alert("목록을 선택해주세요.");
			return;
		}
		if($.trim($('#aiInptRsptTxtDesTxt').val())==""){
			alert("내용을 입력해주세요.");
			$('#aiInptRsptTxtDesTxt').focus();
			return;
		}
		
		$.post('/api/admin/watchlist/cont',param,function(data){
			if(data.resultCode=='200'){
				alert('정상적으로 처리되었습니다.');
				<c:out value="${admWatchTblId3}"/>.searchList();
				fnSetDetail3(null);
			} else {
				fnAlertErrorMsg(data);
			}
		});
	});
	
	//내용 삭제처리
	$("#delBtn3").click(function(e){
		
		var gridSelRows = <c:out value="${admWatchTblId3}"/>.getSelRows();
		
		var f = $('#formProcParams');
		var params = [];
		params.push('<input type="hidden" name="aiInptListId" value="'+$('#aiInptListId').val()+'" />');				
		params.push('<input type="hidden" name="aiInptCtgrId" value="'+$('#aiInptCtgrId').val()+'" />');		
		for(var i=0;i<gridSelRows.length;i++){
			var row = gridSelRows[i];
			params.push('<input type="hidden" name="aiInptRsptTxtSrnos" value="'+row.aiInptRsptTxtSrno+'" />');
		}
		
		f.html(params.join(''));
		
		f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7090">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="05">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="06">');
		
	
		if(gridSelRows.length == 0){
			alert("내용 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			
			$.ajax({
				url: '/api/admin/watchlist/cont/deletee',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admWatchTblId3}"/>.searchList();
					fnSetDetail3(null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
	$("#xlsSampleBtn3").click(function(e){
		fnCmnProgramLog("7040","05","07",$.param({}));	
		
		WatchListDownXls($('#formXls'), '/api/admin/watchlist/excel/dawnLoad');
	});
	
	$("#xlsBtn3").click(function(e){
		
		uploadReset();
		//엑셀업로드 버튼 클릭시 처리.
		var formFile = $('#formFile')[0];
		var aiInptCtgrId = $.trim($("#aiInptCtgrId").val());
		var aiInptListId = $.trim($("#aiInptListId").val());

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7040","05","08",$('#formFile').serialize());
		
		if(aiInptCtgrId==''){
			alert('카테고리와 리스트 목록에서 각각 항목을 선택해주세요.');
			return false;
		}
		
		if(aiInptListId==''){
			alert('카테고리와 리스트 목록에서 각각 항목을 선택해주세요.');
			return false;
		}
		
		formFile.cate_cd.value = aiInptCtgrId;
		formFile.list_cd.value = aiInptListId;
	});
	
});
fileUploadControl_<c:out value="${pageId}" />.uploadCallback = function(list,errInfo){
	if(errInfo){
		alert(errInfo.msg);
	} else {
		alert("정상적으로 처리되었습니다.");
		fileUploadControl_<c:out value="${pageId}" />.closeLayer();
		<c:out value="${admWatchTblId3}"/>.searchList();
	}
};

function fnDeselectListTableAll(){
	var testTableObject = <c:out value="${admWatchTblId3}"/>;
	testTableObject.deselectAllListTableRow();
	$('.multiRowChkBox').prop('checked', false);
}

function consoleTable(){
	var testTableObject = <c:out value="${admWatchTblId3}"/>;
	var dataRows = testTableObject.getAllListTableRow();
	dataRowsTest = testTableObject.getAllListTableRow();
	testTableObject.selectAllListTableRow();
	
	var selectedRowsList = testTableObject.getSelRows();
	for(var index = 0 ; index < selectedRowsList.length ; index++){
		
		if(selectedRowsList[index].aiInptRsptTxtEndDtm != null){
			testTableObject.deselectItem(index);
		}else{
			var multiChkBox = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
			$(multiChkBox[index]).prop('checked', true);
		}
	}
}

function appvAllSelectCheck(){
	var allChkBox = $('#appvAllSelector');
	if(allChkBox.is(":checked")){
		consoleTable();
	}else if(!allChkBox.is(":checked")){
		fnDeselectListTableAll();
	}
	
}
</script>