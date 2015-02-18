<?php
/* depencies */
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once(LIBRARIES_DIR . "smarty/smarty.php");

function api_news_add() {
	/* validate data */
	validate_fields($fields, $_POST, array("text", "album_id"), array("type", "id"), array(), $errors);

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
	if ($fields["type"] == "user") {
		if ($fields["id"] != $_SESSION["user_id"]) {
			aerr(array("Это не вы"));
		}
	} else if ($fields["type"] == "club") {
		$owner_id = $db->getOne("SELECT o_uid FROM clubs WHERE id = ?i", $fields["id"]);
		if ($owner_id != $_SESSION["user_id"]) {
			aerr(array("не можете вы так."));
		} else {
			$fields["o_cid"] = $fields["id"];
		}
        $users = $db->getAll("SELECT id FROM users WHERE cid = ?i",$fields["id"]);
        foreach($users as $row){
            $message = 'В клубе добавлена новость';
            api_add_notice($row['id'],$fields["id"],$message,'club');
        }
	} else {
		aerr(array("Тип неопознан"));
	}
	$type = $fields["type"];
	unset($fields["type"]);
	unset($fields["id"]);

	/* insert to db */	
	$db->query("INSERT INTO news SET ?u;", $fields);
	$id = $db->getOne("SELECT LAST_INSERT_ID() FROM news");

	/* get news */
	$post = news_get_single($type, $id);

	$post["photos"] = others_make_photo_array($post["photos"], $post["photo_ids"]);
	
	/* render it */
	$tmpl = new templater;
	$params = array(
		"user" => array("id" => $_SESSION["user_id"], "avatar" => $post["owner_avatar"]),
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

	if ($news["o_uid"] != $_SESSION["user_id"]) {
		aerr(array("Вы не можете редактировать чужую новость."));
	}

	if ($news["album_id"] != 0) {
		$news["photos"] = $db->getAll("SELECT id, preview FROM gallery_photos WHERE album_id = ?i AND o_uid = ?i", $news["album_id"], $_SESSION["user_id"]);
	}

	if ($news["o_cid"] != 0) {
		$type = "club";
	} else {
		$type = "user";
	}
	
	/* render it */
	$params = array(
		"n" => $news,
		"owner_type" => $type,
		"owner_id" => $news["id"]
	);
	$rendered = template_render_to_var($params, "modules/news-form.tpl");
	aok(array($rendered));
}

function api_news_edit() {
	/* validate data */
	validate_fields($fields, $_POST, array("text", "album_id"), array("type", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}	

	$db = new db;
	/* not add empty news */
	if (!isset($fields["album_id"]) && !isset($fields["text"])) {
		aerr(array("Новость должна содержать либо текст, либо вложения."));	
	}

	if (!in_array($fields["type"], array("user", "club"))) {
		aerr(array("Некорректный тип."));
	}
	$type = $fields["type"];
	unset($fields["type"]);

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
	$news = news_get_single($type, $fields["id"]);
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
	validate_fields($fields, $_POST, array(), array("id", "loaded", "type"), array(), $errors,false);

	if (!empty($errors)) {
		aerr($errors);
	}	


	if (!in_array($fields["type"], array("user", "club", "feed"))) {
		aerr(array("Некорректный тип."));
	}

	/* render it */
	$params = array(
		"news" => news_wall_build($fields["type"], $fields["id"], $fields["loaded"], 5),
		"user" => array("id" => $_SESSION["user_id"]) //user_avatar init
	);
	$rendered = template_render_to_var($params, "iterations/news_block.tpl");
	aok(array($rendered));
}