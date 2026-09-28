<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7010"/>
<c:set var="gridId" value="listTable_${pageId}"/>
<style>
.w54_v2 {
	width: 90% !important;
}
</style>
<div class="container">
	<h2 class="title">
		<strong>국가코드관리 [8010]</strong>
		<span class="revertStatPageDiscription">국가코드 및 국가명 정보를 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>국가정보관리</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="" id="formSearch_<c:out value="${pageId}"/>" onsubmit="return false;">
				<p class="w30">
					<label for="schText1" class="label">국가코드</label>
					<input type="text" class="it w54_v2 admNationCd" id="schText1" value="" placeholder="" />
				</p>
				<p class="w30">
					<label for="schText2" class="label">국가명</label>
					<input type="text" class="it w54_v2 admNationNm" id="schText2" value="" placeholder=""/>
				</p>
				<p class="w30">
					<label for="schRepYn" class="label">대표여부</label>
					<select class="" name="schRepYn" id="schRepYn">
						<option value="">전체</option>
						<option value="Y">대표이름</option>
						<option value="N">비대표이름</option>
					</select>
				</p>
				<button class="searchBtnType1" id="searchBtn_<c:out value="${gridId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>국가 리스트</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm" id="<c:out value="${gridId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>국가 정보</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="txt_nacd" class="label">국가코드</label>
								<input type="text" id="txt_nacd" class="it" value="" placeholder="국가코드" title="국가코드" maxlength="2" />
							</p>
							<p class="">
								<label for="txt_engNlNm" class="label">국가명(영문)</label>
								<input type="text" id="txt_engNlNm" class="it" value="" placeholder="국가명(영문)" title="국가명(영문)" />
							</p>
							<p class="">
								<label for="txt_korlNlNm" class="label">국가명(한글)</label>
								<input type="text" id="txt_korlNlNm" class="it" value="" placeholder="국가명(한글)" title="국가명(한글)" />
							</p>
							<p class="">
								<label for="chk_repYn" class="label">대표이름여부</label>
								<label class="switch switch-primary switch switch-label">
									<input id="chk_repYn" class="switch-input" type="checkbox" checked="" autocomplete="off">
									<span class="switch-slider" data-checked="✓" data-unchecked="✕"></span>
			                    </label>
							</p>
						</form>
					</div>
					<div class="btBox" style="padding-bottom:10px;">
						<span class="r">
							<button type="button" class="btType2" id="newBtn">신규</button>
							<button type="button" class="btType2" id="delBtn">삭제</button>
							<button type="button" class="btType1" id="saveBtn">저장</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<form id="formProcParams"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var <c:out value="${gridId}"/>Config = {
	ajaxUrl : '/api/admin/nation',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-left td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-60' },
		{ targets: 4, className: 'td-text-center td-text-60' }
	],
	columns: [
		{"data": "nacd", title: '국가코드'},
    	{"data": "engNlNm", title: '국가명(영문)'},
    	{"data": "korlNlNm", title: '국가명(한글)'},
    	{"data": "rprsCdYn", title: '대표이름여부'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//국가코드
		if($("#schText1").val()){
			options.schText1 = $("#schText1").val();
		}
		
		//국가명
		if($("#schText2").val()){
			options.schText2 = $("#schText2").val();
		}
		
		//대표이름여부
		if($("#schRepYn").val()){
			options.schRepYn = $("#schRepYn").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8010",null,"01",$.param(options));

		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${gridId}" />
	<jsp:param name="initYN" value="Y" />
 	<jsp:param name="select" value="single" /> 
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="501" />
</jsp:include>
<script>
var mode = 'insert';

$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	$('#newBtn').click(function(e){
		fnSetInfo(null);
	});
	
	$('#saveBtn').click(function(e){
		fnSave();
	});
	
	$('#delBtn').click(function(e){
		fnDel();
	});
	
	$('#chk_repYn').prop('checked',false);
	
});
var <c:out value="${gridId}"/>_selectCallback = function(e, dt, type, index, row){
	fnSetInfo(row);
};
function fnSave(){
	var f = $('#formProcParams');
	var params = [];
	params.push({n:'nacd',v:$('#txt_nacd').val()});
	params.push({n:'engNlNm',v:$('#txt_engNlNm').val()});
	params.push({n:'nutpNacd',v:'-'});
	params.push({n:'korlNlNm',v:$('#txt_korlNlNm').val()});
	params.push({n:'korlNlAbrvNm',v:'-'});
	params.push({n:'engNlAbrvNm',v:'-'});
	params.push({n:'rprsCdYn',v:$('#chk_repYn').prop('checked') ? 'Y' : 'N'});
	fnCmnSetFormParams(f,params);
	
	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="8010">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');
	
	//프로그램 사용 이력 로그누적
	//fnCmnProgramLog("8000",null,"04",f.serialize());

	if(mode=='insert'){
		if($.trim($('#txt_nacd').val())==""){
			alert("국가코드를 입력 해주세요.");
			$('#txt_nacd').focus();
			return;
		}
		if(!fnCheckUsingCharForamt(0, $.trim($('#txt_nacd').val()))){
			alert("국가코드 는 한글이나 숫자를 사용할 수 없습니다");
			$('#txt_nacd').focus();
			return;
		}
		if($.trim($('#txt_engNlNm').val())==""){
			alert("국가명을(영문) 입력 해주세요.");
			$('#txt_engNlNm').focus();
			return;
		}
		if(fnCheckUsingCharForamt(3, $.trim($('#txt_engNlNm').val()))){
			alert("국가명을(영문) 은 특수문자를 사용할 수 없습니다.");
			$('#txt_engNlNm').focus();
			return;
		}
		if($.trim($('#txt_korlNlNm').val())==""){
			alert("국가명을(한글) 입력 해주세요.");
			$('#txt_korlNlNm').focus();
			return;
		}
		if(fnCheckUsingCharForamt(3, $.trim($('#txt_korlNlNm').val()))){
			alert("국가명을(한글) 은 특수문자를 사용할 수 없습니다.");
			$('#txt_korlNlNm').focus();
			return;
		}
	} else {
		if($.trim($('#txt_nacd').val())==""){
			alert("좌측 국가정보 목록에서 수정하실 국가 정보를 선택해주세요.");
			return;
		}
	}
	
	if(confirm('국가 정보를 저장 하시겠습니까?')){
		$.ajax({
			url: '/api/admin/nation/insert',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				fnSetInfo(null);
				<c:out value="${gridId}"/>.searchList();
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}
function fnDel(){
	var f = $('#formProcParams');
	var params = [];
	params.push({n:'nacd',v:$('#txt_nacd').val()});
	params.push({n:'engNlNm',v:$('#txt_engNlNm').val()});
	fnCmnSetFormParams(f,params);

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("8010",null,"06",f.serialize());

	if($.trim($('#txt_nacd').val())==""){
		alert("삭제하실 국가정보를 좌측 국가정보 목록에서 선택해주세요.");
		return;
	}
	if(confirm("국가 정보를 삭제하시겠습니까?")){
		$.ajax({
			url: '/api/admin/nation/delete',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				<c:out value="${gridId}"/>.searchList();
				fnSetInfo(null);
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
		$('#txt_nacd').val(row.nacd);
		$('#txt_engNlNm').val(row.engNlNm);
		$('#txt_korlNlNm').val(row.korlNlNm);
		$('#chk_repYn').prop('checked',row.rprsCdYn=='Y' ? true : false);
		
		fnSetReadonly('txt_nacd',true);
		fnSetReadonly('txt_engNlNm',false);
		fnSetReadonly('txt_korlNlNm',false);
		
		mode = 'update';
		
	} else {
		
		//프로그램 사용 이력 로그누적
	//	fnCmnProgramLog("8000",null,"05",$.param({}));
		
		$('#txt_nacd').val('');
		$('#txt_engNlNm').val('');
		$('#txt_korlNlNm').val('');
		$('#chk_repYn').prop('checked',false);
		
		fnSetReadonly('txt_nacd',false);
		fnSetReadonly('txt_engNlNm',false);
		fnSetReadonly('txt_korlNlNm',false);
		
		<c:out value="${gridId}"/>.deselect();
		
		mode = 'insert';
	}
}
//인풋박스 readOnly 속성설정.
function fnSetReadonly(inputId,flag){
	var obj = $('#'+inputId);
	if(flag){
		obj.prop('readOnly',true);
		obj.css({backgroundColor:'#eaeaea'});
	} else {
		obj.prop('readOnly',false);
		obj.css({backgroundColor:'#ffffff'});
	}
}
</script>