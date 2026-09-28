//변수 선언
g_defaultPageSize = 1000;
//totalText Table ID
totalTextRstTableId = '#totalTextRstTable';
//sanction Table ID
sanctionRstTableId = '#sanctionRstTable';
//totalText Table
totalTextRstListTable = "";
//sanction Table
sanctionRstListTable = "";
//totalText Table DATA, sanction Table DATA
totalTextRstListData = [], sanctionRstListData = [];
//bl메뉴 데이터
top_tab_data = [];
//항목메뉴 데이터
left_tab_data = [];
//이미지 정보 
img_pageInfo_data = [];
//이미지 좌표 데이터
img_Cdnts_data = [];
//totalText 테이블 데이터 
totalTextRst_data = [];
//항목심사 테이블 데이터 
sanctionRst_data = [];
//전달정보 데이터
appvRecode_data = [];
//분서분류코드
imexHisCdList_data = [];
//심사결과 코드
inptRstCdList_data = [];
//이미지 좌표정보
inform = [];
//항목별 이미지 목록
imglist = [];
//inptMstSrno
inpt_mst_srno = "";
//inptAtvtCd
inpt_atvt_cd = "";


//함수 선언
//url에서 파라미터 받아오기
var getUrlVars
//url에서 파라미터 받아오기(varName)
var g_getUrlVar
//bl 생성(top_tab_data)
var setBl
//item 생성(left_tab_data)
var setItem
//이미지  정보 세팅(inptBlGrpNo, imexHisCd)
var setImgInfo
//이미지 페이징버튼 생성 (imglist)
var setImgPageBtn
//TotalText 테이블 초기화(totalTextRstListData)
var initTotalTextRstTable
//문서분류 selectbox 생성(imexHisCdList_data)
var setImexHisCd 
//심사결과 selectbox(inptRstCdList_data)
var setInptRstCd
//이미지호출 전 데이터 세팅
var setCallImgData
//하이라이트 세팅(_active_spdKind, _active_inptTaskId, _active_inptElmtId, _active_imexHisCd)
var setBlink
//심사결과 세팅
var setMstInptRstCd



setBlink = function(_active_spdKind, _active_inptTaskId, _active_inptElmtId, _active_imexHisCd) {
	
	//이미지 좌표정보
	inform = [];
	
	//inptBlGrpNo 받기
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	//선택된 테이블 row데이터
	var _totalTextRstListTable_data = totalTextRstListTable.row('.selected').data();
	var _sanctionRstListTable_data = sanctionRstListTable.row('.selected').data();
	
	if (_totalTextRstListTable_data && 'TOTAL' == _active_spdKind) {
		
		var _totalTextRstListTable_data = totalTextRstListTable.row('.selected').data();
		var _aiInptTotaltextSrno = $(_totalTextRstListTable_data[1]).attr('data-aiInptTotaltextSrno');
		
		for(var i in img_Cdnts_data) {
			
			if (_active_spdKind == img_Cdnts_data[i]["spdKind"] && 
					_aiInptTotaltextSrno == img_Cdnts_data[i]["aiInptTotaltextSrno"] && 
					_active_inptTaskId == img_Cdnts_data[i]["inptTaskId"] && 
					_active_inptElmtId == img_Cdnts_data[i]["inptElmtId"] && 
					_active_imexHisCd == img_Cdnts_data[i]["imexHisCd"]) {
				
				inform.push(JSON.parse(img_Cdnts_data[i]["itmCoordinates"]));
			}
		}
		
		fn_init_draw_image_for_tab(_active_inptBlGrpNo, _active_imexHisCd, _active_inptTaskId, _active_spdKind, _active_inptElmtId);
		fn_selected_blink(inform);
		
	} else if (_sanctionRstListTable_data && 'SANC' == _active_spdKind) {
		
		var _sanctionRstListTable_data = sanctionRstListTable.row('.selected').data();
		var _inptSanctionNo = $(_sanctionRstListTable_data[3]).attr('data-inptSanctionNo');
		
		for(var i in img_Cdnts_data) {
			
			if (_active_spdKind == img_Cdnts_data[i]["spdKind"] && 
					_inptSanctionNo == img_Cdnts_data[i]["inptSanctionNo"] && 
					_active_inptTaskId == img_Cdnts_data[i]["inptTaskId"] && 
					_active_inptElmtId == img_Cdnts_data[i]["inptElmtId"] && 
					_active_imexHisCd == img_Cdnts_data[i]["imexHisCd"]) {
				
				inform.push(JSON.parse(img_Cdnts_data[i]["itmCoordinates"]));
			}
		}	
		
		//이미지 초기화
		fn_init_draw_image_for_tab(_active_inptBlGrpNo, _active_imexHisCd, _active_inptTaskId, _active_spdKind, _active_inptElmtId);
		fn_selected_blink(inform);
		
	} else {
		
		//하이라이트 초기화
		fn_init_draw_image_for_tab(_active_inptBlGrpNo, _active_imexHisCd, _active_inptTaskId, _active_spdKind, _active_inptElmtId);
		
	}
}

//이미지호출 전 데이터 세팅
setCallImgData = function() {
	
	//이미지정보
	var _active_inptTaskId = $('#active_inptTaskId').val();
	var _active_inptElmtId = $('#active_inptElmtId').val();
	var _active_imexHisCd = $('#active_imexHisCd').val();
	//spdKind 받기
	var _active_spdKind = $('#active_spdKind').val();
	//inptBlGrpNo 받기
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	fn_init_draw_image(_active_inptBlGrpNo, _active_imexHisCd, _active_inptTaskId, _active_spdKind, _active_inptElmtId);
	
	//하이라이트 세팅
	setBlink(_active_spdKind, _active_inptTaskId, _active_inptElmtId, _active_imexHisCd);
	
}


//심사결과 selectbox 생성
setInptRstCd = function(inptRstCdList_data) {
	
	$('#totalTextStcdList_select').empty();
	$('#itmInptlStcd_select').empty();
	
	var _aiInptCmnCd = "";
	
	if ('80' == inpt_atvt_cd || '90' == inpt_atvt_cd) {
		
		$("#totalTextStcdList_select").append('<option value="notSelected">선택</option>');
		$("#itmInptlStcdList_select").append('<option value="notSelected">선택</option>');
		
	}
	
	for(var i in inptRstCdList_data) {
		
		_aiInptCmnCd = inptRstCdList_data[i]["aiInptCmnCd"]

		
		// option 추가
		if ('20' != _aiInptCmnCd) {
			$("#totalTextStcdList_select").append('<option id=select_' + _aiInptCmnCd + ' value=' + _aiInptCmnCd + '>' + inptRstCdList_data[i]["aiInptCmnCdEngNm"] + '</option>');
		}
		
	}
	
	for(var i in inptRstCdList_data) {
		
		_aiInptCmnCd = inptRstCdList_data[i]["aiInptCmnCd"]
		
		
		// option 추가
		if ('30' == _aiInptCmnCd || '40' == _aiInptCmnCd) {
			$("#itmInptlStcdList_select").append('<option id=select_' + _aiInptCmnCd + ' value=' + _aiInptCmnCd + '>' + inptRstCdList_data[i]["aiInptCmnCdEngNm"] + '</option>');
		}
		
	}
	
	//심사결과코드 세팅
	setMstInptRstCd(appvRecode_data);
}


//심사결과코드 세팅
setMstInptRstCd = function(appvRecode_data){
	
	var _totalText_val = appvRecode_data[0]['mstTotaltextAiInptRstCd'];
	var _santion_val = appvRecode_data[0]['mstItmInptAiInptRstCd'];
	
	$("#totalTextStcdList_select").val(_totalText_val);
	$("#itmInptlStcdList_select").val(_santion_val);
	
	if ('100' == inpt_atvt_cd || '110' == inpt_atvt_cd ||'120' == inpt_atvt_cd 
			||'130' == inpt_atvt_cd ||'140' == inpt_atvt_cd ||'150' == inpt_atvt_cd) {
		
		var _totalTextStcd_nm = $('#totalTextStcdList_select option:selected').text();
		var _itmInptlStcd_nm = $('#itmInptlStcdList_select option:selected').text();
		
		$('#totalTextStcd_zone').empty();
		$('#itmInptlStcd_zone').empty();
		
		$('#totalTextStcd_zone').append('<p class="mb-0 mt-2">' + _totalTextStcd_nm + '</p>');
		$('#itmInptlStcd_zone').append('<p class="mb-0 mt-2">' + _itmInptlStcd_nm + '</p>');
		
	} else {
		
		if ('20' == _totalText_val) {
	
			$("#totalTextStcdList_select").val('notSelected');
			$('#totalTextStcdList_select').prop('disabled', true);
		
		}
	
		if ('10' == _santion_val || '20' == _santion_val) {
		
			$("#itmInptlStcdList_select").val('notSelected');
			$('#itmInptlStcdList_select').prop('disabled', true);
		
		}
	}
	
	
}


//문서분류 selectbox 생성
setImexHisCd = function(imexHisCdList_data) {
	
	//item 그리기
	$('#item_select').empty();
	
	for(var i in imexHisCdList_data) {
			
		// option 추가
		$("#item_select").append('<option id=select_' + imexHisCdList_data[i]["aiInptCmnCd"] + ' value=' + imexHisCdList_data[i]["aiInptCmnCd"] + '>' + imexHisCdList_data[i]["aiInptCmnCdEngNm"] + '</option>');
	}
}


//항목심사 테이블 초기화
initSanctionRstTable = function(sanctionRstListData){
	sanctionRstListTable = $(sanctionRstTableId).DataTable({
		data: sanctionRstListData,
		pageLength: 1000,
//		fixedHeader: {
//			header: true
//		},
        dom: '<"datatable-scroll"><"datatable-footer">',
        columnDefs: [{ 
            orderable: true,
            sortable: true,
            className:'text-left',
            targets: '_all'
        }],
        columns: [
        	{title: '번호'},
        	{title: '불일치'},
        	{title: '보정전'},
        	{title: '항목'},
        	{title: '항목내용'},
        	{title: 'Alert내용'},
        	{title: '수기입력'}
        ],
        createdRow: function(aRow, aData, row, data, dataIndex){
        	
        	if ('Y' == aData[7]) {
        		$(aRow).addClass('rowHandwriting');
        	}
        }
    });
};


//TotalText 테이블 초기화
initTotalTextRstTable = function(totalTextRstListData){
	totalTextRstListTable = $(totalTextRstTableId).DataTable({
		data: totalTextRstListData,
		autoWidth: true,
		pageLength: 1000,
//		fixedHeader: {
//			header: true
//		},
        dom: '<"datatable-scroll"><"datatable-footer">',
        columnDefs: [{ 
            orderable: true,
            sortable: true,
            className:'text-left',
            targets: '_all'
        }],
        columns: [
        	{title: '번호'},
        	{title: '문서분류'},
        	{title: '보정전'},
        	{title: '추출내용'},
        	{title: 'Alert내용'}
        ]
    });
};


//이미지 페이징버튼 생성 
setImgPageBtn = function(){
	
	//이미지 페이징버튼, 변수초기화
	$('#img_index_btn').empty();
	var _btn_html = "";
	var _index;
	var _imexHisCd = "";
	var _inptElmtId ="";
	var _inptTaskId = "";
	
	//선택된 bl 정보
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_spdKind = $('#active_spdKind').val();
	
	for(var i in imglist) {
		
		_imexHisCd = imglist[i]["imexHisCd"]? imglist[i]["imexHisCd"] : '';
		_inptElmtId = imglist[i]["inptElmtId"]? imglist[i]["inptElmtId"] : '';
		_inptTaskId = imglist[i]["inptTaskId"]? imglist[i]["inptTaskId"] : '';
		
		_index = parseInt(i) + 1;
		_btn_html = "";
		
		_btn_html += '<button data-imexHisCd="' + _imexHisCd + '" data-inptElmtId="' + _inptElmtId + '" data-inptTaskId="' + _inptTaskId + '" id="btn_index_' + _index + '" class="btn btn-secondary img-index-btn m-1" type="button">' + _index + '</button>';
		$('#img_index_btn').append(_btn_html);
		
		if ("0" == i) {
			$('#btn_index_' + _index).removeClass('btn-secondary');
			$('#btn_index_' + _index).addClass('btn btn-primary');
			$('#active_inptTaskId').val(_inptTaskId);
			$('#active_inptElmtId').val(_inptElmtId);
			$('#active_imexHisCd').val(_imexHisCd);
			
			//이미지호출 전 데이터 세팅
			setCallImgData();
		}
	}
}


//이미지  정보 세팅
setImgInfo = function(inptBlGrpNo, imexHisCd){
	
	imglist = [];
	
	for(var i in img_pageInfo_data) {
		
		//이미지 정보 검색 조건
		if (inptBlGrpNo == img_pageInfo_data[i]["inptBlGrpNo"] && 
				imexHisCd == img_pageInfo_data[i]["imexHisCd"]) {
			
			var _tmp_data = [];
			
			var _tmp_data = {
				"inptElmtId" : img_pageInfo_data[i]["inptElmtId"],
				"inptTaskId" : img_pageInfo_data[i]["inptTaskId"],
				"imexHisCd" : img_pageInfo_data[i]["imexHisCd"]
			};
			
			imglist.push(_tmp_data);
		}
	}
	
	//이미지 페이징 초기세팅
	setImgPageBtn();
}


//item 생성
setItem = function(left_tab_data) {
	
	//item 그리기
	$('#item_list').empty();

	//선택된 bl 정보
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	for(var i in left_tab_data) {
		
		if (_active_inptBlGrpNo == left_tab_data[i]["inptBlGrpNo"]) {
			
			var _item_html = "";
			
			_item_html += '<a id="item_' + i + '" class="nav-link item-link item-span" data-imexHisCd = "' + left_tab_data[i]['imexHisCd'] + '" data-inptTaskId = "' + left_tab_data[i]['inptTaskId'] + '" data-inptElmtId = "' + left_tab_data[i]['inptElmtId'] + '" href="#">';
			
			var _item_status = left_tab_data[i]["aiInptAltYn"];
			
			if("N" == _item_status) {

				_item_html += '<span class="badge badge-success mr-1">';
			
			} else {
				
				_item_html += '<span class="badge badge-danger mr-1">';
			
			}
			_item_html += '<i class="fa fa-circle-o"></i>';
			_item_html += '</span>' + left_tab_data[i]["imexHisNm"];
			_item_html += '</a> ';
			
			$('#item_list').append(_item_html);
		}
	}

	$('#item_list').children().first().addClass('item-active');
	
	//inptTaskId 받기
	var _selected_inptTaskId = $('#item_list').children().first().attr('data-inptTaskId');
	//inptElmtId 받기
	var _selected_inptElmtId = $('#item_list').children().first().attr('data-inptElmtId');
	//imexHisCd 받기
	var _selected_imexHisCd = $('#item_list').children().first().attr('data-imexHisCd');
	//inptBlGrpNo 받기
	var _selected_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	//이미지정보 저장
	$('#active_inptTaskId').val(_selected_inptTaskId);
	$('#active_inptElmtId').val(_selected_inptElmtId);
	$('#active_imexHisCd').val(_selected_imexHisCd);
	
	//이미지 초기세팅
	setImgInfo(_selected_inptBlGrpNo, _selected_imexHisCd);
	
}


//bl 생성
setBl = function(top_tab_data) {
	
	//bl 그리기
	$('#bl_list').empty();
	
	for(var i in top_tab_data) {
			
		var _bl_html = "";
		
		_bl_html += '<li class="nav-item">';
		_bl_html += '<a  id="bl_' + i + '" data-inptBlGrpNo = "' + top_tab_data[i]['inptBlGrpNo'] + '" class="nav-link bl-link bl-span" href="#">';
		_bl_html += '<i class="icon-calculator"></i> ' + top_tab_data[i]['blTabNm'];
		_bl_html += '</a>';
		_bl_html += '</li>';
		
		$('#bl_list').append(_bl_html);
		
		if(i == 0){
			$('#bl_' + i).addClass('active');
			$('#active_inptBlGrpNo').val(top_tab_data[i]['inptBlGrpNo']);
		}
	}
	
	//item 생성(left_tab_data)
	setItem(left_tab_data);
}


//url에서 파라미터 받아오기
getUrlVars = function() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}


//url에서 파라미터 받아오기
g_getUrlVar = function(varName) {
	return getUrlVars()[varName];
}

$(function() {
	
	
});


