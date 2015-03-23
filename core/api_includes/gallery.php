<?php
/* this is 'gallery' api unit */

/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/gallery.php");
include_once (CORE_DIR . "core_includes/templates.php");

function api_gallery_photo_info() {
	/* validate data */
	validate_fields($fields, $_POST, array("video"), array("id"), array(), $errors,false);
    session_check();
	if (!empty($errors)) {
		aerr($errors);
	}

	/* Getting photo info */
	$db = new db;

    if(isset($fields['video']) && $fields['video'] > 0) {
        $comment_key = 'vid';
        $info = $db->getRow("SELECT id,
								video,
								time,
								album_club_id,
								`desc`,
								o_uid as user_id,
								(SELECT name FROM albums_clubs WHERE id =  gallery_video.album_club_id) as album_club_name,
								(SELECT CONCAT(fname, ' ', lname) FROM users WHERE id = o_uid) as user_name,
								(SELECT COUNT(id) FROM comments WHERE vid = gallery_video.id) as comments_cnt,
								(SELECT avatar FROM users WHERE id = ?i) as user_avatar
						FROM gallery_video WHERE id = ?i", $_SESSION["user_id"], $fields["id"]);
    }else{
        $info = $db->getRow("SELECT id,
								full,
								time,
								album_id,
								album_club_id,
								`desc`,
								o_uid as user_id,
								(SELECT name FROM albums WHERE id =  album_id) as album_name,
								(SELECT name FROM albums_clubs WHERE id =  album_club_id) as album_club_name,
								(SELECT CONCAT(fname, ' ', lname) FROM users WHERE id = o_uid) as user_name,
								(SELECT COUNT(id) FROM comments WHERE pid = gallery_photos.id) as comments_cnt,
								(SELECT avatar FROM users WHERE id = ?i) as user_avatar
						FROM gallery_photos WHERE id = ?i", $_SESSION["user_id"], $fields["id"]);
        $comment_key = 'pid';
    }


	if ($info === NULL) {
		aerr(array("Такой фотографии больше не существует."));
	} else {
        $user = template_get_short_user_info($_SESSION["user_id"]);
		$info["own"] = ($_SESSION["user_id"] == $info["user_id"] || $user['admin'] > 0)?1:0;
        if($info['album_club_id'] > 0) $info['album_name'] = $info['album_club_name'];
		/* Getting comments to photo */
		$comments = $db->getAll("SELECT c.*,
										concat(fname,' ',lname) as fio,
										avatar,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
										(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked 
								FROM (
									SELECT * FROM comments WHERE ".$comment_key." = ?i ORDER BY time DESC LIMIT 3
								) c, users
								WHERE o_uid = users.id
								ORDER BY time ASC", $_SESSION["user_id"], $info["id"]);
		
		/* Render comments to var */
		$info["comments"] = template_render_to_var(array(
			"comments" => $comments, 
			"comments_cnt" => $info["comments_cnt"],
			"user_avatar" => $info["user_avatar"],
			"c_key" => $comment_key,
			"c_value" => $info["id"],
			"user" => array("id" => $_SESSION["user_id"])
		), "iterations/comments_block.tpl");

		aok($info);
	}
}

function api_gallery_photo_delete() { 
	/* validate data */
	validate_fields($fields, $_POST, array("video"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	/* getting all photos */
	if(isset($fields['video']) && $fields['video'] > 0){
        $image = $db->GetRow("SELECT video FROM gallery_video WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
        if ($image === NULL) {
            aerr(array("Видео не может быть удалено."));
        } else {
            /* delete them */
            $db->query("DELETE FROM gallery_video WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
        }
        aok(array("Видео было удалено."));
    }else{
        $user = template_get_short_user_info($_SESSION["user_id"]);
        if($user['admin'] == 1){
            $image = $db->GetRow("SELECT preview, full FROM gallery_photos WHERE id = ?i", $fields["id"]);
            if ($image === NULL) {
                aerr(array("Фотография не может быть удалена."));
            } else {
                /* delete them */
                $db->query("DELETE FROM gallery_photos WHERE id = ?i", $fields["id"]);
                others_delete_file(WEB_ROOT_DIR . $image["preview"]);
                others_delete_file(WEB_ROOT_DIR . $image["full"]);
            }
        }else{
            $image = $db->GetRow("SELECT preview, full FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
            if ($image === NULL) {
                aerr(array("Фотография не может быть удалена."));
            } else {
                /* delete them */
                $db->query("DELETE FROM gallery_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
                others_delete_file(WEB_ROOT_DIR . $image["preview"]);
                others_delete_file(WEB_ROOT_DIR . $image["full"]);
            }
        }

        aok(array("Фотография была удалена."));
    }

}

function api_adv_photo_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	/* getting all photos */
	$image = $db->GetRow("SELECT preview, full FROM adv_photos WHERE id = ?i AND o_uid = ?i", $fields["id"], $_SESSION["user_id"]);
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
	validate_fields($fields, $_POST, array("desc", "att", "club_id","comp_id","type_album","is_event","event"), array("name"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Create album */
	$db = new db;

    if(isset($fields['club_id']) && $fields['club_id'] > 0 || isset($fields['comp_id']) && $fields['comp_id'] > 0){
        $fields["c_uid"] = $fields['club_id'];
        unset($fields['club_id']);
        if(isset($fields['comp_id']) && $fields['comp_id'] > 0) unset($fields["c_uid"]);
        $db->query("INSERT INTO albums_clubs (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
        $id = $db->getOne("SELECT LAST_INSERT_ID() FROM albums");
        aok(array($id), "/club.php?id=".$fields["c_uid"]);
    }else{
        $fields["o_uid"] = $_SESSION["user_id"];
        unset($fields['club_id']);
        if(!isset($fields['is_event'])){
            unset($fields['event']);
        }else{
            unset($fields['is_event']);
        }
        $db->query("INSERT INTO albums (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
        $id = $db->getOne("SELECT LAST_INSERT_ID() FROM albums");
        aok(array($id), "/gallery.php");
    }


}

function api_gallery_add_video() {
	/* Validate data */
	validate_fields($fields, $_POST, array("desc"), array("video","club_id","album_club_id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Create album */
	$db = new db;
    $YoutubeCode = $fields['video'];
    preg_match('#(\.be/|/embed/|/v/|/watch\?v=)([A-Za-z0-9_-]{5,11})#', $YoutubeCode, $matches);
    if(isset($matches[2]) && $matches[2] != ''){
        $fields['video'] = $matches[2];
    }else{
        aerr(array("Мы не смогли обработать вашу ссылку"));
    }
    $club_id = $fields['club_id'];
    unset($fields['club_id']);
    $fields['o_uid'] = $_SESSION['user_id'];
    $fields['time'] = date('Y-m-d H:i:s');
    $db->query("INSERT INTO gallery_video (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
        $id = $db->getOne("SELECT LAST_INSERT_ID() FROM albums");
        aok(array($id), "/club.php?id=".$club_id."&album=".$fields['album_club_id']);


}

function api_gallery_upload_photo() {
	/* Validate data */
	validate_fields($fields, $_GET, array("album_id","club_id","comp_id"), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
    $type_album = 'album_id';
	if(!isset($fields["album_id"])){ //if not set create new
		$db->query("INSERT INTO albums (`name`,`att`,`o_uid`) VALUES (?s,?i,?i);", "Без альбома", 1, $_SESSION['user_id']);
        $fields["album_id"] = $db->insertId();
    } else { //if set check access
        if(isset($fields["club_id"])){
            $id = $db->getOne("SELECT id FROM albums_clubs WHERE c_uid = ?i AND id = ?i", $fields["club_id"], $fields["album_id"]);
            $type_album = 'album_club_id';
        }elseif(isset($fields["comp_id"])){
            $id = $db->getOne("SELECT id FROM albums_clubs WHERE comp_id = ?i AND id = ?i", $fields["comp_id"], $fields["album_id"]);
            $type_album = 'album_club_id';
        }else{
            $id = $db->getOne("SELECT id FROM albums WHERE o_uid = ?i AND id = ?i", $_SESSION["user_id"], $fields["album_id"]);
        }
    	if ($id == NULL) {
    		aerr(array("Вы не можете загрузить фото в этот альбом, пожалуйста обновите страницу и попробуйте еще."));
    	}
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
		$db->query("INSERT INTO gallery_photos (full, preview, ".$type_album.", o_uid) VALUES (?s, ?s, ?i, ?i);",
			"/uploads/" . $full_img, 
			"/uploads/" . $preview_img, 
			$fields["album_id"], 
			$_SESSION["user_id"]
		);
		$photo_id = $db->getOne("SELECT LAST_INSERT_ID() FROM gallery_photos");
		aok(array(
				"id" => $photo_id,
				"album_id" => $fields["album_id"],
				"preview" => "/uploads/" . $preview_img
		));	
	} else {
		aerr($result);
	} 
}

function api_adv_upload_photo() {
    /* Validate data */
    validate_fields($fields, $_GET, array(), array(), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }

    /* Checking path */
    $path = $_SESSION["user_id"] . "/adv/";
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
        $db->query("INSERT INTO adv_photos (full, preview, adv_id, o_uid) VALUES (?s, ?s, ?i, ?i);",
            "/uploads/" . $full_img,
            "/uploads/" . $preview_img,
            0,
            $_SESSION["user_id"]
        );
        $photo_id = $db->getOne("SELECT LAST_INSERT_ID() FROM adv_photos");
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
	validate_fields($fields, $_POST, array("club_id"), array("id"), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Getting and returning info*/
	$db = new db;
    $table = (isset($fields['club_id']) && $fields['club_id'] > 0)?'albums_clubs':'albums';
    unset($fields["club_id"]);
	$info = $db->getRow("SELECT * FROM ".$table." WHERE id = ?i;", $fields["id"]);
	if ($info == NULL) {
		aerr(array("Запрашиваемый альбом не найден."));
	} else {
		aok($info);
	}
}

function api_gallery_album_update() {
	/* validate data*/
	validate_fields($fields, $_POST, array("desc","club_id","is_event","event","comp_id"), array("id", "name"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* updating info */
	$db = new db;
	$id = $fields["id"];
	unset($fields["id"]);
    if(isset($fields['club_id']) && $fields['club_id'] > 0){
        $club_id = $fields['club_id'];
        unset($fields['club_id']);
        $db->query("UPDATE albums_clubs SET ?u WHERE id = ?i AND c_uid = ?i;", $fields, $id, $club_id);
    }elseif(isset($fields['comp_id']) && $fields['comp_id'] > 0){
        $comp_id = $fields['comp_id'];
        unset($fields['club_id']);
        unset($fields['comp_id']);
        $db->query("UPDATE albums_clubs SET ?u WHERE id = ?i AND comp_id = ?i;", $fields, $id, $comp_id);
    }else{
        if(!isset($fields['is_event'])){
            unset($fields['event']);
        }else{
            unset($fields['is_event']);
        }
        $db->query("UPDATE albums SET ?u WHERE id = ?i AND o_uid = ?i;", $fields, $id, $_SESSION["user_id"]);
    }

	aok(array("Информация обновлена успешно."), "/gallery-album.php?id=" . $id);	
}

function api_gallery_album_delete() {
	/* validate data */
	validate_fields($fields, $_POST, array("club_id"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* delete album with all photos */
	$db = new db;
    $type = (isset($fields['club_id']) && $fields['club_id'] > 0)?'album_club_id':'album_id';
	$photos = $db->getAll("SELECT preview, full FROM gallery_photos WHERE o_uid = ?i AND ".$type." = ?i;", $_SESSION["user_id"], $fields["id"]);
	if (!empty($photos)) {
		foreach ($photos as $photo) {
			others_delete_file(WEB_ROOT_DIR . $photo["preview"]);
			others_delete_file(WEB_ROOT_DIR . $photo["full"]);
		}
		$db->query("DELETE FROM gallery_photos WHERE o_uid = ?i AND ".$type." = ?i;", $_SESSION["user_id"], $fields["id"]);
	}
    if(isset($fields['club_id']) && $fields['club_id'] > 0){
        $db->query("DELETE FROM albums_clubs WHERE id = ?i AND c_uid = ?i;", $fields["id"], $fields['club_id']);
        $db->query("DELETE FROM gallery_video WHERE album_club_id = ?i;", $fields["id"]);
    }elseif(isset($fields['comp_id']) && $fields['comp_id'] > 0){
        $db->query("DELETE FROM albums_clubs WHERE id = ?i AND comp_id = ?i;", $fields["id"], $fields['comp_id']);
        $db->query("DELETE FROM gallery_video WHERE album_club_id = ?i;", $fields["id"]);
    }else{
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
        "avatar" => $fields["avatar"] . "?nocache=" . time()
    ));
}

function api_club_upload_avatar_crop() {
	/* validate fields */
	validate_fields($fields, $_POST, array(  //x1, y1 not required but 0 is empty
		"x1",
		"y1"
	), array(
		"x2",
		"y2",
		"id",
		"avatar"
	), array(), $errors);
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
    $db->query("UPDATE clubs SET avatar = ?s WHERE o_uid = ?i AND id = ?i", $fields["avatar"], $_SESSION["user_id"],$fields['id']);

    aok(array(
        "avatar" => $fields["avatar"] . "?nocache=" . time()
    ));
}

function api_horse_upload_avatar_crop() {
    /* validate fields */
    validate_fields($fields, $_POST, array(  //x1, y1 not required but 0 is empty
        "x1",
        "y1"
    ), array(
        "x2",
        "y2",
        "id",
        "avatar"
    ), array(), $errors);
    /* Crop & resize image */
    $img = new \abeautifulsite\SimpleImage(WEB_ROOT_DIR . $fields["avatar"]);
    $img->crop(
        abs((int)$fields["x1"]),
        abs((int)$fields["y1"]),
        abs((int)$fields["x2"]),
        abs((int)$fields["y2"])
    )->resize(200,200)->save(WEB_ROOT_DIR . $fields["avatar"]);

    aok(array(
        "avatar" => $fields["avatar"] . "?nocache=" . time()
    ));
}

function api_gallery_change_photo_album() {
	/* validate data */
	validate_fields($fields, $_POST, array("club_id"), array("album","photo_id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* delete album with all photos */
	$db = new db;
    $table = (isset($fields['club_id']) && $fields['club_id'] > 0)?'album_club_id':'album_id';
    $photo_id = $db->getOne("SELECT id FROM gallery_photos WHERE o_uid = ?i AND id = ?i;", $_SESSION["user_id"], $fields['photo_id']);
    if($photo_id) $db->query("UPDATE gallery_photos SET ".$table." = ".intval($fields['album'])." WHERE o_uid = ?i AND id = ?i;", $_SESSION["user_id"], $fields['photo_id']);

    aok(array("Альбом успешно изменен."), "/gallery.php");
}

function api_gallery_club_upload_avatar() {
	validate_fields($fields, $_GET, array(), array("id"), array(), $fields);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking path */
	$path = $fields["id"] . "_cl/avatars/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$full_img = $path . $filename . ".jpg";
	$result = gallery_upload_photo($_FILES, "avatar", $full_img, 500, 500);
	
	/* Insert to db */
	if ($result === true) {
		$db = new db;
		$db->query("UPDATE clubs SET avatar = ?s WHERE o_uid = ?i AND id = ?i", "/uploads/" . $full_img, $_SESSION["user_id"], $fields["id"]);
		aok(array(
				"avatar" => "/uploads/" . $full_img
		));	
	} else {
		aerr($result);
	} 
}

function api_file_club_upload() {
	validate_fields($fields, $_GET, array(), array("id"), array(), $fields);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking path */
	$path = $fields["id"] . "_cl/files/";
	$filename = md5(md5(time()) . rand());

	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$full_img = $path . $filename;
	$result = gallery_upload_file($_FILES, "avatar", $full_img);

	/* Insert to db */
	if (isset($result['filename'])) {
		$db = new db;
        $db->query("INSERT INTO comp_files (`cid`,`file`,`ext`,`path`) VALUES (?i,?s,?s,?s);", $fields['id'], $result['filename'], $result['ext'],$full_img);
        $file_id = $db->insertId();
		aok(array(
				"file" => "/uploads/" . $full_img.'.'.$result['ext'],
				"file_id" => $file_id,
				"filename" => $result['filename'],
				"ext" => $result['ext'],
		));
	} else {
		aerr($result);
	}
}

function api_gallery_club_upload_adv() {
	validate_fields($fields, $_GET, array(), array("id"), array(), $fields);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking path */
	$path = $fields["id"] . "_cl/adv/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$full_img = $path . $filename . ".jpg";
	$result = gallery_upload_photo($_FILES, "adv", $full_img, 500, 500);
	
	if ($result === true) {
		aok(array(
				"adv" => "/uploads/" . $full_img
		));	
	} else {
		aerr($result);
	} 
}

function api_gallery_horse_upload_avatar() {
	validate_fields($fields, $_GET, array(), array("id"), array(), $fields);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking path */
	$path = $_SESSION["user_id"] . "/horse_avatars/";
	$filename = md5(md5(time()) . rand());
	
	if (!file_exists(UPLOADS_DIR . $path))
		mkdir(UPLOADS_DIR . $path, 0777, true);

	/* Generating name and upload photo */
	$full_img = $path . $filename . ".jpg";
	$result = gallery_upload_photo($_FILES, "hav", $full_img, 500, 500);
	
	/* Insert to db */
	if ($result === true) {
		aok(array(
				"avatar" => "/uploads/" . $full_img
		));	
	} else {
		aerr($result);
	} 
}