<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>

<script type="text/javascript" src="${ctx_res}/vendors/jquery/js/jquery.min.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/jquery/js/jquery.form.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/custom_style.css"/>

<script src="${ctx_res}/js/common_detail.js"></script>

<c:set var="pageId" value="9999"/>
<c:set var="dataTableId" value="dataTable_manual"/>
<div class="manualContentsWrapper">
	<div class="manualWinTitleWrapper">
		<span class="manualWinTitle">사용자매뉴얼</span>
	</div>
	
	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
		
		<div class="manualBtnWrapper">
			<c:if test="${adminYN eq 'Y'}">
				<form enctype="multipart/form-data" method="post" name="manualform" id="manualform" action="/api/common/manual/upload">
					<input type="text" id="viewManualFileName" readonly="readonly"/>
					<label for="manualFile" class="manualFileLabel" style="cursor: pointer;">파일검색</label>
					<input type="file" name="manualFile" id="manualFile" class="" style="display: none;"/>
					<button type="button" class="manualUploadSubmit" id="manualUploadSubmit">파일업로드</button>
				</form>
			</c:if>
			<c:if test="${adminYN ne 'Y' }">
				<div class="manualAuthMsgWrapper">
					<span class="manualAuthMsg">※ 사용자매뉴얼 파일 업로드 및 삭제는 관리자권한을 가진 사용자만 가능합니다.</span>
				</div>
			</c:if>
		</div>
	</div>
</div>

<form name="formDown" action="/common/down" method="post">
	<input type="hidden" name="inptMstSrno" value="" />
	<input type="hidden" name="aiInptAtflSrno" value="" />
</form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script>
function downFile(filePath, orgFileName, inptMstSrno, aiInptAtflSrno){
	var formDown = document.formDown;

	formDown.inptMstSrno.value = inptMstSrno;
	formDown.aiInptAtflSrno.value = aiInptAtflSrno;
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("1001", "", "26", "");
	
	formDown.submit();
}

var fileUploadControl = {
		fileIdx : 0,
		removeFiles : [],
		fileExtLimit : ['txt','pptx','ppt','xlsx','xls','pdf','doc','docx','json','jpg','png','gif','bmp'],
		//fileExtLimit : 'txt',
		
		getLayer : function(){
			return $("#fileListLayer");
		},
		getFileList : function(){
			var list = this.getLayer().find("tbody > tr");
			return list;
		},
		getFileItem : function(idx){
			var result = null;
			var list = this.getFileList();
			list.each(function(idx2,obj){
				var item = $(obj);
				if( item.data('idx')==idx ){
					result = item;
					return false;
				}
			});
			return result;
		},
		getFileCnt : function(){
			var list = this.getFileList();
			return list.length - 1;
		},

		removeFileItem : function(aiInptAtflSrno, inptMstSrno){
			
			var authDataVali = JSON.parse(sessionStorage.getItem('auth_data'));
			
			
			if(authDataVali.admin_yn == 'Y'){
				var option = {};
				option.aiInptAtflSrno = aiInptAtflSrno;
				option.inptMstSrno = inptMstSrno;
				
				option.aiInptCnctScrnNo = "1001";
				option.aiInptCnctFldCd = "";
				option.aiInptCnctActiCd = "06";
				option.aiInptCnctParmTxt = "";
				//프로그램 사용 이력 로그누적
				//fnCmnProgramLog("1001", "", "06", "");
				
				if(confirm("파일을 삭제하시겠습니까?")){
					$.get('/api/common/manual/delUploadedFile', option, function(data){
		            	var json = data.result;
		            	var httpjson = data.httpResult;
		            	
		            	if(json && httpjson){
		            		alert('삭제하였습니다.');
		            		//swal("Success", "파일을 삭제하였습니다.", "success");
		            		searchTableReload();
		            	}else{
		            		if(!json){
		            			alert('파일 삭제를 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.');
		            		}else if(!httpjson){
		            			alert('common agent 파일 삭제를 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.');
		            		}
		            	}
		            });
				}
			}
			
			
		},
		uploadCallback : function(errInfo){
			if(errInfo){
				alert(errInfo.msg);
			} else {
				alert("정상적으로 처리되었습니다.");
				h_loading();
				$("#manualFile").text("");
				searchTableReload();
			}
		} 
	};

var options = {
	dataType: 'json',
	success:function(data){
		fileUploadControl.uploadCallback(null);
	},
	error: function(e){
		var errInfo = {'code':'-1','msg':'파일 업로드가 실패하였습니다.'};
		fileUploadControl.uploadCallback(errInfo);
	}
};  
$(function() {
	initLoadingDisplay("Y", "class", "app-body");
	
	$('.app-body').css('margin', '0');
	
	$(document).on('change', '#manualFile', function(){
		$("#viewManualFileName").val($(this).val());
	});
	
	// 매뉴얼 업로드&다운로드 팝업
	$(document).on('click', '#manualUploadSubmit', function(){
		
		//var fileInputTarget = $(this).attr('class').split(' ')[0];
		var fileInput = $("#manualFile");
		var filePath = fileInput.val();
		var fileExt = fnCmnGetFileExt(filePath);
		var fileUploadMaxSize = ${uploadMaxSize};
		
		if(fileInput.val() != null && fileInput.val() != ""){
			if(confirm("해당 매뉴얼 파일을 업로드 하시겠습니까?")){
				/*
				console.log("confirm check");
				console.log("file path: ", filePath);
				console.log("file ext: ", fileExt);
				// 확장자 막을부분
				console.log("file size: " + document.manualform.manualFile.files[0].size); 
				console.log("file upload max size: " + fileUploadMaxSize);*/
				
				if(document.manualform.manualFile.files[0].size > fileUploadMaxSize){
					alert('최대 20 MB 의 파일을 업로드 할 수 있습니다.');
					return;
				}
				else if(fileUploadControl.fileExtLimit.indexOf(fileExt)==-1){
					var errInfo = {'code':'-1','msg':'허용되지 않은 확장자입니다.\n확장자를 확인해주시기 바랍니다.'};
					fileUploadControl.uploadCallback(errInfo);
					return;
				}
				else{
					$("#manualform").ajaxForm(options).submit();
					s_loading();
					$('.loadingTitle').text("File Uploading");
				}
				/*
				if(fileUploadControl.fileExtLimit.indexOf(fileExt)==-1){
					var errInfo = {'code':'-1','msg':'허용되지 않은 확장자입니다.\n확장자를 확인해주시기 바랍니다.'};
					fileUploadControl.uploadCallback(errInfo);
					return;
				}
				else if(document.manualform.manualFile.files[0].size > 20971520){
					alert('최대 20 MB 의 파일을 업로드 할 수 있습니다.');
					return;
				}
				else{
					$("#manualform").ajaxForm(options).submit();
					s_loading();
					$('.loadingTitle').text("File Uploading");
				}*/
			}
		}else{
			alert('파일을 검색해주세요.');
			return;
		}
		
		
	});
});
/*
 	private String inptMstSrno;
	private String aiInptAtflSrno;
	private String aiInptAtelNm;
	private String aiInptAtelPathTxt;
	private String trnLogSrno;
	private String lstDbChgDtm;
	private String lstDbChgId;
	private String aiInptBizDscd;
 */
var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/common/manual/list',
		columnDefs: [
			 { targets: 0, className: 'td-text-center td-text-20'}	// no
			,{ targets: 1, className: 'td-text-left td-text-100'}	// 파일명
			,{ targets: 2, className: 'td-text-center td-text-20'} 	// 삭제
			,{ targets: 3, visible: false}							// 마스터번호
			,{ targets: 4, visible: false}							// 파일경로
			,{ targets: 5, visible: false}							// PK2
			
		],
		columns: [
			{"data": "aiInptAtelNm", title: '파일명' , render: function(data, type, row, meta){
		   		return '<a class="nav-link active" href="javascript:downFile(\''+row.aiInptAtelPathTxt+'\',\''+row.aiInptAtelNm+'\',\''+row.inptMstSrno+'\',\''+row.aiInptAtflSrno+'\');" style="padding: 2px 5px;" >'
		   		+row.aiInptAtelNm+'</a>';
		   	}}
			,{"data": "", title: '', render: function(data, type, row, meta){
		   		return '<span class="badge badge-primary badge-pill manualFileDelBtn" style="cursor:pointer;background-color:#f86c6b;z-index:0;" onclick="fileUploadControl.removeFileItem('+row.aiInptAtflSrno+','+row.inptMstSrno+');">삭제</span>';
		   	}}
			,{"data": "inptMstSrno"}
			,{"data": "aiInptAtelPathTxt"}
			,{"data": "aiInptAtflSrno"}
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	
	    	$('.top').css('display', 'none');
	    	
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			//options.aiSysInptPrgStcd = $("#cbo_aiSysInptPrgStcd_Search_"+page_id).val();	// 심사진행상태 조건
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("8050",null,"01",$.param(options));
			
			return options;
			
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
			
			var authDataVali = JSON.parse(sessionStorage.getItem('auth_data'));
			if(authDataVali.admin_yn == 'N'){
				var deleteBtn = $(nRow).find('td:eq(2)').find('.manualFileDelBtn');
				deleteBtn.css('background-color', '#b3b3b3');
				deleteBtn.css('cursor', 'not-allowed');
			}
		}
	};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="150" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){	

};

var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){	

};

function searchTableReload(){
	<c:out value="${dataTableId}"/>.searchList();
}

</script>