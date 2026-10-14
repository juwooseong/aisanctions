/* ===================== 전역변수 ========================  */
// 로그데이터
var logData = [];
// 포커스 위치
var focusSelect = "";
// 전달내용
var orgOpiText = "";
// 회전값
var rotateVal = 360;
// 심사상세 관련 모든  데이터
var $globaObjlData = null;
var globalInptMstSrno = "";
var globalChangeData = "N";
// 심사상세를 호출 타입 : A(심사자), B(심사-결재자), C(QA담당자), D(QA-결재자), E(심사 only Read), F(QA only Read)
var globalCallType = "";
// 문서분류별 이미지 순서
var globalImgIndex = [];
// 문서분류별 이미지 목록
var globalImglist = [];
// 이미지 좌표 데이터
var globalImgCdntsData = [];
// 이미지 좌표정보
var globalInform = [];
// 이미지 인덱스
var globalImgNo = 0;
// 이미지 페이지번호
var globalImgPageNo = 1;
// 이미지 총페이지번호
var globalImgPageSize = 1;
// 이미지 품질점수
var globalQltScre = "";
// 이미지 키
var globalImgKeyNo = "";
// totalText dataTable ID
var globalSafeWatchTableId = '#safeWatchRstTable';
// SafeWatch dataTable
var globalSafeWatchRstListTable = null;
// totalText dataTable Data
var globalSafeWatchRstListData = [];
// totalText dataTable
var globalTotalTextRstTableId = '#totalTextRstTable';
// SafeWatch dataTable
var globalTotalTextRstListTable = null;
// totalText dataTable Data
var globalTotalTextRstListData = [];
// 항목심사 dataTable ID
var globalSanctionRstTableId = '#sanctionRstTable';
// 항목심사 dataTable
var globalSanctionRstListTable = null;
// 항목심사 dataTable Data
var globalSanctionRstListData = [];
// 전달정보 dataTable ID
var globalAppvRecodeTableId = '#appvRecodeTable';
// 전달정보 dataTable
var globalAppvRecodeTable = null;
// 항목심사 dataTable Data
var globalAppvRecodeListData = [];
// 
var globalImexHisCdChgImgInfo = null;
// 마우스 켄버스 오버 구분 변수
var moueUp = false;
// 화면 임시저장 여부
var globalSaveYn = "N";
// 강조 항목 코드
//국가코드 자동세팅 코드데이터
var boldCodeData = [
	'50',
	'51',
	'54',
	'57',
	'60',
	'63',
	'66',
	'70',
	'74',
	'78',
	'82',
	'86',
	'15',
	'19',
	'53',
	'28',
	'38',
	'89',
	'93',
	'23',
	'33',
	'43'
];

/* ===================== 선언식 함수 ========================  */
 
initLoadingDisplay("Y", "class", "app-body");

var sectionViewResize = function() {
	
	var _sc = $('.section_cate').width();
	var _ww = $('.section_wrapper').width() - 60;
	$('.section_view').css('width' ,(_ww - _sc - 50) + 'px');
	
}

// url에서 파라미터 받아오기
var getUrlVars = function() {
    return pageParams; // getUrlVars()[inptMstSrno];
}

// url에서 파라미터 받아오기
var g_getUrlVar = function(varName) {
	return getUrlVars()[varName];
}

/* ===================== 표현식 함수 시작 ========================  */

// 브라우저 줌 설정
function fn_defaultZoom() {
	
	//줌 비율
	zoom_rate = 1;
	
	//브라우저에 설정된 Zoom Level
	var zoomLevel = Math.round(window.devicePixelRatio * 100);
	
	//브라우저에 설정된 Zoom Level 에 상관없이 화면 Zoom Level 고정하는 것
	document.body.style.zoom =   100 / zoomLevel * 100 * zoom_rate  + '%';
}

// 이미지 확대/축소
function fn_Zoom(val) {
	
	var _type = "";
	
	if (rotateVal % 180 == 0) {
		_type = "vertical";
	} else {
		_type = "horizon";
	}
	
	fn_zoom_image(val, rotateVal, _type);
};

//이미지 회전
function fn_rotate(val) {
	
	var _type = "";
	
	if (val == "r") {
		rotateVal += 90;
	} else {
		rotateVal -= 90;
		
		if (rotateVal < 0) {
			rotateVal += 360;
		}
	}
	
	if (rotateVal % 180 == 0) {
		_type = "vertical";
	} else {
		_type = "horizon";
	}
	
	fn_rotate_img(rotateVal, _type, 1, "rotate");
};

// 팝업 open될 때 심사상세 정보 조회
function fn_getBLData(_callType) {
	
	// 이미지 인덱스
	globalImgNo = 0;
	// 이미지 페이지번호
	globalImgPageNo = 1;
	// 이미지 총페이지번호
	globalImgPageSize = 1;
	
	// 회전값
	rotateVal = 360;
	
	s_loading();
	
	var pros_data = {
			inptMstSrno: g_getUrlVar('inptMstSrno').replace('#', ''),
			detailCallType : _callType,
			aiInptCnctScrnNo : "1011",
			aiInptCnctActiCd : "01",
			aiInptCnctParmTxt : $.param({inptMstSrno : g_getUrlVar('inptMstSrno').replace('#', '')}),
			btnFlag : _callType
	};
	
	$.ajax({
		url : "/api/common/detail/load",
		type : "post",
		cache: false,
		async : true,
		data : pros_data,			
		dataType: "json",
		success : function(data) {
			
			if(data.resultCode=="200"){
				
				globalImexHisCdChgImgInfo = null;
				$globaObjlData = data;
				globalCallType = _callType;
				globalInptMstSrno = $globaObjlData.selectStdInfo.inptMstSrno.toString();
				globalQltScre = $globaObjlData.selectStdInfo.aiInptPapsQltScre;
				globalImgKeyNo = $globaObjlData.selectStdInfo.aiInptImgKeyNo;
				globalImgCdntsData = $globaObjlData.imgCdnts;
				var _active_spdKind = $('#tab_list').find('.active').attr('data-spdkind');
				$('#active_spdKind').val(_active_spdKind);
				
				//켄버스함수 초기화
				fn_init();

				// dataTable 생성
				fn_dataTableComplete();
				
				//문서분류 생성
				if(globalCallType == "A") {
					fn_setImexHisCdSelectBox();
				}
				
				// 전달정보 전달이력 초기화
				fn_setOpiHisData();
				
				// 전달정보 임시저장 데이터 초기화
				if(globalCallType != "E" && globalCallType != "F"){
					fn_setOpiData();
				}
				
				// 버튼생성
				$('#left_btn_zone, #center_btn_zone, #right_btn_zone').empty();
				if(globalCallType == "A" || globalCallType == "B" || globalCallType == "C" || globalCallType == "D" || globalCallType == "E" || globalCallType == "F") {
					fn_setBtn();
				}
				
				// 심사결과 생성 및 전달정보 Tab Data Bind
				fn_setInptRstCdSelectBox();
				
				//BL탭(Top Tab) 그리기
				fn_setBl();
				
				// 이미지 순서 정보
				var _imgIndex = 1;
				var _tmpImexHisCd = "00";
				var _arrimgPageInfo = $globaObjlData.imgPageInfo;
				
				for(var i in _arrimgPageInfo) {
					
					if (_arrimgPageInfo[i].imexHisCd != _tmpImexHisCd) {
						_imgIndex = 1;
						_tmpImexHisCd = _arrimgPageInfo[i].imexHisCd;
					}
					
					globalImgIndex["index_" + (_arrimgPageInfo[i].inptTaskId)] = _imgIndex;
					
					
					_imgIndex ++ ;
				}
				
			} else {
				fnAlertErrorMsg(data, true);
			}
		},
		error : function(e) {
			alert('정보조회가 실패했습니다.');
			
		},
		complete: function() {
			
			h_loading();
			globalChangeData = 'N';
			
		}

	});	
}


//BL탭(Top Tab) 생성
function fn_setBl(_arrTobTab) {
	var _arrTobTab = $globaObjlData.topTab;
	var _strHtml = "";
	var _selectHtml = "";
	
	if(_arrTobTab.length > 0) {
		for(var i in _arrTobTab) {
			_strHtml += '<a id="bl_' + i + '" data-inptBlGrpNo="' + _arrTobTab[i].inptBlGrpNo + '" class="nav-link bl-link bl-span" href="#" onclick="fn_blTabClickEvt(this);">';
			_strHtml += _arrTobTab[i].blTabNm;
			_strHtml += '</a>';
			_selectHtml += '<option id="select_bl_' + _arrTobTab[i].inptBlGrpNo + '" class="bl_option" value="' + _arrTobTab[i].inptBlGrpNo + '">' + _arrTobTab[i].blTabNm + '</option>';
		}
		
		$('#bl_list').empty().append(_strHtml);
		
		$('#bl_0').addClass('bl-link_active');
		$('#bl_0').addClass('active');
		$('#active_inptBlGrpNo').val(_arrTobTab[0].inptBlGrpNo);
	}
	
	$('#bl_select').empty().append(_selectHtml);
	
	// Totaltext dataTable Data Bind
	if($globaObjlData.totalTextRst) {
		
		if($globaObjlData.totalTextRst.length > 0) {
			
			fn_setTotalTextRst();
		}
	}
	
	// 항목심사 dataTable Data Bind
	if($globaObjlData.sanctionRst) {
		
		if($globaObjlData.sanctionRst.length > 0) {
			
			fn_setSanctionRst();
		}
	}
	
	// SafeWatch 테이블(safeWatchRst_data)
	if($globaObjlData.safeWatchRst) {
		
		if($globaObjlData.safeWatchRst.length > 0) {
			
			fn_setSafeWatchRst();
		}
	}
	
	// title 높이 조정
	$('.title').height($('#bl_list').height());
	
	// 문서분류 Tab 생성
	fn_setItem();
}

//문서분류 Tab 생성
function fn_setItem() {
	//선택된 bl 정보
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
//	$('.card-body').append('<p>0._activeInptBlGrpNo=' + _activeInptBlGrpNo + '</p>');
	var _arrLeftTab = $globaObjlData.leftTab;
	var _itemStatus = "";
	var _strHtml = "";
	var _indexNo = 0;
	for(var i in _arrLeftTab) {
		if(_activeInptBlGrpNo == _arrLeftTab[i].inptBlGrpNo) {
			
			_strHtml += '<li id="hisCd_' + _arrLeftTab[i].imexHisCd + '">';
			
			_itemStatus = _arrLeftTab[i].aiInptAltYn;
			
			if(_itemStatus == "N") {
				_strHtml += '<span class="circle green"></span>';
			} else {
				_strHtml += '<span class="circle red"></span>';
			}
			
			_strHtml += '<a id="item_' + _indexNo + '" class="nav-link item-link item-span" data-imexHisCd="' + _arrLeftTab[i].imexHisCd + '" data-inptTaskId="' + _arrLeftTab[i].inptTaskId + '" data-inptElmtId="' + _arrLeftTab[i].inptElmtId + '" data-imexHisNm="' + _arrLeftTab[i].imexHisNm + '" data-newImexHisCd="noData" onclick="fn_itemClickEvt(this);" href="#"  data-toggle="tooltip" data-placement="top" title="' + _arrLeftTab[i].imexHisNm +'">';
			_strHtml += _arrLeftTab[i].imexhissAbbr;
			_strHtml += '</a>';
			
			_strHtml += '</li>';
			
			_indexNo++;
		}
	}
	
	$('#item_list').empty().append(_strHtml);
	
	var _selectedImexHisCd;
	var _selectedImexHisNm;
	
	if(globalImexHisCdChgImgInfo == null) {
		$('#item_list').children().first().find('a').addClass('item-active');
		//imexHisCd 받기
		_selectedImexHisCd = $('#item_list').children().first().find('a').attr('data-imexHisCd');
		_selectedImexHisNm = $('#item_list').children().first().find('a').attr('data-imexHisNm');
	} else {
		$('#item_list').find('.item-link').each(function() {
			if(globalImexHisCdChgImgInfo.imexHisCd == $(this).attr('data-imexHisCd')) {
				$(this).addClass('item-active');
			}
		});
		
		_selectedImexHisCd = globalImexHisCdChgImgInfo.imexHisCd;
		_selectedImexHisNm = globalImexHisCdChgImgInfo.imexHisNm;
	}
	
	
	if(globalCallType == "A") {
		
		$('#item_select').val(_selectedImexHisCd);
		
	} else {
		
		$('#item_select').text(_selectedImexHisNm);
		
	}
	
	var _newBlNo = parseInt($('#bl_select option:last').val()) + 1;
	var _newHtml = "";
	
	if (_selectedImexHisCd == "01") {
		
		$('#bl_select').prop('disabled', false);
		
		if ($('#new_bl').length == 0) {
			_newHtml += "<option id='new_bl' value='" + _newBlNo + "'>신규</option>";
			$('#bl_select').append(_newHtml);
		}
		
	} else {
		
		$('#bl_select').prop('disabled', true);
		
		if ($('#new_bl').length > 0) {
			$('#new_bl').remove();
		}
	}
	
	$('#bl_select').val(_activeInptBlGrpNo);
	
	fn_setImgInfo(_activeInptBlGrpNo, _selectedImexHisCd, "0");
}


//임시저장 후 데이터 재조회
function fn_getReBLData() {
	
	s_loading();
	
	var pros_data = {
			inptMstSrno: globalInptMstSrno,
			detailCallType : globalCallType,
			aiInptCnctScrnNo : "1011",
			aiInptCnctActiCd : "01",
			aiInptCnctParmTxt : $.param({inptMstSrno : g_getUrlVar('inptMstSrno').replace('#', '')})
	};
	
	$.ajax({
		url : "/api/common/detail/reload",
		type : "post",
		cache: false,
		async : false,
		data : pros_data ,			
		dataType: "json",
		success : function(data) {
			
			if(data.resultCode=="200"){
				
				globalImexHisCdChgImgInfo = null;
				$globaObjlData.selectStdInfo = data.selectStdInfo;
				$globaObjlData.sanctionRst = data.sanctionRst;
				$globaObjlData.selectOpiHis = data.selectOpiHis;
				$globaObjlData.selectOpi = data.selectOpi;
				
				fn_setMstInptRstCd();
				
				// Totaltext dataTable Data Bind
				if($globaObjlData.totalTextRst) {
					
					if($globaObjlData.totalTextRst.length > 0) {
						
						fn_setTotalTextRst();
					}
				}
				
				// 항목심사 dataTable Data Bind
				if($globaObjlData.sanctionRst) {

					if($globaObjlData.sanctionRst.length > 0) {

						fn_setSanctionRst();
					}
				}
				
				// SafeWatch 테이블(safeWatchRst_data)
				if($globaObjlData.safeWatchRst) {
					
					if($globaObjlData.safeWatchRst.length > 0) {
						
						fn_setSafeWatchRst();
					}
				}
				
				// 전달정보 전달이력 초기화
				fn_setOpiHisData();
				
				// 전달정보 임시저장 데이터 초기화
				if(globalCallType != "E" && globalCallType != "F"){
					fn_setOpiData();
				}
				// 버튼생성
				$('#left_btn_zone, #center_btn_zone, #right_btn_zone').empty();
				if(globalCallType == "A" || globalCallType == "B" || globalCallType == "C" || globalCallType == "D") {
					fn_setBtn();
				}
				
			} else {
				fnAlertErrorMsg(data, true);
			}
			
			
		},
		error : function(e) {
			alert('정보조회가 실패했습니다.');
		},
		complete: function() {
			
			h_loading();
			globalChangeData = 'N';
			
		}

	});	
}

// safrwatch 데이터 재조회
function fn_getSafewatchData() {
	
	var pros_data = {
			inptMstSrno: globalInptMstSrno,
			detailCallType : globalCallType,
			aiInptCnctScrnNo : "1011",
			aiInptCnctActiCd : "01",
			aiInptCnctParmTxt : $.param({inptMstSrno : g_getUrlVar('inptMstSrno').replace('#', '')})
	};
	
	s_loading();
	
	$.ajax({
		url : "/api/common/detail/safeWatchload",
		type : "post",
		cache: false,
		async : false,
		data : pros_data ,			
		dataType: "json",
		success : function(data) {
			
			if(data.resultCode=="200"){
				
				// SafeWatch 테이블(safeWatchRst_data)
				if(data.safeWatchRst) {
					
					if(data.safeWatchRst.length > 0) {
						
						$globaObjlData.safeWatchRst = data.safeWatchRst;
						
						fn_setSafeWatchRst();
					}
				}
				
				
				if(data.selectStdInfo) {
					
					$globaObjlData.selectStdInfo = data.selectStdInfo;
					
					var _objStdInfo = $globaObjlData.selectStdInfo;
					var _swVal = _objStdInfo.safewatchAiInptRstCd;
					var _swNm = _objStdInfo.swNm;
						
					$("#sw_select").val(_swVal);
					$('#sw_zone').empty().append('<label class="col-form-label text-left">' + _swNm + '</label>');
						
				}
				
			} else {
				fnAlertErrorMsg(data, true);
			}
			
			
		},
		error : function(e) {
			alert('정보조회가 실패했습니다.');
		},
		complete: function() {
			
			h_loading();
			globalChangeData = 'N';
			
		}
		
	});	
}

// dataTable 생성
function fn_dataTableComplete() {
	
	// 테이블 높이 조정
	var _tableHight = 0;
	if (globalCallType == "E" || globalCallType == "F") {
		_tableHight = 107;
	}
	
	globalSafeWatchRstListTable = $(globalSafeWatchTableId).DataTable({
		data: globalAppvRecodeListData,
		autoWidth: true,
		pageLength: 1000,
		scrollY: 124,
		scrollX: true,
		scrollXInner: '100%',
		paging: false,
		info: false,
		filter: false,
		length: false,
		columnDefs: [
			{ targets: 0, className: 'td-text-center' },
			{ targets: 1, className: 'td-text-center' },
			{ targets: 2, className: 'td-text-center' },
			{ targets: 3, className: 'td-text-center' },
			{ targets: 4, className: 'td-text-center' },
			{ targets: 5, className: 'td-text-center' },
    		{ targets: 6, visible: false }
		],
		columns: [
			{title: '번호', className: 'td-text-center td-text-30'},
			{title: 'BL그룹', className: 'td-text-center td-text-40'},
			{title: 'BL번호', className: 'td-text-left td-text-100'},
			{title: '필터링결과', className: 'td-text-center td-text-60'},
			{title: 'Detection ID', className: 'td-text-center td-text-80'},
			{title: '심사일시', className: 'td-text-center td-text-100'}
		],
        createdRow: function(aRow, aData, row, data, dataIndex){
        	if("N" == aData[6]) {
        		$(aRow).css('background-color', "#e8e8e8;");
        	}
        }
	});
	
	globalAppvRecodeTable = $(globalAppvRecodeTableId).DataTable({
		data: globalAppvRecodeListData,
		autoWidth: true,
		pageLength: 1000,
		scrollY: 524 + _tableHight,
		scrollX: true,
		scrollXInner: '100%',
		paging: false,
		info: false,
		filter: false,
		length: false,
		columnDefs: [
			{ targets: 0, className: 'td-text-center' },
			{ targets: 1, className: 'td-text-center' },
			{ targets: 2, className: 'td-text-center' },
			{ targets: 3, className: 'td-text-center' },
			{ targets: 4, className: 'td-text-center' }
		],
		columns: [
			{title: '번호', className: 'td-text-center td-text-30'},
			{title: '구분', className: 'td-text-center td-text-60'},
			{title: '전달일', className: 'td-text-center td-text-60'},
			{title: '전달자', className: 'td-text-left td-text-60'},
			{title: '전달정보', className: 'td-text-left td-text-200 text-wrap'}
		]
	});
	
	globalTotalTextRstListTable = $(globalTotalTextRstTableId).DataTable({
		data: globalTotalTextRstListData,
		autoWidth: true,
		pageLength: 1000,
		scrollY: 380 + _tableHight,
		scrollX: true,
		scrollXInner: '100%',
		paging: false,
		info: false,
		filter: false,
		length: false,
        columnDefs: [
        	{ targets: 0, className: 'td-text-center' },
        	{ targets: 1, className: 'td-text-center' },
        	{ targets: 2, className: 'td-text-center' },
        	{ targets: 3, className: 'td-text-center' },
        	{ targets: 4, className: 'td-text-center' },
    		{ targets: 5, visible: false },
    		{ targets: 6, visible: false },
    		{ targets: 7, visible: false }
        ],
        columns: [
        	{title: '번호', className: 'td-text-center td-text-30'},
        	{title: '문서분류', className: 'td-text-left td-text-100 text-wrap'},
        	{title: '텍스트', className: 'td-text-left td-text-100 text-wrap' },
        	{title: '추출내용', className: 'td-text-left td-text-100 text-wrap' },
        	{title: 'Alert내용', className: 'td-text-left td-text-100 text-wrap' }
        ],
        createdRow: function(aRow, aData, row, data, dataIndex){
    		$(aRow).find('td:eq(4)').css('color', "red");
        }
    });

	globalSanctionRstListTable = $(globalSanctionRstTableId).DataTable({
		data: globalSanctionRstListData,
		pageLength: 1000,
		scrollY: 611 + _tableHight,
		scrollX: true,
		scrollXInner: '100%',
		paging: false,
		info: false,
		filter: false,
		length: false,
        columnDefs: [
        	{ targets: 0, className: 'td-text-center' },
        	{ targets: 1, className: 'td-text-center',
        		render: function (data, type, fule, meta) {

        			var _i_data = "";

	      			if (data == "Y") {
	      				_i_data = '<span class="nacrd-y nacrd_modal" data-toggle="modal" data-target="#nacrd_modal" type="button"></span>';
	      			}

      				return _i_data;
    			}
        	},
        	{ targets: 2, className: 'td-text-center',
        		render: function (data, type, fule, meta) {

        			var _i_data = "";

      				_i_data = '<span> ' + data + '</span>';

      				return _i_data;
    			}
        	},
        	{ targets: 3, className: 'td-text-center' },
        	{ targets: 4, className: 'td-text-center', render:
        		function (data, type, fule, meta) {
        		return data; }
        	},
        	{ targets: 5, className: 'td-text-center' },
        	{ targets: 6, className: 'td-text-center' },
        	{ targets: 7, visible: false },
        	{ targets: 8, visible: false },
        	{ targets: 9, visible: false },
        	{ targets: 10, visible: false },
        	{ targets: 11, visible: false },
        	{ targets: 12, visible: false }
        ],
        columns: [
        	{title: 'No', className: 'td-text-center td-text-26' },
        	{title: '≠', className: 'td-text-center td-text-10' },
        	{title: '항목', className: 'td-text-left td-text-140 text-wrap' },
        	{title: '항목내용', className: 'td-text-left td-text-200 text-wrap' },
        	{title: '수기입력', className: 'td-text-left td-text-400' },
        	{title: 'Alert내용', className: 'td-text-left td-text-140 text-wrap' },
        	{title: '', className: 'td-text-center td-text-20' },
        ],
        createdRow: function(aRow, aData, row, data, dataIndex){
        	if("Y" == aData[7]) {
        		$(aRow).addClass('rowHandwriting');
        		$(aRow).find('td:eq(5)').css('color', "red");
        	}
        	if(boldCodeData.indexOf(aData[8]) > -1) {
        		$(aRow).find('td:eq(2)').find('span').css('font-weight', "700");
        		$(aRow).find('td:eq(2)').find('span').css('background-color', "#fff7ac");
        		$(aRow).find('td:eq(2)').find('span').css('padding', "2px");
        	}
        },
    	fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

    		$(nRow).find('td').eq(0).text(iDisplayIndex + 1);
    	}
    });

}

// SafeWatch dataTable Data Bind
function fn_setSafeWatchRst() {
	
	var _arrSafeWatchRst = $globaObjlData.safeWatchRst;
	// 선택된 bl 정보
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	// 변수 초기화
	var _indexNo = 0;
	var _arrData = [];
	var _inptMstSrno = "";
	var _inptBlGrpNo = "";
	var _blNo = "";
	var _swNm = "";
	var _filtDtctDo = "";
	var _filtInptRrstRecpDtm = "";
	var _spdKind = "";
	
	globalSafeWatchRstListData = [];
	
	for(var i in _arrSafeWatchRst) {
		_inptBlGrpNo = (_arrSafeWatchRst[i].inptBlGrpNo != "" && _arrSafeWatchRst[i].inptBlGrpNo != null && _arrSafeWatchRst[i].inptBlGrpNo != "null") ? _arrSafeWatchRst[i].inptBlGrpNo : '-';
		_blNo = (_arrSafeWatchRst[i].blNo != "" && _arrSafeWatchRst[i].blNo != null && _arrSafeWatchRst[i].blNo != "null") ? _arrSafeWatchRst[i].blNo : '-';
		_swNm = (_arrSafeWatchRst[i].swNm != "" && _arrSafeWatchRst[i].swNm != null && _arrSafeWatchRst[i].swNm != "null") ? _arrSafeWatchRst[i].swNm : '-';
		_filtDtctDo = (_arrSafeWatchRst[i].filtDtctDo != "" && _arrSafeWatchRst[i].filtDtctDo != null && _arrSafeWatchRst[i].filtDtctDo != "null") ? _arrSafeWatchRst[i].filtDtctDo : '-';
		_filtInptRrstRecpDtm = (_arrSafeWatchRst[i].filtInptRrstRecpDtm != "" && _arrSafeWatchRst[i].filtInptRrstRecpDtm != null && _arrSafeWatchRst[i].filtInptRrstRecpDtm != "null") ? _arrSafeWatchRst[i].filtInptRrstRecpDtm : '-';
		_spdKind = (_arrSafeWatchRst[i].spdKind != "" && _arrSafeWatchRst[i].spdKind != null && _arrSafeWatchRst[i].spdKind != "null") ? _arrSafeWatchRst[i].spdKind : '-';
		
		_indexNo++;
		
		_arrData = [
			_indexNo,
			_inptBlGrpNo,
			_blNo,
			_swNm,
			_filtDtctDo,
			_filtInptRrstRecpDtm,
			_spdKind
		];
		
		globalSafeWatchRstListData.push(_arrData);
	}
	
	// SafeWatch 테이블 데이터 넣기
	globalSafeWatchRstListTable.clear().draw();
	globalSafeWatchRstListTable.rows.add(globalSafeWatchRstListData).draw();
}

// Totaltext dataTable Data Bind
function fn_setTotalTextRst() {
	
	var _arrTotalTextRst = $globaObjlData.totalTextRst;
	// 선택된 bl 정보
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	// 변수 초기화
	var _indexNo = 0;
	var _arrData = [];
	var _aiInptTotaltextRvsnYn = "";
	var _aiInptTotaltextSrno = "";
	var _imexHisNm = "";
	var _imexHisCd = "";
	var _inptTaskId = "";
	var _inptSanctionDatTxt = "";
	var _bfrsAicrExtcTxt = "";
	var _aiInptSanctionRuleTxt = "";
	
	globalTotalTextRstListData = [];
	
	for(var i in _arrTotalTextRst) {
		if(_activeInptBlGrpNo == _arrTotalTextRst[i].inptBlGrpNo) {
			_aiInptTotaltextRvsnYn = _arrTotalTextRst[i].aiInptTotaltextRvsnYn ? _arrTotalTextRst[i].aiInptTotaltextRvsnYn : '';
			_aiInptTotaltextSrno = _arrTotalTextRst[i].aiInptTotaltextSrno;
			_imexHisNm = _arrTotalTextRst[i].imexHisNm ? _arrTotalTextRst[i].imexHisNm : '';
			_imexHisCd = _arrTotalTextRst[i].imexHisCd ? _arrTotalTextRst[i].imexHisCd : '';
			_inptTaskId = _arrTotalTextRst[i].inptTaskId ? _arrTotalTextRst[i].inptTaskId : '';
			_inptSanctionDatTxt = _arrTotalTextRst[i].inptSanctionDatTxt ? _arrTotalTextRst[i].inptSanctionDatTxt : '';
			_bfrsAicrExtcTxt = _arrTotalTextRst[i].bfrsAicrExtcTxt ? _arrTotalTextRst[i].bfrsAicrExtcTxt : '';
			_aiInptSanctionRuleTxt = _arrTotalTextRst[i].aiInptSanctionRuleTxt ? _arrTotalTextRst[i].aiInptSanctionRuleTxt : '';
			
			_indexNo++;
			
			_arrData = [
				_indexNo,
				_imexHisNm,
				_bfrsAicrExtcTxt,
				_inptSanctionDatTxt,
				_aiInptSanctionRuleTxt,
				_aiInptTotaltextSrno,
				_imexHisCd,
				_inptTaskId
			];
			
			globalTotalTextRstListData.push(_arrData);
		}
	}
	
	// TotalText 테이블 데이터 넣기
	globalTotalTextRstListTable.clear().draw();
	globalTotalTextRstListTable.rows.add(globalTotalTextRstListData).draw();
}

//항목심사 dataTable Data Bind
function fn_setSanctionRst() {
	var _arrSanctionRst = $globaObjlData.sanctionRst;
	// 선택된 bl 정보
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _bl_index_tmp = $('#bl_list').find('a').index($('#bl_list').find('.active'));
	var _bl_count_tmp = $('.bl-link').length;
	var _total_count_tmp = $globaObjlData.sanctionRst.length;
	
	// 항목심사 테이블 변수 초기화
	var _indexNo = _total_count_tmp / _bl_count_tmp * (_bl_index_tmp);
	var _arrData = [];
	var _itmInptNacrdYn = "";
	var _imexHisCd = "";
	var _inptSanctionNo = "";
	var _inptSanctionDatTxt = "";
	var _bfrsTaExtcTxtTag = "";
	var _inptSanctionNm = "";
	var _stRstKind = "";
	var _aiInptSanctionRuleTxt = "";
	var _inptTaskId = "";
	var _itmInptHndgInpDatTxt = "";
	var _aiInptAltYn = "";
	var _itmInptHndgInpDatTxtInputTag = "";
	var _aiInptExtcSntnTxt = "";
	var _concatImexHisCd = "";
	var placeholder = "";
	var ModiBlNumModalId = "";
	var modBlNumId = "";
	var inptSanctionName = ""; 
//	var test = "aa";
	globalSanctionRstListData = [];
	
	//항목심사 테이블 데이터 추가
	for(var i in _arrSanctionRst) {

		if(_activeInptBlGrpNo == _arrSanctionRst[i].inptBlGrpNo) {
			
			_itmInptNacrdYn = _arrSanctionRst[i].itmInptNacrdYn ? _arrSanctionRst[i].itmInptNacrdYn : '';
			_imexHisCd = _arrSanctionRst[i].imexHisCd ? _arrSanctionRst[i].imexHisCd : '';
			_inptSanctionNo = _arrSanctionRst[i].inptSanctionNo ? _arrSanctionRst[i].inptSanctionNo : '';
			_inptSanctionDatTxt = _arrSanctionRst[i].inptSanctionDatTxt ? _arrSanctionRst[i].inptSanctionDatTxt : '';
			_bfrsTaExtcTxt = _arrSanctionRst[i].bfrsTaExtcTxt ? _arrSanctionRst[i].bfrsTaExtcTxt : '';
			_inptSanctionNm = _arrSanctionRst[i].inptSanctionNm ? _arrSanctionRst[i].inptSanctionNm : '';
			_stRstKind = _arrSanctionRst[i].stRstKind ? _arrSanctionRst[i].stRstKind : '';
			_aiInptSanctionRuleTxt = _arrSanctionRst[i].aiInptSanctionRuleTxt ? _arrSanctionRst[i].aiInptSanctionRuleTxt : '';
			_inptTaskId = _arrSanctionRst[i].inptTaskId ? _arrSanctionRst[i].inptTaskId : '';
			_itmInptHndgInpDatTxt = _arrSanctionRst[i].itmInptHndgInpDatTxt ? _arrSanctionRst[i].itmInptHndgInpDatTxt : '';
			_aiInptAltYn = _arrSanctionRst[i].aiInptAltYn ? _arrSanctionRst[i].aiInptAltYn : '';
			_aiInptExtcSntnTxt = _arrSanctionRst[i].aiInptExtcSntnTxt ? _arrSanctionRst[i].aiInptExtcSntnTxt : '';
			_concatImexHisCd = _arrSanctionRst[i].concatImexHisCd ? _arrSanctionRst[i].concatImexHisCd : '';
			_bfrsTaExtcTxtTag = "";
			
			if (globalCallType == "A") {
				if(_inptSanctionNo == ""){
					_inptSanctionNo = 0;
				}
				if(_inptTaskId == ""){
					_inptTaskId = 0;
				}
				
				_itmInptHndgInpDatTxtInputTag = "<input type='text' id='index_" + _indexNo + "' class='form-control itm-inpt-hndg-inp' value='" + fnHtmlEscape(_itmInptHndgInpDatTxt) + "'";
				_itmInptHndgInpDatTxtInputTag += "onchange=fn_itmInptHndgInpDatTextChage(this,this.value," + _inptSanctionNo + "," + _inptTaskId + ","+ _indexNo;
				_itmInptHndgInpDatTxtInputTag += ");>"
					_itmInptHndgInpDatTxtInputTag += "<i class='fa fa-copy fa-lg mt-1 btn-copy' copytype='copy'></i>"
					
			} else {
				 _itmInptHndgInpDatTxtInputTag = _itmInptHndgInpDatTxt;
			}
			
			if ( _inptSanctionDatTxt != "") {
				_bfrsTaExtcTxtTag = '<i class="fa icon-calculator fa-lg mt-1" data-toggle="modal" data-target="#extc_modal" type="button"></i>';
			}
			
			_indexNo++;

			_arrData = [
				_indexNo,
				_itmInptNacrdYn,
				_inptSanctionNm,
				_inptSanctionDatTxt,
				_itmInptHndgInpDatTxtInputTag,
				_aiInptSanctionRuleTxt,
				_bfrsTaExtcTxtTag,
				_aiInptAltYn,
				_inptSanctionNo,
				_imexHisCd,
				_inptTaskId,
				_stRstKind,
				_concatImexHisCd
			];

			globalSanctionRstListData.push(_arrData);
		}
	}
	
	globalSanctionRstListTable.clear().draw();
	globalSanctionRstListTable.rows.add(globalSanctionRstListData).draw();
	
	var _widthVal = 2;
	
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(0).width();
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(1).width();
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(2).width();
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(3).width();
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(4).width();
	_widthVal += $('#sanctionRstTable').find('thead').find('th').eq(5).width();
	
	var _dtfc_width = $('.DTFC_LeftBodyLiner').width();
	$('.DTFC_LeftBodyLiner').css('width', (_dtfc_width + 2) + 'px');
	$('.DTFC_LeftBodyLiner').css("background", "white");
	
	
}

// 문서분류 생성
function fn_setImexHisCdSelectBox() {
	var _arrImexHisCd = $globaObjlData.imexHisCdList;
	var _strHtml = "";
	
	for(var i in _arrImexHisCd) {
		_strHtml += '<option id=select_' + _arrImexHisCd[i]["aiInptCmnCd"] + ' value=' + _arrImexHisCd[i]["aiInptCmnCd"] + ' data-imexhisnm="' + _arrImexHisCd[i].imexhissAbbr + '">' + _arrImexHisCd[i]["aiInptCmnCdEngNm"] + '</option>';
	}
	
	$('#item_select').empty().append(_strHtml);
}

// 심사결과 생성
function fn_setInptRstCdSelectBox() {
	var _objStdInfo = $globaObjlData.selectStdInfo;
	var _arrInptRstCd = $globaObjlData.inptRstCdList;
	var _totalTextVal = _objStdInfo.mstTotaltextAiInptRstCd;
	var _santionVal = _objStdInfo.mstInptItmAiInptRstCd;
	var _qaVal = _objStdInfo.mstQltGrnAiInptRstCd;
	
	var _strTotalTextHtml = "";
	var _strInptlStCdHtml = "";
	var _strQltGrnHtml = "";
	var _strSwHtml = "";
	var _aiInptCmnCd = '';
	
	// 10	완료	Clean
	// 20	대기	Wating
	// 30	경보	Alert
	// 40	해소	Release
	
	if (_totalTextVal == '30') {
		_strTotalTextHtml += '<option id=select_30 value=30>Alert</option>';
		_strTotalTextHtml += '<option id=select_40 value=40>Release</option>';
	} else if (_totalTextVal == '10') {
		_strTotalTextHtml += '<option id=select_10 value=10>Clean</option>';
		_strTotalTextHtml += '<option id=select_30 value=30>Alert</option>';
	} else if (_totalTextVal == '40') {
		_strTotalTextHtml += '<option id=select_30 value=30>Alert</option>';
		_strTotalTextHtml += '<option id=select_40 value=40>Release</option>';
	} else if (_totalTextVal == '20') {
		_strTotalTextHtml += '<option id=select_20 value=20>Wating</option>';
	} else if (_totalTextVal == "" || _totalTextVal == null) {
		
		if ($globaObjlData.totalTextRst.length > 0) {
			_strTotalTextHtml += '<option id=select_30 value=30>Alert</option>';
			_strTotalTextHtml += '<option id=select_40 value=40>Release</option>';
		} else {
			_strTotalTextHtml += '<option id=select_10 value=10>Clean</option>';
			_strTotalTextHtml += '<option id=select_30 value=30>Alert</option>';
		}
	}
	
	if (_santionVal == '30') {
		_strInptlStCdHtml += '<option id=select_30 value=30>Alert</option>';
		_strInptlStCdHtml += '<option id=select_40 value=40>Release</option>';
	} else if (_santionVal == '10') {
		_strInptlStCdHtml += '<option id=select_10 value=10>Clean</option>';
	} else if (_santionVal == '40') {
		_strInptlStCdHtml += '<option id=select_30 value=30>Alert</option>';
		_strInptlStCdHtml += '<option id=select_40 value=40>Release</option>';
	} else if (_santionVal == '20') {
		_strInptlStCdHtml += '<option id=select_20 value=20>Wating</option>';
	}
	
	if (globalCallType == "C" || globalCallType == "D" || globalCallType == "F") {
		_strQltGrnHtml += '<option id=select_10 value=10>적정</option>';
		_strQltGrnHtml += '<option id=select_20 value=20>비적정</option>';
	}
	
	_strSwHtml += '<option id=select_10 value=10>Clean</option>';
	_strSwHtml += '<option id=select_20 value=20>Wating</option>';
	_strSwHtml += '<option id=select_30 value=30>Alert</option>';
	_strSwHtml += '<option id=select_40 value=40>Release</option>';
	
	$('#totalTextStcdList_select').empty().append(_strTotalTextHtml);
	$('#itmInptlStcdList_select').empty().append(_strInptlStCdHtml);
	$('#sw_select').empty().append(_strSwHtml);
	$('#qaStcdList_select').empty().append(_strQltGrnHtml);
	
	// 전달정보 Tab Data Bind
	fn_setMstInptRstCd();
}

// 전달정보 Tab Data Bind
function fn_setMstInptRstCd() {
	var _objStdInfo = $globaObjlData.selectStdInfo;
	var _totalTextVal = _objStdInfo.mstTotaltextAiInptRstCd;
	var _santionVal = _objStdInfo.mstInptItmAiInptRstCd;
	var _swVal = _objStdInfo.safewatchAiInptRstCd;
	var _aiInptQlasProsCd = _objStdInfo.aiInptQlasProsCd;
	var _qaVal = _objStdInfo.mstQltGrnAiInptRstCd;
	
	// Hidden Data Bind
	$('#active_aiInptAppvSrno').val(_objStdInfo.aiInptAppvSrno);
	$('#refNo').text(_objStdInfo.actlFxRefno + '(' + _objStdInfo.inptAtmcBizNm +')');
	if(globalCallType == "C" || globalCallType == "D" || globalCallType == "F") {   // QA인 경우 "3" 강제 set
		$('#active_aiInptBizDscd').val("3");
	} else {
		$('#active_aiInptBizDscd').val(_objStdInfo.aiInptBizDscd);
	}
	
	// View Data Bind
	// 10	완료	Clean
	// 20	대기	Wating
	// 30	경보	Alert
	// 40	해소	Release
	
	$("#sw_select").val(_swVal).prop('disabled', true);
	
	$('#totalTextStcd_zone').empty().append('<label class="col-form-label text-left">' + _objStdInfo.totrstNm + '</label>');
	$('#itmInptlStcd_zone').empty().append('<label class="col-form-label text-left">' + _objStdInfo.itmrstNm + '</label>');
	$('#sw_zone').empty().append('<label class="col-form-label text-left">' + _objStdInfo.swNm + '</label>');
	
	if(_totalTextVal == '20') {
		$("#totalTextStcdList_select").val(_totalTextVal).prop('disabled', true);
	} else if(_totalTextVal == '10') {
		$("#totalTextStcdList_select").val(_totalTextVal);
	} else if(_totalTextVal == '30') {
		$("#totalTextStcdList_select").val(_totalTextVal);
	} else if (_totalTextVal == '40'){
		$("#totalTextStcdList_select").val(_totalTextVal)
	} else if (_totalTextVal == "" || _totalTextVal == null) {
			
		if ($globaObjlData.totalTextRst.length > 0) {
			
			$("#totalTextStcdList_select").val("30");
			
		} else {
			
			$("#totalTextStcdList_select").val("10");
		}
	}
	
	if(_santionVal == '20') {
		$("#itmInptlStcdList_select").val(_santionVal).prop('disabled', true);
	} else if(_santionVal == '10') {
		$("#itmInptlStcdList_select").val(_santionVal).prop('disabled', true);
	} else if(_santionVal == '30') {
		$("#itmInptlStcdList_select").val(_santionVal);
	} else {
		$("#itmInptlStcdList_select").val(_santionVal);
	}
	
	$('#active_mstTotaltextAiInptRstCd').val(_totalTextVal);
	$('#active_mstInptItmAiInptRstCd').val(_santionVal);
	
	if (globalCallType == "C" || globalCallType == "D" || globalCallType == "F") {
		
		if (_qaVal != "" && _qaVal != null) {
			$("#qaStcdList_select").val(_qaVal);
		} else {
			$("#qaStcdList_select").val('10');
		}
		
		// QA프로세스코드별 심사탭 선택
		// 화면에서 임시저장 안했을때
		if (globalSaveYn == "N") {
			$('#tab_list').find('a').removeClass('active');
			$('.tab_item').removeClass('active');
			
			if (_aiInptQlasProsCd == "3") {
				$('a[data-tab="t1"]').click();
			} else if (_aiInptQlasProsCd == "4") {
				$('a[data-tab="t2"]').click();
			} else if (_aiInptQlasProsCd == "5") {
				$('a[data-tab="t1"]').click();
			}
		}
		
		$('#active_mstQltGrnAiInptRstCd').val(_qaVal);
		
		$("#totalTextStcdList_select").prop('disabled', true);
		$("#itmInptlStcdList_select").prop('disabled', true);
	}
	
	if (globalCallType == "E" || globalCallType == "F" || globalCallType == "B" || globalCallType == "D") {
		
		$("#totalTextStcdList_select").prop('disabled', true);
		$("#itmInptlStcdList_select").prop('disabled', true);
		$("#qaStcdList_select").prop('disabled', true);
	}
	
	// 불일치 목록에서 심사자 심사상세 제외한 심사상에에서 적용버튼 삭제
	if (globalCallType != "A") {
		$('#nacrdDataCopyBtn').remove();
	}
}

// 이미지 초기세팅
function fn_setImgInfo(_inptBlGrpNo, _imexHisCd, _inptTaskId) {
	
	var _activeInptTaskId = "0";
	rotateVal = 360;
	
	if(_activeInptTaskId = _inptTaskId) {
		_activeInptTaskId = _inptTaskId;
	}
	
	var _arrimgPageInfo = $globaObjlData.imgPageInfo;
	var params = {};
	var _idx = 0;
	globalImglist = [];
	
	for(var i in _arrimgPageInfo) {
		//이미지 정보 검색 조건
		if(_inptBlGrpNo == _arrimgPageInfo[i].inptBlGrpNo && _imexHisCd == _arrimgPageInfo[i].imexHisCd) {
			params = {
				inptElmtId : _arrimgPageInfo[i].inptElmtId,
				inptTaskId : _arrimgPageInfo[i].inptTaskId,
				imexHisCd : _arrimgPageInfo[i].imexHisCd,
				aiInptPapsQltScre : _arrimgPageInfo[i].aiInptPapsQltScre
			};
			
			globalImglist.push(params);
			
			_idx++;
		}
	}
	
	if(globalImexHisCdChgImgInfo != null) {
		globalImexHisCdChgImgInfo.btnIndex = _idx;
		globalImexHisCdChgImgInfo = null;
	}
	
	$('#item-link').removeClass('item-active');
	$('#hisCd_' + _imexHisCd).find('a').addClass('item-active');
	
	// 화면 사이즈 조정
	sectionViewResize();
	
	// 이미지 페이징버튼 생성
	fn_setImgPageBtn(_activeInptTaskId);
}

// 이미지 페이징버튼 생성 
function fn_setImgPageBtn(_activeInptTaskId) {
	var _btn_html = "";
	var _imexHisCd = "";
	var _inptElmtId = "";
	var _inptTaskId = "";
	
	//선택된 bl 정보
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_spdKind = $('#active_spdKind').val();
	
	// 이미지 점수
	var _aiInptPapsQltScre;
	
	for (var i in globalImglist) {
		
		if (_activeInptTaskId == globalImglist[i].inptTaskId) {
			globalImgNo = parseInt(i);
			
			globalImgPageNo = Math.floor(globalImgNo / 5) + 1;
		}
	}
	
	if( globalImglist.length > 0) {
		
		globalImgPageSize = globalImglist.length % 5 == 0 ? Math.floor(globalImglist.length / 5) : Math.floor(globalImglist.length / 5) + 1;
		
		if ("0" == _activeInptTaskId) {
			
			for (var i = (globalImgPageNo - 1) * 5; i < ((globalImgPageNo - 1) * 5)  + 5; i ++) {
				
				if (globalImglist[i]) {
					
					_inptTaskId = globalImglist[i].inptTaskId ? globalImglist[i].inptTaskId : "";
					_imexHisCd = globalImglist[i].imexHisCd ? globalImglist[i].imexHisCd : "";
					_inptElmtId = globalImglist[i].inptElmtId ? globalImglist[i].inptElmtId : "";
					_aiInptPapsQltScre = globalImglist[i].aiInptPapsQltScre ? globalImglist[i].aiInptPapsQltScre : "-1";
					
					_btn_html += '<button id="imgPageNo_' + i + '" class="btn btn-sm btn-info img-page-btn" type="button" inptTaskId="' +_inptTaskId + '" imexHisCd="' + _imexHisCd + '" inptElmtId="' + _inptElmtId + '" aiInptPapsQltScre="' + _aiInptPapsQltScre + '">' + (i + 1) + '</button>';
					
				}
			}
			
		} else {
			
			for (var i = (globalImgPageNo - 1) * 5; i < ((globalImgPageNo - 1) * 5)  + 5; i ++) {
				
				if (globalImglist[i]) {
					
					_inptTaskId = globalImglist[i].inptTaskId ? globalImglist[i].inptTaskId : "";
					_imexHisCd = globalImglist[i].imexHisCd ? globalImglist[i].imexHisCd : "";
					_inptElmtId = globalImglist[i].inptElmtId ? globalImglist[i].inptElmtId : "";
					_aiInptPapsQltScre = globalImglist[i].aiInptPapsQltScre ? globalImglist[i].aiInptPapsQltScre : "-1";
					
					_btn_html += '<button id="imgPageNo_' + i + '" class="btn btn-sm btn-info img-page-btn" type="button" inptTaskId="' +_inptTaskId + '" imexHisCd="' + _imexHisCd + '" inptElmtId="' + _inptElmtId + '" aiInptPapsQltScre="' + _aiInptPapsQltScre + '">' + (i + 1) + '</button>';					
				}
			}
		}
		
		$('#img_index_btn').empty();
		$('#img_index_btn').append(_btn_html);
		
		// 현재이미지 색 넣기
		$('#imgPageNo_' + globalImgNo).addClass('img-page-btn-active');
		
		// 이미지 총 개수 넣기
		$('#imgIndexNo').val(globalImgNo + 1);
		$('#imgTotalNo').text(globalImglist.length);
		
		// 이미지 순서 버튼 초기화
		$('.img-index-btn').attr('disabled', false);
		$('.img-index-btn').removeClass('not-allowed');
		
		// 첫번째 이미지패이지일때 뒤로 비활성화
		if (globalImgPageNo == 1) {
			$('#doubleLeftBtn').attr('disabled', true);
			$('#doubleLeftBtn').addClass('not-allowed');
		}
		
		// 현재 이미지페이지 = 총 이미지페이지 일때 앞으로 비활성화
		if (globalImgPageNo == globalImgPageSize) {
			$('#doubleRightBtn').attr('disabled', true);
			$('#doubleRightBtn').addClass('not-allowed');
		}
		
		// 첫번째 이미지일때 뒤로 비활성화
		if (globalImgNo == 0) {
			$('#singleLeftBtn').attr('disabled', true);
			$('#singleLeftBtn').addClass('not-allowed');
		}
		
		// 마지막 이미지일때 앞으로 비활성화
		if (globalImgNo + 1 == globalImglist.length) {
			$('#singleRightBtn').attr('disabled', true);
			$('#singleRightBtn').addClass('not-allowed');
		}
		
		if(globalImexHisCdChgImgInfo == null) {

			if(globalImglist.length > 0) {
				
				_aiInptPapsQltScre = globalImglist[globalImgNo].aiInptPapsQltScre;

				$('#active_inptTaskId').val(globalImglist[globalImgNo].inptTaskId);
				$('#active_imexHisCd').val(globalImglist[globalImgNo].imexHisCd);
				$('#active_inptElmtId').val(globalImglist[globalImgNo].inptElmtId);
				$('#active_aiInptPapsQltScre').val(_aiInptPapsQltScre);
				$('#img-scre').empty().removeClass('img-scre');
				var _screHtml = "";
				
				//이미지 품질점수 (그룹코드901 공통코드1) 이하면 저품질 문서 표시
				if (0 < parseInt(_aiInptPapsQltScre) && parseInt(_aiInptPapsQltScre) <= parseInt(globalQltScre)) {
					_screHtml += '저품질';
					
					$('#img-scre').append(_screHtml).addClass('img-scre');
				}
				
				//이미지 품질점수 0 이면 글자초과 문서 표시
				if (0 == parseInt(_aiInptPapsQltScre)) {
					_screHtml += '글자초과';
					
					$('#img-scre').append(_screHtml).addClass('img-scre');
				}
				
				//이미지호출 전 데이터 세팅
				fn_setCallImgData();
			}
			
		} else {
			
			_aiInptPapsQltScre = globalImexHisCdChgImgInfo.aiInptPapsQltScre;
			
			$('#active_inptTaskId').val(globalImexHisCdChgImgInfo.inptTaskId);
			$('#active_inptElmtId').val(globalImexHisCdChgImgInfo.inptElmtId);
			$('#active_imexHisCd').val(globalImexHisCdChgImgInfo.imexHisCd);
			$('#img-scre').empty().removeClass('img-scre');
			var _screHtml = "";
			
			//이미지 품질점수 (그룹코드901 공통코드1) 이하면 저품질 문서 표시
			if (0 < parseInt(_aiInptPapsQltScre) && parseInt(_aiInptPapsQltScre) <= parseInt(globalQltScre)) {
				_screHtml += '저품질';
				
				$('#img-scre').append(_screHtml).addClass('img-scre');
			}
			
			//이미지 품질점수 0 이면 글자초과 문서 표시
			if (0 == parseInt(_aiInptPapsQltScre)) {
				_screHtml += '글자초과';
				
				$('#img-scre').append(_screHtml).addClass('img-scre');
			}
		}
	} else {
		
		alert('분류된 이미지가 없습니다.');
		
	}
}

//이미지호출 전 데이터 세팅
function fn_setCallImgData() {
	
	//spdKind 받기
	var _activeSpdKind = $('#active_spdKind').val();
	//inptBlGrpNo 받기
	var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	//이미지정보
	var _activeInptTaskId = $('#active_inptTaskId').val();
	var _activeInptElmtId = $('#active_inptElmtId').val();
	var _activeImexHisCd = $('#active_imexHisCd').val();
	
	var _selInptTaskId = _activeInptTaskId;
	var _selImexHisCd = _activeImexHisCd;
	
	if(_activeSpdKind == "TOTAL") {
		var _totalTextRstListTableData = globalTotalTextRstListTable.row('.selected').data();
		if(typeof _totalTextRstListTableData != "undefined") {
			_selImexHisCd = _totalTextRstListTableData[6];
			_selInptTaskId = _totalTextRstListTableData[7];
		}
	} else if(_activeSpdKind == "SANC"){
	}
	
	//이미지 세팅
	fn_init_draw_image(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
	//하이라이트 세팅
	fn_setBlink(_activeSpdKind, _selInptTaskId, _activeInptElmtId, _selImexHisCd);
}

//하이라이트 세팅
function fn_setBlink(_activeSpdKind, _activeInptTaskId, _activeInptElmtId, _activeImexHisCd) {
	
	if (rotateVal % 360 == 0) {
		
		//이미지 좌표정보
		globalInform = [];
		
		//inptBlGrpNo 받기
		var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
		
		//선택된 테이블 row데이터
		var _totalTextRstListTableData = globalTotalTextRstListTable.row('.selected').data();
		var _sanctionRstListTableData = globalSanctionRstListTable.row('.selected').data();
		
		if(_totalTextRstListTableData && _activeSpdKind == "TOTAL") {
			var _aiInptTotaltextSrno = _totalTextRstListTableData[5];
			
			for(var i in globalImgCdntsData) {
				if(_activeSpdKind == globalImgCdntsData[i].spdKind && _aiInptTotaltextSrno == globalImgCdntsData[i].aiInptTotaltextSrno
						&& _activeInptTaskId == globalImgCdntsData[i].inptTaskId && _activeInptElmtId == globalImgCdntsData[i].inptElmtId
						&& _activeInptElmtId == globalImgCdntsData[i].inptElmtId && _activeImexHisCd == globalImgCdntsData[i].imexHisCd) {
					
					globalInform.push(JSON.parse(globalImgCdntsData[i].itmCoordinates));
				}
			}
			
			fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
			fn_selected_blink(globalInform);
			
		} else if(_sanctionRstListTableData && _activeSpdKind == "SANC") {
			var _inptSanctionNo = _sanctionRstListTableData[8];
			
			for(var i in globalImgCdntsData) {
				if(_activeSpdKind == globalImgCdntsData[i].spdKind && _inptSanctionNo == globalImgCdntsData[i].inptSanctionNo
						&& _activeInptTaskId == globalImgCdntsData[i].inptTaskId && _activeInptElmtId == globalImgCdntsData[i].inptElmtId
						&& _activeImexHisCd == globalImgCdntsData[i].imexHisCd) {
					
					globalInform.push(JSON.parse(globalImgCdntsData[i].itmCoordinates));
				}
			}
			
			fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
			fn_selected_blink(globalInform);
			
		} else {
			fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
		}
	}
}

function fn_setOpiHisData() {
	
	// 변수 초기화
	var _indexNo = 0;
	var _arrData = [];
	var _selectOpiHis = $globaObjlData.selectOpiHis
	var _selectOpi = $globaObjlData.selectOpi;
	
	var _aiInptCrpeNm = "";
	var _aiInptCrpeEno = "";
	var _aiInptPrcOpiTxt = "";
	var _inptRcpDt = "";
	var _inptAtmcBizNm = "";
	
	globalAppvRecodeListData = [];
	
	for(var i in _selectOpiHis) {
		
		_aiInptCrpeNm = _selectOpiHis[i].aiInptCrpeNm;
		_aiInptCrpeEno = _selectOpiHis[i].aiInptCrpeEno;
		_aiInptPrcOpiTxt = _selectOpiHis[i].aiInptPrcOpiTxt;
		_inptRcpDt = _selectOpiHis[i].inptRcpDt;
		_inptAtmcBizNm = _selectOpiHis[i].inptAtmcBizNm;
		
		_indexNo++;
		
		_arrData = [
			_indexNo,
			_inptAtmcBizNm,
			_inptRcpDt,
			_aiInptCrpeNm,
			_aiInptPrcOpiTxt
		];
		
		globalAppvRecodeListData.push(_arrData);
	}
	
	// TotalText 테이블 데이터 넣기
	globalAppvRecodeTable.clear().draw();
	globalAppvRecodeTable.rows.add(globalAppvRecodeListData).draw();
	
}

function fn_setOpiData() {
	if($globaObjlData.selectOpi != null) {
		$('#rspt_inpt_apv_req_txt').empty().val($globaObjlData.selectOpi.aiInptPrcOpiTxt);
		var _opiTextLength = fnCheckByteSize($globaObjlData.selectOpi.aiInptPrcOpiTxt);
		$('#opi_text_length').text(_opiTextLength + ' / 4000 byte');
	}
}

function fn_setBtn() {
	var _selectStdInfo = $globaObjlData.selectStdInfo;
	
	$('#left_btn_zone').append('<button id="bprImgBtn" class="btn btn-sm btn-secondary m-1">BPR 이미지</button>');
	
	//심사상세를 호출 타입 : A(심사자), B(심사-결재자), C(QA담당자), D(QA-결재자), E(심사 only Read), F(QA only Read)
	if(globalCallType != "E" && globalCallType != "F") {
		$('#right_btn_zone').append('<button id="tmpSaveBtn" class="btn btn-sm btn-secondary m-1">임시저장</button>');
	}
	// 심사자 버튼
	if(globalCallType == "A") {

		$('#left_btn_zone').append('<button id="infoChangeBtn" class="btn btn-sm btn-secondary m-1">정보변경</button>');

		if(_selectStdInfo.aiInptAcvtCd == "80") {            // 수기대상 등록
			$('#left_btn_zone').append('<button id="reScanBtn" class="btn btn-sm btn-secondary m-1">재스캔</button>');
			$('#left_btn_zone').append('<button id="reExtractionBtn" class="btn btn-sm btn-secondary m-1">재추출</button>');
			$('#right_btn_zone').append('<button id="inspection" class="btn btn-sm btn-primary m-1">심사진행</button>');
		} else if(_selectStdInfo.aiInptAcvtCd == "90") {     // 심사결과 검토
			$('#left_btn_zone').append('<button id="reScanBtn" class="btn btn-sm btn-secondary m-1">재스캔</button>');
			$('#left_btn_zone').append('<button id="reExtractionBtn" class="btn btn-sm btn-secondary m-1">재추출</button>');
			$('#right_btn_zone').append('<button id="inspection" class="btn btn-sm btn-secondary m-1">재심사</button>');

			// 상신 버튼 or 재상신 버튼
			if(_selectStdInfo.rebtnYn == "Y") {
				$('#right_btn_zone').append('<button id="rePorsBtn" class="btn btn-sm btn-primary m-1">완료</button>');
			} else {
				$('#right_btn_zone').append('<button id="porsBtn" class="btn btn-sm btn-primary m-1">완료</button>');
			}
		}
		
	} else if(globalCallType == "B") {						// 결재자 버튼 
		$('#right_btn_zone').append('<button id="blockBtn" class="porsBtn btn btn-sm btn-secondary m-1">Block</button>');
		if(_selectStdInfo.aiInptAcvtCd != "130") {
			$('#right_btn_zone').append('<button id="pendingBtn" class="porsBtn btn btn-sm btn-secondary m-1">Pending</button>');
		}
		$('#right_btn_zone').append('<button id="returnBtn" class="porsBtn btn btn-sm btn-secondary m-1">반려</button>');
		$('#right_btn_zone').append('<button id="apprBtn" class="porsBtn btn btn-sm btn-primary m-1">승인</button>');
	} else if(globalCallType == "C") {					    // QA담당자 버튼
		// 상신 버튼 or 재상신 버튼
		if(_selectStdInfo.rebtnYn == "Y") {
			$('#right_btn_zone').append('<button id="rePorsBtn" class="btn btn-sm btn-primary m-1">완료</button>');
		} else {
			$('#right_btn_zone').append('<button id="porsBtn" class="btn btn-sm btn-primary m-1">완료</button>');
		}
	} else if(globalCallType == "D") {
		$('#right_btn_zone').append('<button id="returnBtn" class="porsBtn btn btn-sm btn-secondary m-1">반려</button>');
		$('#right_btn_zone').append('<button id="apprBtn" class="porsBtn btn btn-sm btn-primary m-1">승인</button>');
	}
}

//문서분류 Tab 클릭
function fn_itemClickEvt(itm) {
	
	// 이미지 인덱스
	globalImgNo = 0;
	// 이미지 페이지번호
	globalImgPageNo = 1;
	// 이미지 총페이지번호
	globalImgPageSize = 1;
	
	$('.item-link').removeClass('item-active');
	$(itm).addClass('item-active');
	
	// inptTaskId 받기
	var _selectedInptTaskId = $(itm).attr('data-inptTaskId');
	// inptElmtId 받기
	var _selectedInptElmtId = $(itm).attr('data-inptElmtId');
	// imexHisCd 받기
	var _selectedImexHisCd = $(itm).attr('data-imexHisCd');
	var _selectedImexhissAbbr = $(itm).attr('data-imexhisnm');
	// inptBlGrpNo 받기
	var _selectedInptBlGrpNo = $('#active_inptBlGrpNo').val();
	
	//이미지정보 저장
	$('#active_inptTaskId').val(_selectedInptTaskId);
	$('#active_inptElmtId').val(_selectedInptElmtId);
	$('#active_imexHisCd').val(_selectedImexHisCd);
	
	if(globalCallType == "A") {
		
		// 수기대상일때만 (inptAtvtCd:80) 문서분류 변경 활성화
//		var _inptAtvtCd = g_getUrlVar('inptAtvtCd');
//		
//		if (_inptAtvtCd == "90") {
//			$('#item_select').text(_selectedImexhissAbbr);
//		} else {
//			$('#item_select').val(_selectedImexHisCd);
//		}

		$('#item_select').val(_selectedImexHisCd);
		
	} else {
		$('#item_select').text(_selectedImexhissAbbr);
	}
	
	// 이미지 초기세팅
	fn_setImgInfo(_selectedInptBlGrpNo, _selectedImexHisCd, "0");
}

// BL탭(Top Tab) 클릭 이벤트
function fn_blTabClickEvt(bl) {
	
	// 이미지 인덱스
	globalImgNo = 0;
	// 이미지 페이지번호
	globalImgPageNo = 1;
	// 이미지 총페이지번호
	globalImgPageSize = 1;
	
	$('.bl-link').removeClass('bl-link_active');
	$('.bl-link').removeClass('active');
	$(bl).addClass('bl-link_active');
	$(bl).addClass('active');
	$('#active_inptBlGrpNo').val($(bl).attr('data-inptBlGrpNo'));
	
	//테이블 선택 삭제
	globalTotalTextRstListTable.row('.selected').deselect();
	globalSanctionRstListTable.row('.selected').deselect();
	
	// 문서분류 Tab 생성
	fn_setItem();
	
	// Totaltext 테이블(totalTextRst_data)
	if($globaObjlData.totalTextRst) {
		
		if($globaObjlData.totalTextRst.length > 0) {
			
			fn_setTotalTextRst();
		}
	}
	
	// SafeWatch 테이블(safeWatchRst_data)
	if($globaObjlData.safeWatchRst) {
		
		if($globaObjlData.safeWatchRst.length > 0) {
			
			fn_setSafeWatchRst();
		}
	}
	
	// 항목심사 dataTable Data Bind
	if($globaObjlData.sanctionRst) {
		
		if($globaObjlData.sanctionRst.length > 0) {
			
			fn_setSanctionRst();
		}
	}
}

// 임시저장, 재심사 파라미터 set
function fn_setTmpParam() {
	
	var _selectStdInfo = $globaObjlData.selectStdInfo;
	
	var _sanctionObj = null;
	var _sanctionArr = new Array();
	var _params = new Object();
	_params.inptMstSrno = globalInptMstSrno;
	_params.aiInptAppvSrno = $('#active_aiInptAppvSrno').val() == "" ? '0' : $('#active_aiInptAppvSrno').val();
	_params.aiInptBizDscd = $('#active_aiInptBizDscd').val();
	_params.aiInptPrcOpiTxt = $('#rspt_inpt_apv_req_txt').val();
	_params.inptBlGrpNo = $('#active_inptBlGrpNo').val(); 
	
	if(globalCallType == "A") {
		
		if (_selectStdInfo.aiInptAcvtCd == "80") {
			
			_params.aiInptAcvtCd = "50";
			
		} else {
			
			_params.aiInptAcvtCd = "70";
		}
		
		_params.mstTotaltextAiInptRstCd = "notSelected" == $('#totalTextStcdList_select').val() ? $('#active_mstTotaltextAiInptRstCd').val() : $('#totalTextStcdList_select').val();
		_params.mstInptItmAiInptRstCd = "notSelected" == $('#itmInptlStcdList_select').val() ? $('#active_mstInptItmAiInptRstCd').val() : $('#itmInptlStcdList_select').val();
		
		var _arrSanctionRst = $globaObjlData.sanctionRst;
		
		for(var i = 0; i < _arrSanctionRst.length; i++) {
			_sanctionObj = new Object();
			_sanctionObj.inptMstSrno = globalInptMstSrno;
			_sanctionObj.inptSanctionNo = _arrSanctionRst[i].inptSanctionNo;
			_sanctionObj.inptSanctionNm = _arrSanctionRst[i].inptSanctionNm; 
			_sanctionObj.inptTaskId = _arrSanctionRst[i].inptTaskId;
			_sanctionObj.stRstKind = _arrSanctionRst[i].stRstKind;
			_sanctionObj.inptBlGrpNo = _arrSanctionRst[i].inptBlGrpNo.toString();
			_sanctionObj.itmInptHndgInpDatTxt = _arrSanctionRst[i].itmInptHndgInpDatTxt;
			_sanctionObj.aiInptSanctionRuleTxt = _arrSanctionRst[i].aiInptSanctionRuleTxt;
			_sanctionObj.aiInptAltYn = _arrSanctionRst[i].aiInptAltYn;
			_sanctionArr.push(_sanctionObj);
		}
	} else if(globalCallType == "B") {
		_params.mstTotaltextAiInptRstCd = $('#active_mstTotaltextAiInptRstCd').val();
		_params.mstInptItmAiInptRstCd = $('#active_mstInptItmAiInptRstCd').val();
		_params.mstQltGrnAiInptRstCd = $('#active_mstQltGrnAiInptRstCd').val();
	} else if(globalCallType == "C") {
		_params.mstTotaltextAiInptRstCd = $('#active_mstTotaltextAiInptRstCd').val();
		_params.mstInptItmAiInptRstCd = $('#active_mstInptItmAiInptRstCd').val();
		_params.mstQltGrnAiInptRstCd = $('#qaStcdList_select').val();
	} else if(globalCallType == "D") {
		_params.mstTotaltextAiInptRstCd = $('#active_mstTotaltextAiInptRstCd').val();
		_params.mstInptItmAiInptRstCd = $('#active_mstInptItmAiInptRstCd').val();
		_params.mstQltGrnAiInptRstCd = $('#active_mstQltGrnAiInptRstCd').val();
	}
	
	_params.sanctionList = _sanctionArr.length == 0 ? null : _sanctionArr;
	return _params;
}

/* ===================== 표현식 함수 끝 ========================  */


//우측 Tab 클릭
$(document).on('click','.inpt-tab-link', function(e) {
	$('.inpt-tab-link').removeClass('active');
	$(this).addClass('active');
	
	// 이미지정보
	var _activeInptTaskId = $('#active_inptTaskId').val();
	var _activeInptElmtId = $('#active_inptElmtId').val();
	var _activeImexHisCd = $('#active_imexHisCd').val();
	var _activeSpdKind = $(this).attr('data-spdkind');
	$('#active_spdKind').val(_activeSpdKind);
	
	// 하이라이트 세팅
	fn_setBlink(_activeSpdKind, _activeInptTaskId, _activeInptElmtId, _activeImexHisCd);
	
	// 해더 리사이즈
	$('.dataTables_scrollHeadInner').width('100%');
	
});

//TotalText dataTable row Click
$(document).on('click', globalTotalTextRstTableId + ' tr', function() {
	var _rowData = globalTotalTextRstListTable.row(this).data();
	
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _itemList = $('#item_list').find('a').get();
	var _itemImexhiscd = "";
	
	if (_rowData) {
		
		var _spdKind = $('#tab_list').find('.active').attr('data-spdkind');
		var _aiInptTotaltextSrno = _rowData[5];
		var _imexHisCd = _rowData[6];
		var _inptTaskId = _rowData[7];
		
		//이미지정보
		var _activeInptTaskId = $('#active_inptTaskId').val();
		var _activeInptElmtId = $('#active_inptElmtId').val();
		var _activeImexHisCd = $('#active_imexHisCd').val();
		//spdKind 받기
		var _activeSpdKind = $('#tab_list').find('.active').attr('data-spdkind');
		//inptBlGrpNo 받기
		var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
		
		if($(this).hasClass('selected')) {
			
			$(this).attr('id', 'totalTextNon');
			$(this).removeClass('selected');
			
			for (var i in _itemList) {
				_itemImexhiscd = $('#item_' + i).attr('data-imexhisCd');
				
				if(_itemImexhiscd == _imexHisCd) {
					$('#item_' + i).removeClass('item-imex-selected');
				}
			}
			
			$('#item_list').children('li').removeClass('item-imex-his-cd-selected');
			
			if (rotateVal % 360 == 0) {
				//하이라이트 초기화
				fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
			}
		} else {
			globalSanctionRstListTable.$('tr.selected').attr('id', 'totalTextNon');
			globalTotalTextRstListTable.$('tr.selected').removeClass('selected');
			$('.item-link').removeClass('item-imex-selected');
			$('#item_list').children('li').removeClass('item-imex-his-cd-selected');
			$(this).attr('id', 'totalTextSelected');
			$(this).addClass('selected');
			
			for (var i in _itemList) {
				_itemImexhiscd = $('#item_' + i).attr('data-imexhisCd');
				
				if(_itemImexhiscd == _imexHisCd) {
					$('#item_' + i).addClass('item-imex-selected');
					$('#hisCd_' + _imexHisCd).addClass('item-imex-his-cd-selected');
				}
			}
			
			var _totalTextRstListTableData = globalTotalTextRstListTable.row('.selected').data();
			
			if(typeof _totalTextRstListTableData != "undefined") {
				_imexHisCd = _totalTextRstListTableData[6];
				_activeInptTaskId = _totalTextRstListTableData[7];
			}
			
			if (rotateVal % 360 == 0) {
				//하이라이트 세팅
				fn_setBlink(_activeSpdKind, _activeInptTaskId, _activeInptElmtId, _imexHisCd);
			}
		}
	}
});

//항목심사 dataTable row Click
$(document).on('click', globalSanctionRstTableId + ' tr', function() {
	
	var _rowData = globalSanctionRstListTable.row(this).data();
			
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _itemList = $('#item_list').find('a').get();
	var _itemImexhiscd = "";
	
	if (_rowData) {
		
		var _spdKind = $('#tab_list').find('.active').attr('data-spdkind');
		var _inptSanctionNo = _rowData[8];
		var _imexHisCd = _rowData[9];
		var _inptTaskId = _rowData[10];
		var _stRstKind = _rowData[11];
		var _aiInptExtcSntnTxt = _rowData[2];
		
		//이미지정보
		var _activeInptTaskId = $('#active_inptTaskId').val();
		var _activeInptElmtId = $('#active_inptElmtId').val();
		var _activeImexHisCd = $('#active_imexHisCd').val();
		//spdKind 받기
		var _activeSpdKind = $('#tab_list').find('.active').attr('data-spdkind');
		//inptBlGrpNo 받기
		var _activeInptBlGrpNo = $('#active_inptBlGrpNo').val();
		
		if($(this).hasClass('selected')) {
			$(this).attr('id', 'sanctionNon');
			$(this).removeClass('selected');
			
			for (var i in _itemList) {
				_itemImexhiscd = $('#item_' + i).attr('data-imexhisCd');
				
				if(_itemImexhiscd == _imexHisCd) {
					$('#item_' + i).removeClass('item-imex-selected');
				}
			}
			
			$('#item_list').children('li').removeClass('item-imex-his-cd-selected');
			
			if (rotateVal % 360 == 0) {
				//이미지 좌표정보
				globalInform = [];
				//하이라이트 초기화
				fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
			}
			
		} else {
			globalSanctionRstListTable.$('tr.selected').attr('id', 'sanctionNon');
			globalSanctionRstListTable.$('tr.selected').removeClass('selected');
			$('.item-link').removeClass('item-imex-selected');
			$('#item_list').children('li').removeClass('item-imex-his-cd-selected');
			
			$(this).attr('id', 'sanctionSelected');
			$(this).addClass('selected');
			
			// 불일치 목록 표시
			var _concat_imex_his_cd = _rowData[12].split(',');
			
			for(var i in _concat_imex_his_cd){
				
				$('#hisCd_' + _concat_imex_his_cd[i]).addClass('item-imex-his-cd-selected');
				
			}
			
			if ('EXT' == _stRstKind) {
				for (var i in _itemList) {
					$('#item_' + i).removeClass('item-imex-selected');
					
					_itemImexhiscd = $('#item_' + i).attr('data-imexhisCd');
					
					if(_itemImexhiscd == _imexHisCd) {
						$('#item_' + i).addClass('item-imex-selected');
						$('#hisCd_' + _imexHisCd).addClass('item-imex-his-cd-selected');
					}
				}
				
				if (rotateVal % 360 == 0) {
					//이미지 좌표정보
					globalInform = [];
					//하이라이트 세팅
					fn_setBlink(_activeSpdKind, _activeInptTaskId, _activeInptElmtId, _activeImexHisCd);
				}
			} else {
				if (rotateVal % 360 == 0) {
					//이미지 좌표정보
					globalInform = [];
					//하이라이트 초기화
					fn_init_draw_image_for_tab(_activeInptBlGrpNo, _activeImexHisCd, _activeInptTaskId, _activeSpdKind, _activeInptElmtId);
				}
			}
		}
	}
	
});

$(document).on('click', globalSanctionRstTableId + ' tr', function() {
	var modBlNumId = event.target.id;
});

//TotalText dataTable row Click
$(document).on('dblclick', globalTotalTextRstTableId + ' tr', function() {
	var _rowData = globalTotalTextRstListTable.row(this).data();
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_imexHisCd = $('#active_imexHisCd').val();
	var _active_inptTaskId = $('#active_inptTaskId').val();
	
	if (_rowData) {
		
		var _imexHisCd = _rowData[6];
		var _inptTaskId = _rowData[7];
		
		//다른 이미지일때만 수행
		if (_active_imexHisCd != _imexHisCd || _active_inptTaskId != _inptTaskId) {
			
			fn_setImgInfo(_active_inptBlGrpNo, _imexHisCd, _inptTaskId);
			
			$('.item-link').removeClass('item-active');
			$('#hisCd_' + _imexHisCd).find('a').addClass('item-active');
			
			//imexHisCd 받기
			var _selectedImexHisCd = $('#hisCd_' + _imexHisCd).find('a').attr('data-imexHisCd');
			var _selectedImexhissAbbr = $('#hisCd_' + _imexHisCd).find('a').attr('data-imexhisnm');
			
			if(globalCallType == "A") {
				
				$('#item_select').val(_selectedImexHisCd);
				
			} else {
				
				$('#item_select').text(_selectedImexhissAbbr);
			}
		}
	}
});

//항목심사 dataTable row Click
$(document).on('dblclick', globalSanctionRstTableId + ' tr', function() {
	var _rowData = globalSanctionRstListTable.row(this).data();
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_imexHisCd = $('#active_imexHisCd').val();
	var _active_inptTaskId = $('#active_inptTaskId').val();
	var _imexHisCd = _rowData[9];
	var _inptTaskId = _rowData[10];
	var _sanctionData = _rowData[3];
	
	if (_rowData) {
		
		//다른 이미지일때만 수행
		if ((_active_imexHisCd != _imexHisCd || _active_inptTaskId != _inptTaskId) && _sanctionData != null && _sanctionData != "") {
			
			fn_setImgInfo(_active_inptBlGrpNo, _imexHisCd, _inptTaskId);
			
			$('.item-link').removeClass('item-active');
			$('#hisCd_' + _imexHisCd).find('a').addClass('item-active');
			
			//imexHisCd 받기
			var _selectedImexHisCd = $('#hisCd_' + _imexHisCd).find('a').attr('data-imexHisCd');
			var _selectedImexhissAbbr = $('#hisCd_' + _imexHisCd).find('a').attr('data-imexhisnm');
			
			if(globalCallType == "A") {
				
				$('#item_select').val(_selectedImexHisCd);
				
			} else {
				
				$('#item_select').text(_selectedImexhissAbbr);
				
			}
			
			var _newBlNo = parseInt($('#bl_select option:last').val()) + 1;
			var _newHtml = "";
			
			if (_selectedImexHisCd == "01") {
				
				$('#bl_select').prop('disabled', false);
				
				if ($('#new_bl').length == 0) {
					_newHtml += "<option id='new_bl' value='" + _newBlNo + "'>신규</option>";
					$('#bl_select').append(_newHtml);
				}
				
			} else {
				
				$('#bl_select').prop('disabled', true);
				
				if ($('#new_bl').length > 0) {
					$('#new_bl').remove();
				}
			}
			
			$('#bl_select').val(_active_inptBlGrpNo);
		}
	}
});

// 하이라이트 전체 선택 옵션
$(document).on('change','[name="blinkType"]', function(e) {
	
	// 이미지정보
	var _activeInptTaskId = $('#active_inptTaskId').val();
	var _activeInptElmtId = $('#active_inptElmtId').val();
	var _activeImexHisCd = $('#active_imexHisCd').val();
	var _activeSpdKind = $('#tab_list').find('.active').attr('data-spdkind');
	$('#active_spdKind').val(_activeSpdKind);
	
	// 하이라이트 세팅
	fn_setBlink(_activeSpdKind, _activeInptTaskId, _activeInptElmtId, _activeImexHisCd);
	
});

// 이미지 순서 버튼 선택
$(document).on('click','.img-index-btn', function(e) {
	
	var _btnType = $(this).attr('btnType');
	var _activeInptTaskId = globalImglist[globalImgNo].inptTaskId;
	
	//버튼타입 별 페이지 이동
	if ('doubleLeft' == _btnType) {
		
		globalImgNo = (globalImgPageNo - 2) * 5;
		
	} else if ('singleLeft' == _btnType) {
		
		globalImgNo -= 1;
		
	} else if ('singleRight' == _btnType) {
		
		globalImgNo += 1;
		
	} else if ('doubleRight' == _btnType) {
		
		globalImgNo = (globalImgPageNo) * 5;
	}
	
	var _activeInptTaskId = globalImglist[globalImgNo].inptTaskId;
	
	var globalImgPageSize = 1;
	
	fn_setImgPageBtn(_activeInptTaskId);
});

// 이미지 버튼 선택
$(document).on('click','.img-page-btn', function(e) {
	
	var _btn_html = "";
	var _imexHisCd = "";
	var _inptElmtId = "";
	var _inptTaskId = "";
	
	//선택된 bl 정보
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_spdKind = $('#active_spdKind').val();
	
	var _inptTaskId = $(this).attr('inpttaskid');
	var _imexHisCd = $(this).attr('imexhiscd');
	var _inptElmtId = $(this).attr('inptelmtid');
	var _aiInptPapsQltScre = $(this).attr('aiinptpapsqltscre');
	
	$('.img-page-btn').removeClass('img-page-btn-active');
	$(this).addClass('img-page-btn-active');
	
	$('#active_inptTaskId').val(_inptTaskId);
	$('#active_inptElmtId').val(_inptElmtId);
	$('#active_imexHisCd').val(_imexHisCd);
	$('#active_aiInptPapsQltScre').val(_aiInptPapsQltScre);
	$('#img-scre').empty().removeClass('img-scre');
	var _screHtml = "";
	
	var _pageIndex = parseInt($(this).attr('id').replace("imgPageNo_", ""));
	//이미지 총 개수 넣기
	$('#imgIndexNo').val(_pageIndex + 1);
	globalImgNo = _pageIndex;
	
	//이미지 품질점수 (그룹코드901 공통코드1) 이하면 저품질 문서 표시
	if (0 < parseInt(_aiInptPapsQltScre) && parseInt(_aiInptPapsQltScre) <= parseInt(globalQltScre)) {
		_screHtml += '저품질';
		
		$('#img-scre').append(_screHtml).addClass('img-scre');
	}
	
	//이미지 품질점수 0 이면 글자초과 문서 표시
	if (0 == parseInt(_aiInptPapsQltScre)) {
		_screHtml += '글자초과';
		
		$('#img-scre').append(_screHtml).addClass('img-scre');
	}
	
	// 이미지 순서 버튼 초기화
	$('.img-index-btn').attr('disabled', false);
	$('.img-index-btn').removeClass('not-allowed');
	
	// 첫번째 이미지패이지일때 뒤로 비활성화
	if (globalImgPageNo == 1) {
		$('#doubleLeftBtn').attr('disabled', true);
		$('#doubleLeftBtn').addClass('not-allowed');
	}
	
	// 현재 이미지페이지 = 총 이미지페이지 일때 앞으로 비활성화
	if (globalImgPageNo == globalImgPageSize) {
		$('#doubleRightBtn').attr('disabled', true);
		$('#doubleRightBtn').addClass('not-allowed');
	}
	
	// 첫번째 이미지일때 뒤로 비활성화
	if (globalImgNo == 0) {
		$('#singleLeftBtn').attr('disabled', true);
		$('#singleLeftBtn').addClass('not-allowed');
	}
	
	// 마지막 이미지일때 앞으로 비활성화
	if (globalImgNo + 1 == globalImglist.length) {
		$('#singleRightBtn').attr('disabled', true);
		$('#singleRightBtn').addClass('not-allowed');
	}
	
	
	//이미지호출 전 데이터 세팅
	fn_setCallImgData();
});

// BPR 이미지
$(document).on('click','#bprImgBtn', function(e) {
	
	window.open(bprUrl + globalImgKeyNo, '_blank');
});

// 4000자 체크
$(document).on('keyup','.opi-text-check', function(e) {
	
	var _opiTextLength = fnCheckByteSize($('#rspt_inpt_apv_req_txt').val());
	
	if (_opiTextLength > 4000) {
		alert("전달내용은 허용된 범위내로 입력해 주시기 바랍니다.");
		$('#rspt_inpt_apv_req_txt').val(orgOpiText);
	} else {
		orgOpiText = $('#rspt_inpt_apv_req_txt').val();
		$('#opi_text_length').text(_opiTextLength + ' / 4000 byte');
	}
});

$(function() {
	// 항목심사탭 선택
	$('.inpt-tab-link').removeClass('active');
	$('.tab_item').removeClass('active');
	$('a[data-tab="t2"]').addClass('active');
	$('#t2').addClass('active');
});


// 마우스 휭 오버 다운 이미지 확대 축소
$('.canvas-overflow').on('mouseover',function(){
	moueUp = true;
});

$('.canvas-overflow-revert').on('mouseover',function(){
	moueUp = true;
});

$('.canvas-overflow').on('mouseout',function(){
	moueUp = false;
});

$('.canvas-overflow-revert').on('mouseout',function(){
	moueUp = false;
});

$(window).on('mousewheel',function(event){
	
	var _wheelDelta;
	
	if(moueUp == true){
		
		wheelDelta = event.originalEvent.wheelDelta;
		
		if ( wheelDelta > 0){
			fn_Zoom('+');
		} else {
			fn_Zoom('-');
		}
	}
});

// 키입력 이벤트
$(document).keydown(function(e){
	
	// 심사자 버튼
	if(globalCallType == "A" && $('.itm-inpt-hndg-inp').index($(document.activeElement)) > -1) {
		
		var _totalIndex = $('.itm-inpt-hndg-inp').length - 1;
		var _index =  $('.itm-inpt-hndg-inp').index($(document.activeElement));
		var _indexId = globalSanctionRstListData[_index][0] - 1;
		
		// 앤터  아래화살표 키 이벤트 추가
		if (e.keyCode == "13" || e.keyCode == "40") {
			
			if (_index < _totalIndex) {
				$('#sanctionRstTable').find('tr').find('td').removeClass('selected-sanction');
				$("#index_" + (_indexId + 1)).focus().select();
				$('#sanctionRstTable').find('tr').eq((_index + 2)).find('td').eq(2).addClass('selected-sanction');
				$('#sanctionRstTable').find('tr').eq((_index + 2)).find('td').eq(4).addClass('selected-sanction');
			}
		}
		
		// tab ("수기 추가" 컬럼이 옆에 생기면서 브라우저 기본 tab 순서가 수기입력↔수기추가를
		// 오가게 되어, 포커스 이동을 직접 제어한다 — "수기입력" 컬럼 안에서만 다음/이전 행으로 이동)
		if (e.keyCode == "9") {

			var _tabCol = $('.itm-inpt-hndg-inp');

			// shift + tab
			if (e.shiftKey) {

				if (_index > 0) {
					var _prevTab = _tabCol.eq(_index - 1);
					$('#sanctionRstTable').find('tr').find('td').removeClass('selected-sanction');
					_prevTab.closest('tr').find('td').eq(2).addClass('selected-sanction');
					_prevTab.closest('tr').find('td').eq(4).addClass('selected-sanction');
					_prevTab.focus().select();
				}

			} else {

				if (_index < _totalIndex) {
					var _nextTab = _tabCol.eq(_index + 1);
					$('#sanctionRstTable').find('tr').find('td').removeClass('selected-sanction');
					_nextTab.closest('tr').find('td').eq(2).addClass('selected-sanction');
					_nextTab.closest('tr').find('td').eq(4).addClass('selected-sanction');
					_nextTab.focus().select();
				}
			}

			e.preventDefault();
		}
		
		// 위화살표 이벤트 추가
		if (e.keyCode == "38") {
			                       
			if (_index > 0) {
				$('#sanctionRstTable').find('tr').find('td').removeClass('selected-sanction');
				$("#index_" + (_indexId - 1)).focus().select();
				$('#sanctionRstTable').find('tr').eq(_index).find('td').eq(2).addClass('selected-sanction');
				$('#sanctionRstTable').find('tr').eq(_index).find('td').eq(4).addClass('selected-sanction');
			}
		}
		
	} else if (globalCallType != "A") {
		
		// 위화살표 키 이벤트 추가
		if (e.keyCode == "38") {
			
			var _totalIndex, _index, _selected_table, _selected_globalTable, _selected_type;
			var _active_spdKind = $('#tab_list').find('.active').attr('data-spdkind');
			
			if (_active_spdKind == "SANC") {
				_selected_table = $('#sanctionRstTable');
				_selected_globalTable = globalSanctionRstListTable;
				_selected_type = "sanctionSelected";
			} else if (_active_spdKind == "TOTAL") {
				_selected_table = $('#totalTextRstTable');
				_selected_globalTable = globalTotalTextRstListTable;
				_selected_type = "totalTextSelected";
			}
			
			_totalIndex = parseInt(_selected_table.find('tr').size());
			_index = _selected_table.find('tr').index(_selected_table.find('.selected'));

			if (_index > 1) {
				_selected_table.find('.selected').attr('id', 'non')
				_selected_table.find('tr').removeClass('selected');
				_selected_table.find('tr').eq(_index - 1).addClass('selected');
				_selected_table.find('.selected').attr('id', _selected_type);
				
				document.getElementById(_selected_type).scrollIntoView();
				
				e.preventDefault();
				e.stopPropagation();
			}
		}
		
		// 아래화살표 이벤트 추가
		if (e.keyCode == "40") {
			
			var _totalIndex, _index, _selected_table, _selected_globalTable, _selected_type;
			var _active_spdKind = $('#tab_list').find('.active').attr('data-spdkind');
			
			if (_active_spdKind == "SANC") {
				_selected_table = $('#sanctionRstTable');
				_selected_globalTable = globalSanctionRstListTable;
				_selected_type = "sanctionSelected";
			} else if (_active_spdKind == "TOTAL") {
				_selected_table = $('#totalTextRstTable');
				_selected_globalTable = globalTotalTextRstListTable;
				_selected_type = "totalTextSelected";
			}
			
			_totalIndex = parseInt(_selected_table.find('tr').size());
			_index = _selected_table.find('tr').index(_selected_table.find('.selected'));
			
			if (_index + 1 < _totalIndex) {
				_selected_table.find('.selected').attr('id', 'non')
				_selected_table.find('tr').removeClass('selected');
				_selected_table.find('tr').eq(_index + 1).addClass('selected');
				_selected_table.find('.selected').attr('id', _selected_type);
				
				document.getElementById(_selected_type).scrollIntoView();
				
				e.preventDefault();
				e.stopPropagation();
			}
		}
		
	}
	
	// 페이지업 이벤트 추가
	if (e.keyCode == "33") {
		
		var _focusEle = document.activeElement;
		
		if (focusSelect == "image") {
			
			if (globalImgNo > 0) {
				
				var _activeInptTaskId = globalImglist[globalImgNo - 1].inptTaskId;
				fn_setImgPageBtn(_activeInptTaskId);
			}
			
		}
	}
	
	// 페이지다운 이벤트 추가
	if (e.keyCode == "34") {
		
		var _focusEle = document.activeElement;
		
		if (focusSelect == "image") {
			
			if (globalImgNo < globalImglist.length - 1) {
				
				var _activeInptTaskId = globalImglist[globalImgNo + 1].inptTaskId;
				fn_setImgPageBtn(_activeInptTaskId);
			}
		}
	}
});

// 이미지 포커스 이동
$(document).on('click','.section_cate', function(e) {
	
	focusSelect = "image";
	
});

// 테이블 포커스 이동
$(document).on('click','.section_view', function(e) {
	
	focusSelect = "table";
	
});

// 수기입력 클릭
$(document).on('click','.itm-inpt-hndg-inp', function(e) {
	
	var _totalIndex = $('.itm-inpt-hndg-inp').length;
	var _index =  $('.itm-inpt-hndg-inp').index($(document.activeElement));
	
	$('#sanctionRstTable').find('tr').find('td').removeClass('selected-sanction');
	$('#sanctionRstTable').find('tr').eq((_index + 1)).find('td').eq(2).addClass('selected-sanction');
	$('#sanctionRstTable').find('tr').eq((_index + 1)).find('td').eq(4).addClass('selected-sanction');
	
});

// 추출내용 복사
$(document).on('click','.btn-copy', function(e) {
	
	var _copytype = $(this).attr('copytype');
	var _trIndex = $(this).closest('tr').index();
	var _ele = $(this).closest('input');
	var _rowData = globalSanctionRstListTable.row(_trIndex).data();
	var _index = _rowData[0] - 1;
	var _inptSanctionDatTxt = (_copytype == "copy") ? _rowData[3] : "";
	var _inptSanctionNo = _rowData[8];
	var _inptTaskId = _rowData[10];
	
	$(this).closest('tr').find('td').eq(4).find('input').val(_inptSanctionDatTxt);
	fn_itmInptHndgInpDatTextChage(_ele, _inptSanctionDatTxt, _inptSanctionNo, _inptTaskId, _index);
	
	$(this).attr('copytype', 'copy');
	
});

// 추출내용 전체 복사
$(document).on('click','.btn-all-copy', function(e) {
	
	var _copytype = $('.btn-all-copy').attr('copytype');
	
	var _ele;
	var _inptSanctionDatTxt;
	var _inptTaskId;
	var _inptSanctionNo;
	
	for(var i in globalSanctionRstListData) {
		
		_ele = $("#index_" + i);
		_inptSanctionDatTxt = (_copytype == "copy") ? globalSanctionRstListData[i][3] : "";
		_inptSanctionNo = globalSanctionRstListData[i][8];
		_inptTaskId = globalSanctionRstListData[i][10];
		
		$("#index_" + i).val(_inptSanctionDatTxt);
		fn_itmInptHndgInpDatTextChage(_ele, _inptSanctionDatTxt, _inptSanctionNo, _inptTaskId, i);
	}
	
	$('.btn-all-copy').attr('copytype', 'copy');
});

// 항목심사 콤보박스 변경 시 전달정보탭에 데이터 반영
$(document).on('change','#itmInptlStcdList_select', function(e) {
	var _selectText = $('#itmInptlStcdList_select option:selected').text();
	
	$('#itmInptlStcd_zone').empty().append('<label class="col-form-label text-left">' + _selectText + '</label>');
	
});

// TotalText심사 콤보박스 변경 시 전달정보탭에 데이터 반영
$(document).on('change', '#totalTextStcdList_select', function(e) {
	var _selectText = $('#totalTextStcdList_select option:selected').text();
	
	$('#totalTextStcd_zone').empty().append('<label class="col-form-label text-left">' + _selectText + '</label>');
});

// 이미지 초기화 버튼 클릭
$(document).on('click', '#zoomRefreshBtn', function(e) {
	
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_imexHisCd = $('#active_imexHisCd').val();
	var _active_inptTaskId = $('#active_inptTaskId').val();

	fn_setImgInfo(_active_inptBlGrpNo, _active_imexHisCd, _active_inptTaskId);
	
});

// safewatch 새로고침 버튼 클릭
$(document).on('click', '#safeWatchResetBtn', function(e) {
	fn_getSafewatchData();
});

function fnHtmlEscape(str) {
	if(!str) return str;
	
	str = str+'';
	str = fnCmnReplaceAll(str,'&','&#38;');
	str = fnCmnReplaceAll(str,'<','&lt;');
	str = fnCmnReplaceAll(str,'>','&gt;');
	str = fnCmnReplaceAll(str,'(','&#40;');
	str = fnCmnReplaceAll(str,')','&#41;');
	str = fnCmnReplaceAll(str,'"','&quot;');
	str = fnCmnReplaceAll(str,"'",'&#39;');
	str = fnCmnReplaceAll(str,"=",'&#x3D;');
	str = fnCmnReplaceAll(str,"`",'&#x60;');
	
	return str;
}


//페이지번호 숫자만 입력가능
$(document).on('keyup', '#imgIndexNo', function(e){
	var currValue = $(this).val();
		
	var pattern = /^[0-9]*$/;
	
	if(!pattern.test(currValue)){
		
		$(this).val(globalImgNo + 1);
		$(this).focus();
		
		alert("숫자만 입력 가능합니다.");
	}
});

//앤터키 이벤트 추가
$(document).keydown(function(e){
	
	if (e.keyCode == "13") {
		
		var _focusEle = document.activeElement;
		var _target = $(_focusEle).attr('id');
		var _pageNo = parseInt($(_focusEle).val());
		var _imgTotalNo = globalImglist.length;
		var _activeNo = parseInt($('.img-page-btn-active').text());
		
		if (_target == "imgIndexNo") {
			
			if (_activeNo != _pageNo && _pageNo > 0 && _pageNo <= _imgTotalNo) {
				
				globalImgNo = _pageNo - 1;
				
				var _activeInptTaskId = globalImglist[globalImgNo].inptTaskId;
				
				fn_setImgPageBtn(_activeInptTaskId);
			}
		}
	}
});