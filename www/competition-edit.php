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
    $assigned_vars["files"] = $db->getAll("SELECT * FROM comp_files WHERE cid = ?i", $_GET["id"]);
	foreach ($assigned_vars["comp"]["routes"] as &$route) {
		$route["options"] = unserialize($route["options"]);
        $assigned_vars["comp"]["startlist"][$route['id']] = $db->getAll("SELECT 	users.id,
															CONCAT(fname, ' ', lname) as fio,
															horses.nick as horse,
															horses.id as horse_id,
															horses.owner,
															clubs.name as club,
															clubs.id as club_id,
															(SELECT CONCAT(fname, ' ', lname) as fio FROM users WHERE id = horses.o_uid) as ownerName,
															comp_riders.id as ride_id,
															comp_riders.ordering
													FROM comp_riders, users, horses, clubs
													WHERE
													comp_riders.uid = users.id AND horses.id = comp_riders.hid AND clubs.id = users.cid AND comp_riders.rid = ?i ORDER BY ordering
													", $route['id']);
	}
    $temp = $db->getAll("SELECT routes.id as route_id,
								routes.name,
								clubs.name as club,
								comp_results.*
						FROM routes
						LEFT JOIN comp_results
							ON comp_results.rid = routes.id
						LEFT JOIN users
							ON comp_results.user_id = users.id
						LEFT JOIN horses
							ON comp_results.horse = horses.id
						LEFT JOIN clubs
							ON comp_results.club_id = clubs.id
						WHERE routes.cid = ?i ORDER BY comp_results.disq, comp_results.rank", $assigned_vars["comp"]["id"]);
    $results = array();
    foreach ($temp as $element) {
        if($element['user_id'] > 0){
            $horses = $db->getAll("SELECT * FROM horses WHERE o_uid = ?i", $element['user_id']);
            $element['horses'] = $horses;
        }
        $results[$element["route_id"]][] = $element;
    }
    $assigned_vars["comp"]["results"] = $results;
    $assigned_vars["users"] = $db->getAll("SELECT * FROM users WHERE work LIKE '%Спортсмен%' ORDER BY lname");
    $assigned_vars["const_mounth"] = $const_mounth;
    $assigned_vars["const_work"] = $const_work;
    $assigned_vars["const_countries"] = $const_countries;
    $assigned_vars["clubs"] = $db->getAll("SELECT * FROM clubs ORDER BY name");
    $assigned_vars["const_horses_sex"] = $const_horses_sex;
    $assigned_vars["const_horses_poroda"] = $const_horses_poroda;
    $assigned_vars["const_horses_mast"] = $const_horses_mast;
    $assigned_vars["const_horses_spec"] = $const_horses_spec;
	template_render($assigned_vars, "competition-edit.tpl");
}
