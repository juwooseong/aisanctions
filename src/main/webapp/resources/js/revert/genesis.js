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
					
				} else {
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