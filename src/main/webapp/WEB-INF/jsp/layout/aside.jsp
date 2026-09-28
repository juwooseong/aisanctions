<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<style>
/* 
#sub_menu_zone {
scrollbar-base-color: #fff;
scrollbar-face-color: red;
scrollbar-3dlight-color: #fff;
scrollbar-highlight-color: #fff;
scrollbar-track-color: #fff;
scrollbar-arrow-color: #fff;
scrollbar-shadow-color: #fff;
scrollbar-dark-shadow-color: #fff;
}*/
/*스크롤 작업 전까지만*/
.leftWrap .lnbWrap ul li{
	padding: 0px !important;
}
.sanction-p{
	margin: 0px !important;
}
.asideTd{
	color: black;
    padding-left: 5px;
    padding-top: 5px;
    padding-bottom: 5px;
    width: 53%;
}
.asideStatusWrapper{
    background-color: #fff;
    position: absolute;
    bottom: 70px;
    padding: 0;
    margin: 0;
    width: 100%;
}
.asideStatusTitle{
    display: inline-block;
    box-sizing: border-box;
    font-size: 13px;
    height: 15px;
    line-height: 15px;
    margin-left: 5px;
}
.asideStatusTable{
    width: 100%;
    border-collapse: collapse;
    box-sizing: border-box;
    border: 1px solid #e2e2e2;
    font-size: 11px;
    background-color: #fcfde8;
}
.asideRed{
	color: red;
}
.asideYellow{
	color: orange;
}
.asideGreen{
	color: green;
}
.asideAutoFalse{
}
.autoAsideIconTrue::before{
    color: #05718b;
}
.autoAsideIconFalse::before{
	color: #383838;
}
.autoAsideRefreshBtn{
    box-sizing: border-box;
    margin-left: 65px;
    line-height: 15px;
    font-size: 12px;
    cursor: pointer;
    float: right;
}
.manualFileDownIcon::before{
   	font-size: 18px;
    color: #20a8d8;
}
</style>
<div class="leftWrap">
	<h1>
		<img class="logo-img" src="${ctx_res}/img/logo.png" alt=""/>
	</h1>
	<div class="lnbWrap">
		<span id="asideFoldBtn" class="openAside">
			<i class="fa fa-angle-double-left fa-lg mt-4 foldIcon" style="display: block;"></i>
		</span>
		<h2 id="menu_title"></h2>
		<%--<ul id="sub_menu_zone" style="height: 550px; overflow-y: scroll;"></ul> --%>
		<ul id="sub_menu_zone"></ul>
	</div>
	
	<div class="asideStatusWrapper">
	    <span class="asideStatusTitleWrapper" style="
    display: block;
    margin-left: 10px;
    margin-bottom: 5px;
">
	    <span style="
    text-align: center;
    width: 15px;
    height: 15px;
    display: inline-block;
    line-height: 15px;
    font-size: 14px;
    background-color: orange;
    color: white;
    border-radius: 30px;
    font-weight: 800;
">!</span><span class="asideStatusTitle">당일심사현황

	    <span class="autoAsideRefreshBtn intervalON" id="autoAsideRefreshBtn">
				<i class="fa fa-refresh mt-4 autoAsideRefreshIcon autoAsideIconTrue fa-spin"style="animation: fa-spin 3s infinite linear;"></i>
			</span>
	    </span> 
    </span>
	    <table class="asideStatusTable">
	        <tr>
	            <td class="asideTd">업무미생성</td>
	            <td class="asideTd">
				    <span class="asideRed" id="nonCrCnt">-</span>
				</td>
	        </tr>
	        <tr>
	            <td class="asideTd">스캔건수</td>
	            <td class="asideTd">
	            	<span class="" id="scanCnt">-</span>
	            </td>
	        </tr>
	        <tr>
	            <td class="asideTd">AI(정상/지연/오류)</td>
	            <td class="asideTd">
	            	<span class="asideGreen" id="normalCnt">-</span> / 
				    <span class="asideYellow" id="delayCnt">-</span> / 
				    <span class="asideRed" id="errCnt">-</span>
	            </td>
	        </tr>
	        <tr>
	            <td class="asideTd">심사/결재/완료</td>
	            <td class="asideTd">
				    <span class="" id="inspCnt">-</span> / 
				    <span class="" id="apprCnt">-</span> / 
				    <span class="" id="cmplCnt">-</span>
				</td>
	        </tr>
	    </table>
	    
	    <span id="updateMoment" style="
    display: block;
    text-align: right;
    font-size: 11px;
    margin-top: 5px;
    color: #565656;
    margin-right: 5px;
">17:14:50 기준</span>
	</div>
	
	<div class="manualDownloadWrapper">
		<span class="manualDownloadTitle" id="manualWinBtn">
			<i class="fa fa-question-circle fa-lg mt-4 manualFileDownIcon"></i>
			사용자매뉴얼
		</span>
	</div>
	
	<form id="formManual" action='/common/manual' method='POST' target='commonManual'>
		<input type='hidden' name='inptMstSrno' value=''>
		<input type='hidden' name='adminFlag' id="adminFlag" value=''>
	</form>
	 
</div>
<script>
$(function(){
	console.log('[function()] aside jsp ready function call');
	
	// 최초 1회
	requestAsideStatus();
	
	// 최초 1회 이후 interval function
	requestAsideInterval();
	
	// 새로고침 버튼 toggle
	$(document).on('click', '#autoAsideRefreshBtn', function(){
		if($(this).hasClass('intervalON')){
			
			$(this).removeClass('intervalON');
			$(this).html('<i class="fa fa-refresh mt-4 autoAsideRefreshIcon"></i>');
			clearInterval(asideInterval);
			
		}else if(!$(this).hasClass('intervalON')){
			
			$(this).addClass('intervalON');
			$('.autoAsideRefreshIcon').addClass('autoAsideIconTrue');
			$('.autoAsideRefreshIcon').addClass('fa-spin');
			requestAsideStatus();
			requestAsideInterval();
			
		}
	});
});

// 목록 interval 실행함수
function asideIntervalWrapper(intervalTime){
	asideInterval = setInterval(function(){
		requestAsideStatus();
	}, intervalTime);
}

// 목록 list 요청
function requestAsideStatus(){
	console.log('[ajax] list call');
	var param = {};
	
	$.post('/api/common/status/aside', param, function(data){
		if(data.rst == 'success'){
			$('#nonCrCnt').text(data.cnt_ungen);						// 업무미생성 건수
			$('#scanCnt').text(data.resultAsideList[0].scanCnt);		// 스캔건수
			$('#errCnt').text(data.resultAsideList[0].errCnt);			// 오류건수
			$('#delayCnt').text(data.resultAsideList[0].delayCnt);		// 지연건수
			$('#normalCnt').text(data.resultAsideList[0].normalCnt);	// 정상건수
			$('#inspCnt').text(data.resultAsideList[0].inspCnt);		// 심사건수
			$('#apprCnt').text(data.resultAsideList[0].apprCnt);		// 결재건수
			$('#cmplCnt').text(data.resultAsideList[0].cmplCnt);		// 완료건수
			
			setUpdateTimeText();
		}
	}); // end of ajax
}

// 목록 interval wrapper 호출함수
function requestAsideInterval(){
	console.log('[ajax] interval call');
	var param = {};
	var intervalValue = null;
	
	$.post('/api/common/status/aside/interval', param, function(data){
		if(data.rst == 'success'){
			console.log('[get interval] ' + data.asideInterval);
			
			// 만약 공통코드에서 가져온 값이 숫자가 아니라면 기본 10분
			if(isNaN(data.asideInterval) || data.asideInterval < 1){
				console.log('[ajax] interval call setting and common code error');
				var convTime = (10 * 60) * 1000; // 1000 == 1s, 공통코드 분단위
				asideIntervalWrapper(convTime);//convTime
			}else{
				console.log('[ajax] interval call setting and common code success');
				var convTime = (Number(data.asideInterval) * 60) * 1000; // 1000 == 1s, 공통코드 분단위
				asideIntervalWrapper(convTime);//convTime	
			}
			
		}
	}); // end of ajax
	
	return intervalValue;
}

// 기준시간 업데이트 함수
function setUpdateTimeText(){
	var curTime = new Date();
	var curH = (curTime.getHours() < 10) ? '0'+curTime.getHours() : curTime.getHours();
	var curM = (curTime.getMinutes() < 10) ? '0'+curTime.getMinutes() : curTime.getMinutes();
	var curS = (curTime.getSeconds() < 10) ? '0'+curTime.getSeconds() : curTime.getSeconds();
	$('#updateMoment').text(curH+':'+curM+':'+curS+' 기준')
}
</script>