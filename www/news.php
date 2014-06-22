<?php
/* Logic part of 'news' page */
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
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["page_title"] = $assigned_vars["user"]["fio"]." > Одноконники";
	$db = new db;
	$assigned_vars["news"] = news_wall_build("feed", $assigned_vars["user"]["id"], 0, 5);
	template_render($assigned_vars, "news.tpl");
}



