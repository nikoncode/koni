<?php
/* Including functional dependencies */
include_once ("../../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "/constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
if (!session_check()) {
    template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
    if($assigned_vars['user']['admin'] == 0){
        template_render_error("У вас нет доступа к этой странице <a href='/inner.php'>вернуться на свою страницу</a>.");
    }else{
        $assigned_vars["page_title"] = "Панель администратора > Одноконники";
        $db = new db;
        $limit = 30;
        $start_u = (isset($_GET['page_u']))?$_GET['page_u']*$limit:0;
        $start_c = (isset($_GET['page_c']))?$_GET['page_c']*$limit:0;
        $assigned_vars["users"] = $db->getAll("SELECT u.*,c.name AS club FROM users AS u
                                               LEFT JOIN clubs AS c ON (c.id = u.id)
                                               ORDER BY lname LIMIT ?i,".$limit, $start_u);
        $assigned_vars['users_count'] = $db->getOne("SELECT COUNT(id) FROM users");
        $assigned_vars['users_count'] = ceil($assigned_vars['users_count']/$limit);
        $assigned_vars['clubs_count'] = $db->getOne("SELECT COUNT(id) FROM clubs");
        $assigned_vars['clubs_count'] = ceil($assigned_vars['clubs_count']/$limit);
        $assigned_vars["clubs"] = $db->getAll("SELECT * FROM clubs ORDER BY name LIMIT ?i,".$limit, $start_c);
        $assigned_vars['start_u'] = (isset($_GET['page_u']))?$_GET['page_u']:1;
        $assigned_vars['start_c'] = (isset($_GET['page_c']))?$_GET['page_c']:1;

        template_render($assigned_vars, "admin/index.tpl");
    }

}