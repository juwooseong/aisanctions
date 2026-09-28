<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7070" />
<c:set var="gridId" value="listTable${pageId}" />

<div class="container">
	<h2 class="title">
		<strong>부재 관리 [7070]</strong>
		<span class="revertStatPageDiscription">사용자 부재정보를 관리하는 화면</span>
		<span class="location">
			<span>관리자메뉴</span>
			<span>부재 관리</span>
		</span>
	</h2>

	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="">
				<p class="w18">
					<label for="schAuth" class="label">권한</label> 
					<select class="" name="schAuth" id="schAuth" onchange="chang();">
						<option value="">전체</option>
						<c:forEach var="item" items="${userAuthList}">
							<c:if test="${item.aiInptCmnCd ne '04' and item.aiInptCmnCd ne '02'  and item.aiInptCmnCd ne '05'}">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
							</c:if>
						</c:forEach>
					</select>
				</p>
				<p class="w36">
					<label for="schUserNo" class="label">직원</label>
					<input type="text"class="it w48_v2" value="" id="schUserNo" placeholder="직원번호" title="직원번호"/>
					<button type="button" class="btType4 info" id="btn_appUserNo" data-toggle="modal" data-target="#schUserModal"onclick="fnUserModalSelect(1);">
						<i class="fa fa-search fa-lg"></i>
					</button>
					<input type="text" class="it w48_v2" value="" id="schUserNm" placeholder="직원명" title="직원명">
				</p>
				<p class="w20">
					<span>
						<label for="userFaReYn" class="label">부재여부</label>
						<select class="" name="userFaReYn"" id="userFaReYn">
							<option value="N">N</option>
							<option value="Y">Y</option>
							<option value="">전체</option>
						</select>
					</span>
				</p>
				
				

				<button class="searchBtnType1" id="searchBtn_<c:out value="${gridId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>

	<div class="contents">
		<div class="tbWrap">
			<div class="tbCon">
				<table class="table table-responsive-sm scrollTb"
					id="<c:out value="${gridId}"/>"></table>
			</div>
		</div>
	</div>
	<div class="btBox">
		<span class="c"> 
			<a href="javascript:void(0);" class="btType2"id="saveBtn1">해제</a> 
			<a href="javascript:void(0);" class="btType1" id="saveBtn2">부재</a>
		</span>
	</div>
</div>

<input type="hidden" id="userId" value="" />
<form id="formProcParams"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript"
	src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript"
	src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

	function appvAllSelectCheck(){
		var allChkBox = $('#appvAllSelector');
		
		if(allChkBox.is(":checked")){
			testConsoleTable();
		}else if(!allChkBox.is(":checked")){
			fnDeselectListTableAll();
		}
	}

	
	//select-checkbox 
	var <c:out value="${gridId}"/>Config = {
		ajaxUrl : '/api/admin/absence',
		columnDefs : [ {
			targets : 0,
			className : 'text-center td-text-20 no-use-sorting', orderable :false
		}, {
			targets : 1,
			className : 'td-text-center td-text-60'
		}, {
			targets : 2,
			className : 'td-text-center td-text-60 '
		}, {
			targets : 3,
			className : 'td-text-left td-text-60'
		}, {
			targets : 4,
			className : 'td-text-center td-text-60'
		} ],
		columns : [ {
			"data" : "aiInptUserAutVal",
			title : '권한'
		}, {
			"data" : "aiInptUserEno",
			title : '직원번호'
		}, {
			"data" : "aiInptUserNm",
			title : '직원명'
		}, {
			"data" : "aiInptUserFaReYn",
			title : '부재여부',
			render : function(data, type, row, meta) {
				if (data == "Y") {
					return '부재'
				} else {
					return ''
				}
			}
		} ],
		//검색정의
		getSearchOption : function() {
			var options = {};
			var filters = [];

			//권한
			if ($("#schAuth").val()) {
				options.schAuth = $("#schAuth").val();
			}

			//직원번호
			if ($("#schUserNo").val()) {
				options.schUserNo = $("#schUserNo").val();
				console.log(options.schUserNo)
			}
			
			if($("#userFaReYn").val()){
				options.aiInptUserFaReYn = $("#userFaReYn").val();
			}
			
			if ($("#schUserNm").val()) {
				options.schUserNm = $("#schUserNm").val();
			}

			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("7070", null, "01", $.param(options));

			return options;
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
			tdElementNo = $('.table-responsive-sm').find('thead').find('tr').find('th'); // [No] column selector #1
			tdElementNoObj = $(tdElementNo[0]); // [No] column selector #2
			tdElementNoObj.html(""); // [No] column text remove
			tdElementNoObj.html('<input type="checkbox" class="appvAllSelector" id="appvAllSelector" onclick="appvAllSelectCheck();" autocomplete="off" >');
			$(nRow).find('td').eq(0).html('<input type="checkbox" class="multiRowChkBox" id="multiRowChkBox" style="background-color: transparent !important;">');
			
			if(aData['aiInptUserAutVal']=='S2'){
				var multiChkBox = $(nRow).find('td').eq(0).find('.multiRowChkBox');
				$(multiChkBox).css('display','none');
				//$(multiChkBox).prop('disabled', true);
			}
		}
	};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${gridId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="multi" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="380" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>
	var <c:out value="${gridId}"/>_selectCallback = function(e, dt, type, index, row){	
		if(row.aiInptUserAutVal=='S2'){
			<c:out value="${gridId}"/>.deselectItem(index);
		}
		
		var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
		if($(multiChkBoxList[index]).is(':enabled')){
			$(multiChkBoxList[index]).prop('checked', true);
		}
	};
	
	var <c:out value="${gridId}"/>_deselectCallback = function(e, dt, type, index, row){	
		var multiChkBoxList = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
		if($(multiChkBoxList[index]).is(':enabled')){
			$(multiChkBoxList[index]).prop('checked', false);	
		}
	};
	
	$(function() {
		initLoadingDisplay("Y", "class", "container");
		
		$('#saveBtn1').click(function(e) {
			fnSave('N', true);
		});
	
		$('#saveBtn2').click(function(e) {
			fnSave('Y', false);
		});
	});

	function fnSave(flag, stat) {
		var selRows = <c:out value="${gridId}"/>.getSelRows();
		var f = $('#formProcParams');
		var params = [];
		params.push({
			n : 'aiInptUserFaReYn',
			v : flag
		});
		for (var i = 0; i < selRows.length; i++) {
			var row = selRows[i];
			if(row.aiInptUserFaReYn == 'Y' && stat == false && selRows.length == 1){
				alert("이미 부재처리가 되어있는 사용자입니다.")
				return false;
			}else if(row.aiInptUserFaReYn == 'Y' && stat == false && selRows.length != 1){
				alert("이미 부재처리가 되어있는 사용자가 있습니다.")
				return false;
			}else if(row.aiInptUserFaReYn == 'N' && stat == true && selRows.length == 1){
				alert("이미 해제처리가 되어있는 사용자입니다.")
				return false;
			}else if(row.aiInptUserFaReYn == 'N' && stat == true && selRows.length != 1){
				alert("이미 해제처리가 되어있는 사용자가 있습니다.")
				return false;
			}
			params.push({
				n : 'userNos',
				v : row.aiInptUserEno
			});
		}
		
		fnCmnSetFormParams(f, params);
		
		if (flag == 'N') { //해제
			f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7070">');
			f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="10">');
			f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("7070", null, "10", f.serialize());
		} else if (flag == 'Y') { //부재
			f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7070">');
			f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="11">');
			f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("7070", null, "11", f.serialize());
		}
	
		if (!selRows.length) {
			alert("사용자를 한 명 이상 선택해주세요.");
			return;
		}
		if (confirm('선택하신 사용자에 대해서 부재정보를 설정 하시겠습니까?')) {
			$.ajax({
				url : '/api/admin/absence/update',
				data : f.serialize(),
				method : 'post'
			}).done(function(data) {
				if (data.resultCode == "200") {
					alert("정상적으로 처리되었습니다.");
					<c:out value="${gridId}"/>.searchList();
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	}
</script>
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 선택" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>

<script>
	//사용자 선택 모달 다이얼로그 스크립트 시작.
	var userModalOpenGbn = 1; //사용자 모달창을 어느 버튼에서 오픈했는지 구분자.
	function modalUserListTable<c:out value="${pageId}"/>_selectOK(row) {
		if (row) {
			if (userModalOpenGbn == 1) {
				$("#schUserNo").val(row.aiInptUserEno);
				$("#schUserNm").val(row.aiInptUserNm);
			}
		}
	}
	function fnUserModalSelect(gbn) {
		userModalOpenGbn = gbn;
	}
	function chang() {
		$("#schUserNo").val("");
		$("#schUserNm").val("");
	}
	
	function fnDeselectListTableAll(){
		var testTableObject = <c:out value="${gridId}"/>;
		testTableObject.deselectAllListTableRow();
		$('.multiRowChkBox').prop('checked', false);
	}
	
	function testConsoleTable(){
		var testTableObject = <c:out value="${gridId}"/>;
		var dataRows = testTableObject.getAllListTableRow();
		dataRowsTest = testTableObject.getAllListTableRow();
		testTableObject.selectAllListTableRow();
		
		var selectedRowsList = testTableObject.getSelRows();
		
		// 조건부 선택 해제
		for(var index = 0 ; index < selectedRowsList.length ; index++){
			if(selectedRowsList[index].aiInptUserAutVal=='S2'){
				testTableObject.deselectItem(index);
			}else{
				var multiChkBox = $('.table-responsive-sm').find('tbody').find('tr').find('.multiRowChkBox');
				$(multiChkBox[index]).prop('checked', true);
			}
		}
	}
</script>