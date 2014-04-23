<?php
/* Auth api function */

/* Including functional dependencies */
include_once (LIBRARIES_DIR . "password_compat/password.php");
include_once (CORE_DIR . "core_includes/others.php");

function api_register() {
	validate_fields($fields, $_POST, array(
			"site",
			"work"
		), array(
			"login",
			"passwd1",
			"passwd2",
			"fname",
			"lname",
			"mname",
			"bday",
			"bmounth",
			"byear",
			"country",
			"city",
			"mail",
			"phone",
			"adress",
			"accept"
		), array(
			"login" 	=> "login",
			"passwd1" 	=> "pass",
			"phone" 	=> "phone",
			"mail" 		=> "email",
			"site" 		=> "url"
		), 
	$errors);

	if ($fields["passwd1"] != $fields["passwd2"])
		$errors[] = "Пароли не совпадают.";

	$db = new db;
	$check_uniq = $db->getOne("SELECT id FROM users WHERE mail=?s OR login=?s", $fields["mail"], $fields["login"]);
	if ($check_uniq !== false) {
		$errors[] = "Пользователь с таким логином или почтой уже зарегистрирован.";
	}


	if (!checkdate($fields["bmounth"], $fields["bday"], $fields["byear"])) {
		$errors[] = "Дата рождения неверна.";
	}

	if (!empty($errors))
		aerr($errors); 

	unset($fields["accept"]);

	$fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
	unset($fields["passwd1"]); 
	unset($fields["passwd2"]);	

	$fields["bdate"] = (int)$fields["byear"] . "-" . (int)$fields["bmounth"] . "-" . (int)$fields["bday"];
	unset($fields["byear"]); 
	unset($fields["bmounth"]);	
	unset($fields["bday"]); 	

	if (isset($fields["work"])){
		$fields["work"] = implode(", ", $fields["work"]);
	}

	$fields["hash"] = generate_code(5);

	$db = new db;
	$db->query("INSERT INTO users (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);

    mail($fields["mail"], "Odnokonniki", " 
		Спасибо за регистрацию.
		Логин: {$fields["login"]}
		Код подтверждения: {$fields["hash"]}
		Ссылка для подтверждения: http://odnokonniki.ru/sms.php?login={$fields["login"]}
	");

	aok("Пользователь успешно зарегистрирован. На вашу почту отправлено письмо, код с которого нужно будет указать далее.", "/sms.php?login={$fields["login"]}");
}

function api_sms_validate() {
	validate_fields($fields, $_POST, array(), array(
			"login",
			"code"
		), array(), $errors);

	if (!empty($errors))
		aerr($errors);

	$db = new db;
	$code = $db->getOne("SELECT hash FROM users WHERE login=?s AND hash=?s", $fields["login"], $fields["code"]);

	if ($code === false) {
		aerr(array("Подтвержение регистрации невозможно. Проверьте введенные данные."));
	} else {
		$db->query("UPDATE users SET hash='' WHERE login=?s", $fields["login"]);
		aok(array("Регистрация подтверждена. Сейчас вас перенаправит на страницу входа. Спасибо."), "/login.php?login={$fields["login"]}");
	}
}
