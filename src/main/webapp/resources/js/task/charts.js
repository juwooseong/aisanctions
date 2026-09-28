var options={};
options.searchKeyword = "noting";

datas_a = "";

$.get("/api/task/log/inquiry", options, function(res, a, bs){
	         
	var datas = [];
	var datas2 = [];
	var json = res.chartList;
	var json2 = res.chart2List2;
	var length;
	if(!json.error){
		lengths = json.length;
		for(var i in json){
			datas[i*3] = json[i]['day'];
			datas[i*3+1] = json[i]['export'];
			datas[i*3+2] = json[i]['importt'];
		}
		
		}else{
			data=null;
	       swal("Cancelled", "데이터셋 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
	    }
	
	if(!json.error){
		//lengths = json2.length;
		
		for(var i in json2){
			datas2[i*4] = json2[i]['day'];
			datas2[i*4+1] = json2[i]['sw'];
			datas2[i*4+2] = json2[i]['tot'];
			datas2[i*4+3] = json2[i]['hang'];
		}
		
		}else{
			data=null;
	       swal("Cancelled", "데이터셋 조회에 실패하였습니다.\n잠시후에 다시 시도하기 바랍니다.", "error");
	    }
	
	datas_a = datas;



var random = function random() {
	  return Math.round(Math.random() * 100);
	}; // eslint-disable-next-line no-unused-vars
	
var lineChart = new Chart($('#canvas-1_2'), {
  type: 'line',
  data: {
    labels: [datas2[0], datas2[4], datas2[8], datas2[12], datas2[16]],
    datasets: [{
      label: 'SafeWatch',
      backgroundColor: 'rgba(220, 220, 220, 0.2)',
      borderColor: 'rgba(220, 220, 220, 1)',
      pointBackgroundColor: 'rgba(220, 220, 220, 1)',
      pointBorderColor: '#fff',
      data: [datas2[1], datas2[5], datas2[9], datas2[13], datas2[17]]
    }, {
      label: '항목심사',
      backgroundColor: 'rgba(151, 187, 205, 0.2)',
      borderColor: 'rgba(151, 187, 205, 1)',
      pointBackgroundColor: 'rgba(151, 187, 205, 1)',
      pointBorderColor: '#fff',
      data: [datas2[2], datas2[6], datas2[10], datas2[14], datas2[18]]
    }, {
        label: 'TotalText',
        backgroundColor: 'rgba(300, 400, 105, 0.2)',
        borderColor: 'rgba(600, 187, 205, 1)',
        pointBackgroundColor: 'rgba(151, 187, 205, 1)',
        pointBorderColor: '#fff',
        data: [datas2[3], datas2[7], datas2[11], datas2[15], datas2[19]]
      }]
  },
  options: {
    responsive: true
  }
}); // eslint-disable-next-line no-unused-vars

var lineChart2 = new Chart($('#canvas-1'), {
	  type: 'line',
	  data: {
	    labels: [datas_a[0], datas_a[3], datas_a[6], datas_a[9], datas_a[12]],
	    datasets: [{
	      label: '수출',
	      backgroundColor: 'rgba(220, 220, 220, 0.2)',
	      borderColor: 'rgba(220, 220, 220, 1)',
	      pointBackgroundColor: 'rgba(220, 220, 220, 1)',
	      pointBorderColor: '#fff',
	      data: [datas_a[1], datas_a[4], datas_a[7], datas_a[10], datas_a[13]]
	    }, {
	      label: '수입',
	      backgroundColor: 'rgba(151, 187, 205, 0.2)',
	      borderColor: 'rgba(151, 187, 205, 1)',
	      pointBackgroundColor: 'rgba(151, 187, 205, 1)',
	      pointBorderColor: '#fff',
	      data: [datas_a[2], datas_a[5], datas_a[8], datas_a[11], datas_a[14]]
	    }]
	  },
	  options: {
	    responsive: true
	  }
	});


var barChart = new Chart($('#canvas-2'), {
  type: 'bar',
  data: {
    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
    datasets: [{
      backgroundColor: 'rgba(220, 220, 220, 0.5)',
      borderColor: 'rgba(220, 220, 220, 0.8)',
      highlightFill: 'rgba(220, 220, 220, 0.75)',
      highlightStroke: 'rgba(220, 220, 220, 1)',
      data: [random(), random(), random(), random(), random(), random(), random()]
    }, {
      backgroundColor: 'rgba(151, 187, 205, 0.5)',
      borderColor: 'rgba(151, 187, 205, 0.8)',
      highlightFill: 'rgba(151, 187, 205, 0.75)',
      highlightStroke: 'rgba(151, 187, 205, 1)',
      data: [random(), random(), random(), random(), random(), random(), random()]
    }]
  },
  options: {
    responsive: true
  }
}); // eslint-disable-next-line no-unused-vars

var doughnutChart = new Chart($('#canvas-3'), {
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
});
});
//# sourceMappingURL=charts.js.map