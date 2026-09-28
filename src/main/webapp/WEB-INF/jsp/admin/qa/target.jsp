<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>
<c:set var="pageId" value="7060"/>
<div class="container">
	<h2 class="title">
		<strong>QA선정 관리 [7060]</strong>
		<span class="revertStatPageDiscription">전일 수출, 수입 심사완료건에 대해 자체검증(QA) 대상 배정 Rule 을 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>QA선정 관리</span>
		</span>
	</h2>

	<div class="tbWrap adminQAwrap">
			<span class="adminQAspan">※ QA 선정 건수는 입력된 총건수 * 3 건 입니다 (TotalText, 항목심사, SafeWatch 각각 총건수 만큼 선정됩니다)</span>
			<span class="adminQAspan">※ 조건에 해당하는 대상을 우선 선정하며, 그 외의 경우 Random 으로 선정됩니다</span>
	</div>

	<div class="contents">
		<div class="tbWrap">
			<div class="tbTop">
				<strong>수출</strong>
			</div>
			<div class="tbCon">
				<div class="searchBox">
					<form action="">
						<p class="w24">
							<label for="txt_exTotCnt${pageId}" class="label">총건수(건)</label>
							<input type="text" class="it" value="" placeholder="총건수" title="총건수" id="txt_exTotCnt<c:out value="${pageId}"/>"/>
						</p>
						<p class="w24">
							<label for="txt_exRanCnt${pageId}" class="label">Random(건)</label>
							<input type="text" class="it" value="" placeholder="Random" title="Random" id="txt_exRanCnt<c:out value="${pageId}"/>"/>
							</span>
						</p>
						<p class="w24">
							<label for="cb_exSancCd${pageId}" class="label">조건</label>
							<select title="" name="exSancCd" id="cb_exSancCd<c:out value="${pageId}"/>" onchange="chang();">
								<option value="">선택</option>
								<c:forEach var="item" items="${expItemList }">
								<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
								</c:forEach>
							</select>
						</p>
						<p class="w32 no-label-input">
							<select title="" name="exGrpCd" id="cb_exGrpCd<c:out value="${pageId}"/>">
								<option value="">선택</option>
								<c:forEach var="item" items="${grpList }">
								<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
								</c:forEach>
							</select>
						</p>
					</form>
				</div>
				<div class="btBox">
					<span class="r">
						<a href="javascript:void(0);" class="btType1" id="saveBtn1_<c:out value="${pageId}"/>">저장</a>
					</span>
				</div>
			</div>
		</div>
		<div class="tbWrap">
			<div class="tbTop">
				<strong>수입</strong>
			</div>
			<div class="tbCon">
				<div class="searchBox">
					<form action="">
						<p class="w24">
							<label for="txt_imTotCnt${pageId}" class="label">총건수(건)</label>
							<input type="text" name="imTotCnt" class="it" value="" placeholder="총건수" title="총건수" id="txt_imTotCnt<c:out value="${pageId}"/>"/>
						</p>
						<p class="w24">
							<label for="txt_imRanCnt${pageId}" class="label">Random(건)</label>
							<input type="text" class="it" value="" name="imRanCnt" placeholder="Random" title="Random" id="txt_imRanCnt<c:out value="${pageId}"/>"/>
							</span>
						</p>
						<p class="w24">
							<label for="cb_imSancCd${pageId}" class="label">조건</label>
							<select title="" name="imSancCd" id="cb_imSancCd<c:out value="${pageId}"/>" onchange="chang2();">
								<option value="">선택</option>
								<c:forEach var="item" items="${expItemList }">
									<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdEngNm }</option>
								</c:forEach>
							</select>
						</p>
						<p class="w32 no-label-input">
							<select title="" name="imGrpCd" id="cb_imGrpCd<c:out value="${pageId}"/>">
								<option value="">선택</option>
								<c:forEach var="item" items="${grpList }">
									<option value="${item.aiInptListId }">${item.aiInptListNm }</option>
								</c:forEach>
							</select>
						</p>
					</form>
				</div>
				<div class="btBox">
					<span class="r">
						<a href="javascript:void(0);" class="btType1" id="saveBtn2_<c:out value="${pageId}"/>">저장</a>
					</span>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var page_id = '<c:out value="${pageId}"/>';

$(function() {
	initLoadingDisplay("Y", "class", "container");
	
	search_7060(1);
	search_7060(2);
	
	//수출저장
	$('#saveBtn1_<c:out value="${pageId}"/>').click(function(e){
		// 수출 총건수 validation
		if(!fnCheckUsingCharForamt(1, $("#txt_exTotCnt<c:out value="${pageId}"/>").val())){
			alert("숫자만 입력가능합니다");
			return;
		}
		
		// 수출 Random validation
		if(!fnCheckUsingCharForamt(1, $("#txt_exRanCnt<c:out value="${pageId}"/>").val())){
			alert("숫자만 입력가능합니다");
			return;
		}
		fnSave(2);
	});

	//수입저장
	$('#saveBtn2_<c:out value="${pageId}"/>').click(function(e){
		// 수출 총건수 validation
		if(!fnCheckUsingCharForamt(1, $("#txt_imTotCnt<c:out value="${pageId}"/>").val())){
			alert("숫자만 입력가능합니다");
			return;
		}
		// 수출 Random validation
		if(!fnCheckUsingCharForamt(1, $("#txt_imRanCnt<c:out value="${pageId}"/>").val())){
			alert("숫자만 입력가능합니다");
			return;
		}
		fnSave(1);
	});
});

//수출조회 : search_7060(2);
//수입조회 : search_7060(1);
function search_7060(eximGu) {
	s_loading();
	var searchOptions = {};
	searchOptions.aiInptImexDscd = eximGu;

	if(eximGu=="2"){			// 수출
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7060","09","01",$.param(searchOptions));
	} else if(eximGu=="1"){		// 수입
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("7060","10","01",$.param(searchOptions));
	}

	$.get("/api/admin/qa/target?" + $.now(), searchOptions, function(data){
		h_loading();
	
		if(eximGu=="2"){
			// 수출
			$('#txt_exTotCnt' + page_id).val(data.qlasItmTotCnt);
			$('#txt_exRanCnt' + page_id).val(data.qlasVolnChcCnt);
			$('#cb_exSancCd' + page_id).val(data.aiInptItmCd);
			$('#cb_exGrpCd' + page_id).val(data.aiInptListId);

			if($("#cb_exSancCd<c:out value="${pageId}"/>").val() == ""){
				$("#cb_exGrpCd<c:out value="${pageId}"/>").prop('disabled',true);
			} else{
				$("#cb_exGrpCd<c:out value="${pageId}"/>").prop('disabled',false);
			}
		} else if(eximGu=="1"){
			// 수입
			$('#txt_imTotCnt' + page_id).val(data.qlasItmTotCnt);
			$('#txt_imRanCnt' + page_id).val(data.qlasVolnChcCnt);
			$('#cb_imSancCd' + page_id).val(data.aiInptItmCd);
			$('#cb_imGrpCd' + page_id).val(data.aiInptListId);

			if($("#cb_imSancCd<c:out value="${pageId}"/>").val() == ""){
				$("#cb_imGrpCd<c:out value="${pageId}"/>").prop('disabled',true);
			}else{
				$("#cb_imGrpCd<c:out value="${pageId}"/>").prop('disabled',false);
			}
		}
	});
}

function fnSave(eximGu){
	var param = {};
	param.aiInptImexDscd = eximGu;
	
	if(eximGu=="2"){
		// 수출
		param.qlasItmTotCnt = $('#txt_exTotCnt' + page_id).val();
		param.qlasVolnChcCnt = $('#txt_exRanCnt' + page_id).val();
		param.aiInptItmCd = $("#cb_exSancCd" + page_id).val();
		param.aiInptListId = $("#cb_exGrpCd" + page_id).val();
		
		param.aiInptCnctScrnNo = "7060";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "09";
		param.aiInptCnctParmTxt = $.param(param);
	} else if(eximGu=="1"){
		// 수입
		param.qlasItmTotCnt = $('#txt_imTotCnt' + page_id).val();
		param.qlasVolnChcCnt = $('#txt_imRanCnt' + page_id).val();
		param.aiInptItmCd = $("#cb_imSancCd" + page_id).val();
		param.aiInptListId = $("#cb_imGrpCd" + page_id).val();
		
		param.aiInptCnctScrnNo = "7060";
		param.aiInptCnctActiCd = "04";
		param.aiInptCnctFldCd = "10";
		param.aiInptCnctParmTxt = $.param(param);
	}
	
	//빈값 필수값 체크
	if(eximGu=="2"){
		if($.trim($('#cb_exSancCd' + page_id).val()) !="" && $.trim($('#cb_exGrpCd' + page_id).val())==""){
			alert("조건을 선택해주세요.");
			$('#cb_exGrpCd' + page_id).focus();
			return;
		} 
		if($.trim($('#txt_exTotCnt' + page_id).val())==""){
			alert("총건수를 입력해주세요.");
			$('#txt_exTotCnt' + page_id).focus();
			return;
		}
		if($.trim($('#txt_exRanCnt' + page_id).val())==""){
			alert("Random 건수를 입력해주세요.");
			$('#txt_exRanCnt' + page_id).focus();
			return;
		}
		if(parseInt($.trim($('#txt_exTotCnt' + page_id).val())) < parseInt($.trim($('#txt_exRanCnt' + page_id).val()))){
			alert("Random 건수는 총건수를 초과할 수 없습니다.");
			$('#txt_exRanCnt' + page_id).focus();
			return;
		}
	} else if(eximGu=="1"){
		if($.trim($('#cb_imSancCd' + page_id).val()) !="" && $.trim($('#cb_imGrpCd' + page_id).val())==""){
			alert("조건을 선택해주세요.");
			$('#cb_imGrpCd' + page_id).focus();
			return;
		} 
		if($.trim($('#txt_imTotCnt' + page_id).val())==""){
			alert("총건수를 입력해주세요.");
			$('#txt_imTotCnt' + page_id).focus();
			return;
		}
		if($.trim($('#txt_imRanCnt' + page_id).val())==""){
			alert("Random 건수를 입력해주세요.");
			$('#txt_imRanCnt' + page_id).focus();
			return;
		}
		if(parseInt($.trim($('#txt_imTotCnt' + page_id).val())) < parseInt($.trim($('#txt_imRanCnt' + page_id).val()))){
			alert("Random 건수는 총건수를 초과할 수 없습니다.");
			$('#txt_imRanCnt' + page_id).focus();
			return;
		}
	} else {
		return;
	}
	
 	if(confirm("저장하시겠습니까?")){
		$.ajax({
			url: '/api/admin/qa/target',
			data: param,
			method: 'post'
		}).done(function(data){
			if(data.resultCode=="200"){
				alert("정상적으로 처리되었습니다.");
				search_7060(1);
				search_7060(2);
			} else {
				alert(data.resultMsg);
			}
		});
	} 
}

function chang(){
	if($("#cb_exSancCd<c:out value="${pageId}"/>").val() == ""){
		$("#cb_exGrpCd<c:out value="${pageId}"/>").val("");
		$("#cb_exGrpCd<c:out value="${pageId}"/>").prop('disabled',true);
	}else{
		$("#cb_exGrpCd<c:out value="${pageId}"/>").prop('disabled',false);
	}
}

function chang2(){
	if($("#cb_imSancCd<c:out value="${pageId}"/>").val() == ""){
		$("#cb_imGrpCd<c:out value="${pageId}"/>").prop('disabled',true);
		$("#cb_imGrpCd<c:out value="${pageId}"/>").val("");
	}else{
		$("#cb_imGrpCd<c:out value="${pageId}"/>").prop('disabled',false);
	}
}
</script>