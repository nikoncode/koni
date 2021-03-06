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
	$assigned_vars["cid"] = $_GET["id"];
	$db = new db;
	$permission = $db->getRow("SELECT * FROM clubs WHERE id = ?i", $_GET["id"]);
    $assigned_vars["user"] = template_get_short_user_info($_SESSION["user_id"]);
	if ($permission['o_uid'] == NULL || ($permission['o_uid'] != $_SESSION["user_id"] && $assigned_vars["user"]["admin"] == 0)) {
		template_render_error("Вы не можете добавить соревнования в этот клуб. Мы сожалеем.");	
	}

	$assigned_vars["page_title"] = "Добавить соревнование > Одноконники";
	$assigned_vars["const_countries"] = $const_countries_old;
	$assigned_vars["const_types"] = $const_horses_spec;
	$assigned_vars["club"] = $permission;
	$assigned_vars["files"] = $db->getAll("SELECT * FROM comp_files WHERE cid = ?i", $_GET["id"]);
	template_render($assigned_vars, "competition-add.tpl");
}
