<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (CORE_DIR . "core_includes/others.php");

/* Logic part of 'horses' page */
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars = array();
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	if (empty($_GET["id"])) {
		template_render_error("Такой лошади не существует :C");
	} else {
		$db  = new db;
		$assigned_vars["horse"] = $db->getRow("SELECT *,
													(SELECT COUNT(id) FROM comments WHERE hid = horses.id) as comments_cnt,
													(SELECT avatar FROM users WHERE id = ?i) as user_avatar,
													(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = horses.album_id) as photos,
													(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = horses.album_id) as photo_ids
											  FROM horses WHERE id = ?i", $_SESSION["user_id"], $_GET["id"]);
		$assigned_vars["horse"]["photos"] = others_make_photo_array($assigned_vars["horse"]["photos"], $assigned_vars["horse"]["photo_ids"]);
		if ($assigned_vars["horse"]  === NULL) {
			template_render_error("Такой лошади не существует :C");
		} else {
			$assigned_vars["page_title"] = "Лошадь '" . $assigned_vars["horse"]["nick"] . "' > Одноконники";
			$assigned_vars["horse"]["age"] = date("Y", time()) - $assigned_vars["horse"]["byear"];
			$assigned_vars["horse"]["parents"] = json_decode($assigned_vars["horse"]["parents"], 1);
			if ($assigned_vars["horse"]["o_uid"] != $_SESSION["user_id"]) {
				$assigned_vars["another_user"] = template_get_user_info($assigned_vars["horse"]["o_uid"]);
			}
			$assigned_vars["comments"] = $db->getAll("SELECT c.*,
															concat(fname,' ',lname) as fio,
															avatar,
															(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
															(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked
													FROM (
														SELECT * FROM comments WHERE hid = ?i ORDER BY time DESC LIMIT 3
													) c, users
													WHERE o_uid = users.id
													ORDER BY time ASC", $_SESSION["user_id"], $assigned_vars["horse"]["id"]);
            $assigned_vars["be_events"] = $db->getAll("SELECT c.*,r.name as route, r.exam, r.bdate as date, r.height
													FROM comp_riders as cr
													INNER JOIN routes as r on (cr.rid = r.id)
													INNER JOIN comp as c on (c.id = r.cid)
													WHERE cr.uid = ?i AND cr.hid = ?i AND r.bdate > ?s
													ORDER BY bdate ASC", $_SESSION["user_id"], $assigned_vars["horse"]["id"], date('Y-m-d H:i:s'));

            $assigned_vars["end_events"] = $db->getAll("SELECT c.*,r.name as route, r.exam, r.bdate as date, r.height
													FROM comp_riders as cr
													INNER JOIN routes as r on (cr.rid = r.id)
													INNER JOIN comp as c on (c.id = r.cid)
													WHERE cr.uid = ?i AND cr.hid = ?i AND r.bdate <= ?s
													ORDER BY bdate ASC", $_SESSION["user_id"], $assigned_vars["horse"]["id"], date('Y-m-d H:i:s'));
			$assigned_vars["comments_cnt"] = $assigned_vars["horse"]["comments_cnt"];
			$assigned_vars["c_key"] = "hid";
			$assigned_vars["c_value"] = $assigned_vars["horse"]["id"];
			$assigned_vars["user_avatar"] = $assigned_vars["horse"]["user_avatar"];
			template_render($assigned_vars, "horse.tpl");
		}
	}
}