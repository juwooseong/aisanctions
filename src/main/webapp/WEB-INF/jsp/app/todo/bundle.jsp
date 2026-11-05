<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<link href="${ctx_res}/css/custom_style.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<c:set var="pageId" value="_app_todo_bundle" />
<c:set var="dataTableId" value="listTable${pageId }" />
<div class="appv-container-wrapper">
	<div class="appv-container">
		<div class="appv-content-wrapper">
<div class="appv-container-title-wrap">
<span class="appv-container-title">일괄승인</span></div>

			<div class="appv-content-left">
				<div class="card">
					<div class="card-header bl-img-card-header">
					<span class="appv-content-title">의견목록</span>
					</div>
					<div class="contents">
						<div class="tbWrap">
							<div class="tbCon cleanHead">
								<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="appv-content-right">
				<div class="card">
					<div class="card-header">
					<span class="appv-content-title">결재의견</span>
					</div>
					<div class="card-body overflow-outo">
						<div class="tab-content bl-card-body" style="height:450px !important;border:0;border:0;">
							<textarea id="rspt_inpt_apv_req_txt" class="opi-text-check" style="width:100%;height:100%;border:1px solid #c8ced3;resize:none;padding: 10px;" placeholder="전달의견 목록을 선택하거나 의견을 작성해주세요"></textarea>
							<span id="opi_text_length">0 / 4000 byte</span>
						</div>
					</div>
				</div>
			</div>
			
			<div class="appv-footer-wrapper">
				<span class="appv-footer">
					<button class="btType1" onclick="fnApprove();" style="margin: 0px 8px 0px 8px;">승인</button>
					<button class="btType2" onclick="fnCloseBundle();" style="margin: 0px 8px 0px 8px;">닫기</button>
				</span>
			</div>
		</div>
	</div>
	
</div>
<form id="formParamData" style="position: absolute;opacity: 1;"></form>
<form id="formLogParam" style="position: absolute;opacity: 1;"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>

<script src="${ctx_res}/js/common_detail.js"></script>

<script>
var orgOpiText = "";
$(function(){
	initLoadingDisplay("Y", "class", "container-fluid");
	$('.app-body').removeClass('app-body');
});

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/app/todo/bundle',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20', orderable: false },
		{ targets: 1, className: 'td-text-left td-text-100'}
	],
	columns : [
    	{"data": "aiInptAppvOpiTxt", title: '내용'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		//침해사고명
		if($("#incident_name").val()){
			//options.incident_name = $("#incident_name").val();
		}
		
		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
</jsp:include>
<script>
// 4000 자 제한
/*
function fn_setOpiData() {
	if($globaObjlData.selectOpi != null) {
		$('#rspt_inpt_apv_req_txt').empty().val($globaObjlData.selectOpi.aiInptPrcOpiTxt);
		var _opiTextLength = fnCheckByteSize($globaObjlData.selectOpi.aiInptPrcOpiTxt);
		$('#opi_text_length').text(_opiTextLength + ' / 4000 byte');
	}
}*/


var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	fnSetMemo(row.aiInptAppvOpiTxt);
	orgOpiText = row.aiInptAppvOpiTxt;
	fn_setOpiData_bun(orgOpiText);
};

function fn_setOpiData_bun(orgOpiText) {
	console.log(orgOpiText);
	if(orgOpiText != null) {
		$('#rspt_inpt_apv_req_txt').empty().val(orgOpiText);
		var _opiTextLength = fnCheckByteSize(orgOpiText);
		$('#opi_text_length').text(_opiTextLength + ' / 4000 byte');
	}
}

function fnApprove(){
	if(confirm("승인처리 하시겠습니까?")){
		var ids = '<c:out value="${param.ids}"/>'.split(",");
		var aiInptAppvHstIds = '<c:out value="${param.aiInptAppvHstIds}"/>'.split(",");
		var inptAtmcBizDscds = '<c:out value="${param.inptAtmcBizDscd}"/>'.split(",");
		var aiInptTpySaveYns = '<c:out value="${param.aiInptTpySaveYn}"/>'.split(",");
		var aiInptCrpeEnos = '<c:out value="${param.aiInptCrpeEno}"/>'.split(",");
		var totaltextAiInptRstCds = '<c:out value="${param.totaltextAiInptRstCd}"/>'.split(",");
		var itmInptAiInptRstCds = '<c:out value="${param.itmInptAiInptRstCd}"/>'.split(",");
		var aiInptQlasPrgStsCds = '<c:out value="${param.aiInptQlasPrgStsCd}"/>'.split(",");
		var inptAtvtCds = '<c:out value="${param.inptAtvtCd}"/>'.split(",");
		
		if(fnCheckByteSize($('#rspt_inpt_apv_req_txt').val()) > 4000){
			alert("결재의견은 4000자리 이내로 입력해주세요.");
			return;
		}
		
		var params = [];
		var params2 = [];
		
		params.push({n:'revertMemo',v:$('#rspt_inpt_apv_req_txt').val()}); // 메모
		
		
		for(var i=0;i<ids.length;i++){

			params.push({n:'revertIds',v:ids[i]}); 
			params.push({n:'aiInptAppvHstIds',v:aiInptAppvHstIds[i]}); 
			params.push({n:'inptAtmcBizDscds',v:inptAtmcBizDscds[i]}); 
			params.push({n:'aiInptTpySaveYns',v:aiInptTpySaveYns[i]}); 
			params.push({n:'aiInptCrpeEnos',v:aiInptCrpeEnos[i]}); 
			params.push({n:'totaltextAiInptRstCds',v:totaltextAiInptRstCds[i]}); 
			params.push({n:'itmInptAiInptRstCds',v:itmInptAiInptRstCds[i]}); 
			params.push({n:'aiInptQlasPrgStsCds',v:aiInptQlasPrgStsCds[i]}); 
			params.push({n:'inptAtvtCds',v:inptAtvtCds[i]}); 
			
		} 
	
		fnCmnSetFormParams($('#formParamData'),params); 
		
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctScrnNo" value="2010">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctFldCd" value="11">');
		$('#formParamData').html($('#formParamData').html()+'<input type="hidden" name="aiInptCnctActiCd" value="21">');

	
	//	params.push({n:'aiInptCnctParmTxt',v:$('#formParamData').serialize()});
		   $.post("/api/app/todo/bundle", $('#formParamData').serialize(), function(data){
			var resultCode = data.resultCode;

			if(resultCode=="200"){
				alert("정상적으로 승인이 일괄처리되었습니다.");
				opener.tableReload();
				opener.fnDeleteFormPopup();
				window.close();
			} else {
				alert(data.resultExMsg);
			}
			
			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("2010",null,"21",$.param({}));
		});  
	}
}

$(window).unload(function(){
	opener.fnDeleteFormPopup();
});

function fnCloseBundle(){
	opener.fnDeleteFormPopup();
	window.close();
}

function fnSetMemo(memo){
	$("#rspt_inpt_apv_req_txt").val(memo);
	$("#rspt_inpt_apv_req_txt").focus();
}
</script>