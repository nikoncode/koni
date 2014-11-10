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


	$assigned_vars["comp"]["routes"] = $db->getAll("SELECT *,
															(SELECT COUNT(id) 
															FROM comp_riders 
															WHERE uid = ?i 
															AND rid = routes.id) as is_rider 
													FROM routes WHERE cid = ?i", $_SESSION["user_id"], $_GET["id"]);
    $assigned_vars["comp"]["results"] = array();
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
															comp_riders.ordering
													FROM comp_riders, users, horses, clubs
													WHERE
													comp_riders.uid = users.id AND horses.id = comp_riders.hid AND clubs.id = users.cid AND comp_riders.rid = ?i ORDER BY ordering
													", $route['id']);
        $assigned_vars["comp"]["results"][$route['id']] = $db->getAll("SELECT 	users.id,
															CONCAT(fname, ' ', lname) as fio,
															CONCAT(horses.nick,'-',horses.byear,', ',horses.sex,', ',horses.poroda,', ',horses.mast,', ',horses.bplace) as horseName,
															horses.id as horse_id,
															horses.owner,
															(SELECT `name` FROM clubs WHERE comp_results.club_id=id) as club,
															(SELECT CONCAT(fname, ' ', lname) as fio FROM users WHERE id = horses.o_uid) as ownerName,
															comp_results.*
													FROM users, horses, comp_results
													WHERE comp_results.rid = ?i AND comp_results.user_id = users.id AND
													horses.id = comp_results.horse ORDER BY disq,rank
													", $route['id']);
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
													AND comp_riders.uid = users.id AND horses.id = comp_riders.hid
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
    if(isset($_GET['album'])){
        $ids = array();
        $assigned_vars["gallery"] = $db->getRow("SELECT * FROM albums_clubs WHERE id = ?i AND comp_id = ?i", $_GET['album'], $_GET['id']);

        if($assigned_vars["gallery"]["type_album"] == 0) {
            $assigned_vars["photos"] = $db->getAll("SELECT preview, id FROM gallery_photos WHERE album_club_id = ?i ORDER BY time DESC", $_GET['album']);
            foreach($assigned_vars["photos"] as $photo) {
                $ids[] = $photo["id"];
            }

        }
        if($assigned_vars["gallery"]["type_album"] == 1) {
            $assigned_vars["videos"] = $db->getAll("SELECT video, id FROM gallery_video WHERE album_club_id = ?i ORDER BY time DESC", $_GET['album']);
            foreach($assigned_vars["videos"] as $photo) {
                $ids[] = $photo["id"];
            }
        }
        $assigned_vars["albums"] = $db->getAll("SELECT * FROM albums_clubs WHERE comp_id = ?i AND type_album = ?i",$_GET['id'], $assigned_vars["gallery"]["type_album"]);
        $assigned_vars["gallery_id"] = $_GET['album'];


        $assigned_vars["photos_ids_list"] = implode(",", $ids);
    }else{
        $assigned_vars["comp"]["albums"] = $db->getAll("SELECT 	id,
													name,
													`desc`,
													linked_event,
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT preview FROM gallery_photos where album_club_id=albums_clubs.id LIMIT 1) as cover
											FROM albums_clubs WHERE type_album = 0 AND comp_id = ?i AND att = 0", $assigned_vars["comp"]["id"]);
        $assigned_vars["comp"]["albums_video"] = $db->getAll("SELECT 	id,
													name,
													`desc`,
													linked_event,
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT video FROM gallery_video where album_club_id=albums_clubs.id LIMIT 1) as cover
											FROM albums_clubs WHERE type_album = 1 AND comp_id = ?i AND att = 0", $assigned_vars["comp"]["id"]);
        $assigned_vars["users_photos"] = $db->getAll("SELECT u.avatar, CONCAT(u.fname,' ',u.lname) as fio, u.id as user_id, COUNT(gp.id) as count_photo, a.id FROM albums as a
                                                                    INNER JOIN users as u on (u.id = a.o_uid)
                                                                    INNER JOIN gallery_photos as gp on (gp.album_id = a.id)
                                                                    WHERE a.event = ?i GROUP BY a.event",$assigned_vars["comp"]["id"]);
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
    $assigned_vars["sportsman"] = (array_search('Спортсмен',$assigned_vars["user"]["profs"]) == NULL)?0:1;
    //$assigned_vars["files"] = $db->getAll("SELECT * FROM comp_files WHERE cid = ?i", $assigned_vars["comp"]["id"]);
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
