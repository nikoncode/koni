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

    $db = new db;
    $user_id = (isset($_GET['id']))?intval($_GET['id']):$_SESSION["user_id"];
    if(isset($_GET['ifan'])){
        $assigned_vars = array(
            "page_title" 		=> "Я болею > Одноконники",
            "title" 		=> "Я болею за",
        );
        $cid = $db->getRow("SELECT cm.fan_riders, c.name  FROM `comp_members` as cm
                            INNER JOIN comp as c ON (c.id = cm.cid)
                            WHERE cm.cid = ?i AND cm.uid = ?i", $_GET["cid"],$user_id);
        $name = $cid['name'];
        $users = $db->getAll("SELECT * FROM `users`
                            WHERE id IN (".$cid['fan_riders'].")");
    }else{
        $assigned_vars = array(
            "page_title" 		=> "За меня болеют > Одноконники",
            "title" 		=> "За меня болеют",
        );
        $cid = $db->getAll("SELECT cm.uid,cm.fan_riders, c.name  FROM `comp_members` as cm
                            INNER JOIN comp as c ON (c.id = cm.cid)
                            WHERE cm.cid = ?i AND cm.fan_riders <> ''", $_GET["cid"]);
        $ids = '';

        foreach($cid as $row){
            $riders = explode(',',$row['fan_riders']);
            if(in_array($user_id,$riders)) $ids .= $row['uid'].',';
            $name = $row['name'];
        }
        if($ids != ''){
            $users = $db->getAll("SELECT * FROM `users`
                            WHERE id IN (".trim($ids,',').")");
        }

    }

    $assigned_vars['users'] = $users;
    $assigned_vars['compName'] = $name;
    $assigned_vars['compId'] = $_GET["cid"];
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    template_render($assigned_vars, "fans.tpl");
}
