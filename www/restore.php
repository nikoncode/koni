<?php
/* Logic part of 'restore' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/others.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (LIBRARIES_DIR . "password_compat/password.php");

/* If step2 */
$restored = false;
if (isset($_GET["mail"], $_GET["code"])) {
	$db = new db;
	$id = $db->getOne("SELECT id FROM users WHERE mail = ?s AND restore = ?s", $_GET["mail"], $_GET["code"]);
	if ($id !== false) {
		$new_password = generate_code(8);
		$password = password_hash($new_password, PASSWORD_DEFAULT);
		$db->query("UPDATE users SET restore = '', password = ?s WHERE id = ?i", $password, $id);
	    mail($_GET["mail"], "Odnokonniki", " 
	    	Здравствуйте.
			Ваш пароль успешно изменен. Данные для входа расположены ниже:
			Логин: {$_GET["mail"]}
			Пароль: {$new_password}
			Ссылка для входа: http://odnokonniki.ru/login.php?login={$_GET["mail"]}
			После входа вы сможете сменить пароль на другой.
		");
	}
	$restored = true;
}

$tmpl = new templater;
$tmpl->assign("page_title", "Восстановление пароля > Одноконники");
$tmpl->assign("restored", $restored);
$tmpl->display("restore.tpl");