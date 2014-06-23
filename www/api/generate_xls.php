<?php

include ("../../core/config.php");
include (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include (LIBRARIES_DIR . "php_excel/PHPExcel.php");

error_reporting(0);

if (!isset($_GET["id"])) {
	echo "Не передан идентификатор соревнования.";
} else {
	$cid = $_GET["id"];
}


/* get all data */
$db = new db;
$comp_info = $db->getRow("SELECT name, results FROM comp WHERE id = ?i", $cid);
$routes = $db->getAll("SELECT id, name FROM routes WHERE cid = ?i", $cid);
if (empty($comp_info["results"])) {
	$temp = $db->getAll("SELECT routes.id,
								routes.name,
								CONCAT(fname,' ',lname) AS fio
						FROM routes
						LEFT JOIN comp_riders 
							ON routes.id = comp_riders.rid
						LEFT JOIN users 
							ON comp_riders.uid = users.id
						WHERE routes.cid = ?i", $cid);

	$results = array();
	foreach ($temp as $element) {
		$results[$element["id"]][] = $element;
	}
} else {
	$results = unserialize($comp_info["results"]);
}

/* building */
$xlsReader = new PHPExcel_Reader_Excel5();
$xlsTemplate = $xlsReader->load(PROJECT_DIR . "additions/results_template.xls");
$temp_sheet = $xlsTemplate->getSheet(0);
$temp_sheet->setCellValueByColumnAndRow(0, 1, $comp_info["name"]);
foreach ($routes as $route) {
	$new_sheet = clone $temp_sheet;
	$new_sheet->setCellValueByColumnAndRow(0, 4, $route["name"]);
	$new_sheet->setCellValueByColumnAndRow(1, 5, $route["id"]);

	$row_number = 11;
	foreach ($results[$route["id"]] as $rider) {
		$new_sheet->insertNewRowBefore($row_number, 1);
		$new_sheet->setCellValueByColumnAndRow(1, $row_number, $rider["pos"]);
		$new_sheet->setCellValueByColumnAndRow(2, $row_number, $rider["fio"]);
		$new_sheet->setCellValueByColumnAndRow(3, $row_number, $rider["degree"]);
		$new_sheet->setCellValueByColumnAndRow(4, $row_number, $rider["horse"]);
		$new_sheet->setCellValueByColumnAndRow(5, $row_number, $rider["team"]);
		$new_sheet->setCellValueByColumnAndRow(6, $row_number, $rider["opt1"]);
		$new_sheet->setCellValueByColumnAndRow(7, $row_number, $rider["opt2"]);
		$new_sheet->setCellValueByColumnAndRow(8, $row_number, $rider["opt3"]);
		$new_sheet->setCellValueByColumnAndRow(9, $row_number, $rider["opt4"]);
		$new_sheet->setCellValueByColumnAndRow(10, $row_number, $rider["opt5"]);
		$new_sheet->setCellValueByColumnAndRow(11, $row_number, $rider["disq"]);
		++$row_number;
	}

	$new_sheet->setTitle($route["name"]);
	$xlsTemplate->addSheet($new_sheet);
}

$xlsTemplate->removeSheetByIndex(0);

/* modifying header */
header('Content-Type: application/vnd.ms-excel');
header('Content-Disposition: attachment;filename="' . $cid . '.xls"');
header('Cache-Control: max-age=0'); 

/* move to download */
$xlsWriter = new PHPExcel_Writer_Excel5($xlsTemplate);
$xlsWriter->save( "php://output" );

