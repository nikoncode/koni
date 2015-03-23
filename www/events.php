<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "/constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
session_check();
/* Logic part of 'profile' page */
$assigned_vars = array(
    "page_title" 		=> "Мероприятия > Одноконники",
);
$ip = $_SERVER['REMOTE_ADDR'];
$assigned_vars["my_country"] = tabgeo_country_v4($ip);
$assigned_vars["const_types"] = $const_horses_spec;
$assigned_vars["const_countries"] = $const_countries;
$db = new db;
$assigned_vars["clubs"] = $db->getAll('SELECT name FROM clubs ORDER BY name');
$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
template_render($assigned_vars, "events.tpl");
