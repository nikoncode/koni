<?php
/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");

/* this is 'chat' api unit (MAYBE DEPRECATED) */
function api_chat_me_info() {
	if (session_check()) {
		$db = new db;
		$info = $db->getRow("SELECT CONCAT(fname, ' ', lname) as fio, avatar,id FROM users WHERE id = ?i", $_SESSION["user_id"]);
		aok($info);
	} else {
		aerr(array("Пожалуйста войдите."));
	}
	
}

function api_chat_unread_count() {
    if (session_check()) {
        $db = new db;
        $info['count'] = $db->getOne("SELECT COUNT(id) as count FROM messages WHERE status = 0 AND fid = ?i GROUP BY uid", $_SESSION["user_id"]);
        $info['events_count'] = $db->getOne("SELECT COUNT(id) as count FROM notice WHERE status = 0 AND o_uid = ?i", $_SESSION["user_id"]);
        aok($info);
    }
    aok(array('neok'));
}

function api_chat_unread_update() {
    if (session_check() && isset($_POST['fid'])) {
        $db = new db;
        $db->getRow("UPDATE messages SET status = 1 WHERE status = 0 AND uid = ?i AND fid = ?i", intval($_POST['fid']) ,$_SESSION["user_id"]);
        aok(array('ok'));
    }
    aok(array('neok'));
}