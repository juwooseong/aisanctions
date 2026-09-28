<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<c:set var="pageId" value="8010"/>
<c:set var="admBsnTbId" value="admBsnTbId_${pageId}"/>


<div class="container">
	<h2 class="title">
		<strong>영업일 관리 [8030]</strong>
		<span class="revertStatPageDiscription">시스템에서 사용하는 영업일 관리하는 화면</span>
		<span class="location">
			<span>관리자 메뉴</span>
			<span>영업일 관리</span>
		</span>
	</h2>
	
	<div class="contents">
		<div class="flGroup item_1">
			<div class="tbWrap">
				<div class="tbCon">
					<button type="button" class="btType2 gridRightTopBtn" id="saveBtn" onclick="businessDaySetToday();"style="top: 5px;right: 20px;">오늘</button>
					<div style="display: inline-block;margin-bottom: 10px;">
						<span style="font-size: 13px;">기준년도</span>
						<select class="inpt_hldyOption" name="schGbn" id="cbo_hldyYear" style="width: 80px;height: 25px;">
							<c:forEach var="yearCount" begin="${minYear }" end="${maxYear }" step="1">
								<option value="${yearCount }">${yearCount }</option>
							</c:forEach>
						</select>
					</div>
					<div style="display: inline-block;margin-left: 10px;">
						<span style="font-size: 13px;">기준월</span>
						<select class="inpt_hldyOption" name="schGbn" id="cbo_hldyMonth" style="width: 80px;height: 25px;">
							<option value="01">1월</option>
							<option value="02">2월</option> 
							<option value="03">3월</option>
							<option value="04">4월</option>
							<option value="05">5월</option>
							<option value="06">6월</option>
							<option value="07">7월</option>
							<option value="08">8월</option>
							<option value="09">9월</option>
							<option value="10">10월</option>
							<option value="11">11월</option>
							<option value="12">12월</option>
						</select>
					</div>
					<table class="table table-responsive-sm scrollTb" id="<c:out value="${admBsnTbId}"/>"></table>
				</div>
				<button type="button" class="btType1" id="saveBtn" onclick="businessDaySave();" style="float: right;margin-top: 10px;margin-right: 20px;">저장</button>
			</div>
		</div>
	</div>
</div>

<form id="formBnsDyParams" style="position: absolute;opacity: 1;"></form>

<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/daterangepicker.js"></script>
<script type="text/javascript" src="${ctx_res}/vendors/pickers/anytime.min.js"></script>
<script>

var <c:out value="${admBsnTbId}"/>_selectCallback = function(e, dt, type, index, row){
	//상세정보 설정
	//fnSetDetail(row);
	<c:out value="${admBsnTbId}"/>.deselectItem(index);
};




function fnSetDetail(row){
	if(row){
		// 달력
		$(".adminBsnCal").val(dataFormat(row.basDt));
		// 요일
		weekDaySetting();
		// 휴일구분 
		$("#cbo_hldyDscd").val(row.hldyDscd);
		// 비고
		$("#inpt_hldyTxt").val(row.hldyTxt);
	} 
}

var <c:out value="${admBsnTbId}"/>Config = {
		ajaxUrl : '/api/admin/businessday/list',
		columnDefs: [
			{ targets: 0, className: 'td-text-center td-text-40 no-sorting-datatable', orderable: false , render: function(data, type, row, meta){return dataFormat(data);}},
			{ targets: 1, className: 'td-text-center td-text-40', orderable: false , render: function(data, type, row, meta){
				var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
				return week[data];
			}},
			{ targets: 2, className: 'td-text-left td-text-40', orderable: false , render: function(data, type, row, meta){
				var hldyDscdArr = new Array('영업일', '국경일', '기념일', '임시공휴일', '토요일', '일요일', '대체공휴일');
				
				if(data != "0"){
					return "<span style='color:red;'>" + hldyDscdArr[data] + "</span>";
				}else{
					return hldyDscdArr[data];	
				}
				
			}},
			{ targets: 3, className: 'td-text-left td-text-40', orderable: false }
		],
		columns : [
			{ data: "basDt", title: '일자' },
			{ data: "wkdCd", title: '요일' },
			{ data: "hldyDscd", title: '휴일구분' },
			{ data: "hldyTxt", title: '비고' }
	    ],
	    //검색정의
	    getSearchOption : function() {
			var options = {};
			var filters = [];
			
			options.hldyYear = $("#cbo_hldyYear").val();
			options.hldyMonth = $("#cbo_hldyMonth").val();
			/* if($("#schUserAuth<c:out value="${pageId}"/>").val()){
				options.schAuth = $("#schUserAuth<c:out value="${pageId}"/>").val();
			} */

			//프로그램 사용 이력 로그누적
			fnCmnProgramLog("8030",null,"01",$.param(options));

			return options;
		},
		fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
			
			$('.dataTables_info').remove();
			
			//var testTableObject = <c:out value="${admBsnTbId}"/>;
			//testTableObject.selectOneListTableRow(1);
			$(nRow).find('td').eq(2).css('padding', '0');
			
			if(aData['wkdCd'] == '0' || aData['wkdCd'] == '6'){
				$(nRow).find('td').eq(2).html('<select name="bnsSelect" class="bnsSelect" id="bnsSelect'+iDisplayIndex+'" style="width: 100%;height: 100%;border: none;">' +
					       '<option value="0">영업일</option><option value="1">국경일</option>' +
					       '<option value="2">기념일</option>' +
					       '<option value="3">임시공휴일</option>' +
					       '<option value="4">토요일</option>' +
					       '<option value="5">일요일</option>' +
					       '<option value="6">대체공휴일</option>' +
					  '</select>');
			}else{
				$(nRow).find('td').eq(2).html('<select name="bnsSelect" class="bnsSelect" id="bnsSelect'+iDisplayIndex+'" style="width: 100%;height: 100%;border: none;">' +
					       '<option value="0">영업일</option><option value="1">국경일</option>' +
					       '<option value="2">기념일</option>' +
					       '<option value="3">임시공휴일</option>' +
					       '<option value="6">대체공휴일</option>' +
					  '</select>');
			}
			
			
			$(nRow).find('td').eq(3).css('padding', '0');
			$(nRow).find('td').eq(3).html('<input type="text" class="bnsTxt" id="bnsTxt'+iDisplayIndex+'" style="height: 100%;border: none;padding-left: 10px;" />');
			
			if(aData['hldyDscd'] != '0'){
				var selectObj = $(nRow).find('td').eq(2).find('.bnsSelect');
				$(selectObj).val(aData['hldyDscd']);
				$(selectObj).css('color', 'red');
			}
			
			var txtObj = $(nRow).find('td').eq(3).find('.bnsTxt');
			$(txtObj).val(aData['hldyTxt']);
			
		}
	};
function searchTableReload(){
	<c:out value="${admBsnTbId}"/>.searchList();
}

function searchOptionInitialization(){
	var currYear = new Date().getFullYear();
	var currMonth = new Date().getMonth() + 1;
	
	currMonth = currMonth >= 10 ? currMonth : '0' + currMonth;
	
	$("#cbo_hldyYear").val(currYear);
	$("#cbo_hldyMonth").val(currMonth);
}


function weekDaySetting(){
	var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
	var weekDay = new Date($('.adminBsnCal').val()).getDay();
	var weekDayLabel = week[weekDay];
	
	$('#cbo_wkdCd').val(weekDay);
}

$(function(){
	
	initLoadingDisplay("Y", "class", "container");
	
	searchOptionInitialization();
	weekDaySetting();
	
	$(document).on('change','.inpt_hldyOption', function() {
		searchTableReload();
	});
	
	$(document).on('change', '.adminBsnCal', function(){
		weekDaySetting();
	});
	
	$(document).on('change', '.bnsSelect', function(){
		if($(this).val() == '0'){
			$(this).css('color', 'black');
		}else{
			$(this).css('color', 'red');
		}
		
		$(this).parent().parent().find('td:eq(0)').css('font-weight', 'bold')
		$(this).parent().parent().find('td:eq(1)').css('font-weight', 'bold')
	});
	
	$(document).on('change', '.bnsTxt', function(){
		$(this).parent().parent().find('td:eq(0)').css('font-weight', 'bold')
		$(this).parent().parent().find('td:eq(1)').css('font-weight', 'bold')
	})
});

function businessYearSet(){
	//var todayYear = new Date
}

function businessDaySetToday(){
	var todayYear = new Date().getFullYear();
	var todayMonth = new Date().getMonth() + 1;
	
	todayMonth = todayMonth >= 10 ? todayMonth : '0' + todayMonth;
	
	$("#cbo_hldyYear").val(todayYear);
	$("#cbo_hldyMonth").val(todayMonth);
	
	searchTableReload();
}

function businessDaySave(){
	console.log("test444");
	var f = $('#formBnsDyParams');
	var params_tmp = [];
	var params = [];
	
	var selRows = <c:out value="${admBsnTbId}"/>.getAllListTableRow();
	
	for(var index = 0 ; index < selRows[0].length ; index++){
		var row = selRows.rows(index).data();
		var hldyDscdVal = $("#bnsSelect"+index).val();
		var bnsTxtVal = $("#bnsTxt"+index).val();
		params_tmp.push({n:'basDts', v:row[0].basDt});
		params_tmp.push({n:'wkdCds', v:row[0].wkdCd});
		params_tmp.push({n:'hldyDscds', v:hldyDscdVal});
		params_tmp.push({n:'hldyTxts', v:bnsTxtVal});
	}
	fnCmnSetFormParams($('#formBnsDyParams'), params_tmp); 
	
	for(var index = 0 ; index < selRows[0].length ; index++){
		var row = selRows.rows(index).data();
		var hldyDscdVal = $("#bnsSelect"+index).val();
		var bnsTxtVal = $("#bnsTxt"+index).val();
		params.push({n:'basDts', v:row[0].basDt});
		params.push({n:'wkdCds', v:row[0].wkdCd});
		params.push({n:'hldyDscds', v:hldyDscdVal});
		params.push({n:'hldyTxts', v:bnsTxtVal});
	}
	params.push({n:'aiInptCnctScrnNo', v:"8030"});
	params.push({n:'aiInptCnctActiCd', v:"04"});
	params.push({n:'aiInptCnctParmTxt', v:$('#formBnsDyParams').serialize()});
	
	fnCmnSetFormParams($('#formBnsDyParams'), params); 
	
	console.log($('#formBnsDyParams').serialize());
	
	if(confirm("휴일정보를 저장하시겠습니까?")){
		$.post('/api/admin/businessday/save', $('#formBnsDyParams').serialize(), function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				searchTableReload();	
			}
		});
	}
	
	
}

function businessDayMod(){
	
	/*
	var selRows = <c:out value="${admBsnTbId}"/>.getSelRows();
	if(selRows.length == 0){
		alert("결재취소 할 건을 선택해주세요.");
		return;
	}*/
	var businessDate = $(".adminBsnCal").val();
	//businessDate = businessDate.replaceAll("-", "");
	businessDate = fnReplaceDateDash(businessDate, "-", "");
	var holyDayCd = $("#cbo_hldyDscd").val();
	var holyDayTxt = $("#inpt_hldyTxt").val();
	
	console.log("param date: ", businessDate);
	console.log("param holyDayCd: ", holyDayCd);
	console.log("param holyDayTxt: ", holyDayTxt);
	
	if(confirm("휴일정보를 저장 하시겠습니까?")){
		var param_tmp = {
				basDt : businessDate,
				wkdCd : holyDayCd,
				hldyTxt : holyDayTxt
				
			};
		

		$.post('/api/admin/businessday/save', param, function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				searchTableReload();	
			}
			
			/*
			if(callbackFunc){
				callbackFunc(data);
			}*/
		});
	}
}

function businessDayDel(){
	/*
	var selRows = <c:out value="${admBsnTbId}"/>.getSelRows();
	if(selRows.length == 0){
		alert("결재취소 할 건을 선택해주세요.");
		return;
	}*/
	var businessDate = $(".adminBsnCal").val();
	//businessDate = businessDate.replaceAll("-", "");
	businessDate = fnReplaceDateDash(businessDate, "-", "");
	var holyDayCd = $("#cbo_hldyDscd").val();
	var holyDayTxt = $("#inpt_hldyTxt").val();
	
	console.log("param date: ", businessDate);
	console.log("param holyDayCd: ", holyDayCd);
	console.log("param holyDayTxt: ", holyDayTxt);
	
	if(confirm("휴일정보를 삭제 하시겠습니까?")){
		var param = {
				basDt : businessDate,
				wkdCd : holyDayCd,
				hldyTxt : holyDayTxt
			};

		$.post('/api/admin/businessday/delete', param, function(data){
			if(data.rst == 'success'){
				alert('정상적으로 처리되었습니다.');
				searchTableReload();	
			}
			
			/*
			if(callbackFunc){
				callbackFunc(data);
			}*/
		});
	}
}

function fnReplaceDateDash(str, schStr, rpcStr){
	return str.split(schStr).join(rpcStr);
}
</script>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${admBsnTbId}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="numColYN" value="false" />
	<jsp:param name="select" value="single" />
	<jsp:param name="gridOptionPaging" value="false" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="100%" />
	<jsp:param name="gridOptionScrollY" value="580" />
	<jsp:param name="gridRowCallback" value="Y" />
</jsp:include>

