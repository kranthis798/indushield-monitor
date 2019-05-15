$(function() {
  var startPicker = $("#filter_picker").fdatepicker({});

  $('#status_New,#status_Compliant,#status_Non_Compliant,#status_Billing_Problem').change(function() {
      var val = [];
        var k=0;
          $('.status_leadbox').each(function(i){
           if ($('.status_leadbox')[i].checked){
              if($(this).val()=='New'){
                  val[k] = 'temporary'
                }else if($(this).val()=='Compliant'){
                  val[k] = 'active'
                }else if($(this).val()=='Non Compliant'){
                  val[k] = 'denied'
                }else if($(this).val()=='Billing Problem'){
                  val[k] = 'billing'
                }
              k++;            
            }
          });
      if(val.length>0)
        location.href="/reports/residents/hot-leads?status="+val
      else
        location.href="/reports/residents/hot-leads"
  });

  window.createPieChart = function(elementID, data, tooltipSuffix) {
    var ctx = document.getElementById(elementID);
    tooltipSuffix = ( tooltipSuffix != null ) ? tooltipSuffix : "";
    var myPieChart = new Chart(ctx,{
      type:'pie',
      data: data,
      options: {
        hover: {
          onHover: onChartHover
        },
        tooltips: {
          callbacks: {
            label: function(item, data) {
              var allData = data.datasets[item.datasetIndex].data;
              var tooltipData = allData[item.index];
              var tooltipLabel = data.labels[item.index];
              return tooltipLabel+": "+tooltipData+tooltipSuffix;
            }
          }
        }
      }
    });

    ctx.onclick = function(evt)
    {
      onChartClick(evt, myPieChart, "pie");
    }
  };

  window.createBarChart = function(elementID, data) {
    var ctx = document.getElementById(elementID);
    var myChart = new Chart(ctx,{
      type:'bar',
      data: data,
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero:true
            }
          }]
        },
        hover: {
          onHover: onChartHover
        },
        legend: {
          display:false
        }
      }
    });
    ctx.onclick = function(evt)
    {
      onChartClick(evt, myChart, "bar");
    }
  };

  function onChartHover(evt) {
    if (evt.length > 0) {
      $("canvas").css("cursor", "pointer");
    }
    else {
      $("canvas").css("cursor", "auto");
    }
  }

  function onChartClick(evt, chart, type) {
    var activePoints;
    switch (type) {
      case "pie":
        activePoints = chart.getElementsAtEvent(evt);
        break;
      case "bar":
        activePoints = chart.getElementsAtEvent(evt);
        break;
    }
    if ( activePoints.length > 0 ) {
      var clickedElementindex = activePoints[0]["_index"];
      var label = chart.data.labels[clickedElementindex];
      var value = chart.data.datasets[0].data[clickedElementindex];
      var url = "/reports/service_type?label="+label;
      window.location.href=url;
    }
  }


  $("#agency_comm_details").DataTable({
    "language": {
      "lengthMenu": "Show: _MENU_"
    }
  });

  $(".reportListView").DataTable({
    "iDisplayLength": 50,
    "language": {
      "lengthMenu": "Show: _MENU_"
    }
  });

  $("#hotLeads").DataTable({
    "iDisplayLength": 50,
    "order": [[ 5, "desc" ]],
    "language": {
      "lengthMenu": "Show: _MENU_"
    }
  });


});