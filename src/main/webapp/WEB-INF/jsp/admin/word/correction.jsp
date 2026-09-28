<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="8060"/>
<c:set var="dataTableId" value="dataTable_${pageId}"/>
<style>

</style>
<div class="container">
	<h2 class="title">
		<strong>후보정용어관리 [8060]</strong>
		<span class="revertStatPageDiscription"></span>
		<span class="location">
			<span>관리자메뉴</span>
			<span>코드관리</span>
			<span>후보정용어관리</span>
		</span>
	</h2>
	
	<div class="tbWrap adminQAwrap" style="margin-bottom: 10px;">
			<span class="adminQAspan">※ 한글, 한문, 전각문자, 개행문자 는 후보정용어로 등록할 수 없습니다.</span>
			<span class="adminQAspan">※ 후보정용어는 개당 최소 1Byte 최대 100Byte 까지 등록할 수 있습니다.</span>
	</div>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn_wc" style="
    float: right;
    padding: 10px;
    font-size: 12px;
"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form action="" onsubmit="return false;">
				<p class="w26">
					<label for="cbo_bizCode_Search" class="label">구분</label>
					<select name="schGbn" class="selectBiz" id="cbo_bizCode_Search">
						<option value="242">수출</option>
						<option value="241">수입</option>
						<option value="110">공통</option>
						<option value="777">전체</option>
					</select>
				</p>
				
				<p class="w26">
					<label for="cbo_sanctionItem_Search" class="label">항목</label>
					<select name="schGbn" class="cbo_bizCode_Search" id="cbo_sanctionItem_Search">
						<option value="">전체</option>
						<c:forEach var="item" items="${selectBoxList }" varStatus="status">
							<option value="${item.aiInptIntfItmNm }"><c:out value="${item.aiInptCmnCdNm }"/></option>
						</c:forEach>			
					</select>
				</p>
				<p class="w26">
					<label for="inpt_word_Search" class="label">용어</label>
					<input type="text" class="it" id="inpt_word_Search" />
				</p>
				<button type="button" class="searchBtnType1" id="wordCorrectionSearchBtn">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
		<div class="tbWrap" style="
    display: inline-block;
    width: 58%;
    margin-top: 30px;
">
			<div class="tbCon">
				<button type="button" class="gridRightTopBtn xlsDownloadBtn" onclick="downXls<c:out value="${pageId}"/>();">엑셀다운로드</button>
				<table class="table table-responsive-sm" id="<c:out value="${dataTableId}"/>"></table>
			</div>
		</div>
		<div class="tbWrap"style="
	float: right;
    width: 39%;
    display: inline-block;
    vertical-align: top;
">
				<div class="tbTop">
					<strong>용어 등록</strong>
				</div>
				<div class="tbCon">
					<div class="searchBox">
						<form action="" onsubmit="return false;">
							<p class="">
								<label for="cbo_bizCode_Update" class="label">구분</label>
								<select name="list1" class="selectBiz" id="cbo_bizCode_Update">
									<option value="242">수출</option>
									<option value="241">수입</option>
									<option value="110">공통</option>
								</select>
							</p>
							<p class="">
								<label for="cbo_sanctionItem_Update" class="label">항목</label>
								<select name="list1" class="cbo_bizCode_Update" id="cbo_sanctionItem_Update">
									<option value="">선택</option>
									<c:forEach var="item" items="${selectBoxList }" varStatus="status">
										<option value="${item.aiInptIntfItmNm }"><c:out value="${item.aiInptCmnCdNm }"/></option>
									</c:forEach>	
								</select>
							</p>
							<p class="">
								<label for="inpt_word_Update" class="label">용어</label>
								<input type="text" id="inpt_word_Update" class="it" value="" placeholder="용어" />
								<input type="hidden" id="inpt_pk_Update" value="new"/>
							</p>
						</form>
					</div>
			
					<div class="btBox">
						<span class="r">
							<button type="button" class="btType2" id="newWordBtn">신규</button>
							<button type="button" class="btType2" id="delWordBtn">삭제</button>
							<button type="button" class="btType1" id="savWordBtn">저장</button>
						</span>
					</div>
				</div>
				
				
			</div>
	</div>
</div>

<form id="formXls" method="get"></form>
<form id="formParamData" style="position: absolute;opacity: 1;"></form>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

$(function() {
	initLoadingDisplay("Y", "class", "container");
	
	// 화면내에 구분 콤보박스를 변경했을 시
	$(document).on('change', '.selectBiz', function(){
		
		setSanctionItemCombo($(this).attr('id'), $(this).val(), null);
		
	});
	
	// global keyup
	$(document).keyup(function(e) {
		if(e.keyCode === 13) {
			console.log('what');
		}
	});
	
	// 화면내에 조회 버튼을 클릭했을 시(grid.jsp 의 global 이벤트와 분리함)
	$(document).on('click', '#wordCorrectionSearchBtn', function(){
		var valRstMapper = validationSearchBtn();
		
		if(valRstMapper.rst){
			searchTableReload();	
			initInputArea();
		}else if(!valRstMapper.rst){
			alert(valRstMapper.rstMsg);
			$('#inpt_word_Search').focus();
			$('#inpt_word_Search').val('');
		}
		
	});
	
	// 화면 검색박스 안에 초기화버튼 클릭 시(항목 동적설정으로 인해 global 이벤트와 분리함)
	$(document).on('click', '.init_btn_wc', function(e){
		// 이벤트 전파 제거
		e.stopPropagation();
		
	});
	
	// 신규버튼 클릭했을 시
	$(document).on('click', '#newWordBtn', function(){
		initInputArea();
	});
	
	// 삭제버튼 클릭했을 시
	$(document).on('click', '#delWordBtn', function(){
		var valRstMapper = vaildationUpdateBtn();
		var deleteFlag = $('#inpt_pk_Update').val();
		
		if(deleteFlag == 'new'){
			alert('삭제 할 후보정용어를 목록에서 선택해주세요.');
			return;
		}else{
			
			if(confirm('삭제하시겠습니까?')){
				// parameter
				// 1) for update -> inpt_pk_Update(pk), cbo_sanctionItem_Update(항목값), inpt_word_Update(용어값)
				// 2) for programLog -> aiInptCnctParmTxt, aiInptCnctScrnNo, aiInptCnctActiCd
				var param = {};
				param.aiInptWordSrno = $('#inpt_pk_Update').val();
				param.aiInptGrpCd = $('#cbo_sanctionItem_Update').val();
				param.aiInptWordTxt = $.trim($('#inpt_word_Update').val());
				
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8060";
				param.aiInptCnctActiCd = "06"; // 삭제
				
				$.post('/api/admin/word/correction/delete', param, function(data){
					if(data.rst == 'delete-success'){
						alert('삭제되었습니다.');
						searchTableReload();
					}
				}); // end of ajax
			}// end of confirm
			
		}
		
	});
	
	// 저장버튼 클릭했을 시
	$(document).on('click', '#savWordBtn', function(){
		var valRstMapper = vaildationUpdateBtn();
		
		if(fnCheckByteSize($.trim($('#inpt_word_Update').val())) > 99){
			alert('후보정용어는 100 Byte 를 초과할 수 없습니다.');
			return;
		}else if(fnCheckByteSize($.trim($('#inpt_word_Update').val())) == 1){
			alert('후보정용어는 최소 1 Byte 이상 입력해야 합니다.');
			return;
		}
		
		console.log('preprocess: '+fnHtmlEscape($.trim($('#inpt_word_Update').val())));
		
		if(valRstMapper.rst){
			if(confirm('저장하시겠습니까?')){
				// parameter
				// 1) for update -> inpt_pk_Update(pk), cbo_sanctionItem_Update(항목값), inpt_word_Update(용어값)
				// 2) for programLog -> aiInptCnctParmTxt, aiInptCnctScrnNo, aiInptCnctActiCd
				var param = {};
				param.aiInptWordSrno = $('#inpt_pk_Update').val();
				param.aiInptGrpCd = $('#cbo_sanctionItem_Update').val();
				param.aiInptWordTxt = $.trim($('#inpt_word_Update').val());
				
				param.aiInptCnctParmTxt = $.param(param);
				param.aiInptCnctScrnNo = "8060";
				param.aiInptCnctActiCd = "04"; // 저장
				
				$.post('/api/admin/word/correction/update', param, function(data){
					if(data.rst == 'insert-success'){
						alert('후보정용어가 신규등록되었습니다.');
						searchTableReload();
					}else if(data.rst == 'update-success'){
						alert('후보정용어가 수정되었습니다.');
						searchTableReload();
					}else if(data.rst == 'duplication'){
						alert('이미 등록된 후보정용어 입니다.');
					}
				}); // end of ajax
				
				
			}
		}else if(!valRstMapper.rst){
			alert(valRstMapper.rstMsg);
		}
	});
});
 
var <c:out value="${dataTableId}"/>Config = {
		ajaxUrl : '/api/admin/word/correction/list',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-10' }, 	// NO
			{ targets: 1, className: 'td-text-center td-text-40' }, 	// 구분
			{ targets: 2, className: 'td-text-left td-text-40' }, 		// 항목명
			{ targets: 3, className: 'td-text-left td-text-100' }, 		// 용어값
			{ targets: 4, visible: false }, 							// 117 후보정항목코드
			{ targets: 5, visible: false }, 							// 최종수정시간
			{ targets: 6, visible: false }, 							// 112수입수출코드
			{ targets: 7, visible: false } 								// PK
		],
		columns: [
			{"data": "aiInptGrpCdNm", title: '구분'},		// 구분
        	{"data": "aiInptCmnCdNm", title: '항목'},		// 항목명
        	{"data": "aiInptWordTxt", title: '용어'},		// 용어값
        	{"data": "aiInptGrpCd"},  					// 117 후보정항목코드
        	{"data": "lstDbChgDtm"},  					// 최종수정시간
        	{"data": "aiInptGrpCdCc"},  				// 112수입수출코드
        	{"data": "aiInptWordSrno"}  				// PK
	    ],
	    //검색정의
	    getSearchOption : function() {
	    	
	    	var page_id = '<c:out value="${pageId}"/>';
	    	var options = {};
			var filters = [];
			
			options.inptAtmcBizDscd = $('#cbo_bizCode_Search').val();
			options.schInptItem = $('#cbo_sanctionItem_Search').val();
			options.schText1 = $('#inpt_word_Search').val();
			
			//프로그램 사용 이력 로그누적
			//fnCmnProgramLog("1030",null,"01",$.param(options));
			
			return options;
			
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

		}
	};
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="440" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>
<script>

var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){	
	setRowDataToInputElement(row.aiInptWordSrno, row.aiInptGrpCdCc, row.aiInptGrpCd, row.aiInptWordTxt);
	console.log('parameter: ', row.aiInptWordSrno, row.aiInptGrpCdCc, row.aiInptGrpCd, row.aiInptWordTxt);
	setInputDisabledToggle(true);
};

var <c:out value="${dataTableId}"/>_deselectCallback = function(e, dt, type, index, row){	

};

function searchTableReload(){
	<c:out value="${dataTableId}"/>.searchList();
}

// 우측 입력영역 초기화
function initInputArea(){
	$('#inpt_pk_Update').val('new');
	$('#cbo_bizCode_Update').val('242');
	setSanctionItemCombo('cbo_bizCode_Update', '242', null);
	$('#inpt_word_Update').val('');
	
	setInputDisabledToggle(false);
}

// 테이블 클릭 시, 오른쪽  input 에 값을 채움
function setRowDataToInputElement(PK, bizCode, sanctionItem, word){
	// pk hidden value 설정
	$('#inpt_pk_Update').val(PK);
	
	// 항목 설정
 	
	// 구분 설정
	if(sanctionItem == '110'){
		$('#cbo_sanctionItem_Update').html('<option value="110">(공통) Insurance Company Name</option>');
		$('#cbo_bizCode_Update').val('110');
	}else{
		setSanctionItemCombo('cbo_bizCode_Update', bizCode, sanctionItem);
		$('#cbo_bizCode_Update').val(bizCode);
	}
	
	// 용어값 설정
	$('#inpt_word_Update').val(fnHtmlEscapeConv(word));
}

// 행 선택시, 수정 삭제을 위해 구분과 항목값을 disabled 처리
function setInputDisabledToggle(YN){
	if(YN){
		$('#cbo_bizCode_Update').prop('disabled', 'disabled');
		$('#cbo_sanctionItem_Update').prop('disabled', 'disabled');
	}else if(!YN){
		$('#cbo_bizCode_Update').prop('disabled', '');
		$('#cbo_sanctionItem_Update').prop('disabled', '');
	}
}

// 조회버튼 검색필터 유효성 검증
// 규칙: 구분, 항목 검색콤보박스 중 하나라도 전체 이면 용어를 입력해야함
function validationSearchBtn(){
	var valRstInfoMapper = {};
	var validationTarget1 = $('#cbo_bizCode_Search'); // cbo_bizCode_Search 구분
	var validationTarget2 = $('#cbo_sanctionItem_Search'); // cbo_sanctionItem_Search 항목
	var validationTarget3 = $('#inpt_word_Search'); // inpt_word_Search 용어
	
	if(validationTarget1.val() == "" || validationTarget2.val() == ""){
		if($.trim(validationTarget3.val()) == ""){
			valRstInfoMapper.rst = false;
			valRstInfoMapper.rstMsg = "항목 조건이 전체 인 경우 조회할 용어를 필수로 입력해야 합니다.";
		}else{
			valRstInfoMapper.rst = true;
			valRstInfoMapper.rstMsg = "clear";
		}
	}else{
		valRstInfoMapper.rst = true;
		valRstInfoMapper.rstMsg = "clear";
	}
	
	return valRstInfoMapper; 
}

// 저장버튼 유효성 검증
// 규칙: 항목 이 선택이 아니면서 용어를 입력해야함
function vaildationUpdateBtn(){
	var valRstInfoMapper = {};
	var validationTarget1 = $('#cbo_sanctionItem_Update'); // cbo_sanctionItem_Update 항목
	var validationTarget2 = $('#inpt_word_Update'); // inpt_word_Update 용어
	
	if(validationTarget1.val() == ""){
		valRstInfoMapper.rst = false;
		valRstInfoMapper.rstMsg = "저장할 항목을 선택해주세요.";
	}else if($.trim(validationTarget2.val()) == ""){
		valRstInfoMapper.rst = false;
		valRstInfoMapper.rstMsg = "저장할 용어를 입력해주세요.";
	}else{
		valRstInfoMapper.rst = true;
		valRstInfoMapper.rstMsg = "clear";
	}
	
	return valRstInfoMapper;
}

// global 콤보박스 변경(구분에 따라 sanction 항목 유동적으로 변경)
// 변경ComboBox class명, 수입&수출&공통, 초기화여부(어느 항목값으로 초기화할것인지)
function setSanctionItemCombo(targetClass, bizCode, init){
	
	var changeTargetElement = $('.'+targetClass);
	 
	var htmlValue = '';
	
	if(targetClass.split('_')[2] == 'Search'){
		htmlValue += '<option value="">전체</option>';
	}else if(targetClass.split('_')[2] == 'Update'){
		htmlValue += '<option value="">선택</option>';
	}
	
	var param = {};
	param.inptAtmcBizDscd = bizCode; //$(this).val();
	
	$.post('/api/admin/word/correction/change/combo', param, function(data){
		if(data.rst == 'success'){
			console.log(data.comboList);
			
			for(var i = 0 ; i < data.comboList.length ; i++){
				console.log(data.comboList[i].aiInptCmnCdNm);
				
				htmlValue += '<option value='+data.comboList[i].aiInptIntfItmNm+'>'+
								data.comboList[i].aiInptCmnCdNm+
								'</option>';
			}
			changeTargetElement.html(htmlValue);
			
			if(init != null){
				changeTargetElement.val(init);
			}
		}
	}); // end of ajax
}

function downXls<c:out value="${pageId}"/>(){
	if(<c:out value="${dataTableId}"/>.dataCount() < 1){
		alert('데이터가 존재하지 않습니다.');
		return;
	}
	
	var searchOption = <c:out value="${dataTableId}"/>Config.getSearchOption();
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("8060",null,"02",$.param(searchOption));
	
	fnCmnDownXls($('#formXls'), '/api/admin/word/correction/xls', searchOption);
	
} 

function fnHtmlEscapeConv(str) {
	if(!str) return str;
	
	str = str+'';
	str = fnCmnReplaceAll(str,'&#35;','#');
	str = fnCmnReplaceAll(str,'&#38;','&');
	str = fnCmnReplaceAll(str,'&lt;','<');
	str = fnCmnReplaceAll(str,'&gt;','>');
	str = fnCmnReplaceAll(str,'&#40;','(');
	str = fnCmnReplaceAll(str,'&#41;',')');
	str = fnCmnReplaceAll(str,'&quot;','"');
	str = fnCmnReplaceAll(str,'&#39;',"'");
	str = fnCmnReplaceAll(str,'&#x3D;',"=");
	str = fnCmnReplaceAll(str,'&#x60;',"`");
	
	return str;
}
</script>