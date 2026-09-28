<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>

<c:set var="pageId" value="5020"/>

<c:set var="apdrDsNm01" value=""/>
<c:set var="apdrDsNm02" value=""/>
<c:set var="apdrDsNm03" value=""/>
<c:set var="apdrDsNm04" value=""/>
<c:set var="apdrDsNm05" value=""/>
<c:forEach var="item" items="${apdrDsCdList}">
<c:if test="${item.aiInptCmnCd eq '01'}"><c:set var="apdrDsNm01" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '02'}"><c:set var="apdrDsNm02" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '03'}"><c:set var="apdrDsNm03" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '04'}"><c:set var="apdrDsNm04" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '05'}"><c:set var="apdrDsNm05" value="${item.aiInptCmnCdNm}"/></c:if>
</c:forEach>

<c:set var="apdrItmNm01" value=""/>
<c:set var="apdrItmNm02" value=""/>
<c:set var="apdrItmNm03" value=""/>
<c:set var="apdrItmNm04" value=""/>
<c:set var="apdrItmNm05" value=""/>
<c:set var="apdrItmNm06" value=""/>
<c:set var="apdrItmNm07" value=""/>
<c:set var="apdrItmNm08" value=""/>
<c:set var="apdrItmNm09" value=""/>
<c:set var="apdrItmNm10" value=""/>
<c:set var="apdrItmNm11" value=""/>
<c:set var="apdrItmNm12" value=""/>
<c:set var="apdrItmNm13" value=""/>
<c:set var="apdrItmNm14" value=""/>
<c:set var="apdrItmNm15" value=""/>
<c:set var="apdrItmNm16" value=""/>
<c:set var="apdrItmNm17" value=""/>
<c:set var="apdrItmNm18" value=""/>
<c:set var="apdrItmNm19" value=""/>
<c:set var="apdrItmNm20" value=""/>
<c:forEach var="item" items="${apdrItmCdList}">
<c:if test="${item.aiInptCmnCd eq '01'}"><c:set var="apdrItmNm01" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '02'}"><c:set var="apdrItmNm02" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '03'}"><c:set var="apdrItmNm03" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '04'}"><c:set var="apdrItmNm04" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '05'}"><c:set var="apdrItmNm05" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '06'}"><c:set var="apdrItmNm06" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '07'}"><c:set var="apdrItmNm07" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '08'}"><c:set var="apdrItmNm08" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '09'}"><c:set var="apdrItmNm09" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '10'}"><c:set var="apdrItmNm10" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '11'}"><c:set var="apdrItmNm11" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '12'}"><c:set var="apdrItmNm12" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '13'}"><c:set var="apdrItmNm13" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '14'}"><c:set var="apdrItmNm14" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '15'}"><c:set var="apdrItmNm15" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '16'}"><c:set var="apdrItmNm16" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '17'}"><c:set var="apdrItmNm17" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '18'}"><c:set var="apdrItmNm18" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '19'}"><c:set var="apdrItmNm19" value="${item.aiInptCmnCdNm}"/></c:if>
<c:if test="${item.aiInptCmnCd eq '20'}"><c:set var="apdrItmNm20" value="${item.aiInptCmnCdNm}"/></c:if>
</c:forEach>

<div class="container">
	<h2 class="title">
		<strong>업무일지 등록 [5020]</strong>
		<span class="revertStatPageDiscription">일별 수출입 선적서류 심사건수를 조회하고, W/F 중 증빙서류 심사 건수, 수/발신 전문 심사 건수, 서류심사 자체심사 건수 등 수기등록 하는 화면</span>
		<span class="location">
			<span>업무일지</span>
			<span>업무일지 등록</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form class="form-horizontal" id="formSearch_<c:out value="${pageId}"/>" onsubmit="return false;">
				
				<p class="w36">
					<label for="stat_date" class="label">업무생성일</label>
					<input type="text" class="cal daterange-basic calSingle" name="aiInptApdrDt" id="stat_date" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>
				<button class="searchBtnType1" id="searchBtn" onclick="return false;">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
			</form>
		</div>
	</div>
	
	<div class="contents">
	
		<form id="formData">
		<input type="hidden" name="aiInptApdrDt" />
		<input type="hidden" name="aiInptCnctScrnNo" id="aiInptCnctScrnNo" />
		<input type="hidden" name="aiInptCnctActiCd" id="aiInptCnctActiCd" />
		<input type="hidden" name="aiInptCnctParmTxt" id="aiInptCnctParmTxt" />
			<div class="flGroup item_2">
				<div class="tbWrap">
					<div class="tbTop">
						<strong>1. 수출입 선적서류 심사</strong>
					</div>
					<div class="tbCon">
						<table class="scrollTb" id="section01">
							<thead>
								<tr>
									<th scope="col" colspan="2">구분</th>
									<th scope="col">수출</th>
									<th scope="col">수입</th>
									<th scope="col">합계</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td rowspan="4">심사완료명세</td>
									<td>전체</td>
									<td id="cell1_1_1"></td>
									<td id="cell1_1_2"></td>
									<td id="cell1_1_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm02}"/></td>
									<td id="cell1_2_1"></td>
									<td id="cell1_2_2"></td>
									<td id="cell1_2_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm03}"/></td>
									<td id="cell1_3_1"></td>
									<td id="cell1_3_2"></td>
									<td id="cell1_3_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm04}"/></td>
									<td id="cell1_4_1"></td>
									<td id="cell1_4_2"></td>
									<td id="cell1_4_3"></td>
								</tr>
								<tr>
									<td rowspan="3">심사오류명세</td>
									<td>전체</td>
									<td id="cell1_5_1"></td>
									<td id="cell1_5_2"></td>
									<td id="cell1_5_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm06}"/></td>
									<td id="cell1_6_1"></td>
									<td id="cell1_6_2"></td>
									<td id="cell1_6_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm07}"/></td>
									<td id="cell1_7_1"></td>
									<td id="cell1_7_2"></td>
									<td id="cell1_7_3"></td>
								</tr>
								<tr>
									<td rowspan="4">경보발생명세</td>
									<td>전체</td>
									<td id="cell1_8_1"></td>
									<td id="cell1_8_2"></td>
									<td id="cell1_8_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm08}"/></td>
									<td id="cell1_9_1"></td>
									<td id="cell1_9_2"></td>
									<td id="cell1_9_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm09}"/></td>
									<td id="cell1_10_1"></td>
									<td id="cell1_10_2"></td>
									<td id="cell1_10_3"></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm10}"/></td>
									<td id="cell1_11_1"></td>
									<td id="cell1_11_2"></td>
									<td id="cell1_11_3"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="tbWrap">
					<div class="tbTop">
						<strong>2. <c:out value="${apdrDsNm02}"/></strong>
					</div>
					<div class="tbCon">
						<table class="table inputTable" id="section02">
							<thead>
								<tr>
									<th scope="col" class="td-text-80">구분</th>
									<th scope="col" class="td-text-40">수출</th>
									<th scope="col" class="td-text-40">수입</th>
									<th scope="col" class="td-text-40">당발</th>
									<th scope="col" class="td-text-40">타발</th>
									<th scope="col" class="td-text-40">기타</th>
									<th scope="col" class="td-text-40">합계</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><c:out value="${apdrItmNm11}"/></td>
									<td id="cell2_1_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_1_1" name="input2_1_1" placeholder=""></td>
									<td id="cell2_1_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_1_2" name="input2_1_2" placeholder=""></td>
									<td id="cell2_1_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_1_3" name="input2_1_3" placeholder=""></td>
									<td id="cell2_1_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_1_4" name="input2_1_4" placeholder=""></td>
									<td id="cell2_1_5" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_1_5" name="input2_1_5" placeholder=""></td>
									<td id="cell2_1_6" class="sum-td"><span class="sumLabel" id="input2_1_6"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm12}"/></td>
									<td id="cell2_2_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_2_1" name="input2_2_1" placeholder=""></td>
									<td id="cell2_2_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_2_2" name="input2_2_2" placeholder=""></td>
									<td id="cell2_2_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_2_3" name="input2_2_3" placeholder=""></td>
									<td id="cell2_2_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_2_4" name="input2_2_4" placeholder=""></td>
									<td id="cell2_2_5" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_2_5" name="input2_2_5" placeholder=""></td>
									<td id="cell2_2_6" class="sum-td"><span class="sumLabel" id="input2_2_6"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm10}"/></td>
									<td id="cell2_3_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_3_1" name="input2_3_1" placeholder=""></td>
									<td id="cell2_3_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_3_2" name="input2_3_2" placeholder=""></td>
									<td id="cell2_3_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_3_3" name="input2_3_3" placeholder=""></td>
									<td id="cell2_3_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_3_4" name="input2_3_4" placeholder=""></td>
									<td id="cell2_3_5" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_3_5" name="input2_3_5" placeholder=""></td>
									<td id="cell2_3_6" class="sum-td"><span class="sumLabel" id="input2_3_6"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm13}"/></td>
									<td id="cell2_4_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_4_1" name="input2_4_1" placeholder=""></td>
									<td id="cell2_4_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_4_2" name="input2_4_2" placeholder=""></td>
									<td id="cell2_4_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_4_3" name="input2_4_3" placeholder=""></td>
									<td id="cell2_4_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_4_4" name="input2_4_4" placeholder=""></td>
									<td id="cell2_4_5" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input2_4_5" name="input2_4_5" placeholder=""></td>
									<td id="cell2_4_6" class="sum-td"><span class="sumLabel" id="input2_4_6"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="tbWrap">
					<div class="tbTop">
						<strong>3. <c:out value="${apdrDsNm03}"/></strong>
					</div>
					<div class="tbCon">
						<table class="scrollTb inputTable" id="section03">
							<thead>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">수신전문</th>
									<th scope="col">발신전문</th>
									<th scope="col">합계</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><c:out value="${apdrItmNm14}"/></td>
									<td id="cell3_1_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_1_1" name="input3_1_1" placeholder=""></td>
									<td id="cell3_1_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_1_2" name="input3_1_2" placeholder=""></td>
									<td id="cell3_1_3" class="sum-td"><span class="sumLabel" id="input3_1_3"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm10}"/></td>
									<td id="cell3_2_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_2_1" name="input3_2_1" placeholder=""></td>
									<td id="cell3_2_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_2_2" name="input3_2_2" placeholder=""></td>
									<td id="cell3_2_3" class="sum-td"><span class="sumLabel" id="input3_2_3"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm13}"/></td>
									<td id="cell3_3_1" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_3_1" name="input3_3_1" placeholder=""></td>
									<td id="cell3_3_2" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input3_3_2" name="input3_3_2" placeholder=""></td>
									<td id="cell3_3_3" class="sum-td"><span class="sumLabel" id="input3_3_3"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="tbWrap">
					<div class="tbTop">
						<strong>4. <c:out value="${apdrDsNm04}"/></strong>
					</div>
					<div class="tbCon">
						<table class="scrollTb inputTable" id="section04">
							<thead>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">수출</th>
									<th scope="col">수입</th>
									<th scope="col">당발</th>
									<th scope="col">타발</th>
									<th scope="col">합계</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><c:out value="${apdrItmNm15}"/></td>
									<td id="cell4_1_1"></td>
									<td id="cell4_1_2"></td>
									<td id="cell4_1_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_1_3" name="input4_1_3" placeholder=""></td>
									<td id="cell4_1_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_1_4" name="input4_1_4" placeholder=""></td>
									<td id="cell4_1_5" class="sum-td"><span class="sumLabel" id="input4_1_5"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm16}"/></td>
									<td id="cell4_2_1"></td>
									<td id="cell4_2_2"></td>
									<td id="cell4_2_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_2_3" name="input4_2_3" placeholder=""></td>
									<td id="cell4_2_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_2_4" name="input4_2_4" placeholder=""></td>
									<td id="cell4_2_5" class="sum-td"><span class="sumLabel" id="input4_2_5"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm10}"/></td>
									<td id="cell4_3_1"></td>
									<td id="cell4_3_2"></td>
									<td id="cell4_3_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_3_3" name="input4_3_3" placeholder=""></td>
									<td id="cell4_3_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_3_4" name="input4_3_4" placeholder=""></td>
									<td id="cell4_3_5" class="sum-td"><span class="sumLabel" id="input4_3_5"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm17}"/></td>
									<td id="cell4_4_1"></td>
									<td id="cell4_4_2"></td>
									<td id="cell4_4_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_4_3" name="input4_4_3" placeholder=""></td>
									<td id="cell4_4_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_4_4" name="input4_4_4" placeholder=""></td>
									<td id="cell4_4_5" class="sum-td"><span class="sumLabel" id="input4_4_5"></span></td>
								</tr>
								<tr>
									<td><c:out value="${apdrItmNm18}"/></td>
									<td id="cell4_5_1"></td>
									<td id="cell4_5_2"></td>
									<td id="cell4_5_3" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_5_3" name="input4_5_3" placeholder=""></td>
									<td id="cell4_5_4" class="numberOnlyInputTd"><input type="text" class="numberOnlyInput" id="input4_5_4" name="input4_5_4" placeholder=""></td>
									<td id="cell4_5_5" class="sum-td"><span class="sumLabel" id="input4_5_5"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="flGroup">
				<div class="txtWrap">
					<div class="txtTop">
						<strong>5. <c:out value="${apdrDsNm05}"/></strong>
					</div>
					<div class="txtCon taskLogRegTxtMargin" id="section05">
						<textarea id="input5_1_1" name="input5_1_1" title=""></textarea>
					</div>
				</div>
			</div>
		</form>
		
	</div>
	
</div>
<p class="footBt">
	<span class="c">
		<a href="javascript:void(0);" class="btType1" id="saveBtn">저장</a>
	</span>
</p>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

var dscdIdx = -1;
var lineIdx = -1;
var inptIdx = -1;
//input 값 편의성 및 값유효성 검증
var originalInputValue = "";

/*
$(document).on('click', '.inputTable .numberOnlyInput', function(e){
	if(originalInputValue != null || originalInputValue != ""){
		originalInputValue = $(this).val();
		$(this).val("");
	}
})*/;
$(function() {
	
	initLoadingDisplay("Y", "class", "container");
	
	//$('#stat_date').val(new Date().getFullYear()+'-'+(new Date().getMonth()+1)+'-'+new Date().getDate());
	initRangeCal();
	fnInitUI();
	
	
	
	$('#searchBtn').click(function(e){
		if(validationSingleEvent()){
			fnSearch();
		}else{
			return;
		}
	});
	
	$('#saveBtn').click(function(e){
		fnSave();
	});
	
	$(":text[readonly]").css({'background-color':'rgb(248, 248, 248)'}).css({'border':'none'});
	$(".sum-td").css({'background-color':'rgb(248, 248, 248)'});
	fnSearch();
	
	$(document).on('focus', '.numberOnlyInput', function(){
		if(originalInputValue != null || originalInputValue != ""){
			originalInputValue = $(this).val();
			$(this).val("");
		}
		
		var IdVal = $(this).attr("id");
		IdVal = IdVal.replace("input", "");
		//input4_3_3
		var dscdIdxTmp = IdVal.split("_")[0];
		var lineIdxTmp = IdVal.split("_")[1];
		var inptIdxTmp = IdVal.split("_")[2];
		
		dscdIdx = dscdIdxTmp;
		lineIdx = lineIdxTmp;
		inptIdx = inptIdxTmp;
		console.log(dscdIdx, lineIdx, inptIdx);
		
		$(".numberOnlyInput").parent().removeClass("taskLogInptActive");
		$(this).parent().addClass("taskLogInptActive");
	});
	$(document).on('blur', '.numberOnlyInput', function(){
		$(this).parent().removeClass("taskLogInptActive");
	});
	$(document).keydown(function(e){
		if((dscdIdx == -1 && lineIdx == -1 && inptIdx == -1)){
			console.log("focus initialization");
		}else if(!(dscdIdx == -1 && lineIdx == -1 && inptIdx == -1)){
			
			// ↑
			if(e.keyCode == "38"){
				var focusingId = "input"+dscdIdx+"_"+(Number(lineIdx)-1)+"_"+inptIdx;
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0 && focusingElement.hasClass("numberOnlyInput")){
					focusingElement.focus();
				}
			}
			// →(X) Enter(O)
			else if(e.keyCode == "13"){
				console.log("focus right");
				//input2_1_5
				//numberOnlyInput
				var focusingId = "input"+dscdIdx+"_"+lineIdx+"_"+(Number(inptIdx)+1);
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0 && focusingElement.hasClass("numberOnlyInput")){
					focusingElement.focus();
				}else{
					var focusingId2 = "input"+dscdIdx+"_"+(Number(lineIdx)+1)+"_1";
					var focusingElement2 = $("#"+focusingId2);
					if(focusingElement2.length != 0 && focusingElement2.hasClass("numberOnlyInput")){
						focusingElement2.focus();
					}else{
						var focusingId3 = "input"+dscdIdx+"_"+(Number(lineIdx)+1)+"_3";
						var focusingElement3 = $("#"+focusingId3);
						if(focusingElement3.length != 0 && focusingElement3.hasClass("numberOnlyInput")){
							focusingElement3.focus();
						}else{
							var focusingId4 = "input"+(Number(dscdIdx)+1)+"_1_1";
							var focusingElement4 = $("#"+focusingId4);
							if(focusingElement4.length != 0 && focusingElement4.hasClass("numberOnlyInput")){
								focusingElement4.focus();
							}else{
								var focusingId5 = "input"+(Number(dscdIdx)+1)+"_1_3";
								var focusingElement5 = $("#"+focusingId5);
								if(focusingElement5.length != 0 && focusingElement5.hasClass("numberOnlyInput")){
									focusingElement5.focus();
								}
							}
						}
					}
				}
			}
			// ↓
			else if(e.keyCode == "40"){
				var focusingId = "input"+dscdIdx+"_"+(Number(lineIdx)+1)+"_"+inptIdx;
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0 && focusingElement.hasClass("numberOnlyInput")){
					focusingElement.focus();
				}
			}
			// ←
			else if(e.keyCode == "37"){
				// None
			}
			
		}
	});
	
	
});




// input값 포커스 잃었을 때
// 1) 숫자입력 체크 -> false 이면 0 으로 초기화 후 포커싱
// 2) 숫자입력 체크 -> true 인데 이전입력값이 없으면서 현재값이 없으면 0 으로 초기화
// 3) 숫자입력 체크 -> true 인데 이전입력값은 있는데 현재값이 없으면 이전값으로 초기화
// 4) 1, 2, 3 번에 걸리지 않으면 입력값 정상 및 합계 로직 수행
$(document).on('blur', '.inputTable .numberOnlyInput', function(e){
	var currValue = $(this).val();
	
	var pattern = /^[0-9]*$/;
	
	if(!pattern.test(currValue)){
		$(this).val(0);
		$(this).focus();
		return;
	}
	
	if(originalInputValue == "" && currValue == ""){
		$(this).val(0);
		return;
	}
	
	if(originalInputValue != "" && currValue == ""){
		$(this).val(originalInputValue);
		return;
	}
	
	var _inputEl = $(this).parents('tr').find(':input');		
	//var _maxIndex = _inputEl.length - 1;
	var _maxIndex = _inputEl.length;
	var _sum = 0;
	
	_inputEl.each(function(idx,obj){
		
		if (_inputEl[idx].value && _maxIndex > idx) {
			_sum += parseInt(_inputEl[idx].value);
		} 
	});
	 //_inputEl[_maxIndex].value = _sum;
	 //console.log(_inputEl[_maxIndex].value);
	 
	 var _resultEl = $(this).parent().parent().find('.sumLabel');
	 console.log("sum: ", _sum);
	 $(_resultEl).text(_sum);
	 console.log($(_resultEl).text());
});

// input 값 validation 부분: 숫자만 입력가능
$(document).on('keydown', '.inputTable :input', function(e){
	var currValue = $(this).val();
		
	var pattern = /^[0-9]*$/;
	
	if(!pattern.test(currValue)){
		$(this).val("");
		$(this).focus();
		return;
	}
});


function fnSearch(){
	//fnInitData();
	s_loading();
	var stat_date = $('#stat_date').val();

	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5020",null,"01",$.param({'schSdate1' : stat_date}));
	
	$.get('/api/task/log/reg?' + $.now(),{'schSdate1' : stat_date},function(data){
		if(data.resultCode=='200'){
			h_loading();
			var list = data.list;
			var list2 = data.list2;
			var list3 = data.list3;
			var list4 = data.list4;
			var list5 = data.list5;
			
			//리스트1
			if(list && list.length){
				for(var i=0;i<list.length;i++){
					var num = i + 1;
					var row = list[i];
					$('#cell1_'+num+'_1').html(row.col1 ? row.col1 : '');
					$('#cell1_'+num+'_2').html(row.col2 ? row.col2 : '');
					$('#cell1_'+num+'_3').html(row.col3 ? row.col3 : '');
				}
			}
			
			
			//리스트2
			console.log("list2 : ");
			if(list2 && list2.length){
				console.log("list2 start :");
				for(var i=0;i<list2.length;i++){
					var num = i + 1;
					var row = list2[i];
					console.log('row.col1 : ' + row.col1);
					console.log(row.col == null ? 'null yes' : 'null no');
					$('#input2_'+num+'_1').val(row.col1 ? row.col1 : '');
					$('#input2_'+num+'_2').val(row.col2 ? row.col2 : '');
					$('#input2_'+num+'_3').val(row.col3 ? row.col3 : '');
					$('#input2_'+num+'_4').val(row.col4 ? row.col4 : '');
					$('#input2_'+num+'_5').val(row.col5 ? row.col5 : '');
					$('#input2_'+num+'_6').text(row.col6 ? row.col6 : '');
				}
			}else{
				for(var i=0;i<4;i++){
					var num = i + 1;
					$('#input2_'+num+'_1').val('0');
					$('#input2_'+num+'_2').val('0');
					$('#input2_'+num+'_3').val('0');
					$('#input2_'+num+'_4').val('0');
					$('#input2_'+num+'_5').val('0');
					$('#input2_'+num+'_6').text('0');	
				}
			}
			
			//리스트3
			if(list3 && list3.length){
				for(var i=0;i<list3.length;i++){
					var num = i + 1;
					var row = list3[i];
					$('#input3_'+num+'_1').val(row.col1 ? row.col1 : '');
					$('#input3_'+num+'_2').val(row.col2 ? row.col2 : '');
					$('#input3_'+num+'_3').text(row.col3 ? row.col3 : '');
				}
			}else{
				for(var i=0;i<3;i++){
					var num = i + 1;
					$('#input3_'+num+'_1').val('0');
					$('#input3_'+num+'_2').val('0');
					$('#input3_'+num+'_3').text('0');
				}
				
			}

			//리스트4
			if(list4 && list4.length){
				for(var i=0;i<list4.length;i++){
					var num = i + 1;
					var row = list4[i];
					$('#cell4_'+num+'_1').html(row.col1 ? row.col1 : '');
					$('#cell4_'+num+'_2').html(row.col2 ? row.col2 : '');
					$('#input4_'+num+'_3').val(row.col3 ? row.col3 : '');
					$('#input4_'+num+'_4').val(row.col4 ? row.col4 : '');
					$('#input4_'+num+'_5').text(row.col5 ? row.col5 : '');
				}
			}else{
				for(var i=0;i<5;i++){
					var num = i + 1;
					$('#cell4_'+num+'_1').html('0');
					$('#cell4_'+num+'_2').html('0');
					$('#input4_'+num+'_3').val('0');
					$('#input4_'+num+'_4').val('0');
					$('#input4_'+num+'_5').text('0');
				}
			}

			//리스트5
			if(list5 && list5.length){
				for(var i=0;i<list5.length;i++){
					var num = i + 1;
					var row = list5[i];
					$('#input5_'+num+'_1').val(row.col1 ? row.col1 : '');
					break;
				}
			}
		} else {
			fnAlertErrorMsg(data);
		}
	});
}
function fnSave(){
	var stat_date = $.trim($('#stat_date').val());
	if(stat_date==""){
		alert('일자를 입력해주세요.');
		$('#stat_date').focus();
		return;
	}
	if(confirm('저장하시겠습니까?')){
		var form = $('#formData');
		form.find('[name="aiInptApdrDt"]').val($('#stat_date').val());
		form.find('[name="aiInptCnctScrnNo"]').val("5020");
		form.find('[name="aiInptCnctActiCd"]').val("04");
		form.find('[name="aiInptCnctParmTxt"]').val(form.serialize());
		//프로그램 사용 이력 로그누적
		//fnCmnProgramLog("5020",null,"04",$.param({aiInptApdrDt:$('#stat_date').val()}));
		
		$.post('/api/task/log/reg',form.serialize(),function(data){
			if(data.resultCode=='200'){
				alert('정상적으로 처리되었습니다.');
				fnSearch();
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}
}
function fnInitUI(){
	
	/*
	$('.daterange-basic').daterangepicker({
		singleDatePicker: true,
		locale: {
			format: 'YYYY-MM-DD'
		}
	});*/
	
	$('#section01 td[id^="cell"]').css({'text-align':'right'});
	$('#section02 td[id^="cell"]').find(':text').css({'text-align':'right'});
	$('#section03 td[id^="cell"]').find(':text').css({'text-align':'right'});
	$('#section04 td[id^="cell"]').css({'text-align':'right'});
	$('#section04 td[id^="cell"]').find(':text').css({'text-align':'right'});
	
}
//출력/입력항목들 초기화.
function fnInitData(){
	//섹션1 초기화
	for(var rowIdx=1;rowIdx<=11;rowIdx++){
		for(var colIdx=1;colIdx<=3;colIdx++){
			$('#cell1_'+rowIdx+'_'+colIdx).html('');
		}
	}
	//섹션2 초기화
	for(var rowIdx=1;rowIdx<=4;rowIdx++){
		for(var colIdx=1;colIdx<=5;colIdx++){
			$('#input2_'+rowIdx+'_'+colIdx).val('');
		}
	}
	//섹션3 초기화
	for(var rowIdx=1;rowIdx<=3;rowIdx++){
		for(var colIdx=1;colIdx<=3;colIdx++){
			$('#input3_'+rowIdx+'_'+colIdx).val('');
		}
	}
	//섹션4 초기화
	for(var rowIdx=1;rowIdx<=5;rowIdx++){
		for(var colIdx=1;colIdx<=5;colIdx++){
			if(colIdx==1 || colIdx==2 || colIdx==5){
				$('#cell4_'+rowIdx+'_'+colIdx).html('');
			} else {				
				$('#input4_'+rowIdx+'_'+colIdx).val('');
			}
		}
	}
	//섹션5 초기화
	$('#input5_1_1').val('');
}
</script>