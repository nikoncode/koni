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
	), array(), array(), $errors,false);

	if (!empty($errors)) {
		aerr($errors);
	}
    session_check();
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
		"finded_users" => $users,
        "show_right" => 1,
	), "iterations/users_find_results.tpl");
	aok($rendered);
}

function api_user_find_reg() {
    validate_fields($fields, $_POST, array(
        "q",
        "city",
    ), array(), array(), $errors,false);

    if (!empty($errors)) {
        aerr($errors);
    }

    $db = new sphinx;
    $conditions = "";
    if (isset($fields["q"])) {
        $conditions .= "@fio \"" . $db->parse("?w", $fields["q"]) . "\" ";
    }

    if (isset($fields["city"])) {
        $conditions .= "@city \"" . $db->parse("?w", $fields["city"]) . "\" ";
    }


    $ids = $db->getCol("SELECT id FROM users_index WHERE MATCH('?p')", $conditions);
    $db = new db;
    $users = $db->getAll("SELECT 	CONCAT(fname,' ',lname) as fio,
									id,
									avatar,
									country,
									city,
									(SELECT name FROM clubs WHERE id = users.cid) as club,
									cid
						FROM users
						WHERE id IN (?a) AND hand = 1",  $ids);
    $rendered = template_render_to_var(array(
        "finded_users" => $users,
        "show_right" => 0,
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
								(SELECT name FROM clubs WHERE id = club_id) as club_name,
								rank
								 FROM users WHERE id = ?i", $fields['id']);
    aok($user);
}

function api_send_support(){
	validate_fields($fields, $_POST, array(
		"phone",
		"name",
		"lname",
		"url",
		"city",
		"user_id",
	), array("email|E-mail","message|Текст сообщения"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $db = new db;
    $fields['dt'] = time();
    $db->query("INSERT INTO support (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
	$headers  = 'Content-type: text/plain; charset=utf-8';
	mail("nostrag@gmail.com", "Запрос в службу поддержки", "
	    	Имя:".$fields['name']."
	    	Фамилия:".$fields['lname']."
	    	Телефон:".$fields['phone']."
	    	E-Mail:".$fields['email']."
	    	Текст сообщения:".$fields['message']."
	    	Сраница, с которой был отправлен запрос:".$_SERVER['SERVER_NAME'].$fields['url']."
	    	IP отправителя:".$_SERVER['REMOTE_ADDR']."
		",$headers);
	aok(array("Сообщение отправлено"));
}

function api_send_access(){
	validate_fields($fields, $_POST, array(), array("id","status"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $db = new db;
    $db->query("UPDATE support SET status = ?i WHERE id = ?i", $fields['status'],$fields['id']);
    if($fields['status'] == 1){
        $row = $db->getRow("SELECT * FROM support WHERE id = ?i",$fields['id']);
        $rand = 'pass'.rand(100000,90000000);
        $pass = password_hash($rand, PASSWORD_DEFAULT);
        $db->query("UPDATE users SET mail = ?s, password = ?s, hash = '' WHERE id = ?i",$row['email'],$pass,$row['user_id']);
        $headers  = 'Content-type: text/plain; charset=utf-8';
        mail($row['email'], "Предоставление доступа > Odnokonniki.ru", "
	    	Ваш логин для входа:".$row['email']."
	    	Ваш пароль для входа:".$rand,$headers);
        aok("Доступы отправлены");
    }else{
        aok("В доступе было отказано");
    }


}

function api_find_users(){
	validate_fields($fields, $_POST, array(), array("q"), array(), $errors);
	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	$q = explode(" ",$fields['q']);
	if(count($q) > 1){
		$users = $db->getAll("SELECT id, CONCAT(fname,' ',lname,', ', city,', ',DATE_FORMAT(bdate,'%d.%m.%Y')) as fio FROM users WHERE ((fname = '".$q[0]."' AND lname LIKE '".$q[1]."%') OR (lname = '".$q[0]."' AND fname LIKE '".$q[1]."%')) AND `work` LIKE '%Спортсмен%'");
	}else{
		$users = $db->getAll("SELECT id, CONCAT(fname,' ',lname,', ', city,', ',DATE_FORMAT(bdate,'%d.%m.%Y')) as fio FROM users WHERE (lname LIKE '".$q[0]."%' OR fname LIKE '".$q[0]."%') AND `work` LIKE '%Спортсмен%'");
	}

	$results = array();
	foreach($users as $user){
		$results[] = array('id' => $user['id'], 'text' => $user['fio']);
	}
	echo json_encode(array('q' => $fields['q'], 'results' => $results));
}

function api_get_user_profile(){
    validate_fields($fields, $_POST, array(), array("id"), array(), $errors);
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if($user['admin'] == 0){
        $errors[] = 'Нет доступа';
    }
    if (!empty($errors)) {
        aerr($errors);
    }
    $db = new db;
    /* user */
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
    $assigned_vars["page_title"] = "Редактирование данных > Одноконники";
    $assigned_vars["u"] = $db->getRow("SELECT * FROM users WHERE id = ?i", $fields['id']);
    $temp = explode("-", $assigned_vars["u"]["bdate"]);
    unset($assigned_vars["u"]["bdate"]);
    $assigned_vars["u"]["byear"] = $temp[0];
    $assigned_vars["u"]["bmounth"] = $temp[1];
    $assigned_vars["u"]["bday"] = $temp[2];
    $assigned_vars["mounths"] = $GLOBALS['const_mounth'];
    $assigned_vars["countries"] = $GLOBALS['const_countries'];
    $assigned_vars["const_rank"] = $GLOBALS['const_rank'];
    $temp = array_flip($GLOBALS['const_work']);
    $works = explode(",", $assigned_vars["u"]["work"]);
    unset($assigned_vars["u"]["work"]);
    foreach ($works as $work) {
        $temp[$work] = "checked";
    }
    $assigned_vars["u"]["profs"] = $temp;
    $profile = template_render_to_var($assigned_vars, "iterations/user_prifile.tpl");
    unset($assigned_vars);
    /* horses */
    $assigned_vars["horses"] = $db->getAll("SELECT id,
													avatar,
													nick,
													sex,
													byear,
													spec,
													(YEAR(NOW()) - byear) as age,
													o_uid
											FROM horses
											WHERE o_uid = ?i", $fields['id']);
    $assigned_vars["horses_owners"] = $db->getAll("SELECT h.id,
													h.avatar,
													h.nick,
													h.sex,
													h.byear,
													h.spec,
													(YEAR(NOW()) - h.byear) as age,
													htu.uid AS o_uid
											FROM horses as h,horses_to_users as htu
											WHERE h.id=htu.hid AND htu.uid = ?i", $fields['id']);

    $assigned_vars["const_horses_sex"] = $GLOBALS['const_horses_sex'];
    $assigned_vars["const_horses_poroda"] = $GLOBALS['const_horses_poroda'];
    $assigned_vars["const_horses_mast"] = $GLOBALS['const_horses_mast'];
    $assigned_vars["const_horses_spec"] = $GLOBALS['const_horses_spec'];
    $horses = template_render_to_var($assigned_vars, "iterations/user_horses.tpl");
    unset($assigned_vars);
    $albums = $db->getAll("SELECT 	gp.id,
													a.name,
													a.desc,
													gp.preview,
													gp.album_id
											FROM albums AS a,gallery_photos AS gp  WHERE a.id = gp.album_id AND a.o_uid = ?i AND a.att = 0", $fields['id']);
    $ids = array();
    foreach($albums as $album){
        $assigned_vars["albums"][$album['album_id']]['name'] = $album['name'];
        $assigned_vars["albums"][$album['album_id']]['photos'][] = $album;
        $ids[] = $album["id"];
    }

    $assigned_vars["photos_ids_list"] = implode(",", $ids);
    $photos = template_render_to_var($assigned_vars, "iterations/user_photos.tpl");
    aok(array('profile' => $profile,'horses' => $horses, 'photos' => $photos));
}

function api_user_blocked(){
    validate_fields($fields, $_POST, array(), array("id","blocked"), array(), $errors);
    $user = template_get_short_user_info($_SESSION["user_id"]);
    if($user['admin'] == 0){
        $errors[] = 'Нет доступа';
    }
    if (!empty($errors)) {
        aerr($errors);
    }
    $db = new db;
    $db->query("UPDATE users SET blocked = ?i WHERE id = ?i",$fields['blocked'],$fields['id']);
    aok(array('ок'));
}

