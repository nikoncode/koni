<?php

include ("../../core/config.php");
include (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include (LIBRARIES_DIR . "php_excel/PHPExcel.php");

//error_reporting(0);

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
$xlsTemplate = $xlsReader->load(PROJECT_DIR . "additions/startlist_template.xls");
$temp_sheet = $xlsTemplate->getSheet(0);
$temp_sheet->setCellValueByColumnAndRow(0, 1, $comp_info["name"]);
$ranks = array(
    0 => "б/р",
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "КМС",
    5 => "МС",
    6 => "МСМК",
    7 => "ЗМС"
);

foreach ($routes as $route) {
    $new_sheet = clone $temp_sheet;
    $new_sheet->setCellValueByColumnAndRow(0, 4, $route["name"]);
    $new_sheet->setCellValueByColumnAndRow(1, 5, $route["id"]);

    $row_number = 9;
    $heights = $db->getAll("SELECT * FROM routes_heights WHERE route_id = ?i", $route['id']);
    foreach($heights as $height){
        $new_sheet->insertNewRowBefore($row_number, 1);
        $new_sheet->mergeCells('B'.$row_number.':F'.$row_number);
        $new_sheet->setCellValueByColumnAndRow(1, $row_number, $height['height'].','.$height['exam']);
        $results = $db->getAll("SELECT 	users.id,
															fname,
															lname,
															horses.nick as horse,
															horses.id as horse_id,
															horses.owner,
															clubs.name as club,
															clubs.id as club_id,
															(SELECT CONCAT(fname, ' ', lname) as fio FROM users WHERE id = horses.o_uid) as ownerName,
															comp_riders.id as ride_id,
															comp_riders.ordering,
															users.rank
													FROM comp_riders
													INNER JOIN users ON (comp_riders.uid = users.id)
													LEFT JOIN horses ON (horses.id = comp_riders.hid)
													LEFT JOIN clubs ON (clubs.id = users.cid)
													WHERE
													comp_riders.rid = ?i ORDER BY ordering
													", $height['id']);
        ++$row_number;
        foreach ($results as $rider) {
            $new_sheet->insertNewRowBefore($row_number, 1);
            $new_sheet->setCellValueByColumnAndRow(1, $row_number, $rider["ordering"]);
            $new_sheet->setCellValueByColumnAndRow(2, $row_number, $rider["fname"].' '.$rider['lname']);
            $new_sheet->setCellValueByColumnAndRow(3, $row_number, $ranks[$rider["rank"]]);
            $new_sheet->setCellValueByColumnAndRow(4, $row_number, $rider["horse"]);
            $new_sheet->setCellValueByColumnAndRow(5, $row_number, $rider["club"]);
            ++$row_number;
        }
    }

    $new_sheet->removeRow(8, 1);
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

