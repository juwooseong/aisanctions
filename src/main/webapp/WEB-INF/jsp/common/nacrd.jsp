<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>
<div class="modal fade" id="nacrd_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<span class="width-100">
					<h4 class="modal-title" id="modalSanctionName">Modal title</h4>
				</span>
			</div>
			<div class="modal-body">
				<div class="tbWrap">
					<div class="tbCon">
						<table class="table table-responsive-sm width-100" id="nacrdTable"></table>
					</div>
				</div>
			</div>
			<div class="modal-footer" id="nacrd_modal_footer">
				<button class="btn btn-sm btn-primary pl-xl-3 pr-xl-3 m-1" data-dismiss="modal" id="nacrdDataCopyBtn">적용</button>
				<button class="btn btn-sm btn-secondary pl-xl-3 pr-xl-3 m-1" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<script>

var nacrdData = [];
var nacrdRow;
var nacrdIndex;
var nacrdColumn;
var nacrdEle;
var nacrdInptSanctionDatTxt;
var nacrdInptTaskId;
var nacrdInptSanctionNo;

$('#nacrd_modal').draggable({ handle: '.modal-header' });

var nacrdTable = $('#nacrdTable').DataTable({
	data: nacrdData,
	pageLength: 1000,
	scrollY: 150,
	scrollX: true,
	scrollXInner: '100%',
	paging: false,
	info: false,
	filter: false,
	length: false,
    columnDefs: [
    	{ targets: 0, className: 'td-text-center' },
    	{ targets: 1, className: 'td-text-center' },
    	{ targets: 1, className: 'td-text-center' },
    	{ targets: 2, className: 'td-text-center' },
    	{ targets: 3, className: 'td-text-center' }
    ],
    columns: [
    	{title: '번호', className: 'td-text-center td-text-40'},
    	{title: '√', className: 'td-text-center td-text-20'},
    	{title: '문서분류명', className: 'td-text-left td-text-80'},
    	{title: '이미지번호', className: 'td-text-center td-text-60' ,
    		render: function (data, type, fule, meta) {
    			
    			return globalImgIndex["index_" + data];
    		}
    	},
    	{title: '항목내용', className: 'td-text-left td-text-200 text-wrap' }
    ]
});

//항목심사 불일치 버튼 클릭
$(document).on('click','#sanctionRstTable td', function(e) {
	
	//클릭한 td 컬럼 데이터 받기
	var _row_index = globalSanctionRstListTable.cell(this).index()['row'];
	var _column_index = globalSanctionRstListTable.cell(this).index()['column'];
	var _inptSanctionNm = globalSanctionRstListTable.data()[_row_index][2];
	var _inptSanctionNo = globalSanctionRstListTable.data()[_row_index][8];
	var _inptTaskId = globalSanctionRstListTable.data()[_row_index][10];
	var _inptMstSrno = globalInptMstSrno;
	var _aiInptGrpCd = $('#active_inptBlGrpNo').val();
	
	nacrdRow = _row_index;
	nacrdColumn = _column_index;
	nacrdInptSanctionNo = _inptSanctionNo;
	nacrdInptTaskId = _inptTaskId;
	nacrdIndex = globalSanctionRstListTable.data()[_row_index][0] - 1;
	
	$('#modalSanctionName').text(_inptSanctionNm);

	if (1 == _column_index) {
		$.ajax({
			url : "/api/common/detail/nacrd",
			type : "post",
			cache: false,
			async : true,
			data : { inptMstSrno: _inptMstSrno, aiInptGrpCd: _aiInptGrpCd, inptSanctionNo: _inptSanctionNo },			
			dataType: "json",
			success : function(data) {
				
				if(data.resultCode=="200"){
					var selectInptNacrd = data.selectInptNacrd;
					
					// 변수 초기화
					var _indexNo = 0;
					var _rmrk_txt = "";
					var _safewatchItmYn = "";
					var _imgNo = "";
					var _sanction_dat_txt = "";
					
					nacrdData = [];
					var _arrData = [];
					
					for(var i in selectInptNacrd) {
						_indexNo ++;
						_safewatchItmYn = selectInptNacrd[i].safewatchItmYn ? selectInptNacrd[i].safewatchItmYn : '';
						_rmrk_txt = selectInptNacrd[i].imexhissAbbr ? selectInptNacrd[i].imexhissAbbr : '';
						_imgNo = selectInptNacrd[i].inptTaskId ? selectInptNacrd[i].inptTaskId : '';
						_sanction_dat_txt = selectInptNacrd[i].inptSanctionDatTxt ? selectInptNacrd[i].inptSanctionDatTxt : '';
						
						if ( _safewatchItmYn == "Y") {
							_safewatchItmYn = "√";
						} else {
							_safewatchItmYn = "";
						}
						
						_arrData = [
							_indexNo,
							_safewatchItmYn,
							_rmrk_txt,
							_imgNo,
							_sanction_dat_txt
						];
						
						nacrdData.push(_arrData);
					}
					
					// TotalText 테이블 데이터 넣기
					nacrdTable.clear().rows.add(nacrdData).draw();
					
				} else {
					
				}
			},
			error : function(e) {
				alert('정보조회가 실패했습니다.');
			}
		});	
	}
});


// 불일치 dataTable row Click
$(document).on('click', '#nacrdTable tr', function() {
	
	nacrdTable.$('tr.selected').attr('id', 'nacrdNon');
	nacrdTable.$('tr.selected').removeClass('selected');
	
	$(this).attr('id', 'nacrdSelected');
	$(this).addClass('selected');
	
	var _rowData = nacrdTable.row(this).data();
			
	if (_rowData) {
		
		var _nacrdData = _rowData[4];
		
		nacrdEle = $("#index_" + nacrdRow);
		nacrdInptSanctionDatTxt = _nacrdData;
		
	}
});


// 불일치 복사 Click
$(document).on('click', '#nacrdDataCopyBtn', function() {
	
	$("#index_" + nacrdIndex).val(nacrdInptSanctionDatTxt);
	fn_itmInptHndgInpDatTextChage(nacrdEle, nacrdInptSanctionDatTxt, nacrdInptSanctionNo, nacrdInptTaskId, nacrdIndex);
	
});

</script>