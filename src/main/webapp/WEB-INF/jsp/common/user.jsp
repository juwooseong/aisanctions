<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@include file="/WEB-INF/jsp/common/datatable.jsp"%>
<c:set var="pageId" value="${param.pageId}"/>
<c:set var="modelTitle" value="${param.modelTitle}"/>
<c:set var="modelGridId" value="modalUserListTable${param.pageId}"/>

<div class="modal fade" id="schUserModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<span class="width-100">
					<h4 class="modal-title" >사용자 조회</h4>
				</span>
			</div>
			<div class="modal-body">
				<div class="searchWrap">
					<div class="searchToggle">
						<button type="button" class="schToggle">검색</button>
						<span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
					</div>
					<div class="searchBox">
						<form action="">
							<p class="w28" style="padding: 5px 0px 5px 47px;">
								<label for="modalSchUserAu${pageId}" class="label" style="width: 30px;">권한</label>
								<select class="w64" name="schGbn" id="modalSchUserAu<c:out value="${pageId}"/>" onchange="chang();">
									<option value="">선택</option>
									 <c:forEach var="item" items="${inptAtmcBizDscdList }">
										<c:if test="${item.aiInptCmnCd ne '04'}">
											<option value="${item.aiInptCmnCd }">${item.aiInptCmnCdNm }</option>
										</c:if>
									</c:forEach> 
								</select>
							</p>
							<p class="w28" style="padding: 5px 9px 5px 70px;">
								<label for="modalSchUserNo${param.pageId}" class="label" style="width: 55px;">직원번호</label>
								<input type="text" class="it" id="modalSchUserNo<c:out value="${param.pageId}"/>" style="width: 79px;">
							</p>
							<p class="w28" style="padding: 5px 0px 5px 61px;">
								<label for="modalSchUserNm${param.pageId}" class="label">직원명</label>
								<input type="text" class="it" id="modalSchUserNm<c:out value="${param.pageId}"/>">
							</p>
							<p class="w28" style="padding: 5px 1px 5px 70px;">
								<label for="schUserYn${pageId}" class="label">사용여부</label>
								<select class="w64" name="schGbn" id="schUserYn<c:out value="${pageId}"/>">
									<option value="Y" selected="selected">사용</option>
									<option value="N">미사용</option>
								</select>
							</p>
							<button type="button" class="btType1" id="modalSearchBtn<c:out value="${param.pageId}"/>">조회</button>
						</form>
					</div>
				</div>
				
				<div class="contents">
					<div class="tbWrap">
						<div class="tbCon">
							<table class="table table-responsive-sm w-100" id="<c:out value="${modelGridId}"/>"></table>
							<p class="footBt">
								<span class="c">
									<button class="btType1" id="btnUserModalSelectInfo"  data-dismiss="modal">선택</button>
									<button class="btType1" id="btnUserModalClose"  data-dismiss="modal">닫기</button>
								</span>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<script>

$('#schUserModal').draggable({ handle: '.modal-header' });



var <c:out value="${modelGridId}"/>_data = {};
var <c:out value="${modelGridId}"/>LoadCnt = 0;
var <c:out value="${modelGridId}"/>Close = function() {
	$('#<c:out value="${param.modalId}" /> .modal-footer button.btn-danger').click();
}

function chang(){
	$("#modalSchUserNo<c:out value="${pageId}"/>").val("");
}

$(function() {
	var page_id = "<c:out value="${param.pageId}"/>";

	
	var modalDataTableId = '#<c:out value="${modelGridId}"/>', modalUserListTable, add_group_table;
	var initPage, initEvent, getSearchOption, getModalSearchOption;
	var g_defaultPageSize = 10;
	
	getModalSearchOption = function() {
		var options = {};
		var filters = [];

		/* if(<c:out value ="${modelGridId}"/>.userCte){
			options.aiInptCmnCd = <c:out value ="${modelGridId}"/>.userCte;
			<c:out value ="${modelGridId}"/>.userCte = "";
		} // 지워도 될듯.. userCte 없음 */
		//사용자 등급 선택박스
		if(<c:out value="${modelGridId}"/>_data.userAuthId){
			if(<c:out value="${modelGridId}"/>_data.userAuthId == 'auth02' && $('#'+<c:out value="${modelGridId}"/>_data.userAuthId).val() == '02'){
				$("#modalSchUserAu<c:out value="${pageId}"/>").val("02");
				document.getElementById("modalSchUserAu<c:out value="${pageId}"/>").disabled = true;
			}else if(<c:out value="${modelGridId}"/>_data.userAuthId == 'schSenderAuth'){
				$("#modalSchUserAu<c:out value="${pageId}"/>").val($('#'+<c:out value="${modelGridId}"/>_data.userAuthId).val());
				document.getElementById("modalSchUserAu<c:out value="${pageId}"/>").disabled = true;
			}else{
		//		$("#modalSchUserAu<c:out value="${pageId}"/>").val("");
				document.getElementById("modalSchUserAu<c:out value="${pageId}"/>").disabled = false;
			}
			//$("#modalSchUserAu<c:out value="${pageId}"/>").val
			options.aiInptCmnCd = $('#'+<c:out value="${modelGridId}"/>_data.userAuthId).val();
		}
		
		if(<c:out value ="${modelGridId}"/> && <c:out value ="${modelGridId}"/>.userSch){
			options.inptBizAlctCrpeEno = <c:out value ="${modelGridId}"/>.userSch;
			<c:out value ="${modelGridId}"/>.userSch = "";
		}
		
		if(<c:out value ="${modelGridId}"/> && <c:out value ="${modelGridId}"/>.userSearch){
			options.inptBizAlctCrpeFnm = <c:out value ="${modelGridId}"/>.userSearch;
			<c:out value ="${modelGridId}"/>.userSearch = "";
		}
		
		//직원번호
		if($("#modalSchUserNo" + page_id).val()){
			options.schUserNo = $("#modalSchUserNo" + page_id).val();
		}
		
		//직원명
		if($("#modalSchUserNm" + page_id).val()){
			options.schUserNm = $("#modalSchUserNm" + page_id).val();
		}
		
		//권한
		if($("#modalSchUserAu" + page_id).val()){
			options.aiInptCmnCd = $("#modalSchUserAu" + page_id).val();
		}
		if($("#schUserYn" + page_id).val()){
			options.schUserYn = $("#schUserYn" + page_id).val();
		}
		options = $.extend(options, {
				filter: JSON.stringify(filters),
			//	sort: "-created_time",
				"page[size]": g_defaultPageSize,
				"page[number]": 1
		});
		return options;
	};

	initModalDataTable = function(){
		modalUserListTable = $(modalDataTableId).DataTable({
			autoWidth: true,
			serverSide : true,
	        processing: true,
	        dom: 'r<"datatable-scroll"t><"datatable-footer"p>',
	        /*
	        columnDefs: [{
	            orderable: false,
	            sortable: false,
	            className:'text-left',
	            targets: '_all'
	        }],*/
	        select: {
	        	style: 'single'
	        },
	        language: {
	            processing: "loading...",
	            paginate: { 'first': 'First', 'last': 'Last', 'next': 'Next', 'previous': 'Prev' }
	        },
	        columns: [
	        	{"data": "aiInptUserAutVal", title: '권한', orderable: true, sortable: true}, // 수정할것 쿼리에서 가져오는걸로
	        	{"data": "aiInptUserEno", title: '직원번호', orderable: true, sortable: true},
	        	{"data": "aiInptUserNm", title: '직원명', orderable: true, sortable: true}
	        	
	        ],
	        columnDefs: [
	    		{ targets: 0, className: 'td-text-center td-text-10' },
	    		{ targets: 1, className: 'td-text-center td-text-40' },
	    		{ targets: 2, className: 'td-text-center td-text-40' }
	    	],

	        ajax : function(data, callback, settings) {
	        	var options = getModalSearchOption();
	        	// 페이징 처리 : length: 10, start: 10
	        	options["page[size]"] = data.length;
	        	options["pageIndex"] = data.start / data.length + 1;
	        
	        	options["pageUnit"] = options["page[size]"];
	        	options["sortItem"] = data.columns[data.order[0]['column']].data;
	        	options["sortDir"] = data.order[0]['dir'];
	        	// JSONAPI 호출
	        	$.get("/api/common/user", options, function(data){
	            	// callback 처리로 data 를 가공하여 datatable 에 출력한다.
	            	var json = data.resultList; 
	            	var modalList = document.getElementById("btnUserModalSelectInfo");
	            	if(!json.error){
		                callback({
		                	recordsTotal : data.paginationInfo.totalRecordCount,
		                	recordsFiltered : data.paginationInfo.totalRecordCount,
		                	data : data.resultList
		                });
		                if(json.length == 0){
		                	modalList.disabled=true;
		                }else{
		                	modalList.disabled=false;
		                }
		                $(modalDataTableId).find(' tbody tr').css("cursor", "pointer");
	            	}else{
	            		callback({
		                	recordsTotal : 0,
		                	recordsFiltered : 0,
		                	data : []
		                });
	            		
	            		swal("Cancelled", "사용자 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
	            	}
					
	                //사용자 그리드 검색 콜백함수
	        		if(<c:out value="${modelGridId}"/>LoadCnt > 0 && window.<c:out value="${modelGridId}"/>OnSearchList){
	        			window.<c:out value="${modelGridId}"/>OnSearchList(json);
	        		}
	                
	                //그리드 검색횟수 증가
	        		<c:out value="${modelGridId}"/>LoadCnt++;
	            });
	        }//ajax
	    });
		
		modalUserListTable.on('select', function(e, dt, type, index) {
			var row = dt.data();
			
			//행 선택시마다 행정보 저장.
			<c:out value="${modelGridId}"/>_data.row = row;
			
			if(window.<c:out value="${modelGridId}"/>_selectCallback){
				<c:out value="${modelGridId}"/>_selectCallback(e, dt, type, index, row);
			}
		});

		modalUserListTable.dataCount = function(){
			var olistTable = $(modalDataTableId).DataTable();
			var rowsCnt = olistTable.data().count();
			return rowsCnt ? rowsCnt : 0;
		};

		$("#btnUserModalSelectInfo").click(function(e){
			//선택버튼 클릭시.
			if(window.<c:out value="${modelGridId}"/>_selectOK){
				if(<c:out value="${modelGridId}"/>_data.row !=null){
					<c:out value="${modelGridId}"/>_selectOK(<c:out value="${modelGridId}"/>_data.row);
				}
			}
			$('#<c:out value="${param.modalId}" />').find('.btn-danger').trigger('click');
			$("#modalSchUserAu<c:out value="${pageId}"/>").val("");
			$("#modalSchUserNo<c:out value="${param.pageId}"/>").val("");
			$("#modalSchUserNm<c:out value="${param.pageId}"/>").val("");
		});
		
		
		$("#btnUserModalClose").click(function(e){
			//닫기 클릭시.
			$("#modalSchUserAu<c:out value="${pageId}"/>").val("");
			$("#modalSchUserNo<c:out value="${param.pageId}"/>").val("");
			$("#modalSchUserNm<c:out value="${param.pageId}"/>").val("");
		});
		
	};//initModalDataTable
	
	initEvent = function(){
		$('#schModal').off('shown.bs.modal').on('shown.bs.modal', function(e){
			if (!modalUserListTable){
				initModalDataTable();
			}
	    });
		
		$('#modalSearchBtn' + page_id).click(function() {
	        modalUserListTable.ajax.reload();
	        return false;
		});
		
		// 검색버튼 클릭
		$('.it').keyup(function(e) {
			
			if(e.keyCode === 13) {
				modalUserListTable.ajax.reload();
		        return false;
			}
		});
	};
	
	initPage = function(){
		initModalDataTable();
		initEvent();
		var btnModal = $('[data-target="#schUserModal"]');
		
		if(btnModal.length){
			btnModal.click(function(e){
				var schUserName = <c:out value="${modelGridId}"/>_data.userName ? <c:out value="${modelGridId}"/>_data.userName : null;
				//1115 추가
				var schUserNoId = <c:out value="${modelGridId}"/>_data.userNoId ? <c:out value="${modelGridId}"/>_data.userNoId : null;
				//사용자 번호 검색 입력박스, 검색창으로 넘기기
				if(schUserNoId){
					$("#modalSchUserNo<c:out value="${param.pageId}"/>").val($('#'+schUserNoId).val());
				}
				if(schUserName){
					$("#modalSchUserNm<c:out value="${param.pageId}"/>").val($('#'+schUserName).val());
				}
				$('#modalSearchBtn' + page_id).trigger("click");
				return true;
			});
		}
	};
	
	
	
	initPage();
});
</script>