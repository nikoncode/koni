<?php
/* photo upload */

/* Including functional dependencies */
include_once (LIBRARIES_DIR . "simple_image/SimpleImage.php");

function gallery_upload_photo($photo, $name, $destname, $w=500, $h=500, $preview=false, $pname=NULL) { //TO-DO: MAKE CONFIG
	$avaible_types = array('png' => 'image/png', 'gif' => 'image/gif', 'jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg');
	if((!empty($photo[$name])) && ($photo[$name]['error'] == 0)) {
		$filename = basename($photo[$name]['name']);
		$temp = explode(".", $filename);
		$ext = strtolower($temp[count($temp)-1]);
		if (isset($avaible_types[$ext]) && ($avaible_types[$ext]==strtolower($photo[$name]["type"])) && ($photo[$name]["size"] < 300000000) && getimagesize($photo[$name]['tmp_name'])) {
			$img = new \abeautifulsite\SimpleImage($photo[$name]['tmp_name']);
			$newname = UPLOADS_DIR . $destname;
			$prev_name = UPLOADS_DIR . $pname;
			$img->best_fit($w,$h)->save($newname);
			if ($preview) {
				$img->best_fit(190, 130)->save($prev_name);
			}
			return true;        
		} else { 
			return array("Для загрузки достуны файлы ТОЛЬКО размером не более 3Mb и расширениями ".implode(", ", array_keys($avaible_types)));
		}
	} else { 
		return array("Файл не был отправлен.");
	}
}

function gallery_upload_file($photo, $name, $destname) { //TO-DO: MAKE CONFIG
	$avaible_types = array(
        'doc' => 'application/msword',
        'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'pdf' => 'application/pdf',
        'xls' => 'application/vnd.ms-excel',
        'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
	if((!empty($photo[$name])) && ($photo[$name]['error'] == 0)) {
		$filename = basename($photo[$name]['name']);
		$temp = explode(".", $filename);
		$ext = strtolower($temp[count($temp)-1]);
		if (isset($avaible_types[$ext]) && ($avaible_types[$ext]==strtolower($photo[$name]["type"])) && ($photo[$name]["size"] < 3100000000)) {
			$newname = UPLOADS_DIR . $destname.'.'.$ext;
            move_uploaded_file($photo[$name]['tmp_name'],$newname);
			return array('filename' => $photo[$name]['name'],'file'=>$newname,'ext' => $ext);
		} else {
			return array("Для загрузки достуны файлы ТОЛЬКО размером не более 30Mb и расширениями ".implode(", ", array_keys($avaible_types)));
		}
	} else {
		return array("Файл не был отправлен.");
	}
}