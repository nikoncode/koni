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
	/* Checking another user */
	if (!empty($_GET["id"]) && $assigned_vars["user"]["id"] != $_GET["id"]) {
		$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
		if ($assigned_vars["another_user"] === NULL) {
			template_render_error("Такого пользователя не существует. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
		} else {
			$user_id = $assigned_vars["another_user"]["id"];
		}
	}
	/* Getting all albums and photos */
	$db = new db;
	$assigned_vars["albums"] = $db->getAll("SELECT 	id, 
													name, 
													`desc`, 
													linked_event, 
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT preview FROM gallery_photos where album_id=albums.id LIMIT 1) as cover
											FROM albums WHERE o_uid = ?i AND att = 0", $user_id);

	$assigned_vars["photos"] = $db->getAll("SELECT 	id,
													preview
										 	FROM gallery_photos WHERE album_club_id=0 AND o_uid = ?i ORDER BY time DESC", $user_id);

	/* Making id's array for gallery */
	$ids = array();
	foreach($assigned_vars["photos"] as $photo) {
		$ids[] = $photo["id"];
	}
	$assigned_vars["photos_ids_list"] = implode(",", $ids);

	/* Render */
	$assigned_vars["page_title"] = "Галерея > Одноконники";
	template_render($assigned_vars, "gallery.tpl");
}

