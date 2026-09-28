<%@page import="egovframework.ui.cmmn.PropUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/loading.jsp"%>



<c:set var="pageId" value="5010"/>
<div class="container">
	<h2 class="title">
		<strong>업무마감 [5010]</strong>
		<span class="revertStatPageDiscription">일별 업무마감 정보를 조회하고 저장하는 화면</span>
		<span class="location">
			<span>업무일지</span>
			<span>업무마감</span>
		</span>
	</h2>
	
	<div class="searchWrap">
		<div class="searchToggle">
			<button type="button" class="schToggle">검색</button>
			<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
		</div>
		<div class="searchBox">
			<form class="form-horizontal" id="formSearch_<c:out value="${pageId}"/>" onsubmit="return false;">
				<input type="hidden" name="aiInptCnctScrnNo" id="aiInptCnctScrnNo" value="" />
				<input type="hidden" name="aiInptCnctActiCd" id="aiInptCnctActiCd" value="" />
				<input type="hidden" name="aiInptCnctParmTxt" id="aiInptCnctParmTxt" value="" />
				<p class="w36">
					<label for="aiInptClsDt" class="label">업무생성일</label>
					<input type="text" class="cal daterange-basic calSingle" name="aiInptClsDt" id="aiInptClsDt" pageid="<c:out value="${pageId}"/>" placeholder="기간 검색">
				</p>
				<button type="button" class="searchBtnType1" id="searchBtn">
					<i class="fa fa-search searchBtn"></i>
					조회
				</button>
				<input type="hidden" name="inptTaskId" id="isRetry" value="0" />
			</form>
		</div>
	</div>
	<div class="contents">
		<div class="btBox">
			<span class="r">
				<button type="button" class="reportPrintBtn" onclick="fnReport('1100', '700');">
					<i class="icons font-2xl d-block mt-5 cui-print printIcon"></i>
					레포트출력
				</button>
			</span>
		</div>
		<div class="flGroup item_3">
			<form class="form-horizontal" id="formSave" onsubmit="return false;">
			<input type="hidden" name="aiInptClsDt" />
			<input type="hidden" name="aiInptCnctScrnNo" id="aiInptCnctScrnNo" value="" />
			<input type="hidden" name="aiInptCnctActiCd" id="aiInptCnctActiCd" value="" />
			<input type="hidden" name="aiInptCnctParmTxt" id="aiInptCnctParmTxt" value="" />
			<c:forEach var="gitem" items="${taskEndGbnCd }" varStatus="status">
				<c:if test="${gitem.aiInptCmnCd eq '01' or gitem.aiInptCmnCd eq '02' or gitem.aiInptCmnCd eq '03'}">
					<div class="tbWrap">
						<div class="tbTop">
							<strong><c:out value="${gitem.aiInptCmnCdNm}"/></strong>
						</div>
						<div class="tbCon">
							<table class="table" id="statTable<c:out value="${status.count}"/>">
								<thead>
									<tr>
										<th scope="col" class="td-text-60">구분</th>
										<th scope="col" class="td-text-40">건수</th>
										<th scope="col" class="td-text-80">비고</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="inpt_numbering_top" value="0" />
									<c:forEach var="item" items="${taskEndItmCd }">
										<c:if test="${item.aiInptCmnCd ne '11' and item.aiInptCmnCd ne '12' and item.aiInptCmnCd ne '06'}">
											<c:set var="inpt_numbering_top" value="${inpt_numbering_top + 1 }" />
											<tr class="rowcolumn">
												<td class="text-left">
													<c:if test="${item.aiInptCmnCd ne '01' and item.aiInptCmnCd ne '02' and item.aiInptCmnCd ne '07'}"></c:if>
													<c:out value="${item.aiInptCmnCdNm}"/>
												</td>
												<td class="text-right"></td>
												<td class="memo_inpt_td">
													<input class="width-100 inptKeyMove" id="focusIdx<c:out value="${status.count}"/>_<c:out value="${inpt_numbering_top}"/>" value="" type="text" name="stat<c:out value="${status.count}"/>Memos" placeholder=""/>
												</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</c:if>
				<c:if test="${gitem.aiInptCmnCd eq '04' or gitem.aiInptCmnCd eq '05' or gitem.aiInptCmnCd eq '06'}">
					<div class="tbWrap">
						<div class="tbTop">
							<strong><c:out value="${gitem.aiInptCmnCdNm}"/></strong>
						</div>
						<div class="tbCon">
							<table class="table" id="statTable<c:out value="${status.count}"/>">
								<thead>
									<tr>
										<th scope="col" class="td-text-60">구분</th>
										<th scope="col" class="td-text-40">건수</th>
										<th scope="col" class="td-text-80">비고</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="inpt_numbering" value="0" />
									<c:forEach var="item" items="${taskEndItmCd }">
										<c:if test="${item.aiInptCmnCd eq '01' or item.aiInptCmnCd eq '11' or item.aiInptCmnCd eq '12'}">
											<c:set var="inpt_numbering" value="${inpt_numbering + 1 }" />
											<tr class="rowcolumn">
												<td class="text-left">
													<c:if test="${item.aiInptCmnCd ne '01'}"></c:if>
													<c:out value="${item.aiInptCmnCdNm}"/>
												</td>
												<td class="text-right"></td>
												<td>
													<input class="width-100 inptKeyMove" id="focusIdx<c:out value="${status.count}"/>_<c:out value="${inpt_numbering}"/>" value="" type="text" name="stat<c:out value="${status.count}"/>Memos" placeholder=""/>
												</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</c:if>
			</c:forEach>
			</form>
		</div>
		
	</div>
	
</div>
<p class="footBt">
	<span class="c">
		<button class="retryLogEndBtn" id="retryLogEndBtn" onclick="fnReLogEnd();">재마감</button>
		<a href="javascript:void(0);" class="btType1" onclick="fnSave();">저장</a>
	</span>
</p>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>

<form id="formReport" action='/birt/frameset' method='POST' target='winReport'>
<input TYPE='hidden' name='__report' value='report/task_log_end_report.rptdesign'><br>
<input TYPE='hidden' name='aiInptClsDt' value='2019-09-12'><br>
</form>

<script>

var dscdIdx = -1;
var inptIdx = -1;

function fnReLogEnd(){
	if(confirm("재마감 하시겠습니까?")){
		$('#isRetry').val('1');
		
		//프로그램 사용 이력 로그누적
		fnCmnProgramLog("5010",null,"30","schSdate1="+$('#aiInptClsDt').val());
		
		fnSearch();
		
		alert("재마감 처리 되었습니다");
	}else{
		$('#isRetry').val('0');
	}
	$('#isRetry').val('0');
	
}

$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	initRangeCal();
	
	//$('#aiInptClsDt').val(formatYMD(getToDay()));
	
	var todayString = new Date().getFullYear() + '-' + (new Date().getMonth()+1 >= 10 ? new Date().getMonth()+1 : '0' + (new Date().getMonth()+1)) + '-' + (new Date().getDate() >= 10 ? new Date().getDate() : '0' + new Date().getDate());
	if($('#aiInptClsDt').val() == todayString){
		$('#retryLogEndBtn').attr('disabled', true); //.css({"background":"#b1b1b1"});
		$('#retryLogEndBtn').addClass('retryLogEndBtnDisabled');
		$('#retryLogEndBtn').removeClass('retryLogEndBtn');
	}else{
		$('#retryLogEndBtn').attr('disabled', false); //.css({"background":"#05718b"});
		$('#retryLogEndBtn').removeClass('retryLogEndBtnDisabled');
		$('#retryLogEndBtn').addClass('retryLogEndBtn');
	}
	
	$('#searchBtn').click(function(e){
		if(validationSingleEvent()){
			fnSearch();
		}else{
			return;
		}
	});
	
	
	fnSearch();
	
	//$('#formSave').find(':text').css({'text-align':'left'}).css({'font-size':'12px'});
	
	$(document).on('focus', '.inptKeyMove', function(){
		var IdVal = $(this).attr("id");
		IdVal = IdVal.replace("focusIdx", "");
		var dscdIdxTmp = IdVal.split("_")[0];
		var inptIdxTmp = IdVal.split("_")[1];
		
		dscdIdx = dscdIdxTmp;
		inptIdx = inptIdxTmp;
		console.log(dscdIdx, inptIdx);
		
		//var parentTdElement = 
		
		$(".inptKeyMove").parent().removeClass("taskLogInptActive");
		$(this).parent().addClass("taskLogInptActive");
	});
	$(document).on('blur', '.inptKeyMove', function(){
		$(this).parent().removeClass("taskLogInptActive");
	});
	$(document).keydown(function(e){
		//focusIdx2_1
		//focusIdx[0]_[1]
		if((dscdIdx == -1 && inptIdx == -1)){
			console.log("focus initialization");
		}else if(!(dscdIdx == -1 && inptIdx == -1)){
			// 
			// ↑
			if(e.keyCode == "38") {
				console.log("focus up");
				var focusingId = "focusIdx"+dscdIdx+"_"+(Number(inptIdx)-1);
				console.log("focus down focusingId: ", focusingId);
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0){
					focusingElement.focus();
				}else if(focusingElement.length == 0){
					var focusingId2 = "focusIdx"+(Number(dscdIdx)-1)+"_10";
					var focusingElement2 = $("#"+focusingId2);
					if(focusingElement2.length != 0){
						focusingElement2.focus();
					}else if(focusingElement2.length == 0){
						var focusingId3 = "focusIdx"+(Number(dscdIdx)-1)+"_3";
						var focusingElement3 = $("#"+focusingId3);
						if(focusingElement3.length != 0){
							focusingElement3.focus();
						}
					}
				}
			}
			// →
			else if(e.keyCode == "39") {
				/*
				console.log("focus right");
				var focusingId = "focusIdx"+(Number(dscdIdx)+1)+"_"+inptIdx;
				console.log("focus down focusingId: ", focusingId);
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0){
					focusingElement.focus();
				}else if(focusingElement.length == 0){
					var focusingId2 = "focusIdx"+(Number(dscdIdx)+1)+"_1";
					var focusingElement2 = $("#"+focusingId2);
					if(focusingElement2 != 0){
						focusingElement2.focus();
					}
				}*/
			}
			// ↓
			else if(e.keyCode == "40" || e.keyCode == "13") {
				console.log("focus down");
				var focusingId = "focusIdx"+dscdIdx+"_"+(Number(inptIdx)+1);
				console.log("focus down focusingId: ", focusingId);
				var focusingElement = $("#"+focusingId);
				
				if(focusingElement.length != 0){
					focusingElement.focus();
				}else if(focusingElement.length == 0){
					var focusingId2 = "focusIdx"+(Number(dscdIdx)+1)+"_1";
					var focusingElement2 = $("#"+focusingId2);
					if(focusingElement2 != 0){
						focusingElement2.focus();
					}
				}
			}
			// ←
			else if(e.keyCode == "37") {
				/*
				console.log("focus left");
				var focusingId = "focusIdx"+(Number(dscdIdx)-1)+"_"+inptIdx;
				console.log("focus down focusingId: ", focusingId);
				var focusingElement = $("#"+focusingId);
				if(focusingElement.length != 0){
					focusingElement.focus();
				}*/
			}
		}
		
	});		
	
});
function fnSearch(){
	s_loading();
	var form = $("#formSearch_<c:out value="${pageId}"/>");
	
	var calElementValue = $('#aiInptClsDt').val();
	var calElementYear = calElementValue.substr(0, 4);
	var calElementMonth = calElementValue.substr(5, 2);
	var calElementDay = calElementValue.substr(8, 4);
	var calElementValueConvt = calElementYear + calElementMonth + calElementDay;
	var todayString = new Date().getFullYear() + "" + (new Date().getMonth()+1 >= 10 ? new Date().getMonth()+1 : '0' + (new Date().getMonth()+1)) + (new Date().getDate() >= 10 ? new Date().getDate() : '0' + new Date().getDate());

	if(calElementValueConvt >= todayString){ // 
		$('#retryLogEndBtn').attr('disabled', true); //.css({"background":"#b1b1b1"});
		$('#retryLogEndBtn').addClass('retryLogEndBtnDisabled');
		$('#retryLogEndBtn').removeClass('retryLogEndBtn');
		
	}else if(calElementValueConvt < todayString){
		$('#retryLogEndBtn').attr('disabled', false); //.css({"background":"#05718b"});
		$('#retryLogEndBtn').removeClass('retryLogEndBtnDisabled');
		$('#retryLogEndBtn').addClass('retryLogEndBtn');
	}
	
	$('#aiInptCnctParmTxt').val(form.serialize());
	$('#aiInptCnctScrnNo').val("5010");
	$('#aiInptCnctActiCd').val("01");
	
	//프로그램 사용 이력 로그누적
	//fnCmnProgramLog("5010",null,"01",form.serialize());
	$.get('/api/task/log/end?' + $.now(),form.serialize(),function(data){
		h_loading();
		var lists = [];
		lists.push(data.resultList);
		lists.push(data.result2List);
		lists.push(data.result3List);
		lists.push(data.result4List);
		lists.push(data.result5List);
		lists.push(data.result6List);
		
		console.log(data.resultList)
		
		$(lists).each(function(idx,list){
			var table = $("#statTable"+(idx+1));
			var trs = table.find("tr.rowcolumn");
			var inputs = table.find(":text");
			var row = list[0];
			var cols = ['','','','','','','','','','',''];
			var memos = ['','','','','','','','','','',''];
			
			if(row){
				if(idx==0){
					cols = [row.col1,row.col2,row.col3,row.col4,row.col5/*,row.col6*/,row.col11,row.col7,row.col8,row.col9,row.col10];
					memos = [row.memo1,row.memo2,row.memo3,row.memo4,row.memo5,row.memo6,row.memo11,row.memo7,row.memo8,row.memo9,row.memo10];
				} else {
					cols = [row.col1,row.col2,row.col3,row.col4,row.col5/*,row.col6*/,row.col11,row.col7,row.col8,row.col9,row.col10];
					memos = [row.memo1,row.memo2,row.memo3,row.memo4,row.memo5,row.memo6,row.memo11,row.memo7,row.memo8,row.memo9,row.memo10];
				}
			}
			
			//카운트 숫자 출력
			$(trs).each(function(idx2,tr){
				var tds = $(tr).find('td');
				var cnt = cols[idx2];
				tds.eq(1).html(cnt);
			});
			
			//메모 입력박스 설정
			$(inputs).each(function(idx2,item){
				var memo = memos[idx2] ? memos[idx2] : "";
				$(item).val(memo);
			});
		});
	});
}
function fnSave(){
	if(confirm("저장하시겠습니까?")){
		
		var _text = "";
		var _textSize = 0;
		var _checkflag = true;
		
		//비고 30자 제한
		$('#formSave').find(':text').each(function(idx,obj){
			
			_text = $('#formSave').find(':text').get()[idx].value;
			_textSize = _text.length;
			if (_textSize > 30) {
				alert("비고는 30자 미만으로 입력해주세요.");
				_checkflag = false;
			}
		}).promise().done(function(){
			
			if (_checkflag) {
				var form = $("#formSave");
				form.find('[name="aiInptClsDt"]').val($('#aiInptClsDt').val());
				
				//프로그램 사용 이력 로그누적
				//fnCmnProgramLog("5010",null,"04",$.param({aiInptClsDt:$('#aiInptClsDt').val()}));
				form.find('[name="aiInptCnctScrnNo"]').val("5010");
				form.find('[name="aiInptCnctActiCd"]').val("04");
				form.find('[name="aiInptCnctParmTxt"]').val(form.serialize());
				
				$.post('/api/task/log/end',form.serialize(),function(data){
					if(data.resultCode=="200"){
						alert('정상적으로 처리되었습니다.');
						fnSearch();
					} else {
						fnAlertErrorMsg(data);
					}
				});
			}
		})
	}
}

function fnReport(displayW, displayH){
	var formReport = $('#formReport')[0];
	formReport.aiInptClsDt.value = $('#aiInptClsDt').val();
	
	//프로그램 사용 이력 로그누적
	fnCmnProgramLog("5010",null,"03",$(formReport).serialize());
	
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = displayW;
	var popupSizeH = displayH;
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
	var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
	
	
	window.open('about:blank','winReport','left='+resultLeft+', top='+resultTop+', width='+popupSizeW+', height='+popupSizeH);
	formReport.submit();
}
</script>