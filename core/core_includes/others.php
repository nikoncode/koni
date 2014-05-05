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