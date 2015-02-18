<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (CORE_DIR . "core_includes/news.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "constant.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");

$tmpl = new templater;
session_check();
if (!isset($_GET["id"])) {
	template_render_error("Такого клуба нет. Простите.");
} else {
	$db = new db;
	$assigned_vars["club"] = $db->getRow("SELECT 	clubs.*,
														AVG(club_reviews.rating) as SCORE,
														COUNT(club_reviews.id) AS REVIEWS_CNT,
														(SELECT COUNT(id) FROM club_reviews WHERE cid=clubs.id AND rating = 5) as CNT_FIVE,
														(SELECT COUNT(id) FROM club_reviews WHERE cid=clubs.id AND rating = 4) as CNT_FOUR,
														(SELECT COUNT(id) FROM club_reviews WHERE cid=clubs.id AND rating = 3) as CNT_THREE,
														(SELECT COUNT(id) FROM club_reviews WHERE cid=clubs.id AND rating = 2) as CNT_TWO
											FROM clubs, club_reviews
											WHERE clubs.id=?i AND club_reviews.cid=clubs.id", $_GET["id"]);
	if ($assigned_vars["club"]["name"] == NULL) {
		template_render_error("Такого клуба нет. Простите.");
	} else {
		$assigned_vars["page_title"] = "Клуб '" . $assigned_vars["club"]["name"] . "' > Одноконники";
		$assigned_vars["types"] = $const_horses_spec;
		$assigned_vars["club"] = array_merge($assigned_vars["club"], others_club_make_rating($assigned_vars["club"]));
		$assigned_vars["club"]["phones"] = unserialize($assigned_vars["club"]["c_phones"]);
		$assigned_vars["club"]["reviews"] = $db->getAll("SELECT *,
															club_reviews.id as review_id,
															(SELECT COUNT(id) FROM club_reviews_useless WHERE review_id = club_reviews.id AND type = 1) as plus,
															(SELECT COUNT(id) FROM club_reviews_useless WHERE review_id = club_reviews.id AND type = 2) as minus,
															CONCAT(fname,' ',lname) as fio
															FROM club_reviews, users
															WHERE club_reviews.cid = ?i
															AND club_reviews.o_uid = users.id
															ORDER BY time DESC
															LIMIT 5", $assigned_vars["club"]["id"]);

		$rewiews_count = $db->getOne("SELECT COUNT(id) FROM club_reviews WHERE `time` >  NOW( ) - INTERVAL 3 MONTH AND o_uid = ?i AND cid = ?i;",$_SESSION['user_id'], $assigned_vars["club"]["id"]);
		$assigned_vars["review_isset"] = $rewiews_count;
		$assigned_vars["club"]["additions"] = json_decode($assigned_vars["club"]["additions"], 1);
		$assigned_vars["club"]["types"] = explode(',',$assigned_vars["club"]['type']);
		if ($assigned_vars["club"]["ability"] == "") {
			$assigned_vars["club"]["ability"] = array("Возможности не указаны.");
		} else {
			$assigned_vars["club"]["ability"] = explode(", ", $assigned_vars["club"]["ability"]);
		}
		$assigned_vars["club"]["adv"] = others_club_adv_choose($assigned_vars["club"]["adv"]);
		$assigned_vars["club"]["staff"] = $db->getAll("SELECT concat(fname,' ',lname) as fio, avatar,id, club_staff_descr, phone, mail, show_mail, show_phone FROM users WHERE cid = ?i AND is_club_staff = 1", $assigned_vars["club"]["id"]);
		$assigned_vars["club"]["members"] = $db->getAll("SELECT concat(fname,' ',lname) as fio, avatar,id FROM users WHERE cid = ?i LIMIT 6", $assigned_vars["club"]["id"]);
		$assigned_vars["user"] = template_get_user_info($_SESSION["user_id"]); //many info
		$assigned_vars["news"] = news_wall_build("club", $assigned_vars["club"]["id"], 0, 5);
		$assigned_vars["club"]["competitions"] = others_competitions_get($assigned_vars["club"]["id"]);
		if (!empty($assigned_vars["club"]["coords"])) {
			$assigned_vars["club"]["coords"] = explode(", ", $assigned_vars["club"]["coords"]);
		}
		$assigned_vars["datepicker"] = array();
		foreach ($assigned_vars["club"]["competitions"] as $type => $comps) {
			if ($type == "soon") continue;
			foreach ($comps as $comp) {
				$assigned_vars["datepicker"][$comp["bdate"]][] = $comp["name"];
			}

		}
		$assigned_vars["datepicker"] = json_encode($assigned_vars["datepicker"]);

		if(isset($_GET['album'])){
			$ids = array();
			$assigned_vars["gallery"] = $db->getRow("SELECT * FROM albums_clubs WHERE id = ?i AND c_uid = ?i", $_GET['album'], $_GET['id']);

			if($assigned_vars["gallery"]["type_album"] == 0) {
				$assigned_vars["photos"] = $db->getAll("SELECT preview, id FROM gallery_photos WHERE album_club_id = ?i ORDER BY time DESC", $_GET['album']);
				foreach($assigned_vars["photos"] as $photo) {
					$ids[] = $photo["id"];
				}

			}
			if($assigned_vars["gallery"]["type_album"] == 1) {
				$assigned_vars["videos"] = $db->getAll("SELECT video, id FROM gallery_video WHERE album_club_id = ?i ORDER BY time DESC", $_GET['album']);
				foreach($assigned_vars["videos"] as $photo) {
					$ids[] = $photo["id"];
				}
			}
			$assigned_vars["albums"] = $db->getAll("SELECT * FROM albums_clubs WHERE type_album = ?i AND c_uid = ?i", $assigned_vars["gallery"]["type_album"], $_GET['id']);
			$assigned_vars["gallery_id"] = $_GET['album'];


			$assigned_vars["photos_ids_list"] = implode(",", $ids);
		}else{
			$assigned_vars["club"]["albums"] = $db->getAll("SELECT 	id,
													name,
													`desc`,
													linked_event,
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT preview FROM gallery_photos where album_club_id=albums_clubs.id LIMIT 1) as cover
											FROM albums_clubs WHERE type_album = 0 AND c_uid = ?i AND att = 0", $_GET["id"]);
			$assigned_vars["club"]["albums_video"] = $db->getAll("SELECT 	id,
													name,
													`desc`,
													linked_event,
													(SELECT name FROM comp WHERE id = linked_event) as linked_event_name,
													(SELECT video FROM gallery_video where album_club_id=albums_clubs.id LIMIT 1) as cover
											FROM albums_clubs WHERE type_album = 1 AND c_uid = ?i AND att = 0", $_GET["id"]);
		}

		template_render($assigned_vars, "club.tpl");
	}
}



