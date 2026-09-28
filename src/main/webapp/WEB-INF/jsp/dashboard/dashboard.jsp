<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/taglib.jsp"%>

<c:set var="pageId" value="Dashboard"/>
<style>
.h145{
height:145px;
}
</style>
<div class="container">
	<div class="contents">
		<span id="refreshBtn" class="refresh_btn" title="새로고침"><i class="fa fa-refresh fa-sm"></i> 새로고침</span>
		<div class="flGroup item_3">
			<div class="tbWrap">
				<div class="tbTop">
					<strong>내업무 To-Do</strong>
				</div>
				<div class="tbCon">
					<div class="flGroup item_2">
						<div class="chart flItem dashboard-doughnut-chart">
							<canvas id="canvas-1"></canvas>
						</div>
						<div class="chart flItem dashboard-table">
							<table class="" id="todo_table">
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong>진행업무별 현재상태</strong>
				</div>
				<div class="tbCon">
					<div class="flGroup item_2">
						<div class="chart flItem dashboard-doughnut-chart">
							<canvas id="canvas-2"></canvas>
						</div>
						<div class="chart flItem dashboard-table">
							<table class="" id="status_table"></table>
						</div>
					</div>
				</div>
			</div>
			<div class="tbWrap">
				<div class="tbTop">
					<strong id="statusDate">당일심사현황</strong>
				</div>
				<div class="tbCon h145">
					<div class="flGroup item_2 h145">
						<div class="chart flItem dashboard-bar-chart h145">
							<canvas id="canvas-3" class="dashboard-canvas"></canvas>
						</div>
						<div class="chart flItem dashboard-table h145">
							<table class="" id="inpt_table"></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="tbWrap">
			<div class="tbTop">
					<strong>국가별 수출입 현황</strong>
					<p id="mapDate"></p>
				</div>
			<div class="tbCon dashboard-map-chart">
				<%@include file="/WEB-INF/jsp/common/map.jsp"%>
			</div>
		</div>
	</div>
</div>

<script src="${ctx_res}/vendors/chart.js/js/Chart.min.js"></script>
<script src="${ctx_res}/vendors/@coreui/coreui-plugin-chartjs-custom-tooltips/js/custom-tooltips.min.js"></script>

<script>
// 국가별 수출입 데이터
// var g_ex_im_data = [
// 	["SA", "사우디아라비아", 'Saudi Arabia', [407, 612]],
// 	["AE", "아랍에미레이트", 'United Arab Emirates(UAE)', [435, 609]],
// 	["OM", "오만", 'Oman', [444, 616]],
// 	["IQ", "이라크", 'Iraq', [404, 615]],
// 	["PK", "파키스탄", 'Pakistan', [480, 590]],
// 	["TR", "터키", 'Turkey', [383, 565]],
// 	["RU", "러시아", 'Russia', [577, 577]]
// ];

var todo_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var todo_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var status_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var status_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var inpt_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var inpt_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
var inpt_labels = ['당일심사목록', '당일심사진행', '당일QA목록', '당일QA진행'];

$(function() {
	
	$('#graph').show();
	
	// 타이틀 삭제
	$('.title').remove();
	
	// 내업무Todo, 진행업무별 현재상태, 심사현황 데이터 불러오기
	fn_get_chart_data();
	
});

// 새로고침
$(document).on('click','#refreshBtn', function(e) {
	
	todo_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	todo_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	status_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	status_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	inpt_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	inpt_hover_background_color = ['#36A2EB', '#369e24', '#FFCE56', '#FF6384'];
	inpt_labels = ['당일심사목록', '당일심사진행', '당일QA목록', '당일QA진행'];
	
	fn_get_chart_data();
});

// 내업무Todo, 진행업무별 현재상태, 심사현황  데이터 불러오기
function fn_get_chart_data() {
	
	// 차트 데이터
	var _todo_list, _status_list, _inpt_list;
	var _todo_data = [];
	var _todo_labels = [];
	var _status_data = [];
	var _status_labels = [];
	var _inpt_data = [];
	var _inpt_labels = [];
	
	// 차트 데이터 체크변수
	var _todo_cnt = "0", _status_cnt = "0", _inpt_cnt = "0";
	
	// 테이블 초기화
	$('#todo_table').empty();
	$('#status_table').empty();
	$('#inpt_table').empty();
	
	$.ajax({
		url : "/api/dashboard",
		type : "post",
		dataType: "json",
		success : function(data) {
			_todoList = data.todoList;
			_statusList = data.statusList;
			_inptList = data.inptList;
			_impExpList = data.impExpList;
			
			var _businessDate = data.businessDate
			$('#mapDate').text('(' + dataFormat(_businessDate) + ' 기준)');
			
			var _html = "";
			
			console.log(data);
			
			// 내업무Todo
			for (var i in _todoList) {
				
				_todo_data.push(_todoList[i].totalCnt);
				_todo_labels.push(_todoList[i].aiInptCmnCdNm);
				
				// 데이플 데이터 추가
				_html = "";
				_html += '<tr>';
				_html += '<th class="td-text-left td-text-120" style="background: ' + todo_background_color[i] + ';">' + _todoList[i].aiInptCmnCdNm + '</th>';
				_html += '<td class="td-text-right td-text-40">' + _todoList[i].totalCnt + '</td>';
				_html += '</tr>';
				
				$('#todo_table').append(_html);
				
				// 차트 데이터 체크
				if (_todoList[i].totalCnt != "0") {
					_todo_cnt = _todoList[i].totalCnt;
				}
				
			}
			
			// 진행업무별 현재상태
			for (var i in _statusList) {
				
				_status_data.push(_statusList[i].totalCnt);
				_status_labels.push(_statusList[i].aiInptCmnCdNm);
				
				// 데이플 데이터 추가
				_html = "";
				_html += '<tr>';
				_html += '<th class="td-text-left td-text-120" style="background: ' + status_background_color[i] + ';">' + _statusList[i].aiInptCmnCdNm + '</th>';
				_html += '<td class="td-text-right td-text-40">' + _statusList[i].totalCnt + '</td>';
				_html += '</tr>';
				
				$('#status_table').append(_html);

				// 차트 데이터 체크
				if (_statusList[i].totalCnt != "0") {
					_status_cnt = _statusList[i].totalCnt;
				}
			}
			
			// 심사현황
			for (var i in _inptList) {
				
				_inpt_data.push(_inptList[i].totalCnt);
				_inpt_labels.push(_inptList[i].aiInptCmnCdNm);
				
				// 데이플 데이터 추가
				_html = "";
				_html += '<tr>';
				_html += '<th class="td-text-left td-text-120" style="background: ' + inpt_background_color[i] + ';">' + _inptList[i].aiInptCmnCdNm + '</th>';
				_html += '<td class="td-text-right td-text-40">' + _inptList[i].totalCnt + '</td>';
				_html += '</tr>';
				
				$('#inpt_table').append(_html);

				// 차트 데이터 체크
				if (_inptList[i].totalCnt != "0") {
					_inpt_cnt = _inptList[i].totalCnt;
				}
			}
			
			// 차트 데이터가 전부 0일경우 차트를 그려주기위해 강제로 데이터 1 추가
			if (_todo_cnt == "0") {
				_todo_data[0] = "1";
				todo_background_color = ['#bfc1c1', '#bfc1c1', '#bfc1c1', '#bfc1c1'];
			}
			if (_status_cnt == "0") {
				_status_data[0] = "1";
				status_background_color = ['#bfc1c1', '#bfc1c1', '#bfc1c1', '#bfc1c1'];
			}
			
			fn_set_todo_chart(_todo_data, _todo_labels, _todo_cnt);
			fn_set_status_chart(_status_data, _status_labels, _status_cnt);
			fn_set_inpt_chart(_inpt_data, _inpt_labels, _inpt_cnt);
			
			// 국가별 수출입 현황
			for (var i in _impExpList) {
				
				g_ex_im_data = [];
				
				for(var i in _impExpList) {
					var row = [];
					
					row.push(_impExpList[i].nacd);									//국가코드(NACD)
					row.push(_impExpList[i].korNlNm);								//국가 한글명
					row.push(_impExpList[i].engNlNm);								//국가 영문명
					row.push([_impExpList[i].export_cnt, _impExpList[i].import_cnt]);	//국가 수출입 건수, [수입건수,수출건수]
					
					g_ex_im_data.push(row);
				}
				
				fn_draw_country_data(g_ex_im_data);
				
			}
		},
		error : function(e) {
			console.log(e);
		}
	});
}

// 내업무Todo 차트 초기화
function fn_set_todo_chart(_todo_data, _todo_labels, _todo_cnt) {
	var todo_chart = new Chart($('#canvas-1'), {
		type: 'doughnut',
		data: {
			labels: _todo_labels,
			datasets: [{
				data: _todo_data,
				backgroundColor: todo_background_color,
				hoverBackgroundColor: todo_hover_background_color
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio:false,
			legend: false,
			tooltips: {
				callbacks: {
					label : function(tooltipItem, data) {
						if (_todo_cnt == '0') {
							return '데이터가 없습니다.';
						} else {
							return data.datasets[0].data[tooltipItem.index];
						}
					}
				}
			}
		}
	});
}

//진행업무별 현재상태 차트 초기화
function fn_set_status_chart(_status_data, _status_labels, _status_cnt) {
	var status_chart = new Chart($('#canvas-2'), {
		type: 'doughnut',
		data: {
			labels: _status_labels,
			datasets: [{
				data: _status_data,
				backgroundColor: status_background_color,
				hoverBackgroundColor: status_hover_background_color
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio:false,
			legend: false,
			tooltips: {
				callbacks: {
					label : function(tooltipItem, data) {
						if (_status_cnt == '0') {
							return '데이터가 없습니다.';
						} else {
							return data.datasets[0].data[tooltipItem.index];
						}
					}
				}
			}
		}
	});
}

function fn_set_inpt_chart(_inpt_data, _inpt_labels, _inpt_cnt) {
	
	var _scopeYMax = fnCmnGetArrayMaxItem(_inpt_data);
	
	var inpt_status_chart = new Chart($('#canvas-3'), {
		type: 'horizontalBar',
		data: {
			datasets: [{
				label: [_inpt_labels[0]],
				backgroundColor: '#36A2EB',
				borderColor: '#36A2EB',
				highlightFill: '#36A2EB',
				highlightStroke: '#36A2EB',
				data: [_inpt_data[0]]
			}, {
				label: [_inpt_labels[1]],
				backgroundColor: '#369e24',
				borderColor: '#369e24',
				highlightFill: '#369e24',
				highlightStroke: '#369e24',
				data:  [_inpt_data[1]]
			}, {
				label: [_inpt_labels[1]],
				backgroundColor: '#FFCE56',
				borderColor: '#FFCE56',
				highlightFill: '#FFCE56',
				highlightStroke: '#FFCE56',
				data: [_inpt_data[2]]
			}, {
				label: [_inpt_labels[3]],
				backgroundColor: '#FF6384',
				borderColor: '#FF6384',
				highlightFill: '#FF6384',
				highlightStroke: '#FF6384',
				data: [_inpt_data[3]]
			}]
		},
		options: {
			maintainAspectRatio: false,
			legend: false,
		    scales: {
				xAxes: [{
					ticks:{
						stepSize: Math.round(_scopeYMax / 4),
						beginAtZero: true,
						suggestedMax: (_scopeYMax + 1)		/* 차트 Y축 최대값 범위 지정 */
					}
				}]
			}
		}
	});
}

</script>