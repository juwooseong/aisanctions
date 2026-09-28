<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="modal fade" id="extc_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<span class="width-100">
					<h4 class="modal-title" id="extcSanctionName">Modal title</h4>
				</span>
			</div>
			<div class="modal-body">
				<div class="tbWrap">
					<div class="tbCon">
						<table class="table table-responsive-sm width-100" id="extcTable"></table>
					</div>
				</div>
			</div>
			<div class="modal-footer" id="extc_modal_footer">
				<button class="btn btn-sm btn-secondary pl-xl-3 pr-xl-3 m-1" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<script>

var extcData = [];
var extcRow;
var extcColumn;

$('#extc_modal').draggable({ handle: '.modal-header' });

var extcTable = $('#extcTable').DataTable({
	data: extcData,
	pageLength: 1000,
	scrollY: 300,
	scrollX: true,
	scrollXInner: '100%',
	paging: false,
	info: false,
	filter: false,
	length: false,
    columnDefs: [
    	{ targets: 0, className: 'td-text-center no-use-sorting', orderable :false },
    	{ targets: 1, className: 'td-text-center no-use-sorting', orderable :false }
    ],
    columns: [
    	{title: '구분', className: 'td-text-center td-text-40'},
    	{title: '추출내용', className: 'td-text-left td-text-200 text-wrap'}
    ]
});

//항목심사 불일치 버튼 클릭
$(document).on('click','#sanctionRstTable td', function(e) {
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = globalSanctionRstListTable.cell(this).index()['row'];
	var _column_index = globalSanctionRstListTable.cell(this).index()['column'];
	var _index = globalSanctionRstListTable.data()[_row_index][0];
	var _inptSanctionNm = globalSanctionRstListTable.data()[_row_index][2];
	var _inptSanctionNo = globalSanctionRstListTable.data()[_row_index][8];
	var _inptMstSrno = globalInptMstSrno;
	var _aiInptGrpCd = $('#active_inptBlGrpNo').val();
	
	extcRow = _row_index;
	extcColumn = _column_index;
	
	$('#extcSanctionName').text(_inptSanctionNm);

	if (6 == _column_index) {
		// 변수 초기화
		var _indexNo = 0;
		extcData = [];
		var _arrData = [];
		
		_arrData = ["AICR", $globaObjlData.sanctionRst[_index - 1].aiInptExtcSntnTxt];
		extcData.push(_arrData);

		_arrData = ["TA", $globaObjlData.sanctionRst[_index - 1].bfrsTaExtcTxt];
		extcData.push(_arrData);

		_arrData = ["항목내용", $globaObjlData.sanctionRst[_index - 1].inptSanctionDatTxt];
		extcData.push(_arrData);
		
		// TotalText 테이블 데이터 넣기
		extcTable.clear().rows.add(extcData).draw();
	}
});

</script>