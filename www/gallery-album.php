<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'gallery' page */
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars = array();
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$user_id = $assigned_vars["user"]["id"];

	/* Checking album id */
	if (isset($_GET["id"])) {
			$db = new db;
        $assigned_vars["albums"] = $db->getAll("SELECT 	id,
													name,
													`desc`,
													linked_event,
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT preview FROM gallery_photos where album_id=albums.id LIMIT 1) as cover
											FROM albums WHERE o_uid = ?i", $user_id);
			$assigned_vars["album"] = $db->getRow("SELECT id, name, `desc`, o_uid FROM albums WHERE id = ?i", $_GET["id"]);
			if ($assigned_vars["album"] === NULL) {
				template_render_error("Такого альбома не существует. Мы сожалеем :C");
			} else {
				/* If owner not you? */
				if ($user_id != $assigned_vars["album"]["o_uid"]) {
					$assigned_vars["another_user"] = template_get_user_info($assigned_vars["album"]["o_uid"]);
					$user_id = $assigned_vars["another_user"]["id"];
				}
				/* Getting photos list */
				$assigned_vars["photos"] = $db->getAll("SELECT preview, id FROM gallery_photos WHERE album_id = ?i ORDER BY time DESC", $assigned_vars["album"]["id"]);
				
				$ids = array();
				foreach($assigned_vars["photos"] as $photo) {
					$ids[] = $photo["id"];
				}
				$assigned_vars["photos_ids_list"] = implode(",", $ids);
                $assigned_vars["events"] = $db->getAll("SELECT c.*, DATE_FORMAT(c.bdate,'%d.%m.%Y') as date
													FROM comp as c
													INNER JOIN clubs as cl on (cl.id = c.o_cid)
													LEFT JOIN routes as r on (r.cid = c.id)
													LEFT JOIN comp_riders as cr on (cr.uid = ?i AND cr.rid = r.id)
													LEFT JOIN comp_members as cm on (cm.uid = ?i AND cm.cid = c.id)
													WHERE cm.fan > 0 OR cr.id > 0
													ORDER BY c.bdate DESC", $_SESSION["user_id"], $_SESSION["user_id"]);
				$assigned_vars["user_id"] = $user_id;
				$assigned_vars["page_title"] = "Альбом '" . $assigned_vars["album"]["name"] . "' > Одноконники";
				template_render($assigned_vars, "gallery-album.tpl");
			}
	} else {
		template_render_error("Такого альбома не существует. Мы сожалеем :C");
	}
	
}

