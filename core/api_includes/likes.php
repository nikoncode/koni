<?php

function api_like_add() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("type", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* like to news or comment? */
	if ($fields["type"] == "n") {
		$key = "nid";
	} else if ($fields["type"] == "c") {
		$key = "cid";
	} else {
		aerr(array("Неизвестный тип."));
	}

	/* insert to db */
	$db = new db;
	$db->query("DELETE FROM likes WHERE o_uid = ?i AND ?p = ?i", $_SESSION["user_id"], $key, $fields["id"]); //exclude dublicate
	$db->query("INSERT INTO likes (?p, o_uid) VALUES (?i, ?i);", $key, $fields["id"], $_SESSION["user_id"]);
	$new_count = $db->getOne("SELECT COUNT(id) FROM likes WHERE ?p = ?i", $key, $fields["id"]); //new likes count
	aok(array("new_count" => $new_count));
}

function api_like_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("type", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* like to news or comment? */
	if ($fields["type"] == "n") {
		$key = "nid";
	} else if ($fields["type"] == "c") {
		$key = "cid";
	} else {
		aerr(array("Неизвестный тип."));
	}

	/* likes to news or comment? */
	$db = new db;
	$db->query("DELETE FROM likes WHERE o_uid = ?i AND ?p = ?i", $_SESSION["user_id"], $key, $fields["id"]);
	$new_count = $db->getOne("SELECT COUNT(id) FROM likes WHERE ?p = ?i", $key, $fields["id"]);
	aok(array("new_count" => $new_count));
}