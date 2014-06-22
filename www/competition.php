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
	$db = new db;
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //fix
	$assigned_vars["comp"] = $db->getRow("SELECT *,
												(SELECT CONCAT(viewer,',',photographer,',',fan) 
													FROM comp_members 
													WHERE uid = ?i
													AND cid = comp.id) as member_mask
										FROM comp WHERE id = ?i", $_SESSION["user_id"], $_GET["id"]);

	$temp = explode(",", $assigned_vars["comp"]["member_mask"]);
	$assigned_vars["comp"]["is_viewer"] = (bool)$temp[0];
	$assigned_vars["comp"]["is_photographer"] = (bool)$temp[1];
	$assigned_vars["comp"]["is_fan"] = (bool)$temp[2];

	$assigned_vars["comp"]["routes"] = $db->getAll("SELECT *,
															(SELECT COUNT(id) 
															FROM comp_riders 
															WHERE uid = ?i 
															AND rid = routes.id) as is_rider 
													FROM routes WHERE cid = ?i", $_SESSION["user_id"], $_GET["id"]);

	foreach ($assigned_vars["comp"]["routes"] as &$route) {
		$route["options"] = unserialize($route["options"]);
	}

	$members = $db->getAll("SELECT 	users.id,
									users.avatar,
									CONCAT(fname,' ',lname) as fio,
									photographer,
									viewer,
									fan,
									comp_riders.id as rider
							FROM (
								(SELECT uid FROM comp_members WHERE cid = ?i)
								UNION
								(SELECT uid FROM comp_riders WHERE rid IN (SELECT id FROM  routes WHERE cid = ?i))
							) as s 
							LEFT JOIN users 
								ON users.id = s.uid
							LEFT JOIN comp_members
								ON comp_members.uid = s.uid
							LEFT JOIN comp_riders
								ON comp_riders.uid = s.uid
							GROUP BY id", $assigned_vars["comp"]["id"], $assigned_vars["comp"]["id"]);

	//print_r($members);
	$assigned_vars["comp"]["viewers"] = 
	$assigned_vars["comp"]["photographers"] =
	$assigned_vars["comp"]["fans"] = 
	$assigned_vars["comp"]["riders"] = 
	array();

	foreach ($members as $member) {
		$temp = array(
			"id" => $member["id"],
			"fio" => $member["fio"],
			"avatar" => $member["avatar"]
		);
		if ($member["viewer"]) {
			$assigned_vars["comp"]["viewers"][] = $temp;
		} 
		if ($member["photographer"]) {
			$assigned_vars["comp"]["photographers"][] = $temp;
		} 
		if ($member["fan"]) {
			$assigned_vars["comp"]["fans"][] = $temp;
		} 
		if ($member["rider"]) {
			$assigned_vars["comp"]["riders"][] = $temp;
		} 
	}

	print_r($assigned_vars["comp"]["members"]);
	template_render($assigned_vars, "competition.tpl");
}
