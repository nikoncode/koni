<?php
/* this is 'gallery' api unit */

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/gallery.php");

function api_photo_info() { //GUEST MAY VIEW PHOTO
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

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
		aok($info);
	}
}

function api_photo_delete() { //TO-DO: file delete
	if (!check()) {
		aerr(array("Необходимо войти."));
	}

	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$db->query("DELETE FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
	aok(array("Фотография была удалена."));
}

function api_create_album() {
	if (!check()) {
		aerr(array("Необходимо войти."));
	}

	validate_fields($fields, $_POST, array("desc"), array("name"), array(), $errors);

	if (!empty($errors))
		aerr($errors);

	$db = new db;
	$fields["o_uid"] = $_SESSION["user_id"];	
	$db->query("INSERT INTO albums (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
	aok(array("Альбом успешно создан."), "/gallery.php");
}

function api_upload_gallery_photo() {
	if (!check()) {
		aerr(array("Необходимо войти."));
	}

	validate_fields($fields, $_GET, array(), array("album_id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$path = $_SESSION["user_id"] . "/album_" . $fields["album_id"] . "/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	$preview_img = $path . $filename . "_preview.jpg";
	$full_img = $path . $filename . ".jpg";
	$result = upload_photo($_FILES, "gallery", $full_img, 1000, 1000, true, $preview_img);

	$db = new db;
	$db->query("INSERT INTO gallery_photos (full, preview, album_id, o_uid) VALUES (?s, ?s, ?i, ?i);", 
		"/uploads/" . $full_img, 
		"/uploads/" . $preview_img, 
		$fields["album_id"], 
		$_SESSION["user_id"]
	);
	$photo_id = $db->getOne("SELECT LAST_INSERT_ID() FROM gallery_photos");

	if ($result === true) {
		aok(array(
				"id" => $photo_id,
				"preview" => "/uploads/" . $preview_img
			));
	} else {
		aerr($result);
	}  //TO-DO: Check
}

function api_gallery_update_description() { //TO-DO: optimize
	if (!check()) {
		aerr(array("Необходимо войти."));
	}
	validate_fields($fields, $_POST, array("desc"), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	foreach ($fields["desc"] as $id => $desc) {
		$db->query("UPDATE gallery_photos SET `desc` = ?s WHERE id = ?i AND o_uid = ?i;", $desc, $id, $_SESSION["user_id"]);
	}
	//print_r($fields["desc"]);
	aok(array("Описания обновлены."));

}