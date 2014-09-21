<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "/constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'profile' page */
if (!session_check()) {
    template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
    $assigned_vars = array(
        "page_title" 		=> "Мероприятия > Одноконники",
    );
    $assigned_vars["const_types"] = $const_horses_spec;
    $db = new db;
    $assigned_vars["clubs"] = $db->getAll('SELECT name FROM clubs ORDER BY name');
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    template_render($assigned_vars, "events.tpl");
}
