<?php

function api_club_edit1() {
	validate_fields($fields, $_POST, array(
		"city",
		"address",
		"site",
		"email",
		"phones",
		"p_desc",
		"coords",
        "type",
		"metro"
	), array(
		"id",
		"name|Название клуба",
		"country|Страна"
	), array(
		"site" => "url",
		"email" => "email"
	), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    if($fields['city'] != 'Москва') $fields['metro'] = '';
    if (isset($fields["site"])) {
        if(strpos($fields["site"], 'http://') !== 0) {
            $fields["site"] = 'http://' . $fields["site"];
        }
    }

	if (isset($fields["coords"])) {
		$fields["coords"] = implode(", ", $fields["coords"]);
	}

    if (isset($fields["type"])) {
		$fields["type"] = implode(",", $fields["type"]);
	}else{
        $fields['type'] = '';
    }


	if (isset($fields["phones"]) && isset($fields["p_desc"])) {
		$phones = array();
		foreach ($fields["p_desc"] as $key => $value) {
			$phones[$value] = $fields["phones"][$key];
		}
		$fields["c_phones"] = serialize($phones);
	}
	unset($fields["phones"]); unset($fields["p_desc"]);

	$db = new db;
	$db->query("UPDATE clubs SET ?u WHERE o_uid = ?i AND id = ?i", $fields, $_SESSION["user_id"], $fields["id"]);
	aok(array("Данные обновлены."));
}

function api_club_edit2() {
	validate_fields($fields, $_POST, array(
		"desc",
		"sdesc",
		"ability",
		"opt"
	), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (strlen($fields["sdesc"]) > 800) {
		aerr(array("Слишком длинное 'Краткое описание'."));
	}

	$db = new db;
	if (isset($fields["ability"])) {
		$fields["ability"] = implode(", ", $fields["ability"]);
	}

	if (isset($fields["opt"])) {
		$fields["additions"] = json_encode($fields["opt"]);
	}
	unset($fields["opt"]);
	$db->query("UPDATE clubs SET ?u WHERE id = ?i AND o_uid = ?i", $fields, $fields["id"], $_SESSION["user_id"]);
	aok(array("Данные изменены.")); //check
}

function api_club_user_permission() { //NOT-SAFE
	validate_fields($fields, $_POST, array("desc"), array("id", "type"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["is_moderator"] = 0;
	$fields["is_club_staff"] = 0;
	$fields["club_staff_descr"] = 0;
	$fields["show_mail"] = ($_POST['show_mail'] == 1)?1:0;
	$fields["show_phone"] = ($_POST['show_phone'] == 1)?1:0;

	if ($fields["type"] == "moderator") {
		$fields["is_moderator"] = 1;
	} else if ($fields["type"] == "staff") {
		$fields["is_club_staff"] = 1;
		if (isset($fields["desc"])) {
			$fields["club_staff_descr"] = $fields["desc"];
		} 
	} 
	unset($fields["desc"]);
	unset($fields["type"]);
	$db = new db;
	$db->query("UPDATE users SET ?u WHERE id = ?i", $fields, $fields["id"]);
	aok(array("Обновлено."));
}

function api_club_membership() {
	validate_fields($fields, $_POST, array(), array("id", "act"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$id = $db->getOne("SELECT id FROM clubs WHERE id = ?i", $fields["id"]);
	if ($id === NULL) {
		aerr(array("Такого клуба не существует"));
	}
	/* delete from club & reset preferences */
	$query = array(
		"is_moderator" => 0,
		"is_club_staff" => 0,
		"club_staff_descr" => "",
		"cid" => 0
	);
	if ($fields["act"] == "enter") {
		$query["cid"] = $fields["id"];
	}
	$db->query("UPDATE users SET ?u WHERE id = ?i", $query, $_SESSION["user_id"]);
	aok(array("Успех"));
}

function api_club_adv() {
	//garbage collections
	validate_fields($fields, $_POST, array("adv_img", "adv_link"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}


	$adv = array();
	if (isset($fields["adv_img"]) && isset($fields["adv_link"])) {
		foreach ($fields["adv_img"] as $key => $value) {
			$adv[] = array(
				"img" => $fields["adv_img"][$key],
				"url" => $fields["adv_link"][$key]
			);
		}
	}
	$db = new db;
	$db->query("UPDATE clubs SET adv = ?s WHERE id = ?i AND o_uid = ?i", json_encode($adv), $fields["id"], $_SESSION["user_id"]);
	aok(array("Баннеры обновлены."));
}

function api_club_search() {
	validate_fields($fields, $_POST, array(
		"type",
		"country",
		"city",
		"type",
		"name",
		"ability",
		"amount_start",
		"amount_end",
		"metro"
	), array("range_type"), array(), $errors,false);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (!in_array($fields["range_type"], array("horse", "with_inst", "without_inst"))) {
		aerr(array("Неверный тип фильтра."));
	}

	$db = new sphinx;
	$conditions = "";
	if (isset($fields["name"])) {
		$conditions .= "@name \"" . $db->parse("?w", $fields["name"]) . "\" ";
	}

	if (isset($fields["country"])) {
		$conditions .= "@country \"" . $db->parse("?w", $fields["country"]) . "\" ";
	}

	if (isset($fields["type"])) {
		$conditions .= "@type \"" . $db->parse("?w", $fields["type"]) . "\" ";
	}

	if (isset($fields["city"])) {
		$conditions .= "@city \"" . $db->parse("?w", $fields["city"]) . "\" ";
	}

    if (isset($fields["metro"])) {
		$conditions .= "@metro \"" . $db->parse("?w", $fields["metro"]) . "\" ";
	}

	if (isset($fields["ability"])) {
		$temp = implode(", ", $fields["ability"]);
		$conditions .= "@ability " . $db->parse("?w", $temp);
	}

	
	$between = $db->parse("?n BETWEEN ?i AND ?i", $fields["range_type"], (int)$fields["amount_start"], (int)$fields["amount_end"]);
	$ids = $db->getCol("SELECT id FROM clubs_index WHERE MATCH('?p') AND ?p;", $conditions, $between);
	$db = new db;
	$clubs = $db->getAll("SELECT 	id,
									avatar,
									name,
									coords,
									country,
									city,
									(SELECT COUNT(id) FROM users WHERE cid = clubs.id) as members_cnt,
									(SELECT COUNT(id) FROM club_reviews WHERE cid = clubs.id) as reviews,
									CONCAT(with_inst, ' / ', without_inst, ' / ', horse) as prices
							FROM clubs 
							WHERE id IN (?a)", $ids);
	$result = template_render_to_var(array(
		"clubs" => $clubs
	), "iterations/clubs_find_results.tpl");
	aok(array(
		"rendered" 	=> $result,
		"source"	=> $clubs
	));
}

function api_club_create() {
	validate_fields($fields, $_POST, array(), array(
		"accept|Перед созданием клуба, вы должна подтвердить, что являетесь уполномоченным лицом!",
		"phone|Телефон",
		"name|Название клуба"
	), array("phone" => "phone"), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	unset($fields["accept"]);
	unset($fields["phone"]); //send sms
	$db = new db;
	$fields["o_uid"] = $_SESSION["user_id"];
	$db->query("INSERT INTO clubs SET ?u", $fields);
	aok($db->insertId());
}

function api_rating_search(){
    validate_fields($fields, $_POST, array(
        "period",
        "country",
        "city"
    ), array(), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }
    $db = new db;
    $get_where = '';
    if($fields['period'] == 12) $get_where = " cr.time >= '".date("Y-m-d H:i:s",time()-31556926)."'";
    if($fields['country'] != '') {
        if($get_where != '') $get_where .= ' AND';
        $get_where .= " c.country = '".$fields['country']."'";
    }
    if($fields['city'] != '') {
        if($get_where != '') $get_where .= ' AND';
        $get_where .= " c.city = '".$fields['city']."'";
    }
    if($get_where != '') $get_where = ' WHERE '.$get_where;
    $clubs = $db->getAll("SELECT c.avatar, c.id as cid,SUM(cr.ball) as rating, c.name, CONCAT(c.country,', ',c.city) as address,
                                            (SELECT COUNT(id) as members FROM users WHERE cid = c.id) as members
                                            FROM `clubs` as c
                                            INNER JOIN comp_results as cr ON(c.id = cr.club_id)
											INNER JOIN routes_heights AS rh ON (rh.id = cr.rid)
											INNER JOIN routes AS r ON (r.id = rh.route_id)
                                            ".$get_where."
                                            GROUP BY c.id ORDER BY rating DESC");
    $result = template_render_to_var(array(
        "clubs" => $clubs
    ), "iterations/rating_row.tpl");
    aok(array(
        "rendered" 	=> $result,
        "source"	=> $clubs
    ));
}
function api_rating_search_users(){
    validate_fields($fields, $_POST, array(
        "period",
        "vozrast",
        "height",
        "country",
        "city"
    ), array(), array(), $errors);

    if (!empty($errors)) {
        aerr($errors);
    }
    $vozrast = array(
        "vzroslie" => 'TIMESTAMPDIFF( YEAR, u.bdate, CURDATE( ) ) > 22',
        "uniori" => 'TIMESTAMPDIFF( YEAR, u.bdate, CURDATE( ) ) > 19 AND TIMESTAMPDIFF( YEAR, u.bdate, CURDATE( ) ) < 22',
        "unoshi" => 'TIMESTAMPDIFF( YEAR, u.bdate, CURDATE( ) ) < 22',
        "deti" => 'TIMESTAMPDIFF( YEAR, u.bdate, CURDATE( ) ) < 15',
    );
    $db = new db;
    $get_where = '';
    if($fields['period'] == 12) $get_where = " r.bdate >= '".date("Y-m-d H:i:s",time()-31556926)."'";
    if($fields['country'] != '') {
        if($get_where != '') $get_where .= ' AND';
        $get_where .= " u.country = '".$fields['country']."'";
    }
    if($fields['city'] != '') {
        if($get_where != '') $get_where .= ' AND';
        $get_where .= " u.city = '".$fields['city']."'";
    }
    if($fields['height'] != '') {
        if($get_where != '') $get_where .= ' AND';
        $get_where .= " r.height = '".$fields['height']."'";
    }
    if($fields['vozrast'] != '' && isset($vozrast[$fields['vozrast']])) {
        if($get_where != '') $get_where .= ' AND ';
        $get_where .= $vozrast[$fields['vozrast']];
    }
    if($get_where != '') $get_where = ' WHERE '.$get_where;
    $users = $db->getAll("SELECT u.*, c.name as club, SUM(cr.ball) as ball FROM users AS u
                            INNER JOIN comp_results AS cr ON (cr.user_id = u.id)
                            INNER JOIN routes_heights AS rh ON (rh.id = cr.rid)
                            INNER JOIN routes AS r ON (r.id = rh.route_id)
                            LEFT JOIN clubs AS c ON (c.id = u.cid)
                            ".$get_where."
                            GROUP BY u.id ORDER BY ball DESC");
    $result = template_render_to_var(array(
        "users" => $users
    ), "iterations/rating_user_row.tpl");
    aok(array(
        "rendered" 	=> $result
    ));
}