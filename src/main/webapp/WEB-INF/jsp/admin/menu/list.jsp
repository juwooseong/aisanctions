<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7030"/>
<c:set var="dataTableId" value="menuListTable_${pageId}"/>
<c:set var="dataTableId2" value="roleListTable_${pageId}"/>

			<div class="container">
				<h2 class="title">
					<strong>권한별 메뉴 관리 [7030]</strong>
					<span class="revertStatPageDiscription">사용자 권한별 사용가능한 화면을 설정하는 화면</span>
					<span class="location">
						<span>관리자 메뉴</span>
						<span>권한별 메뉴 관리</span>
					</span>
				</h2>
				
				<div class="searchWrap">
					<div class="searchToggle">
						<button type="button" class="schToggle">검색</button>
						<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
					</div>
					<div class="searchBox">
						<form id="formSearch_<c:out value="${pageId}"/>" onsubmit="return false;">
						<input type="hidden" id="menuId_<c:out value="${pageId}"/>" value="0"/>
							<p class="w18">
								<label for="schUserAuth_${pageId}" class="label">권한</label>
								
								<select class="" id="schUserAuth_<c:out value="${pageId}"/>">
									<c:forEach var="item" items="${authCodeList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
									</c:forEach>
								</select>
					
							
							</p>
						</form>
					</div>
				</div>
				
				<div class="contents">
					<div class="flGroup item_2">
						<div class="tbWrap">
							<div class="tbCon">
								<table class="table table-responsive-sm scrollTb" id="<c:out value="${dataTableId}"/>"></table>
							</div>
						</div>
						<div class="tbWrap">
							<div class="tbCon">
								<table class="table table-responsive-sm scrollTb" id="<c:out value="${dataTableId2}"/>"></table>
							</div>
						</div>
					</div>
				</div>
				
				<div class="btBox">
					<span class="c" style="width:92%;">
						<button htype="button" class="btType1" id="saveBtn_<c:out value="${pageId}"/>">저장</button>
						<button htype="button" class="btType2" id="regMenuBtn" style="float:left;">메뉴등록</button>
					</span>
				</div>
				
			</div>


<form id="formSave"></form>

<form id="formMenuReg" action='/admin/menu/menuReg' method='POST' target='menuReg'>
	
</form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/admin/menu',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-left td-text-80' }
	],
	columns : [
    	{"data": "aiInptMenuId", title: '메뉴ID'},
    	{"data": "aiInptMenuNm", title: '메뉴명'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//권한
		if($("#schUserAuth_<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth_<c:out value="${pageId}"/>").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7030",null,"01",$.param(options));

		return options;
	}
};
var <c:out value="${dataTableId2}"/>Config = {
	ajaxUrl : '/api/admin/menu/screen',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-left td-text-80' },
		{ targets: 3, className: 'td-text-center td-text-20' }
	],
	columns : [
    	{"data": "aiInptMenuId", title: '화면ID'},
    	{"data": "aiInptMenuNm", title: '화면명'},
    	{"data": "aiInptAutUsgYn", title: '사용', 
    		"render": function ( data, type, row) {
    			var src = '';
    			var chk = '';
    			
    			if(data == 'Y'){
    				chk = ' checked="checked" ';
    			}
    			
    			src = '<input type="checkbox" class="editor" name="checkb" '+chk+' id="chk_'+row.aiInptMenuId+'" />';

    			return src;
	    	},
	    	className: "dt-body-center"
    	},
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		options.menuId = $("#menuId_<c:out value="${pageId}"/>").val();
		
		//권한
		if($("#schUserAuth_<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth_<c:out value="${pageId}"/>").val();
		}
		
		return options;
	}
};

$(document).on('click', '#regMenuBtn', function(){
	var formMenuReg = $('#formMenuReg')[0];
	var winName = formMenuReg.target;
	
	var userDataForValidation = JSON.parse(sessionStorage.getItem('auth_data'));
	$("#adminFlag").val(userDataForValidation.admin_yn);
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = "1100";
	var popupSizeH = "800";
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
	var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
	
	window.open('about:blank', winName, 'left='+resultLeft+', top='+resultTop+', width=1236, height=678, resizable=0, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
	
	formMenuReg.submit();
});

$("#saveBtn_<c:out value="${pageId}"/>").click(function() {
	var options = $(':checkbox[name="checkb"]');

	var auth = $('#schUserAuth_<c:out value="${pageId}"/>').val();
	var form = $('#formSave');
	var params = [];
	var params_tmp = [];
	
	params_tmp.push({n:'aiInptAutCd',v:auth});
	options.each(function(idx,obj){
		var aiInptAutUsgYn = obj.checked ? "Y" : "N";
		var aiInptMenuId = obj.id.replace('chk_','');
		params_tmp.push({n:'aiInptMenuIds',v:aiInptMenuId});
		params_tmp.push({n:'aiInptAutUsgYns',v:aiInptAutUsgYn});
	});
	fnCmnSetFormParams(form,params_tmp);

	params.push({n:'aiInptAutCd',v:auth});
	options.each(function(idx,obj){
		var aiInptAutUsgYn = obj.checked ? "Y" : "N";
		var aiInptMenuId = obj.id.replace('chk_','');
		params.push({n:'aiInptMenuIds',v:aiInptMenuId});
		params.push({n:'aiInptAutUsgYns',v:aiInptAutUsgYn});
	});
	params.push({n:'aiInptCnctScrnNo',v:"7030"});
	params.push({n:'aiInptCnctActiCd',v:"04"});
	params.push({n:'aiInptCnctParmTxt',v:form.serialize()});

	fnCmnSetFormParams(form,params);
	
	//프로그램 사용 이력 로그누적
	//fnCmnProgramLog("7030",null,"04",form.serialize());

	if(!options.length){
		alert("설정할 내용이 없습니다.");
		return;
	}
	if(confirm('현재 설정하신 내용으로 사용여부를 저장하시겠습니까?')){
		$.post("/api/admin/menu/screen", form.serialize(), function(data){
	    	if(data.resultCode=="200"){
	    		alert('정상적으로 처리되었습니다.');
	    		<c:out value="${dataTableId2}"/>.searchList();
	    	} else {
	    		fnAlertErrorMsg(data);
	    	}
	    });
	}
});


/* $("#regMenuBtn").click(function() {
	var formMenuReg = $('#formMenuReg')[0];
	var winName = formMenuReg.target;
	
	var userDataForValidation = JSON.parse(sessionStorage.getItem('auth_data'));
//	$("#adminFlag").val(userDataForValidation.admin_yn);
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = "1100";
	var popupSizeH = "800";
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
	var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
	
	window.open('about:blank', winName, 'left='+resultLeft+', top='+resultTop+', width=600, height=300, resizable=0, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
	
	formMenuReg.submit();
}); */
$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	$('#schUserAuth_<c:out value="${pageId}"/>').change(function(e){
		<c:out value="${dataTableId}"/>.searchList();
		$("#menuId_<c:out value="${pageId}"/>").val("");
		<c:out value="${dataTableId2}"/>.searchList();
	});
	
});
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
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="430" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	$("#menuId_<c:out value="${pageId}"/>").val(row.aiInptMenuId);
	<c:out value="${dataTableId2}"/>.searchList();
};
var <c:out value="${dataTableId2}"/>_selectCallback = function(e, dt, type, index, row){
	//
};
</script>
<%--  <jsp:include page="/admin/menu/menuReg" flush="false">
	<jsp:param name="modelTitle" value="메뉴등록" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="regMenuModal" />
</jsp:include> --%> 