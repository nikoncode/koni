<?php
/* Logic part of 'find-users' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once (CORE_DIR . "constant.php");

if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["page_title"] = "Поиск пользователей > Одноконники";
	$assigned_vars["works"] = $const_work;
	$assigned_vars["countries"] = $const_countries_old;
	template_render($assigned_vars, "find-users.tpl");
}



