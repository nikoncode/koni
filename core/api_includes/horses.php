<?php

function api_horses_add() {
	/* validate data */
	validate_fields($fields, $_POST, array("bplace", "parent", "pname", "about", "rost", "spec"),  array("nick",
		"sex",
		"poroda",
		"mast",
		"byear", 
		"avatar"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

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
	$fields["o_uid"] = $_SESSION["user_id"];

	/* insert to db */
	$db = new db;
	$db->query("INSERT INTO horses (`" . implode("`, `", array_keys($fields)) . "`) VALUES (?a);", $fields);
	aok(array("Конь добавлен C:"));
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
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* delete horse */
	$db = new db;
	$db->query("DELETE FROM horses WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	aok(array("Лошадь удалена"));	
}