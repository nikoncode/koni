<?php

function api_friends_add() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$db->query("DELETE FROM friends WHERE uid = ?i AND fid = ?i;", $_SESSION["user_id"], $fields["id"]); // to exclude dublicates
	$db->query("INSERT INTO friends (uid, fid) VALUES (?i, ?i);", $_SESSION["user_id"],  $fields["id"]);
    $message = 'Добавил вас в друзья';
    api_add_notice($fields["id"],$_SESSION['user_id'],$message,'user');
	aok(array("Друг добавлен успешно."));
}

function api_friends_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$db->query("DELETE FROM friends WHERE uid = ?i AND fid = ?i;", $_SESSION["user_id"],  $fields["id"]);
	aok(array("Друг удален успешно."));
}