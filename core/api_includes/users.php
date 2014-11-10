<?php

function api_user_find() {
	validate_fields($fields, $_POST, array(
		"q",
		"age1",
		"age2",
		"country",
		"city",
		"club",
		"work"
	), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new sphinx;
	$conditions = "";
	if (isset($fields["q"])) {
		$conditions .= "@fio \"" . $db->parse("?w", $fields["q"]) . "\" ";
	}

	if (isset($fields["country"])) {
		$conditions .= "@country \"" . $db->parse("?w", $fields["country"]) . "\" ";
	}

	if (isset($fields["club"])) {
		$conditions .= "@club \"" . $db->parse("?w", $fields["club"]) . "\" ";
	}

	if (isset($fields["city"])) {
		$conditions .= "@city \"" . $db->parse("?w", $fields["city"]) . "\" ";
	}

	if (isset($fields["work"])) {
		$temp = implode(", ", $fields["work"]);
		$conditions .= "@work " . $db->parse("?w", $temp);
	}

	if (empty($fields["age1"])) {
		$fields["age1"] = 0;
	}

	if (empty($fields["age2"])) {
		$fields["age2"] = 99999999;
	}

	$ages = $db->parse("age BETWEEN ?i AND ?i", $fields["age1"], $fields["age2"]);
	$ids = $db->getCol("SELECT id FROM users_index WHERE MATCH('?p') AND ?p", $conditions, $ages);
	$db = new db;
	$users = $db->getAll("SELECT 	CONCAT(fname,' ',lname) as fio,
									id,
									avatar,
									country,
									city,
									(SELECT name FROM clubs WHERE id = users.cid) as club,
									cid,
									(SELECT count(id) FROM `friends` WHERE uid = ?i AND fid = users.id) as is_friends
						FROM users
						WHERE id IN (?a)", $_SESSION["user_id"], $ids);
	$rendered = template_render_to_var(array(
		"finded_users" => $users
	), "iterations/users_find_results.tpl");
	aok($rendered);
}

function api_user_horse_find() {
    validate_fields($fields, $_POST, array(
        "q"
    ), array(), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }

    $db = new sphinx;
    $conditions = "";
    if (isset($fields["q"])) {
        $conditions .= "@fio \"" . $db->parse("?w", $fields["q"]) . "\" ";
    }
    $ids = $db->getCol("SELECT id FROM users_index WHERE MATCH('?p')", $conditions);
    $db = new db;
    $users = $db->getAll("SELECT 	CONCAT(fname,' ',lname) as fio,
									id,
									avatar,
									country,
									city,
									(SELECT name FROM clubs WHERE id = users.cid) as club,
									cid,
									(SELECT count(id) FROM `friends` WHERE uid = ?i AND fid = users.id) as is_friends
						FROM users
						WHERE id IN (?a)", $_SESSION["user_id"], $ids);
    $rendered = template_render_to_var(array(
        "finded_users" => $users
    ), "iterations/users_horse_search.tpl");
    aok($rendered);
}

function api_check_notice() {
    validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }

    $db = new db;
    $db->query("UPDATE notice SET status = 1 WHERE id = ?i AND o_uid = ?i;", $fields['id'], $_SESSION["user_id"]);
    aok(array("Уведомление отмечено как прочитанное."));
}

function api_add_notice($o_uid,$sender_id,$message,$type) {
    $db = new db;
    $db->query("INSERT INTO notice (`o_uid`, `message`, `sender_id`, `type`, `time`) VALUES (?i, ?s, ?i, ?s, ?s);",
        $o_uid,
        $message,
        $sender_id,
        $type,
        date('Y-m-d H:i:s')
    );
}

function api_unread_events() {
    validate_fields($fields, $_POST, array(
        "q"
    ), array(), array(), $errors);
    $db = new db;
    $notices = $db->getAll("SELECT n.*, u.avatar, c.avatar as avatarClub, CONCAT(u.fname, ' ', u.lname) as fio, c.name as clubName, u.id as user_id, c.id as club_id
	                                FROM notice as n
	                                LEFT JOIN users as u ON (u.id = n.sender_id)
	                                LEFT JOIN clubs as c ON (c.id = n.sender_id)
	                                WHERE n.o_uid = ?i AND n.status = 0", $_SESSION["user_id"]);
    /* render it */

    $notice = template_render_to_var(array('notice'=>$notices),"iterations/notice-events.tpl");
    aok($notice);
}
function api_unread_msgs() {
    validate_fields($fields, $_POST, array(
        "q"
    ), array(), array(), $errors);
    $db = new db;
    $messages = $db->getAll("SELECT m.*, u.avatar, CONCAT(u.fname, ' ', u.lname) as fio, u.id as user_id
	                                FROM messages as m
	                                INNER JOIN users as u ON (u.id = m.uid)
	                                WHERE m.fid = ?i AND m.status = 0 GROUP BY m.uid ORDER BY m.time DESC ", $_SESSION["user_id"]);
    /* render it */

    $message = template_render_to_var(array('messages'=>$messages),"iterations/msg-rows.tpl");
    aok($message);
}

function api_get_user_club(){
    validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }

    $db = new db;
    $user = $db->GetRow("SELECT
								cid as club_id,
								(SELECT name FROM clubs WHERE id = club_id) as club_name
								 FROM users WHERE id = ?i", $fields['id']);
    aok($user);
}

