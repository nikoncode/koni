<?php
/* depencies */
include_once(CORE_DIR . "/core_includes/others.php");

function news_get_single($type, $news_id) {
	$queries = array(
		"user" => "SELECT 	CONCAT(fname,' ',lname) as owner_name,
							o_uid as owner_id,
							'user' as owner_type,
							avatar as owner_avatar,
							news.id,
							text,
							attachments,
							time,
							news.o_uid,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, users
					WHERE news.id = ?i
					AND users.id = o_uid",
		"club" => "SELECT 	clubs.name as owner_name,
							o_cid as owner_id,
							'club' as owner_type,
							avatar as owner_avatar,
							news.id,
							text,
							attachments,
							time,
							news.o_uid,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, clubs
					WHERE news.id = ?i
					AND clubs.id = o_cid"
	);
	$db = new db;
	return $db->getRow($queries[$type], $_SESSION["user_id"], $news_id);
}

function news_wall_build($type, $id, $start, $count) {
	$queries = array(
		"user" => "SELECT 	CONCAT(fname,' ',lname) as owner_name,
							o_uid as owner_id,
							'user' as owner_type,
							avatar as owner_avatar,
							news.id,
							text,
							attachments,
							time,
							news.o_uid,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT COUNT(id) FROM comments WHERE nid = news.id) as comments_cnt,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, users
					WHERE news.o_uid = ?i
					AND users.id = o_uid
					AND o_cid = 0
					ORDER BY time DESC
					LIMIT ?i, ?i",
		"feed" => "SELECT 	CONCAT(fname,' ',lname) as owner_name,
							o_uid as owner_id,
							'user' as owner_type,
							avatar as owner_avatar,
							news.id,
							text,
							attachments,
							time,
							news.o_uid,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT COUNT(id) FROM comments WHERE nid = news.id) as comments_cnt,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, users
					WHERE (o_uid IN (SELECT fid FROM friends WHERE uid = ?i) OR o_uid = ?i)
					AND users.id = o_uid
					AND o_cid = 0
					ORDER BY time DESC
					LIMIT ?i, ?i",
		"club" => "SELECT 	clubs.name as owner_name,
							o_cid as owner_id,
							'club' as owner_type,
							avatar as owner_avatar,
							news.id,
							text,
							attachments,
							time,
							news.o_uid,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
							(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
							(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
							(SELECT COUNT(id) FROM comments WHERE nid = news.id) as comments_cnt,
							(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
					FROM news, clubs
					WHERE news.o_cid = ?i
					AND clubs.id = o_cid
					ORDER BY time DESC
					LIMIT ?i, ?i"
	);	
	$db = new db;
	
	if ($type == "feed") {
		$news = $db->getAll($queries[$type], $_SESSION["user_id"], $id, $id, $start, $count);
	} else {
		$news = $db->getAll($queries[$type], $_SESSION["user_id"], $id, $start, $count);
	}

	$ids = array();
	foreach ($news as $post) {
		$ids[] = $post["id"];
		$post["photos"] = others_make_photo_array($post["photos"], $post["photo_ids"]);
		$result[$post["id"]] = $post;
		$result[$post["id"]]["comments"] = array();
	}

	$comments = $db->getAll("SELECT c.*,
									CONCAT(fname,' ',lname) as fio,
									avatar,
									(SELECT COUNT(id) FROM likes WHERE cid = c.id) as likes_cnt,
									(SELECT COUNT(id) FROM likes WHERE cid = c.id AND o_uid = ?i) as is_liked 
							FROM news n
							LEFT JOIN 
								(SELECT x.* 
									FROM comments x 
									JOIN comments y 
									ON y.nid = x.nid 
									AND y.id >= x.id 
									GROUP BY x.nid, 
									x.id HAVING COUNT(*) <= 3
								) c
							ON c.nid = n.id
							LEFT JOIN users
							ON c.o_uid = users.id
							WHERE nid in (?a)", $_SESSION["user_id"], $ids);

	foreach ($comments as $comment) {
		$result[$comment["nid"]]["comments"][] = $comment;
	}
	return $result;
}