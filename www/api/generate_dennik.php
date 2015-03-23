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
$routes = $db->getAll("SELECT id FROM routes WHERE cid = ?i", $cid);

/* building */
$xlsReader = new PHPExcel_Reader_Excel5();
$xlsTemplate = $xlsReader->load(PROJECT_DIR . "additions/dennik_template.xls");
$temp_sheet = $xlsTemplate->getSheet(0);
$remove = false;
foreach ($routes as $route) {
    $heights = $db->getAll("SELECT h.nick,h.poroda,h.sex, h.byear, u.lname, u.fname, u.phone,cr.dennik FROM routes_heights AS rh
                            INNER JOIN comp_riders AS cr ON (cr.rid = rh.id)
                            INNER JOIN users AS u ON (u.id = cr.uid)
                            INNER JOIN horses AS h ON (h.id = cr.hid)
                            WHERE cr.dennik > 0 AND rh.route_id = ?i", $route['id']);
    foreach($heights as $height){
        $remove = true;
        $new_sheet = clone $temp_sheet;
        $new_sheet->setCellValue('C7', $height['nick']);
        $new_sheet->setCellValue('C13', $height['byear'].'г.р.,  '.$height['poroda'].',  '.$height['sex']);
        $new_sheet->setCellValue('C18', $height['lname'].' '.$height['fname']);
        $new_sheet->setCellValue('C23', $height['phone']);
        $new_sheet->setTitle(mb_substr($height["nick"],0,30));
        $xlsTemplate->addSheet($new_sheet);
    }


}

if($remove) $xlsTemplate->removeSheetByIndex(0);

/* modifying header */
header('Content-Type: application/vnd.ms-excel');
header('Content-Disposition: attachment;filename="Список резерваций.xls"');
header('Cache-Control: max-age=0');

/* move to download */
$xlsWriter = new PHPExcel_Writer_Excel5($xlsTemplate);
$xlsWriter->save( "php://output" );

