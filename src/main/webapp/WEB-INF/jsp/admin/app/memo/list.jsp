<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7090"/>
<c:set var="gridId" value="listTable${pageId}"/>

<div class="container">
	<h2 class="title">
		<strong>일괄결재 의견 관리 [7090]</strong>
		<span class="revertStatPageDiscription">일괄승인 시 자주 사용하는 결재 의견을 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>일괄결재 의견 관리</span>
		</span>
	</h2>

	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>일괄결재 의견</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${gridId}"/>"></table>
				</div>
			</div>
	
			<div class="tbWrap">
				<div class="tbTop">
					<strong>의견</strong>
					
				</div>
				<div class="tbCon">
					<form id="formDetailSearch" onsubmit="return false;" style="width:100%; height:372px;">
						<textarea id="memo" class="opi-text-check" title="의견" wrap="physical" style="width:100%;height:340px;padding: 10px;box-sizing: border-box;font-size: 12px;line-height: 20px;"></textarea>
						<span id="memo_text_length" style="margin-top: 10px;">0 / 4000 byte</span>
					</form>
					
				</div>
			</div>
			
		</div>
		
	</div>
	<div class="btBox">
		<span class="r">
			<a href="javascript:void(0);" class="btType2" id="newBtn">신규</a>
			<a href="javascript:void(0);" class="btType2" id="delBtn">삭제</a>
			<a href="javascript:void(0);" class="btType1" id="saveBtn">저장</a>
		</span>
	</div>
	
</div>
			
<input type="hidden" id="seq" value="" />
<form id="formProcParams"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
//전달내용
var orgOpiText = "";
var <c:out value="${gridId}"/>Config = {
	ajaxUrl : '/api/admin/app/memo',
	columnDefs: [
		{ targets: 0, width: '120px', className: 'td-text-center td-text-50', orderable: false },
		{ targets: 1, className: 'text-left' }
	],
	columns: [
		{"data": "aiInptAppvOpiTxt", title: '내용'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		/* if($("#schAuth<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schAuth<c:out value="${pageId}"/>").val();
		} */

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7090",null,"01",$.param(options));

		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${gridId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="false" />
	<jsp:param name="gridOptionScrollY" value="350" />
</jsp:include>
<script>
$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	$('#newBtn').click(function(e){
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7090",null,"05",$.param({}));

		fnSetInfo(null);
		$('#memo_text_length').text('0 / 4000 byte');
	});
	
	$('#saveBtn').click(function(e){
		fnSave();
	});
	
	$('#delBtn').click(function(e){
		fnDel();
	});
	
});
var <c:out value="${gridId}"/>_selectCallback = function(e, dt, type, index, row){
	fnSetInfo(row);
	
	var _opiTextLength = fnCheckByteSize(row.aiInptAppvOpiTxt);
	$('#memo_text_length').text(_opiTextLength + ' / 4000 byte');
	
};
function fnSave(){
	var f = $('#formProcParams');
	var params = [];
	params.push({n:'aiInptAppvOpiTxt',v:$('#memo').val()});
	params.push({n:'aiInptAppvOpiSrno',v:$('#seq').val()});
	fnCmnSetFormParams(f,params);
	
	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7090">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');
	
	//프로그램 사용 이력 로그누적
	//fnCmnProgramLog("7090",null,"04",f.serialize());
	
	if($.trim($('#memo').val())==""){
		alert("메모 내용을 입력해주세요.");
		$('#memo').focus();
		return;
	}
	if(confirm('메모 내용을 저장 하시겠습니까?')){
		$.ajax({
			url: '/api/admin/app/memo/save',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				fnSetInfo(null);
				<c:out value="${gridId}"/>.searchList();
				$('#memo_text_length').text('0 / 4000 byte');
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}
function fnDel(){
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("7090",null,"06",$.param({'seq' : $('#seq').val()}));
	
	if($.trim($('#seq').val())==""){
		alert("삭제하실 메모항목을 좌측 목록에서 선택해주세요.");
		return;
	}
	if(confirm("삭제하시겠습니까?")){
		$.ajax({
			url: '/api/admin/app/memo/delete/'+$('#seq').val(),
			data: {},
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				$('#memo').val('');
				alert("정상적으로 처리되었습니다.");
				<c:out value="${gridId}"/>.searchList();
				$('#memo_text_length').text('0 / 4000 byte');
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}
//row 가 널이면, 신규 입력박스 클리어, 값이 있으면 해당 값으로 셋팅처리.
function fnSetInfo(row){
	//console.info(row);
	if(row){
		$('#seq').val(row.aiInptAppvOpiSrno);
		$('#memo').val(fnCmnXssUnescape(row.aiInptAppvOpiTxt));
	} else {
		$('#seq').val('');
		$('#memo').val('');
		
		<c:out value="${gridId}"/>.deselect();
	}
}

//4000자 체크
$(document).on('keyup','.opi-text-check', function(e) {
	
	var _opiTextLength = fnCheckByteSize($('#memo').val());
	
	if (_opiTextLength > 4000) {
		alert("전달정보는 4000자를 넘을 수 없습니다.");
		$('#memo').val(orgOpiText);
	} else {
		orgOpiText = $('#memo').val();
		$('#memo_text_length').text(_opiTextLength + ' / 4000 byte');
	}
});
</script>