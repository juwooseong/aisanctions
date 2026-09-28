/*
g_ex_im_data = [];	//디비데이터 설정.
fn_draw_multi_country_data(g_ex_im_data);
*/

// 국가 위치 데이터
var g_location_data = {
	"SA" : "사우디아라비아", 
	"AE" : "아랍에미레이트", 
	"OM" : "오만",
	"IQ" : "이라크",
	"PK" : "파키스탄",
	"TR" : "터키",
	"RU" : "러시아"
};

// 국가별 수출입 데이터
//var g_ex_im_data = [
//	["SA", "사우디아라비아", 'Saudi Arabia', [407, 612]],
//	["AE", "아랍에미레이트", 'United Arab Emirates(UAE)', [435, 609]],
//	["OM", "오만", 'Oman', [444, 616]],
//	["IQ", "이라크", 'Iraq', [404, 615]],
//	["PK", "파키스탄", 'Pakistan', [480, 590]],
//	["TR", "터키", 'Turkey', [383, 565]],
//	["RU", "러시아", 'Russia', [577, 577]]
//];		

//국가 좌표 불러오기
function getPos(e, param) {
	x = e.offsetX;
	y = e.offsetY;
	cursor = "Country : " + param.id + "  좌표 : (" + x + "," + y + ")  " ;
//	alert(cursor);
	
}

// 국가별 수출입 데이터 세팅
function fn_draw_country_data(country_data) {

	// 국가별 수출입 현황 초기화
	var _location_data = Object.keys(g_location_data);

	for(var i in _location_data) {
		
		$('#nacd_' + _location_data[i]).hide();
	}
	
	if (country_data.length > 0) {
		
		var _id, _name_k, _name_e, export_h, import_h;
		
		for (var i in country_data) {
			
			_id = country_data[i][0];
			_name_k = country_data[i][1];
			_name_e = country_data[i][2];
			_export_h = country_data[i][3][0];
			_import_h = country_data[i][3][1];
			
			if (_id in g_location_data) {
				
				$('#nacd_' + _id).find('title').text(_name_k + ' [수출 : ' + _export_h + ' / 수입 : ' + _import_h + ']');
				$('#nacd_' + _id).show();
			}
		}
	}
}


