<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<c:set var="pageId" value="7031"/>
<%-- <c:set var="modelTitle" value="${param.modelTitle}"/> --%>
<c:set var="dataTableId" value="listTable_${pageId}"/>
<%-- <c:set var="modelGridId" value="modalUserListTable${param.pageId}"/> --%>
<%-- <c:set var="modalId" value="${param.modalId}"/>
 --%>

<div class="wrap layout_type_popup history_popup" style="padding:0;">
	<h2 class="title">
		<strong style="font-size: 18px; color: #05718b; line-height: 44px; padding-left: 8px;">메뉴등록 [7031]</strong>
	</h2>
	<div class="layout_container" style="padding-top : 7px;">
		<div class="contents" style="margin-top: 0px;">
					<div class="searchBox" style="width:98.3%; margin:0 auto;">
						<form action="">
							<p class="w18" style="padding: 5px 0px 5px 59px;">
								<label for="aiInptHgrnMenuId" class="label" style="width: 38px;">대메뉴</label>
									<select class="" id="aiInptHgrnMenuId">
										<c:forEach var="item" items="${adminMenuList }">
											<option value="${item.aiInptMenuId }">${item.aiInptMenuNm }</option>
										</c:forEach>
									</select>
							</p>
						<button class="searchBtnType1" style="float:right;" id="searchBtn_<c:out value="${dataTableId}"/>"><i class="fa fa-search searchBtn"></i>조회</button>
						</form>
					
					</div>
				<div class="flGroup item_2" style ="padding-top:10px;">
					
						<div class="tbWrap" style="width: 61%; margin: 0 auto;">
							<div class="tbCon" style="margin-left:5px;">
								<table class="table table-responsive-sm w-100" id="<c:out value="${dataTableId}"/>"></table>
								
							</div>
						</div>
					<div class="tbWrap" style="width: 38.3%; margin : 0 auto;">
						
						<div class="tbCon" style="padding-top: 45px;">
							<div class="searchBox" style="padding-left: 0px">
								<form action="">
									<p class="">
										<label for="menuId" class="label">메뉴ID</label>
										<input type="text" id="menuId" class="it" value="" placeholder="메뉴ID" title="메뉴ID"/>
									</p>
									<p class="">
										<label for="menuName" class="label">메뉴명</label>
										<input type="text" id="menuName" class="it" value="" placeholder="메뉴명" title="메뉴명"/>
									</p>
									<p class="">
										<label for="menuURL" class="label">URL</label>
										<input type="text" id="menuURL" class="it" value="" placeholder="URL" title="URL"/>
									</p>
									<p class="">
										<label for="hgMenuId" class="label">상위메뉴ID</label>
										<input type="text" id="hgMenuId" class="it" value="" placeholder="상위메뉴ID" title="상위메뉴ID" onchange="ch();" style="width: 21.3%"/>
										<input type="text" id="hgMenuName" class="it" value="" placeholder="상위메뉴Name" title="상위메뉴Name" disabled="disabled" style="width: 77.4%"/>
									</p>
									<p class="">
										<label for="screenId" class="label">화면번호</label>
										<input type="text" id="screenId" class="it" value="" placeholder="화면번호" title="화면번호" onchange="chTwo();" style="width: 21.3%"/>
										<input type="text" id="screenName" class="it" value="" placeholder="화면명" title="화면명" disabled="disabled" style="width: 77.4%"/>
									</p>
									<p class="">
										<label for="adminYN" class="label">관리자 화면</label>
										<select class="" name="adminYN" id="adminYN">
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</p>
								</form>
							</div>
							<div class="btBox">
								<span class="r">
									<a href="javascript:void(0);" class="btType2" id="newBtn">신규</a>
									<a href="javascript:void(0);" class="btType2" id="delBtn">삭제</a>
									<a href="javascript:void(0);" class="btType1" id="saveBtn">저장</a>
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<form id="formHighMenuNameParams"></form>		
<form id="formScreenNameParams"></form>		
<form id="formMenuRegParams"></form>
<form id="formMenuDeleteParams"></form>
<script>

var mode = 'insert';


$(function() {
	$("#newBtn").click(function(e){
		<c:out value="${dataTableId}"/>.deselectAllListTableRow();
		fnSetDetail(null);
	});
	
	$('#saveBtn').click(function(e){
		fnSave();
	});
	$('#delBtn').click(function(e){
		fnDelete();
	});
});
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/admin/menu/reg',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-10' },
		{ targets: 1, className: 'td-text-center td-text-20' },
		{ targets: 2, className: 'td-text-center td-text-30' },
		{ targets: 3, className: 'td-text-center td-text-40' },
		{ targets: 4, className: 'td-text-center td-text-20' },
		{ targets: 5, className: 'td-text-center td-text-30' },
		{ targets: 6, className: 'td-text-center td-text-20' },
		{ targets: 7, className: 'td-text-center td-text-20' },
		{ targets: 8, visible: false}
	],
	columns: [
		{"data": "aiInptMenuId", title: '메뉴ID'},
    	{"data": "aiInptMenuNm", title: '에뉴명'},
    	{"data": "aiInptMenuUrlNm", title: 'URL'},
    	{"data": "aiInptHgrnMenuId", title: '상위메뉴ID'},
    	{"data": "highNm", title: '상위메뉴명'},
    	{"data": "aiInptMenuNo", title: '화면번호'},
    	{"data": "aiInptAdminYn", title: '관리자 화면'},
    	{"data": "screenName"}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		options.aiInptHgrnMenuId = $("#aiInptHgrnMenuId").val();
		console.log(options.aiInptHgrnMenuId);
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7031",null,"01",$.param(options));
		
		return options;
	}
};

function fnSave(){
	var f = $('#formMenuRegParams');
	var params = [];
	
	params.push({n:'aiInptMenuId',v:$('#menuId').val()});
	params.push({n:'aiInptMenuNm',v:$('#menuName').val()});
	params.push({n:'aiInptMenuUrlNm',v:$('#menuURL').val()});
	params.push({n:'aiInptHgrnMenuId',v:$('#hgMenuId').val()});
	params.push({n:'highNm',v:$('#hgMenuName').val()});
	params.push({n:'aiInptMenuNo',v:$('#screenId').val()});
	params.push({n:'aiInptAdminYn',v:$('#adminYN').val()});
	
	fnCmnSetFormParams(f,params);
	
	//프로그램 사용 이력 로그누적
//	fnCmnProgramLog("8000",null,"04",f.serialize());

	if($.trim($('#menuId').val())==""){
		alert("메뉴 ID를 입력해주세요.");
		$('#menuId').focus();
		return;
	}
	if($.trim($('#menuName').val())==""){
		alert("메뉴명을 입력해주세요.");
		$('#menuName').focus();
		return;
	}
	if($.trim($('#aiInptHgrnMenuId').val())==""){
		alert("상위메뉴 ID를 입력해주세요.");
		$('#aiInptHgrnMenuId').focus();
		return;
	}

 	if(mode=='insert'){
		f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formMenuRegParams').serialize()+'">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7031">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="05">');

		if(confirm('메뉴를 등록하시겠습니까?')){
			$.ajax({
				url: '/api/admin/menu/regMenu',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					var checkStr = data.checkStr;
					if(checkStr == 'both'){
						alert("중복된 메뉴ID와 화면번호가 있습니다.");
						$('#menuId').focus();
					}else if(checkStr == 'menuId'){
						alert("이미 사용중인 메뉴ID입니다.\n다른 메뉴ID를 등록해주시기 바랍니다.");
						$('#menuId').focus();
					}else if(checkStr == 'screenNo'){	
						alert("해당 상위메뉴 ID에서 이미 사용중인 화면번호입니다.\n다른 화면번호를 등록해주시기 바랍니다.");
						$('#screenId').focus();
					}else{
						alert("정상적으로 처리되었습니다.");
					//	fnSetInfo(null);
						<c:out value="${dataTableId}"/>.searchList();
					}
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
		
 	} else {
		f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7031">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');

		if(confirm('메뉴정보를 수정하시겠습니까?')){
			$.ajax({
				url: '/api/admin/menu/modiMenu',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					var checkStr = data.checkStr;
					console.log(checkStr);
					 if(checkStr == 'screenNo'){	
						alert("해당 상위메뉴 ID에서 이미 사용중인 화면번호입니다.\n다른 화면번호를 등록해주시기 바랍니다.");
						$('#screenId').focus();
					}else{
						alert("정상적으로 처리되었습니다.");
						// fnSetInfo(null);
						<c:out value="${dataTableId}"/>.searchList();
					}
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
 	} 
}

function fnDelete(){
	var f = $('#formMenuDeleteParams');
	var params = [];
	
	params.push({n:'aiInptMenuId',v:$('#menuId').val()});
	/* params.push({n:'aiInptMenuNm',v:$('#menuName').val()});
	params.push({n:'aiInptMenuUrlNm',v:$('#menuURL').val()});
	params.push({n:'aiInptHgrnMenuId',v:$('#hgMenuId').val()});
	params.push({n:'highNm',v:$('#hgMenuName').val()});
	params.push({n:'aiInptMenuNo',v:$('#screenId').val()});
	params.push({n:'aiInptAdminYn',v:$('#adminYN').val()}); */
	
	fnCmnSetFormParams(f,params);
	
	//프로그램 사용 이력 로그누적
//	fnCmnProgramLog("8000",null,"04",f.serialize());

	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+$('#formParamData').serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7031">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="06">');

	if(confirm('메뉴정보를 삭제하시겠습니까?')){
		$.ajax({
			url: '/api/admin/menu/delMenu',
			data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("삭제되었습니다.");
				<c:out value="${dataTableId}"/>.searchList();
			}else {
				fnAlertErrorMsg(data);
			}
		});
	}
}

function chTwo() {
	 var screenId = $('#screenId').val();
	 var f = $('#formScreenNameParams');
	 
	 var params = [];
	 params.push('<input type="hidden" name="screenId" value="'+screenId+'" />');		//인수자 번호
	 f.html(params.join(''));
		
	$.ajax({
		url: '/api/admin/menu/selectOneScreenName',
		data: f.serialize(),
		method: 'post'
	}).done(function(data){
		if(data.resultCode=="200"){
			if(data.screenName == null){
				$('#screenName').val("해당 화면번호는 등록되어있지 않습니다.");	
				$('#screenId').val("");
				$('#screenId').focus();
			}else{
				$('#screenName').val(data.screenName);
			}
		} else {
			fnAlertErrorMsg(data);
		}
	});
} 

function ch() {
	 var hgMenuId = $('#hgMenuId').val();
	 var f = $('#formHighMenuNameParams');
	 
	 var params = [];
	 params.push('<input type="hidden" name="hgMenuId" value="'+hgMenuId+'" />');		//인수자 번호
	 f.html(params.join(''));
		
	$.ajax({
		url: '/api/admin/menu/selectOneHg',
		data: f.serialize(),
		method: 'post'
	}).done(function(data){
		if(data.resultCode=="200"){
			if(data.hgNm == null){
				$('#hgMenuName').val("해당 상위메뉴 ID는 등록되어있지 않습니다.");	
				$('#hgMenuId').val("");
				$('#hgMenuId').focus();
			}else{
				$('#hgMenuName').val(data.hgNm);
			}
		} else {
			fnAlertErrorMsg(data);
		}
	});
} 

</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="430" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail(row);
};

function fnSetDetail(row){
//	$("#userYn").val('01');
	if(row){
		//상세/수정 모드
		$("#menuId").val(row.aiInptMenuId);
		$("#menuId").prop('disabled',true);
		$("#menuName").val(fnCmnXssUnescape(row.aiInptMenuNm));
		$("#menuURL").val(fnCmnXssUnescape(row.aiInptMenuUrlNm));
		$("#hgMenuId").val(row.aiInptHgrnMenuId);
		$("#hgMenuName").val(fnCmnXssUnescape(row.highNm));
		$("#screenId").val(fnCmnXssUnescape(row.aiInptMenuNo));
		$("#screenName").val(row.aiInptCtgrId);
		$("#adminYN").val(fnCmnXssUnescape(row.aiInptAdminYn));
		$("#screenName").val(row.screenName);
		mode = 'update';
	} else {
		//신규모드
		$("#menuId").prop('disabled',false);
		$("#menuId").val("");
		$("#menuName").val("");
		$("#menuURL").val("");
		$("#hgMenuId").val("");
		$("#hgMenuName").val("");
		$("#screenId").val("");
		$("#screenName").val("");
		$("#adminYN").val("Y");
		
		mode = 'insert';
	}
}
</script>