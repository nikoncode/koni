<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (CORE_DIR . "/constant.php");

/* Logic part of 'club-admin' page */
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$db = new db;
	$assigned_vars["const_countries"] = $const_countries_old;
	$assigned_vars["const_types"] = $const_horses_spec;
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //fix
	$assigned_vars["comp"] = $db->getRow("SELECT *, (SELECT o_uid FROM clubs WHERE id = comp.o_cid) as perm FROM comp WHERE id = ?i", $_GET["id"]);
	if ($assigned_vars["comp"] == NULL || $assigned_vars["comp"]["perm"] != $_SESSION["user_id"]) {
		template_render_error("Вы не можете редактировать это соревнование, простите.");	
	}
	$assigned_vars["page_title"] = "Редактирование соревнования '" . $assigned_vars["comp"]["name"] . "' > Одноконники";
	$assigned_vars["comp"]["bdate"] = others_data_format($assigned_vars["comp"]["bdate"], "-", ".");
	$assigned_vars["comp"]["edate"] = others_data_format($assigned_vars["comp"]["edate"], "-", ".");

	$assigned_vars["comp"]["routes"] = $db->getAll("SELECT * FROM routes WHERE cid = ?i", $_GET["id"]);

	foreach ($assigned_vars["comp"]["routes"] as &$route) {
		$route["options"] = unserialize($route["options"]);
	}
	if (empty($assigned_vars["comp"]["results"])) {
		$temp = $db->getAll("SELECT routes.id,
								routes.name,
								CONCAT(fname,' ',lname) AS fio,
								CONCAT(horses.nick,', ',horses.sex,', ',horses.mast) as horse
						FROM routes
						LEFT JOIN comp_riders 
							ON routes.id = comp_riders.rid
						LEFT JOIN users 
							ON comp_riders.uid = users.id
						LEFT JOIN horses 
							ON comp_riders.hid = horses.id
						WHERE routes.cid = ?i", $assigned_vars["comp"]["id"]);
		$results = array();
		foreach ($temp as $element) {
			$results[$element["id"]][] = $element;
		}
		$assigned_vars["comp"]["results"] = $results;
	} else {
		$assigned_vars["comp"]["results"] = unserialize($assigned_vars["comp"]["results"]);
	}
	template_render($assigned_vars, "competition-edit.tpl");
}
