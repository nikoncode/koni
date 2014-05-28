<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "/constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'profile' page */
if (!session_check()) {
		template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$db = new db;
	$assigned_vars["u"] = $db->getRow("SELECT * FROM users WHERE id = ?i", $_SESSION["user_id"]);
	$temp = explode("-", $assigned_vars["u"]["bdate"]);
	unset($assigned_vars["u"]["bdate"]);
	$assigned_vars["u"]["byear"] = $temp[0];
	$assigned_vars["u"]["bmounth"] = $temp[1];
	$assigned_vars["u"]["bday"] = $temp[2];
	$assigned_vars["mounths"] = $const_mounth;
	$assigned_vars["countries"] = $const_countries;
	$temp = array_flip($const_work);
	$works = explode(",", $assigned_vars["u"]["work"]);
	unset($assigned_vars["u"]["work"]);
	foreach ($works as $work) {
		$temp[$work] = "checked";
	}
	$assigned_vars["u"]["profs"] = $temp;
	template_render($assigned_vars, "profile.tpl");
}
