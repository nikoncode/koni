<?php

function api_horses_add() {
	/* validate data */
	validate_fields($fields, $_POST, array("user_id","bplace", "parent", "pname", "about", "rost", "spec","name", "lname","pasport","admin_user_id"),  array("nick",
		"sex",
		"poroda",
		"mast",
		"byear",
		"avatar"), array(), $errors); 

	if (!empty($errors)) {
		aerr($errors);
	}
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if(isset($fields['admin_user_id']) && $fields['admin_user_id'] > 0 && $user['admin'] > 0){
        $user_id = $fields['admin_user_id'];
    }else{
        $user_id = $_SESSION["user_id"];
    }
    unset($fields['admin_user_id']);
	/* make parrent */
	if (isset($fields["pname"], $fields["parent"])) {
		$fields["parents"] = array();
		foreach ($fields["parent"] as $key => $value) {
			$fields["parents"][$fields["pname"][$key]] = $value;
		}
		$fields["parents"] = json_encode($fields["parents"]);
	}
	unset($fields["parent"]);
	unset($fields["pname"]);
	$fields["o_uid"] = (isset($fields['user_id']) && $fields['user_id'] > 0)?$fields['user_id']:$user_id;
    $fields['owner'] = $fields['lname'].' '.$fields['name'];
    unset($fields["user_id"]);
    unset($fields["lname"]);
    unset($fields["name"]);
	/* insert to db */
	$db = new db;
	$db->query("INSERT INTO albums (name, o_uid, att) VALUES (?s, ?i, 1)", $fields["nick"], $fields["o_uid"]);
	$fields["album_id"] = $db->getOne("SELECT LAST_INSERT_ID() FROM albums");
	$db->query("INSERT INTO horses (`" . implode("`, `", array_keys($fields)) . "`) VALUES (?a);", $fields);

    if($fields['o_uid'] != $user_id){
        $horse_id = $db->insertId();
        $db->query("DELETE FROM horses_to_users WHERE hid = ?i AND uid = ?i;", $horse_id,$user_id);
        $db->query("INSERT INTO horses_to_users (hid,uid) VALUES (?i,?i);", $horse_id,$user_id);
    }
	aok(array("Конь добавлен C:"));
}

function api_horses_add_admin() {
    /* validate data */
    validate_fields($fields, $_POST, array("bplace","byear","rost","pasport"),  array("nick","o_uid","sex",
        "poroda",
        "mast"), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }
    /* insert to db */
    $db = new db;
    $db->query("INSERT INTO horses (`" . implode("`, `", array_keys($fields)) . "`) VALUES (?a);", $fields);
    aok($db->insertId());
}

function api_horse_owner_add() {
	/* validate data */
	validate_fields($fields, $_POST, array("admin_user_id"),  array("horse"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if(isset($fields['admin_user_id']) && $fields['admin_user_id'] > 0 && $user['admin'] > 0){
        $user_id = $fields['admin_user_id'];
    }else{
        $user_id = $_SESSION["user_id"];
    }
    unset($fields['admin_user_id']);
	/* insert to db */
	$db = new db;
	$db->query("DELETE FROM horses_to_users WHERE hid = ?i AND uid = ?i;", $fields['horse'],$user_id);
	$db->query("INSERT INTO horses_to_users (hid,uid) VALUES (?i,?i);", $fields['horse'],$user_id);
	aok(array("Конь добавлен C:"));
}

function api_horses_edit() {
	/* validate data */
	validate_fields($fields, $_POST, array("bplace", "parent", "pname", "about", "rost", "spec","admin_user_id"),  array("nick",
		"sex",
		"poroda",
		"mast",
		"byear", 
		"avatar",
		"hid"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$id = $fields["hid"];
	unset($fields["hid"]);
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if(isset($fields['admin_user_id']) && $fields['admin_user_id'] > 0 && $user['admin'] > 0){
        $user_id = $fields['admin_user_id'];
    }else{
        $user_id = $_SESSION["user_id"];
    }
    unset($fields['admin_user_id']);
	/* make parrent */
	if (isset($fields["pname"], $fields["parent"])) {
		$fields["parents"] = array();
		foreach ($fields["parent"] as $key => $value) {
			$fields["parents"][$fields["pname"][$key]] = $value;
		}
		$fields["parents"] = json_encode($fields["parents"]);
	}
	unset($fields["parent"]);
	unset($fields["pname"]);
	$fields["o_uid"] = $user_id;

	/* insert to db */
	$db = new db;
	$db->query("UPDATE horses SET ?u WHERE id = ?i AND o_uid = ?i", $fields, $id, $user_id);
	$album_id = $db->getOne("SELECT album_id FROM horses WHERE id = ?i", $id);
	$db->query("UPDATE albums SET name = ?s WHERE id = ?i AND o_uid = ?i", $fields["nick"], $album_id, $user_id);
	aok(array("Конь изменен C:"));
}

function api_horses_info() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	/* get horse info */
	$info = $db->getRow("SELECT * FROM horses WHERE id = ?i;", $fields["id"]);
	if ($info === NULL) {
		aerr(array("Не найдено."));
	} else {
		aok($info);
	}
}

function api_horses_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array("uid"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if(isset($fields['uid']) && $fields['uid'] > 0 && $user['admin'] > 0){
        $user_id = $fields['uid'];
    }else{
        $user_id = $_SESSION["user_id"];
    }
	/* delete horse */
	$db = new db;
	$db->query("DELETE FROM horses WHERE id = ?i AND o_uid = ?i", $fields["id"], $user_id);
	aok(array("Лошадь удалена"));	
}

function api_horses_user_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array("uid"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if(isset($fields['uid']) && $fields['uid'] > 0 && $user['admin'] > 0){
        $user_id = $fields['uid'];
    }else{
        $user_id = $_SESSION["user_id"];
    }
	/* delete horse */
	$db = new db;
	$db->query("DELETE FROM horses_to_users WHERE hid = ?i AND uid = ?i", $fields["id"], $user_id);
	aok(array("Лошадь удалена"));
}

function api_user_horses() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	/* find user horses */
	$db = new db;
    $horses = $db->getAll("SELECT * FROM horses WHERE o_uid = ?i", $fields["id"]);
    $rendered = template_render_to_var(array(
        "finded_horses" => $horses
    ), "iterations/select_options.tpl");
    aok($rendered);
}
