<html>
  <head>
    <meta charset="utf-8">
    <title>Terrarium Daten</title>

	<!--Load the AJAX API-->
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script type="text/javascript">
    

	function getParameterByName(name) {
		var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
		return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
	}
	
google.charts.load('current', {packages: ['corechart'], 'language': 'de'});
//google.charts.setOnLoadCallback(drawChart);

//      google.load('visualization', '1.0', {'packages':['corechart']});
//	  google.setOnLoadCallback(drawChart);
	google.charts.setOnLoadCallback(
        function() {
          var tick = getParameterByName('u');  
          if (!tick) {
              tick = "RAW";
          }          
            
          drawChart(tick);
        }
      );

function drawChart(tick) {

      var jsonDataTemp = $.ajax({
          url: "_getLightData.php?t=temperature_log&u=" + tick,
          dataType:"json",
          async: false
          }).responseText;

      var jsonDataHumi = $.ajax({
          url: "_getLightData.php?t=humidity_log&u=" + tick,
          dataType:"json",
          async: false
          }).responseText;		  

    var dataTemp = new google.visualization.DataTable(jsonDataTemp);
    var chartTemp = new google.visualization.AreaChart(document.getElementById('chart_div_temp'));
	var optionsTemp = {
          title: 'Temperatur (°C)',
		  legend:  { position: 'bottom' },
          curveType: 'function',
		  chartArea: {left:'30', top:'30', width:'95%'}
        };
  chartTemp.draw(dataTemp, optionsTemp);
 
	var dataHumi = new google.visualization.DataTable(jsonDataHumi);
	var chartHumi = new google.visualization.AreaChart(document.getElementById('chart_div_humi'));
  	var optionsHumi = {
          title: 'Feuchtigkeit (%)',
          curveType: 'function',
		  legend:  { position: 'bottom' },
		  chartArea: {left:'30', top:'30', width:'95%'}
        };
  chartHumi.draw(dataHumi, optionsHumi); 
  }

    </script>
</head>

<body>
  <CENTER><H1>Terrarium Temperatur und Feuchtigkeits Werte</H1></CENTER>
  <table style="width:100%">
  <tr>
    <td><div id="chart_div_temp"></div></td>
	<td style="width:20%">
	<?php 
	echo '<a href="index.php?u=RAW">letzte 24h</a><br>';
	echo '<a href="index.php?u=HOURLY">letzte 72h</a><br>';
	echo '<a href="index.php?u=DAILY">letzte 15 Tage</a><br>';
	echo '<a href="index.php?u=MONTHLY">letzter Monat</a><br>';

	?>
	</td>
  </tr>
  <tr>
	<td><div id="chart_div_humi"></div></td>
	<td style="width:20%">
	</td>
  </tr>
  </table>
  </body>
  </html>