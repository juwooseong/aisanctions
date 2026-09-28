<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="_watchInfo"/>
<c:set var="admWatchTblId" value="admCtgrTbl${pageId}"/>
<c:set var="admWatchTblId2" value="admGrpTbl${pageId}"/>
<c:set var="admWatchTblId3" value="admContsTbl${pageId}"/>

<div class="container-fluid">
	<div class="row">
		<div class="col-sm-12" style="margin-bottom:20px;">
			<div class="card-header">
				<i class="fa fa-search"></i> WatchList 등록 조회화면 [7040]
				<div class="card-header-actions">
					<a class="card-header-action btn-minimize" href="#"data-toggle="collapse" data-target="#collapseExample<c:out value="${pageId}"/>" aria-expanded="true"> 
						<i class="icon-arrow-up"></i>
					</a> 
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="card" style="height:305px;">
				<div class="card-header">
					<i class="fa fa-align-justify"></i> 카테고리
				</div>
				<div class="card-body">
					<table class="table table-responsive-sm" id="<c:out value="${admWatchTblId}"/>"></table>
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="card" style="height:305px;">
				<div class="card-body">
					<div class="text-sm-right my-1" style="padding-bottom:10px;">
						<button type="button" class="btn btn-primary btType2" id="newBtn1">신규</button>
						<button type="button" class="btn btn-primary btType1" id="saveBtn1">저장</button>
						<button type="button" class="btn btn-primary btType2" id="delBtn1">삭제</button>
					</div>
					<div class="form-group row">
						<label class="control-label col-sm-2">카테고리명</label>
						<div class="col-sm-10"><input type="text" class="form-control" id="aiInptCtgrNm"></div>
					</div>
					<div class="form-group row">
						<label class="control-label col-sm-2">비고</label>
						<div class="col-sm-10"><input type="text" class="form-control" id="aiInptCtgrTxt"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<div class="card" style="height:310px;">
				<div class="card-header">
					<i class="fa fa-align-justify"></i> 리스트
				</div>
				<div class="card-body">
					<table class="table table-responsive-sm" id="<c:out value="${admWatchTblId2}"/>"></table>
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="card" style="height:310px;">
				<div class="card-body">
					<div class="text-sm-right my-1" style="padding-bottom:10px;">
						<button type="button" class="btn btn-primary btType2" id="newBtn2">신규</button>
						<button type="button" class="btn btn-primary btType1" id="saveBtn2">저장</button>
						<button type="button" class="btn btn-primary btType2" id="delBtn2">삭제</button>
					</div>
					<div class="form-group row">
						<label class="control-label col-sm-2">리스트명</label>
						<div class="col-sm-10"><input type="text" class="form-control" id="aiInptListNm"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<div class="card" style="height:305px;">
				<div class="card-header">
					<i class="fa fa-align-justify"></i> 내용
				</div>
				<div class="card-body">
					<table class="table table-responsive-sm" id="<c:out value="${admWatchTblId3}"/>"></table>
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="card" style="height:305px;">
				<div class="card-body">
					<div class="text-sm-right my-1" style="padding-bottom:10px;">
						<button type="button" class="btn btn-primary btType2" id="xlsSampleBtn3">엑셀샘플</button>
						<button type="button" class="btn btn-primary btType2" id="xlsBtn3" data-toggle="modal" data-target="#primaryFileUploadModal">엑셀업로드</button>
						<button type="button" class="btn btn-primary btType2" id="newBtn3">신규</button>
						<button type="button" class="btn btn-primary btType1" id="saveBtn3">저장</button>
						<button type="button" class="btn btn-primary btType2" id="delBtn3">삭제</button>
					</div>
					<div class="form-group row">
						<label class="control-label col-sm-2">내용</label>
						<div class="col-sm-10"><input type="text" class="form-control" id="aiInptRsptTxtDesTxt"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<input type="hidden" id="aiInptCtgrId" value="" />
<input type="hidden" id="aiInptListId" value="" />
<input type="hidden" id="aiInptRsptTxtSrno" value="" />

<%-- <jsp:include page="/common/file" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="fileLayerId" value="primaryFileUploadModal" />
	<jsp:param name="fileFormId" value="formFile" />
	<jsp:param name="fileFormAction" value="/api/admin/watchlist/excel/upload" />
	<jsp:param name="pageTitle" value="Watchlist 엑셀업로드" />
</jsp:include> --%>
<jsp:include page="/common/file" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="fileLayerId" value="primaryFileUploadModal" />
	<jsp:param name="fileFormId" value="formFile" />
	<jsp:param name="fileFormAction" value="/api/admin/watchlist/json/upload" />
	<jsp:param name="pageTitle" value="Watchlist 엑셀업로드" />
	<jsp:param name="fileListYN" value="N" />
	<jsp:param name="paramName1" value="cate_cd" />
	<jsp:param name="paramName2" value="list_cd" />
	<jsp:param name="fileExtLimit" value="json" />
</jsp:include>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var <c:out value="${admWatchTblId}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/ctgrList',
	columns : [
		{ data: "aiInptCtgrNm", title: '카테고리명' }
    ],
    columnDefs : [
    	{ 
        	orderable: false,
        	sortable: false,
        	className:'text-center',
        	targets: '_all'
    	},
    	{
    		targets: [0],
    		width: 80
    	}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		/* if($("#schUserAuth<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth<c:out value="${pageId}"/>").val();
		} */
		
		return options;
	}
};
var <c:out value="${admWatchTblId2}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/groupList',
	columns : [
		{ data: "aiInptListNm", title: '리스트' }
    ],
    columnDefs : [
    	{ 
        	orderable: false,
        	sortable: false,
        	className:'text-center',
        	targets: '_all'
    	},
    	{
    		targets: [0],
    		width: 80
    	}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		if($("#aiInptCtgrId").val()){
			options.aiInptCtgrId = $("#aiInptCtgrId").val();
		}
		
		return options;
	}
};
var <c:out value="${admWatchTblId3}"/>Config = {
	ajaxUrl : '/api/admin/watchlist/contList',
	columns : [
    	{"data": "aiInptRsptTxtDesTxt", title: '내용'}
    ],
    columnDefs : [
    	{ 
        	orderable: false,
        	sortable: false,
        	className:'text-center',
        	targets: '_all'
    	},
    	{
    		targets: [0],
    		width: 80
    	}
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
		
		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollY" value="145" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollY" value="145" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admWatchTblId3}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollY" value="145" />
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
	//상세정보 설정
	fnSetDetail3(row);
};
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail(row){
	if(row){
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
	
	//하위 그리드 갱신.
	<c:out value="${admWatchTblId2}"/>.searchList();
	<c:out value="${admWatchTblId3}"/>.searchList();
}
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail2(row){
	if(row){
		//상세/수정 모드
		$("#aiInptListId").val(row.aiInptListId);
		$("#aiInptListNm").val(fnCmnXssUnescape(row.aiInptListNm));
	} else {
		//신규모드
		$("#aiInptListId").val("");
		$("#aiInptListNm").val("");
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
		//신규모드
		$("#aiInptRsptTxtSrno").val("");
		$("#aiInptRsptTxtDesTxt").val("");
	}
}
$(function(){

	//############# 카테고리 #############
	
	//카테고리 신규버튼
	$("#newBtn1").click(function(e){
		fnSetDetail(null);
	});
	
	//카테고리 저장버튼
	$("#saveBtn1").click(function(e){
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
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptCtgrNm = $('#aiInptCtgrNm').val();
		param.aiInptCtgrTxt = $('#aiInptCtgrTxt').val();
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
		if($.trim($('#aiInptCtgrId').val())==""){
			alert("카테고리 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/watchlist/ctgr/delete/'+$('#aiInptCtgrId').val(),
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
		fnSetDetail2(null);
	});
	
	//리스트 저장버튼
	$("#saveBtn2").click(function(e){
		if($.trim($('#aiInptListNm').val())==""){
			alert("리스트명을 입력해주세요.");
			$('#aiInptListNm').focus();
			return;
		}
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptListId = $('#aiInptListId').val();
		param.aiInptListNm = $('#aiInptListNm').val();
		$.post('/api/admin/watchlist/group',param,function(data){
			if(data.resultCode=='200'){
				alert('정상적으로 처리되었습니다.');
				<c:out value="${admWatchTblId2}"/>.searchList();
				fnSetDetail2(null);
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
				url: '/api/admin/watchlist/group/delete/'+$('#aiInptCtgrId').val()+'/'+$('#aiInptListId').val(),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admWatchTblId2}"/>.searchList();
					fnSetDetail2(null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});

	//############# 내용 #############
	
	//내용 신규버튼
	$("#newBtn3").click(function(e){
		fnSetDetail3(null);
	});
	
	//내용 저장버튼
	$("#saveBtn3").click(function(e){
		if($.trim($('#aiInptListNm').val())==""){
			alert("내용을 입력해주세요.");
			$('#aiInptRsptTxtDesTxt').focus();
			return;
		}
		var param = {};
		param.aiInptCtgrId = $('#aiInptCtgrId').val();
		param.aiInptListId = $('#aiInptListId').val();
		param.aiInptRsptTxtSrno = $('#aiInptRsptTxtSrno').val() ? $('#aiInptRsptTxtSrno').val() : "0";
		param.aiInptRsptTxtDesTxt = $('#aiInptRsptTxtDesTxt').val();
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
		if($.trim($('#aiInptRsptTxtSrno').val())==""){
			alert("내용 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/watchlist/cont/delete/'+$('#aiInptCtgrId').val()+'/'+$('#aiInptListId').val()+'/'+$('#aiInptRsptTxtSrno').val(),
				data: {},
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
		//location.href = "/admin/watchlist/excel/download2";
		location.href = "/admin/watchlist/json/download";
	});
	
	$("#xlsBtn3").click(function(e){
		//엑셀업로드 버튼 클릭시 처리.
		var formFile = $('#formFile')[0];
		var aiInptCtgrId = $.trim($("#aiInptCtgrId").val());
		var aiInptListId = $.trim($("#aiInptListId").val());
		
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
fileUploadControl<c:out value="${pageId}" />.uploadCallback = function(list,errInfo){
	//console.info(list);
	if(errInfo){
		alert(errInfo.msg);
	} else {
		alert("정상적으로 처리되었습니다.");
		fileUploadControl<c:out value="${pageId}" />.closeLayer();
		<c:out value="${admWatchTblId3}"/>.searchList();
	}
};
</script>