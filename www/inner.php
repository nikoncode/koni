<?php
/* Logic part of 'inner' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");

$tmpl = new templater;
if (!session_check()) {
	$tmpl->assign("page_title", "Ошибка > Одноконники");
	$tmpl->assign("error_text", "К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
	$tmpl->display("error.tpl");
} else {
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["page_title"] = $assigned_vars["user"]["fio"]." > Одноконники";
	$assigned_vars["news"] = news_wall_build("user", $_SESSION["user_id"], 0, 5);
	template_render($assigned_vars, "inner.tpl");
}



