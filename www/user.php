<?php
/* Logic part of 'user' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");

$tmpl = new templater;
session_check();
if (empty($_GET["id"]) || $_SESSION["user_id"] == $_GET["id"]) {
	header("location: /inner.php");
	exit();
}
$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
if ($assigned_vars["another_user"] == NULL) {
	template_render_error("Пользователь с таким идентификатором не найден, мы сожалеем.");
}

$assigned_vars["page_title"] = $assigned_vars["another_user"]["fio"]." > Одноконники";
$db = new db;
$assigned_vars["photos"] = $db->getAll("SELECT preview, id FROM gallery_photos WHERE o_uid = ?i ORDER BY time DESC LIMIT 3", $assigned_vars["another_user"]["id"]);
foreach ($assigned_vars["photos"] as $ph) {
	$ids[] = $ph["id"];
}
$assigned_vars["photos_ids"] = implode(",", $ids);
$assigned_vars["news"] = news_wall_build("user", $assigned_vars["another_user"]["id"], 0, 5);
$assigned_vars["url"] = $_SERVER['REQUEST_URI'];
template_render($assigned_vars, "user.tpl");