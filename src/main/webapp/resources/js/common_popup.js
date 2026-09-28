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
			alert('검색기간이 잘 못 설정되었습니다.');
			sdateObj.focus();
			return false;
		}
		
		//조회기간이 최대 7일까지만 가능.
		var v_diff = fnCmnGetDateStrDiff(sdate,edate,'d');
		if(v_diff!=null && v_diff > 7){
			alert('검색기간은 최대 7일까지만 조회가 가능합니다.');
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
			_value = _jungsoo;
		}else{
			_value = _jungsoo+'.'+_split[1];
		}
		
		return _value==null ? '' : _value;
	} else {
		return '';
	}
}


function fnNumberCommaFormat(_data) {
	if(_data != null && _data !='0') {
		var _split = String(_data).split('.');
		var _jungsoo = _split[0];
		var _value = "";
		
		_jungsoo = _jungsoo.replace(/\B(?=(\d{3})+(?!\d))/g,",");
		
		if(_split.length == '1'){
			_value = _jungsoo;
		}else{
			_value = _jungsoo+'.'+_split[1];
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
