<?php

include ("../../core/config.php");
include (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include (LIBRARIES_DIR . "php_excel/PHPExcel.php");

$xlsReader = new PHPExcel_Reader_Excel5();
$xlsOpen = $xlsReader->load("4.xls");

function compare($a, $b) {
	if ($a["pos"] == $b["pos"]) {
		return 0;
	}
	return ($a["pos"] < $b["pos"]) ? -1 : 1;
}


$results = array();
foreach ($xlsOpen->getWorksheetIterator() as $sheet) {
	if ($sheet->getCellByColumnAndRow(1, 10)->getCalculatedValue() == "BEGIN") {
		$route_id = $sheet->getCellByColumnAndRow(1, 5)->getCalculatedValue();
		$results[$route_id] = array();
		$row_number = 11;
		while ($sheet->getCellByColumnAndRow(1, $row_number)->getCalculatedValue() != "END") {
			$row = array(
				'pos' 	=> $sheet->getCellByColumnAndRow(1, $row_number)->getCalculatedValue(),
				'name' 	=> $sheet->getCellByColumnAndRow(2, $row_number)->getCalculatedValue(),
				'horse' => $sheet->getCellByColumnAndRow(4, $row_number)->getCalculatedValue(),
				'opt1' 	=> $sheet->getCellByColumnAndRow(6, $row_number)->getCalculatedValue(),
				'opt2' 	=> $sheet->getCellByColumnAndRow(7, $row_number)->getCalculatedValue(),
				'opt3' 	=> $sheet->getCellByColumnAndRow(8, $row_number)->getCalculatedValue(),
				'opt4' 	=> $sheet->getCellByColumnAndRow(9, $row_number)->getCalculatedValue(),
				'opt5' 	=> $sheet->getCellByColumnAndRow(10, $row_number)->getCalculatedValue(),
				'disq' 	=> $sheet->getCellByColumnAndRow(11, $row_number)->getCalculatedValue()
			);
			$results[$route_id][] = $row;
			$row_number++;
		}
		usort($results[$route_id], compare);
	}
}




print_r($results);