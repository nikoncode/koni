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
	$min_diff = 999999999;
	foreach($comp as $c) {
		if ($c["diff"] >= 0 && $c["diff"] < $min_diff) {
			$competitions["soon"] = $c;
			$min_diff = $c["diff"];
		}
		if ((int)$c["diff"] > 30) {
			$competitions["future"][] = $c;
		} else if ((int)$c["diff"] < 0) {
			$c["diff"] = abs($c["diff"]);
			$competitions["past"][] = $c;
		} else {
			$competitions["coming"][] = $c; 
		}
	}
	return $competitions;
}

function others_results_position_sort($a, $b) {
	if ($a["pos"] == $b["pos"]) {
		return 0;
	}
	return ($a["pos"] < $b["pos"]) ? -1 : 1;
}

function others_club_make_rating($info) {
	if ($info == NULL) return NULL;
	$stats = array();
	$stats["notes"]["all"] = $info["REVIEWS_CNT"];
	$stats["notes"]["avg"] = $info["SCORE"];
	$stats["notes"]["stars"] = round($stats["notes"]["avg"]);
	$stats["notes"]["5"] = $info["CNT_FIVE"];
	$stats["notes"]["4"] = $info["CNT_FOUR"];
	$stats["notes"]["3"] = $info["CNT_THREE"];
	$stats["notes"]["2"] = $info["CNT_TWO"];
	$stats["notes"]["1"] = $stats["notes"]["all"] - $stats["notes"]["5"] - $stats["notes"]["4"] - $stats["notes"]["3"] - $stats["notes"]["2"];
	$stats["percent"]["5"] = ($stats["notes"]["5"] / $stats["notes"]["all"]) * 100;
	$stats["percent"]["4"] = ($stats["notes"]["4"] / $stats["notes"]["all"]) * 100;
	$stats["percent"]["3"] = ($stats["notes"]["3"] / $stats["notes"]["all"]) * 100;
	$stats["percent"]["2"] = ($stats["notes"]["2"] / $stats["notes"]["all"]) * 100;
	$stats["percent"]["1"] = ($stats["notes"]["1"] / $stats["notes"]["all"]) * 100;
	return $stats;
}

function others_club_adv_choose($adv) {
	$adv = json_decode($adv, 1);
	$adv_num = rand(0, count($adv) - 1);
	return $adv[$adv_num];
}