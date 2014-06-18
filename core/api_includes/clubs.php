<?php

function api_club_edit1() {
	validate_fields($fields, $_POST, array(
		"city",
		"address",
		"site",
		"email",
		"phones",
		"p_desc",
		"coords"
	), array(
		"id",
		"name",
		"type",
		"country"
	), array(
		"site" => "url",
		"email" => "email"
	), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (isset($fields["coords"])) {
		$fields["coords"] = implode(", ", $fields["coords"]);
	}

	if (isset($fields["phones"]) && isset($fields["p_desc"])) {
		$phones = array();
		foreach ($fields["p_desc"] as $key => $value) {
			$phones[$value] = $fields["phones"][$key];
		}
		$fields["c_phones"] = serialize($phones);
	}
	unset($fields["phones"]); unset($fields["p_desc"]);

	$db = new db;
	$db->query("UPDATE clubs SET ?u WHERE o_uid = ?i AND id = ?i", $fields, $_SESSION["user_id"], $fields["id"]);
	aok(array("Данные обновлены."));

}

function api_club_edit2() {
	validate_fields($fields, $_POST, array(
		"desc",
		"sdesc",
		"ability",
		"opt"
	), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	if (isset($fields["ability"])) {
		$fields["ability"] = implode(", ", $fields["ability"]);
	}

	if (isset($fields["opt"])) {
		$fields["additions"] = json_encode($fields["opt"]);
	}
	unset($fields["opt"]);
	$db->query("UPDATE clubs SET ?u WHERE id = ?i AND o_uid = ?i", $fields, $fields["id"], $_SESSION["user_id"]);
	aok(array("Данные изменены.")); //check
}

function api_club_user_permission() {
	validate_fields($fields, $_POST, array("desc"), array("id", "type"), array(), $errors);

	if (!empty($errors)) {
		err($errors);
	}

	$fields["is_moderator"] = 0;
	$fields["is_club_staff"] = 0;
	$fields["club_staff_descr"] = 0;

	if ($fields["type"] == "moderator") {
		$fields["is_moderator"] = 1;
	} else if ($fields["type"] == "staff") {
		$fields["is_club_staff"] = 1;
		if (isset($fields["desc"])) {
			$fields["club_staff_descr"] = $fields["desc"];
		} 
	} 
	unset($fields["desc"]);
	unset($fields["type"]);
	$db = new db;
	$db->query("UPDATE users SET ?u WHERE id = ?i", $fields, $fields["id"]);
	aok(array("Обновлено."));
}

function api_club_membership() {
	validate_fields($fields, $_POST, array(), array("id", "act"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$id = $db->getOne("SELECT id FROM clubs WHERE id = ?i");
	if ($id === NULL) {
		aerr(array("Такого клуба не существует"));
	}
	/* delete from club & reset preferences */
	$query = array(
		"is_moderator" => 0,
		"is_club_staff" => 0,
		"club_staff_descr" => "",
		"cid" => 0
	);
	if ($fields["act"] == "enter") {
		$query["cid"] = $fields["id"];
	}
	$db->query("UPDATE users SET ?u WHERE id = ?i", $_SESSION["user_id"]);
	aok(array("Успех"));
}

function api_club_adv() {
	//garbage collections
	validate_fields($fields, $_POST, array("adv_img", "adv_link"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}


	$adv = array();
	if (isset($fields["adv_img"]) && isset($fields["adv_link"])) {
		foreach ($fields["adv_img"] as $key => $value) {
			$adv[] = array(
				"img" => $fields["adv_img"][$key],
				"url" => $fields["adv_link"][$key]
			);
		}
	}
	$db = new db;
	$db->query("UPDATE clubs SET adv = ?s WHERE id = ?i AND o_uid = ?i", json_encode($adv), $fields["id"], $_SESSION["user_id"]);
	aok(array("Баннеры обновлены."));
}