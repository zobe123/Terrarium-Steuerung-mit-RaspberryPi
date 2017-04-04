<?php 

// *************************************************
// ** Code made by (c) Vincent(at)Cruvellier(dot)eu
// * 2014, November.
// *************************************************
//
// This is just an example of reading server side data and sending it to the client.
// It reads a json formatted text file and outputs it.
// Call this file with the following parameters in GET Mode:
//        t=tablename&f=fieldname&u=tick
// Typical use in external Javascript call:
//


// Configuration file for the Database Connection

$_DBname = 'Terrarium'; // Enter DB Here
$_DBusername = 'root'; // Enter Username Here
$_DBpassword = 'raspberry'; // Enter Password Here


date_default_timezone_set('Europe/Paris');

//*****************************************************************************
//* function _DateTimeToJavaScript => return Date Time script useable in JSON data format
//*  $adatetime : string from a query database following this format: Y-m-d H:i:s.
//*		refers to mysql manual for DATE_FORMAT function if needed.
//*****************************************************************************
function _DateTimeToJavaScript($adatetime) {
   // WARNING: assumes dates are patterned 'yyyy-MM-dd hh:mm:ss'  
   preg_match('/(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/', $adatetime, $match);
   $year = (int) $match[1];
   $month = (int) $match[2] - 1; // convert to zero-index to match javascript's dates
   $day = (int) $match[3];
   $hours = (int) $match[4];
   $minutes = (int) $match[5];
   $seconds = (int) $match[6];
   return "Date($year, $month, $day, $hours, $minutes, $seconds)";
} // End of _DateTimeToJavaScript

//*****************************************************************************
//* function _QueryToJson => return a Json Array useable with Google Charts
//*  $tableName_ : string Name of the sensor table name to query in database.
//*  $fieldName_ : string Name of the field  name to query in from the table in database.
//*  $tick_      : Future use: tick = Hourly, Daily ....
//*****************************************************************************
function _QueryToJson($tableName_, $fieldName_, $fieldName2_, $tick_) { 



  $conn = new PDO("mysql:host=localhost;dbname=Terrarium", 'root', 'raspberry');
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

try { 
	$_StrQuery=";";
	if (strcmp($tick_,"HOURLY")==0) { // Hourly Tick based
		$_StrQuery = "SELECT DATE_FORMAT(timestamp,'%X-%m-%d %H:00:00') as datetime, 
  		avg($fieldName_) as ${fieldName_},
  		avg($fieldName2_) as ${fieldName2_}
  		from $tableName_ WHERE (timestamp > DATE_SUB(NOW(), INTERVAL 72 HOUR)) GROUP BY  DATE_FORMAT(timestamp,'%X-%m-%d %H:00:00') 
  		ORDER BY 1 ASC;";
        
	} elseif (strcmp($tick_,"DAILY")==0) { // Daily Tick based
		$_StrQuery = "SELECT DATE_FORMAT(timestamp,'%X-%m-%d 00:00:00') as datetime, 
  		avg($fieldName_) as ${fieldName_},
  		avg($fieldName2_) as ${fieldName2_}
  		from $tableName_ WHERE (timestamp > DATE_SUB(NOW(), INTERVAL 15 DAY)) GROUP BY  DATE_FORMAT(timestamp,'%X-%m-%d 00:00:00') 
  		ORDER BY 1 ASC;";
        
	} elseif (strcmp($tick_,"RAW")==0) { // Daily Tick based
		$_StrQuery = "SELECT DATE_FORMAT(timestamp,'%X-%m-%d %H:%i:%s') as datetime, 
  		$fieldName_, 
  		$fieldName2_ 
  		FROM $tableName_ WHERE (timestamp > DATE_SUB(NOW(), INTERVAL 1 DAY))
  		ORDER BY 1 ASC;";
        
	} elseif (strcmp($tick_,"MONTHLY")==0) { // Monthly Tick based
		$_StrQuery = "SELECT DATE_FORMAT(timestamp,'%X-%m-01 00:00:00') as datetime, 
  		avg($fieldName_) as ${fieldName_},
  		avg($fieldName2_) as ${fieldName2_}
  		from $tableName_ GROUP BY DATE_FORMAT(timestamp,'%X-%m-01 00:00:00')
  		ORDER BY 1 ASC;";
        //$_StrQuery = "SELECT month(timestamp) as datetime, avg(value_1) as value_1, avg(value_2) as value_2 from temperature_log GROUP BY month(timestamp) ORDER BY 1 ASC;";
        
	} else {
		$_StrQuery = "SELECT DATE_FORMAT(timestamp,'%X-%m-%d %H:%i:%s') as datetime, 
  		$fieldName_, 
  		$fieldName2_ 
  		FROM $tableName_ WHERE (timestamp > DATE_SUB(NOW(), INTERVAL 1 DAY))
  		ORDER BY 1 ASC;";
    }
    
	$result = $conn->query($_StrQuery); // Execute the Query
  	// An array will be build in order to store data as per needed for a JSON further use
	$rows = array();
	$table = array();
	$table['cols'] = array(
		array('label' => 'datetime', 'type' => 'datetime'), 
//		array('label' => "${fieldName_}", 'type' => 'number'),
		array('label' => "Sensor 1", 'type' => 'number'),
//		array('label' => "${fieldName2_}", 'type' => 'number'),
		array('label' => "Sensor 2", 'type' => 'number'),
	); // Creation of the column header definition.
	// We will push the data in the array following a loop from the query results
	foreach($result as $r) {
		$my_date_ = _DateTimeToJavaScript($r['datetime']); // call function to convert to Javascript format expected
		$data = array();
	  	$data[] = array('v' =>  $my_date_);
	  	$data[] = array('v' => sprintf("%.1f", $r["${fieldName_}"]));
	  	$data[] = array('v' => sprintf("%.1f", $r["${fieldName2_}"]));
	  	$rows[] = array('c' => $data);
  	}
	$table['rows'] = $rows;
  } catch(PDOException $e) {
	echo 'ERROR: ' . $e->getMessage();
  }
return(json_encode($table));
} // End of _QueryToJson

// Default data for easiest use
//$tableName_ = "temperature_log";
$fieldName_ = "value_1";
$fieldName2_ = "value_2";
//$tick_ = "RAW";

if (isset($_GET['t'])) {$tableName_ = $_GET['t'];}
if (isset($_GET['f'])) {$fieldName_ = $_GET['f'];}
if (isset($_GET['g'])) {$fieldName2_ = $_GET['g'];}
if (isset($_GET['u'])) {$tick_ = $_GET['u'];}


// push Header (JSON)
header('Content-type: application/json');
// return the JSON Data content
$temp  = _QueryToJson($tableName_, $fieldName_, $fieldName2_, $tick_);
echo $temp;
?>
