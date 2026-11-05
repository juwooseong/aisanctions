<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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

<c:set var="pageId" value="9090"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<c:set var="dataTableId2" value="dataTable2_${pageId}"/>

<div class="wrap layout_type_popup history_popup" style="height: 100%;min-height: 800px; overflow: hidden;">
	<div class="layout_container">
		<h2 class="title">
			<strong>QA이력 [9090]</strong>
		</h2>
		<div class="contents" style="margin-bottom: 46px;">
			<div class="tbWrap" style="margin-bottom: 0px;"">
				<div class="tbTop">
					<strong>QA이력</strong>
					<span style="position: absolute; top: 54px; left: 74px; color: #2f353a; font-weight:600;" class="historyEno">
						 <span id="actlFxRefno" style="float : right; color: #2f353a; font-size: 12.5px; font-weight: 450; line-height: 27px;"></span> 
					</span> 
				</div>
				<div class="tbCon" style="margin-top: 8px;" padding: 8px 7px 7px 7px;">
					<table class="table table-responsive-sm width-100" id="<c:out value="${dataTableId}"/>"></table>
				</div>
				<div class="text-right" style="margin-top:10; height:73px;">
					<span id="optTxt">
						<span class="historyEno" style="position: absolute; top: 446px; right: 542px;">추가의견 : </span>
						<textarea wrap="physical" style="width: 525px; height: 47px; padding:7px 7px; font-size: 12px" id="textOpt" placeholder="추가할 의견을 입력해주세요."></textarea>
						<span class="" style="text-align: right;display: block;">
							<span class="r">
								<button class="btType1" type="button" onclick="insertOptText();" style="margin-top: 8px;">저장</button> 
							</span>
						</span>
						<!-- <a href="javascript:void(0);" class="btType1" id="saveBtn1">저장</a> -->
					</span>
				</div>
			</div>

			
			<div class="col-sm-12" id="uploadForm">
				<div class="content">
					<div class="tab-pane active" id="bl_1" role="tabpanel">
						<div class="row">
	
							<div class="tbWrap" id="">
								<div class="tbTop">
									<strong>첨부파일 업로드</strong>
								</div>
							</div>
	
	
							<div class="inner-contents-wrapper" style="margin-top: 8px;">
								<div class="inner-contents">
									<div class="inner-content-1">
										<div class="tbWrap" id="upload2">
											<div class="tbCon text-center" id="upload2" >
												<table class="table table-responsive-sm width-100" id="<c:out value="${dataTableId2}"/>"></table>
											</div>
										</div>
									</div>
							
									<div class="inner-content-2">	
										<div class="tbCon" id="uploadList">
											<div class="tbCon text-center" id="upload1">
												<form enctype="multipart/form-data" method="post" name="fileForm" id="multiform" action="/api/common/qa/history/upload">
													<div class="upload">
														<div id="input-file-area" style="">
															<input type="file" name="fileUPload" id="fileUPload" multiple="multiple" style="display:none;" /> 
														</div>
												
														<span class="bt" style="text-align-last: left;text-align: left;display: block;width: 100%;margin-bottom: 10px;color: #ff0000;font-weight:500;font-size: 12px;">
														※ 확장자는 txt, pptx, ppt, xlsx, xls, pdf, doc, docx, json, jpg, png, gif, bmp 만 가능합니다.
														</span>
														<div id="forUploadFille" class="file-name" style="border:2px solid #c9c9c9;margin-bottom: 10px;min-height: 150px;padding: 5px;line-height: 20px;text-align: left;"></div>
													</div>
													<input type="hidden" name="inptAtmcBizDscd" id="inptAtmcBizDscd" value="">
													<input type="hidden" name="inptMstSrno" id="inptMstSrno" value="" />
													<input type="hidden" name="MFNum" id="MFNum" value="" />
													<input type="hidden" name="delArr" id="delArr" value="" /> 
													<input type="hidden" name="cnt" id="cnt" value="" />
													<input type="hidden" id="uploadMaxSize" value="${uploadMaxSize}">		
												</form>
											</div>
											<span class="" style="text-align: right;display: block;">
												<span class="r">
													<button class="btType2" type="button" onclick="fileReset();">신규</button>
													<button class="btType2" type="button" id="btn-upload">파일검색</button>
													<button class="btType1" type="button" onclick="uploadFile();">파일업로드</button> 
												</span>
											</span>
										</div>
									</div>
								</div>
							</div>
							 <div class="tbCon" style="height: 47px; border:#fff;">
						  		<span style="position: absolute; top: 287px; left: 0px;" class="historyEno">
									Master ID : <strong id="masterId"></strong> 
								</span>
								<span style="position: absolute; top: 287px; right: 1px;" class="historyEno">
									QA 담당자 : <strong id="aiInptCrpeNm"></strong> (<strong id="qlasCrpeEno"></strong>)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									QA 담당 결재자 : <strong id="aiInptSnpeNm"></strong> (<strong id="qlasSnpeEno"></strong>)
								</span> 
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<input type="hidden" id="aiInptPrgSrno" value="" />
<input type="hidden" id="aiInptAcvtStsCd" value="" />
<form name="formDown" action="/common/down" method="post">
	<input type="hidden" name="inptMstSrno" value="" />
	<input type="hidden" name="aiInptAtflSrno" value="" />
</form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<%@include file="/WEB-INF/jsp/common/progres.jsp"%>

<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="310" />
	<jsp:param name="gridRowCallback" value="N" />
</jsp:include>

<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="110" />
	<jsp:param name="gridRowCallback" value="N" />
</jsp:include>

<script>

$(function() {
	$('#optTxt').hide();
	
});

var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail(row, index);
};

function fnSetDetail(row, index){
	var userData = JSON.parse(sessionStorage.getItem('auth_data'));
	if(row && userData.eno == row.aiInptCrpeEno){
		$('#optTxt').show();
		$('#aiInptPrgSrno').text(row.aiInptPrgSrno);
		$('#aiInptAcvtStsCd').text(row.aiInptAcvtStsCd);
	}else{
		$('#optTxt').hide();
	} 	
}

function insertOptText(){
	var options = {};
	if($.trim($('#textOpt').val())==""){
		alert("추가할 의견을 입력해주세요.");
		return;
	}
	options.aiInptPrgSrno = $('#aiInptPrgSrno').text();
   //	options.inptAtvtCd = '120';
  // 	options.aiInspAtvtStsCd = '160';
	options.inptMstSrno = Number($('#masterId').text());
	options.aiInspAtvtStsCd = $('#aiInptAcvtStsCd').text();
   	options.textOpt = $('#textOpt').val(); 
   	
		$.post('/api/common/qa/history/updateOpt',options,function(data){
			if(data.resultCode=='200'){
				<c:out value="${dataTableId}"/>.searchList();
				$('#textOpt').val("");
			} else {
				if(data.exceptResult == 'DIException'){
					alert("추가 의견을 포함한 심사의견은 4000자를 넘을 수 없습니다.");
					$('#textOpt').focus();
				}else{
					alert(data.resultMsg);
				}
		
			}
		});	
}

var pageParams = [];
pageParams['inptMstSrno'] = '<c:out value="${param.inptMstSrno}"/>';
pageParams['actlFxRefno'] = '<c:out value="${param.actlFxRefno}"/>';
pageParams['inptAtmcBizDscd'] = '<c:out value="${param.inptAtmcBizDscd}"/>';
var sel_files = [];
var delArr ='';
var MFNum = 0;
var cnt = 0;
$('#btn-upload').click(function (e) {
	e.preventDefault();
	var MFNum = $('#MFNum').val();
	if(MFNum == ''){
		$('#fileUPload').click();
	}else{
		$('#fileUPload' + MFNum).click();
	}

});

$(function() {
	$('.app-body').css('overflow-y','hidden');
	initLoadingDisplay("Y", "class", "history_popup");
	var form = $("#multiform")[0];
	var inptMstSrno = g_getUrlVar('inptMstSrno');
	if(inptMstSrno==0){
		document.getElementById("uploadForm").style.display="none";
	}
	
	for(var i=0; i<10; i++){
		$("#input-file-area").append("<input type='file' name='fileUPload"+i+"' id='fileUPload"+i+"' multiple='multiple' onchange='handleFiles("+i+")' style='display:none;'/>");
	}
	
	form.inptMstSrno.value = inptMstSrno;
	
	$("input[type=file]").change(function () {
		var del = 0;
		var fileInput; // = document.getElementById("fileUPload");	
		var cnt = $("#cnt").val();
	//	var n = $("#MFNum").val();
		if(MFNum == 0){ // ★
			fileInput = document.getElementById("fileUPload");
		}  else{ //★
			fileInput = document.getElementById("fileUPload"+MFNum); //★
		}   //★
		var files = fileInput.files;
		var file;
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("9090", "14", "24", $.param({inptMstSrno : inptMstSrno}));
		
		for(var i=0; i<files.length; i++){
			file = files[i];
			var contains = $("div[id='forUploadFille']:contains("+file.name+")");
			var delFileName = file.name;
			var count = 1;
			if(cnt == '10'){
				alert("파일은 총 10개까지만 업로드가 가능합니다.");
				break;
			}
			$("#forUploadFille").append(file.name+"<br>");		
				del++;
				cnt++;
		}
		$("#MFNum").val(MFNum);
		$("#cnt").val(cnt);
		MFNum++; 
	})
});

$(document).on('click','.icon-close', function(e) {
	delArr += $(this).closest('.cancle').attr('id') + '/';
	$("#delArr").val(delArr);
});


function handleFiles(MFNum) {
	var fileInput = document.getElementById("fileUPload"+MFNum);
	var files = fileInput.files;
	var file;
	var del2=0;
	var cnt = $("#cnt").val();
	for(var i=0; i<files.length; i++){
		file = files[i];
		var contains = $("div[id='forUploadFille']:contains("+file.name+")");
		var delFileName = file.name;
		var count = 1;
		if(cnt == '10'){
			alert("파일은 총 10개까지만 업로드가 가능합니다.");
			break;
		}
		$("#forUploadFille").append("<span class='cancle' id="+MFNum+"_"+del2+">"+file.name+"<span style='display: inline-block; margin-left: 5;'>"
		     							+ "<i id='fileOneDelete_"+MFNum+"_"+del2+"' class='icon-close icons' style='font-size: 15px; color: #f86c6b;"
										+ "'></i></span></span><br>"); //0, 0_0, 0_1, 0_2, 1_0, 1_1 ...
		del2++;
		cnt++;
	}
	MFNum++; 
	$("#MFNum").val(MFNum);
	$("#cnt").val(cnt);
}

var <c:out value="${dataTableId2}"/>Config = {
	ajaxUrl : '/api/common/qa/history/uploadList',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-left td-text-300', title: '파일명'},
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, visible: false }
	],
	columns: [
	   	{data: 'aiInptAtflNm' , render: function(data, type, row, meta){
	   		return '<a class="nav-link active" href="javascript:downFile(\''+row.aiInptAtflPathTxt+'\',\''+row.aiInptAtflNm+'\',\''+row.inptMstSrno+'\',\''+row.aiInptAtflSrno+'\');" style="padding: 2px 5px;" >'
	   		+row.aiInptAtflNm+'</a>';
	   	}},
	   	{render: function(data, type, row, meta){
	   		return '<span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#f86c6b;z-index:0;" onclick="fileUploadControl.removeFileItem('+row.aiInptAtflSrno+','+row.inptMstSrno+');">삭제</span>';
	   	}},
	   	{data: 'aiInptAtflSrno'}
	   ],
	   getSearchOption : function() {
		   	var page_id = '<c:out value="${pageId}"/>';
		   	var options = {};
			var filters = [];
			var inptMstSrno = g_getUrlVar('inptMstSrno');
			var inptAtmcBizDscd = $("#inptAtmcBizDscd").val();
			var inptAtmcBizDscd = g_getUrlVar('inptAtmcBizDscd');
			options.inptAtmcBizDscd = inptAtmcBizDscd;
			options.inptMstSrno = inptMstSrno;
			options.inptAtmcBizDscd = inptAtmcBizDscd;
			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("9090", "14", "01", $.param(options));
			$('#dataTable2_9090_info').prependTo($('#upload2'));
			$('#dataTable2_9090_info').css({'font-size':'12px', 'margin-bottom':'10px'});
			//$('#dataTable2_9090').css('height','110px');
			
			return options;
	}
};  
	
function downFile(filePath,orgFileName, inptMstSrno, aiInptAtflSrno){
	var formDown = document.formDown;

	formDown.inptMstSrno.value = inptMstSrno;
	formDown.aiInptAtflSrno.value = aiInptAtflSrno;
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("9090", "14", "26", $.param({filePath : filePath, orgFileName : orgFileName}));
	
	formDown.submit();
}

function fileReset() {
	$("#forUploadFille").empty();
	$("#fileUPload").val('');
	$("#fileUPload0").val('');
	$("#fileUPload1").val('');
	$("#fileUPload2").val('');
	$("#fileUPload3").val('');
	MFNum = 0;
	cnt = 0;
	$("#MFNum").val('');
	$("#cnt").val('');
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
		var option = {};
		option.aiInptAtflSrno = aiInptAtflSrno;
		option.inptMstSrno = inptMstSrno;
		
		option.aiInptCnctScrnNo = "9090";
		option.aiInptCnctFldCd = "14";
		option.aiInptCnctActiCd = "06";
		option.aiInptCnctParmTxt = "inptMstSrno="+inptMstSrno+"&aiInptAtflSrno="+aiInptAtflSrno;
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("9090", "14", "06", $.param({aiInptAtflSrno : aiInptAtflSrno, inptMstSrno : inptMstSrno}));
		
		if(confirm("파일을 삭제하시겠습니까?")){
			$.get('/api/common/qa/history/delUploadedFile', option, function(data){
            	var json = data.result;
            	var httpjson = data.httpResult;
            	
            	if(json && httpjson){
            		alert('삭제하였습니다.');
            		//swal("Success", "파일을 삭제하였습니다.", "success");
            		<c:out value="${dataTableId2}"/>.searchList();
            	}else{
            		if(!json){
            			alert('파일 삭제를 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.');
            		}else if(!httpjson){
            			alert('common agent 파일 삭제를 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.');
            		}
            	}
            });
		}
	},
	uploadCallback : function(errInfo){
		if(errInfo){
			alert(errInfo.msg);
			$("#forUploadFille").empty();
			$("#fileUPload").val('');
		} else {
			h_loading(); 
			<c:out value="${dataTableId2}"/>.searchList();
			$("#forUploadFille").empty();
			$("#fileUPload").val('');	
			$("#MFNum").val('');
			$("#cnt").val('');
			MFNum = 0;
			cnt = 0;
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
		
//파일 업로드 처리.
//jquery.form.js 플러그인 사용 방식.
function uploadFile(){
	var fileInput;
	var fileSize;
	var agent = navigator.userAgent.toLowerCase();
	/* if(agent.indexOf("chrome") == -1){
		var oas = new ActiveXObject("Scripting.FileSystemObject");
		fileSize = oas.getFile(document.fileForm.fileUPload.value).size;
	}else{
		fileSize = document.fileForm.fileUPload.files[0].size;
	} */
	fileSize = document.fileForm.fileUPload.files[0].size;
	var maxSize = $("#uploadMaxSize").val();
	if(Number(fileSize) > Number(maxSize)){
		alert("용량이 20MB 이하인 파일만 업로드 해주시기 바랍니다.");
		return;
	}
	
	var MFNum = $('#MFNum').val();
	if(MFNum == 0){
		fileInput = $('#fileUPload')
	}else{
		fileInput = $('#fileUPload'+MFNum)
	}

	
	var filePath = $.trim(fileInput.val());
 	if(!filePath && MFNum == 0){
		alert('파일을 선택해주세요.');
		return;
	} 
	
	//확장자 제한처리
	var fileExtLimit = fileUploadControl.fileExtLimit;
	
	if(fileExtLimit && filePath){
		var fileExt = fnCmnGetFileExt(filePath);
		fileExt = fileExt ? fileExt.toLowerCase() : '';
		fileExt = fileExt.toLowerCase();

		if(fileExtLimit.indexOf(fileExt)==-1){
			var errInfo = {'code':'-1','msg':'허용되지 않은 확장자입니다.\n홪장자를 확인해주시기 바랍니다.'};
			fileUploadControl.uploadCallback(errInfo);
			return;
		}
	}

	$("#multiform").ajaxForm(options).submit();
	s_loading();
	$("#fileUPload").val('');
	$("#fileUPload0").val('');
	$("#fileUPload1").val('');
	$("#fileUPload2").val('');
	$("#fileUPload3").val('');
}

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/common/qa/history',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-10' },
		{ targets: 1, className: 'td-text-left td-text-80 td-long-content' },
		{ targets: 2, className: 'td-text-left td-text-40' },
		{ targets: 3, className: 'td-text-center td-text-60' },
		{ targets: 4, className: 'td-text-center td-text-50' },
		{ targets: 5, className: 'td-text-left td-text-40' },
		{ targets: 6, className: 'td-text-left td-text-200' },
		{ targets: 7, visible: false },
		{ targets: 8, visible: false },
		{ targets: 9, visible: false },
		{ targets: 10, visible: false },
		{ targets: 11, visible: false },
		{ targets: 12, visible: false },
		{ targets: 13, visible: false },
		{ targets: 14, visible: false },
		{ targets: 15, visible: false },
		{ targets: 16, visible: false },
		{ targets: 17, visible: false },
		{ targets: 18, visible: false }
	],
	columns: [

    	{"data": "aiInspAtvtNm", title: '액티비티' },
    	{"data": "damdang", title: '담당자' }, 
    	{"data": "startTime", title: '시작시간', render: function(data, type, row, meta){ 
   			var temp = data.split('.');
   			var startTime = temp[0];
    		return startTime
    	}},
    	{"data": "timeDiff", title: '처리시간', render: function(data, type, row, meta){ 
   			if(data == '0000::'){
   				data = '';
   			}
   			return data;
    	}},
    	{"data": "aiInspAtvtStsNm", title: '처리'},
    	{"data": "aiInspPrcOpi", title: '심사의견', render : function(data, type, row, meta){
    		if(data !=null){
    			data = data.replace(/\n/g, '<br>');
    		}
    		return data;
    	}},
    	{"data": "trnlogsrno" , render: function(data, type, row, meta){ 
   			var form = $('form[name="fileForm"]');
   			form.append('<input type="hidden" name="trnlogsrno" value="'+data+'" />')
    	}},
    	{"data": "lstDbChgId" , render: function(data, type, row, meta){ 
			var form = $('form[name="fileForm"]');
   			form.append('<input type="hidden" name="lstDbChgId" value="'+data+'" />')
   		}},
    	{"data": "lstDbChgDtm" , render: function(data, type, row, meta){ 
			var form = $('form[name="fileForm"]');
   			form.append('<input type="hidden" name="lstDbChgDtm" value="'+data+'" />')
    	}},
    	{"data": "inptAtmcBizDscd", render: function(data, type, row, meta){ 
    		$("#inptAtmcBizDscd").val(data);
    	}},
    	{"data": "qlasSnpeEno", render: function(data, type, row, meta){ 
    		$("#qlasSnpeEno").text(data);
    	}},
    	{"data": "qlasCrpeEno", render: function(data, type, row, meta){ 
    		$("#qlasCrpeEno").text(data);
    	}},
    	{"data": "aiInptSnpeNm", render: function(data, type, row, meta){ 
    		$("#aiInptSnpeNm").text(data);
    	}},
    	{"data": "aiInptCrpeNm", render: function(data, type, row, meta){ 
    		$("#aiInptCrpeNm").text(data);
    	}},
    	{"data": "inptMstSrno", render: function(data, type, row, meta){ 
    		$("#masterId").text(data);
    	}},
    	{"data": "fxRefnoSrno", render: function(data, type, row, meta){ 
    		var refNo = row.actlFxRefno.concat(" / ");
    		refNo = refNo.concat(data);

    		$("#actlFxRefno").text(refNo);
    	}},
    	{"data": "aiInptAcvtStsCd"}
    ],
    getSearchOption : function() {
    	var options = {};			
		var inptMstSrno = g_getUrlVar('inptMstSrno');

		options.inptMstSrno = inptMstSrno;
		
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("9090", null, "01", $.param(options));

		return options;
	}
};
</script>