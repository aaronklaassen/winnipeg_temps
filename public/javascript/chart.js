google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(loadData);

function drawChart(data_array) {
  var data = google.visualization.arrayToDataTable(data_array);

  var options = {
    title: 'Temperatures'
  };

  var chart = new google.visualization.LineChart(document.getElementById('temp-chart'));
  chart.draw(data, options);
}

function loadData() {
  $.get('/temperatures',
    function(json) {
      drawChart(JSON.parse(json))
    }
  );
}