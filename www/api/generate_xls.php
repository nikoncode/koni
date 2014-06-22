<?php

include ("../../core/config.php");
include (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include (LIBRARIES_DIR . "php_excel/PHPExcel.php");

$cid = 4;

/* get all data */
$db = new db;
$comp_info = $db->getRow("SELECT name FROM comp WHERE id = ?i", $cid);
$routes = $db->getAll("SELECT id, name FROM routes WHERE cid = ?i", $cid);
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
		$new_sheet->setCellValueByColumnAndRow(1, $row_number, "n/a");
		$new_sheet->setCellValueByColumnAndRow(2, $row_number, $rider["fio"]);
		$new_sheet->setCellValueByColumnAndRow(11, $row_number, "нет");
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

