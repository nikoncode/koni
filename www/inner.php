<?php
/* Logic part of 'inner' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

$tmpl = new templater;
if (!check()) {
	$tmpl->assign("page_title", "Ошибка > Одноконники");
	$tmpl->assign("error_text", "К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
	$tmpl->display("error.tpl");

} else {
	$db = new db;
	$user = $db->GetRow("SELECT CONCAT(fname, ' ', lname) as fio, 
								avatar,
								work,
								cid as club_id,
								(SELECT name FROM CLUBS WHERE id = club_id) as club_name,
								DATEDIFF(NOW(), bdate) as age,
								country,
								city FROM users WHERE id = ?i", $_SESSION["user_id"]);
	
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

	/* render */
	$tmpl->assign("page_title", $user["fio"]." > Одноконники");
	$tmpl->assign("user", $user);
	$tmpl->display("inner.tpl");
}



