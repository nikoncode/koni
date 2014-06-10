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
        "page_title" 		=> "Объявления > Одноконники",
        "masti" => $const_horses_mast,
        "porodi" => $const_horses_poroda,
        "sexs" => $const_horses_sex,
        "specs" => $const_horses_spec,
        "countries" => $const_countries,
        "year_now" => date('Y'),
    );
    $assigned_vars["horses"] = $db->getAll("SELECT * FROM adv ORDER BY add_time");
    template_render($assigned_vars, "adv.tpl");
}
