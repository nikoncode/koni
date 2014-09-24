<?php
/* template functions file */

/* Including functional dependencies */
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");
include_once (CORE_DIR . "core_includes/others.php");

function template_get_user_info($id) {
	$db = new db;
	$user = $db->GetRow("SELECT CONCAT(fname, ' ', lname) as fio, 
								avatar,
								work,
								cid as club_id,
								(SELECT name FROM clubs WHERE id = club_id) as club_name,
								DATEDIFF(NOW(), bdate) as age,
								country,
								city,
								(SELECT count(id) FROM `friends` WHERE uid = ?i AND fid = users.id) as is_friends,
								id FROM users WHERE id = ?i", $_SESSION["user_id"], $id);

	if ($user === NULL) 
		return $user;
	
	/* Making profs array */
	if (!empty($user["work"])) {
		$user["profs"] = explode(",", $user["work"]);
			unset($user["work"]);
	}

	/* Making info */
	$user["age"] = (int)($user["age"] / 365);
	$user["info"] = $user["age"] . " лет, " . implode(", ", array($user["country"], "г. " . $user["city"]));
	unset($user["age"]);
	unset($user["country"]);
	unset($user["city"]);

	$user["friends"] = $db->getAll("SELECT users.id, 
											CONCAT(fname,' ',lname) as fio, 
											avatar 
									FROM users, friends 
									WHERE users.id = friends.fid 
									AND friends.uid = ?i LIMIT 6", $id);

	$user["horses_bar"] = $db->getAll("SELECT * FROM horses WHERE o_uid = ?i LIMIT 2", $id); //BOOM
	$user["notice"] = $db->getAll("SELECT n.*, u.avatar, c.avatar as avatarClub, CONCAT(u.fname, ' ', u.lname) as fio, c.name as clubName, u.id as user_id, c.id as club_id
	                                FROM notice as n
	                                LEFT JOIN users as u ON (u.id = n.sender_id)
	                                LEFT JOIN clubs as c ON (c.id = n.sender_id)
	                                WHERE n.o_uid = ?i AND n.status = 0", $id);
    $user["notice_count"] = count($user["notice"]);
    $user["messages"] = $db->getAll("SELECT m.*, u.avatar, CONCAT(u.fname, ' ', u.lname) as fio, u.id as user_id
	                                FROM messages as m
	                                INNER JOIN users as u ON (u.id = m.uid)
	                                WHERE m.fid = ?i AND m.status = 0 GROUP BY m.uid ORDER BY m.time DESC ", $id);
    $user["messages_count"] = count($user["messages"]);
	$user["competitions"] = $db->getAll("SELECT id,
										       name, 
										       bdate, 
										       Datediff(bdate, Now()) AS diff 
										FROM   comp 
										WHERE  id IN (SELECT cid 
										              FROM   ((SELECT cid 
										                       FROM   comp_riders, 
										                              routes 
										                       WHERE  comp_riders.uid = ?i 
										                              AND comp_riders.rid = routes.id) 
										                      UNION 
										                      (SELECT cid 
										                       FROM   comp_members 
										                       WHERE  uid = ?i)) ids) 
										HAVING diff >= 0
										ORDER BY bdate", $id, $id); //BOOM x2
	if ($user["competitions"]){
		foreach ($user["competitions"] as &$comp) {
			$comp["bdate"] = others_data_format($comp["bdate"], "-", ".");
			$comp["date"] = explode(".", $comp["bdate"]);
		}
	}

	return $user;
}

function template_get_short_user_info($id) {
	$db = new db;
	$user = $db->GetRow("SELECT CONCAT(fname, ' ', lname) as fio, 
								avatar,
								cid as club_id,
								(SELECT name FROM clubs WHERE id = club_id) as club_name,
								DATEDIFF(NOW(), bdate) as age,
								id FROM users WHERE id = ?i", $id);
	return $user;
}

function template_render($vars, $template_name) {
	$tmpl = new templater;
	foreach ($vars as $key => $value) {
		$tmpl->assign($key, $value);
	}
	$tmpl->display($template_name);
}

function template_render_error($text) { //TO-DO: make errors constant
	$variables = array(
		"page_title" => "Ошибка > Одноконники",
		"error_text" => $text
	);
	template_render($variables, "error.tpl");	
	exit(); //hook
}

function template_render_to_var($vars, $template_name) {
	$tmpl = new templater;
	foreach ($vars as $key => $value) {
		$tmpl->assign($key, $value);
	}
	return $tmpl->fetch($template_name);
}