<?php
/* Others core unclassifiable function */

function others_generate_code($length) {
	$base = md5(time());
	return substr($base, -$length);
}