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
        "page_title" 		=> "Рейтинг > Одноконники",
    );
    $assigned_vars["clubs"] = $db->getAll("SELECT c.avatar, cr.cid,SUM(cr.rating)/COUNT(cr.cid) as rating, c.name, CONCAT(c.country,', ',c.city) as address,
                                            (SELECT COUNT(id) as members FROM users WHERE cid = cr.cid) as members
                                            FROM `club_reviews` as cr
                                            INNER JOIN clubs as c ON(c.id = cr.cid)
                                            GROUP BY cr.cid ORDER BY rating DESC");
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    $assigned_vars['countries'] =$const_countries;
    template_render($assigned_vars, "ratings.tpl");
}
