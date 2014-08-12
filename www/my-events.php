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
    );
    $assigned_vars["be_events"] = $db->getAll("SELECT c.*,r.name as route, r.exam, r.bdate as date, r.height, cm.fan,cl.city,cl.name as club, cl.avatar, cl.id as club_id, cm.fan_riders, r.type
													FROM comp as c
													INNER JOIN clubs as cl on (cl.id = c.o_cid)
													LEFT JOIN routes as r on (r.cid = c.id)
													LEFT JOIN comp_riders as cr on (cr.uid = ?i AND cr.rid = r.id)
													LEFT JOIN comp_members as cm on (cm.uid = ?i AND cm.cid = c.id)
													WHERE c.bdate > ?s AND (cm.fan > 0 OR cr.id > 0)
													ORDER BY bdate ASC", $_SESSION["user_id"], $_SESSION["user_id"], date('Y-m-d H:i:s'));

    $my_fans = $db->getAll("SELECT COUNT(cm.id) as count,cm.cid FROM `users` as u
                            INNER JOIN comp_members as cm ON (cm.fan_riders IN (u.id))
                            INNER JOIN comp as c ON (c.id = cm.cid)
                            WHERE u.id = ?i AND c.bdate > ?s GROUP BY cm.cid", $_SESSION["user_id"], date('Y-m-d'));
    $my_fans_ar = array();
    foreach($my_fans as $row){
        $my_fans_ar[$row['cid']] = $row['count'];
    }
    $assigned_vars['be_events_fans'] = $my_fans_ar;

    $assigned_vars["end_events"] = $db->getAll("SELECT c.*,r.name as route, r.exam, r.bdate as date, r.height, cm.fan,cl.city,cl.name as club, cl.avatar, cl.id as club_id, cm.fan_riders, r.type
													FROM comp as c
													INNER JOIN clubs as cl on (cl.id = c.o_cid)
													LEFT JOIN routes as r on (r.cid = c.id)
													LEFT JOIN comp_riders as cr on (cr.uid = ?i AND cr.rid = r.id)
													LEFT JOIN comp_members as cm on (cm.uid = ?i AND cm.cid = c.id)
													WHERE c.bdate <= ?s AND (cm.fan > 0 OR cr.id > 0)
													ORDER BY bdate ASC", $_SESSION["user_id"], $_SESSION["user_id"], date('Y-m-d H:i:s'));

    $my_fans = $db->getAll("SELECT COUNT(cm.id) as count,cm.cid FROM `users` as u
                            INNER JOIN comp_members as cm ON (cm.fan_riders IN (u.id))
                            INNER JOIN comp as c ON (c.id = cm.cid)
                            WHERE u.id = ?i AND c.bdate <= ?s GROUP BY cm.cid", $_SESSION["user_id"], date('Y-m-d'));
    $my_fans_ar = array();
    foreach($my_fans as $row){
        $my_fans_ar[$row['cid']] = $row['count'];
    }
    $assigned_vars['end_events_fans'] = $my_fans_ar;
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    template_render($assigned_vars, "my-events.tpl");
}
