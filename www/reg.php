<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "constant.php");

/* Logic part of 'reg' page */
$assigned_vars = array(
	"page_title" 		=> "Регистрация > Одноконники",
	"const_mounth" 		=> $const_mounth,
	"const_work" 		=> $const_work,
	"const_rank" 		=> $const_rank,
	"const_countries" 	=> $const_countries
);
template_render($assigned_vars, "registration.tpl");