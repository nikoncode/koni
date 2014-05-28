<?php
/* this is 'gallery' api unit */

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/gallery.php");
include_once (CORE_DIR . "core_includes/templates.php");

function api_gallery_photo_info() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Getting photo info */
	$db = new db;
	$info = $db->getRow("SELECT id,
								full,
								time,
								album_id,
								`desc`,
								o_uid as user_id,
								(SELECT name FROM albums WHERE id =  album_id) as album_name,
								(SELECT CONCAT(fname, ' ', lname) FROM users WHERE id = o_uid) as user_name,
								(SELECT COUNT(id) FROM comments WHERE pid = gallery_photos.id) as comments_cnt,
								(SELECT avatar FROM users WHERE id = ?i) as user_avatar
						FROM gallery_photos WHERE id = ?i", $_SESSION["user_id"], $fields["id"]);

	if ($info === NULL) {
		aerr(array("Такой фотографии больше не существует."));
	} else {
		$info["own"] = ($_SESSION["user_id"] == $info["user_id"]);

		/* Getting comments to photo */
		$comments = $db->getAll("SELECT c.*,
										concat(fname,' ',lname) as fio,
										avatar,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked 
								FROM (
									SELECT * FROM comments WHERE pid = ?i ORDER BY time DESC LIMIT 3
								) c, users
								WHERE o_uid = users.id
								ORDER BY time ASC", $_SESSION["user_id"], $info["id"]);
		
		/* Render comments to var */
		$info["comments"] = template_render_to_var(array(
			"comments" => $comments, 
			"comments_cnt" => $info["comments_cnt"],
			"user_avatar" => $info["user_avatar"],
			"c_key" => "pid",
			"c_value" => $info["id"],
			"user" => array("id" => $_SESSION["user_id"])
		), "iterations/comments_block.tpl");

		aok($info);
	}
}

function api_gallery_photo_delete() { 
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	/* getting all photos */
	$image = $db->GetRow("SELECT preview, full FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	if ($image === NULL) {
		aerr(array("Фотография не может быть удалена."));
	} else {
		/* delete them */
		$db->query("DELETE FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
		others_delete_file(WEB_ROOT_DIR . $image["preview"]);
		others_delete_file(WEB_ROOT_DIR . $image["full"]);
	}
	aok(array("Фотография была удалена."));
}

function api_gallery_create_album() {
	/* Validate data */
	validate_fields($fields, $_POST, array("desc", "att"), array("name"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Create album */
	$db = new db;
	$fields["o_uid"] = $_SESSION["user_id"];	
	$db->query("INSERT INTO albums (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
	$id = $db->getOne("SELECT LAST_INSERT_ID() FROM albums");
	aok(array($id), "/gallery.php");
}

function api_gallery_upload_photo() {
	/* Validate data */
	validate_fields($fields, $_GET, array(), array("album_id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking path */
	$path = $_SESSION["user_id"] . "/album_" . $fields["album_id"] . "/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$preview_img = $path . $filename . "_preview.jpg";
	$full_img = $path . $filename . ".jpg";
	$result = gallery_upload_photo($_FILES, "gallery", $full_img, 1000, 1000, true, $preview_img);
	
	/* Insert to db */
	if ($result === true) {
		$db = new db;
		$db->query("INSERT INTO gallery_photos (full, preview, album_id, o_uid) VALUES (?s, ?s, ?i, ?i);", 
			"/uploads/" . $full_img, 
			"/uploads/" . $preview_img, 
			$fields["album_id"], 
			$_SESSION["user_id"]
		);
		$photo_id = $db->getOne("SELECT LAST_INSERT_ID() FROM gallery_photos");
		aok(array(
				"id" => $photo_id,
				"preview" => "/uploads/" . $preview_img
		));	
	} else {
		aerr($result);
	} 
}

function api_gallery_update_description() { //TO-DO: optimize
	/* Validate data */
	validate_fields($fields, $_POST, array("desc"), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Insert description */
	$db = new db;
	if (!empty($fields["desc"])) {
		foreach ($fields["desc"] as $id => $desc) {
			$db->query("UPDATE gallery_photos SET `desc` = ?s WHERE id = ?i AND o_uid = ?i;", $desc, $id, $_SESSION["user_id"]); //WARN: query in cycle
		}
	}

	aok(array("Описания обновлены."));

}

function api_gallery_album_info() {//GUEST MAY VIEW ALBUM INFO
	/* validate data*/
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Getting and returning info*/
	$db = new db;
	$info = $db->getRow("SELECT id, name, `desc` FROM albums WHERE id = ?i;", $fields["id"]);
	if ($info == NULL) {
		aerr(array("Запрашиваемый альбом не найден."));
	} else {
		aok($info);
	}
}

function api_gallery_album_update() {
	/* validate data*/
	validate_fields($fields, $_POST, array("desc"), array("id", "name"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* updating info */
	$db = new db;
	$id = $fields["id"];
	unset($fields["id"]);
	$db->query("UPDATE albums SET ?u WHERE id = ?i AND o_uid = ?i;", $fields, $id, $_SESSION["user_id"]);
	aok(array("Информация обновлена успешно."), "/gallery-album.php?id=" . $id);	
}

function api_gallery_album_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* delete album with all photos */
	$db = new db;
	$photos = $db->getAll("SELECT preview, full FROM gallery_photos WHERE o_uid = ?i AND album_id = ?i;", $_SESSION["user_id"], $fields["id"]);
	if (!empty($photos)) {
		foreach ($photos as $photo) {
			others_delete_file(WEB_ROOT_DIR . $photo["preview"]);
			others_delete_file(WEB_ROOT_DIR . $photo["full"]);
		}
		$db->query("DELETE FROM gallery_photos WHERE o_uid = ?i AND album_id = ?i;", $_SESSION["user_id"], $fields["id"]);
		$db->query("DELETE FROM albums WHERE id = ?i AND o_uid = ?i;", $fields["id"], $_SESSION["user_id"]);
	}
	aok(array("Альбом успешно удален."), "/gallery.php");
}	

function api_gallery_upload_avatar() {
	if (!session_check()) { //hook to initialize session & check auth
		aerr(array("Нужно войти."));
	}

	/* Checking path */
	$path = $_SESSION["user_id"] . "/avatars/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$full_img = $path . $filename . ".jpg";
	$result = gallery_upload_photo($_FILES, "avatar", $full_img, 500, 500);
	
	/* Insert to db */
	if ($result === true) {
		aok(array(
				"avatar" => "/uploads/" . $full_img
		));	
	} else {
		aerr($result);
	} 
}

function api_gallery_upload_avatar_crop() {
	/* validate fields */
	validate_fields($fields, $_POST, array(  //x1, y1 not required but 0 is empty
		"x1",
		"y1"
	), array( 
		"x2",  
		"y2", 
		"avatar"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Crop & resize image */
	$img = new \abeautifulsite\SimpleImage(WEB_ROOT_DIR . $fields["avatar"]);
	$img->crop(
		abs((int)$fields["x1"]),
		abs((int)$fields["y1"]),
		abs((int)$fields["x2"]),
		abs((int)$fields["y2"])
	)->resize(200,200)->save(WEB_ROOT_DIR . $fields["avatar"]);

	/* update in db */
	$db = new db;
	$db->query("UPDATE users SET avatar = ?s WHERE id = ?i", $fields["avatar"], $_SESSION["user_id"]);

	aok(array(
		"avatar" => $fields["avatar"]
	));
}