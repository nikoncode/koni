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
$routes = $db->getAll("SELECT id, name, sub_type FROM routes WHERE cid = ?i", $cid);

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
	$heights = $db->getAll("SELECT * FROM routes_heights WHERE route_id = ?i", $route['id']);
	foreach($heights as $height) {
		$new_sheet->insertNewRowBefore($row_number, 1);
		$new_sheet->mergeCells('B' . $row_number . ':O' . $row_number);
		$new_sheet->setCellValueByColumnAndRow(1, $row_number, $height['height'] . ',' . $height['exam']);
		$results = $db->getAll("SELECT cr.*,CONCAT(u.fname,' ',u.lname) AS fio, c.name AS team, CONCAT(h.nick,', ',h.sex,', ',h.mast) AS horseName FROM comp_results AS cr
							INNER JOIN users AS u ON (cr.user_id = u.id)
							LEFT JOIN clubs AS c ON (c.id = cr.club_id)
							LEFT JOIN horses AS h ON (h.id = cr.horse)
							WHERE cr.rid = ?i",$height['id']);
		++$row_number;
		foreach ($results as $rider) {
			$new_sheet->insertNewRowBefore($row_number, 1);
			$new_sheet->setCellValueByColumnAndRow(1, $row_number, $rider["rank"]);
			$new_sheet->setCellValueByColumnAndRow(2, $row_number, $rider["fio"]);
			$new_sheet->setCellValueByColumnAndRow(3, $row_number, $rider["razryad"]);
			$new_sheet->setCellValueByColumnAndRow(4, $row_number, $rider["horseName"]);
			$new_sheet->setCellValueByColumnAndRow(5, $row_number, $rider["team"]);
			$new_sheet->setCellValueByColumnAndRow(6, $row_number, $rider["shtraf_route"]);
			$new_sheet->setCellValueByColumnAndRow(7, $row_number, $rider["time"]);
			$new_sheet->setCellValueByColumnAndRow(8, $row_number, $rider["shtraf"]);
			$new_sheet->setCellValueByColumnAndRow(9, $row_number, $rider["rerun"]);
			$new_sheet->setCellValueByColumnAndRow(10, $row_number, $rider["ball"]);
			$new_sheet->setCellValueByColumnAndRow(11, $row_number, $rider["time"]);
			$new_sheet->setCellValueByColumnAndRow(12, $row_number, $rider["norma"]);
			$new_sheet->setCellValueByColumnAndRow(13, $row_number, ($rider["disq"] > 0)?'Да':'');
			$new_sheet->setCellValueByColumnAndRow(14, $row_number, $rider["money"].$rider['currency']);
			++$row_number;
		}
	}

	if($route['sub_type'] == 'на чистоту и резвость')
	{
		$new_sheet->removeColumn('M', 1);
		$new_sheet->removeColumn('L', 1);
		$new_sheet->removeColumn('K', 1);
		$new_sheet->removeColumn('J', 1);
		$new_sheet->removeColumn('I', 1);
	}else
	if($route['sub_type'] == '269')
	{
		$new_sheet->removeColumn('M', 1);
		$new_sheet->removeColumn('J', 1);
		$new_sheet->removeColumn('I', 1);
		$new_sheet->removeColumn('H', 1);
		$new_sheet->removeColumn('G', 1);
	}else
	if($route['sub_type'] == 'с перепрыжкой')
	{
		$new_sheet->removeColumn('M', 1);
		$new_sheet->removeColumn('L', 1);
		$new_sheet->removeColumn('K', 1);
	}else{
		$new_sheet->removeColumn('L', 1);
		$new_sheet->removeColumn('K', 1);
	}
	$new_sheet->removeRow(10, 1);
	$new_sheet->setTitle(mb_substr($route["name"],0,30));
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

