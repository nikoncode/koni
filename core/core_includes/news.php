<?php
/* depencies */
include_once(CORE_DIR . "/core_includes/others.php");

function news_wall_build($user_ids, $start, $count, $feed = false) {
	$db = new db;
	if ($feed) {
		$param = $db->parse("WHERE (o_uid IN (SELECT fid FROM friends WHERE uid = ?i) OR o_uid = ?i)", $_SESSION["user_id"], $_SESSION["user_id"]);
	} else {
		$param = $db->parse("WHERE o_uid IN (?a)", $user_ids);
	}
	$news = $db->getAll("SELECT CONCAT(fname,' ',lname) as fio,
								news.id,
								avatar,
								text,
								attachments,
								time,
								o_uid,
								(SELECT COUNT(id) FROM likes WHERE nid = news.id) as likes_cnt,
								(SELECT COUNT(id) FROM likes WHERE nid = news.id AND o_uid = ?i) as is_liked,
								(SELECT COUNT(id) FROM comments WHERE nid = news.id) as comments_cnt,
								(SELECT GROUP_CONCAT(full) FROM gallery_photos WHERE album_id = news.album_id) as photos,
								(SELECT GROUP_CONCAT(id) FROM gallery_photos WHERE album_id = news.album_id) as photo_ids
						FROM news, users
						?p
						AND o_cid = 0
						AND users.id = o_uid
						ORDER BY time DESC
						LIMIT ?i, ?i", $_SESSION["user_id"], $param, $start, $count);
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