<?php
/* Others core unclassifiable function */

function generate_code($length) {
	$base = md5(time());
	return substr($base, -$length);
}