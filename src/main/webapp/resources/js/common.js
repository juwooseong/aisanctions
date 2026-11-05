//console.log('common.js 로드');
var _isAlertLoaded = false;

function iframeLoaded(_height){
	$('iframe').each(function(){
		let $this = $(this);
		if($this.hasClass('show')){
			$this.height(_height); 
		}
	});
}

/*window.onload = function(){
	console.log('onload : ', $('body').height());
	if(parent && parent.length > 0){
		parent.iframeLoaded($('body').height());
	}
};*/

Pace.on('done', function(){
	if(parent && parent.length > 0){
		parent.iframeLoaded($('body').height()+10);
	}
});

var APP = {
	contextPath : '',
	env : '',
	getCtx : function() {
		return this.contextPath;
	},
	setCtx : function(_ctx){
		this.contextPath = _ctx;
	},
	getEnv : function() {
		return this.env;
	},
	setEnv : function(_env){
		this.env = _env;
	}
};

$.ajaxSetup({
	global : true
});

$(function(){
	$(document).ajaxError(function(e, xhr, settings, exception){
		if(xhr && (xhr.status == 500 || xhr.status == 0)){
			if(!_isAlertLoaded){
				alert('처리중 오류가 발생하였습니다.'); // 오류 처리가 없을 경우 alert 으로 처리함
				
//				window.parent.location.replace("/error/500");
				
				_isAlertLoaded = true;
				
				setTimeout(function(){
					_isAlertLoaded = false;
				},2000);
				
				h_loading();
			}
		}
	});

	$(document).ajaxComplete(function(){
		if(parent && parent.name){
			try{
				
			}catch(e){
				console.log('resize 함수 없음');
			};
		}
	});
});

var dolocateMenu = null;
var checkLogin = null;

//퍼블리싱 추가
function layer(cont){
	
//	$('body').append('<div class="dim"></div>');
//	$('.dim').fadeIn();
//	$(cont).fadeIn();
//	$(cont).css({
//		'margin':'-'+($(cont).outerHeight()/2)+'px 0 0 -'+($(cont).outerWidth()/2)+'px'
//	})
}

function layerClose(){
//	$('.layer').fadeOut();
//	$('.dim').fadeOut(function(){
//		$('.dim').remove();
//	});
}

$(function() {

	//함수 선언
	var initPage, initEvent;
	var getMenuData, setTabMenu, setMainMenu, setSubMenu, setTitle;
	var fnCheckMenu, fnDeleteMenu;

	//변수 선언
	var tab_data = [];
	
	//main_menu_data
	var main_menu_data = {};
	
	//sub_menu_data
	var sub_menu_data = {};
	
	//날짜 validation 최종점검 함수선언
	var validationEvent;

	//init
	initPage = function() {
		
		initEvent();
		
		// 사용자정보 확인
		if(!resetUserInfo()) return;
		// 사용자정보 세팅
		var userData = JSON.parse(sessionStorage.getItem('auth_data'));
		
		// 사용자 최종접속시간 체크
		if (userData.finloginDtm) {
			$('#loginInfo').text(userData.name + ' (최종접속시간 : ' + userData.finloginDtm + ')');
		} else {
			$('#loginInfo').text(userData.name + ' (최종접속시간 : - )');
		}
		
		// 사용자 부재여부 아이콘(화면 상단) 초기화
		initHeaderAbsenceIcon();
		
		//menu data 유무확인
		//sessionStorage에서 main menu 정보 받기
		var main_menu_data = JSON.parse(sessionStorage.getItem('main_menu_data'));
		//sessionStorage에서 sub menu 정보 받기
		var sub_menu_data = JSON.parse(sessionStorage.getItem('sub_menu_data'));
		//sessionStorage에서 tab menu 정보 받기
		var tab_data = JSON.parse(sessionStorage.getItem('tab_data'));
		
		if (!main_menu_data) {
			
			//menu 정보받기
			getMenuData();
			
		} else {
			//selected tab data 삭제
			var _tab_data = {
				"menu_id" : "101000",
				"main_menu_id" : "100000",
				"p_menu_id" : "100000",
				"menu_path" : "Dashboard",
				"menu_nm" : "Dashboard",
				"menu_url" : "/dashboard/dashboard"
			};
			
			//sessionStorage에서 selected_tab_data 정보 받기
			var _selected_tab_data = sessionStorage.getItem('selected_tab_data');
			
			//sessionStorage에서 selected menu 정보 받기
			var _main_menu_id, _main_menu_nm;
			
			if (_selected_tab_data) {
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				
				//최초 로딩시, 404오류가 나면, 대시보드로 이동.
				try{
					$.ajax({
						url: _selected_tab_data.menu_url,
						data: {},
						async: false,
						dataType: 'text',
						error : function(request,status,error) {
							sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
						}
					});
				}catch(e){}
				
				_selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_main_menu_id = _selected_tab_data["main_menu_id"]
				_main_menu_nm = _selected_tab_data["menu_nm"]
				
			} else {
				
				// selected tab data sessionStorage에 추가
				tab_data = [];
				tab_data.push(_tab_data);
				sessionStorage.tab_data = JSON.stringify(tab_data);

				sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_main_menu_id = _selected_tab_data["main_menu_id"]
				_main_menu_nm = _selected_tab_data["menu_nm"]
				
			}

			//main manu 그리기
			setMainMenu(main_menu_data);
			
			//제목 그리기
			setSubMenu(_main_menu_id);
			
			//tab menu 그리기
			setTabMenu();
		}
	};
	
	
	//menu 정보받기
	getMenuData = function() {
		var _options = {};
		//sessionStorage에서 auth 정보 받기
		var _auth_data = JSON.parse(sessionStorage.getItem('auth_data'));
		
		_options.schAuth = _auth_data['auth'];
		_options.schAdminYN = _auth_data['admin_yn'];
	
		$.get("/api/common/menu?" + $.now(), _options, function(data){
	    	var json = data.resultList;
	    	if(!json.error){
	    		
	    		var _depth_1_name, _menu_id, _menu_nm, _menu_url, _p_menu_id, _menu_path;
	    		var _menu_id, _depth_2, _depth_3;
	    		
	    		//menu 분류
	    		for(var i in json) {
	    			
	    			_menu_id = json[i]["menu_id"];
	    			_depth_1 = _menu_id.substring(0, 1) + '00000';
	    			_depth_2 = _menu_id.substring(2, 4);
	    			_depth_3 = _menu_id.substring(4, 6);
	    			
	    			_menu_id = json[i]["menu_id"];
	    			_p_menu_id = json[i]["p_menu_id"];
					_menu_nm = json[i]["menu_nm"];
					_menu_url = json[i]["menu_url"];
	    			
	    			//main_menu
	    			if("00" == _depth_2 && "00" == _depth_3) {
	    				
	    				main_menu_data[_depth_1] = {
							"menu_id" : _menu_id,
							"menu_nm" : _menu_nm
	    				};
	    				
	    				sub_menu_data[_depth_1] = [];
	    				
					//sub_menu
	    			} else {
	    				
	    				var _temp_data = {
							"menu_id" : _menu_id,
							"p_menu_id" : _p_menu_id,
							"menu_nm" : _menu_nm, 
							"menu_url" : _menu_url
	    				};
	    				
	    				sub_menu_data[_depth_1].push(_temp_data);
	    			}
	    			
	    		}
	    		
	    		//메뉴데이터 저장
	    		sessionStorage.main_menu_data = JSON.stringify(main_menu_data);
	    		sessionStorage.sub_menu_data = JSON.stringify(sub_menu_data);

	    		//selected tab data 삭제
				var _tab_data = {
					"menu_id" : "101000",
					"main_menu_id" : "100000",
					"p_menu_id" : "100000",
					"menu_path" : "Dashboard",
					"menu_nm" : "Dashboard",
					"menu_url" : "/dashboard/dashboard",
					"close_lock" : "true"
				};
				
				// selected tab data sessionStorage에 추가
				tab_data = [];
				tab_data.push(_tab_data);
				sessionStorage.tab_data = JSON.stringify(tab_data);

				sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_main_menu_id = _selected_tab_data["main_menu_id"]
				_main_menu_nm = _selected_tab_data["menu_nm"]
				
				//main manu 그리기
				setMainMenu(main_menu_data);
				
				// left menu 그리기
				setSubMenu(_main_menu_id);
				
				//tab menu 그리기
				setTabMenu();
	    		
	    	}else{
	    		
	    		swal("Cancelled", "메뉴 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
	    	}
	    });
	}

	
	//main menu 생성
	setMainMenu = function(data) {
		var _main_menu_data = Object.keys(data);
		var _main_menu_id;
		
		$('#main_menu_zone').empty();
		
		var _html = ""
		for(var i in _main_menu_data) {
			
			_main_menu_id = _main_menu_data[i];
			
			_html += '<li>';
			_html += '<a class="main-menu-link" id=' + data[_main_menu_id]["menu_id"] + ' href="#">' + data[_main_menu_id]["menu_nm"] + '</a>';
			_html += '</li>';
		}
		
		$('#main_menu_zone').append(_html);
	}
	

	//sub menu 그리기
	setSubMenu = function(main_menu_id) {
		
		$('#' + main_menu_id).addClass('active');
		
		$('#sub_menu_zone').empty();
		
		var _depth_1_name, _menu_id, _menu_nm, _menu_url, _p_menu_id, _menu_path;
		var _menu_id, _depth_2, _depth_3;
		
		//sessionStorage에서 seb menu 정보 받기
		var _sessionStorage_data = JSON.parse(sessionStorage.getItem('sub_menu_data'));
	
		var _sub_menu_data = _sessionStorage_data[main_menu_id];
		
		_depth_1_name = _sub_menu_data[0]["menu_nm"];
		
		for(var i in _sub_menu_data) {
			
			_menu_id = _sub_menu_data[i]["menu_id"];
			_depth_1 = _menu_id.substring(0, 1) + '00000';
			_depth_2 = _menu_id.substring(2, 4);
			_depth_3 = _menu_id.substring(4, 6);
			
			_menu_id = _sub_menu_data[i]["menu_id"];
			_p_menu_id = _sub_menu_data[i]["p_menu_id"];
			_menu_nm = _sub_menu_data[i]["menu_nm"];
			_menu_url = _sub_menu_data[i]["menu_url"];
			
			if (_menu_nm.length > 20) {
				_menu_nm = _menu_nm.substring(0, 16) + '...';
			}
			
			//2depth
			if("00" != _depth_2 && "00" == _depth_3) {
				
				_menu_path = _menu_nm;
				
				var _html = '';
				
				_html += '<li>';
				
				
				if (_menu_url) {
					_html += '<a class="sub-menu-link" id="' + _menu_id + '" data-main_menu_id = "' + _depth_1 + '" data-menu_url = "' + _menu_url + '" data-p_menu_id = "' + _p_menu_id + '" data-menu_path = "' + _menu_path + '" href="#">';
					_html += '<span>' + _menu_nm + '</span>';
					_html += '</a>';
				} else {
					_html += '<a id="' + _menu_id + '" data-main_menu_id = "' + _depth_1 + '" data-menu_url = "' + _menu_url + '" data-p_menu_id = "' + _p_menu_id + '" data-menu_path = "' + _menu_path + '" href="#">';
					_html += _menu_nm;
					_html += '</a>';
					_html += '<p id="menu_3depth_' + _menu_id + '" class="sanction-p">';
					_html += '</p>';
				}
				
				_html += '</li>';
				
				$('#sub_menu_zone').append(_html);
			}
			
			//3depth
			if("00" != _depth_2 && "00" != _depth_3) {
				
				var _p_menu_nm = $('#' + _p_menu_id).attr('data-menu_path');
				
				_menu_path = _p_menu_nm + "/" + _menu_nm
				
				var _html = '';
				
				_html += '<a class="sub-menu-link" id="' + _menu_id + '" data-main_menu_id = "' + _depth_1 + '" data-menu_url = "' + _menu_url + '" data-p_menu_id = "' + _p_menu_id + '" data-menu_path = "' + _menu_path + '" href="#">';
				_html += '<span>' + _menu_nm + '</span>';
				_html += '</a>';
				
				//하위메뉴 있는 중메뉴 링크속성 삭제
				$('#menu_3depth_' + _p_menu_id).append(_html);
				
			}
		}
		
		setTitle(main_menu_id);
	}
	
	
	//tab menu 그리기
	setTabMenu = function() {
		console.log('setTabMenu');
		//menu-tab 비우기
		$('#menu-tab').empty();
		
		//sessionStorage에서 메뉴 체크
		var tab_data = sessionStorage.getItem('tab_data');
		
		if(null != tab_data) {
			
			tab_data = JSON.parse(tab_data);
			
			//tab 추가
			for(var i in tab_data) {
				
				var _menu_id = tab_data[i]["menu_id"];
				var _main_menu_id = tab_data[i]["main_menu_id"];
				var _menu_nm = tab_data[i]["menu_nm"];
				var _menu_url = tab_data[i]["menu_url"];
				var _menu_path = tab_data[i]["menu_path"];
				var _p_menu_id = tab_data[i]["p_menu_id"];
				var _menu_full_nm = _menu_nm;
				var _menu_close_lock = tab_data[i]["close_lock"];
				

				if (_menu_nm.length > 10) {
					_menu_nm = _menu_nm.substring(0, 10) + '...';
				}
				
				var _tab_html = '';
				
				_tab_html += '<li>';
				_tab_html += '<a class="tab-link" id="menu-tab-' + _menu_id + '" data-main_menu_id = "' + _main_menu_id +'" data-toggle="pill" data-menu_url = "' + _menu_url + '" data-p_menu_id = "' + _p_menu_id + '" data-menu_path = "' + _menu_path + '" ';
				_tab_html += 'href="#menu-content-' + _menu_id +'" role="tab" aria-controls="menu-tab-' + _menu_id +'" aria-selected="menu-content-' + _menu_id +'" title="' + _menu_full_nm + '">';
				
				var _setClassName = "sessionIdx" + i;
				
				// '101000' 은 제외
				
				if (_menu_close_lock == "true") {
					_tab_html += '<label class="tab-menu-lock-btn locked" id="'+_setClassName+'"><i class="fa fa-lock fa-lg mt-4 tab-menu-lock-icon"></i></label>';
				}else if(_menu_close_lock == "false"){
					_tab_html += '<label class="tab-menu-lock-btn unlocked" id="'+_setClassName+'"><i class="fa fa-unlock-alt fa-lg mt-4 tab-menu-lock-icon"></i></label>';
					//_tab_html += '<label class="tab-menu-lock-btn unlocked" id="'+_setClassName+'"><i class="fa fa-unlock fa-lg mt-4 tab-menu-lock-icon"></i></label>';
				}
				
				_tab_html += _menu_nm;
				if (_menu_id == '101000') {
					//_tab_html += ' <span class="fa fa-lock fa-lg">';
					_tab_html += ' ';
				} else if(_menu_close_lock == "false") {
					//_tab_html += ' <span class="badge-danger fa fa-remove fa-lg">';
					_tab_html += ' <label class="badge-danger tab-menu-cls-btn-mini"><i class="fa fa-close fa-lg mt-4 tab-menu-cls-icon"></i>';
				} else if(_menu_close_lock == "true"){
					_tab_html += ' <label class="badge-danger tab-menu-cls-btn-mini cls-lock"><i class="fa fa-close fa-lg mt-4 tab-menu-cls-icon"></i>';
				}
				_tab_html += '</label>';
				_tab_html += '</a>';
				_tab_html += '</li>';
				
				$('#menu-tab').append(_tab_html);
				
			}
			
			//sessionStorage에서 selected menu 정보 받기
			var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
			var _selected_menu_id, _selected_menu_url;
			
			if (_selected_tab_data) {
				
				_selected_menu_id = _selected_tab_data["menu_id"]
				_selected_menu_url = _selected_tab_data["menu_url"]
				
			} else {
				
//				_selected_menu_id = tab_data[0]["menu_id"]
//				_selected_menu_url = tab_data[0]["menu_url"]

			}
			
			$('#menu-tab-' + _selected_menu_id).addClass('active');
			$('#' + _selected_menu_id).addClass('active');
//			$('#menu-tabContent').empty();
			dolocateMenu(_selected_menu_url, _selected_menu_id);
		}
	}
	
	
	//제목세팅
	setTitle = function(menu_id){
		
		//sessionStorage에서 main menu 정보 받기
		var main_menu_data = JSON.parse(sessionStorage.getItem('main_menu_data'));
		var _main_menu_nm = main_menu_data[menu_id]["menu_nm"];
		
//		$('#menu_title').text(_main_menu_nm + '(' + env_mode_name + ')');
		$('#menu_title').text(_main_menu_nm);
	}
	
	
	//메뉴이동
	dolocateMenu = function(menu_url, menu_id){
		console.log('menu_url : ', menu_url, menu_id);
		if(!checkLogin()){
			//로그인세션체크
//			location.href = "/login";
			alert('세션이 만료되었습니다. 로그인화면으로 이동합니다.');
			
			window.parent.location.replace(loginUrl);
		} else {
			var working_paths = [];
			
			if(menu_url=="/working"){
				//작업안된 페이지.
//				$('#menu-tabContent').load('/error/working');
				$('#menu-tabContent').attr('src', '/err/working');
			} else {
				fnCheckMenu(menu_url, menu_id);
			}
		}
	};
	
	fnDeleteMenu = function(_menu_id){
		console.log('TAB 삭제 : ', _menu_id);
		if($('#menu-tabContent-'+_menu_id).length){
			$('#menu-tabContent-'+_menu_id).remove();
		}
	};
	
	// iframe 관련 메뉴 정보를 확인하기 위한 부분
	fnCheckMenu = function(_menu_url, _menu_id){
		let _$content = $('#menu-tabContent-tmp');
		let _$content_template = $('#menu-tabContent-template');
		
		if(_$content.length == 0) return
		
		// #menu-tabContent-template
		// TODO: _menu_id 가 존재하는지 확인해서 나머지 화면을 감추고 선택된 메뉴를 보인다.
		
		// 기존 iframe class 를 감춤
		_$content.find('iframe').removeClass('show').addClass('hide');
		
		console.log('fnCheckMenu : ', _menu_id, ' , href : ', window.location.href);
		
		if($('#menu-tabContent-'+_menu_id).length){
			// 존재할 경우
			console.log('#menu-tabContent-'+_menu_id, ' exists');
			
			if($('#menu-tabContent-'+_menu_id).height() == 10){
				$('#menu-tabContent-'+_menu_id).remove();
				console.log('#menu-tabContent-'+_menu_id, ' height 10, remove');
			}
		}
		
		if(!$('#menu-tabContent-'+_menu_id).length){
			console.log('#menu-tabContent-'+_menu_id, ' not exists');
			// 존재하지 않을 경우 
			let _clone = _$content_template.clone();
			_clone.attr('id', 'menu-tabContent-'+_menu_id);
			_clone.attr('name', 'menu_'+_menu_id);
			_clone.removeClass('hide').addClass('show');
			_clone.attr('src', _menu_url + "?" +$.now());
			_$content.append(_clone);
		}

		$('#menu-tabContent-'+_menu_id).removeClass('hide').addClass('show');
		$('#menu-tabContent-'+_menu_id).addClass('iframe100');
		
	};
	
	//세션체크
	checkLogin = function(){
		var result = false;

		$.ajax({
			url: '/api/common/login/check',
			data: {},
			async: false,
			dataType: 'json'
		}).done(function(data){
			//console.info(data);
			if(data.resultCode=="200"){
				result = true;
			} else if(data.resultCode=="401"){
				alert('중복 로그인으로 세션이 만료되었습니다.');
			} else {
				result = false;
			}
		});
		
		return result;
	}
	
	
	
	// 오늘날짜 이후인지 유효성 검증
	validationEvent = function(paramDate, calObject){
		var calElementValue = paramDate;
		var calElementYear = calElementValue.substr(0, 4);
		var calElementMonth = calElementValue.substr(5, 2);
		var calElementDay = calElementValue.substr(8, 4);
		var calElementValueConvt = calElementYear + calElementMonth + calElementDay;
		//var todayString = new Date().getFullYear() + "" + (new Date().getMonth()+1) + new Date().getDate();
		var todayString = new Date().getFullYear() + "" + (new Date().getMonth()+1) + (new Date().getDate() >= 10 ? new Date().getDate() : '0' + new Date().getDate());

		
		//console.log("today str : " + todayString);
		//console.log("cal str : " + calElementValueConvt);
		
		if(calElementValueConvt > todayString && !calObject.hasClass("adminBsnCal")){ // 오늘날짜 이후를 선택하면
			alert("오늘 이후의 날짜를 선택할 수 없습니다");
			calObject.focus().val("");
			$('#ui-datepicker-div').css('display','none');
			return;
		}else{
			calObject.val(paramDate);
			
		}
	}
	
	initEvent = function(){
		
		// 모든페이지 달력 validation
		var dateTmpVar = "";
		var dateTmpVarBlur = "";

		$('.init_btn').attr('title', '초기화');
		
		// 검색조건 초기화
		$(document).on('click','.init_btn', function(e) {
			
			// 이벤트 전파 제거
			e.stopPropagation();
			
			// form 초기화
			$(this).parents('.searchWrap').find('form')[0].reset();
			
			// 날짜초기화 세팅()
			initRangeCal();
			$('.calRange').attr('disabled',false);

			return false;
		});
		
		$(document).on('click','.cal', function() {
			dateTmpVar = $(this).val();
			//$(this).val("");
			$('#ui-datepicker-div').css('display','block');
		});
		
		$(document).on('keyup','.cal', function(key){
			if(key.keyCode == 13){
				$(this).blur();
			}
		});
		
		$(document).on('click', '.calRangeSchBtn', function(){
			validationRangeEvent();
		});
		
		$(document).on('click', '.manualDownloadLink', function(){
			
			var fileFlag = $(this).attr('id');
			
			if(confirm('사용자메뉴얼 PDF 파일을 다운로드 하시겠습니까?')){
				
				location.href = "/api/common/manual/download?fileFlag="+fileFlag;
				
			}
			/*
			
			if(confirm('사용자메뉴얼 PDF 파일을 다운로드 하시겠습니까?')){
				var param = {};
				
				$.post('/api/common/manual/download', param, function(data){
					if(data.resultCode == "200"){
						alert('정상적으로 처리되었습니다.');
					}
					
				});
			}*/
			
			
			
		});
		
		// 매뉴얼 업로드&다운로드 팝업	
		$(document).on('click', '#manualWinBtn', function(){
			var formManual = $('#formManual')[0];
			var winName = formManual.target;
			
			var userDataForValidation = JSON.parse(sessionStorage.getItem('auth_data'));
			$("#adminFlag").val(userDataForValidation.admin_yn);
			
			// 창 가운데정렬추가 #2(듀얼모니터 체크)
			var popupSizeW = "1100";
			var popupSizeH = "800";
			
			var curX = window.screenLeft;
			var curY = window.screenTop;
			
			var clientW = document.body.clientWidth;
			var clientH = document.body.clientHeight;
			
			var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
			var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
			
			window.open('about:blank', winName, 'left='+resultLeft+', top='+resultTop+', width=600, height=300, resizable=0, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
			
			formManual.submit();
		});
		
		// 사이드메뉴 aside 접기/펴기
		$(document).on('click', '#asideFoldBtn', function(){
			//console.log("click aside test!");
			if($(this).hasClass('openAside')){
				//console.log("close aside!");
				$(this).removeClass('openAside');
				$(this).html('<i class="fa fa-angle-double-right fa-lg mt-4 foldIcon" style="display: block;"></i>');
				
				$('.leftWrap').css('left','-190px');
				$('body.leftOpen').css('padding','0 0 0 0px');
			}
			else if(!$(this).hasClass('openAside')){
				//console.log("open aside!");
				$(this).addClass('openAside');
				$(this).html('<i class="fa fa-angle-double-left fa-lg mt-4 foldIcon" style="display: block;"></i>');
				
				$('.leftWrap').css('left','0px');
				$('body.leftOpen').css('padding','0 0 0 190px');
			}
		});
		// 화면 최상단 메인메뉴 클릭시
		$(document).on('click', '#main_menu_zone li', function(){
			if(!$('#asideFoldBtn').hasClass('openAside')){
				//console.log("open aside!");
				$('#asideFoldBtn').addClass('openAside');
				$('#asideFoldBtn').html('<i class="fa fa-angle-double-left fa-lg mt-4 foldIcon" style="display: block;"></i>');
				
				$('.leftWrap').css('left','0px');
				$('body.leftOpen').css('padding','0 0 0 190px');
			}
		});
		
		// 화면 상단 부재자 아이콘 클릭시 상태변경(부재중 <-> 온라인)
		$(document).on('click', '#absenceChangeBtn', function(){
			var userData = JSON.parse(sessionStorage.getItem('auth_data'));
			
			/*
			var get_absence = userData.absence;
			var get_admin_yn = userData.admin_yn;
			var get_auth = userData.auth;
			var get_eno = userData.eno;
			var get_finloginDtm = userData.finloginDtm;
			var get_loginDtm = userData.loginDtm;
			var get_name = userData.name;*/
			
			// 심사자와 QA 만 자신의 부재여부를 변경 가능함 
			if(userData.auth == '01' || userData.auth == '03'){
				if(userData.absence == 'Y'){
					// 부재중 -> 온라인
					if(confirm("부재상태를 해제 하시겠습니까?")){
						requestHeaderAbsence('N', userData);
					}
				}else if(userData.absence == 'N'){
					// 온라인 -> 부재중
					if(confirm("부재상태로 변경하시겠습니까?")){
						requestHeaderAbsence('Y', userData);
					}
				}
			}
		});
			
		$(document).on('change','.cal', function() {
			var dateStr = $(this).val();
			if(dateStr == '0000'){
				$(this).focus().val("");
				return;
			}
			var dateStrLen = dateStr.length;
			
			
			// YYYY-MM-DD 정규식
			if(dateStrLen == 10){
				var pattern = /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
				if(pattern.test(dateStr)){
					//$(this).val(dateStr);
					validationEvent(dateStr, $(this));
				}else{
					$(this).focus().val("");
					$('#ui-datepicker-div').css('display','none');
					return;
				}
			}
			// YYYYMMDD 정규식
			else if(dateStrLen == 8){
				var pattern = /^(19[7-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
				if(pattern.test(dateStr)){
					var convertedDate = dateStr.substring(0, 4) + "-" + dateStr.substring(4, 6) + "-" + dateStr.substring(6, 8);
					//$(this).val(convertedDate);
					validationEvent(convertedDate, $(this));
				}else{
					$(this).focus().val("");
					$('#ui-datepicker-div').css('display','none');
					return;
				}
			// MMDD 정규식
			}else if(dateStrLen == 4){
				 // MMDD 1단계
				var pattern = /[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}/;
				 // MMDD 2단계
				if(pattern.test(dateStr)){
					var convertTmpNumverMonth = Number(dateStr.substring(0, 2));
					var convertTmpNumverDay = Number(dateStr.substring(2, 4));
					
					if(convertTmpNumverMonth > 12 || convertTmpNumverDay > 31){
						$(this).focus().val("");
						$('#ui-datepicker-div').css('display','none');
						return;
					}else{
						var currYear = new Date().getFullYear();
						var convertedDate = currYear + "-" + dateStr.substring(0, 2) + "-" + dateStr.substring(2, 4);
						//$(this).val(convertedDate);
						validationEvent(convertedDate, $(this));
					}
				}else{
					$(this).focus().val("");
					$('#ui-datepicker-div').css('display','none');
					return;
				}
			}else{
				$(this).focus().val("");
				$('#ui-datepicker-div').css('display','none');
				return;
			}
		});
		
		//라디오버튼 css이벤트
		$(document).on('click','.radioSelector', function() {
			var targets = $(this).attr('class');
			var targetId = targets.split(" ")[0]
			
			/*$('.radioSelector').removeClass('radioActive');
			$('.radioSelector').addClass('radioDeactive');
			$('.radioSelector .radioCheckIcon').css('display','none');*/
			
			$('.'+targetId).removeClass('radioActive');
			$('.'+targetId).addClass('radioDeactive');
			$('.'+targetId+' .radioCheckIcon').css('display','none');
			
			$(this).removeClass('radioDeactive');
			$(this).addClass('radioActive');
			$('.radioActive .radioCheckIcon').css('display','block');
		});
		$(document).on('click','.radioSelectorLabel', function(){
			var targets = $(this).attr('id');
			
			$('.'+targets).removeClass('radioActive');
			$('.'+targets).addClass('radioDeactive');
			$('.'+targets+' .radioCheckIcon').css('display','none');
			
			var targetIds = $(this).attr('class');
			var targetId = targetIds.split(" ")[1]
			
			$('#'+targetId).removeClass('radioDeactive');
			$('#'+targetId).addClass('radioActive');
			$('.radioActive .radioCheckIcon').css('display','block');
		});
		// 체크박스 css이벤트
		$(document).on('click', '.checkSelector', function(){
			if($(this).hasClass('checkActive')){
				$(this).removeClass('checkActive');
				$(this).addClass('checkDeactive');
				var checkIcon = $(this).find('.checkBoxIcon');
				$(checkIcon).css('display','none');
			}else if($(this).hasClass('checkDeactive')){
				$(this).removeClass('checkDeactive');
				$(this).addClass('checkActive');
				var checkIcon = $(this).find('.checkBoxIcon');
				$(checkIcon).css('display','block');
			}
		});
		
		//검색조건 열기 닫기
		$(document).on('click','.btn-minimize', function() {
			
			var _collapse_yn = $(this).hasClass('collapsed');
			var _minimize = $(this).children('i');
			
			if (_collapse_yn) {
				
				_minimize.removeClass('icon-arrow-up');
				_minimize.addClass('icon-arrow-down');
				
			} else {
				
				_minimize.removeClass('icon-arrow-down');
				_minimize.addClass('icon-arrow-up');
				
			}
		});
		
		//main menu 클릭이벤트
		$(document).on('click','.main-menu-link', function() {
						
			//메뉴 id 받기
			var _menu_id = $(this).attr('id');
			
			$('.main-menu-link').removeClass('active');
			$('#' + _menu_id).addClass('active');
			setSubMenu(_menu_id);
		});
		
		//로그아웃
		$(document).on('click','#user_logout', function() {

			if(confirm("로그아웃 하시겠습니까?")){
				//sessionStorage 초기화
				sessionStorage.clear();
//				location.href = '/logout';
				$.ajax({
					url: '/api/common/logout',
					data: {},
					method: 'post',
					async: false
				}).done(function(data){
					
					var agent = navigator.userAgent.toLowerCase();

					if (agent.indexOf("safari") != -1) {

						// 크롬
						window.location.replace(loginUrl);

					} else {

						// 익스플로러
						window.open('','_self').close();
					}
				});
			}
		});
		
		//sub menu 클릭이벤트
		$(document).on('click','.sub-menu-link', function(e) {
			
			//이벤트 전파 제거
			e.stopPropagation();
			
			//메뉴 id 받기
			var _menu_id = $(this).attr('id');
			
			//sessionStorage에서 메뉴 id
			var _sessionStorage_id;
			
			//메뉴명 받기
			var _menu_nm = $(this).text().trim();
			
			//메뉴경로 받기
			var _menu_url = $(this).attr('data-menu_url');
			
			//메인 메뉴 id 받기
			var _main_menu_id = $(this).attr('data-main_menu_id');
			
			//부모 메뉴 id 받기
			var _p_menu_id = $(this).attr('data-p_menu_id');
			
			//sessionStorage에서 메뉴 체크
			var _tab_data_tmp = sessionStorage.getItem('tab_data');
			
			//부모 정보 받기
			var _menu_path = $(this).attr('data-menu_path');
			
			//selected tab data
			var _tab_data = {
				"menu_id" : _menu_id,
				"main_menu_id" : _main_menu_id,
				"p_menu_id" : _p_menu_id,
				"menu_path" : _menu_path,
				"menu_nm" : _menu_nm, 
				"menu_url" : _menu_url,
				"close_lock" : "false"
			};
			
			//sessionStorage에서 selected_tab_data 정보 받기
			var _selected_tab_data = sessionStorage.getItem('selected_tab_data');
			
			//sessionStorage에서 selected menu 정보 받기
			var _selected_menu_id;
			
			if (_selected_tab_data) {
				
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_selected_menu_id = _selected_tab_data["menu_id"]
				_selected_menu_url = _selected_tab_data["menu_url"]
				
				if (_selected_menu_id == _menu_id) {
					
					dolocateMenu(_selected_menu_url, _selected_menu_id);
					
					// sub menu 클릭 시 화면 리로드
					document.getElementById("menu-tabContent-" +_menu_id).contentDocument.location.reload(true);
					return false;
				}
			}
			
			if(null != _tab_data_tmp) {
				
				//sessionStorage에서 메뉴 id 목록받기
				tab_data = JSON.parse(sessionStorage.getItem('tab_data'));
				
				//sessionStorage에서 메뉴 id 찾기
				for(var i in tab_data) {
					
					//메뉴 id 체크
					var _menu_id_tmp = tab_data[i]["menu_id"]
					
					if(_menu_id == _menu_id_tmp) {
						
						_sessionStorage_id = _menu_id_tmp;
					}
				}
			}
			
			//sessionStorage에 메뉴 id 없으면 tab 추가
			if(!_sessionStorage_id){
				
				//tab 개수 체크(최대6
				if (tab_data) {
					var _tab_count = tab_data.length;
					
					var tab_data_to_delete = sessionStorage.getItem('tab_data');
					tab_data_to_delete = JSON.parse(tab_data_to_delete);
					
					// 현재활성화된 탭 개수가 6개가 넘어가면,
					if(_tab_count >= 6) {
						if(confirm("최대활성화 탭의 개수는 6 개 입니다.\n잠금설정하지 않은 탭은 임의로 삭제됩니다.")){
							// 잠금설정되지 않은 탭이 있는지 검사
							var deleteIndex = -1;
							for(var index = 0 ; index < tab_data_to_delete.length ; index++){
								if(tab_data_to_delete[index].close_lock == "false"){
									deleteIndex = index;
									break;
								}
							}
							
							// 만약에 잠금설정 안한 탭이 있으면 그걸 지우고
							if(deleteIndex != -1){
								let _delete_item = tab_data.splice(deleteIndex, 1);
								if(_delete_item && _delete_item[0].menu_id){
									fnDeleteMenu(_delete_item[0].menu_id)
								}
							// 6개 탭(DashBoard 포함)이 모두 잠금설정되어있다면 
							}else if(deleteIndex == -1){
								alert("모든탭이 닫기 잠금설정 되어있습니다.\n현재 활성화 되어있는 탭의 잠금상태를 확인해주세요.");
								return;
							}
						}else{
							return;
						}
					} 

					tab_data.push(_tab_data);
					sessionStorage.tab_data = JSON.stringify(tab_data);
					//selected tab data sessionStorage에 추가
					sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				}
				
			} else {
				
				//selected tab data sessionStorage에 추가
				sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				
			}
			
			$('.sub-menu-link').removeClass('active');
			$(this).closest('a').addClass('active');
			
			//tab menu 그리기
			setTabMenu();
			document.getElementById("menu-tabContent-" +_menu_id).contentDocument.location.reload(true);
		});
		

		//tab 클릭
		$(document).on('click','.tab-link', function(e) {

			//이벤트 전파 제거
			e.stopPropagation();
			
			//메뉴 id 받기
			var _menu_id = $(this).attr('id').replace('menu-tab-', '');
			
			//메뉴명 받기
			var _menu_nm = $(this).text().trim();
			
			//메뉴경로 받기
			var _menu_url = $(this).attr('data-menu_url');
			
			//메인 메뉴 id 받기
			var _main_menu_id = $(this).attr('data-main_menu_id');
			
			//부모 메뉴 id 받기
			var _p_menu_id = $(this).attr('data-p_menu_id');
			
			//메뉴 경로 받기
			var _menu_path = $(this).attr('data-menu_path');
			
			//selected tab data
			var _tab_data = {
				"menu_id" : _menu_id,
				"main_menu_id" : _main_menu_id,
				"p_menu_id" : _p_menu_id,
				"menu_path" : _menu_path,
				"menu_nm" : _menu_nm, 
				"menu_url" : _menu_url
			};

			
			//sessionStorage에서 selected_tab_data 정보 받기
			var _selected_tab_data = sessionStorage.getItem('selected_tab_data');
			
			//sessionStorage에서 selected menu 정보 받기
			var _selected_menu_id;
			
			if (_selected_tab_data) {
				
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_selected_menu_id = _selected_tab_data["menu_id"]
				_selected_menu_url = _selected_tab_data["menu_url"]
				
				if (_selected_menu_id == _menu_id) {
					
					dolocateMenu(_selected_menu_url, _selected_menu_id);
					return false;
				}
			}
			
			//selected tab data sessionStorage에 추가
			sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
			
			// [20191203] 추가
			// fnCheckMenu(_main_menu_id);
			// $('#menu-tabContent').empty();
			//dolocateMenu(_menu_url, _menu_id);	//아래 setTabMenu 함수에서 페이지를 로딩함, 이거까지 하면 두번 로딩됨.

			//sessionStorage에서 main menu 정보 받기
			var main_menu_data = JSON.parse(sessionStorage.getItem('main_menu_data'));

			//제목 그리기
			setSubMenu(_main_menu_id);

			//tab menu 그리기
			setTabMenu();
			
			$('.main-menu-link').removeClass('active');
			$('#' + _main_menu_id).addClass('active');
			
		});
		
		//tab 잠금버튼 클릭
		$(document).on('click','.tab-menu-lock-btn', function(e){
			
			//이벤트 전파 제거
			e.stopPropagation();
			
			var _menu_id = $(this).closest('.tab-link').attr('id').replace('menu-tab-', '');
			
			var tab_data = sessionStorage.getItem('tab_data');
			tab_data = JSON.parse(tab_data);
			
			var getId = $(this).attr("id");
			
			var getJsonIndex = getId.substr(getId.length - 1);
			
			var closeBtnElement = $(this).closest('.tab-link').find('.badge-danger');
			
			if(_menu_id != "101000"){
				if($(this).hasClass("locked")){
					// locked -> unlocked
					$(this).removeClass("locked");
					$(this).addClass("unlocked");
					
					tab_data[getJsonIndex].close_lock = "false";
					
					sessionStorage.tab_data = JSON.stringify(tab_data);
					
					$(this).html('<i class="fa fa-unlock-alt fa-lg mt-4 tab-menu-lock-icon"></i>');
					//$(this).html('<i class="fa fa-unlock fa-lg mt-4 tab-menu-lock-icon"></i>');
					$(closeBtnElement).removeClass("cls-lock");
					
				}else if($(this).hasClass("unlocked")){
					// unlocked -> locked
					$(this).removeClass("unlocked");
					$(this).addClass("locked");
					
					tab_data[getJsonIndex].close_lock = "true";
					
					sessionStorage.tab_data = JSON.stringify(tab_data);
					
					$(this).html('<i class="fa fa-lock fa-lg mt-4 tab-menu-lock-icon"></i>');
					$(closeBtnElement).addClass("cls-lock");
				}
			}
			
		});
		
		//tab 삭제버튼 클릭
		$(document).on('click','.badge-danger', function(e) {
			
			//이벤트 전파 제거
			e.stopPropagation();
			
			//탭 닫기 lock 걸려있는경우 return;
			if($(this).hasClass('cls-lock')){
				return;
			}
			
			//메뉴 id 받기
			var _menu_id = $(this).closest('.tab-link').attr('id').replace('menu-tab-', '');

			//메뉴 id index
			var _menu_index;
			
			//sessionStorage에서 메뉴 id
			var _sessionStorage_id;
			
			//sessionStorage에서 메뉴 id 목록받기
			tab_data = JSON.parse(sessionStorage.getItem('tab_data'));
			
			//sessionStorage에서 메뉴 id 찾기
			for(var i in tab_data) {
							
				//메뉴 id 체크
				var _menu_id_tmp = tab_data[i]["menu_id"]
				
				if(_menu_id == _menu_id_tmp) {

					_sessionStorage_id = _menu_id_tmp;
					_menu_index = i;
				}
				
			}
			
			tab_data.splice(_menu_index, 1);
			sessionStorage.tab_data = JSON.stringify(tab_data);
			
			$('#' + _menu_id).removeClass('active');
			$('#menu-tab-' + _menu_id).closest('li').remove();
			var _selected_tab_id = $('#menu-tab').find('.active').attr('id');
			
			// tab 삭제 시 첫번째 tab 선택
			if (tab_data[0] && !_selected_tab_id) {
				
				var _selected_menu_id = tab_data[0]["menu_id"]
				var _selected_main_menu_id = tab_data[0]["main_menu_id"]
				var _selected_p_menu_id = tab_data[0]["p_menu_id"]
				var _selected_menu_path = tab_data[0]["menu_path"]
				var _selected_menu_nm = tab_data[0]["menu_nm"]
				var _selected_p_menu_nm = tab_data[0]["p_menu_nm"]
				var _selected_menu_url = tab_data[0]["menu_url"]
				
				$('.tab-link').removeClass('active');
				$('#menu-tab-' + _selected_menu_id).addClass('active');
				$('#' + _selected_menu_id).addClass('active');
				
				// selected tab data
				var _tab_data = {
					"menu_id" : _selected_menu_id,
					"main_menu_id" : _selected_main_menu_id,
					"p_menu_id" : _selected_p_menu_id,
					"menu_path" : _selected_menu_path,
					"menu_nm" : _selected_menu_nm, 
					"menu_url" : _selected_menu_url
				};
				
				// selected tab data sessionStorage에 추가
				sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				
//				$('#menu-tabContent').empty();
				dolocateMenu(_selected_menu_url, _selected_menu_id);
				
				//서브메뉴 그리기
				setSubMenu(_selected_main_menu_id);
				
				$('.sub-menu-link').removeClass('active');
				$('#' + _selected_menu_id).addClass('active');
				
				$('.main-menu-link').removeClass('active');
				$('#' + _selected_main_menu_id).addClass('active');
				
			} else if ((!tab_data[0] && !_selected_tab_id)) {
				sessionStorage.removeItem('selected_tab_data');
				$('#menu-tabContent').empty();
			}
			
			fnDeleteMenu(_menu_id);
			
		});
		
		//퍼블리싱 추가
		$(document).on('click','.searchToggle', function(e) {
			$(this).toggleClass('hide').next().slideToggle();
			return false;
		})

/*		$(".searchToggle").on("click", function(){
			$(this).toggleClass('hide').next().slideToggle();
		})*/
		
		//Tab fn
		$(document).on('click','.tab_menu a', function(e) {
			var $this = $(this);
			if($this.attr('data-tab') != null){
				var targetID = $this.attr('data-tab');
				$("#"+targetID).addClass("active").siblings().removeClass("active");
				$this.addClass("active").siblings().removeClass("active");
			}
		})
		
		//대시볻드 이동
		$('.logo-img').click(function() {
			
			$('#menu-tab-' + _selected_menu_id).addClass('active');
			$('#' + _selected_menu_id).addClass('active');
//			$('#menu-tabContent').empty();
			dolocateMenu('/dashboard/dashboard', '101000');
			
			//sessionStorage에서 메뉴 id
			var _sessionStorage_id;
			
			//메뉴 id 받기
			var _menu_id = "101000";
			
			//메뉴명 받기
			var _menu_nm = "Dashboard";
			
			//메뉴경로 받기
			var _menu_url = "/dashboard/dashboard";
			
			//부모 메뉴 id 받기
			var _p_menu_id = "100000";
			
			//sessionStorage에서 메뉴 체크
			var _tab_data_tmp = sessionStorage.getItem('tab_data');
			
			//부모 정보 받기
			var _menu_path = $(this).attr('data-menu_path');
			
			//selected tab data
			var _tab_data = {
				"menu_id" : "101000",
				"main_menu_id" : "100000",
				"p_menu_id" : "100000",
				"menu_path" : "Dashboard",
				"menu_nm" : "Dashboard",
				"menu_url" : "/dashboard/dashboard"
			};
			
			//sessionStorage에서 selected_tab_data 정보 받기
			var _selected_tab_data = sessionStorage.getItem('selected_tab_data');
			
			//sessionStorage에서 selected menu 정보 받기
			var _selected_menu_id;
			
			if (_selected_tab_data) {
				
				var _selected_tab_data = JSON.parse(sessionStorage.getItem('selected_tab_data'));
				_selected_menu_id = _selected_tab_data["menu_id"]
				
				if (_selected_menu_id == _menu_id) {
					
					return false;
				}
			}
			
			if(null != _tab_data_tmp) {
				
				//sessionStorage에서 메뉴 id 목록받기
				tab_data = JSON.parse(sessionStorage.getItem('tab_data'));
				
				//sessionStorage에서 메뉴 id 찾기
				for(var i in tab_data) {
					
					//메뉴 id 체크
					var _menu_id_tmp = tab_data[i]["menu_id"]
					
					if(_menu_id == _menu_id_tmp) {
						
						_sessionStorage_id = _menu_id_tmp;
					}
				}
			}
					
			//sessionStorage에 메뉴 id 없으면 tab 추가
			if(!_sessionStorage_id){
				
				//tab 개수 체크(최대6
				if (tab_data) {
					var _tab_count = tab_data.length;
					
					if(_tab_count >= 6) {
						
						tab_data.splice(1, 1);
					} 

					tab_data.push(_tab_data);
					sessionStorage.tab_data = JSON.stringify(tab_data);
					//selected tab data sessionStorage에 추가
					sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				}
				
			} else {
				
				//selected tab data sessionStorage에 추가
				sessionStorage.selected_tab_data = JSON.stringify(_tab_data);
				
			}
			
			$('.sub-menu-link').removeClass('active');
			$(this).closest('a').addClass('active');
			
			//tab menu 그리기
			setTabMenu();
			
			//제목 그리기
			setSubMenu(_p_menu_id);
			
			//tab menu 그리기
			setTabMenu();
		});
		
		// iframe 로딩
		if($('#menu-tabContent').length){
			$('iframe').load(function(rtxt, status, jqXhr){
				let $this = $(this);
				var _height = $this.contents().find('body').height();
				$this.height(_height);
				if (status == 'error') {
					
					//tab data 삭제
					//sessionStorage에서 메뉴 id 목록받기
					var _tab_data = JSON.parse(sessionStorage.getItem('tab_data'));
					
					//메뉴 id index
					var _menu_index;
					
					//sessionStorage에서 메뉴 id 찾기
					for(var i in _tab_data) {
									
						//메뉴 id 체크
						var _menu_id_tmp = _tab_data[i]["menu_id"]
						
						if(menu_id == _menu_id_tmp) {
	
							_sessionStorage_id = _menu_id_tmp;
							_menu_index = i;
						}
						
					}
					
					_tab_data.splice(_menu_index, 1);
					sessionStorage.tab_data = JSON.stringify(_tab_data);
					
					location.href = "/error/" + jqXhr.status;
				} else {
					
					
				}
			});
		}
		
		
		// datepicker 초기화
		if ($('.cal').length) {
			// Basic initialization
		    $('.cal').datepicker({
	 	        dateFormat: 'yy-mm-dd'
		    });
		    
		    //날짜 밸리데이션 체크 적용
		    //$('.cal') 대상으로 함수 적용.
		}
		
		//날짜 입력박스들 오늘날짜 초기값 설정
		var today = formatYMD(getToDay());
		$('.cal').each(function(idx,obj){
			var input = $(obj);
			if(input.val()==''){
				input.val(today);
			}
		});
		
		// input 검색기록 삭제
		 $('input').attr('autocomplete', 'off')
		 
		 // 사용자 팝업 띄우기
//		 $('[data-target="#schUserModal"]').click(function(e){
//			 layer('.layerSt1');
//		 });
		
	};
	
	initPage();
	
});

function LPad(s, c, n) {    
    if (! s || ! c || s.length >= n) {
        return s;
    }
 
    var max = (n - s.length)/c.length;
    for (var i = 0; i < max; i++) {
        s = c + s;
    }
 
    return s;
}

function isChecked(value, startDateText, endDateText) {
	kind = $('.cal').attr('pageid');
	
	if(value.checked){
		startDateText.disabled=false;
		endDateText.disabled=false;
		var defaultDate = formatYMD(getToDay());
		if(kind == "3020"){
			defaultDateRange = (2 - 1);
			yesterDayCal = 0;	
			
			var todayDate = new Date();

			var endDate = todayDate.getTime() - (yesterDayCal * 24 * 60 * 60 * 1000);
			todayDate.setTime(endDate);
			var endDateStr = todayDate.getFullYear()+"-"+(todayDate.getMonth()+1 >= 10 ? todayDate.getMonth()+1 : '0' + (todayDate.getMonth()+1))+"-"+(todayDate.getDate() >= 10 ? todayDate.getDate() : '0' + todayDate.getDate());

			var startDate = todayDate.getTime() - (defaultDateRange * 24 * 60 * 60 * 1000);
			todayDate.setTime(startDate);
			var startDateStr = todayDate.getFullYear()+"-"+(todayDate.getMonth()+1 >= 10 ? todayDate.getMonth()+1 : '0' + (todayDate.getMonth()+1))+"-"+(todayDate.getDate() >= 10 ? todayDate.getDate() : '0' + todayDate.getDate());
			
			defaultDateRange = (2 - 1);
			yesterDayCal = 0;
			var options = {};
			options.schSdate1 = startDateStr;
			$.ajax({
				url : '/api/qa/status/dateSet',
				data : options,
				method : 'post'
			}).done(function(data) {
				if (data.resultCode == "200") {
					startDateStr_3020 = data.startDate; 
					
					console.log(startDateStr_3020);
					startDateText.value = startDateStr_3020;
				} else {
					fnAlertErrorMsg(data);
				}
			});
		}else{
		//	var defaultDate = formatYMD(getToDay());
			startDateText.value = defaultDate;
		}
		endDateText.value = defaultDate;
	}else{
	//	startDateText.readOnly=true;
		startDateText.disabled=true;
		startDateText.value=null;
	//	endDateText.readOnly=true;
		endDateText.disabled=true;
		endDateText.value=null;
	}
}


function getToDay() {
	var d = new Date();
	var s = d.getFullYear()
	      + LPad(((d.getMonth() + 1) + ""), '0', 2)
	      + LPad((d.getDate() + ""), '0', 2);

	return (s);
}

function formatYMD(str) {
	var str = String(str);
	return isNaN(str) ? str : str.substring(0, 4) + '-' + str.substring(4, 6) + '-' + str.substring(6, 8);
}

var pkkinitDataTable = function (dataTableId, options, columns, columnDefs, callFunc) {
	var objTable = $('#' + dataTableId).DataTable({
		scrollY: options.scrollY,
		serverSide : true,
        processing: true,
		dom: 'r<"datatable-scroll"t><"datatable-footer"ip>',
        language: {
            processing: "loading...",
            paginate: { 'first': 'First', 'last': 'Last', 'next': 'Next', 'previous': 'Prev' }
        },
		columns: [
        	{data: "id",type:'', title: 'No', "render": function ( data, type, full, meta ) {
    	    return  (objTable.page.info().page * 10) + meta.row + 1;
    	}}].concat(columns),
        columnDefs: columnDefs,
        select: {
        	style: 'single'
        },
        ajax : function(data, callback, settings) {
        	var searchParams = options.searchParams;
        	searchParams["page[size]"] = data.length;
        	searchParams["pageIndex"] = data.start / data.length + 1;
        	searchParams["pageUnit"] = options["page[size]"];
        	
        	if(options.url != '') {
	        	$.get(options.url + "?" + $.now(), searchParams, function(data) {
	        		var json = data.resultList;
	        		if(!json.error) {
		                callback({
		                	recordsTotal : data.paginationInfo.totalRecordCount,
		                	recordsFiltered : data.paginationInfo.totalRecordCount,
		                	data : data.resultList
		                });
		                
		                $('#' + dataTableId).find(' tbody tr').css("cursor", "pointer");
	            	} else {
	            		callback({
		                	recordsTotal : 0,
		                	recordsFiltered : 0,
		                	data : []
		                });
	            	}
	            });
        	}
        }
	});
	
	objTable.on('select', function(e, dt, type, index) {
		callFunc();
	});
	
	return objTable;
};
/**
 * 폼에다가, 키값 쌍의 목록을 히든인풋으로 폼에다 설정함.
 * 동일한 이름의 값들은, 배열형태로 넘어가게 됨.
 * @param form		: $('#formId')
 * @param list		: [{n:'name',v:'value'}, ...]
 * @returns
 */
function fnCmnSetFormParams(form,list){
	if(form==null || list==null) return;
	
	var params = [];
	for(var i=0;i<list.length;i++){
		var v_item = list[i];
		params.push('<input type="hidden" name="'+v_item.n+'" value="'+v_item.v+'" />');
	}
	
	form.html(params.join(''));
}
/**
 * 문자열 치환
 * @param str		: 원본문자열
 * @param tgt		: 대상문자열
 * @param rep		: 바꿀문자열
 * @returns
 */
function fnCmnReplaceAll(str,tgt,rep){
	if(str && tgt){
		return str ? str.split(tgt).join(rep) : str;
	} else {
		return str;
	}
}
/**
 * 날짜 문자열값을 날짜 객체로 반환.
 * console.info(fnCmnGetDateObject('2019-01-01'));
 * console.info(fnCmnGetDateObject('2019.01.01'));
 * @param vdate		: '2019-01-01', '2019.01.01'
 * @returns			: 날짜 객체값
 */
function fnCmnGetDateObject(vdate){
	vdate = vdate ? $.trim(vdate) : '';
	if(vdate){
		vdate = fnCmnReplaceAll(vdate,'-','');
		vdate = fnCmnReplaceAll(vdate,'.','');
		vdate = fnCmnReplaceAll(vdate,' ','');
		vdate = fnCmnReplaceAll(vdate,'/','');
		vdate = fnCmnReplaceAll(vdate,':','');
	} else {
		return null;
	}
	var vparse = [];
	vparse.push(vdate.length >= 4 ? vdate.substring(0,4) : '');
	vparse.push(vdate.length >= 6 ? vdate.substring(4,6) : '');
	vparse.push(vdate.length >= 8 ? vdate.substring(6,8) : '');
	return new Date(vparse[0],vparse[1],vparse[2]);
}
/**
 * 두 날짜 객체에서, 날짜 빼기, dateObj2 - dateObj1
 * @param dateObj1		: 시작날짜 객체
 * @param dateObj2		: 종료날짜 객체
 * @param unit			: 단위, 'd' - 일자, 'm' - 월, 'y' - 년
 * @returns
 */
function fnCmnGetDateDiff(dateObj1,dateObj2,unit){
	var result = null;
	
	unit = unit ? unit : 'd';
	
	if(dateObj1 && dateObj2){
		var v_diff = dateObj2 - dateObj1;
		var v_unitDay = 24 * 60 * 60 * 1000;	//하루를 밀리세컨드 단위로 환산
		var v_unitMon = v_unitDay * 30;			//한달을 밀리세컨드 단위로 환산
		var v_unitYear = v_unitMon * 12;		//일년을 밀리세컨드 단위로 환산
		
		if(unit=='y'){
			result = parseInt(v_diff / v_unitYear);
		} else if(unit=='m') {
			result = parseInt(v_diff / v_unitMon);
		} else if(unit=='d') {
			result = parseInt(v_diff / v_unitDay);
		}
	}
	
	return result;
}


function dataFormat(data){
	if(!data) return "";
	var formatNum='';
	data = data.replace(/\s/gi,"");
	
	try{
		if(data.length==8){
			formatNum = data.replace(/(\d{4})(\d{2})(\d{2})/,'$1-$2-$3');
		}
	}catch(e){
			formatNum=data;
	}
		return formatNum;
}
/**
 * 두 날짜 객체에서, 날짜 빼기, dateObj2 - dateObj1
 * @param dateStr1		: 시작날짜 문자열, '2019-01-01'
 * @param dateStr2		: 종료날짜 문자열, '2019-01-01'
 * @param unit			: 단위, 'd' - 일자, 'm' - 월, 'y' - 년
 * @returns
 */
function fnCmnGetDateStrDiff(dateStr1,dateStr2,unit){
	var dateObj1 = fnCmnGetDateObject(dateStr1);
	var dateObj2 = fnCmnGetDateObject(dateStr2);
	return fnCmnGetDateDiff(dateObj1,dateObj2,unit);
}
/**
 * 날짜 시작일, 종료일 입력박스에 대한, 유효성 체크하는 함수.
 * 조회버튼이나, 등록/수정 버튼 이벤트 함수에서, 해당 처리를 하기전에 이 함수로 체크.
 * @param sdateId		: 시작일 입력박스 아이디
 * @param edateId		: 종료일 입력박스 아이디
 * @returns				: 유효성에 이상이 없으면 true, 이상이 있으면 false
 */
function fnCmnCheckValidDate(sdateId,edateId){
	var sdateObj = $('#'+$.trim(sdateId));
	var edateObj = $('#'+$.trim(edateId));
	var sdate = $.trim(sdateObj.val());
	var edate = $.trim(edateObj.val());
	
	if(sdate && edate){
		//시작일은 종료일보다 이전이어야함.
		if(sdate > edate){
			alert('검색기간이 잘못 설정되었습니다.');
			setTimeout(function() {
				location.reload();
			}, 10);
			sdateObj.focus();
			return false;
		}
		
		//조회기간이 최대 30일까지만 가능.
		var v_diff = fnCmnGetDateStrDiff(sdate,edate,'d');
		if(v_diff!=null && v_diff > 30){
			alert('검색기간은 최대 30일까지만 조회가 가능합니다!!');
			sdateObj.focus();
			return false;
		}
	}
	
	return true;
}

/**
 * Datatble 천단위 콤마
 */
function fnNumberCommaFormat(_data) {
	if(_data != null && _data !='0') {
		var _split = String(_data).split('.');
		var _jungsoo = _split[0];
		var _value = "";
		
		_jungsoo = _jungsoo.replace(/\B(?=(\d{3})+(?!\d))/g,",");
		
		if(_split.length == '1'){
			_value = _jungsoo+".00";
		}else if(_split.length == '2'){
			if(_split[1].length == '1'){
				_value = _jungsoo+'.'+_split[1]+'0';
			}else{
				_value = _jungsoo+'.'+_split[1];
			}
			
		}

		return _value==null ? '' : _value;
	} else {
		return '';
	}
}


/**
 * 그리드를 엑셀다운로드 처리.
 * @param form				: $('formId'), $('#formXls')
 * @param searchOption		: gridConfig.getSearchOption()
 * @param xlsPath			: /api/revert/stat/complete/xls
 * @returns
 */
function fnCmnDownXls(form, xlsPath, searchOption){
	
	if(!checkLogin()) {
		alert('세션이 만료되었습니다. 로그인화면으로 이동합니다.');
		//parent.location.href = loginUrl; //?
		window.parent.location.replace(loginUrl); //?
	}else{
		if(!form) return;
		var params = [];
		if(searchOption){
			for(var key in searchOption){
				if(searchOption.hasOwnProperty(key)){
					var val = searchOption[key] ? searchOption[key] : '';
					params.push({n:key, v:val});
				}
			}
		}
		fnCmnSetFormParams(form,params);
		form.prop('action',xlsPath);
		form.submit();
	}
}

function WatchListDownXls(form ,xlsPath){
	
	form.prop('action',xlsPath);
	form.submit();
}

/**
 * 널일때, 디폴트값으로 반환.
 * @param value		: 체크할 값
 * @param def		: 널일때 대체할 값
 * @returns			: 널이 아니면 value, 널이면 def 반환
 */
function fnNvl(value,def){
	def = def!==undefined && def!==null ? def : '';
	value = value && $.trim(value).toLowerCase()!='null' ? value : def;
	return value;
}

/**
 * 입력항목 빈값체크
 * @param jobj		: $('#inputId')
 * @param msg		: 빈값일때 알럿 메시지
 * @returns			: 값이 있으면 true, 없으면 false 반환
 */
function fnCmnCheckValidNull(jobj,msg){
	if(jobj && jobj.length){
		if($.trim(jobj.val())==''){
			alert(msg);
			jobj.focus();
			return false;
		}
	}
	return true;
}

/**
 * 디비에서 html 보안관련 이스케이프 했던 특수문자열들을, 
 * 다시 복구처리. 입력박스 등에 설정할때는 복구해서 셋팅해줘야함.
 * 그래야 다시 디비에 입력할때 재이스케이프 할때, 중복해서 이스케이프 안됨.
 * @param str		: 복구할 문자열
 */
function fnCmnXssUnescape(str) {
	if(!str) return str;
	
	str = str+'';
	str = fnCmnReplaceAll(str,'&#35;','#');
	str = fnCmnReplaceAll(str,'&#38;','&');
	str = fnCmnReplaceAll(str,'&lt;','<');
	str = fnCmnReplaceAll(str,'&gt;','>');
	str = fnCmnReplaceAll(str,'&#40;','(');
	str = fnCmnReplaceAll(str,'&#41;',')');
	
	return str;
}

function fnCmnXssEscape(str) {
	if(!str) return str;
	
	str = str+'';
	str = fnCmnReplaceAll(str,'#','&#35;');
	str = fnCmnReplaceAll(str,'&','&#38;');
	str = fnCmnReplaceAll(str,'<','&lt;');
	str = fnCmnReplaceAll(str,'>','&gt;');
	str = fnCmnReplaceAll(str,'(','&#40;');
	str = fnCmnReplaceAll(str,')','&#41;');
	
	return str;
}

function fnHtmlEscape(str) {
	if(!str) return str;
	
	str = str+'';
	str = fnCmnReplaceAll(str,'#','&#35;');
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

function fnCmnGetFileExt(filePath){
	var fileExt = '';
	
	filePath = $.trim(filePath);
	
	if(filePath){
		var lidx = filePath.lastIndexOf('.');
		if(lidx!=-1){
			fileExt = filePath.substring(lidx+1);
		}
	}
	
	return fileExt;
}

/**
 * 해당 입력창 jquery 지정된 객체들에 엔터키 이벤트에 특정 처리로직 적용.
 * fnCmnDoEnterEvent($('target'),function(obj) {...});
 * @param inputCtls		: $('target')
 * @param callback		: function(obj) {...}
 */
function fnCmnDoEnterEvent(inputCtls,callback){
	if(inputCtls && inputCtls.length > 0){
		inputCtls.keydown(function(key){
			if(key.keyCode==13){
				if(callback){
					callback(this);
				}
			}
		});
	}
}

/**
 * 랜덤난수 숫자 반환 (파라미터 안넘기면 0 ~ 100 사이 난수)
 * @param min		: 난수 최저숫자 (범위)
 * @param max		: 난수 최고숫자 (범위)
 */
function random(min, max) {
	var result = 0;
	
	if(min!==undefined && min!==null && min!==undefined && min!==null){
		min = parseInt(min);
		max = parseInt(max);
		
		if(min < max){
			result = min + Math.round(Math.random() * (max - min));
			result = Math.min(max,result);
		}
	} else {
		result = Math.min(Math.round(Math.random() * 100), 100);
	}
	
	return result;
}

/**
 * 숫자 배열에서 최대값을 반환
 * @param arr	: 숫자배열
 */
function fnCmnGetArrayMaxItem(arr){
	var item = 0;
	
	if(arr && arr.length){
		for(var i=0;i<arr.length;i++){
			item = Math.max(item,parseInt(arr[i]));
		}
	}
	
	return item;
}


/**
 * 텍스트 자르기 (기준길이보다 길면 뒤에 ... 붙임)
 * @param txt			: (필수)원본문자열
 * @param limitLen		: (필수)제한길이
 * @param tail			: (선택)문자열 자를때 뒤에 붙일 문자열(기본 ...)
 * @returns				: 자른문자열
 */
function fnCmnCutStr(txt,limitLen,tail){
	if(txt && limitLen){
		limitLen = parseInt(limitLen);
		tail = tail===null || tail===undefined ? '...' : tail;
		txt = txt.length > limitLen ? txt.substring(0,limitLen) + tail : txt ;
	}
	
	return txt;
}

/**
 * jquery 대상객체에 대해서, 현재날짜 설정
 * @param targets	: jquery 대상객체
 * @returns			: void
 */
function fnCmnSetToday(targetsStr){
	if(targetsStr){
		var targets = $(targetsStr);
		if(targets && targets.length){
			targets.each(function(idx,obj){
				obj.value = formatYMD(getToDay());
			});
		}
	}
}

/**
 * data.resultCode 가 '200'을 반환하지 않을때 오류메시지 출력
 * @param data	: ajax 로 api 호출 결과값.
 * @param isPopup : true/false (팝업여부)
 * @returns		: 없음.
 */
function fnAlertErrorMsg(data, isPopup){
	isPopup = isPopup===undefined || isPopup===null ? false : isPopup;
	if(data && data.resultCode!='200'){
		
		if(data.resultCode == '403' || !checkLogin()) {
			alert('세션이 만료되었습니다. 로그인화면으로 이동합니다.');
			if(isPopup){
				//팝업인경우
				window.close();
//				opener.document.location.href = '/login';
//				opener.document.location.href = '<c:out value="${portal_login}"/>';
				
				opener.document.location.href = loginUrl;
			} else if(self !== top){
//				parent.document.location.href = '/login';
//				parent.document.location.href = '<c:out value="${portal_login}"/>';
				
				parent.document.location.href = loginUrl;
			} else {
				//일반페이지인 경우
//				document.location.href = '/login';
//				document.location.href = '<c:out value="${portal_login}"/>';
				
				document.location.href = loginUrl;
			}
		} else if(data.resultExMsg){
			alert(data.resultExMsg);
		} else {
			alert('알 수 없는 오류가 발생했습니다.');
		}
	}
}

/**
 * 로그인 안되어있으면, 알랏 후 로그인 페이지 이동. 
 */
function fnLoginAlert(isPopup){
	isPopup = isPopup===undefined || isPopup===null ? false : isPopup;
	alert('세션이 만료되었습니다. 로그인화면으로 이동합니다.');
	if(isPopup){
		//팡업인경우
		window.close();
//		opener.document.location.href = '/login';
//		opener.document.location.href = '<c:out value="${portal_login}"/>';
		
		opener.document.location.href = loginUrl;
		
	} else {
		//일반페이지인 경우
//		document.location.href = '/login';
//		document.location.href = '<c:out value="${portal_login}"/>';
		
		document.location.href = loginUrl;
	}
}

// 심사상세 팝업 함수
function fnFullWin(form){
	var winWidth = screen.availWidth;
	var winHeight = screen.availHeight;
	var winName = form.target;
	var action = form.action;
	
	// 브라우저 버전 확인 후 팝업 사이즈 조정
	var agent = navigator.userAgent.toLocaleLowerCase();
	if (agent.indexOf("safari") != -1) {
		
		// 크롬
		winWidth -= 15;
		winHeight -= 65;
		
	} else {
		
		// 익스플로러
		winWidth -= 20;
		winHeight -= 66;
	}
	
	form.action = action + '?t='+$.now();
	
	// 창 가운데정렬추가
	var popUpSizeW = window.screen.width * 0.8;
	var popUpSizeH = window.screen.height * 0.8;
	
	var popUpLeft = (window.screen.width - popUpSizeW) / 2;
	var popUpTop = (window.screen.height - popUpSizeH) / 2;
	
	window.open('about:blank', winName, 'left=0, top=0, width=' + window.screen.width + ', height=960, resizable=1, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
	form.submit();
	form.action = action;
}

// 심사이력 팝업 함수
function fnHistoryWin(form){
	var winWidth = screen.availWidth;
	var winHeight = screen.availHeight;
	var winName = form.target;
	var action = form.action;
	
	// 브라우저 버전 확인 후 팝업 사이즈 조정
	var agent = navigator.userAgent.toLocaleLowerCase();
	if (agent.indexOf("safari") != -1) {
		
		// 크롬
		winWidth -= 15;
		winHeight -= 65;
		
	} else {
		
		// 익스플로러
		winWidth -= 20;
		winHeight -= 66;
	}
	
	form.action = action + '?t='+$.now();
	
	// 창 가운데정렬추가 #1
	var popUpSizeW = window.screen.width * 0.8;
	var popUpSizeH = window.screen.height * 0.8;
	var popUpLeft = (window.screen.width - popUpSizeW) / 2;
	var popUpTop = (window.screen.height - popUpSizeH) / 2;
	
	// 창 가운데정렬추가 #2(듀얼모니터 체크)
	var popupSizeW = "1100";
	var popupSizeH = "800";
	
	var curX = window.screenLeft;
	var curY = window.screenTop;
	
	var clientW = document.body.clientWidth;
	var clientH = document.body.clientHeight;
	
	var resultLeft = curX + (clientW / 2) - (popupSizeW / 2);
	var resultTop = curY + (clientH / 2) - (popupSizeH / 2);
	
	
	

	//console.log("resultLeft : ", resultLeft, ", resultTop : ", resultTop);
	
	
	
	window.open('about:blank', winName, 'left='+resultLeft+', top='+resultTop+', width=1100, height=845, resizable=1, toolbar=0, status=0, location=0, addressbar=0, menubar=0');
	form.submit();
	form.action = action;
}

//LocalStorage 테스트
function fnTestLocalStorage(){
	
	for (var i; i < 100; i ++){
		
		localStorage.localStorage1 = JSON.stringify("1");
		
	}
}

//세션은 있는데 사용자 정보 없을때
//if(!resetUserInfo()) return;
function resetUserInfo() {
	var result = false;
	var userData = JSON.parse(sessionStorage.getItem('auth_data'));
	
	if(!userData){
		$.ajax({
			url: '/api/common/getMyInfo',
			data: {},
			method: 'post',
			async: false
		}).done(function(data){
			if(data.resultCode=="200"){
				
				//sessionStorage 초기화
				sessionStorage.clear();
				
				//auth sessionStorage에 추가
				var _auth_data = {
					"auth" : data.auth,
					"name" : data.name,
					"admin_yn" : data.adminYN,
					"loginDtm" : data.loginDtm,
					"finloginDtm" : data.finloginDtm,
					"absence" : data.absence,
					"eno" : data.eno
				};
				sessionStorage.auth_data = JSON.stringify(_auth_data);
				
				result = true;
			} else {
				
				alert('세션이 만료되었습니다. 로그인화면으로 이동합니다.');
//				document.location.href = '/login';
//				document.location.href = '<c:out value="${portal_login}"/>';
				
				document.location.href = loginUrl;
			}
		});
	} else {
		result = true;
	}
	
	return result;
}
/**
 * 프로그램 사용 이력 로그누적 공통함수
 * @param pageNo				: (필수)화면번호
 * @param pageSecCd				: (필수)화면섹션코드
 * @param actCd					: (필수)액션코드
 * @param pageParamStr			: (선택)액션별 파라미터 문자열 ("이름=값&이름=값"), 심사상세는 마스터번호만 저장. 나머지는 처리시 파라미터 그대로.
 * @param callbackFunc			: (선택)로그 저장 후 처리가 필요하면 function(data) {} 형태로 파라미터 넘기면 되고, 생략하거나 널을 넘기면, 호출 안함.
 * @param extraData				: (선택)추후에 페이지별, 섹션별, 액션별로 다른 처리를 할때 사용예약, 기본값은 널 혹은 생략. 사용시 객체 {}.
 * @returns						: void (없음)
 */
function fnCmnProgramLog(pageNo,pageSecCd,actCd,pageParamStr,callbackFunc,extraData){
	var cnctUrl = '';
	
	if(extraData){
		cnctUrl = extraData.url ? extraData.url : '';
	}
	
	var param = {
		aiInptCnctUrlNm : cnctUrl
		, aiInptCnctScrnNo : pageNo
		, aiInptCnctFldCd : pageSecCd
		, aiInptCnctActiCd : actCd
		, aiInptCnctParmTxt : pageParamStr
	};

	$.post('/api/common/main/log/program/insert', param, function(data){
		if(data.resultCode!='200'){
			console.info('프로그램 로그 이력 오류발생 : ' + data.resultMsg);
		}
		
		if(callbackFunc){
			callbackFunc(data);
		}
	});
}


//문자열 Byte 길이
function fnCheckByteSize(str){
	var byteSize = 0;
	
	if (str != null && str != "") {
		for (var i = 0; i < str.length; i ++) {
			
			(str.charCodeAt(i) > 127) ? byteSize += 3 : byteSize ++;
		}
	}

	return byteSize;
	
}

// 조회조건 정규식 체크
function fnCheckUsingCharForamt(kind, validationStr){
	// kind 0 : 영어만
	// kind 1 : 숫자만
	// kind 2 : 영어숫자혼용
	// kind 3 : 특수문자만 체크
	var currValue = "";
	var pattern = null;
	
	if(kind == 0){ // 영어만
		currValue = validationStr;
		pattern = /^[A-Za-z]*$/;
		
	}else if(kind == 1){ // 숫자만
		currValue = validationStr;
		pattern = /^[0-9]*$/;
		
	}else if(kind == 2){ // 영어숫자 혼용
		currValue = validationStr;
		pattern = /^[A-Za-z0-9]*$/;
		
	}else if(kind == 3){ // 특수문자만 체크
		currValue = validationStr;
		pattern = /[~!@#$%^&*+|<>?:{}]/gi;
		
	}else{
		return false;
	}
	
	if(pattern.test(currValue)){
		return true;
	}else if(!pattern.test(currValue)){
		return false;
	}
}

//문자열 Byte 길이2
//function fnCheckByteSize2(s, b, i, c){
//	for (b = i = 0; c = s.charCodeAt(i++); b += c >> 11? 3 : c >> 7 ? 2 : 1);
//
//	return b;
//}

/**
 * 로딩화면 초기화
 * @param useLoadingDisplayYN	: 로딩화면 사용여부. Y(사용) N(미사용)
 * @param loadingTargetUsingProperty	: 로딩화면 사용할 페이지의 selector. class(클래스명으로 타겟) id(아이디명으로 타겟)
 * @param targetElementClassName	: 로딩화면 사용할 페이지의 selector.
 */
function initLoadingDisplay(useLoadingDisplayYN, loadingTargetUsingProperty, targetElementClassName){
	var displayHeight = window.screen.height * 0.35;
	if(useLoadingDisplayYN == "Y"){
		if(loadingTargetUsingProperty == "class"){
			
			$('.loadingDisplay').width($('.loadingDisplay').parent().width()); 
			$('.loadingDisplayWrapper').css({'margin-left':($('.loadingDisplayWrapper').parent().width() / 2) - ($('.loadingDisplayWrapper').width() /2)});
			$('.loadingDisplayWrapper').css('top', 'calc(50% - 50px)');
			
			$('.loadingDisplay').prependTo($('.'+targetElementClassName));
			//$('.loadingDisplay').height($('.loadingDisplay').parent().height());
			$('.loadingDisplay').css('height', '100%');
		}else if(loadingTargetUsingProperty == "id"){
			
			$('.loadingDisplay').width($('.loadingDisplay').parent().width());
			$('.loadingDisplayWrapper').css({'margin-left':($('.loadingDisplayWrapper').parent().width() / 2) - ($('.loadingDisplayWrapper').width() /2)});
			$('.loadingDisplayWrapper').css('top', 'calc(50% - 50px)');
			
			$('.loadingDisplay').prependTo($('#'+targetElementClassName));
			//$('.loadingDisplay').height($('.loadingDisplay').parent().height());
			$('.loadingDisplay').css('height', '100%');
		}
	}else if(useLoadingDisplayYN == "N"){
		hideLoadingDisplay();
		return;
	}
}

function h_loading(){
	$('.loadingTitle').text("Data Loading");
	$('.loadingDisplay').hide();
	$('.loadingDisplayWrapper').hide();
}

function s_loading(loadingText){
	var loadingParam = loadingText;
	if(loadingText == null || loadingText == ""){
		loadingParam = "Data Loading";
	}
	$('.loadingTitle').text(loadingParam);
	$('.loadingDisplay').show();
	$('.loadingDisplayWrapper').show();
}


function validationSingleEvent(){
	var caDate = $('.calSingle');
	
	if(caDate.val() == ""){
		alert('조회기간을 입력해주세요');
		return false;
	}else{
		return true;
	}
}

function validationRangeEvent(){
	
	var stDate = $('.calStd');
	var edDate = $('.calEd');
	
	// kind 1: 업무일지 > [업무마감5010] [업무일지등록5020] [업무일지조회5030] [성과관리 5040]
	// kind 2: 성능분석6010
	// kind 3: 업무별통계6020
	// kind 4: 항목별통계 > [항목별통계6030_1] [기간별추이6030_2]
	// kind 5: 조건별통계6040
	// kind 6: 고객별통계6050
	// -1 하는 이유 : 양편넣기 날짜
	// kind 7: 진행업무별 현재상태(QA)3020 none
	// kind 8: 심사완료명세4030
	// kind 9: 심사오류명세4040
	// kind 10: 경보발생명세4050
	kind = $('.cal').attr('pageid');
	
	// 검증 범위 세팅(추가)
	var searchingDateMaxRange = 0;
	var workText = "";
	if(kind == "5010" || kind == "5020" || kind == "5030" || kind == "5040"){
		searchingDateMaxRange = (7 - 1);
		workText = "업무일지";
	}else if(kind == "6010"){
		searchingDateMaxRange = (30 - 1);
		workText = "성능분석";
	}
	else if(kind == "6020"){
		searchingDateMaxRange = (30 - 1);
		workText = "업무별통계";
	}
	else if(kind == "6030_1"){
		searchingDateMaxRange = (90 - 1);
		workText = "항목별통계";
	}
	else if(kind == "6030_2"){
		searchingDateMaxRange = (30 - 1);
		workText = "기간별추이";
	}
	else if(kind == "6040"){
		searchingDateMaxRange = (90 - 1);
		workText = "조건별통계";
	}
	else if(kind == "6050"){
		searchingDateMaxRange = (90 - 1);
		workText = "고객별통계";
	}
	else if(kind == "4030"){
		searchingDateMaxRange = (30 - 1);
		workText = "심사완료명세";
	}
	else if(kind == "4040"){
		searchingDateMaxRange = (30 - 1);
		workText = "심사오류명세";
	}
	else if(kind == "4050"){
		searchingDateMaxRange = (30 - 1);
		workText = "경보발생명세";
	}
	else{
		searchingDateMaxRange = 0;
	}
	

	var edtStrArr = edDate.val().split('-');
	var sdtStrArr = stDate.val().split('-');
	var edtDate = new Date(edtStrArr[0], edtStrArr[1]-1, edtStrArr[2]);
	var sdtDate = new Date(sdtStrArr[0], sdtStrArr[1]-1, sdtStrArr[2]);
	
	var dateDiff = Math.ceil((edtDate.getTime() - sdtDate.getTime()) / (1000*3600*24));
	
	if($('#dateDisable').length == 1 && $('#dateDisable').is(":checked")){
		if(isNaN(dateDiff)){
			alert('조회기간을 입력해주세요');
			return false;
		}
	}else if($('#dateDisable').length == 0){
		if(isNaN(dateDiff)){
			alert('조회기간을 입력해주세요');
			return false;	
		}
	}else{
		return true;
	}
		/*
	if(isNaN(dateDiff) || ($('#dateDisable').length == 1 && $('#dateDisable').is(":checked") == false)){
		//calObject.val(paramDate);
		alert('조회기간을 입력해주세요');
		return false;
	}*/
	
	if(dateDiff < 0){
		alert("시작범위는 종료범위를 초과할 수 없습니다");
		//calObject.focus().val(""); // 최대 조회가능범위를 계산해서 넣어주는 부분?
		$('#ui-datepicker-div').css('display','none');
		return false;
	}
	
	if(searchingDateMaxRange == 0){
		return true;
	}
	
	if(dateDiff > searchingDateMaxRange){
		alert(workText + " 최대 조회범위는 " + (searchingDateMaxRange+1) + " 일 입니다");
		//$('.calStd').val();
		//$('.calEd').val();
		//calObject.focus().val(""); // 최대 조회가능범위를 계산해서 넣어주는 부분?
		$('#ui-datepicker-div').css('display','none');
		return false;
	}else if(dateDiff <= searchingDateMaxRange){
		return true;
	}
}

// 범위형 달력(주로 업무일지와 통계) 초기화
function initRangeCal(){
	var defaultDateRange = 0;
	var yesterDayCal = 0; // 업무일지는 현재일자 포함 초기화, 통계는 어제일자
	var startDateStr_3020;
	// kind 1: 업무일지 > [업무마감5010] [업무일지등록5020] [업무일지조회5030] [성과관리 5040]
	// kind 2: 성능분석6010
	// kind 3: 업무별통계6020
	// kind 4: 항목별통계 > [항목별통계6030_1] [기간별추이6030_2]
	// kind 5: 조건별통계6040
	// kind 6: 고객별통계6050
	// kind 7: 진행업무별 현재상태(QA)3020 > 초기화만(밸리데이션 안함)
	// kind 8: 심사완료명세4030
	// kind 9: 심사오류명세4040
	// kind 10: 경보발생명세4050
	kind = $('.cal').attr('pageid');
	//console.log("commonJS pageId: " + kind);
	
	if(kind == "5010" || kind == "5020" || kind == "5030" || kind == "5040"){
		defaultDateRange = (7 - 1);
		yesterDayCal = 0;
	}else if(kind == "6010"){
		defaultDateRange = (14 - 1);
		yesterDayCal = 1;
	}else if(kind == "6020"){
		defaultDateRange = (14 - 1);
		yesterDayCal = 1;
	}else if(kind == "6030_1" || kind == "6030_2"){
		defaultDateRange = (14 - 1);
		yesterDayCal = 1;
	}else if(kind == "6040"){
		defaultDateRange = (14 - 1);
		yesterDayCal = 1;
	}else if(kind == "6050"){
		defaultDateRange = (14 - 1);
		yesterDayCal = 1;
	}
	else if(kind == "3020"){
		defaultDateRange = (2 - 1);
		yesterDayCal = 0;	
	}
	else{
		defaultDateRange = 0;
		yesterDayCal = 0;
	}
	
	var todayDate = new Date();
	
	var endDate = todayDate.getTime() - (yesterDayCal * 24 * 60 * 60 * 1000);
	todayDate.setTime(endDate);
	var endDateStr = todayDate.getFullYear()+"-"+(todayDate.getMonth()+1 >= 10 ? todayDate.getMonth()+1 : '0' + (todayDate.getMonth()+1))+"-"+(todayDate.getDate() >= 10 ? todayDate.getDate() : '0' + todayDate.getDate());
	//console.log("endDateStr");
	//console.log(endDateStr);
	
	var startDate = todayDate.getTime() - (defaultDateRange * 24 * 60 * 60 * 1000);
	todayDate.setTime(startDate);
	var startDateStr = todayDate.getFullYear()+"-"+(todayDate.getMonth()+1 >= 10 ? todayDate.getMonth()+1 : '0' + (todayDate.getMonth()+1))+"-"+(todayDate.getDate() >= 10 ? todayDate.getDate() : '0' + todayDate.getDate());
	
	if(kind == "3020"){
		defaultDateRange = (2 - 1);
		yesterDayCal = 0;
    	var options = {};
		options.schSdate1 = startDateStr;
		$.ajax({
			url : '/api/qa/status/dateSet',
			data : options,
			method : 'post'
		}).done(function(data) {
			if (data.resultCode == "200") {
				startDateStr_3020 = data.startDate; 
				$('.calStd').val(startDateStr_3020);
			} else {
				fnAlertErrorMsg(data);
			}
		});
	}else{
		$('.calStd').val(startDateStr);
	}
	$('.calEd').val(endDateStr);
	$('.calSingle').val(endDateStr);
}

// header.jsp 부재아이콘 초기화
function initHeaderAbsenceIcon(){
	var userData = JSON.parse(sessionStorage.getItem('auth_data'));
	
	var absenceYN = userData.absence;
	
	var absenceInfoIcon = $('.absenceInfoIcon');
	var absenceChangeBtn = $('#absenceChangeBtn');
	
	absenceInfoIcon.removeClass('absenceO');
	absenceInfoIcon.removeClass('absenceX');
	
	// 초기화 로직은 심사자(01), QA(03) 만 적용, 나머지는 온라인표시 및 부재기능 제외
	if(userData.auth == '01' || userData.auth == '03'){
		if(absenceYN == 'Y'){
			absenceChangeBtn.attr("title", "부재중");
			absenceInfoIcon.addClass('absenceO');
		}else if(absenceYN == 'N'){
			absenceChangeBtn.attr("title", "온라인");
			absenceInfoIcon.addClass('absenceX');
		}else{
			absenceChangeBtn.attr("title", "온라인");
			absenceInfoIcon.addClass('absenceX');
		}
	}else{
		absenceChangeBtn.attr("title", "온라인");
		absenceInfoIcon.addClass('absenceX');
	}
	
}
// header.jsp 부재요청
function requestHeaderAbsence(absenceFlag, userData){
	var f = $('#selfAbsenceProcParams');
	var params = [];
	params.push({n : 'aiInptUserFaReYn', v : absenceFlag});
	params.push({n : 'userNos', v : userData.eno});
	
	fnCmnSetFormParams(f, params);
	
	var programLogActionValue = (absenceFlag == 'Y') ? "11" : "10";
	
	f.html(f.html()+'<input type="hidden" name="aiInptCnctParmTxt" value="'+f.serialize()+'">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctScrnNo" value="7070">');
	f.html(f.html()+'<input type="hidden" name="aiInptCnctActiCd" value="'+programLogActionValue+'">');
	
	$.ajax({
		url : '/common/self/absence/update',
		data : f.serialize(),
		method : 'post'
	}).done(function(data) {
		if (data.resultCode == "200") {
			alert("정상적으로 처리되었습니다.");
			
			var _auth_data = {
					"auth" : userData.auth,
					"name" : userData.name,
					"admin_yn" : userData.adminYN,
					"loginDtm" : userData.loginDtm,
					"finloginDtm" : userData.finloginDtm,
					"absence" : absenceFlag,
					"eno" : userData.eno
				};
				sessionStorage.auth_data = JSON.stringify(_auth_data);
			
				initHeaderAbsenceIcon();
		} else {
			fnAlertErrorMsg(data);
		}
	});
}



// AND조건식 disabled 처리함수(항목별통계, 조건별통계)
function disabled(selectorName){}