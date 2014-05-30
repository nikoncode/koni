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