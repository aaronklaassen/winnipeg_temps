google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(loadData);


function drawChart(data_array) {
  
  column_names = ["Date", "Normal High", "Normal Low", "Actual High", "Actual Low"]
  var options = {
    colors: ["#0000FF", "#0000BB", "#FF0000", "#BB0000"],
    hAxis: { showTextEvery: 7 },
    vAxis: { title: "Temp (°C)" },
  };

  var contains_today = false;
  data_array.forEach(function(day) {
    if (day[5] != null) {
      contains_today = true;
    }
  });

  if (contains_today) {
    column_names.push("Current Temp");
    options.series = { 4: { pointSize: 10, color: "#FFAA00" } }
  } else {
    data_array = data_array.map(function(day) {
      return day.slice(0, 5);
    });
  }

  data_array.unshift(column_names);

  var data = google.visualization.arrayToDataTable(data_array);

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

function updatePermalink() {
  var url = "http://" + window.location.host + "?start=" + $("#start").val() + "&end=" + $("#end").val();;
  $(".permalink a").attr('href', url);
  $(".permalink a").html(url);

}

$(function() {
  updatePermalink();

  $('form').submit(function(e) {
    e.preventDefault();
    loadData();
    updatePermalink();
  });
});