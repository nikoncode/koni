<?php
/* Logic part of 'gallery-upload' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");


if (!check()) {
	render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$user = tmpl_get_user_info($_SESSION["user_id"]);
	if (empty($_GET["id"])) {
		render_error("Запрашиваемый альбом не найден.");	
	} else {
		$db = new db;
		$album_info = $db->getRow("SELECT id, name FROM albums WHERE id = ?i AND o_uid = ?i", $_GET["id"], $_SESSION["user_id"]);
		$assigned_vars  = array(
			"page_title" => "Загрузить фото > Одноконники",
			"album_id"	 => $album_info["id"],
			"album_name" => $album_info["name"],
			"user"		 => $user
		);
		render_template($assigned_vars, "gallery-upload.tpl");
	}
}

