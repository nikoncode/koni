<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");


if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$user = template_get_user_info($_SESSION["user_id"]);
	if (empty($_GET["id"])) {
		template_render_error("Запрашиваемый альбом не найден. Мы сожалеем :C");	
	} else {
		$db = new db;
        if(isset($_GET['club_id'])){
            $album_info = $db->getRow("SELECT id, name FROM albums_clubs WHERE id = ?i AND c_uid = ?i", $_GET["id"], $_GET["club_id"]);
        }elseif(isset($_GET['comp_id'])){
            $album_info = $db->getRow("SELECT id, name FROM albums_clubs WHERE id = ?i AND comp_id = ?i", $_GET["id"], $_GET["comp_id"]);
        }else{
            $album_info = $db->getRow("SELECT id, name FROM albums WHERE id = ?i AND o_uid = ?i", $_GET["id"], $_SESSION["user_id"]);
        }

		if ($album_info === NULL) {
			template_render_error("Запрашиваемый альбом не найден. Мы сожалеем :C");	
		} else {
			$assigned_vars  = array(
				"page_title" => "Загрузить фото > Одноконники",
				"album_id"	 => $album_info["id"],
				"club_id"	 => intval($_GET['club_id']),
				"comp_id"	 => intval($_GET['comp_id']),
				"album_name" => $album_info["name"],
				"user"		 => $user
			);
			template_render($assigned_vars, "gallery-upload.tpl");
		}
	}
}

