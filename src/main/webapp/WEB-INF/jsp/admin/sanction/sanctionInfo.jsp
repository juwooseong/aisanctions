<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7050"/>
<c:set var="gridId" value="gridTbl1${pageId}"/>
<c:set var="gridId2" value="gridTbl2${pageId}"/>
<%-- <c:set var="gridId3" value="gridTbl3${pageId}"/> --%>

<div class="container">
	<h2 class="title">
		<strong>제재 Rule 등록 [7050]</strong>
		<span class="revertStatPageDiscription">TotalText심사, 항목심사를 위한 제재 Rule 을 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>WatchList 관리</span>
			<span>제재 Rule 등록</span>
		</span>
	</h2>

	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
			<input type="hidden" id="dataset_id">
				<p class="w34 no-label-input">
					<label for="category" id="rsIndx1" class="group1 radioSelector radioActive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:block;"></i></label>
					<input type="radio" checked="checked" name="bbutton" id="category" value="TOT" style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx1" for="category">TotalText</label>
					<label for="category2" id="rsIndx2" class="group1 radioSelector radioDeactive"><i class="fa fa-check fa-lg mt-4 radioCheckIcon" style="display:none;"></i></label>
					<input type="radio" value="ITM" name="bbutton" id="category2" style="display:none;"><label id="group1" class="radioSelectorLabel rsIndx2" for="category2" >항목심사</label>
				</p>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="flGroup item_2" id="rule1Id">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>TotalText Rule 등록</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${gridId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>항목 생성</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<%-- <p class="">
								<label for="item1" class="label">항목</label>
								<select class="" name="item1" id="item1">
									<option value="">선택</option>
									<c:forEach var="item" items="${itmList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
									</c:forEach>
								</select>
							</p> --%>
							<p class="">
								<label for="list1" class="label">리스트</label>
								<select class="" name="list1" id="list1">
									<option value="">선택</option>
								 	<c:forEach var="item" items="${lstList }">
										<option value="${item.aiInptListId }">${item.cateList }</option>
									</c:forEach>
								</select>
							</p>
							<%-- <p class="w100">
								<label for="cate1" class="label">카테고리</label>
								<select class="w100 no-label-input" name="cate1" id="cate1" onchange="fnSelect()">
									<option value="">선택</option>
									<c:forEach var="item" items="${ctgrList }">
										<option value="${item.aiInptCtgrId }">${item.aiInptCtgrNm }</option>
									</c:forEach>
								</select>
								
							</p> --%>
						</form>
					</div>
			
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType2" id="newBtn1">신규</a>
							<a href="javascript:void(0);" class="btType2" id="delBtn1">삭제</a>
							<a href="javascript:void(0);" class="btType1" id="saveBtn1">저장</a>
						</span>
					</div>
				</div>
			</div>
		</div>
		<div class="flGroup item_2" id="rule2Id">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>항목심사 Rule 등록</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${gridId2}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>항목 생성</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="joggun2" class="label">조건명</label>
								<input type="text" class="it" value="" id="joggun2" placeholder="조건명" title="조건명"/>
							</p>
							<p class="no-label-input" style="width: 100%;">
								<select class="" name="item2" id="item2" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${itmList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
									</c:forEach>
								</select>
								<select class="" name="list2" id="list2" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${lstList }">
										<option value="${item.aiInptListId }">${item.cateList }</option>
									</c:forEach>
								</select>
							</p>
							<p class="no-label-input" style="width: 100%;">
								<select class="" name="item22" id="item22" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${itmList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
									</c:forEach>
								</select>
								<select class="" name="list22" id="list22" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${lstList }">
										<option value="${item.aiInptListId }">${item.cateList }</option>
									</c:forEach>
								</select>
								<input id="chk_item22" type="checkbox" checked="" autocomplete="off" style="width: 30px;">
							</p>
							<p class="no-label-input" style="width: 100%;">
								<select class="" name="item23" id="item23" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${itmList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
									</c:forEach>
								</select>
								<select class="" name="list23" id="list23" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${lstList }">
										<option value="${item.aiInptListId }">${item.cateList }</option>
									</c:forEach>
								</select>
								<input id="chk_item23" type="checkbox" checked="" autocomplete="off" style="width: 30px;">
							</p>
							<p class="no-label-input" style="width: 100%;">
								<select class="" name="item24" id="item24" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${itmList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
									</c:forEach>
								</select>
								<select class="" name="list24" id="list24" style="width: 46%;">
									<option value="">선택</option>
									<c:forEach var="item" items="${lstList }">
										<option value="${item.aiInptListId }">${item.cateList }</option>
									</c:forEach>
								</select>
								<input id="chk_item24" type="checkbox" checked="" autocomplete="off" style="width: 30px;">
							</p>
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<a href="javascript:void(0);" class="btType2" id="newBtn2">신규</a>
							<a href="javascript:void(0);" class="btType2" id="delBtn2">삭제</a>
							<a href="javascript:void(0);" class="btType1" id="saveBtn2">저장</a>
						</span>
					</div>
				</div>
			</div>
		</div>
		<div class="flGroup item_3" id="ilchiTot">
		
			<div class="tbWrap" style="width: 49.7%;">
				<div class="tbTop">
					<strong>TotalText 일치율(%)</strong>
				</div>
				<div class="tbCon">
				
					<div class="searchBox">
						<form action="">
							<p class="w64">
								<label for="ilchiyul1" class="label">일치율(%)</label>
								<input type="text" class="it" id="ilchiyul1" value="" placeholder="일치율(%)" style="width: 30%;"/>
							</p>
							<button class="btType1" id="btnSaveInfo1">적용</button>
						</form>
					</div>
				
					
				</div>
			</div>
		</div>
		
		<div class="flGroup item_4" id="ilchiItm">
			<div class="tbWrap" style="width: 49.7%;margin: 0;margin-bottom: 10px;">
				<div class="tbTop">
					<strong>항목심사 일치율(%)</strong>
				</div>
				<div class="tbCon">
				
					<div class="searchBox">
						<form action="">
							<p class="w64">
								<label for="ilchiyul2" class="label">일치율(%)</label>
								<input type="text" class="it" id="ilchiyul2" value="" placeholder="일치율(%)" style="width: 30%;"/>
							</p>
							<button class="btType1" id="btnSaveInfo2">적용</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		
	</div>
</div>

<input type="hidden" id="num1" value="" />
<input type="hidden" id="num2" value="" />
<input type="hidden" id="num3" value="" />
<input type="hidden" id="isNewOrMod" value="" />

<input type="hidden" id="index" value="" /> 
<input type="hidden" id="e" value="" />
<input type="hidden" id="dt" value="" />
<input type="hidden" id="type" value="" />
<input type="hidden" id="row" value="" />
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var topGbn = 'TOT';
var page_id = '';
var indexRo = $("#index").val();
var roww;
//$("#chk_item22").prop("checked",false);
//$("#chk_item23").prop("checked",false);
//$("#chk_item24").prop("checked",false);
document.getElementById("rule1Id").style.display="";
document.getElementById("rule2Id").style.display="";
document.getElementById("ilchiTot").style.display="";
document.getElementById("ilchiItm").style.display="";
if(topGbn == 'TOT'){
	document.getElementById("rule2Id").style.display="none";
	document.getElementById("ilchiItm").style.display="none";
}

function fnSelect(fnSet){
	var cate = $('#cate1').val();
	var options = {};
	var f = $('#list1');
	var params = [];
	var len;
	var aiInptListId;
	var aiInptListNm;
	var choice = '선택';
	options.aiInptCtgrId = cate;
}
		
var <c:out value="${gridId}"/>Config = {
	ajaxUrl : '/api/admin/sanction/rule1',
	columns : [
	 	{"data": "aiInptCtgrNm", title: '카테고리' },
		{"data": "aiInptListNm", title: '리스트'},
		{"data": "aiInptCtgrId"}
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-left td-text-120' },
		{ targets: 2, className: 'td-text-left td-text-200' },
		{ targets: 3, className: 'td-text-left td-text-200', visible: false}
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];

		if(topGbn){
			options.schGbn = topGbn;
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7050","06","01",$.param(options));

		return options;
	}
};
var <c:out value="${gridId2}"/>Config = {
	ajaxUrl : '/api/admin/sanction/rule2',
	columns : [
		{ data: "aiInptSnrl2Nm"},
		{ data: "inptSanction1No"},
		{ data: "aiInptList1Id"},
		{ data: "inptSanction2No"},
		{ data: "aiInptList2Id"},
		{ data: "inptSanction3No"},
		{ data: "aiInptList3Id"},
		{ data: "inptSanction4No"},
		{ data: "aiInptList4Id"}
						
	/* 	$("#num2").val(row.aiInptSnrl2Id);
		$("#joggun2").val(fnCmnXssUnescape(row.aiInptSnrl2Nm));
 */
		
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-20' },
		{ targets: 1, className: 'td-text-left td-text-200' },
		{ targets: 2,  visible: false},
		{ targets: 3,  visible: false},
		{ targets: 4,  visible: false},
		{ targets: 5,  visible: false},
		{ targets: 6,  visible: false},
		{ targets: 7,  visible: false},
		{ targets: 8,  visible: false},
		{ targets: 9,  visible: false},
		{ targets: 10,  visible: false}
		
	],
    getSearchOption : function() {
		var options = {};
		var filters = [];

		if(topGbn){
			options.schGbn = topGbn;
		}

		fnCmnProgramLog("7050","07","01",$.param(options));

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
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${gridId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridRowCallback" value="Y" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>

<script>
var <c:out value="${gridId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail(row);
};
var <c:out value="${gridId2}"/>_selectCallback = function(e, dt, type, index, row){
	roww = row;
	//console.log(roww);
	fnSetDetail2(row, index);
};

//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail(row){
	if(row){
		var fnSet = row.aiInptListId;
		//상세/수정 모드
		$("#num1").val(row.aiInptSnrl1Id);
		$("#item1").val(row.inptSanctionNo);
		$("#list1").val(row.aiInptListId);
		$("#cate1").val(row.aiInptCtgrId);
		fnSelect(fnSet);
	} else {
		//프로그램 사용 이력 로그누적
		// fnCmnProgramLog("7050","06","05",$.param({}));
		//신규모드
		$("#num1").val("");
		$("#item1").val("");
		$("#list1").val("");
		$("#cate1").val("");
	}
}
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail2(row, index){
	if(row){
		//상세/수정 모드
		$("#num2").val(row.aiInptSnrl2Id);
		$("#joggun2").val(fnCmnXssUnescape(row.aiInptSnrl2Nm));
		$("#item2").val(row.inptSanction1No);
		$("#list2").val(row.aiInptList1Id);
		$("#item22").val(row.inptSanction2No);
		$("#list22").val(row.aiInptList2Id);
		$("#item23").val(row.inptSanction3No);
		$("#list23").val(row.aiInptList3Id);
		$("#item24").val(row.inptSanction4No);
		$("#list24").val(row.aiInptList4Id);
		$("#isNewOrMod").val("mod");
		$("#index").val(index);
		console.log($("#isNewOrMod").val());
		if($("#list22").val() == ""){
			$("#chk_item22").prop("checked",false);
		}else{
			$("#chk_item22").prop("checked",true);
		}
		if($("#list23").val() == ""){
			$("#chk_item23").prop("checked",false);
		}else{
			$("#chk_item23").prop("checked",true);
		}
		if($("#list24").val() == ""){
			$("#chk_item24").prop("checked",false);		
		}else{
			$("#chk_item24").prop("checked",true);		
		}
	} else {
		//프로그램 사용 이력 로그누적
		// fnCmnProgramLog("7050","07","05",$.param({}));
		//신규모드
		$("#num2").val("");
		$("#joggun2").val("");
		$("#item2").val("");
		$("#list2").val("");
		$("#item22").val("");
		$("#list22").val("");
		$("#item23").val("");
		$("#list23").val("");
		$("#item24").val("");
		$("#list24").val("");
		$("#isNewOrMod").val("new");
		$("#index").val("");
		
		$("#chk_item22").prop("checked",false);
		$("#chk_item23").prop("checked",false);
		$("#chk_item24").prop("checked",false);
	}
	fnSetRule2Input();
}

//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
/* function fnSetDetail3(row){
	if(row){
		//상세/수정 모드
		$("#num3").val(row.aiInptSnrl3Id);
		$("#joggun3").val(fnCmnXssUnescape(row.aiInptSnrl3Nm));
		$("#cont3").val(fnCmnXssUnescape(row.aiInptRsptSqlTxt));
	} else {
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7050","08","05",$.param({}));

		//신규모드
		$("#num3").val("");
		$("#joggun3").val("");
		$("#cont3").val("");
	}
} */

$(function(){
	initLoadingDisplay("Y", "class", "container");
	
	//############# 상단 공통검색 #############
	topGbn = fnGetTopGbnVal();
	
	fnGetSanctionInfo();	//공통정보 설정.
	fnSetItemInput();

	//상단 구분값 라디오버튼 변경시 처리.
	fnGetTopGbn().change(function(){
		topGbn = this.value;
		
		if(topGbn == 'TOT'){
			document.getElementById("rule1Id").style.display="";
			document.getElementById("rule2Id").style.display="none";
			document.getElementById("ilchiTot").style.display="";
			document.getElementById("ilchiItm").style.display="none";
		}
		if(topGbn == 'ITM'){
			document.getElementById("rule2Id").style.display="";
			document.getElementById("rule1Id").style.display="none";
			document.getElementById("ilchiTot").style.display="none";
			document.getElementById("ilchiItm").style.display="";
		}
		
		fnSetDetail(null);
		fnSetDetail2(null, null);
	//	fnSetDetail3(null);
		
		fnGetSanctionInfo();
		fnSetItemInput();
		
		<c:out value="${gridId}"/>.searchList();
		<c:out value="${gridId2}"/>.searchList();
	});
	
	//Rule2의 체크박스의 체크에 따라서 입력항목들이 활성화 비활성화 처리.
	fnSetRule2Input();
	$('#chk_item22').add('#chk_item23').add('#chk_item24').change(function(e){
		fnSetRule2Input();
	});
	
	$("#btnSaveInfo1").click(function(){
		var param = {};
		param.aiInptRuleDscd = topGbn;
		param.aiInptWordAcrdRt = $("#ilchiyul1").val();

		param.aiInptCnctScrnNo = "7050";
		param.aiInptCnctActiCd = "09";
		param.aiInptCnctFldCd = "06";
		param.aiInptCnctParmTxt = $.param(param);
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7050","06","09",$.param(param));
		
		//공통정보 저장 - 일치율 적용
		if(!fnCmnCheckValidNull($('#ilchiyul1'),'일치율을 입력해주세요.')) return;
		if(confirm("일치율을 적용하시겠습니까?")){
			$.post("/api/admin/sanction/request",param,function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${gridId}"/>.searchList();
				} else {
					alert(data.resultExCode);
				}
			});
		}
	});
	$("#btnSaveInfo2").click(function(){
		var param = {};
		param.aiInptRuleDscd = topGbn;
		param.aiInptWordAcrdRt = $("#ilchiyul2").val();

		param.aiInptCnctScrnNo = "7050";
		param.aiInptCnctActiCd = "09";
		param.aiInptCnctFldCd = "07";
		param.aiInptCnctParmTxt = $.param(param);
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7050","06","09",$.param(param));
		
		//공통정보 저장 - 일치율 적용
		if(!fnCmnCheckValidNull($('#ilchiyul2'),'일치율을 입력해주세요.')) return;
		if(confirm("일치율을 적용하시겠습니까?")){
			$.post("/api/admin/sanction/request",param,function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${gridId2}"/>.searchList();
			//		fnSetDetail2(null, null);
				} else {
					alert(data.resultExCode);
				}
			});
		}
	});

	//############# Rule1 #############
	
	//Rule1 신규버튼
	$("#newBtn1").click(function(e){
		<c:out value="${gridId}"/>.deselectAllListTableRow();
		fnSetDetail(null);
	});
	
	//Rule1 저장버튼
	$("#saveBtn1").click(function(e){
		var param = {};
		param.aiInptRuleDscd = topGbn;
		param.aiInptSnrl1Id = $('#num1').val();
	//	param.inptSanctionNo = fnGetItemObjVal('item1');
		param.aiInptListId = $('#list1').val();
		param.isNewOrMod = $('#isNewOrMod').val();
		
		param.aiInptCnctScrnNo = "7050";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "06";
		param.aiInptCnctParmTxt = $.param(param);
		
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("7050","06","04",$.param(param));
		
		if($.trim($('#item1').val())=="" && topGbn=='ITM'){
			alert("항목명을 선택해주세요.");
			$('#item1').focus();
			return;
		}
		if($.trim($('#list1').val())==""){
			alert("카테고리와 리스트를 선택해주세요.");
			$('#list1').focus();
			return;
		}
		$.post('/api/admin/sanction/rule1',param,function(data){
			var jsonResult = data.result;
			if(data.resultCode=='200' && jsonResult==true){
				alert('정상적으로 처리되었습니다.');
				<c:out value="${gridId}"/>.searchList();
				$('#list1').val("");
			}else if(jsonResult==false){
				alert('중복된 RULE 리스트가 존재합니다.');
			}else {
				fnAlertErrorMsg(data);
			}
		});
	});

	//Rule1 삭제처리
	$("#delBtn1").click(function(e){

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7050","06","06",$.param({'seq' : $('#num1').val()}));
		
		if($.trim($('#num1').val())==""){
			alert("Rule1 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/sanction/rule1/delete/'+$('#num1').val(),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${gridId}"/>.searchList();
					fnSetDetail(null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
	//############# Rule2 #############
	
	//Rule2 신규버튼
	$("#newBtn2").click(function(e){
		<c:out value="${gridId2}"/>.deselectAllListTableRow();
		fnSetDetail2(null, null);
	});
	
	//Rule2 저장버튼
	$("#saveBtn2").click(function(e){
		
		var param = {};
		param.aiInptRuleDscd = topGbn;
		param.aiInptSnrl2Id = $('#num2').val();
		param.aiInptSnrl2Nm = $('#joggun2').val();
		param.inptSanction1No = fnGetItemObjVal('item2');
		param.aiInptList1Id = $('#list2').val();
		param.inptSanction2No = fnGetItemObjVal('item22');
		param.aiInptList2Id = $('#list22').val();
		param.inptSanction3No = fnGetItemObjVal('item23');
		param.aiInptList3Id = $('#list23').val();
		param.inptSanction4No = fnGetItemObjVal('item24');
		param.aiInptList4Id = $('#list24').val();
		param.isNewOrMod = $('#isNewOrMod').val();
		
		param.aiInptCnctScrnNo = "7050";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "07";
		param.aiInptCnctParmTxt = $.param(param);
		
		//프로그램 사용 이력 로그누적 
		//fnCmnProgramLog("7050","07","04",$.param(param));
		//console.log($('#isNewOrMod').val());
		
		if($.trim($('#joggun2').val())==""){
			alert("조건명을 입력해주세요.");
			$('#joggun2').focus();
			return;
		}
		if($.trim($('#item2').val())=="" && topGbn=='ITM'){
			alert("항목을 선택해주세요.");
			$('#item2').focus();
			return;
		}
		if($.trim($('#list2').val())==""){
			alert("리스트를 선택해주세요.");
			$('#list2').focus();
			return;
		}
		
		if($('#chk_item22').is(":checked") && ($('#list22').val() == "" || $('#item22').val() == "")){
			alert("선택하지 않은 세부항목이 있습니다.");
			return;
		}
		
		if($('#chk_item23').is(":checked") && ($('#list23').val() == "" || $('#item23').val() == "")){
			alert("선택하지 않은 세부항목이 있습니다.");
			return;
		}
		
		if($('#chk_item24').is(":checked") && ($('#list24').val() == "" || $('#item24').val() == "")){
			alert("선택하지 않은 세부항목이 있습니다.");
			return;
		}
		
	/* 	if($('#chk_item24').is(":checked") && ($('#list22').val() == "" $('#item22').val() == "")){
			alert("선택하지 않은 세부항목이 있습니다.");
			return;
		} */
		
		if(($.trim($('#list2').val()) == $.trim($('#list22').val())) && $.trim($('#list2').val()) != "" && $.trim($('#list22').val()) != ""){
			if($.trim($('#item2').val()) == $.trim($('#item22').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		
		if(($.trim($('#list2').val()) == $.trim($('#list23').val())) && $.trim($('#list2').val()) != "" && $.trim($('#list23').val()) != ""){
			if($.trim($('#item2').val()) == $.trim($('#item23').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		
		if(($.trim($('#list2').val()) == $.trim($('#list24').val())) && $.trim($('#list2').val()) != "" && $.trim($('#list24').val()) != ""){
			if($.trim($('#item2').val()) == $.trim($('#item24').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		
		if(($.trim($('#list22').val()) == $.trim($('#list23').val())) && $.trim($('#list22').val()) != "" && $.trim($('#list23').val()) != ""){
			if($.trim($('#item22').val()) == $.trim($('#item23').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		
		if(($.trim($('#list22').val()) == $.trim($('#list24').val())) && $.trim($('#list22').val()) != "" && $.trim($('#list24').val()) != ""){
			if($.trim($('#item22').val()) == $.trim($('#item24').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		
		if(($.trim($('#list23').val()) == $.trim($('#list24').val())) && $.trim($('#list23').val()) != "" && $.trim($('#list24').val()) != ""){
			if($.trim($('#item23').val()) == $.trim($('#item24').val())){
				alert("동일항목 내 동일한 LIST는 등록이 불가합니다.");
				return;
			}
		}
		// 1단계 체크되어있는지 확인후 빈값체크
		// 
		
		$.post('/api/admin/sanction/rule2',param,function(data){
			var jsonResult = data.result;
			var index = $("#index").val();
			var e = $("#e").val();
			var dt = $("#dt").val();
			var type = $("#type").val();
			// var row = $("#row").val();
			var grid = <c:out value="${gridId2}"/>;
			if(data.resultCode=='200' && jsonResult==true){
				alert('정상적으로 처리되었습니다.');
				<c:out value="${gridId2}"/>.searchList();
				if($('#isNewOrMod').val() == 'mod'){
					indexRo = index;
					/* <c:out value="${gridId2}"/>.selectOneListTableRow(indexRo);
					console.log(json);
				//	$("#num2").val(data.resultList.aiInptSnrl2Id);
				//	$("#joggun2").val(fnCmnXssUnescape(jsonResult.aiInptSnrl2Nm));
					$("#item2").val(jsonResult.inptSanction1No);
					$("#list2").val(jsonResult.aiInptList1Id);
					$("#item22").val(jsonResult.inptSanction2No);
					$("#list22").val(jsonResult.aiInptList2Id);
					$("#item23").val(jsonResult.inptSanction3No);
					$("#list23").val(jsonResult.aiInptList3Id);
					$("#item24").val(jsonResult.inptSanction4No);
					$("#list24").val(jsonResult.aiInptList4Id);
					$("#isNewOrMod").val("mod");
					$("#index").val(index);
					console.log($("#isNewOrMod").val());
					if($("#list22").val() == ""){
						$("#chk_item22").prop("checked",false);
					}else{
						$("#chk_item22").prop("checked",true);
					}
					if($("#list23").val() == ""){
						$("#chk_item23").prop("checked",false);
					}else{
						$("#chk_item23").prop("checked",true);
					}
					if($("#list24").val() == ""){
						$("#chk_item24").prop("checked",false);		
					}else{
						$("#chk_item24").prop("checked",true);		
					} */
					
				}
				var tabl = document.getElementById("<c:out value="${gridId2}"/>")[0];
			}else if(jsonResult==false){
				alert('조건명이 동일한 항목심사 RULE이 존재합니다.');
			}else {
				fnAlertErrorMsg(data);
			}
		});
	});
	
	//Rule2 삭제처리
	$("#delBtn2").click(function(e){

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7050","07","06",$.param({'seq' : $('#num2').val()}));
		
		if($.trim($('#num2').val())==""){
			alert("Rule2 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/sanction/rule2/delete/'+$('#num2').val(),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
						<c:out value="${gridId2}"/>.searchList();
					fnSetDetail2(null, null);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
	//############# Rule3 #############

});
function fnGetTopGbn(){
	return $(":radio[name='bbutton']");
}
function fnGetTopGbnVal(){
	return $(":radio[name='bbutton']:checked").val();
}
function fnGetSanctionInfo(){
	//일치율 및 사용여부 정보 등 가져오기.
	var param = {};
	param.schGbn = topGbn;
	$.get('/api/admin/sanction/request?' + $.now(),param,function(data){
		if(data.resultCode=="200"){
			var resultList = data.resultList;
			var info = resultList && resultList.length ? resultList[0] : null;
			if(info){
				if(info.aiInptRuleDscd == 'TOT'){
					$("#ilchiyul1").val(info.aiInptWordAcrdRt);
				
				}else{
					$("#ilchiyul2").val(info.aiInptWordAcrdRt);
					
				}
			}
		} else {
			fnAlertErrorMsg(data);
		}
	});
}
function fnSetItemInput(){
	//상단에 토탈텍스트와 항목을 선택함에 따라서, 항목 입력박스들이 보이고 안보이고 처리.
	if(topGbn=="TOT"){
		$("#item1").prop('disabled',true);
		$("#item2").prop('disabled',true);
		$("#item22").prop('disabled',true);
		$("#item23").prop('disabled',true);
		$("#item24").prop('disabled',true);
		
		$("#item1").val("");
		$("#item2").val("");
		$("#item22").val("");
		$("#item23").val("");
		$("#item24").val("");
	} else {
		$("#item1").prop('disabled',false);
		$("#item2").prop('disabled',false);
		if($('#chk_item22')[0].checked) $("#item22").prop('disabled',false);
		if($('#chk_item23')[0].checked) $("#item23").prop('disabled',false);
		if($('#chk_item24')[0].checked) $("#item24").prop('disabled',false);
	}
}
function fnSetRule2Input(){
	//Rule2의 항목입력, 체크박스 동작 초기화.
	if($('#chk_item22')[0].checked){
		if(topGbn!='TOT') $("#item22").prop('disabled',false);
		$("#list22").prop('disabled',false);
	} else {
		$("#item22").val("");
		$("#list22").val("");
		$("#item22").prop('disabled',true);
		$("#list22").prop('disabled',true);
	}
	
	if($('#chk_item23')[0].checked){
		if(topGbn!='TOT') $("#item23").prop('disabled',false);
		$("#list23").prop('disabled',false);
	} else {
		$("#item23").val("");
		$("#list23").val("");
		$("#item23").prop('disabled',true);
		$("#list23").prop('disabled',true);
	}
	
	if($('#chk_item24')[0].checked){
		if(topGbn!='TOT') $("#item24").prop('disabled',false);
		$("#list24").prop('disabled',false);
	} else {
		$("#item24").val("");
		$("#list24").val("");
		$("#item24").prop('disabled',true);
		$("#list24").prop('disabled',true);
	}
}
//심사항목  값 반환, 상단에 TotalText 와 항목 라디오 버튼 선택에 따라서, 항목 선택시에만 값 반환.
function fnGetItemVal(itemVal){
	return topGbn=='ITM' ? itemVal : '';
}
//심사항목  객체값 반환, 상단에 TotalText 와 항목 라디오 버튼 선택에 따라서, 항목 선택시에만 값 반환.
function fnGetItemObjVal(itemId){
	var result = '';
	itemId = $.trim(itemId);
	if(itemId){
		result = fnGetItemVal($('#'+itemId).val());
	}
	return result;
}
</script>