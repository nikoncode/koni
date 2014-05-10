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