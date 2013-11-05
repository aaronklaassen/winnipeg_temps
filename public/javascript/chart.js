google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(loadData);


function drawChart(data_array) {
  data_array.unshift(["Date", "Normal High", "Normal Low", "Actual High", "Actual Low"]);
  var data = google.visualization.arrayToDataTable(data_array);

  var options = {
    colors: ["#0000FF", "#0000BB", "#FF0000", "#BB0000"],
    hAxis: { showTextEvery: 7 },
    vAxis: { title: "Temp (°C)" }
  };

  var chart = new google.visualization.LineChart(document.getElementById('temp-chart'));
  chart.draw(data, options);
}

function loadData() {
  $.get(
    '/temperatures.json',
    { 
      start: $("#start").val(),
      end:   $("#end").val()
    }, 
    function(json) {
      drawChart(json);
    }
  );
}


$(function() {
  $('form').submit(function(e) {
    e.preventDefault();
    loadData();
  });
});