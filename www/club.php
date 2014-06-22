<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

$tmpl = new templater;
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	if (!isset($_GET["id"])) {
		template_render_error("Такого клуба нет. Простите.");
	} else {
		$db = new db;
		$assigned_vars["club"] = $db->getRow("SELECT * FROM clubs WHERE id = ?i", $_GET["id"]);
		if ($assigned_vars["club"] == NULL) {
			template_render_error("Такого клуба нет. Простите.");
		} else {
			$assigned_vars["club"]["phones"] = unserialize($assigned_vars["club"]["c_phones"]);
			$assigned_vars["club"]["additions"] = json_decode($assigned_vars["club"]["additions"], 1);
			if ($assigned_vars["club"]["ability"] == "") {
				$assigned_vars["club"]["ability"] = array("Возможности не указаны.");
			} else {
				$assigned_vars["club"]["ability"] = explode(", ", $assigned_vars["club"]["ability"]);
			}
			$assigned_vars["club"]["staff"] = $db->getAll("SELECT concat(fname,' ',lname) as fio, avatar,id, club_staff_descr, phone, mail FROM users WHERE cid = ?i AND is_club_staff = 1", $assigned_vars["club"]["id"]); 
			$assigned_vars["club"]["members"] = $db->getAll("SELECT concat(fname,' ',lname) as fio, avatar,id FROM users WHERE cid = ?i LIMIT 6", $assigned_vars["club"]["id"]);
			$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
			$assigned_vars["news"] = news_wall_build("club", $assigned_vars["club"]["id"], 0, 5);
			$assigned_vars["club"]["competitions"] = others_competitions_get($assigned_vars["club"]["id"]);
			template_render($assigned_vars, "club.tpl");
		}
	}
	
}



