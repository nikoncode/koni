<?php
/* depencies */
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once(LIBRARIES_DIR . "smarty/smarty.php");

function api_news_add() {
	/* validate data */
	validate_fields($fields, $_POST, array("text", "album_id"), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* filter empty news */
	if (!isset($fields["text"]) && !isset($fields["album_id"])) {
		aerr(array("Новость должна содержать либо текст, либо вложения."));
	}

	$db = new db;
	/* filter news without image and text */
	$att_count = $db->getOne("SELECT COUNT(id) FROM gallery_photos WHERE album_id = ?i", $fields["album_id"]);
	if (!isset($fields["text"]) && $att_count == 0) {
		aerr(array("Новость должна содержать либо текст, либо вложения."));	
	}
	$fields["o_uid"] = $_SESSION["user_id"];

	/* insert to db */	
	$db->query("INSERT INTO news (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);

	/* get news */
	$post = $db->getRow("SELECT CONCAT(fname,' ',lname) as fio,
							news.id,
							avatar,
							text,
							attachments,
							time,
							o_uid,
							0 as likes_cnt,
							0 as is_liked,
							0 as comments_cnt,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, users
					WHERE o_uid = ?i 
					AND news.id = LAST_INSERT_ID()
					AND users.id = o_uid", $_SESSION["user_id"]);
	$post["photos"] = others_make_photo_array($post["photos"], $post["photo_ids"]);
	
	/* render it */
	$tmpl = new templater;
	$params = array(
		"user" => array("id" => $_SESSION["user_id"], "avatar" => $post["avatar"]),
		"news" => array($post)
	);
	$rendered = template_render_to_var($params, "iterations/news_block.tpl");
	aok(array($rendered));
}

function api_news_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	/* select attachment album id */
	$album = $db->getOne("SELECT album_id FROM news WHERE o_uid = ?i AND id = ?i", $_SESSION["user_id"], $fields["id"]);
	/* delete news & comments */
	$db->query("DELETE FROM news WHERE o_uid = ?i AND id = ?i",  $_SESSION["user_id"], $fields["id"]);
	$db->query("DELETE FROM comments WHERE nid = ?i", $fields["id"]);
	if ($album != NULL) {
		/* getting all photos */
		$photos = $db->getAll("SELECT preview, full FROM gallery_photos WHERE o_uid = ?i AND album_id = ?i;", $_SESSION["user_id"], $album);
		/* remove photos */
		if (!empty($photos)) {
			foreach ($photos as $photo) {
				others_delete_file(WEB_ROOT_DIR . $photo["preview"]);
				others_delete_file(WEB_ROOT_DIR . $photo["full"]);
			}
		}
		/* delete all photos from db & album */
		$db->query("DELETE FROM gallery_photos WHERE o_uid = ?i AND album_id = ?i;", $_SESSION["user_id"], $album);
		$db->query("DELETE FROM albums WHERE o_uid = ?i AND id = ?i AND att = 1", $_SESSION["user_id"], $album);
	}
	aok(array("Новость удалена."));
}

function api_news_edit_form() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* select news and photos */
	$db = new db;
	$news = $db->getRow("SELECT *
						FROM news 
						WHERE id = ?i
						AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	if ($news["album_id"] != 0) {
		$news["photos"] = $db->getAll("SELECT id, preview FROM gallery_photos WHERE album_id = ?i AND o_uid = ?i", $news["album_id"], $_SESSION["user_id"]);
	}	
	
	/* render it */
	$params = array(
		"n" => $news
	);
	$rendered = template_render_to_var($params, "modules/news-form.tpl");
	aok(array($rendered));
}

function api_news_edit() {
	/* validate data */
	validate_fields($fields, $_POST, array("text", "album_id"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}	

	$db = new db;
	/* not add empty news */
	if (!isset($fields["album_id"]) && !isset($fields["text"])) {
		aerr(array("Новость должна содержать либо текст, либо вложения."));	
	}

	/* filter news without image and text */
	$att_count = $db->getOne("SELECT COUNT(id) FROM gallery_photos WHERE album_id = ?i", $fields["album_id"]);
	if ($att_count == 0 && !isset($fields["text"])) {
		aerr(array("Новость должна содержать либо текст, либо вложения."));	
	}

	/* if isset images make text empty */
	if (!isset($fields["text"])) {
		$fields["text"] = "";
	}

	/* update news */
	$db->query("UPDATE news SET ?u WHERE o_uid = ?i AND id = ?i", $fields, $_SESSION["user_id"], $fields["id"]);
	/* get updated news */
	$news = $db->getRow("SELECT CONCAT(fname,' ',lname) as fio,
								news.id,
								avatar,
								text,
								attachments,
								time,
								o_uid,
								(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
								(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = users.id) as is_liked,
								(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
								(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
						FROM news, users
						WHERE o_uid = ?i 
						AND news.id = ?i
						AND users.id = o_uid", $_SESSION["user_id"], $fields["id"]);
	$news["photos"] = others_make_photo_array($news["photos"], $news["photo_ids"]);

	/* render it */
	$params = array(
		"post" => $news,
		"user" => array("id" => $_SESSION["user_id"])
	);
	$rendered = template_render_to_var($params, "iterations/post.tpl");
	aok(array($rendered));	
}

function api_news_extra() {
	/* validate data */
	validate_fields($fields, $_POST, array("feed"), array("id", "loaded"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}	

	/* render it */
	$feed = !empty($fields["feed"]);
	$params = array(
		"news" => news_wall_build(array($fields["id"]), $fields["loaded"], 5, $feed),
		"user" => array("id" => $_SESSION["user_id"]) //user_avatar init
	);
	$rendered = template_render_to_var($params, "iterations/news_block.tpl");
	aok(array($rendered));
}