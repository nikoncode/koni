<?php
/* this is 'gallery' api unit */

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/gallery.php");

function api_photo_info() { //GUEST MAY VIEW PHOTO
	validate_fields($fields, $_POST, array("id"), array(), array(), $errors);

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
	
	if (!file_exists(UPLOAD_DIR . $path))
		mkdir(UPLOAD_DIR . $path, 0777, true);

	$path  .= $filename;
	$result = upload_photo($_FILES, "gallery", $path . $filename . ".jpg", 1000, 1000, true, $path . $filename . "_prev.jpg");
	if ($result === true) {
		aok(array("Фото загружено."), "/uploads/" . $path . $filename . "_prev.jpg");
	} else {
		aerr($result);
	}
}