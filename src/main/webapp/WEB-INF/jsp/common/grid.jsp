<%@ page contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<style>
.table-responsive-sm th {text-align:center !important;}
</style>
<%-- 
참조페이지 url : /admin/menu

//jsp 상단에, 아래 변수두개 선언.
<c:set var="dataTableId" value="gridListTable${pageId}"/>
<c:set var="dataTableId2" value="gridListTable2${pageId}"/>

var <c:out value="${dataTableId}"/>Config = {
	ajaxUrl : '/api/admin/menu',
	columns : [
    	{"data": "col1", title: '메뉴ID'},
    	{"data": "col2", title: '메뉴명'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//권한
		if($("#schUserAuth<c:out value="${pageId}"/>").val()){
			options.schAuth = $("#schUserAuth<c:out value="${pageId}"/>").val();
		}

		//직원
		if($("#schUserName<c:out value="${pageId}"/>").val()){
			options.schUserNm = $("#schUserName<c:out value="${pageId}"/>").val();
		}
		
		return options;
	},
	columnDefs: [{ 
	    orderable: false,
	    sortable: false,
	    className:'text-center',
	    targets: '_all'
	}],
	/* 날짜 입력값 유효성 체크 대상 아이디 지정, 없으면 체크안함 */
	dateInputIds : [['schSDate1','schEDate1'],['schSDate2','schEDate2'],....]
};
var <c:out value="${dataTableId2}"/>Config = {
	ajaxUrl : '/api/admin/menu/screen',
	columns : [
    	{"data": "col1", title: '화면ID'},
    	{"data": "col2", title: '화면명'}
    ],
    //검색정의
    getSearchOption : function() {
		var options = {};
		var filters = [];
		
		//메뉴ID
		if($("#menuId<c:out value="${pageId}"/>").val()){
			options.menuId = $("#menuId<c:out value="${pageId}"/>").val();
		}
		
		return options;
	}
};
</script>
<jsp:include page="/common/grid" flush="false">
	//아래 옵션들은, 필수옵션.
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId}" />
	<jsp:param name="initYN" value="Y" />
	//아래 옵션들은, 선택옵션.
	<jsp:param name="gridOptionPaging" value="true" />
	<jsp:param name="gridOptionScrollX" value="true" />
	<jsp:param name="gridOptionScrollXInner" value="2000px" />
	<jsp:param name="gridOptionScrollY" value="300" />
	<jsp:param name="gridOptionPagingType" value="scrolling" />
	<jsp:param name="gridOptionPagingSize" value="Y/N" />
	<jsp:param name="select" value="single/multi" />
</jsp:include>
<jsp:include page="/common/grid" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="dataTableId" value="${dataTableId2}" />
	<jsp:param name="initYN" value="Y" />
	<jsp:param name="gridOptionPaging" value="false" />
</jsp:include>
<script>
var <c:out value="${dataTableId}"/>_selectCallback = function(e, dt, type, index, row){
	//좌측 메뉴목록에서, 메뉴항목 클릭시, 메뉴ID에 해당하는 화면목록을 갱신처리. 
	$('#menuId<c:out value="${pageId}"/>').val('SCREEN5100');
	<c:out value="${dataTableId2}"/>.searchList();
};
</script>

--%>
<c:set var="numColYN" value="${empty param.numColYN ? 'Y' : param.numColYN}"/>
<c:set var="gridOptionPagingSize" value="${empty param.gridOptionPagingSize ? 'Y' : param.gridOptionPagingSize}"/>

<script>
var <c:out value="${param.dataTableId}"/> = {};
$(function() {
	var today = formatYMD(getToDay());
	var rowLengthSelect = [15, 30, 50, 100];
	var config = <c:out value="${param.dataTableId}"/>Config;
	var config_columnDefs = config.columnDefs ? config.columnDefs : 
		[{
	        orderable: false,
	        sortable: false,
	        className:'text-center',
	        targets: '_all'
		}]
	;
	
	//날짜 입력값 셋팅 안되엉 있으면, 기본일자 셋팅처리.
	if(config.dateInputIds && config.dateInputIds.length){
		for(var i=0;i<config.dateInputIds.length;i++){
			var v_dateInputIds = config.dateInputIds[i] ? (config.dateInputIds[i]+'').split(',') : [];
			for(var j=0;j<v_dateInputIds.length;j++){
				var v_id = v_dateInputIds[j];
				var v_input = $('#' + v_id);
				if(v_input.val()==''){
					v_input.val(today);
				}
			}
		}
	}
	
	var listTable;
	
	<c:out value="${param.dataTableId}"/>.dataTableId = '#<c:out value="${param.dataTableId}"/>';
	<c:out value="${param.dataTableId}"/>.add_group_table;
	<c:out value="${param.dataTableId}"/>.g_defaultPageSize = 15;
	
	<c:out value="${param.dataTableId}"/>.initPage;
	<c:out value="${param.dataTableId}"/>.initEvent;
	
	<c:out value="${param.dataTableId}"/>.pageId = '<c:out value="${param.pageId}"/>';
	
	<c:out value="${param.dataTableId}"/>.getSearchOption = config.getSearchOption;
	
	<c:out value="${param.dataTableId}"/>.initDataTable = function(){
		var imAuths;
		var exAuths;
		var imSugis;
		var exSugis;
		var qas;
		var qa2s;
		
		var imAuthDateSets;
		var exAuthDateSets;
		var imSugiDateSets;
		var exSugiDateSets;
		var qaDateSets;
		var qa2DateSets;
		
		var totalAvgTimes;
		listTable = $(<c:out value="${param.dataTableId}"/>.dataTableId).DataTable({
			<c:if test="${not empty param.gridOptionScrollX}">"scrollX": <c:out value="${param.gridOptionScrollX}"/>,</c:if>
			<c:if test="${not empty param.gridOptionScrollXInner}">"scrollXInner": '<c:out value="${param.gridOptionScrollXInner}"/>',</c:if>
	    	<c:if test="${not empty param.gridOptionScrollY}">scrollY: '<c:out value="${param.gridOptionScrollY}"/>',</c:if>
	    	<c:if test="${empty param.gridOptionScrollY}">scrollY: '440',</c:if>
	    	<c:if test="${not empty param.gridOptionPagingType}">pagingType: <c:out value="${param.gridOptionPagingType}"/>,</c:if>
	        <c:if test="${not empty param.gridOptionPaging}">paging: <c:out value="${param.gridOptionPaging}"/>,	// default</c:if>
			serverSide : true,
	        processing: true,
	        searching: false,
	        cache: false,
	        dom: '<c:if test="${not empty gridOptionPagingSize and gridOptionPagingSize eq 'Y'}"><"top"li></c:if>t<"bottom"p>',
	        lengthMenu: [15, 30, 50, 100],
	        language: {
	            processing: "loading...",
	            paginate: { 'first': 'First', 'last': 'Last', 'next': 'Next', 'previous': 'Prev' },
	            lengthMenu: '_MENU_',
	            info: '_START_ - _END_ (총 _TOTAL_ 건)',
	            infoEmpty: '1 - 1 (총 0 건)'
	        },
	        
	        columns: [<c:if test="${not empty numColYN and numColYN eq 'Y'}">
	        	{data: "id",type:'', title: 'No', "render": function ( data, type, full, meta ) {
	    	    return  (listTable.page.info().page * listTable.page.info().length) + meta.row + 1;
	    	}}</c:if>].concat(config.columns),
	        columnDefs: config_columnDefs,
	        <c:if test="${not empty param.select}">
	        select: {
	        	style: '<c:out value="${param.select}"/>'
	        },
	        </c:if>

	        ajax : function(data, callback, settings) {
	        
	      
	        	
    			//console.log(data);
	        	var options = <c:out value="${param.dataTableId}"/>.getSearchOption();
	        	// 페이징 처리 : length: 20, start: 20
	        	options["page[size]"] = data.length;
	        	options["pageIndex"] = data.start / data.length + 1;
	        	options["recordCountPerPage"] = data.length;
	        	options["pageUnit"] = options["page[size]"];
	        	options["sortItem"] = data.columns[data.order[0]['column']].data;
	        	options["sortDir"] = data.order[0]['dir'];
	        	
	        	/* // 초기정렬설정
	        	if(options["sortItem"]=='id'){
	        		options["sortItem"] = 'inptRcpDt';
	        		options["sortDir"] = 'desc';
	        	} */
	        	
	        	// JSONAPI 호출
	        	// callback 처리로 data 를 가공하여 datatable 에 출력한다.
	        	if(config.ajaxUrl != '') {
	        		
	        		//날짜 기간 검색 입력값 유효성 체크
	        		//config.dateInputIds : [['시작일검색입력박스아이디','종료일검색입력박스아이디'],....]
	        		if(config.dateInputIds){	//임시 디버깅용으로 주석처리, 추후에 테스트 완료 후 조건 삭제처리.
		        		var dateInputIds = config.dateInputIds ? config.dateInputIds : [];
		        		for(var i=0;i<dateInputIds.length;i++){
		        			var sdateObj = $('#'+dateInputIds[i][0]);
		        			var edateObj = $('#'+dateInputIds[i][1]);
		        			var sdate = $.trim(sdateObj.val());
		        			var edate = $.trim(edateObj.val());
		        			if(sdate && edate){
		        				//시작일은 종료일보다 이전이어야함.
		        				if(sdate > edate){
		        					alert('검색기간이 잘 못 설정되었습니다.');
		        					sdateObj.focus();
		        					return;
		        				}
		        				
		        				//조회기간이 최대 30일까지만 가능.
		        				var v_diff = fnCmnGetDateStrDiff(sdate,edate,'d');
		        				if(v_diff!=null && v_diff > 30){
		        					//alert('검색기간은 최대 30일까지만 조회가 가능합니다.');
		        					//sdateObj.focus();
		        					//return;
		        				}
		        			}
		        		}
	        		}
	        		
	        	
	        		s_loading();
	        		//그리드 목록 ajax 호출 및 로딩
	        		$.get(config.ajaxUrl+'?'+$.now(), options, function(data){
	        			
	        			if(data.resultCode=="200"){
	        				h_loading();
	        				
			            	var json = data.resultList;
			            	if(config.ajaxUrl == "/api/stat/task"){
	        					imAuths = data.imAuth;
	        					exAuths = data.exAuth;
	        				    imSugis = data.imSugi;
	        					exSugis = data.exSugi;
	        					qas = data.qa;
	        					qa2s = data.qa2;
	        					
	        					imAuthDateSets = data.imAuthDateSet;
	        					exAuthDateSets = data.exAuthDateSet;
	        					imSugiDateSets = data.imSugiDateSet;
	        					exSugiDateSets = data.exSugiDateSet;
	        					qaDateSets = data.qaDateSet;
	        					qa2DateSets = data.qa2DateSet;
	        					
	        					totalAvgTimes = data.totalAvgTime;
	        				}
			          
			            	if(!json.error){
				                data.resultList.totalAvgTimes = data.totalAvgTime
				                callback({
				                	//recordsTotal : json.paginationInfo.totalRecordCount,
				                	//recordsFiltered : json.paginationInfo.totalRecordCount,
				                	recordsTotal : data.paginationInfo.totalRecordCount,
				                	recordsFiltered : data.paginationInfo.totalRecordCount,
				                	data : data.resultList
				      
				                });
			            	}else{
			            		callback({
				                	recordsTotal : 0,
				                	recordsFiltered : 0,
				                	data : []
				                });
			            		
			            		swal("Cancelled", "데이터셋 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
			            	}
			            	
			            	/* if(${param.pageId} == '7080'){
			    				<c:out value="${param.dataGridId2}"/>.searchList();
			    				return;
			    			} */
			            	
	        			} else {
	        				fnAlertErrorMsg(data);
	        			}
	        			
		            });
	        	} else {
	        		callback({
	                	recordsTotal : 0,
	                	recordsFiltered : 0,
	                	data : []
	                });
	        	}
	        	
	        	//$('.table-responsive-sm').children('thead').children('tr').children('.sorting_asc').removeClass('sorting_asc');
	        	
	        }//ajax
	        <c:if test="${not empty param.gridRowCallback and param.gridRowCallback eq 'Y'}">,fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull){
	        	var vrow = $(nRow);
	 
				//셀별 툴팁설정
				vrow.find('td').each(function(idx,obj){
					var vtd = $(obj);
					var vtdText = vtd.text();
					
					//셀에 툴팁표시
					if(idx > 0 && $.trim(vtdText)){
						vtd.prop('title',vtdText);
					}
				});
 
			 	if(config.ajaxUrl == "/api/stat/task"){
				    //console.log(aData)
                    aData.imAuths = imAuths;
                    aData.exAuths = exAuths;
                    aData.imSugis = imSugis;
                    aData.exSugis = exSugis;
                    aData.qas = qas;
                    aData.qa2s = qa2s;
                    
                    aData.imAuthDateSets = imAuthDateSets;
                    aData.exAuthDateSets = exAuthDateSets;
                    aData.imSugiDateSets = imSugiDateSets;
                    aData.exSugiDateSets = exSugiDateSets;
                    aData.qaDateSets = qaDateSets;
                    aData.qa2DateSets = qa2DateSets;
                    
                    aData.totalAvgTimes = totalAvgTimes;
					if(config.fnRowCallback){
		        		config.fnRowCallback(nRow, aData, iDisplayIndex, iDisplayIndexFull);
		        	}
					
				}else{
		        	if(config.fnRowCallback){
		        		config.fnRowCallback(nRow, aData, iDisplayIndex, iDisplayIndexFull);
		        	}
					
				} 	
	        }</c:if>
	    });
	    <c:out value="${param.dataTableId}"/>listTable = listTable;
		$('#select_th').html("<input type='checkbox' name='select_all' value='1' id='select-all'>");
		$('#<c:out value="${param.dataTableId}"/>').prop('align','left');
		$('.dataTables_scrollHeadInner').css('width',$('.dataTables_scrollHeadInner').parent().next().find('.dataTable').width());
		
	};

	<c:out value="${param.dataTableId}"/>.initEvent = function(){
		
		$("#searchBtn_<c:out value="${param.dataTableId}"/>").click(function() {
			
			var sdateId = 'cld_schSdate1_Search_<c:out value="${param.pageId}"/>';
			var edateId = 'cld_schEdate1_Search_<c:out value="${param.pageId}"/>';
			
			var input_refno = $("#txt_actlFxRefno_Search_<c:out value="${param.pageId}"/>").val();
			var input_refno_2 = $("#actlFxRefno").val();
			var input_cusno = $("#txt_aiInptCusNo_Search_<c:out value="${param.pageId}"/>").val();
			var input_empno = $("#txt_inptBizAlctCrpeEno_<c:out value="${param.pageId}"/>").val();
			var input_empno_2 = $("#schUserId_<c:out value="${param.pageId}"/>").val();
			var input_empno_3 = $("#schUserNo").val();
			var input_mstno = $("#txt_masterNum_Search").val();
			var input_admNationCd = $(".admNationCd").val(); // 관리자메뉴 > 코드관리 > 국가코드관리 > 검색조건(국가코드)
			var input_admNationNm = $(".admNationNm").val(); // 관리자메뉴 > 코드관리 > 국가코드관리 > 검색조건(국가명)
			var input_proc_time = $("#aiInptProcTime_Search_<c:out value="${param.pageId}"/>").val();
			var input_admStatus_server = $("#schAiInptSvrInfTxt").val();
			
			var values = document.getElementsByName("BizDscd");
			var isChk = false;

			for(var i=0; i<values.length; i++){
				if(values[i].checked){
					isChk = true;
				}
			}
			
			
			var calValidation = false;
			
			if($('.cal').hasClass('calRange')){
				if(!validationRangeEvent()){
					return;
					//listTable.ajax.reload();
				}
			}else if($('.cal').hasClass('calSingle')){
				if(!validationSingleEvent()){
					///listTable.ajax.reload();
					return;
				}
			}
			
			
			if(!isChk && ${param.pageId} == '6020'){
				alert("최소 한개의 업무구분을 선택해주시기 바랍니다.");
				return;
			}
			
			if(input_admStatus_server != null && input_admStatus_server != ""){
				console.log("input_admStatus_server validation process");
				if(!fnCheckUsingCharForamt(1, input_admStatus_server)){
					alert("수행서버는 숫자만 입력 가능합니다.");
					return;
				}
			}
			if(input_proc_time != null && input_proc_time != ""){
				console.log("input_proc_time validation process");
				if(!fnCheckUsingCharForamt(1, input_proc_time)){
					alert("경과시간은 숫자만 입력 가능합니다.");
					return;
				}
			}
			if(input_refno != null && input_refno != ""){
				console.log("input_refno validation process");
				if(!fnCheckUsingCharForamt(2, input_refno)){
					alert("Ref.No 을 확인해주세요.");
					return;
				}
			}
			if(input_refno_2 != null && input_refno_2 != ""){
				console.log("input_refno validation process");
				if(!fnCheckUsingCharForamt(2, input_refno_2)){
					alert("Ref.No 을 확인해주세요.");
					return;
				}
			}
			if(input_cusno != null && input_cusno != ""){
				console.log("input_cusno validation process");
				if(!fnCheckUsingCharForamt(1, input_cusno)){
					alert("고객번호 를 확인해주세요.");
					return;
				}
			}
			if(input_empno != null && input_empno != ""){
				console.log("input_empno validation process");
				if(!fnCheckUsingCharForamt(2, input_empno)){
					alert("직원번호 를 확인해주세요.");
					return;
				}
			}
			if(input_empno_2 != null && input_empno_2 != ""){
				console.log("input_empno_2 validation process");
				if(!fnCheckUsingCharForamt(2, input_empno_2)){
					alert("직원번호 를 확인해주세요.");
					return;
				}
			}
			if(input_empno_3 != null && input_empno_3 != ""){
				console.log("input_empno_3 validation process");
				if(!fnCheckUsingCharForamt(2, input_empno_3)){
					alert("직원번호 를 확인해주세요.");
					return;
				}
			}
			if(input_mstno != null && input_mstno != ""){
				console.log("input_mstno validation process");
				if(!fnCheckUsingCharForamt(1, input_mstno)){
					alert("마스터번호 를 확인해주세요.");
					return;
				}
			}
			if(input_admNationCd != null && input_admNationCd != ""){
				console.log("input_admNationCd validation process");
				if(!fnCheckUsingCharForamt(0, input_admNationCd)){
					alert("국가코드 를 확인해주세요.");
					return;
				}
			}
			if(input_admNationNm != null && input_admNationNm != ""){
				console.log("input_admNationNm validation process");
				if(fnCheckUsingCharForamt(3, input_admNationNm)){
					alert("국가명 을 확인해주세요.");
					return;
				}
			}
			
			if($("#aiInptListText1").val()  == "" && $("#aiInptListText2").val()  == "" && $("#aiInptListText3").val()  == "" && $("#aiInptListText4").val()  == "" && $("#aiInptListText5").val()  == ""
				&& $("#aiInptListId1").val()  == "" && $("#aiInptListId2").val()  == "" && $("#aiInptListId3").val()  == "" && $("#aiInptListId4").val()  == "" && $("#aiInptListId5").val()  == ""){
			alert("조건항목을 최소 1개 입력해주시기 바랍니다.");
			return false;
		}
		
		 if($("#inptSanctionNo1").val()  != "" && $("#aiInptListText1").val()  == "" && $("#aiInptListId1").val()  == ""
				 || ($("#inptSanctionNo1").val() == "" && ($("#aiInptListText1").val()  != "" || $("#aiInptListId1").val()  != ""))){
			alert("조건항목과 값을 모두 입력해주시기 바랍니다..");
			return false;
		}
		
		 if($("#inptSanctionNo2").val()  != "" && $("#aiInptListText2").val()  == "" && $("#aiInptListId2").val()  == ""
			 || ($("#inptSanctionNo2").val() == "" && ($("#aiInptListText2").val()  != "" || $("#aiInptListId2").val()  != ""))){
			alert("조건항목과 값을 모두 입력해주시기 바랍니다..");
			return false;
		}
		
		 if($("#inptSanctionNo3").val()  != "" && $("#aiInptListText3").val()  == "" && $("#aiInptListId3").val()  == ""
			 || ($("#inptSanctionNo3").val() == "" && ($("#aiInptListText3").val()  != "" || $("#aiInptListId3").val()  != ""))){
			alert("조건항목과 값을 모두 입력해주시기 바랍니다..");
			return false;
		}
		
		 if($("#inptSanctionNo4").val()  != "" && $("#aiInptListText4").val()  == "" && $("#aiInptListId4").val()  == ""
			 || ($("#inptSanctionNo4").val() == "" && ($("#aiInptListText4").val()  != "" || $("#aiInptListId4").val()  != ""))){
			alert("조건항목과 값을 모두 입력해주시기 바랍니다..");
			return false;
		}
		
		 if($("#inptSanctionNo5").val()  != "" && $("#aiInptListText5").val()  == "" && $("#aiInptListId5").val()  == ""
			 || ($("#inptSanctionNo5").val() == "" && ($("#aiInptListText5").val()  != "" || $("#aiInptListId5").val()  != ""))){
			alert("조건항목과 값을 모두 입력해주시기 바랍니다..");
			return false;
		}
			
			/*
			var calValidation = false;
			
			if($('.cal').hasClass('calRange')){
				if(validationRangeEvent()){
					listTable.ajax.reload();
				}
			}else if($('.cal').hasClass('calSingle')){
				if(validationSingleEvent()){
					listTable.ajax.reload();
				}
			}
			else{
				listTable.ajax.reload();
				
			}*/
			
			/*
			if(calValidation){
				if(fnCmnCheckValidDate(sdateId, edateId)){
					listTable.ajax.reload();
				}
			}else{
				return;
			}*/
			
			listTable.ajax.reload();
			
		
			
			// 사용자 정보 refresh
			$("#userNo").val("");
			$("#userNm").val("");
			$("#appUserNo").val("");
			$("#appUserNm").val("");
			
			$("#schSenderNo").val("");
			$("#schSenderNm").val("");
			$("#schReceiverNo").val("");
			$("#schReceiverNm").val("");
			
			$("#txt_nacd").val("");
			$("#txt_engNlNm").val("");
		
		       return false;
		});
		
// 		// Basic initialization
// 	    $('.daterange-basic').daterangepicker({
// 	    	singleDatePicker: true,
// 	        locale: {
// 	            format: 'YYYY-MM-DD'
// 	        }
// 	    });
		
	};
	
	<c:out value="${param.dataTableId}"/>.searchList = function(){
		<c:out value="${param.dataTableId}"/>listTable.ajax.reload();
	};

	<c:out value="${param.dataTableId}"/>.searchListCurrentPage = function(){
		<c:out value="${param.dataTableId}"/>listTable.ajax.reload(null, false);
	};
	
	<c:out value="${param.dataTableId}"/>.getAllListTableRow = function(){
		var selectTargetTableRowData = <c:out value="${param.dataTableId}"/>listTable.rows();
		return selectTargetTableRowData;
	};
	
	
	
	<c:out value="${param.dataTableId}"/>.selectAllListTableRow = function(){
		var selectTargetTable = <c:out value="${param.dataTableId}"/>listTable;
		selectTargetTable.rows().select();
	};
	
	// 특정 하나 행만 선택하는것(콜백에서 사용가능)
	<c:out value="${param.dataTableId}"/>.selectOneListTableRow = function(index){
		var selectTargetTable = <c:out value="${param.dataTableId}"/>listTable;
		selectTargetTable.rows(index).select();
	};
	
	<c:out value="${param.dataTableId}"/>.deselectAllListTableRow = function(){
		var selectTargetTable = <c:out value="${param.dataTableId}"/>listTable;
		selectTargetTable.rows().deselect();
	};
	
	<c:out value="${param.dataTableId}"/>.getListTable = function(){
		return <c:out value="${param.dataTableId}"/>listTable;
	};
	
	//현재 선택된 행의 row 정보를 반환.
	<c:out value="${param.dataTableId}"/>.getSelRows = function(){
		var olistTable = <c:out value="${param.dataTableId}"/>listTable;
		var selRows = olistTable.rows({selected: true})[0];
		var list = []
		if(selRows && selRows.length){
			for(var i=0;i<selRows.length;i++){
				var idx = selRows[i];
				var row = olistTable.rows(idx).data()[0];
				row.idx = idx;
				list.push(row);
			}
		}
		return list;
	};
	
	<c:out value="${param.dataTableId}"/>.getSelRowIdxs = function(){
		var olistTable = <c:out value="${param.dataTableId}"/>listTable;
		var selRows = olistTable.rows({selected: true})[0];
		return selRows;
	};
	
	<c:out value="${param.dataTableId}"/>.deselect = function(){
		var olistTable = <c:out value="${param.dataTableId}"/>listTable;
		olistTable.rows().deselect();
	};

	<c:out value="${param.dataTableId}"/>.deselectItem = function(idx){
		var olistTable = <c:out value="${param.dataTableId}"/>listTable;
		olistTable.rows(idx).deselect();
	};

	<c:out value="${param.dataTableId}"/>.dataCount = function(idx){
		var olistTable = <c:out value="${param.dataTableId}"/>listTable;
		var rowsCnt = olistTable.data().count();
		return rowsCnt ? rowsCnt : 0;
	};

	<c:out value="${param.dataTableId}"/>.initPage = function(){
		this.initDataTable();
		this.initEvent();
	};
	
	<c:if test="${param.initYN eq 'Y'}">
		<c:out value="${param.dataTableId}"/>.initPage();
	</c:if>
	
	<c:out value="${param.dataTableId}"/>listTable.on('select', function(e, dt, type, index, row) {
		
		if (typeof dt != "undefined") {
			var row = dt.data();
			if(window.<c:out value="${param.dataTableId}"/>_selectCallback){
				<c:out value="${param.dataTableId}"/>_selectCallback(e, dt, type, index, row);
			}
		}
	});
	
	<c:out value="${param.dataTableId}"/>listTable.on('deselect', function(e, dt, type, index, row) {
		
		if (typeof dt != "undefined") {
			var row = dt.data();
			if(window.<c:out value="${param.dataTableId}"/>_deselectCallback){
				<c:out value="${param.dataTableId}"/>_deselectCallback(e, dt, type, index, row);
			}
		}
	});

	// 검색버튼 클릭
	$('.it').keyup(function(e) {
		
		if(e.keyCode === 13) {
			listTable.ajax.reload();
	        return false;
		}
	});
});
</script>