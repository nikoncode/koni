<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

$tmpl = new templater;
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$db = new db;
	/* left sidebar */
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	if (!empty($_GET["id"])) {
		$assigned_vars["another_user"] = template_get_user_info($_GET["id"]);
		if ($assigned_vars["another_user"] == NULL) {
			template_render_error("Такого пользователя не существует. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
		} else {
			$assigned_vars["page_title"] = "Чат с '" . $assigned_vars["another_user"]["fio"] . "' > Одноконники";
			template_render($assigned_vars, "chat.tpl");
		}	
	} else {
		template_render_error("Такого пользователя не существует. Пожалуйста вернитесь к <a href='/find-users.php'>поиску</a> или уточните его идентификатор.");
	}
}



