<?php
/* Depencies */
include_once(LIBRARIES_DIR . "smarty/smarty.php");
include_once(CORE_DIR . "core_includes/templates.php");

function api_comments_add() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("text", "type", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (!in_array($fields["type"], array("nid", "pid", "hid", "aid", "apid", "cid", "vid"))) { //check comment to news, horse, photo
		aerr(array("Ошибка."));
	}

	$db = new db;
	/* insert comment (XSS IN SMARTY) */
	$db->query("INSERT INTO comments (?n, text, o_uid) VALUES (?i, ?s, ?i);", 
		$fields["type"], 
		$fields["id"], 
		$fields["text"], 
		$_SESSION["user_id"]);

	/* Getting new comment */
	$new_comment = $db->getRow("SELECT c.*,
									users.avatar,
									concat(fname,' ',lname) as fio,
									0 as likes_cnt,
									0 as is_liked 
								FROM `comments` as c, users
	 							WHERE c.`id` = LAST_INSERT_ID()
								AND users.id = c.o_uid");
    if($fields['type'] == 'pid'){
        $user_id = $db->getOne("SELECT users.id FROM users, gallery_photos WHERE users.id=gallery_photos.o_uid AND gallery_photos.id=".$fields['id']);
        $message = 'Добавил комментарий к вашей фотографии.';
        api_add_notice($user_id,$_SESSION["user_id"],$message,'user');
    }

	/* Render he */
	$params = array(
		"comment" => $new_comment,
		"user" => array("id" => $_SESSION["user_id"])
	);
	$rendered = template_render_to_var($params, "iterations/comment.tpl");
	aok(array($rendered));
}

function api_comments_remove() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}	

	/* delete comment */
	$db = new db;
	$db->query("DELETE FROM comments WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	aok(array("Удалено."));
}

function api_comments_extra() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("type", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (!in_array($fields["type"], array("nid", "pid", "hid", "aid", "apid", "cid", "vid"))) { //check comment to news, horse, photo
		aerr(array("Ошибка."));
	}

	/* getting comment */
	$db = new db;
	$comments = $db->getAll("SELECT comments.*,
									avatar,
									CONCAT(fname, ' ',lname) as fio,
									(SELECT COUNT(id) FROM likes WHERE cid = comments.id) as likes_cnt,
									(SELECT COUNT(id) FROM likes WHERE cid = comments.id AND o_uid = ?i) as is_liked  
							FROM comments, users 
							WHERE comments.?n = ?i
							AND users.id = comments.o_uid
							ORDER BY time", $_SESSION["user_id"], $fields["type"], $fields["id"]);
	/* render it */
	$tmpl = new templater;
	$tmpl->assign("user", array("id" => $_SESSION["user_id"]));
	foreach($comments as &$comment) {
		$tmpl->assign("comment", $comment);
		$comment = $tmpl->fetch("iterations/comment.tpl");
	}
	aok($comments);
}

function api_comments_edit_form() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("cid"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* get comment */
	$db = new db;
	$comment = $db->getRow("SELECT comments.id, text, avatar 
							FROM comments, users
							WHERE comments.id = ?i
							AND users.id = comments.o_uid", $fields["cid"]);

	/* render it */
	$params = array(
		"loaded_comment" => $comment["text"],
		"c_key" => "cid",
		"c_value" => $comment["id"],
		"user_avatar" => $comment["avatar"]
	);
	$rendered = template_render_to_var($params, "modules/comment-form.tpl");
	aok(array($rendered));	
}

function api_comments_edit() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("type", "id", "text"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (!in_array($fields["type"], array("cid"))) { //only comment id
		aerr(array("Ошибка."));
	}

	$db = new db;
	/* update comment */
	$db->query("UPDATE comments SET text = ?s WHERE id = ?i AND o_uid = ?i", $fields["text"], $fields["id"], $_SESSION["user_id"]);
	/* get update comment */
	$comment = $db->getRow("SELECT comments.*,
									avatar,
									CONCAT(fname, ' ',lname) as fio,
									(SELECT COUNT(id) FROM likes WHERE cid = comments.id) as likes_cnt,
									(SELECT COUNT(id) FROM likes WHERE cid = comments.id AND o_uid = ?i) as is_liked  
							FROM comments, users 
							WHERE comments.id = ?i
							AND users.id = comments.o_uid", $_SESSION["user_id"], $fields["id"]);
	/* Render it */
	$params = array(
		"comment" => $comment,
		"user" => array("id" => $_SESSION["user_id"])
	);
	$rendered = template_render_to_var($params, "iterations/comment.tpl");
	aok(array($rendered));
}

