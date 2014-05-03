<?php
/* Logic part of 'gallery' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");

$tmpl = new templater;
if (!check()) {
	render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars = array();
	$assigned_vars["user"] = tmpl_get_user_info($_SESSION["user_id"]);
	if (isset($_GET["id"])) {
		$db = new db;
		$album = $db->getRow("SELECT id, name, `desc`, o_uid FROM albums WHERE id = ?i", $_GET["id"]);
		if ($album === NULL) {
			render_error("Такого альбома не существует :C");
		} else {
			$assigned_vars["album"] = $album;
			if ($album["o_uid"] != $_SESSION["user_id"]) {
				$assigned_vars["another_user"] = tmpl_get_user_info($album["o_uid"]);	
			}
			$assigned_vars["photos"] = $db->getAll("SELECT preview, id FROM gallery_photos WHERE album_id = ?i", $album["id"]);

			$ids = array();
			foreach($assigned_vars["photos"] as $photo) {
				$ids[] = $photo["id"];
			}
			$assigned_vars["photos_ids_list"] = implode(",", $ids);

			render_template($assigned_vars, "gallery-album.tpl");
		}
		
		if ($another_user === NULL) {
			render_error("К сожалению, пользователь с которым вы хотите пообщаться не найден. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
		} else {
			$db = new db;
			
		}
		
	} else {
		render_error("Не передан идентификатор :C");
	}
}

