<?php
/* template functions file */

/* Including functional dependencies */
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");

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
}

function template_render_to_var($vars, $template_name) {
	$tmpl = new templater;
	foreach ($vars as $key => $value) {
		$tmpl->assign($key, $value);
	}
	return $tmpl->fetch($template_name);
}