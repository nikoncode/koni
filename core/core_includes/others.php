<?php
/* Others core unclassifiable function */

function others_generate_code($length) {
	$base = md5(time());
	return substr($base, -$length);
}

function others_delete_file($file_name) {
	if (file_exists($file_name)) {
		unlink($file_name);
	}
}

function others_make_photo_array($photos, $photo_ids) {
	if ($photos != NULL && $photo_ids != NULL) {
		$photos = explode(",", $photos);
		$photo_ids = explode(",", $photo_ids);
		$new_photos = array();
		foreach ($photo_ids as $key => $value) {
			$new_photos[$value] = $photos[$key];
		}
		return $new_photos;
	} else {
		return NULL;
	}
}

function others_data_format($data, $sep1, $sep2) {
	$data = explode($sep1, $data);
	return implode($sep2, array_reverse($data));	
}

function others_competitions_get($id) {
	$db = new db;
	$comp = $db->getAll("SELECT *, DATEDIFF(bdate, NOW()) as diff FROM comp WHERE o_cid = ?i", $id);
	$competitions = array();
	$competitions["soon"]["diff"] = 9999999999;
	foreach($comp as $c) {
		if ((int)$c["diff"] > 30) {
			$competitions["future"][] = $c;
		} else if ((int)$c["diff"] < 0) {
			$c["diff"] = abs($c["diff"]);
			$competitions["past"][] = $c;
		} else {
			$competitions["coming"][] = $c; 
		}
		if ($c["diff"] >= 0 && $c["diff"] < $competitions["soon"]["diff"]) {
			$competitions["soon"] = $c;
		}
	}
	return $competitions;
}