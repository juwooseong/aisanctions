var options={};

var lineChart;
var lineChart2;
var barChart;
var barChart2;

datas_a = "";

function drawChart(schSdate1, schEdate1){
	
	 if(lineChart){lineChart.destroy();}
	 if(lineChart2){lineChart2.destroy();}
	 if(barChart){barChart.destroy();}
	 if(barChart2){barChart2.destroy();}
	
	options.schSdate1 = schSdate1;
	options.schEdate1 = schEdate1;
		$.get("/api/stat/analysis", options, function(res, a, bs){
			var dateTerm = [];
			var nomals = [];
			var textNonExtrs = [];
			var textNonExtrsPer = [];
			var aicrs = [];
			var aicrsPer = [];
			var tas = [];
			var mass = [];
			var massPer = [];
			var tasPer = [];
			var nomalsPer = [];
			//var errorCnt = [];
			var NomalAvgs = [];
			var UnNomalAvgs = [];
			var json = res.resultList;
			var length;
			var NomalCnt; 
			var UnNomalTotalCnt;
			var NomalAvg;
			var UnNomalAvg;
			
			if(!res.resultList && !res.resultList.length){
				$('#noSrchRstNotice').show();
			}else{
				if(!json.error){
					lengths = json.length;
					for(var i=0; i<lengths-2; i++){
						dateTerm[i] = json[i]['day'];
						mass[i] = json[i]['mas'];
						nomals[i] =  Number((json[i]['nomal']));
						//	NomalCnt = nomals[i];
						textNonExtrs[i] =  Number((json[i]['textNonExtr']));
						aicrs[i] =  Number((json[i]['aicr']));
						tas[i] =  Number((json[i]['ta']));
						//	UnNomalTotalCnt = textNonExtrs[i] + aicrs[i] + tas[i];
							totalCnt = mass[i];
							//totalCnt = textNonExtrs[i] + aicrs[i] + tas[i] + nomals[i];
						massPer[i] = (mass[i] / totalCnt * 100).toFixed(1);
						nomalsPer[i] = (nomals[i] / totalCnt * 100).toFixed(1);
						textNonExtrsPer[i] = (textNonExtrs[i] / totalCnt * 100).toFixed(1);
						aicrsPer[i] = (aicrs[i] / totalCnt * 100).toFixed(1);
						tasPer[i] = (tas[i] / totalCnt * 100).toFixed(1);
						//	NomalAvg = ((NomalCnt / (UnNomalTotalCnt + NomalCnt)) * 100).toFixed(1);
							//NomalAvg = NomalAvg.toFixed(2);
						//NomalAvgs[i] = NomalAvg;
						//	UnNomalAvg = 100 - NomalAvg;
						//UnNomalAvgs[i] = UnNomalAvg;
					}
				}else{
					console.log("실패입니다.");
					data=null;
					swal("Cancelled", "데이터셋 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
				}
				
				// 정상 & 오류 선 그래프
				lineChart = new Chart($('#canvas-1_2'), { 
					type: 'line',
					data:{
						labels: (function () {
									var datas = [];
									var tempDate;
									var tempDateDay;
									var fullDay;
									for(var i=0; i<dateTerm.length; i++){
										tempDateMon = dateTerm[i].substr(4,2);
										tempDateDay = dateTerm[i].substr(6,2);
										console.log(tempDateMon + '/' + tempDateDay);
										fullDay = tempDateMon + '/' + tempDateDay;
										datas.push(fullDay);
									}
									return datas;
						})(),
						datasets: [{    
							label: '자동건수',
						//	backgroundColor: 'rgba(000, 000, 255, 0.5)',
							borderColor: 'rgba(000, 000, 255, 0.5)',
							pointBackgroundColor: 'rgba(151, 187, 205, 0.75)',
							pointBorderColor: '#fff',
							data: (function () {
								var datas = []
								for(var i=0; i<nomalsPer.length; i++){
									datas.push(nomalsPer[i])
								}
								return datas;
							})()
						}, {    
							label: '수기등록',
							//backgroundColor: 'rgba(255, 0, 0, 0.5)',
							borderColor: 'rgba(255, 0, 0, 0.5)',
							pointBackgroundColor: 'rgba(700, 287, 585, 0.35)',
							pointBorderColor: '#fff',
							data: (function () {
								var datas = []
								for(var i=0; i<textNonExtrsPer.length; i++){
									datas.push(textNonExtrsPer[i])
								}
								return datas;
							})()
						}, {
							label: '저품질',
						//	backgroundColor: 'rgba(000, 102, 000, 0.5)',
							borderColor: 'rgba(000, 102, 000, 0.5)',
							pointBackgroundColor: 'rgba(151, 187, 205, 0.75)',
							pointBorderColor: '#fff',
							data: (function () {
								var datas = []
								for(var i=0; i<aicrsPer.length; i++){
									datas.push(aicrsPer[i])
								}
								return datas;
							})()
						}, {
							label: '재추출',
						//	backgroundColor: 'rgba(0, 0, 0, 0.5)',
							borderColor: 'rgba(0, 0, 0, 0.5)',
							pointBackgroundColor: 'rgba(700, 287, 585, 0.35)',
							pointBorderColor: '#fff',
							data: (function () {
								var datas = []
								for(var i=0; i<tasPer.length; i++){
									datas.push(tasPer[i])
								}
								return datas;
							})()
						}]
					},
					options: {
						responsive: true,
						scales: {
						     yAxes: [{
						      beginAtZero :true,
						      display: true,
						      ticks: {
						       min: 0,
						       max: 100  /* 차트 Y축 최대값 범위 지정 */
						      }
						    }]
						},
						tooltips: {
							callbacks: {
								label : function(tooltipItem, data) {
									return data.datasets[tooltipItem.datasetIndex].label + " : " + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + "%";
								}
							}
						}
					}
				}); // eslint-disable-next-line no-unused-vars
				
				
				barChart2 = new Chart($('#canvas-2_2'), {
					type: 'bar',
					data: {
						labels: (function () {
							var datas = [];
							var tempDate;
							var tempDateDay;
							var fullDay;
							for(var i=0; i<dateTerm.length; i++){
								tempDateMon = dateTerm[i].substr(4,2);
								tempDateDay = dateTerm[i].substr(6,2);
								console.log(tempDateMon + '/' + tempDateDay);
								fullDay = tempDateMon + '/' + tempDateDay;
								datas.push(fullDay);
							}
							return datas;
						})(),
						datasets: [{    
							label: '자동건수',
							backgroundColor: 'rgba(000, 000, 255, 0.5)',
							borderColor: 'rgba(000, 000, 255, 0.5)',
							highlightFill: 'rgba(151, 187, 205, 0.75)',
							highlightStroke: 'rgba(151, 187, 205, 1)',		
							data: (function () {
								var datas = []
								for(var i=0; i<nomalsPer.length; i++){
									datas.push(nomalsPer[i])
								}
								return datas;
							})(),
							data2: (function () {
								var datas = []
								for(var i=0; i<nomals.length; i++){
									datas.push(nomals[i])
								}
								return datas;
							})()
						}, {    
							label: '수기등록',
							backgroundColor: 'rgba(255, 0, 0, 0.5)',
							borderColor: 'rgba(255, 0, 0, 0.5)',
							highlightFill: 'rgba(700, 287, 585, 0.35)',
							highlightStroke: 'rgba(700, 287, 585, 1)',
							data: (function () {
								var datas = []
								for(var i=0; i<textNonExtrsPer.length; i++){
									datas.push(textNonExtrsPer[i])
								}
								return datas;
							})(),
							data2: (function () {
								var datas = []
								for(var i=0; i<textNonExtrs.length; i++){
									datas.push(textNonExtrs[i])
								}
								return datas;
							})()
						}, {
							label: '저품질',
							
							backgroundColor: 'rgba(000, 102, 000, 0.5)',
							borderColor: 'rgba(000, 102, 000, 0.5)',
							highlightFill: 'rgba(151, 187, 205, 0.75)',
							highlightStroke: 'rgba(151, 187, 205, 1)',
							
							data: (function () {
								var datas = []
								for(var i=0; i<aicrsPer.length; i++){
									datas.push(aicrsPer[i])
								}
								return datas;
							})(),
							data2: (function () {
								var datas = []
								for(var i=0; i<aicrs.length; i++){
									datas.push(aicrs[i])
								}
								return datas;
							})()
						}, {
							label: '재추출',
							backgroundColor: 'rgba(0, 0, 0, 0.5)',
							borderColor: 'rgba(0, 0, 0, 0.5)',
							highlightFill: 'rgba(700, 287, 585, 0.35)',
							highlightStroke: 'rgba(700, 287, 585, 1)',
							data: (function () {
								var datas = []
								for(var i=0; i<tasPer.length; i++){
									datas.push(tasPer[i])
								}
								return datas;
							})(),
							data2: (function () {
								var datas = []
								for(var i=0; i<tas.length; i++){
									datas.push(tas[i])
								}
								return datas;
							})()
						}]
					},
					options: {
						responsive: true,
						scales: {
						     yAxes: [{
						      beginAtZero :true,
						      display: true,
						      ticks: {
						       min: 0,
						       max: 100  /* 차트 Y축 최대값 범위 지정 */
						      }
						    }]
						},
						tooltips: {
							callbacks: {
								label : function(tooltipItem, data) {
									return data.datasets[tooltipItem.datasetIndex].label + " : " + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + "% ("+data.datasets[tooltipItem.datasetIndex].data2[tooltipItem.index]+"건)";
								}
							}
						}
					}
				}); // eslint-disable-next-line no-unused-vars
			}
		});

}