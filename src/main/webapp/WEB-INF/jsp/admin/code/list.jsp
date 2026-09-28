<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="8010"/>
<c:set var="admGrpTblId" value="admCtgrTbl_${pageId}"/>
<c:set var="admCodeTblId" value="admGrpTbl_${pageId}"/>

<div class="container">
	<h2 class="title">
		<strong>공통코드관리 [8020]</strong>
		<span class="revertStatPageDiscription">시스템에서 사용하는 공통코드를 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>코드 관리</span>
			<span>공통코드 관리</span>
		</span>
	</h2>
	
	<div class="contents">
		<div class="flGroup item_2">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>코드그룹</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${admGrpTblId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>코드그룹 정보</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="a1_aiInptGrpCd" class="label">그룹코드</label>
								<input type="text" id="a1_aiInptGrpCd" class="it" value="" placeholder="그룹코드" title="그룹코드" disabled />
							</p>
							<p class="">
								<label for="a1_aiInptGrpNm" class="label">코드그룹명</label>
								<input type="text" id="a1_aiInptGrpNm" class="it" value="" placeholder="코드그룹명" title="코드그룹명"/>
							</p>
							<p class="">
								<label for="a1_a1ImexhissAbbr" class="label">비고</label>
								<input type="text" id="a1_a1ImexhissAbbr" class="it" value="" placeholder="비고" title="비고"/>
							</p>
							<p class="">
								<label for="a1_aiInptGrpUsgYn" class="label">사용여부</label>
								<label class="switch switch-primary switch switch-label">
									<input id="a1_aiInptGrpUsgYn" class="switch-input" type="checkbox" checked="" autocomplete="off">
									<span class="switch-slider" data-checked="✓" data-unchecked="✕"></span>
			                    </label>
							</p>
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
			<div class="tbWrap">
				<div class="tbTop">
					<strong>공통코드</strong>
				</div>
				<div class="tbCon">
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${admCodeTblId}"/>"></table>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>공통코드 정보</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="">
							<p class="">
								<label for="a2_aiInptGrpCd" class="label">코드그룹</label>
								<input type="text" id="a2_aiInptGrpCd" class="it" value="" placeholder="코드그룹" title="코드그룹" disabled />
							</p>
							<p class="">
								<label for="a2_aiInptCmnCd" class="label">공통코드</label>
								<input type="text" id="a2_aiInptCmnCd" class="it" value="" placeholder="공통코드" title="공통코드" disabled  />
							</p>
							<p class="">
								<label for="a2_aiInptCmnCdNm" class="label">코드명(한글)</label>
								<input type="text" id="a2_aiInptCmnCdNm" class="it" value="" placeholder="코드명(한글)" title="코드명(한글)"  />
							</p>
							<p class="">
								<label for="a2_aiInptCmnCdEngNm" class="label">코드명(영문)</label>
								<input type="text" id="a2_aiInptCmnCdEngNm" class="it" value="" placeholder="코드명(영문)" title="코드명(영문)"  />
							</p>
							<p class="">
								<label for="a2_a1ImexhissAbbr" class="label">비고</label>
								<input type="text" id="a2_a1ImexhissAbbr" class="it" value="" placeholder="비고" title="비고"/>
							</p>
							<p class="">
								<label for="a2_aiInptSortSeq" class="label">순서</label>
								<input type="text" id="a2_aiInptSortSeq" class="it" value="" placeholder="순서" title="순서"/>
							</p>
							<p class="">
								<label for="a2_aiInptIntfItmNm" class="label">I/F 항목명</label>
								<input type="text" id="a2_aiInptIntfItmNm" class="it" value="" placeholder="I/F 항목명" title="I/F 항목명"/>
							</p> 
							<p class="">
								<label for="a2_aiInptCmnUsgYn" class="label">사용여부</label>
								<label class="switch switch-primary switch switch-label">
									<input id="a2_aiInptCmnUsgYn" class="switch-input" type="checkbox" checked="" autocomplete="off">
									<span class="switch-slider" data-checked="✓" data-unchecked="✕"></span>
			                    </label>
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
	</div>
</div>

<input type="hidden" id="aiInptGrpCd" value="" />
<input type="hidden" id="aiInptCmnCd" value="" />

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>
var <c:out value="${admGrpTblId}"/>Config = {
	ajaxUrl : '/api/admin/code/grp/list',
	columns : [
		{ data: "aiInptGrpCd", title: '그룹코드' },
		{ data: "aiInptGrpNm", title: '코드그룹명' },
		{ data: "aiInptRmrkTxt", title: '비고' }, 
		{ data: "aiInptGrpUsgYn", title: '사용여부' }
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-30' },
		{ targets: 1, className: 'td-text-center td-text-100' },
		{ targets: 2, className: 'td-text-left td-text-150' },
		{ targets: 3, className: 'td-text-left td-text-180' },
		{ targets: 4, className: 'td-text-center td-text-60' }
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		/* if($("#schUserAuth<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth<c:out value="${pageId}"/>").val();
		} */

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8020","15","01",$.param(options));

		return options;
	}
};
var <c:out value="${admCodeTblId}"/>Config = {
	ajaxUrl : '/api/admin/code/cd/list',
	columns : [
		{ data: "aiInptGrpCd", title: '그룹코드' },
		{ data: "aiInptCmnCd", title: '공통코드' },
		{ data: "aiInptCmnCdNm", title: '코드명(한글)' },
		{ data: "aiInptCmnCdEngNm", title: '코드명(영문)' },
		{ data: "aiInptRmrkTxt", title: '비고' },
		{ data: "aiInptCmnUsgYn", title: '사용여부' },
		{ data: "aiInptSortSeq", title: '순서' },
		{ data:"aiInptIntfItmNm"}
		
    ],
	columnDefs: [
		{ targets: 0, className: 'td-text-center td-text-30' },
		{ targets: 1, className: 'td-text-center td-text-40' },
		{ targets: 2, className: 'td-text-center td-text-40' },
		{ targets: 3, className: 'td-text-left td-text-100' },
		{ targets: 4, className: 'td-text-left td-text-100' },
		{ targets: 5, className: 'td-text-center td-text-80' },
		{ targets: 6, className: 'td-text-center td-text-40' },
		{ targets: 7, className: 'td-text-center td-text-40' },
		{ targets: 8, visible: false }
	],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		if($("#aiInptGrpCd").val()){
			options.aiInptGrpCd = $("#aiInptGrpCd").val();
		}

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8020","16","01",$.param(options));

		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admGrpTblId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admCodeTblId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="200" />
</jsp:include>
<script>
var <c:out value="${admGrpTblId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail(row);
};
var <c:out value="${admCodeTblId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	fnSetDetail2(row);
};
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail(row){
	if(row){
		//상세/수정 모드
		$("#aiInptGrpCd").val(row.aiInptGrpCd);
		$("#aiInptCmnCd").val("");
		
		$("#a1_aiInptGrpCd").val(row.aiInptGrpCd);
		$("#a1_aiInptGrpNm").val(fnCmnXssUnescape(row.aiInptGrpNm));
		$("#a1_aiInptGrpUsgYn").prop('checked',row.aiInptGrpUsgYn=='Y' ? true : false);
		$("#a1_a1ImexhissAbbr").val(row.aiInptRmrkTxt);
		$("#a2_aiInptSortSeq").val(row.aiInptSortSeq);
		$("#a2_aiInptIntfItmNm").val(row.aiInptIntfItmNm);
		$("#a1_aiInptGrpCd").prop('disabled',true);
	} else {

		//프로그램 사용 이력 로그누적
	//	fnCmnProgramLog("8010","15","05",$.param({}));

		//신규모드
		$("#aiInptGrpCd").val("");
		$("#aiInptCmnCd").val("");
		
		$("#a1_aiInptGrpCd").val("");
		$("#a1_aiInptGrpNm").val("");
		$("#a1_a1ImexhissAbbr").val("");
		
		$("#a1_aiInptGrpUsgYn").prop('checked',false);

		$("#a1_aiInptGrpCd").prop('disabled',false);
		
		<c:out value="${admGrpTblId}"/>.deselect();
	}
	
	//하위 목록 및 상세 초기화
	fnSetDetail2(null);
	
	//하위 그리드 갱신.
	<c:out value="${admCodeTblId}"/>.searchList();
}
//신규버튼 클릭시 row 는 널값, 상세 및 수정모드시에는 실제 그리드에서 제공해주는 row값.
function fnSetDetail2(row){
	if(row){
		//상세/수정 모드
		$("#aiInptGrpCd").val(row.aiInptGrpCd);
		$("#aiInptCmnCd").val(row.aiInptCmnCd);
		
		$("#a2_aiInptGrpCd").val(row.aiInptGrpCd);
		$("#a2_aiInptCmnCd").val(row.aiInptCmnCd);
		$("#a2_aiInptCmnCdNm").val(fnCmnXssUnescape(row.aiInptCmnCdNm));
		$("#a2_aiInptCmnCdEngNm").val(fnCmnXssUnescape(row.aiInptCmnCdEngNm));
		$("#a2_aiInptCmnUsgYn").prop('checked',row.aiInptCmnUsgYn=='Y' ? true : false);
		$("#a2_a1ImexhissAbbr").val(row.aiInptRmrkTxt);
		$("#a2_aiInptSortSeq").val(row.aiInptSortSeq);
		$("#a2_aiInptIntfItmNm").val(row.aiInptIntfItmNm);
		$("#a2_aiInptCmnCd").prop('disabled',true);
	} else {
		
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("8010","16","05",$.param({}));

		//신규모드
		$("#aiInptCmnCd").val("");

		$("#a2_aiInptGrpCd").val($('#aiInptGrpCd').val());
		$("#a2_aiInptCmnCd").val("");
		$("#a2_aiInptCmnCdNm").val("");
		$("#a2_aiInptCmnCdEngNm").val("");
		$("#a2_aiInptCmnUsgYn").prop('checked',false);
		$("#a2_a1ImexhissAbbr").val("");
		$("#a2_aiInptSortSeq").val("");
		$("#a2_aiInptIntfItmNm").val("");
		$("#a2_aiInptCmnCd").prop('disabled',false);
		
		<c:out value="${admCodeTblId}"/>.deselect();
	}
}
$(function(){

	initLoadingDisplay("Y", "class", "container");
	//############# 코드그룹 #############
	
	//코드그룹 신규버튼
	$("#newBtn1").click(function(e){
		fnSetDetail(null);
	});
	
	//코드그룹 저장버튼
	$("#saveBtn1").click(function(e){
		var param = {};
		if(fnCheckByteSize($('#a1_aiInptGrpCd').val()) > 3){
			alert("그룹코드는 3자리 밑으로 적용해주시기 바랍니다."); 
		}else if(fnCheckByteSize($('#a1_aiInptGrpNm').val()) > 40){
			alert("그룹그룹명은 40자리 밑으로 적용해주시기 바랍니다."); 
		}else if($('#a1_a1ImexhissAbbr').val() > 100){  
			alert("비고는 4000자리 밑으로 적용해주시기 바랍니다."); 
		}else{
			param.aiInptGrpCd = $('#a1_aiInptGrpCd').val();
			param.aiInptGrpNm = $('#a1_aiInptGrpNm').val();
			param.aiInptGrpUsgYn = $('#a1_aiInptGrpUsgYn').prop('checked') ? "Y" : "N";
			param.aiInptRmrkTxt = $('#a1_a1ImexhissAbbr').val();
			//alert(param.aiInptRmrkTxt);
			
			param.aiInptCnctParmTxt = $.param(param);
			param.aiInptCnctScrnNo = "8020";
			param.aiInptCnctActiCd = "04";
			param.aiInptCnctFldCd = "15";
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("8010","15","04",$.param(param));
			
			if($.trim($('#a1_aiInptGrpCd').val())==""){
				alert("그룹코드를 입력해주세요.");
				$('#a1_aiInptGrpCd').focus();
				return;
			}
			if(!fnCheckUsingCharForamt(1, $.trim($('#a1_aiInptGrpCd').val()))){
				alert("그룹코드 에 한글이나 숫자를 사용할 수 없습니다.");
				$('#a1_aiInptGrpCd').focus();
				return;
			}
			if($.trim($('#a1_aiInptGrpNm').val())==""){
				alert("코드그룹명 명을 입력해주세요.");
				$('#a1_aiInptGrpNm').focus();
				return;
			} 
			if(fnCheckUsingCharForamt(3, $.trim($('#a1_aiInptGrpNm').val()))){
				alert("코드그룹명 에 특수문자를 사용할 수 없습니다.");
				$('#a1_aiInptGrpNm').focus();
				return;
			}
			
			$.post('/api/admin/code/grp/insert',param,function(data){
				if(data.resultCode=='200'){
					alert('정상적으로 처리되었습니다.');
					<c:out value="${admGrpTblId}"/>.searchList();
					fnSetDetail(null);
				} else {
					alert(data.resultMsg);
				}
			});
		}
	});

	//코드그룹 삭제처리
	$("#delBtn1").click(function(e){

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8020","15","06",$.param({'aiInptGrpCd' : $('#aiInptGrpCd').val()}));
		
		if($.trim($('#aiInptGrpCd').val())==""){
			alert("코드그룹 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/code/grp/delete/'+$('#aiInptGrpCd').val(),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admGrpTblId}"/>.searchList();
					fnSetDetail(null);
				} else if(data.resultExMsg) {
					alert(data.resultExMsg);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
	//############# 공통코드 #############
	
	//공통코드 신규버튼
	$("#newBtn2").click(function(e){
		fnSetDetail2(null);
	});
	
	//공통코드 저장버튼
	$("#saveBtn2").click(function(e){
		var param = {};
		
		
		if($.trim($('#aiInptGrpCd').val())==""){
			alert("코드그룹 목록에서 코드그룹 항목을 선택해주세요.");
			return;
		}
		// 공통코드 빈칸체크
		if($.trim($('#a2_aiInptCmnCd').val())==""){
			alert("공통코드 는 필수 입력값입니다.");
			$('#a2_aiInptCmnCd').focus();
		}
		// 공통코드 길이체크
		else if(fnCheckByteSize($('#a2_aiInptCmnCd').val()) > 10){
			alert("공통코드 는 10자리 이하로 적용해주시기 바랍니다."); 
			$('#a2_aiInptCmnCd').focus();
		}
		// 코드명(한글) 빈칸체크
		
		else if($.trim($('#a2_aiInptCmnCdNm').val())==""){
			alert("코드명(한글)은 필수 입력값입니다.");
			$('#a2_aiInptCmnCdNm').focus();
		}
		// 코드명(한글) 길이체크(추가필요)
		// 코드명(영문) 빈칸체크
		
		else if($.trim($('#a2_aiInptCmnCdEngNm').val())==""){
			alert("코드명(영문)은 필수 입력값입니다.");
			$('#a2_aiInptCmnCdEngNm').focus();
		}
		// 코드명(영문) 길이체크(추가필요)
		else if(fnCheckByteSize($('#a2_aiInptCmnCdEngNm').val()) > 60){
			alert("코드명(영문)은 60자 이내로 적용해주시기 바랍니다.");
			$('#a2_aiInptCmnCdEngNm').focus();
		}
		else if(fnCheckByteSize($('#a2_aiInptCmnCdNm').val()) > 50){
			alert("코드명(한글)은  50자 이내로 적용해주시기 바랍니다.");
			$('#a2_aiInptCmnCdNm').focus();
		}
		else if(fnCheckByteSize($('#a2_a1ImexhissAbbr').val()) > 100){
			alert("비고는 4000자리 밑으로 적용해주시기 바랍니다."); 
			$('#a2_a1ImexhissAbbr').focus();
		}
		else if(fnCheckByteSize($('#a2_aiInptSortSeq').val()) > 3){
			alert("순서는 3자리 밑으로 적용해주시기 바랍니다."); 
			$('#a2_aiInptSortSeq').focus();
		}
		else if(fnCheckByteSize($('#a2_aiInptIntfItmNm').val()) > 100){
			alert("인터페이스 항목명은 100자리 밑으로 적용해주시기 바랍니다."); 
			$('#a2_aiInptIntfItmNm').focus();
		}else{
			param.aiInptGrpCd = $('#aiInptGrpCd').val();
			param.aiInptCmnCd = $('#a2_aiInptCmnCd').val();
			param.aiInptCmnCdNm = $('#a2_aiInptCmnCdNm').val();
			param.aiInptCmnCdEngNm = $('#a2_aiInptCmnCdEngNm').val();
			param.aiInptRmrkTxt = $('#a2_a1ImexhissAbbr').val();
			param.aiInptSortSeq = $('#a2_aiInptSortSeq').val();
			param.aiInptIntfItmNm = $('#a2_aiInptIntfItmNm').val();
			//alert(param.aiInptRmrkTxt);
			param.aiInptCmnUsgYn = $('#a2_aiInptCmnUsgYn').prop('checked') ? "Y" : "N";
			
			param.aiInptCnctParmTxt = $.param(param);
			param.aiInptCnctScrnNo = "8020";
			param.aiInptCnctActiCd = "04";
			param.aiInptCnctFldCd = "16";
			
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("8010","16","04",$.param(param));
	
			

			/* // 공통코드 숫자만 validation
			if(!fnCheckUsingCharForamt(1, $.trim($('#a2_aiInptCmnCd').val()))){
				alert("공통코드 는 숫자만 입력해주세요");
				$('#a2_aiInptCmnCd').focus();
				return;
			} */
			
			// 코드명(한글) 특수문자 불가능
			if(fnCheckUsingCharForamt(3, $.trim($('#a2_aiInptCmnCdNm').val()))){
				alert("코드명(한글) 은 특수문자를 사용할 수 없습니다");
				$('#a2_aiInptCmnCdNm').focus();
				return;
			}
			// 코드명(영어) 특수문자 불가능
			if(fnCheckUsingCharForamt(3, $.trim($('#a2_aiInptCmnCdEngNm').val()))){
				alert("코드명(영문) 은 특수문자를 사용할 수 없습니다");
				$('#a2_aiInptCmnCdEngNm').focus();
				return;
			}
			if(!fnCheckUsingCharForamt(1, $('#a2_aiInptSortSeq').val())){
				alert("순서는 숫자만 입력해주세요");
				$('#a2_aiInptSortSeq').focus();
				return;
			}
		
			/*//이미 위에서 실행됌
			if($.trim($('#a2_aiInptCmnCdNm').val())=="" && $.trim($('#a2_aiInptCmnCdEngNm').val())==""){
				alert("공통코드 명을 입력해주세요.");
				$('#a2_aiInptCmnCdNm').focus();
				return;
			}*/
			
			$.post('/api/admin/code/cd/insert',param,function(data){
				if(data.resultCode=='200'){
					alert('정상적으로 처리되었습니다.');
					<c:out value="${admCodeTblId}"/>.searchList();
					fnSetDetail2(null);
				} else {
					alert(data.resultMsg);
				}
			});
		}
	});
	
	//공통코드 삭제처리
	$("#delBtn2").click(function(e){

		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("8020","16","06",$.param({'aiInptGrpCd' : $('#aiInptGrpCd').val(), 'aiInptCmnCd' : $('#aiInptCmnCd').val()}));
		
		if($.trim($('#aiInptCmnCd').val())==""){
			alert("공통코드 목록에서 삭제할 항목을 선택해주세요.");
			return;
		}
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
				url: '/api/admin/code/cd/delete/'+$('#aiInptGrpCd').val()+'/'+$('#aiInptCmnCd').val(),
				data: {},
				method: 'post'
			}).done(function(data){
				if(data.resultCode=="200"){
					alert("정상적으로 처리되었습니다.");
					<c:out value="${admCodeTblId}"/>.searchList();
					fnSetDetail2(null);
				} else if(data.resultExMsg) {
					alert(data.resultExMsg);
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}
	});
	
});
</script>