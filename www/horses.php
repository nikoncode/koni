<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "/constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'horses' page */
session_check();
$assigned_vars = array();
$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
$assigned_vars["page_title"] = "Лошади '" . $assigned_vars["user"]["fio"]  . "' > Одноконники";
$user_id = $assigned_vars["user"]["id"];
if (!empty($_GET["id"]) && $user_id != $_GET["id"]) {
	$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
	if ($assigned_vars["another_user"] === NULL) {
		template_render_error("Такого пользователя не существует. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
	} else {
		$user_id = $assigned_vars["another_user"]["id"];
		$assigned_vars["page_title"] = "Лошади '" . $assigned_vars["another_user"]["fio"]  . "' > Одноконники";
	}
}
$db = new db;
$assigned_vars["horses"] = $db->getAll("SELECT id,
													avatar,
													nick,
													sex,
													byear,
													spec,
													(YEAR(NOW()) - byear) as age
											FROM horses
											WHERE o_uid = ?i", $user_id);
$assigned_vars["horses_owners"] = $db->getAll("SELECT h.id,
													h.avatar,
													h.nick,
													h.sex,
													h.byear,
													h.spec,
													(YEAR(NOW()) - h.byear) as age
											FROM horses as h,horses_to_users as htu
											WHERE h.id=htu.hid AND htu.uid = ?i", $user_id);

$assigned_vars["const_horses_sex"] = $const_horses_sex;
$assigned_vars["const_horses_poroda"] = $const_horses_poroda;
$assigned_vars["const_horses_mast"] = $const_horses_mast;
$assigned_vars["const_horses_spec"] = $const_horses_spec;
template_render($assigned_vars, "horses.tpl");