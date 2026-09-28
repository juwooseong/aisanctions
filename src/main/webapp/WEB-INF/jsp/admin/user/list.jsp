<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="7010"/>
<c:set var="gridId" value="listTable_${pageId}"/>
<div class="container">
	<h2 class="title">
		<strong>사용자 관리 [7010]</strong>
		<span class="revertStatPageDiscription">심사자동화시스템 사용자 정보를 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>사용자 관리</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="" id="formSearch_<c:out value="${pageId}"/>" onsubmit="return false;">
				<p class="w24">
					<label for="schAuth_${pageId}" class="label">권한</label>
					<select class="" id="schAuth_<c:out value="${pageId}"/>">
						<option value="" checked="checked">전체</option>
						<c:forEach var="item" items="${authCodeList }">
							<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
						</c:forEach>
					</select>
				</p>
				<p class="w24">
					<label for="schUserId_${pageId}" class="label">직원번호</label>
					<input type="text" class="it" id="schUserId_<c:out value="${pageId}"/>" value="" placeholder="" maxlength="<c:out value="${maxLength_eno }"/>" />
					<button type="button" class="btType4 info" id="btn_appUserNo1" data-toggle="modal" data-target="#schUserModal" onclick="fnUserModalSelect(1);">
						<i class="fa fa-search fa-lg"></i>
					</button>
				</p>
				
				<p class="w24">
					<span>
						<label for="schUserNm_${pageId}" class="label">직원명</label>
						<input type="text" class="it" value="" id="schUserNm_<c:out value="${pageId}"/>" placeholder="직원명" title="직원명"/>
						
					</span>
				</p>
				<p class="w24"></p>
				<p class="w24">
					<span>
						<label for="schUserYN_${pageId}" class="label">사용여부</label>
						<select class="" id="schUserYN_<c:out value="${pageId}"/>">
							<option value="Y" checked="checked">사용</option>
							<option value="N" checked="">미사용</option>
						</select>
					</span>
				</p>
				
				<p class="w24">
					<span>
						<label for="schUserDscd_${pageId}" class="label">사용자구분</label>
						<select class="" id="schUserDscd_<c:out value="${pageId}"/>">
							<c:forEach var="item" items="${userCodeList}">
								<option value="${item.aiInptCmnCd}">${item.aiInptCmnCdNm}</option>
							</c:forEach>
						</select>
					</span>
				</p>
				<button class="searchBtnType1" id="searchBtn_<c:out value="${gridId}"/>">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<input type="hidden" value="02" id="auth02">
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>사용자 리스트</strong>
				</div>
				<div class="tbCon" style="padding: 6px 7px 7px 7px;">
					<table class="table table-responsive-sm" id="<c:out value="${gridId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>사용자 정보</strong>
				</div>
				<div class="tbCon" style="padding: 6px 7px 7px 7px;">
					<div class="searchBox" id="adminUserInfo">
						<form action="">
							<p class="">
								<label for="userNo" class="label">직원</label>
								<input type="text" id="userNo" class="it" value="" placeholder="직원번호" title="직원번호"/>
							</p>
							<p class="">
								<input type="text" class="it" value="" id="userNm" placeholder="직원명" title="직원명"/>
								</span>
							</p>
							
							
							<p class="w44">
								<label for="userYN" class="label">사용여부</label>
								<select class="" id="userYN">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>	
							</p>
							<p class="w44">
								<label for="userDscd" class="label">사용자구분</label>
								<select class="" id="userDscd">
									<c:forEach var="item" items="${userCodeList}">
									<%-- 	<c:if test="${item.aiInptCmnCd ne '01'}"> --%>
											<option value="${item.aiInptCmnCd}">${item.aiInptCmnCdNm}</option>
										<%-- </c:if> --%>
									</c:forEach>
								</select>	
							</p>
							
							<p class="w44">
								<label for="userAuth" class="label">권한</label>
								<select class="" onchange="fnSelectGbn()" id="userAuth">
									<c:forEach var="item" items="${authCodeList }">
										<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
									</c:forEach>
								</select>	
							</p>
							<p class="w44">
								<label for="userAdminYn" class="label">관리자여부</label>
								<label class="switch switch-primary switch switch-label">
									<input id="userAdminYn" class="switch-input" type="checkbox" checked="" autocomplete="off">
									<span class="switch-slider" data-checked="✓" data-unchecked="✕"></span>
			                    </label>
							</p>
							<p class="">
								<label for="appUserNo" class="label">담당 결재자</label>
								<input type="text" class="it" value="" id="appUserNo" placeholder="직원번호" title="직원번호" readonly/>
							</p>
							<p class="">
								<span>
									<input type="text" class="it" value="" id="appUserNm" placeholder="직원명" title="직원명" readonly/>
									<button type="button" class="btType4 info" id="btn_appUserNo2" data-toggle="modal" data-target="#schUserModal" onclick="fnUserModalSelect(2);">
										<i class="fa fa-search fa-lg"></i>
									</button>
								</span>
							</p>
							<input type="hidden" id="adminYN" value="">
						</form>
					</div>
					<div class="btBox">
						<span class="r">
							<button htype="button" class="btType2" id="newBtn">신규</button>
							<button htype="button" class="retryLogEndBtnDisabled revertUserCancelBtn" id="delBtn" disabled="disabled">삭제</button>
							<button type="button" class="btType1" id="saveBtn">저장</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<input type="hidden" id="index" value="" /> 
<input type="hidden" id="userId" value="" />
<input type="hidden" id="userNo2" value="" />
<input type="hidden" id="userNm2" value="" />
<input type="hidden" id="userAuth2" value="" />
<input type="hidden" id="appUserNo2" value="" />
<input type="hidden" id="appUserNm2" value="" />
<input type="hidden" id="adminYN2" value="" />
<input type="hidden" id="userDscd2" value="" />
<input type="hidden" id="userYN2" value="" />
<input type="hidden" id="userAdminYn2" value="" />
<form id="formProcParams"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var indexRo = $("#index").val();

var <c:out value="${gridId}"/>Config = {
	ajaxUrl : '/api/admin/user',
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-40' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-center td-text-60' },
		{ targets: 4, className: 'td-text-left td-text-60' },
		{ targets: 5, className: 'td-text-center td-text-100' },
		{ targets: 6, visible: false}
	],
	columns: [
		{"data": "aiInptUserAutVal", title: '권한'},
    	{"data": "aiInptAdminYn", title: '관리자'},
    	{"data": "aiInptUserEno", title: '직원번호'},
    	{"data": "aiInptUserNm", title: '직원명'},
    	{"data": "aiInptSnpeEno", title: '담당 결재자 직원번호'},
    	{"data": "aiInptSrvcUserDscd"}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//권한
		if($("#schAuth_<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schAuth_<c:out value="${pageId}"/>").val();
		}
		
		//직원
		if($("#schUserId_<c:out value="${pageId}"/>").val()){
			options.schUserNoNm = $("#schUserId_<c:out value="${pageId}"/>").val();
		}
		
		//직원
		if($("#schUserNm_<c:out value="${pageId}"/>").val()){
			options.schUserNm = $("#schUserNm_<c:out value="${pageId}"/>").val();
		}
		
		if($("#schUserYN_<c:out value="${pageId}"/>").val()){
			options.aiInptUserYn = $("#schUserYN_<c:out value="${pageId}"/>").val();
			console.log("schUserYN_ : " + options.aiInptUserYn);
		}
		
		if($("#schUserDscd_<c:out value="${pageId}"/>").val()){
			options.aiInptSrvcUserDscd = $("#schUserDscd_<c:out value="${pageId}"/>").val();
		}
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7010",null,"01",$.param(options));
		
		return options;
	}
	 /* , fnRowCallback : function(nRow, aData, rowIndex, iDisplayIndexFull){
		if(indexRo !=""){
			
		
			<c:out value="${gridId}"/>.selectOneListTableRow(indexRo);
		 	if(rowIndex == indexRo){
		 		userId= aData.aiInptUserId;
				$('#userNo2').val(aData.aiInptUserEno);
				$('#userNm2').val(aData.aiInptUserNm);
				$('#userAuth2').val(aData.aiInptUserAutCd);
				$('#appUserNo2').val(aData.aiInptSnpeEno);
				$('#appUserNm2').val(aData.aiInptSnpeNm);
				$('#userAdminYn2').val(aData.aiInptAdminYn);
				$('#adminYN2').val(aData.aiInptAdminYn);	
			
				$('#userDscd2').val(aData.aiInptSrvcUserDscd);
				$('#userYN2').val(aData.aiInptUserYn);
				$("#index").val(rowIndex);
		 	}
		
		 	if($("#userNo2").val() != ''){
		 		console.log($("#userNo2").val());
				$("#userNo").val($("#userNo2").val());
			}
		 	if($("#userNm2").val() != ''){
				$("#userNm").val($("#userNm2").val());
			}
		 	if($("#userAuth2").val() != ''){
				$("#userAuth").val($("#userAuth2").val());
			}
		 	if($("#appUserNo2").val() != ''){
				$("#appUserNo").val($("#appUserNo2").val());
			}
		 	if($("#appUserNm2").val() != ''){
				$("#appUserNm").val($("#appUserNm2").val());
			}
		 	if($("#userAdminYn2").val() != ''){
				$("#userAdminYn").val($("#userAdminYn2").val());
			}
		 	if($("#adminYN2").val() != ''){
				$("#adminYN").val($("#adminYN2").val());
				console.log($("#adminYN").val() + "adminYN");
			}
		 	if($("#userDscd2").val() != ''){
				$("#userDscd").val($("#userDscd2").val());
			}
		 	if($("#userYN2").val() != ''){
				$("#userYN").val($("#userYN2").val());
				
			}
			
			
		 	if($("#userAdminYn2").val() != ''){
		 		$('#userAdminYn').prop('checked',$("#userAdminYn2").val()=='Y' ? true : false); 
		 		$("#adminYN").val("");
			}
			isMod = true; 
		}
	}   */
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
	<jsp:param name="gridOptionScrollY" value="430" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>


var isMod;

$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	//alert($("#schUserDscd_<c:out value="${pageId}"/>") == "01")
	
	//document.getElementById("delBtn").style.display="none";
	
	$("#schUserId_<c:out value="${pageId}"/>").keydown(function(event) {
	 	if(event.keyCode ===8){
			$("#txt_inptBizAlctCrpeEno_<c:out value="${pageId}"/>").val("")
		} 
		 if(event.keyCode ===13){
			$('#btn_appUserNo1').trigger("click");
		} 
	}); 
	
	$('#newBtn').click(function(e){
	/* 	<c:out value="${pageId}"/>.deselectAllListTableRow(); */
		//프로그램 사용 이력 로그누적
	//	fnCmnProgramLog("7010",null,"05","");
		fnSetInfo(null);
	});
	
	$('#saveBtn').click(function(e){
		fnSave();
	});
	
	$('#delBtn').click(function(e){
		fnDel();
	});
	document.getElementById("userAdminYn").disabled = true;
	$('#btn_appUserNo2').css('display','block');
	
	if(isMod){
		fnSetInfo(row, indexRo);
	}
});

var <c:out value="${gridId}"/>_selectCallback = function(e, dt, type, index, row){
	fnSetInfo(row, index);
};

function fnSave(){
	var f = $('#formProcParams');
	

	
	if($.trim($('#userNm').val())==""){
		alert("직원명을 입력해주세요.");
		return;
	}
	
	if($.trim($('#userNo').val())==""){
		alert("직원번호를 입력해주세요.");
		return;
	}
	
	if(fnCheckByteSize($('#userNm').val()) > 40){
		alert("직원명은 40자리 이내로 입력해주세요.");
		return;
	}
	

	
	if(fnCheckByteSize($('#userNo').val()) > 8){
		alert("직원번호는 8자리 이내로 입력해주세요.");
		return;
	}
	if(($('#userAuth').val() == '01' || $('#userAuth').val() == '03' || $('#userAuth').val() == '04') 
			&& ($.trim($('#appUserNo').val())=="" || $.trim($('#appUserNm').val())=="")){
		alert("담당 결재자는 필수항목입니다.");
		return;
	}
	
	if($.trim($('#userNo').val()) == $.trim($('#appUserNo').val())){
		$('#appUserNo').val("");
		$('#appUserNm').val("");
		alert("담당 결재자는 본인이 될 수 없습니다.");
		return;
	}
	
	var params = [];


	params.push({n:'aiInptUserId',v:$('#userId').val()});
	params.push({n:'aiInptUserEno',v:$('#userNo').val()});
	
	if($('#userAuth').val() == null){
		params.push({n:'aiInptUserAutCd',v:""});
	}else{
		params.push({n:'aiInptUserAutCd',v:$('#userAuth').val()});
	}
	params.push({n:'aiInptSnpeEno',v:$('#appUserNo').val()});
	params.push({n:'aiInptUserNm',v:$('#userNm').val()});
	params.push({n:'aiInptUserYn',v:$('#userYN').val()});
	params.push({n:'aiInptSrvcUserDscd',v:$('#userDscd').val()});
	params.push({n:'aiInptAdminYn',v:$('#userAdminYn').prop('checked') ? 'Y' : 'N'});
	
	fnCmnSetFormParams(f,params);
	//프로그램 사용 이력 로그누적
	
	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7010">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctFldCd" value="">');
	console.log($("#index").val())
	if(isMod){
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="04">');
		if(confirm('사용자 정보를 저장 하시겠습니까?')){
			$.ajax({
				url: '/api/admin/user/update',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				var index= $("#index").val();
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${gridId}"/>.searchList();
			
					indexRo = index;
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	}else{
		f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="05">');
		if(confirm('사용자를 등록하시겠습니까?')){
			$.ajax({
				url: '/api/admin/user/insert',
				data: f.serialize(),
				method: 'post'
			}).done(function(data){
				if(data.result == false){
					alert("이미 사용중인 직원번호입니다.\n다른 직원번호를 입력해주시기 바랍니다.");
				}else{
					if(data.resultCode=="200"){
						alert("정상적으로 처리되었습니다.");
						<c:out value="${gridId}"/>.searchList();
					} else {
						fnAlertErrorMsg(data);
					}
				}
			});
		}
	}
	
	
}

function fnDel(){
	if($.trim($('#userId').val())==""){
		alert("삭제하실 직원정보를 좌측 사용자 목록에서 선택해주세요.");
		$('#userId').focus();
		return;
	}
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("7010",null,"06","");
	
	if(confirm("사용자 정보를 삭제하시겠습니까?")){
		$.ajax({
			url: '/api/admin/user/delete/'+$('#userId').val(),
			//data: f.serialize(),
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				<c:out value="${gridId}"/>.searchList();
				fnSetInfo(null, null);
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}

function fnSelectGbn() {
	//s1 ,QA일경우 결재자 활성화
	//결재자인 경우, 관리자여부 체크박스 셋팅활성화
	if($('#userAuth').val() != '02' || $('#userAuth').val() != '05'){
		document.getElementById("userAdminYn").disabled = true;
		document.getElementById("userAdminYn").checked = false;
		//console.log($('#userAuth').val()+ "zzzzzzzzzzzzzzz");
		$('#appUserNo').prop('disabled',false);
		$('#appUserNm').prop('disabled',false);
		$('#btn_appUserNo2').css('display','block');
		document.getElementById("btn_appUserNo2").disabled = false;
	}
	
	var delBtn = document.getElementById('delBtn');

	if($('#userDscd').val() == "01") {
		$('.revertUserCancelBtn').attr('disabled', true);
		$('.revertUserCancelBtn').removeClass('btType1');
		$('.revertUserCancelBtn').addClass('retryLogEndBtnDisabled');
	}else{
		$('.revertUserCancelBtn').attr('disabled', false);
		$('.revertUserCancelBtn').removeClass('retryLogEndBtnDisabled');
		$('.revertUserCancelBtn').addClass('btType1');
	}
	
	if($('#userAuth').val() == '02' || $('#userAuth').val() == '05'){
		document.getElementById("userAdminYn").disabled = false;
		document.getElementById("userAdminYn").checked = true;
		$('#btn_appUserNo2').css('display','none');
		if($('#adminYN').val() == 'N'){
			$('#userAdminYn').prop('checked',false);
		}else{
			$('#userAdminYn').prop('checked',true);
		}
		$('#appUserNo').val('');
		$('#appUserNm').val('');
		$('#appUserNo').prop('disabled',true);
		$('#appUserNm').prop('disabled',true);
		document.getElementById("btn_appUserNo2").disabled = true;
	}
}
//row 가 널이면, 신규 입력박스 클리어, 값이 있으면 해당 값으로 셋팅처리.
function fnSetInfo(row, index){
	if(row){
		$('#userId').val(row.aiInptUserId);
		$('#userNo').val(row.aiInptUserEno);
		$('#userNm').val(row.aiInptUserNm);
		$('#userAuth').val(row.aiInptUserAutCd);
		$('#appUserNo').val(row.aiInptSnpeEno);
		$('#appUserNm').val(row.aiInptSnpeNm);
		$('#userAdminYn').prop('checked',row.aiInptAdminYn=='Y' ? true : false);
		$('#adminYN').val(row.aiInptAdminYn);	
		$('#userNo').prop('disabled',true);
		$('#userNm').prop('disabled',true);
	//	$('#appUserNo').prop('disabled',true);
	//	$('#appUserNm').prop('disabled',true);
		$('#userDscd').val(row.aiInptSrvcUserDscd);
		$('#userYN').val(row.aiInptUserYn);
		$("#index").val(index);
		isMod = true;
	} else {
		$('#userId').val('');
		$('#userNo').val('');
		$('#userNm').val('');
		$('#userAuth').val('01');
		$('#appUserNo').val('');
		$('#appUserNm').val('');
		$('#userAdminYn').prop('checked',false);
		$('#userNo').prop('disabled',false);
		$('#userNm').prop('disabled',false);
		$('#userDscd').val('01');
		$('#userYN').val('Y');
		$("#index").val("");
		<c:out value="${gridId}"/>.deselect();
		isMod = false;
	}
	
	fnSelectGbn();
}
</script>
<jsp:include page="/common/user" flush="false">
	<jsp:param name="modelTitle" value="사용자 선택" />
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="modalId" value="schUserModal" />
</jsp:include>
<script>
//사용자 선택 모달 다이얼로그 스크립트 시작.
var userModalOpenGbn = 1;	//사용자 모달창을 어느 버튼에서 오픈했는지 구분자.

function modalUserListTable<c:out value="${pageId}"/>_selectOK(row){
	if(row){
		if(userModalOpenGbn==1){
			$("#schUserId_<c:out value="${pageId}"/>").val(row.aiInptUserEno);
			$("#schUserNm_<c:out value="${pageId}"/>").val(row.aiInptUserNm);
		} else {
			$("#appUserNo").val(row.aiInptUserEno);
			$("#appUserNm").val(row.aiInptUserNm);
		}
	}
}

function fnUserModalSelect(gbn){
	userModalOpenGbn = gbn;
 	if(userModalOpenGbn==1){
 		$("#auth02").val('');
	//	document.getElementById("modalSchUserAu<c:out value="${pageId}"/>").disabled = false;
	
	}  else   if(userModalOpenGbn==2){
		$("#auth02").val('02');
		modalUserListTable<c:out value ="${pageId}"/>_data.userAuthId = 'auth02';
	}  
}
</script>