<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'friends' page */
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$assigned_vars["page_title"] = "Лошади '" . $assigned_vars["user"]["fio"]  . "' > Одноконники";
	$user_id = $assigned_vars["user"]["id"];
	if (!empty($_GET["id"]) && $_GET["id"] != $user_id) {
		$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
		if ($assigned_vars["another_user"] == NULL) {
			template_render_error("Такого пользователя не существует. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
		} else {
			$user_id = $assigned_vars["another_user"]["id"];
			$assigned_vars["page_title"] = "Лошади '" . $assigned_vars["another_user"]["fio"]  . "' > Одноконники";
		}
	}

	$db = new db;
	$assigned_vars["friends"]  = $db->getAll("SELECT 	users.id,
														avatar,
														CONCAT(fname,' ',lname) as fio
											FROM friends, users 
											WHERE users.id = fid 
											AND uid = ?i", $user_id);
	template_render($assigned_vars, "friends.tpl");
}