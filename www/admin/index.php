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
        $start_s = (isset($_GET['page_s']))?$_GET['page_s']*$limit:0;

        if(isset($_POST['search_u']) && strlen($_POST['q']) > 0){
            $assigned_vars['users_count'] = 1;
            $q = explode(" ",$_POST['q']);
            if(count($q) > 1){
                $assigned_vars["users"] = $db->getAll("SELECT u.*,c.name AS club FROM users AS u
                                               LEFT JOIN clubs AS c ON (c.id = u.id)
                                               WHERE ((u.fname = '".$q[0]."' AND u.lname LIKE '".$q[1]."%') OR (u.lname = '".$q[0]."' AND u.fname LIKE '".$q[1]."%'))
                                               ORDER BY lname ");
            }else{
                $assigned_vars["users"] = $db->getAll("SELECT u.*,c.name AS club FROM users AS u
                                               LEFT JOIN clubs AS c ON (c.id = u.id)
                                               WHERE (u.lname LIKE '".$q[0]."%' OR u.fname LIKE '".$q[0]."%')
                                               ORDER BY lname ");
            }
            $assigned_vars['q_user'] = $_POST['q'];
        }else{
            $assigned_vars["users"] = $db->getAll("SELECT u.*,c.name AS club FROM users AS u
                                               LEFT JOIN clubs AS c ON (c.id = u.id)
                                               ORDER BY lname LIMIT ?i,".$limit, $start_u);
            $assigned_vars['users_count'] = $db->getOne("SELECT COUNT(id) FROM users");
            $assigned_vars['users_count'] = ceil($assigned_vars['users_count']/$limit);
        }


        if(isset($_POST['search_c']) && strlen($_POST['q']) > 0){
            $assigned_vars["clubs"] = $db->getAll("SELECT * FROM clubs WHERE name LIKE '%".$_POST['q']."%' ORDER BY name ");
            $assigned_vars['q_club'] = $_POST['q'];
            $assigned_vars['clubs_count'] = 1;
        }else{
            $assigned_vars["clubs"] = $db->getAll("SELECT * FROM clubs ORDER BY name LIMIT ?i,".$limit, $start_c);
            $assigned_vars['clubs_count'] = $db->getOne("SELECT COUNT(id) FROM clubs");
            $assigned_vars['clubs_count'] = ceil($assigned_vars['clubs_count']/$limit);
        }

        $assigned_vars["support"] = $db->getAll("SELECT * FROM support ORDER BY dt DESC LIMIT ?i,".$limit, $start_s);
        $assigned_vars['support_count'] = $db->getOne("SELECT COUNT(id) FROM support");
        $assigned_vars['support_count'] = ceil($assigned_vars['clubs_count']/$limit);

        $assigned_vars['start_u'] = (isset($_GET['page_u']))?$_GET['page_u']:1;
        $assigned_vars['start_c'] = (isset($_GET['page_c']))?$_GET['page_c']:1;
        $assigned_vars['start_s'] = (isset($_GET['page_s']))?$_GET['page_s']:1;
        $assigned_vars['limit'] = $limit;
        $assigned_vars["countries"] = $const_countries;
        $assigned_vars["const_horses_sex"] = $const_horses_sex;
        $assigned_vars["const_horses_poroda"] = $const_horses_poroda;
        $assigned_vars["const_horses_mast"] = $const_horses_mast;
        $assigned_vars["const_horses_spec"] = $const_horses_spec;
        template_render($assigned_vars, "admin/index.tpl");
    }

}