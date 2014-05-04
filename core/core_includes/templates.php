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
								(SELECT name FROM CLUBS WHERE id = club_id) as club_name,
								DATEDIFF(NOW(), bdate) as age,
								country,
								city,
								id FROM users WHERE id = ?i", $id);

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