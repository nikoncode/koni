<?php
/* Logic part of 'gallery' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");
include (CORE_DIR . "constant.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");

$tmpl = new templater;
if (!check()) {
	$tmpl->assign("page_title", "Ошибка > Одноконники");
	$tmpl->assign("error_text", "К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
	$tmpl->display("error.tpl");
} else {
	$user = tmpl_get_user_info($_SESSION["user_id"]);
	$user_id = $user["id"];
	$user_fio = $user["fio"];
	$tmpl->assign("user", $user);
	if (!empty($_GET["id"]) && $user_id != $_GET["id"]) {
		$another_user = tmpl_get_user_info($_GET["id"]);
		if ($another_user !== NULL) {
			$user_id = $another_user["id"];
			$user_fio = $another_user["fio"];
			$tmpl->assign("another_user", $another_user);
		} else {
			$tmpl->assign("page_title", "Ошибка > Одноконники");
			$tmpl->assign("error_text", "К сожалению, пользователь с которым вы хотите пообщаться не найден. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
			$tmpl->display("error.tpl");
		}
	}
	$tmpl->assign("page_title", "Галерея " . $user_fio . " > Одноконники");
	$db = new db;
	$albums = $db->getAll("SELECT 	id, 
									name, 
									`desc`, 
									linked_event, 
									(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
									(SELECT preview FROM gallery_photos where album_id=albums.id LIMIT 1) as cover
						  FROM albums WHERE o_uid = ?i", $user_id);

	$photos = $db->getAll("SELECT 	id,
									preview
						  FROM gallery_photos WHERE o_uid = ?i", $user_id);

	$ids = array();
	foreach($photos as $photo) {
		$ids[] = $photo["id"];
	}

	$tmpl->assign("photos_ids_list", implode(",", $ids));
	$tmpl->assign("albums", $albums);
	$tmpl->assign("photos", $photos);
	$tmpl->display("gallery.tpl");
}

