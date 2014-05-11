<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

/* Logic part of 'messages' page */
if (!session_check()) {
	template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]);
	$db = new db;
	$dialogs = $db->getAll("SELECT 
    						MAX(`id`) AS `message_id`,
    						IF (`uid` > `fid`, `fid`, `uid`) AS `lower`,
    						IF (`uid` > `fid`, `uid`, `fid`) AS `upper`
						FROM messages
						WHERE uid = ?i OR fid = ?i 
						GROUP BY `lower`,`upper`", $_SESSION["user_id"], $_SESSION["user_id"]);
	
	$ids = array();
	foreach ($dialogs as $dialog) {
		$ids[] = $dialog["message_id"];
	}
	$assigned_vars["messages"] = $db->getAll("SELECT IF(uid = ?i, fid, uid) AS friend_id,
											       IF (uid = ?i, 1, 0) AS me_last,
											  (SELECT CONCAT(fname,' ',lname)
											   FROM users
											   WHERE id = friend_id) AS friend_fio,
											  (SELECT avatar
											   FROM users
											   WHERE id = friend_id) AS friend_avatar, uid, text, time
											FROM `messages`
											WHERE id IN (?a)
											ORDER BY time DESC", $_SESSION["user_id"], $_SESSION["user_id"], $ids);
	$assigned_vars["page_title"] = "Диалоги > Одноконники";
	template_render($assigned_vars, "messages.tpl");
}