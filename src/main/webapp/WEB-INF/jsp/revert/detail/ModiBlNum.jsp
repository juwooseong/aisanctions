<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="modal fade" id="ModiBlNum_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog w40" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="modalSanctionName">Bill of landing No - Modify</h4>
				<button class="close" type="button" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			
			<div class="modal-body">
				<span aria-hidden="true">현재 이미지에 해당하는 B/L Number를 수정합니다.</span>
				<div class="tbWrap">
					<div class="container">
						<label for="inptSanctionDatTxt" class="label td-text-400">Origin B/L Number</label>
						<input type="text" class="it td-text-300" id="inptSanctionDatTxt" readonly="readonly">
					</div>
				</div>
				<div class="tbWrap">
					<div class="container">
						<label for="BlModi" class="label td-text-400">Modify B/L Number </label>
						<input id="BlModi" type="text" class="it td-text-300" placeholder="수정할 Bill of landing No을 입력해주세요.">
					</div>
				</div>
			</div> 
			<div class="modal-footer">
				<button class="btType2" type="button" data-dismiss="modal">닫기</button>
				<button class="btType1" type="button" data-dismiss="modal" id="BlModiSave">저장</button>
			</div>
			<input type="hidden" id="inptSanctionDatTxt" value="">
			<input type="hidden" id="inptTaskId" value="">
			<input type="hidden" id="inptSanctionNo" value="">
			<input type="hidden" id="imexHisCd" value="">
			<input type="hidden" id="inptMstSrno" value=""> 
			<input type="hidden" id="inptBlGrpNo" value="">
		</div>
	</div>
</div>
<script>
////항목심사  수기입력 Click

var globalSanctionRstTableId = '#sanctionRstTable';
$('#BlModi').val("");


$(document).on('click', globalSanctionRstTableId + ' tr', function() {

	var _rowData = globalSanctionRstListTable.row(this).data();
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _inptSanctionDatTxt = _rowData[3];
	var _inptTaskId = _rowData[9];
	var _inptSanctionNo = _rowData[7];
	var _imexHisCd = _rowData[8];
	var inptSanctionDatTxt;
	
	if(_inptSanctionDatTxt == ""){
		inptSanctionDatTxt = "추출된 B/L Number 항목이 없습니다.";
	}else{
		inptSanctionDatTxt = _inptSanctionDatTxt;
	}
	$('#inptSanctionDatTxt').val(inptSanctionDatTxt);
	$('#inptTaskId').val(_inptTaskId);
	$('#inptSanctionNo').val(_inptSanctionNo);
	$('#imexHisCd').val(_imexHisCd);
	$('#inptMstSrno').val(globalInptMstSrno);
	$('#inptBlGrpNo').val(_active_inptBlGrpNo);
});

$('#BlModiSave').on('click', function() {	
		var inptSanctionDatTxt = $('#BlModi').val();
		var inptTaskId = $('#inptTaskId').val();
		var inptSanctionNo = $('#inptSanctionNo').val();
		var imexHisCd = $('#imexHisCd').val();
		var inptMstSrno = $('#inptMstSrno').val();
		var inptBlGrpNo = $('#inptBlGrpNo').val();
		if(inptSanctionDatTxt ==""){
			alert("수정할 Bill of landing No를 입력해주세요.");
			return false;
		}
		
		$.ajax({
			url : "/api/common/revertDetail/ModiBlNum",
			type : "post",
			cache: false,
			async : true,
			data : {inptMstSrno: inptMstSrno, inptSanctionNo: inptSanctionNo, inptTaskId:inptTaskId, imexHisCd:imexHisCd, inptSanctionDatTxt:inptSanctionDatTxt, inptBlGrpNo:inptBlGrpNo},			
			dataType: "json",
			success : function(data) {
				if(data.resultCode=="200"){
					 var selectInptNacrd = data.result;
					
					 if(selectInptNacrd){
						 alert("성공적으로 처리되었습니다.");
						 $('#BlModi').val("");
					 }else{
						 alert("B/L 업데이트를 실패하였습니다.\n 다시 시도해주시기 바랍니다.");
					 }
			
				} else {
					alert("B/L 업데이트를 실패하였습니다.\n 다시 시도해주시기 바랍니다.");
				}
				fn_getReBLData();
				//	window.location.reload();
			},
			error : function(e) {
				alert('정보조회가 실패했습니다.');
			}
		});	
	});
</script>