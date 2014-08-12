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
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //fix
	$assigned_vars["comp"] = $db->getRow("SELECT *,
												(SELECT CONCAT(viewer,',',photographer,',',fan) 
													FROM comp_members 
													WHERE uid = ?i
													AND cid = comp.id) as member_mask
										FROM comp WHERE id = ?i", $_SESSION["user_id"], $_GET["id"]);

	if ($assigned_vars["comp"] == NULL) {
		template_render_error("Соревнование не найдено.");
	}
	$assigned_vars["club"] = $db->getRow("SELECT * FROM clubs WHERE id = ?i", $assigned_vars["comp"]["o_cid"]);
	$assigned_vars["club"]["phones"] = unserialize($assigned_vars["club"]["c_phones"]);
	$assigned_vars["club"]["adv"] = others_club_adv_choose($assigned_vars["club"]["adv"]);
	$assigned_vars["page_title"] = "Соревнование '" . $assigned_vars["comp"]["name"] . "' > Одноконники";
	$temp = explode(",", $assigned_vars["comp"]["member_mask"]);
	$assigned_vars["comp"]["is_viewer"] = (bool)$temp[0];
	$assigned_vars["comp"]["is_photographer"] = (bool)$temp[1];
	$assigned_vars["comp"]["is_fan"] = (bool)$temp[2];

	if (!empty($assigned_vars["comp"]["results"])) {
		$assigned_vars["comp"]["results"] = unserialize($assigned_vars["comp"]["results"]);
	}

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
									CONCAT(fname, ' ', lname) as fio,
									comp_members.photographer,
									comp_members.viewer,
									comp_members.fan
							FROM comp_members, users
							WHERE comp_members.cid = ?i
							AND comp_members.uid = users.id", $assigned_vars["comp"]["id"]);
	$assigned_vars["comp"]["riders"] = $db->getAll("SELECT 	users.id,
															users.avatar,
															CONCAT(fname, ' ', lname) as fio,
															GROUP_CONCAT(DISTINCT CONCAT(horses.nick,',',horses.poroda )) as horse,
															clubs.name as club, clubs.city
													FROM comp_riders, users, horses, clubs
													WHERE comp_riders.rid IN 
														(SELECT id FROM routes WHERE cid = ?i)
													AND comp_riders.uid = users.id AND horses.id = comp_riders.hid AND clubs.id = users.cid
													GROUP BY id", $assigned_vars["comp"]["id"]);

	$assigned_vars["comp"]["viewers"] = 
	$assigned_vars["comp"]["photographers"] =
	$assigned_vars["comp"]["fans"] = 
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
	}
    $comments = $db->getAll("SELECT c.*,
										concat(fname,' ',lname) as fio,
										users.avatar,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked
								FROM (
									SELECT * FROM comments WHERE cid = ?i ORDER BY time DESC LIMIT 3
								) c, users
								WHERE o_uid = users.id
								ORDER BY time ASC", $_SESSION["user_id"], $assigned_vars["comp"]["id"]);
    $comments_count = $db->getOne("SELECT COUNT(id) as comments_cnt FROM comments WHERE cid = ?i", $assigned_vars["comp"]["id"]);
    /* Render comments to var */
    $comments_bl = template_render_to_var(array(
        "comments" => $comments,
        "comments_cnt" => $comments_count,
        "user_avatar" => $assigned_vars["user"]["avatar"],
        "c_key" => "cid",
        "c_value" => $assigned_vars["comp"]["id"],
        "user" => array("id" => $_SESSION["user_id"])
    ), "iterations/comments_block.tpl");
    $assigned_vars['comments_bl'] = $comments_bl;
	$assigned_vars["horses"] = $db->getAll("SELECT id, nick FROM horses WHERE o_uid = ?i", $_SESSION["user_id"]);
	template_render($assigned_vars, "competition.tpl");
}
