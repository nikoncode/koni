<?php
/*
* This is main configuration file.
*/

include ("../core/config.php");
include (CORE_DIR . "core_includes/validate.php");

$arr = array(
	"first" => "",
	"sub" => array(
		"sub_one" => "",
		"sub_two" => "sd"
	),
	"new" => "salos"
);

print_r(validate_fields($arr, array("first", "sub"), array("new"), array("new" => "login"), $err));
print_r($err);

