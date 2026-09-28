<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="8040"/>
<c:set var="gridId" value="listTable_${pageId}"/>
<style>
.w54_v2 {
	width: 90% !important;
}
</style>
<div class="container">
	<h2 class="title">
		<strong>도시항구관리 [8040]</strong>
		<span class="revertStatPageDiscription">도시 및 항구코드 정보를 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>도시항구관리</span>
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
					<label for="Search_aiInptCmnCdNm" class="label">도시항구구분</label>
					<select name="engCityNm" id="Search_aiInptCmnCdNm" style="margin-left:27px; width:81%;">
						<option value="">전체</option>
						<c:forEach var="item" items="${cityPortDscd }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w30">
					<label for="Search_engCityRgnNm" class="label">City / Port</label>
					<input type="text" class="it w54_v2" id="Search_engCityRgnNm" value="" placeholder="" />
				</p>
				<p class="w30">
					<label for="search_nacd" class="label">국가코드</label>
					<input type="text" class="it w54_v2" id="search_nacd" value="" placeholder=""/>
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
					<strong>도시항구 리스트</strong>
				</div>
				<div class="tbCon" style="padding:6px 7px 7px 7px;">
					<table class="table table-responsive-sm" id="<c:out value="${gridId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>도시항구 정보</strong>
				</div>
				<div class="tbCon" style="padding:6px 7px 7px 7px;">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="txt_nacd" class="label">도시항구구분</label>
									<select name="engCityNm" id="aiInptCmnCdNm" style="margin-left:27px; width:97%;">
										<c:forEach var="item" items="${cityPortDscd }">
											<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
										</c:forEach>
									</select>
							</p>
							<p class="">
								<label for="txt_engCityRgnNm" class="label">City / Port</label>
								<input style="margin-left:27px; width:97%;" type="text" id="txt_engCityRgnNm" class="it" value="" placeholder="도시항구명(영문)" title="도/주명(영문)" />
							</p>
							<p class="">
								<label for="txt_engNlNm" class="label">주 / Province</label>
								<input style="margin-left:27px; width:97%;" type="text" id="txt_engCityNm" class="it" value="" placeholder="도/주명(영문)" title="국가명(영문)" />
							</p>
							<p class="">
								<label for="txt_engNlNm" class="label">국가코드</label>
								<input style="margin-left:27px; width:27%;" type="text" id="txt_nacd" class="it" value="" placeholder="국가코드" title="국가코드" onchange="ch()"/>
								<input style="margin-left:3px; width:69%;" type="text" id="txt_engNlNm" class="it" value="" placeholder="국가명(영문)" title="국가명(영문)" disabled="disabled"/>
							</p>
							
							<input type="hidden" value="" id="citySrno">
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
<form id="formNationParams"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var <c:out value="${gridId}"/>Config = {
	ajaxUrl : '/api/admin/city',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-10' },
		{ targets: 1, className: 'td-text-center td-text-20' },
		{ targets: 2, className: 'td-text-left td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-40' },
		{ targets: 4, className: 'td-text-center td-text-20' },
		{ targets: 5, className: 'td-text-left td-text-20' },
		{ targets: 6, visible: false}
	],
	columns: [
		{"data": "aiInptCmnCdNm", title: '도시항구'},
    	{"data": "engCityRgnNm", title: 'city / port'},
    	{"data": "engCityNm", title: '주 / Province'},
    	{"data": "nacd", title: '국가코드'},
    	{"data": "engNlNm", title: '국가명(대표)'},
    	{"data": "citySrno" }
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//국가코드
		if($("#search_nacd").val()){
			options.nacd = $("#search_nacd").val();
		}
		
		//국가명
		if($("#Search_engCityRgnNm").val()){
			options.engCityRgnNm = $("#Search_engCityRgnNm").val();
		}

		//도시항구구분
		if($("#Search_aiInptCmnCdNm").val()){
			options.cityPortDscd = $("#Search_aiInptCmnCdNm").val();
		}
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8040",null,"01",$.param(options));
		return options;
	}
};

 function ch() {
	 var nacd = $('#txt_nacd').val();
	 var f = $('#formNationParams');
	 
	 var params = [];
	 params.push('<input type="hidden" name="nacd" value="'+nacd+'" />');		//인수자 번호
	 f.html(params.join(''));
		
		
//	if(mode=='insert'){
		$.ajax({
			url: '/api/admin/nation/one',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				//console.log(data.resultList.engNlNm);
				if(data.resultList == null){
					$('#txt_engNlNm').val("해당 국가코드는 등록되어있지않습니다.");	
					$('#txt_nacd').val("");
					$('#txt_nacd').focus();
				}else{
					$('#txt_engNlNm').val(data.resultList.engNlNm);
				}
			} else {
				fnAlertErrorMsg(data);
			}
		});
//	}
} 
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
	params.push({n:'engCityNm',v:$('#txt_engCityNm').val()});
	params.push({n:'engCityRgnNm',v:$('#txt_engCityRgnNm').val()});
	params.push({n:'cityPortDscd',v:$('#aiInptCmnCdNm').val()});
	params.push({n:'citySrno',v:$('#citySrno').val()});

	fnCmnSetFormParams(f,params);
	
	//프로그램 사용 이력 로그누적
//	fnCmnProgramLog("8000",null,"04",f.serialize());

 	if(mode=='insert'){
		if($.trim($('#txt_engCityRgnNm').val())==""){
			alert("City / Port를 입력 해주세요.");
			$('#txt_engCityRgnNm').focus();
			return;
		}
		if($.trim($('#txt_engCityNm').val())==""){
			alert("주 / Province를 입력 해주세요.");
			$('#txt_engCityNm').focus();
			return;
		}
		if($.trim($('#txt_nacd').val())==""){
			alert("국가코드를 입력 해주세요.");
			$('#txt_nacd').focus();
			return;
		}
		f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="8040">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="05">');
 	} else {
 		if($.trim($('#txt_engCityRgnNm').val())==""){
			alert("City / Port를 입력 해주세요.");
			$('#txt_engCityRgnNm').focus();
			return;
		}
		if($.trim($('#txt_engCityNm').val())==""){
			alert("주 / Province를 입력 해주세요.");
			$('#txt_engCityNm').focus();
			return;
		}
		if($.trim($('#txt_nacd').val())==""){
			alert("국가코드를 입력 해주세요.");
			$('#txt_nacd').focus();
			return;
		}
		f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="8040">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');
	} 
	
	if(confirm('도시항구 정보를 저장 하시겠습니까?')){
		$.ajax({
			url: '/api/admin/city/insert',
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
	params.push({n:'citySrno',v:$('#citySrno').val()});
	fnCmnSetFormParams(f,params);

	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="8040">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="06">');
	
	//프로그램 사용 이력 로그누적
//	fnCmnProgramLog("8000",null,"06",f.serialize());

	if($.trim($('#citySrno').val())==""){
		alert("삭제하실 도시항구 정보를 좌측 도시항구 목록에서 선택해주세요.");
		return;
	}
	if(confirm("도시항구 정보를 삭제하시겠습니까?")){
		$.ajax({
			url: '/api/admin/city/delete',
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
		$('#txt_engCityNm').val(row.engCityNm);
		$('#txt_engCityRgnNm').val(row.engCityRgnNm);
		$('#aiInptCmnCdNm').val(row.cityPortDscd);
		$('#citySrno').val(row.citySrno);
	//$('#chk_repYn').prop('checked',row.rprsCdYn=='Y' ? true : false);
	//	fnSetReadonly('txt_nacd',true);
	//	fnSetReadonly('txt_engNlNm',true);
		
		mode = 'update';
		
	} else {
		
		//프로그램 사용 이력 로그누적
	//	fnCmnProgramLog("8000",null,"05",$.param({}));
		
		$('#txt_nacd').val('');
		$('#txt_engNlNm').val('');
		$('#txt_engCityNm').val('');
		$('#txt_engCityRgnNm').val('');
		$('#aiInptCmnCdNm').val('1');
		$('#citySrno').val('');
		
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