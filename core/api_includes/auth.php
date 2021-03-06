<?php
/* Including functional dependencies */
include_once (LIBRARIES_DIR . "password_compat/password.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/session.php");

function api_auth_register() {
	/* Validate data */
	validate_fields($fields, $_POST, array(
			"site",
            "mname",
            "rank",
			"work"
		), array(
			"login|Ваш логин",
			"passwd1|Ваш пароль",
			"passwd2|Подтверждение пароля",
			"fname|Имя",
			"lname|Фамилия",

			"bday|День рождения",
			"bmounth|Месяц рождения",
			"byear|Год рождения",
			"country|Страна",
			"city|Город",
			"mail|E-mail",
			"phone|Телефон",
			"adress|Улица, дом",
			"accept|Я согласен с условиями портала"
		), array(
			"login|Ваш логин" 	=> "login",
			"passwd1|Ваш пароль" 	=> "pass",
			"phone|Телефон" 	=> "phone",
			"mail|E-mail" 		=> "email",
			"site|Ваш сайт" 		=> "url"
		), 
	$errors, false);

	/* Checking equality passwords */
	if ($fields["passwd1"] != $fields["passwd2"]) {
		$errors[] = "Пароли не совпадают.";
	}



	/* Checking uniqueness Login & password pair */
	$db = new db;

    $country = $db->getRow("SELECT country_name_ru FROM country_ WHERE id=?i", $fields["country"]);
    $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", $fields["city"]);
    if(!isset($country['country_name_ru'])){
        $errors[] = "Не выбрана страна.";
    }else{
        $fields['country'] = $country['country_name_ru'];
    }
    if(!isset($city['city_name_ru'])){
        $errors[] = "Не выбран город.";
    }else{
        $fields['city'] = $city['city_name_ru'];
    }
	$check_uniq = $db->getOne("SELECT id FROM users WHERE mail=?s OR login=?s", $fields["mail"], $fields["login"]);
	if ($check_uniq !== false) {
		$errors[] = "Пользователь с таким логином или почтой уже зарегистрирован.";
	}

	/* Checking user birthdate */
	if (!checkdate($fields["bmounth"], $fields["bday"], $fields["byear"])) {
		$errors[] = "Дата рождения неверна.";
	}

	if (!empty($errors)) {
		aerr($errors); 
	}

	unset($fields["accept"]);

	/* Hashing password */
	$fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
	unset($fields["passwd1"]); 
	unset($fields["passwd2"]);	

	/* Making MYSQL dbate */
	$fields["bdate"] = (int)$fields["byear"] . "-" . (int)$fields["bmounth"] . "-" . (int)$fields["bday"];
	unset($fields["byear"]); 
	unset($fields["bmounth"]);	
	unset($fields["bday"]); 	

	/* Making MYSQL work set */
	if (isset($fields["work"])){
		$fields["work"] = implode(",", $fields["work"]);
	}

	/* Making verify code */
	$fields["hash"] = others_generate_code(5);

	/* Insert to db */
	$db->query("INSERT INTO users (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);

	/* Mail client details to user */
    $headers  = 'Content-type: text/plain; charset=utf-8';
    mail($fields["mail"], "Odnokonniki", "
    	Здравствуйте. 
		Спасибо за регистрацию.
		Логин: {$fields["login"]}
		Код подтверждения: {$fields["hash"]}
		Ссылка для подтверждения: http://odnokonniki.ru/sms.php?login={$fields["login"]}
	",$headers);

	aok(array("Пользователь успешно зарегистрирован. На вашу почту отправлено письмо, код с которого нужно будет указать далее."), "/sms.php?login={$fields["login"]}");
}

function api_auth_register_admin() {
    /* Validate data */
    validate_fields($fields, $_POST, array(
            "mname",
            "cid",
            "rank",
            "city",
            "work",
		"h_bplace","h_byear","h_rost","h_pasport","h_nick","h_sex",
		"h_poroda",
		"h_mast"
        ), array(
            "fname|Имя",
            "lname|Фамилия",

            "bday|День рождения",
            "bmounth|Месяц рождения",
            "byear|Год рождения",
            "country|Страна",

            "phone|Телефон",
        ), array(
        ),
        $errors, false);

    /* Checking uniqueness Login & password pair */
    $db = new db;

    $country = $db->getRow("SELECT country_name_ru FROM country_ WHERE id=?i", $fields["country"]);

    if(!isset($country['country_name_ru'])){
        $errors[] = "Не выбрана страна.";
    }else{
        $fields['country'] = $country['country_name_ru'];
    }
    if(isset($fields["city"])){
        $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", $fields["city"]);
        if(!isset($city['city_name_ru'])){
            //$errors[] = "Не выбран город.";
        }else{
            $fields['city'] = $city['city_name_ru'];
        }
    }

    $fields['login'] = time();
    $fields['mail'] = $fields['login'].'@odnokonniki.ru';
    $fields["passwd1"] = '1111111q';
    $check_uniq = $db->getOne("SELECT id FROM users WHERE mail=?s OR login=?s", $fields["mail"], $fields["login"]);
    if ($check_uniq !== false) {
        $errors[] = "Пользователь с таким логином или почтой уже зарегистрирован.";
    }

    /* Checking user birthdate */
    if (!checkdate($fields["bmounth"], $fields["bday"], $fields["byear"])) {
        $errors[] = "Дата рождения неверна.";
    }

    if (!empty($errors)) {
        aerr($errors);
    }

    unset($fields["accept"]);

    /* Hashing password */
    $fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
    unset($fields["passwd1"]);
    unset($fields["passwd2"]);

    /* Making MYSQL dbate */
    $fields["bdate"] = (int)$fields["byear"] . "-" . (int)$fields["bmounth"] . "-" . (int)$fields["bday"];
    unset($fields["byear"]);
    unset($fields["bmounth"]);
    unset($fields["bday"]);

    /* Making MYSQL work set */
    if (isset($fields["work"])){
        $fields["work"] = implode(",", $fields["work"]);
    }

    /* Making verify code */
    $fields["hash"] = others_generate_code(5);
    $fields["hand"] = 1;
	$fields_horse = $fields;
	foreach($fields as $key=>$val){
		if(substr_count($key,'h_')) unset($fields[$key]);
	}
    /* Insert to db */
    $db->query("INSERT INTO users (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
	$insert_id = $db->insertId();
	if(isset($fields_horse['h_nick'])){
		foreach($fields_horse['h_nick'] as $key=>$val){
			$ins = array(
				"o_uid" => $insert_id,
				"nick" => $val,
				"bplace" => $fields_horse["h_bplace"][$key],
				"byear" => $fields_horse["h_byear"][$key],
				"rost" => $fields_horse["h_rost"][$key],
				"pasport" => $fields_horse["h_pasport"][$key],
				"sex" => $fields_horse["h_sex"][$key],
				"poroda" => $fields_horse["h_poroda"][$key],
				"mast" => $fields_horse["h_mast"][$key]
			);
			$db->query("INSERT INTO horses (`" . implode("`, `", array_keys($ins)) . "`) VALUES (?a);", $ins);
		}

	}
    aok($insert_id);
}

function api_add_user_owner(){
    validate_fields($fields, $_POST, array(), array(
        "fname|Имя",
        "lname|Фамилия",
        "country|Страна",
        "city|Страна"
    ), array(
    ),
        $errors, false);
    $db = new db;
    $fields['login'] = time();
    $fields['mail'] = $fields['login'].'@odnokonniki.ru';
    $fields["passwd1"] = '1111111q';
    $fields["hand"] = '1';
    $fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
    $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", $fields["city"]);
    if(!isset($city['city_name_ru'])){
        $errors[] = "Не выбран город.";
    }else{
        $fields['city'] = $city['city_name_ru'];
    }
    if (!empty($errors)) {
        aerr($errors);
    }
    unset($fields["passwd1"]);
    $db->query("INSERT INTO users (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
    $insert_id = $db->insertId();
    aok($insert_id);
}

function api_auth_get_city(){
    validate_fields($fields, $_POST, array("city"), array(
        "country_id",
    ), array(), $errors, false);
    $db = new db;
	if(intval($fields['country_id']) > 0){
		$cities = $db->getAll("SELECT id,city_name_ru
                                                FROM city_
                                                WHERE id_country = ?i
                                                ORDER BY oid",$fields['country_id']);
	}else{
		$cities = $db->getAll("SELECT city_.id,city_.city_name_ru
                                                FROM city_, country_
                                                WHERE city_.id_country = country_.id AND country_.country_name_ru = ?s
                                                ORDER BY city_.oid",$fields['country_id']);
	}

    $city = '';
    foreach($cities as $row){
        $selected = (isset($fields['city']) && $row['city_name_ru'] == $fields['city'])?'selected="selected"':'';
        $city .= '<option value="'.$row['id'].'" '.$selected.'>'.$row['city_name_ru'].'</option>';
    }
    aok($city, "");
}

function api_auth_check_login(){
    validate_fields($fields, $_POST, array(), array(
        "login",
    ), array(), $errors, false);
    $db = new db;
    $check_uniq = $db->getOne("SELECT id FROM users WHERE login=?s", $fields["login"]);
    if ($check_uniq !== false) {
        aerr(array("Пользователь с таким логином уже зарегистрирован."));
    }else{
        aok(array("Логин свободен."));
    }
}

function api_auth_sms_resend(){
    validate_fields($fields, $_POST, array(), array(
        "login",
    ), array(), $errors, false);
    $db = new db;
    $hash = $db->getRow("SELECT hash,mail FROM users WHERE login=?s", $fields["login"]);
    $headers  = 'Content-type: text/plain; charset=utf-8';
    if ($hash['hash'] != '') {
        mail($hash["mail"], "Odnokonniki", "
    	Здравствуйте.
		Спасибо за регистрацию.
		Логин: {$fields["login"]}
		Код подтверждения: {$hash['hash']}
		Ссылка для подтверждения: http://odnokonniki.ru/sms.php?login={$fields["login"]}
	",$headers);
        aok(array("Повторное письмо с кодом отправлено."));
    }else{
        $errors[] = "Пользователь с таким логином не найден.";
    }
    if (!empty($errors)) {
        aerr($errors);
    }

}

function api_auth_sms_validate() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array(
			"login",
			"code"
		), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking code from db */
	$db = new db;
	$code = $db->getOne("SELECT hash FROM users WHERE login=?s AND hash=?s", $fields["login"], $fields["code"]);
	if ($code === false) {
		aerr(array("Подтвержение регистрации невозможно. Проверьте введенные данные."));
	} else {
		$db->query("UPDATE users SET hash='' WHERE login=?s", $fields["login"]);
		aok(array("Регистрация подтверждена. Сейчас вас перенаправит на страницу входа. Спасибо."), "/login.php?login={$fields["login"]}");
	}
}

function api_auth_login() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array(
			"login",
			"pass"
		), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Calculate login or email entered */
	if (validate_email($fields["login"])) {
		$field_name = "mail";
	} else {
		$field_name = "login";
	}

	/* Getting client details of entered user */
	$db = new db;
	$details = $db->getRow("SELECT id, password, hash, blocked,hand FROM users WHERE ?n = ?s", $field_name, $fields["login"]);

	/* Check and auth */
    if($details['blocked'] > 0){
        aerr(array("Ваш аккаунт заблокирован"));
    }elseif (password_verify($fields["pass"], $details["password"]) && strlen($details["hash"]) != 5) {
		session_auth($details["id"]);
        if($details['hand'] > 0){
            $db->query("UPDATE users SET hand = 0 WHERE id = ?i",$details['id']);
            $db->query("DELETE FROM support WHERE user_id = ?i",$details['id']);
        }
		aok(array("Вход осуществлен успешно."), "/inner.php");
	} else {
		aerr(array("Данные неверны или пользователь не зарегистрирован (не верифицирован)."));
	}
}

function api_auth_logout() {
	session_logout();
	aok(array("Все хорошо."), "/login.php");
}

function api_auth_pass_restore() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array("mail"), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors); 
	}

	/* Generate and send verification code */
	$db = new db;
	$code = md5(time() . others_generate_code(5));
	$id = $db->getOne("SELECT id FROM users WHERE mail=?s", $fields["mail"]);
	if ($id !== false) {
		$db->query("UPDATE users SET restore = ?s WHERE id = ?s", $code, $id);
        $headers  = 'Content-type: text/plain; charset=utf-8';
	    mail($fields["mail"], "Odnokonniki", " 
	    	Здравствуйте.
			На вашем аккаунте была заказана смена пароля.
			Для подтверждения смены пароля, пройдите по ссылке: http://odnokonniki.ru/restore.php?mail={$fields["mail"]}&code={$code}
			Если вы этого не делали, просто проигнорируйте это письмо.
		",$headers);
	}
	aok(array("Если такой пользователь существует, то ему выслано письмо с подтверждением."));
}


function api_auth_user_change() {
	/* Validate data */
    validate_fields($fields, $_POST, array(
            "site",
            "user_id",
            "mname",
            "work",
            "passwd1",
            "rank",
            "adress",
            "passwd2"
        ), array(
            "fname|Имя",
            "lname|Фамилия",
            "bday|День рождения",
            "bmounth|Месяц рождения",
            "byear|Год рождения",
            "country|Страна",
            "city|Город",
            "mail|E-mail",
            "phone|Телефон",
        ), array(
            "login|Ваш логин" 	=> "login",
            "passwd1|Ваш пароль" 	=> "pass",
            "phone|Телефон" 	=> "phone",
            "mail|E-mail" 		=> "email",
            "site|Ваш сайт" 		=> "url"
        ),
        $errors);
	/* Checking equality passwords */
	if (isset($fields["passwd1"]) && isset($fields["passwd2"]) && $fields["passwd1"] != $fields["passwd2"]) {
		$errors[] = "Пароли не совпадают.";
	}

	/* Checking user birthdate */
	if (!checkdate($fields["bmounth"], $fields["bday"], $fields["byear"])) {
		$errors[] = "Дата рождения неверна.";
	}

	/* Hashing password */
	if (isset($fields["passwd1"]) && isset($fields["passwd2"])) {
		$fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
	}
	unset($fields["passwd1"]); 
	unset($fields["passwd2"]);	

	/* Making MYSQL dbate */
	$fields["bdate"] = (int)$fields["byear"] . "-" . (int)$fields["bmounth"] . "-" . (int)$fields["bday"];
	unset($fields["byear"]); 
	unset($fields["bmounth"]);	
	unset($fields["bday"]); 	

	/* Making MYSQL work set */
	if (isset($fields["work"])){
		$fields["work"] = implode(",", $fields["work"]);
	}

	/* Insert to db */
	$db = new db;
    $country = $db->getRow("SELECT country_name_ru FROM country_ WHERE id=?i", $fields["country"]);
    $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", $fields["city"]);
    if(!isset($country['country_name_ru'])){
        $errors[] = "Не выбрана страна.";
    }else{
        $fields['country'] = $country['country_name_ru'];
    }
    if(!isset($city['city_name_ru'])){
        $errors[] = "Не выбран город.";
    }else{
        $fields['city'] = $city['city_name_ru'];
    }
    if (!empty($errors)) {
        aerr($errors);
    }
    if(!isset($fields['rank'])) $fields['rank'] = 0;
    if (isset($fields['user_id']) && $fields['user_id'] > 0) {
        $user_id = $fields['user_id'];
        unset($fields['user_id']);
        $user = template_get_short_user_info($_SESSION["user_id"]);
        if($user['admin'] == 0) {
            $errors[] = "Нет доступа.";
            aerr($errors);
        }else{
            $db->query("UPDATE users SET ?u WHERE id = ?i", $fields, $user_id);
        }
    }else{
        $db->query("UPDATE users SET ?u WHERE id = ?i", $fields, $_SESSION["user_id"]);
    }

	/* Mail client details to user */

	aok(array("Данные изменены"));
}