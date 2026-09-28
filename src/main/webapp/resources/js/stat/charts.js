var options={};

datas_a = "";

function drawChart(schSdate1, schEdate1){
	options.schSdate1 = schSdate1;
	options.schEdate1 = schEdate1;
		$.get("/api/stat/analysis", options, function(res, a, bs){
			var dateTerm = [];
			var nomals = [];
			var textNonExtrs = [];
			var aicrs = [];
			var tas = [];
			var NomalAvgs = [];
			var UnNomalAvgs = [];
			
			var json = res.resultList;
			
			var length;
			var NomalCnt; 
			var UnNomalTotalCnt;
			var NomalAvg;
			var UnNomalAvg;
			if(!json.error){
				lengths = json.length;
				
				for(var i in json){
					dateTerm[i] = json[i]['day'];
					nomals[i] =  Number((json[i]['nomal']));
						NomalCnt = nomals[i];
					textNonExtrs[i] =  Number((json[i]['textNonExtr']));
					aicrs[i] =  Number((json[i]['aicr']));
					tas[i] =  Number((json[i]['ta']));
						UnNomalTotalCnt = textNonExtrs[i] + aicrs[i] + tas[i];
						NomalAvg = Math.floor((NomalCnt / (UnNomalTotalCnt + NomalCnt)) * 100);
					NomalAvgs[i] = NomalAvg;
						UnNomalAvg = 100 - NomalAvg;
					UnNomalAvgs[i] = UnNomalAvg;
					
				}
			}else{
				console.log("실패입니다.");
				data=null;
				swal("Cancelled", "데이터셋 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
			}
			
			/*var random = function random() {
				return Math.round(Math.random() * 100);
			}; */
			
			// 정상 & 오류 선 그래프
			
			var lineChart = new Chart($('#canvas-1_2'), { 
				type: 'line',
				data:{
					labels: (function () {
								var datas = []
								for(var i=0; i<dateTerm.length; i++){
									datas.push(dateTerm[i])
								}
								return datas;
					})(),
					datasets: [{
						label: '정상',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(255, 0, 0, 0.5)',
						pointBackgroundColor: 'rgba(255, 0, 0, 0.5)',
						pointBorderColor: '#fff',
						data: (function () {
							var datas = []
							for(var i=0; i<NomalAvgs.length; i++){
								datas.push(NomalAvgs[i])
							}
							return datas;
						})()
					}, {
						label: '오류',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						pointBackgroundColor: 'rgba(000, 000, 255, 0.5)',
						pointBorderColor: '#FFF6347',
						data: (function () {
							var datas = []
							for(var i=0; i<UnNomalAvgs.length; i++){
								datas.push(UnNomalAvgs[i])
							}
							return datas;
						})()
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			
			// 오류 항목별 선 그래프
			var lineChart2 = new Chart($('#canvas-1'), {
				type: 'line',
				data: {
					labels: (function () {
						var datas = []
						for(var i=0; i<dateTerm.length; i++){
							datas.push(dateTerm[i])
						}
						return datas;
					})(),
					datasets: [{
						label: 'Text 미추출',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(255, 0, 0, 0.5)',
						pointBackgroundColor: 'rgba(255, 0, 0, 0.5)',
						pointBorderColor: '#FFFFA500',
						data: (function () {
							var datas = []
							for(var i=0; i<textNonExtrs.length; i++){
								datas.push(textNonExtrs[i])
							}
							return datas;
						})()
					}
					, {
						label: '단어보정(AICR)',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						pointBackgroundColor: 'rgba(000, 000, 255, 0.5)',
						pointBorderColor: 'FFB4B9',
						data: (function () {
							var datas = []
							for(var i=0; i<aicrs.length; i++){
								datas.push(aicrs[i])
							}
							return datas;
						})()
					}
					, {
						label: '단어보정(TA)',
						backgroundColor: 'rgba(255, 255, 255, 0.5)',
						borderColor: 'rgba(000, 053, 000, 0.5)',
						pointBackgroundColor: 'rgba(000, 053, 000, 0.5)',
						pointBorderColor: '#fff',
						data: (function () {
							var datas = []
							for(var i=0; i<tas.length; i++){
								datas.push(tas[i])
							}
							return datas;
						})()
					}]
				},
				options: {
					responsive: true
				}
			});
			
			
			var barChart = new Chart($('#canvas-2'), {
				type: 'bar',
				data: {
					labels: (function () {
						var datas = []
						for(var i=0; i<dateTerm.length; i++){
							datas.push(dateTerm[i])
						}
						return datas;
					})(),
					datasets: [{
						label: '정상',
						backgroundColor: 'rgba(255, 0, 0, 0.5)',
						borderColor: 'rgba(255, 0, 0, 0.5)',
						highlightFill: 'rgba(220, 220, 220, 0.75)',
						highlightStroke: 'rgba(220, 220, 220, 1)',
						data: (function () {
							var datas = []
							for(var i=0; i<NomalAvgs.length; i++){
								datas.push(NomalAvgs[i])
							}
							return datas;
						})()
					}, {
						label: '오류',
						backgroundColor: 'rgba(000, 000, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						highlightFill: 'rgba(151, 187, 205, 0.75)',
						highlightStroke: 'rgba(151, 187, 205, 1)',
						data: (function () {
							var datas = []
							for(var i=0; i<UnNomalAvgs.length; i++){
								datas.push(UnNomalAvgs[i])
							}
							return datas;
						})()
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			
			var barChart = new Chart($('#canvas-2_2'), {
				type: 'bar',
				data: {
					labels: (function () {
						var datas = []
						for(var i=0; i<dateTerm.length; i++){
							datas.push(dateTerm[i])
						}
						return datas;
					})(),
					datasets: [{    
						label: 'Text 미추출',
						backgroundColor: 'rgba(255, 0, 0, 0.5)',
						borderColor: 'rgba(255, 0, 0, 0.5)',
						highlightFill: 'rgba(700, 287, 585, 0.35)',
						highlightStroke: 'rgba(700, 287, 585, 1)',
						data: (function () {
							var datas = []
							for(var i=0; i<textNonExtrs.length; i++){
								datas.push(textNonExtrs[i])
							}
							return datas;
						})()
					}, {
						label: '단어보정(AICR)',
						backgroundColor: 'rgba(000, 000, 255, 0.5)',
						borderColor: 'rgba(000, 000, 255, 0.5)',
						highlightFill: 'rgba(151, 187, 205, 0.75)',
						highlightStroke: 'rgba(151, 187, 205, 1)',
						data: (function () {
							var datas = []
							for(var i=0; i<aicrs.length; i++){
								datas.push(aicrs[i])
							}
							return datas;
						})()
					}, {
						label: '단어보정(TA)',
						backgroundColor: 'rgba(000, 102, 000, 0.5)',
						borderColor: 'rgba(000, 102, 000, 0.5)',
						highlightFill: 'rgba(151, 187, 205, 0.75)',
						highlightStroke: 'rgba(151, 187, 205, 1)',
						data: (function () {
							var datas = []
							for(var i=0; i<tas.length; i++){
								datas.push(tas[i])
							}
							return datas;
						})()
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			/*var doughnutChart = new Chart($('#canvas-3'), {
				type: 'doughnut',
				data: {
					labels: ['Red', 'Green', 'Yellow'],
					datasets: [{
						data: [300, 50, 100],
						backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
						hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			
			var radarChart = new Chart($('#canvas-4'), {
				type: 'radar',
				data: {
					labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],
					datasets: [{
						label: 'My First dataset',
						backgroundColor: 'rgba(220, 220, 220, 0.2)',
						borderColor: 'rgba(220, 220, 220, 1)',
						pointBackgroundColor: 'rgba(220, 220, 220, 1)',
						pointBorderColor: '#fff',
						pointHighlightFill: '#fff',
						pointHighlightStroke: 'rgba(220, 220, 220, 1)',
						data: [65, 59, 90, 81, 56, 55, 40]
					}, {
						label: 'My Second dataset',
						backgroundColor: 'rgba(151, 187, 205, 0.2)',
						borderColor: 'rgba(151, 187, 205, 1)',
						pointBackgroundColor: 'rgba(151, 187, 205, 1)',
						pointBorderColor: '#fff',
						pointHighlightFill: '#fff',
						pointHighlightStroke: 'rgba(151, 187, 205, 1)',
						data: [28, 48, 40, 19, 96, 27, 100]
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			
			var pieChart = new Chart($('#canvas-5'), {
				type: 'pie',
				data: {
					labels: ['Red', 'Green', 'Yellow'],
					datasets: [{
						data: [300, 50, 100],
						backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
						hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
					}]
				},
				options: {
					responsive: true
				}
			}); // eslint-disable-next-line no-unused-vars
			
			var polarAreaChart = new Chart($('#canvas-6'), {
				type: 'polarArea',
				data: {
					labels: ['Red', 'Green', 'Yellow', 'Grey', 'Blue'],
					datasets: [{
						data: [11, 16, 7, 3, 14],
						backgroundColor: ['#FF6384', '#4BC0C0', '#FFCE56', '#E7E9ED', '#36A2EB']
					}]
				},
				options: {
					responsive: true
				}
			});*/
		});
}
//# sourceMappingURL=charts.js.map