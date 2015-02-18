<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "constant.php");
session_check();
$assigned_vars = array(
	"page_title" 		=> "Клубы > Одноконники",
	"abilities" 		=> $const_ability,
	"types" 			=> $const_horses_spec,
	"countries" 		=> $const_countries,
	"metros" 		=> $const_metro,
	"user"				=> template_get_short_user_info($_SESSION["user_id"])
);
template_render($assigned_vars, "clubs.tpl");
