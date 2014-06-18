<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (CORE_DIR . "/constant.php");

/* Logic part of 'club-admin' page */
if (!session_check()) {
		template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	if (empty($_GET["id"])) {

		template_render_error("Клуб не найден.");
	}
	$db = new db;
	$assigned_vars["club"] = $db->getRow("SELECT * FROM clubs WHERE id = ?i", $_GET["id"]); 
	
	if ($assigned_vars["club"]["o_uid"] != $_SESSION["user_id"]) {
		template_render_error("Вы не можете редактировать этот клуб.");
	}

	$assigned_vars["countries"] = $const_countries_old;
	$assigned_vars["club"]["c_phones"] = unserialize($assigned_vars["club"]["c_phones"]);
	$assigned_vars["club"]["adv"] = json_decode($assigned_vars["club"]["adv"], 1);
	$assigned_vars["club"]["ability"] = explode(", ", $assigned_vars["club"]["ability"]);
	$assigned_vars["club"]["coords"] = explode(", ", $assigned_vars["club"]["coords"]);
	$comp = $db->getAll("SELECT *, DATEDIFF(bdate, NOW()) as diff FROM comp WHERE o_cid = ?i", $_GET["id"]);
	$competitions = array();
	foreach($comp as $c) {
		if ((int)$c["diff"] > 30) {
			$competitions["future"][] = $c;
		} else if ((int)$c["diff"] < 0) {
			$c["diff"] = abs($c["diff"]);
			$competitions["past"][] = $c;
		} else {
			$competitions["coming"][] = $c; 
		}
	}
	$assigned_vars["club"]["competitions"] = $competitions; 
	$assigned_vars["abilities"]  = $const_ability;
	$assigned_vars["types"] = $const_club_type;
	$assigned_vars["members"] = $db->getAll("SELECT *, CONCAT(fname,' ',lname) as fio FROM users WHERE cid = ?i", $_GET["id"]);
	//print_r($assigned_vars);
	template_render($assigned_vars, "club-admin.tpl");
}
