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
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    $assigned_vars["horses"] = $db->getAll("SELECT *, (SELECT preview FROM adv_photos WHERE adv_id = adv.id LIMIT 1) as preview FROM adv WHERE `usage` = 1 ORDER BY add_time");
    $assigned_vars["my_horses"] = $db->getAll("SELECT id,
													avatar,
													nick,
													sex,
													byear,
													spec
											FROM horses
											WHERE o_uid = ?i", $_SESSION['user_id']);
    template_render($assigned_vars, "adv.tpl");
}
