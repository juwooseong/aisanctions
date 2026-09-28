<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>

<script type="text/javascript" src="${ctx_res}/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${ctx_res}/js/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx_res}/js/common.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx_res}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/layout.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/custom_style.css"/>

<c:set var="pageId" value="8051"/>
<c:set var="cspdTable" value="cspdTable_${pageId}"/>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>

<div class="wrap" style="overflow-y: hidden;">
	<div class="processing-container">
	
		<h2>
			<strong class="processing-title">재처리 정보 등록</strong>
		</h2>
		
		<div class="section_wrapper" style="border-bottom: 0px;">
			<div class="processing-option" style="display: inline-block;">
				<strong class="processing-sub-title">처리구분</strong>
				<select name="processingType" id="processingType" class="processing-select">
					<option value="R">SELECT</option>
					<option value="C">INSERT</option>
					<option value="U">UPDATE</option>
					<option value="D">DELETE</option>
				</select>
			</div>	
			<div style="display: inline-block;">
				<button id="cudButon" class="btn btn-sm btn-secondary w-45">실행</button>
				<button id="searchBtn_<c:out value="${cspdTable}"/>" class="btn btn-sm btn-secondary w-45">실행</button>
			</div>
		</div>
		
		<div class="tbWrap">
			<div class="tbTop">
				<strong>Query</strong>
			</div>
			<div class="tbCon" style="margin-top: 8px;height: 40%;">
				<span class="adminStatusspan" style="line-height: 14px;">※ 쿼리를 입력하세요.</span>		
				<textarea class="form-control" id="testTextArea" name="textarea-input" wrap="physical" style="height: calc(100% - 30px);font-size: 12px;color: black;resize: none;"></textarea>
			</div>
	
		</div>
		
		<div class="tbWrap" id="tbWrap_2" style="height: 35%;padding: 17px 7px 7px 7px;margin-top: 8px;">
			<div class="adminStatusTop">
				<strong>실행결과</strong>
				<span class="resultCountSpan" style="
    margin-left: 5px;
    font-size: 12px;
"></span>
				<button type="button" class="gridRightTopAdminStatusBtn xlsDownloadBtn" onclick="downXls<c:out value="${pageId}"/>();">엑셀다운로드</button>
			</div>
			<div class="tbCon" style="padding: 17px 7px 7px 7px; margin-top: 8px;">
			
				<div id="cspdDiv" class="tbWrap table-div">
					<table class="table table-responsive-sm width-100" id="cspdTable"></table>
				</div>
			</div>
		</div>
	</div>
</div>

<form id="formXls" method="get"></form>

<script>

// 테이블 변수 선언
var globalCspdTable = null;
var globalCspdData = [];
var globalColumnDefs = [];
var globalColumns = [];
var globalQueryText = null;

$(document).ready(function(){
	initLoadingDisplay("Y", "class", "processing-container");
	fn_init();
});

function downXls<c:out value="${pageId}"/>(){
	
	/*
	if($('#cspdDiv').attr('style') != 'display: none;'){
		dataTableId = "#tableName";
		searchOption = dataTableId.getSearchOption();
	}*/
	/*
	if(dataTableId.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}*/
	if(globalCspdData.length == 0){
		alert('데이터가 존재하지 않습니다.');
		return;
	}else{
		param = {};
		param.queryTestParam = globalQueryText;//$('#testTextArea').val();
		fnCmnDownXls($('#formXls'), '/api/admin/status/xls/new', param);
	}
	
}

// 초기화
function fn_init() {
	$('#cudButon').css('display', 'none');
	
	$('#tableName').prop('disabled', false);
	$('#tbWrap_2').show();
}

// 쿼리결과 조회
function fn_getTableData() {
	
	var pros_data = {
			queryTestParam : $('#testTextArea').val()
	};
	
	var bannedChar = ['insert', 'delete', 'merge', 'update', 'create', 'declare'];
	var bannedFlag = 0;
	for(var i = 0 ; i < bannedChar.length ; i++){
		if($('#testTextArea').val().toLowerCase().indexOf(bannedChar[i]) != -1){
			bannedFlag = 1;
		}
	}
	if(bannedFlag == 1){
		alert('조회쿼리 에 허용되지 않는 키워드가 포함되어 있습니다.\n입력하신 쿼리를 확인해주세요.');
		return;
	}else{
		
		// 테이블 변수 초기화
		globalCspdData = [];
		globalColumnDefs = [];
		globalColumns = [];
		$('.resultCountSpan').text('');
		
		
		if (globalCspdTable) {
			// 데이터 테이블 초기화
			globalCspdTable.destroy();
			$('#cspdDiv').empty().append('<table class="table table-responsive-sm width-100" id="cspdTable"></table>');
		}
		
		$.ajax({
			url : "/api/admin/status/queryUse/new",
			type : "get",
			cache: false,
			async : true,
			data : pros_data,			
			dataType: "json",
			success : function(data) {
				
				if(data.rstCode=="success") {
					
					globalQueryText = $('#testTextArea').val();
					
					

					// 쿼리 결과 데이터
					globalCspdData = data.resultList;
					
					// 쿼리 결과 컬럼목록
					var _columnList = data.columnList;
					
					for (var i in _columnList) {
						
						globalColumnDefs.push({ targets : i, className : 'td-text-left' , orderable : false});
						globalColumns.push({ title : _columnList[i], data : _columnList[i], className : 'td-text-left td-text-80'});
						
					}
					
					// 쿼리 결과 데이터가 있으면
					if (globalCspdData.length > 0) {
						$('.resultCountSpan').text(data.paginationInfo.totalRecordCount + ' 건');
						fn_dataTableComplete(globalCspdData, globalColumnDefs, globalColumns);
					}
					
				} else if(data.rstCode=="zero") {
					alert('쿼리 데이터 결과가 없습니다.');
					return;
				}else{
					alert('비정상적인 쿼리입니다.\n입력하신 쿼리를 확인해주세요.');
					return;
				}
			},
			error : function(e) {
				
			},
			complete: function() {
				
			}

		});	
	}
	
}

// 쿼리결과 dataTable 생성
function fn_dataTableComplete(globalCspdData, globalColumnDefs, globalColumns) {
	globalCspdTable = $('#cspdTable').DataTable({
		
		data: globalCspdData,
		scrollY: "calc(100% - 60px)",
		scrollX: true,
		scrollXInner: "auto",
		paging: true,
		info: false,
		filter: false,
		length: true,
		columnDefs: globalColumnDefs,
		columns: globalColumns,
		lengthMenu: [50, 100, 200]
	});
}

$("#cudButon").click(function(e){
	
	var options = {};
   	options.crud = $('#processingType').val();
	options.queryTestParam = $('#testTextArea').val();
	
	if($.trim($('#testTextArea').val())==""){
		alert("수행할 쿼리를 입력해주세요.");
		return;
	}
	
	if($('#processingType').val() == 'C' && $('#testTextArea').val().toLowerCase().indexOf('insert') == -1){
		alert('적절하지 않은 INSERT 쿼리 입니다');
		return;
	}else if($('#processingType').val() == 'U' && $('#testTextArea').val().toLowerCase().indexOf('update') == -1){
		alert('적절하지 않은 UPDATE 쿼리 입니다');
		return;
	}else if($('#processingType').val() == 'D' && $('#testTextArea').val().toLowerCase().indexOf('delete') == -1){
		alert('적절하지 않은 DELETE 쿼리 입니다');
		return;
	}else{
		
		$.post('/api/admin/status/queryUse', options, function(data){
			if(data.resultCode=='200'){
				
				console.log("update 잘 탔습니다 " + $('#processingType').val());
				
				if($('#processingType').val() == 'C'){
					alert("INSERT가 완료되었습니다.");
					$('#tbWrap_2').hide();
				}
				if($('#processingType').val() == 'U'){
					alert("UPDATE가 완료되었습니다.");
					$('#tbWrap_2').hide();
				}
				if($('#processingType').val() == 'D'){
					alert("DELETE가 완료되었습니다.");
					$('#tbWrap_2').hide();
				}
			} else {
				alert(data.resultMsg);
			}
		});	
		
	}
	
	

});


$("#searchBtn_<c:out value="${cspdTable}"/>").click(function(e){
	if($.trim($('#testTextArea').val())==""){
		alert("수행할 쿼리를 입력해주세요.");
		return;
	}
	
	if($('#processingType').val() == 'R'){
		$('#tbWrap_2').show();
		fn_getTableData();
	}
});

// 처리구분 옵션
$(document).on('change','#processingType', function(e) {
	
	var _type = $('#processingType option:selected').val();
	  
	// SELECT
	if ("R" == _type) {
		 $('#tbWrap_2').show();
		 $('#cudButon').css('display', 'none');
		 $("#searchBtn_<c:out value="${cspdTable}"/>").css('display', 'block');
	} else {
		 $('#tbWrap_2').hide();
		 $('#cudButon').css('display', 'block');
		 $("#searchBtn_<c:out value="${cspdTable}"/>").css('display', 'none');
	}
	
});

</script>