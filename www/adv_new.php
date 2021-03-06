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
        "page_title" 		=> "Новое объявление > Одноконники",
        "masti" => $const_horses_mast,
        "porodi" => $const_horses_poroda,
        "sexs" => $const_horses_sex,
        "specs" => $const_horses_spec,
        "countries" => $const_countries,
        "usage" => $_POST['usage'],
        "type" => $_POST['type'],
    );
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    $db = New db;
    if($_POST['new_horse'] == 2){

        $assigned_vars["horse"] = $db->getRow("SELECT *
											FROM horses
											WHERE o_uid = ?i AND id = ?i", $_SESSION['user_id'],$_POST['horse_id']);
    }
    $assigned_vars["my_horses"] = $db->getAll("SELECT id,
													avatar,
													nick,
													sex,
													byear,
													spec
											FROM horses
											WHERE o_uid = ?i", $_SESSION['user_id']);
    if($_POST['usage'] == 1){
        template_render($assigned_vars, "adv_new.tpl");
    }else{
        template_render($assigned_vars, "adv_new_sell_car.tpl");
    }

}
