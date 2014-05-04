<?php
/* this is 'gallery' api unit */

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/gallery.php");

function api_gallery_photo_info() { //GUEST MAY VIEW PHOTO
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors, false);

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
								(SELECT CONCAT(fname, ' ', lname) FROM users WHERE id = o_uid) as user_name
						FROM gallery_photos WHERE id = ?i", $fields["id"]);

	if ($info === NULL) {
		aerr(array("Такой фотографии больше не существует."));
	} else {
		if (session_check()) {
			$info["own"] = ($_SESSION["user_id"] == $info["user_id"]);
		} else {
			$info["own"] = 0;
		}
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
	$image = $db->GetRow("SELECT preview, full FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	if ($image === NULL) {
		aerr(array("Фотография не может быть удалена."));
	} else {
		$db->query("DELETE FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
		unlink(WEB_ROOT_DIR . $image["preview"]);
		unlink(WEB_ROOT_DIR . $image["full"]);
	}
	aok(array("Фотография была удалена."));
}

function api_gallery_create_album() {
	/* Validate data */
	validate_fields($fields, $_POST, array("desc"), array("name"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Create album */
	$db = new db;
	$fields["o_uid"] = $_SESSION["user_id"];	
	$db->query("INSERT INTO albums (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
	aok(array("Альбом успешно создан."), "/gallery.php");
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