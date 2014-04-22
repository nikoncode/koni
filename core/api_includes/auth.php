<?php
/* Auth api function */

function api_register() {
	$fields = validate_fields($_POST, array(
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
}
