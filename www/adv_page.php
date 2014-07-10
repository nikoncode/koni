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
    $horse = $db->getRow("SELECT * ,
    (SELECT COUNT(id) FROM comments WHERE aid = adv.id) as comments_cnt,
     (SELECT avatar FROM users WHERE id = ?i) as user_avatar
    FROM adv WHERE id = ?i", $_SESSION["user_id"],$_GET['adv']);
    $photos = $db->getAll("SELECT * FROM adv_photos WHERE o_uid = ?i AND adv_id = ?i", $_SESSION["user_id"],$_GET['adv']);
    $comments = $db->getAll("SELECT c.*,
										concat(fname,' ',lname) as fio,
										avatar,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked
								FROM (
									SELECT * FROM comments WHERE aid = ?i ORDER BY time DESC LIMIT 3
								) c, users
								WHERE o_uid = users.id
								ORDER BY time ASC", $_SESSION["user_id"], $_GET['adv']);

    /* Render comments to var */
    $comments_bl = template_render_to_var(array(
        "comments" => $comments,
        "comments_cnt" => $horse["comments_cnt"],
        "user_avatar" => $horse["user_avatar"],
        "c_key" => "aid",
        "c_value" => $horse["id"],
        "user" => array("id" => $_SESSION["user_id"])
    ), "iterations/comments_block.tpl");
    $assigned_vars = array(
        "page_title" 		=> "Объявления > Одноконники",
        "masti" => $const_horses_mast,
        "porodi" => $const_horses_poroda,
        "sexs" => $const_horses_sex,
        "specs" => $const_horses_spec,
        "countries" => $const_countries,
        "year_now" => date('Y'),
        "comments_bl" => $comments_bl,
        "horse" => $horse,
        "photos" => $photos,
    );
    $ids = array();
    foreach($assigned_vars["photos"] as $photo) {
        $ids[] = $photo["id"];
    }
    $assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
    $assigned_vars["photos_ids_list"] = implode(",", $ids);
    $assigned_vars["my_horses"] = $db->getAll("SELECT id,
													avatar,
													nick,
													sex,
													byear,
													spec
											FROM horses
											WHERE o_uid = ?i", $_SESSION['user_id']);
    template_render($assigned_vars, "adv_page.tpl");
}
