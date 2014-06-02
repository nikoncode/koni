<?php
/* Logic part of 'user' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");

$tmpl = new templater;
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	if (empty($_GET["id"]) || $_SESSION["user_id"] == $_GET["id"]) {
		header("location: /inner.php");
		exit();
	}
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
	$assigned_vars["page_title"] = $assigned_vars["another_user"]["fio"]." > Одноконники";
	$db = new db;
	$assigned_vars["photos"] = $db->getCol("SELECT preview FROM gallery_photos WHERE o_uid = ?i ORDER BY time DESC LIMIT 3", $assigned_vars["another_user"]["id"]);
	$assigned_vars["news"] = news_wall_build(array($_GET["id"]), 0, 5);
	template_render($assigned_vars, "user.tpl");
}



