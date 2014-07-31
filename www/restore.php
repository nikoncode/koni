<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (LIBRARIES_DIR . "password_compat/password.php");

/* Logic part of 'restore' page */

/* If step2 */
$restored = false;
if (isset($_GET["mail"], $_GET["code"])) {
	/* Checking restore code */
	$db = new db;
	$id = $db->getOne("SELECT id FROM users WHERE mail = ?s AND restore = ?s", $_GET["mail"], $_GET["code"]);
	if ($id !== false) {
		/* Generate and update password */
		$new_password = others_generate_code(8);
		$password = password_hash($new_password, PASSWORD_DEFAULT);
		$db->query("UPDATE users SET restore = '', password = ?s WHERE id = ?i", $password, $id);
        $headers  = 'Content-type: text/plain; charset=utf-8';
	    mail($_GET["mail"], "Odnokonniki", " 
	    	Здравствуйте.
			Ваш пароль успешно изменен. Данные для входа расположены ниже:
			Логин: {$_GET["mail"]}
			Пароль: {$new_password}
			Ссылка для входа: http://odnokonniki.ru/login.php?login={$_GET["mail"]}
			После входа вы сможете сменить пароль на другой.
		",$headers);
	}
	$restored = true;
}

$assigned_vars = array(
	"page_title"	=> "Восстановление пароля > Одноконники",
	"restored"		=> $restored
);
template_render($assigned_vars, "restore.tpl");