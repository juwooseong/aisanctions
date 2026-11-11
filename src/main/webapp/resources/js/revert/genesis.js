var canvas_width_global = null;
var canvas_height_global = null;
var ctx_global = null;
var image_global = new Image();	

var cur_image_info_list = null;
var refresh_id_list = new Array();
var zoom_rate_global = 1;
var width_global;
var height_global;
var width_rate = 1;
var height_rate = 1;
var mouse_drag = false;

// 이미지 로드 코드
var imgType = "";
// 이미지 원본형태(image:스캔이미지, text:텍스트를 그린 이미지)
var imgSrcType = "";
// 텍스트를 그린 이미지의 배율 (이미지 크기 / 화면 표시 크기, fn_text_to_image_src 에서 설정)
var text_image_scale_global = 1;

/*
 * 원문보기 (화면맞춤 <-> 원본 크기 전환)
 * - fit      : canvas 기본 크기(canvas_width_global x canvas_height_global)에 이미지를 맞춰 표시 (기존 동작)
 * - original : 이미지 원본 픽셀 크기로 canvas 를 잡아 표시, 영역을 넘는 부분은 #canvas_area 스크롤로 확인
 * - 버튼(심사상세 툴바) 클릭 → fn_toggle_view_mode() → fn_set_view_mode()
 * - 이미지 로드(onload) 시에도 fn_get_base_size() 로 크기를 잡아 문서/탭을 바꿔도 보기 모드 유지
 * - 이미지 초기화 버튼(#zoomRefreshBtn, common_detail.js) 클릭 시 화면맞춤으로 복귀
 * - 항목 하이라이트 좌표는 원본 이미지 기준이라 width_rate/height_rate 재계산으로 두 모드 모두 위치가 맞음
 */
// 이미지 보기 모드 (fit: 화면맞춤(기본), original: 원본 크기)
var view_mode_global = "fit";
// 원본 모드에서 허용하는 최소 축소배율
var ORIGINAL_MIN_ZOOM = 0.2;

// 보기 모드에 맞는 기준 canvas 크기 (배율 1 기준)
// - 원본 모드 : 이미지 원본 크기 / 화면맞춤 또는 이미지 로드 전 : 기본 canvas 크기
function fn_get_base_size() {
	// 텍스트형 문서는 원본 크기가 없으므로 두 모드 모두 가로는 canvas 폭, 세로는 이미지 비율만큼
	// (긴 전문은 세로로 긴 이미지 → canvas 도 세로로 늘어나 #canvas_area 세로 스크롤, 짧은 전문은 기본 크기와 같음)
	if (imgSrcType == "text" && image_global && image_global.width) {
		return { w: Math.round(image_global.width / text_image_scale_global), h: Math.round(image_global.height / text_image_scale_global) };
	} else if (view_mode_global == "original" && image_global && image_global.width) {
		return { w: image_global.width, h: image_global.height };
	} else {
		return { w: canvas_width_global, h: canvas_height_global };
	}
}

// 보기 모드 전환 버튼 아이콘/툴팁 갱신
// - 원본 모드 : fa-compress / '화면에 맞추기', 화면맞춤 : fa-expand / '원본 크기로 보기'
// - 버튼이 없는 화면(genesis.js 를 쓰는 다른 상세 화면)은 아무것도 하지 않음
function fn_update_view_mode_btn() {
	var $btn = $('#viewModeBtn');
	if ($btn.length == 0) {
		return;
	}

	if (view_mode_global == "original") {
		$btn.attr('title', '화면에 맞추기').find('i').removeClass('fa-expand').addClass('fa-compress');
	} else {
		$btn.attr('title', '원본 크기로 보기').find('i').removeClass('fa-compress').addClass('fa-expand');
	}
}

// 보기 모드 설정 후 현재 이미지를 해당 모드 크기로 다시 그림
// mode : "original"(원본 크기), 그 외 값은 "fit"(화면맞춤)
function fn_set_view_mode(mode) {
	view_mode_global = (mode == "original") ? "original" : "fit";
	fn_update_view_mode_btn();

	// 이미지 로드 전/실패 시에는 모드만 저장 → 다음 이미지 로드(onload) 때 적용
	if (imgType != "success" || !ctx_global || !image_global || !image_global.width) {
		return;
	}

	// 하이라이트 깜빡임 타이머 중지 (canvas 크기 변경 후 아래에서 다시 시작)
	fn_remove_blink_list();

	// 모드 전환 시 배율/회전 초기화
	rotateVal = 360;
	zoom_rate_global = 1;

	// canvas 크기 변경 (크기를 바꾸면 회전 등 context 변환도 초기화됨)
	var _base = fn_get_base_size();
	canvas.width = _base.w;
	canvas.height = _base.h;

	// 원본 이미지 좌표 → canvas 좌표 변환 비율 (항목 박스/하이라이트 위치 계산용)
	width_rate = canvas.width / image_global.width;
	height_rate = canvas.height / image_global.height;

	// 이미지 다시 그리기
	ctx_global.clearRect(0, 0, canvas.width, canvas.height);
	ctx_global.drawImage(image_global, 0, 0, image_global.width, image_global.height, 0, 0, canvas.width, canvas.height);

	// 항목 박스 다시 그리기 (fn_clear_box 를 거치므로 형광펜/핀(annotation-host.js)도 다시 그려짐)
	fn_draw_multi_box();

	// 선택된 항목이 있으면 하이라이트 깜빡임 다시 시작
	if (globalInform.length > 0) {
		fn_selected_blink(globalInform);
	}

	// 이미지 영역 스크롤 위치 초기화
	$('#canvas_area').scrollTop(0).scrollLeft(0);
}

// 화면맞춤 <-> 원본 전환
function fn_toggle_view_mode() {
	fn_set_view_mode(view_mode_global == "original" ? "fit" : "original");
}

function getMousePos(canvas, evt) {

	var rect = canvas.getBoundingClientRect();

	return {
		x:evt.clientX - rect.left,
		y:evt.clientY - rect.top
	};
}

function fn_mouse_down(e) {

	startTime = new Date().getTime();
	console.log("fn_mouse_down");
	e.preventDefault();
	mouse_drag = true;

	locA = getMousePos(canvas, e);
}


function fn_mouse_move(e) {

	e.preventDefault();
	locB = getMousePos(canvas, e);
	
	if(mouse_drag) {
		console.log(mouse_drag);
		document.getElementById('canvas_area').scrollLeft = document.getElementById('canvas_area').scrollLeft -(locB.x - locA.x);
		document.getElementById('canvas_area').scrollTop = document.getElementById('canvas_area').scrollTop -(locB.y - locA.y);
	}
}


function fn_mouse_up(e) {

	e.preventDefault();
	mouse_drag = false;
	locB = getMousePos(canvas, e);
}


function fn_add_refresh_list(param) {

	refresh_id_list[refresh_id_list.length] = param;
}

function fn_remove_blink_list() {

	if (refresh_id_list.length == 0) {
		return;
	}

	for(i=0; i<refresh_id_list.length; i++ ) {
		clearInterval(refresh_id_list[i]);
	}
	
	refresh_id_list = [];

}	
	

function fn_draw_multi_box() {
	
	fn_remove_blink_list();
	fn_clear_box();		
	
	var _blinkTpe = $('[name="blinkType"]:checked').val();
	
	// all: 전체항목 selected: 선택된 항목
	if (_blinkTpe == "all"){
		
		//좌표 갯수만큼 For 문을 돌면서 박스를 그려준다.
		for (i=0; i<cur_image_info_list.length;i++) {
			
			fn_draw_rect_single(cur_image_info_list[i], zoom_rate_global);
			
		}
		//ctx_global.stroke();
	}
	
}	

function fn_draw_rect_single(param, zoom_rate) {
	
	ctx_global.beginPath();

	ctx_global.rect(param[2][0] * zoom_rate * width_rate, 
					param[2][1] * zoom_rate * height_rate, 
					(param[2][2] - param[2][0]) * zoom_rate * width_rate, 
					(param[2][3] - param[2][1])* zoom_rate * height_rate)  ;

	ctx_global.lineWidth = 1;

	if (param[1] == "Y") {
		ctx_global.strokeStyle = "red";
		ctx_global.fillStyle = "rgba(255,0,0," + 0.02 + ")";
		color_global = "red";
		
		
	}
	else {
		ctx_global.strokeStyle = "blue";
		ctx_global.fillStyle = "rgba(0,0,255," + 0.02 + ")";
		color_global = "blue";
		

	}
	//rect_fill_color(ctx_global,color_global);
	ctx_global.fill();	
	ctx_global.closePath();
	ctx_global.stroke();
	
}	


function fn_draw_multi_box_blink(p_position, counter) {
	
	fn_clear_box();		
	//좌표 갯수만큼 For 문을 돌면서 박스를 그려준다.
	//cur_image_info_list[p_index][1] --> 좌표 리스트
	data = cur_image_info_list;
	
	var _blinkTpe = $('[name="blinkType"]:checked').val();
	
	// all: 전체항목 selected: 선택된 항목
	if (_blinkTpe == "selected"){
		
		for (i=0; i<data.length;i++) {
			blink = "N";
			for(j=0; j<p_position.length; j++) {
				
				if( data[i][2][0] == p_position[j][0] && 
					data[i][2][1] == p_position[j][1] && 
					data[i][2][2] == p_position[j][2] && 
					data[i][2][3] == p_position[j][3]  ) {

					blink = "Y";
					fn_draw_rect_single_blink(data[i], zoom_rate_global, blink, counter);
					break;
				}
			}
		}
		
	} else {
	
		for (i=0; i<data.length;i++) {
			blink = "N";
			for(j=0; j<p_position.length; j++) {
				
				if( data[i][2][0] == p_position[j][0] && 
					data[i][2][1] == p_position[j][1] && 
					data[i][2][2] == p_position[j][2] && 
					data[i][2][3] == p_position[j][3]  ) {

					blink = "Y";
					break;					
				}
			}

			fn_draw_rect_single_blink(data[i], zoom_rate_global, blink, counter);
			
		}
	}
	//ctx_global.stroke();
}	
		
function fn_draw_rect_single_blink(param, zoom_rate, blink, counter) {
	
	ctx_global.beginPath();

	ctx_global.rect(param[2][0] * zoom_rate * width_rate, 
					param[2][1] * zoom_rate * height_rate, 
					(param[2][2] - param[2][0]) * zoom_rate * width_rate, 
					(param[2][3] - param[2][1])* zoom_rate * height_rate)  ;	
					
	ctx_global.lineWidth = 1;
	
	if(param[1] == null) {
		param[1] = 'N';
	}
	
	//console.log("param[1] >>>>  " + param[2] + "    blink >>>> " + blink);
	
	if (param[1] == "Y" && blink == "Y") {
		
		//console.log("position >>>> " + param[2] +  "   blink >>>> " + blink);
		ctx_global.strokeStyle = (counter%2==0)? "yellow" : "red";
		ctx_global.fillStyle = "rgba(255,0,0," + 0.02 + ")";	
		
	}
	else if (param[1] == "Y" && blink == "N"){

		
		ctx_global.strokeStyle = "red";
		ctx_global.fillStyle = "rgba(255,0,0," + 0.02 + ")";				
		
	} else if (param[1] == "N" && blink == "Y"){
		ctx_global.strokeStyle = (counter%2==0)? "yellow" : "blue";
		ctx_global.fillStyle = "rgba(0,0,255," + 0.02 + ")";
		
	} else {
		ctx_global.strokeStyle = "blue";
		ctx_global.fillStyle = "rgba(0,0,255," + 0.02 + ")";			
	}
		
	ctx_global.fill();	
	ctx_global.closePath();
	ctx_global.stroke();


}			

function fn_selected_blink(p_position) {
	
	if (imgType == "error") {
		return false;
	}
	
	fn_remove_blink_list();
	fn_clear_box();

	if (rotateVal % 360 == 0) {
		
		var counter = 1;
		//0.5 초 지연이후 Blink 가 된다. 이것을 줄이기 위해서는 Rest 를 호출해야 하는데 이 시간도 만만치 않을 듯.....
		//현재 보고 있는 화면의 좌표정보를 가지고 있어야 할 것 같은데...
		//빨리 DB 랑 WAS 연동해서 테스트 해보고 싶다.
		//counter : 짝수이면 노란색, 홀수이면 빨간색
		fn_draw_multi_box_blink(p_position, 0);
		
		interval = setInterval(function() {
			fn_draw_multi_box_blink(p_position, counter++);
		},500);		
		fn_add_refresh_list(interval);	
	}
}


function fn_get_image_info_for_menu() {
	
	//선택된 item 정보
	var _active_inptBlGrpNo = $('#active_inptBlGrpNo').val();
	var _active_inptTaskId = $('#active_inptTaskId').val();
	var _active_imexHisCd = $('#active_imexHisCd').val();
	var _active_spdKind = $('#active_spdKind').val();
	
	var inform = [];
	
	for(var i in globalImgCdntsData) {
		
		if (_active_inptBlGrpNo == globalImgCdntsData[i]["inptBlGrpNo"] && 
				_active_imexHisCd == globalImgCdntsData[i]["imexHisCd"] && 
				_active_inptTaskId == globalImgCdntsData[i]["inptTaskId"] && 
				_active_spdKind == globalImgCdntsData[i]["spdKind"]) {

			var _tmp_data = [];
			
			_tmp_data.push(globalImgCdntsData[i]["inptTaskId"]);
			_tmp_data.push(globalImgCdntsData[i]["aiInptAltYn"]);
			
			//현 totaltext 좌표정보가 들어오지 않아 오류발생, 임시조치
			if(globalImgCdntsData[i]["itmCoordinates"] == "[,,,]") {
				globalImgCdntsData[i]["itmCoordinates"] = "[]";
			}
			
			_tmp_data.push(JSON.parse(globalImgCdntsData[i]["itmCoordinates"]));
			_tmp_data.push(globalImgCdntsData[i]["inptElmtId"]);
			
			inform.push(_tmp_data);
		}
	}	
	
	return inform;
	
}


function fn_init_draw_image_for_tab(_inptBlGrpNo, _imexHisCd, _inptTaskId, _spdKind, _inptElmtId) {
	
	if (imgType == "error") {
		return false;
	}
	
	if (rotateVal % 360 == 0) {
		fn_remove_blink_list();
		cur_image_info_list = null;	
		cur_image_info_list = fn_get_image_info_for_menu();	
		fn_draw_multi_box();
	}
}
	
function fn_init_draw_image(_inptBlGrpNo, _imexHisCd, _inptTaskId, _spdKind, _inptElmtId) {

	fn_remove_blink_list();
	cur_image_info_list = null;
	
	zoom_rate_global = 1;
	
	p_index = 0;

	if(image_global  == null) {
		alert("image_global is NULL");
		image_global = new Image();
		
	}

	cur_image_info_list = fn_get_image_info_for_menu();
	
	canvas.width = canvas_width_global;
	canvas.height = canvas_height_global;

	ctx_global = canvas.getContext('2d');
					
	
	var options = {};		
	options.inptTaskId = parseInt(_inptTaskId);
	options.inptMstSrno = globalInptMstSrno;
	options.imexHisCd = _imexHisCd;

	var response;

	//Common Agent 호출을 통해 Image 를 얻어온다.....
	
	$.ajax({

		url : "/api/common/detail/imgRest",
		type : "post",
		cache: false,
		async : false,
		data : options ,			
		dataType: "json",
		success : function(data) {
			if(data.resultCode=="200"){
				response = data.imgStr;
				
				if (response == "" || response == null) {
					
					alert('이미지 로드가 실패했습니다.');
					
					//임시 이미지데이터
//					response = "/resources/img/sanction/BL110.png";
//					image_global.src =  response;
					imgType = "error";
					
				} else if (data.type == "text") {
					imgSrcType = "text";
					// 텍스트(전문 등)가 넘어온 경우 텍스트를 이미지로 그려서 사용
					image_global.src = fn_text_to_image_src(response);
					imgType = "success";
				} else {
					imgSrcType = "image";
					image_global.src =  "data:image/jpeg;base64," + response;
					imgType = "success";
				}
				
			} else {
				fnAlertErrorMsg(data, true);
				
				//임시 이미지데이터
//				response = "/resources/img/sanction/BL110.png";
//				image_global.src =  response;
				imgType = "error";
			}
		},
		error : function(e) {
			
			alert('이미지 로드가 실패했습니다.');
			
			//임시 이미지데이터
//			response = "/resources/img/sanction/BL110.png";
//			image_global.src =  response;
			imgType = "error";
		}
	});		
	
	if (imgType == "error") {
		
		fn_clear_box();
		
		ctx_global.clearRect(0, 0, canvas.width, canvas.height);		
		ctx_global.rect(0 , 0 , canvas.width, canvas.height);
		ctx_global.fillStyle = "#fff";
		ctx_global.fill();
		
		ctx_global.moveTo(0, canvas.height);
		ctx_global.lineTo(canvas.width, 0);
		ctx_global.moveTo(0, 0);
		ctx_global.lineTo(canvas.width, canvas.height);
		ctx_global.strokeStyle = "#ccc";
		ctx_global.stroke();
		
	} else {
		
		image_global.onload = function(){
			// 보기 모드(화면맞춤/원본)에 맞춰 canvas 크기 설정
			// (fn_get_base_size 가 image_global 크기를 쓰므로 이미지 로드 완료 후 계산)
			var _base = fn_get_base_size();
			canvas.width = _base.w;
			canvas.height = _base.h;
			fn_update_view_mode_btn();


			width_rate = canvas.width/this.width;
			height_rate = canvas.height/this.height;			
			
			
			ctx_global.clearRect(0, 0, canvas.width, canvas.height);		
			
			ctx_global.drawImage(image_global , 0, 0 , image_global.width , image_global.height , 0 , 0 , canvas.width , canvas.height);	
			
			fn_draw_multi_box();
			
			var _inform_length = globalInform.length;
			
			if (_inform_length > 0) {
				
				fn_selected_blink(globalInform);
				
			}
		};
	}
}


// 텍스트(SWIFT 전문 등)를 그린 후 이미지 src(data URI)로 반환
// 확대/회전/하이라이트 로직이 image_global 기준으로 동작하므로 이미지로 변환해서 사용한다.
// - 글자 크기 기준으로 그림 (줄바꿈 없이 원문 줄 그대로)
// - 짧은 전문 : 화면 기준 14px ~ 11px 중 canvas 한 장(기본 크기)에 다 들어오는 가장 큰 글자로 그림
// - 긴 전문   : 11px 로도 한 장에 안 들어오면 글자 11px 고정, 이미지를 내용 크기만큼 늘려 그림
//               (가로 : 가장 긴 줄, 세로 : 줄 수 → fn_get_base_size 가 이 크기로 canvas 를 잡아 #canvas_area 가로/세로 스크롤)
function fn_text_to_image_src(text) {

	var _minFontSize = 11;			// 화면 기준 최소 글자 크기 (확대 없이 읽을 수 있는 크기)
	var _maxFontSize = 14;			// 화면 기준 최대 글자 크기
	var _lineRate = 1.4;			// 줄 간격 (글자 크기 대비)
	var _scale = 3;					// 배율 : 확대 시 글자가 깨지지 않도록 고해상도로 그림
	var _maxCanvasSize = 32000;		// 브라우저 canvas 최대 크기(약 32767px) 이내
	var _padding = 20;				// 화면 기준 여백 (위/아래/오른쪽)
	var _paddingLeft = 50;			// 화면 기준 왼쪽 여백 : 이미지 영역 왼쪽 위에 떠 있는 주석 툴바(#annoToolbar, left 8px + 버튼 32px)와
									// 겹치지 않도록 넓게 (이미지가 영역보다 넓으면 canvas 가 영역 왼쪽 끝부터 그려짐)
	var _fontFamily = "'Malgun Gothic', '맑은 고딕', 'Dotum', monospace";

	var _ctx = document.createElement('canvas').getContext('2d');
	var _srcLines = String(text).replace(/\r\n?/g, "\n").replace(/\t/g, "    ").split("\n");

	// 글자 100px 기준 가장 긴 줄 폭 (글자 폭은 글자 크기에 비례)
	_ctx.font = "100px " + _fontFamily;

	var _maxLineWidth100 = 1;

	for (var i = 0; i < _srcLines.length; i++) {
		_maxLineWidth100 = Math.max(_maxLineWidth100, _ctx.measureText(_srcLines[i]).width);
	}

	// canvas 한 장(기본 크기)에 가로/세로 모두 들어오는 가장 큰 글자 크기 (0.5px 단위, 14px ~ 11px)
	var _fitFontSize = Math.min(_maxFontSize,
			100 * (canvas_width_global - _paddingLeft - _padding) / _maxLineWidth100,
			(canvas_height_global - (_padding * 2)) / (_srcLines.length * _lineRate));
	var _viewFontSize = Math.max(_minFontSize, Math.floor(_fitFontSize * 2) / 2);

	// 화면 기준 이미지 크기 : 최소 기본 canvas 크기, 넘치면 내용 크기만큼
	var _viewWidth = Math.max(canvas_width_global, Math.ceil(_maxLineWidth100 * _viewFontSize / 100 + _paddingLeft + _padding));
	var _viewHeight = Math.max(canvas_height_global, Math.ceil(_srcLines.length * _viewFontSize * _lineRate + (_padding * 2)));

	// 아주 긴 전문은 이미지/canvas 최대 크기를 넘지 않도록 배율을 낮추고(최소 1배), 1배로도 넘치면 최대 크기까지만 그림
	_scale = Math.max(1, Math.min(_scale, _maxCanvasSize / Math.max(_viewWidth, _viewHeight)));
	_viewWidth = Math.min(_viewWidth, _maxCanvasSize);
	_viewHeight = Math.min(_viewHeight, _maxCanvasSize);

	// 지정 배율로 그림 (글자 크기/여백도 배율만큼)
	var _textCanvas = document.createElement('canvas');

	_textCanvas.width = Math.round(_viewWidth * _scale);
	_textCanvas.height = Math.round(_viewHeight * _scale);

	// canvas 크기를 바꾸면 context 설정이 초기화되므로 크기 지정 후 설정
	var _textCtx = _textCanvas.getContext('2d');
	var _fontSize = _viewFontSize * _scale;

	_textCtx.fillStyle = "#fff";
	_textCtx.fillRect(0, 0, _textCanvas.width, _textCanvas.height);
	_textCtx.fillStyle = "#000";
	_textCtx.textBaseline = "top";
	_textCtx.font = _fontSize + "px " + _fontFamily;

	for (var j = 0; j < _srcLines.length; j++) {
		_textCtx.fillText(_srcLines[j], _paddingLeft * _scale, (_padding * _scale) + (j * _fontSize * _lineRate));
	}

	// 화면 표시 크기 = 이미지 크기 / 배율 (fn_get_base_size 에서 canvas 크기로 사용)
	text_image_scale_global = _textCanvas.width / _viewWidth;

	return _textCanvas.toDataURL("image/png");
}

function fn_init() {

	canvas = document.getElementById('canvas');
	canvas_width_global = canvas.width ;
	canvas_height_global = canvas.height ;
	
	canvas.addEventListener('mousedown', fn_mouse_down);
	canvas.addEventListener('mousemove', fn_mouse_move);
	canvas.addEventListener('mouseup', fn_mouse_up);
	
}	

function fn_init_box() {

	window.location.reload(true);
}	


function fn_clear_box() {

	if (ctx_global) {
		
		ctx_global.beginPath();
		
		ctx_global.clearRect(0, 0, canvas.width, canvas.height);
		ctx_global.drawImage(image_global, 0, 0, image_global.width ,image_global.height, 0, 0, canvas.width, canvas.height);	
		ctx_global.stroke();
	}
}	

function fn_zoom_image(arg, rotateVal, _type) {
	
	if (imgType == "error") {
		return false;
	}
	
	// 긴 텍스트 이미지(SWIFT 전문)는 확대 시 canvas 최대 크기(약 32767px)를 넘으면 그려지지 않으므로 확대 중지
	if (arg == "+" && Math.max(canvas.width, canvas.height) * 1.1 > 32000) {
		return false;
	}
	
	fn_remove_blink_list();
	
	zoom_rate = 1;

	if (arg == "+" ) {
		zoom_rate =  zoom_rate * 1.1;
	} else {
		zoom_rate = zoom_rate / 1.1;
	}	

//	if ( Math.floor(zoom_rate_global * 10000)/10000 == 1 && arg =="-" ){
//		zoom_rate = 1;
//	}
	
	fn_clear_box();	
	
	ctx_global.beginPath();
	
	zoom_rate_global = zoom_rate_global * zoom_rate;
	
	if (zoom_rate_global < 1) {
		zoom_rate_global = 1;
		zoom_rate = 1; 
	}
	
	canvas.width = canvas.width * zoom_rate;
	canvas.height = canvas.height * zoom_rate;
	
	ctx_global.drawImage(image_global, 0, 0, image_global.width , image_global.height, 0, 0, canvas.width  , canvas.height);
	
	fn_draw_multi_box();
	
	var _inform_length = globalInform.length;
	
	if (_inform_length > 0) {

		fn_selected_blink(globalInform);
		
	}
	
	if (!(rotateVal % 360 == 0)) {
		
		fn_rotate_img(rotateVal, _type, zoom_rate, "zoom");
	}
}

function fn_rotate_img(rotate, _type, zoom_rate, mode) {
	
	if (imgType == "error") {
		return false;
	}
	
	fn_remove_blink_list();
	fn_clear_box();
	
	ctx_global.clearRect(0, 0, canvas.width, canvas.height);		

	var _oig_canvas_width = $('#canvas').prop("width");
	var _oig_canvas_height = $('#canvas').prop("height");
	
	if (mode == "rotate") {
		
		$('#canvas').prop("height", _oig_canvas_width);
		$('#canvas').prop("width", _oig_canvas_height);
		var width = $('#canvas').prop("width");
		var height = $('#canvas').prop("height");
		
		ctx_global.translate(canvas.width/2, canvas.height/2);
		ctx_global.rotate(rotate * Math.PI / 180);
		ctx_global.translate(-(canvas.width/2), -(canvas.height/2));
		
	} else {
			
		if (!(rotateVal % 180 == 0)) {
			$('#canvas').prop("height", _oig_canvas_height);
			$('#canvas').prop("width", _oig_canvas_width);
			var width = $('#canvas').prop("width");
			var height = $('#canvas').prop("height");
		}
		
		var width = $('#canvas').prop("width");
		var height = $('#canvas').prop("height"); 
		
		ctx_global.translate(canvas.width/2, canvas.height/2);
		ctx_global.rotate(rotate * Math.PI / 180);
		ctx_global.translate(-(canvas.width/2), -(canvas.height/2));
	}
	
	if (zoom_rate_global < 1) {
		zoom_rate_global = 1;
		zoom_rate = 1; 
	}

	if (!(rotateVal % 180 == 0)) {
//		ctx_global.drawImage(image_global, +(100 * zoom_rate), -(100 * zoom_rate), canvas.width -(200 * zoom_rate), canvas.height +(200 * zoom_rate));
		ctx_global.drawImage(image_global, +(100 * zoom_rate_global), -(100 * zoom_rate_global), canvas.width -(200 * zoom_rate_global), canvas.height +(200 * zoom_rate_global));
	} else {
		ctx_global.drawImage(image_global, 0, 0, image_global.width , image_global.height, 0, 0, canvas.width  , canvas.height);
	}
	
	if (rotateVal % 360 == 0) {
		
		fn_selected_blink(globalInform);
	}
}

function fn_rotate_zoom_image(arg) {
	
	if (imgType == "error") {
		return false;
	}
	
	// 긴 텍스트 이미지(SWIFT 전문)는 확대 시 canvas 최대 크기(약 32767px)를 넘으면 그려지지 않으므로 확대 중지
	if (arg == "+" && Math.max(canvas.width, canvas.height) * 1.1 > 32000) {
		return false;
	}

	fn_remove_blink_list();
	
	zoom_rate = 1;

	if (arg == "+" )
		zoom_rate =  zoom_rate * 1.1;
		
	else
		zoom_rate = zoom_rate / 1.1;
		

	if ( Math.floor(zoom_rate_global * 10000)/10000 == 1 && arg =="-" ){
		zoom_rate = 1;
	}	
	
	fn_clear_box();	
	
	ctx_global.beginPath();
	
	zoom_rate_global = zoom_rate_global * zoom_rate;

	canvas.width = canvas.width * zoom_rate;
	canvas.height = canvas.height * zoom_rate;

	ctx_global.translate(canvas.width/2, canvas.height/2);
	ctx_global.rotate(90 * Math.PI / 180);
	ctx_global.translate(-(canvas.width/2), -(canvas.height/2));

}