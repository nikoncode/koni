<?php
/* Logic part of 'find-users' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once (CORE_DIR . "constant.php");
session_check();
$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["page_title"] = "Поиск пользователей > Одноконники";
	$assigned_vars["works"] = $const_work;
	$assigned_vars["countries"] = $const_countries_old;
	$assigned_vars["search"] = $_POST['search'];
	template_render($assigned_vars, "find-users.tpl");



