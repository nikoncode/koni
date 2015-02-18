<?php
include_once(CORE_DIR . "core_includes/others.php");
include (LIBRARIES_DIR . "php_excel/PHPExcel.php");

function api_comp_add() {
	validate_fields($fields, $_POST, array("desc"), array(
		"name",
		"type",
		"country",
		"city",
		"address",
		"bdate",
		"edate",
		"o_cid"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["bdate"] = others_data_format($fields["bdate"], ".", "-");
	$fields["edate"] = others_data_format($fields["edate"], ".", "-");
    if (isset($fields["type"])) {
        $fields["type"] = implode(",", $fields["type"]);
    }
	$db = new db;
	$permission = $db->getOne("SELECT o_uid FROM clubs WHERE id = ?i", $fields["o_cid"]);

	if ($permission == NULL || $permission != $_SESSION["user_id"]) {
		aerr(array("Вы не можете добавить событие в этот клуб."));
	}

	$db->query("INSERT INTO comp SET ?u", $fields);
    $insert_id = $db->insertId();
    $users = $db->getAll("SELECT id FROM users WHERE cid = ?i",$fields["o_cid"]);
    foreach($users as $row){
        $message = 'Добавлено новое соревнование';
        api_add_notice($row['id'],$fields["o_cid"],$message,'club');
    }

	aok($insert_id);
}

function api_comp_edit() {
	validate_fields($fields, $_POST, array("combat_field","training_field","dennik","razvyazki"), array(
		"name",
		"type",
		"country",
		"city",
		"address",
		"bdate",
		"edate",
		"desc",
		"id"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["bdate"] = others_data_format($fields["bdate"], ".", "-");
	$fields["edate"] = others_data_format($fields["edate"], ".", "-");
    if (isset($fields["type"])) {
        $fields["type"] = implode(",", $fields["type"]);
    }
    if(!isset($fields['dennik'])) $fields['dennik'] = 0;
    if(!isset($fields['combat_field'])) $fields['combat_field'] = '';
    if(!isset($fields['training_field'])) $fields['training_field'] = '';
    if(!isset($fields['razvyazki'])) $fields['razvyazki'] = 0;
	if($fields['dennik'] < 0 ) $fields['dennik'] = 0;
	if($fields['razvyazki'] < 0 ) $fields['razvyazki'] = 0;
	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM clubs, comp WHERE comp.id = ?i AND comp.o_cid = clubs.id", $fields["id"]);

	if ($perm == NULL || $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете редактировать это соревнование."));
	}
	
	$db->query("UPDATE comp SET ?u WHERE id = ?i", $fields, $fields["id"]);
    $o_cid = $db->getOne("SELECT o_cid FROM clubs, comp WHERE comp.id = ?i AND comp.o_cid = clubs.id", $fields["id"]);
    $users = $db->getAll("SELECT id FROM users WHERE cid = ?i",$o_cid);
    foreach($users as $row){
        $message = 'Изменено соревнование';
        api_add_notice($row['id'],$o_cid,$message,'club');
    }
	aok(array("Данные изменены успешно."));
}

function api_change_riders_ordering() {
	$db = new db;
    foreach($_POST['ordering'] as $ride_id => $routes){
        foreach($routes as $route_id => $order){
            $db->query("UPDATE comp_riders SET rid = ?i, ordering = ?i WHERE id = ?i", $route_id, $order, $ride_id);
        }
    }
	aok(array("Данные изменены успешно."));
}

function api_comp_member() {
	validate_fields($fields, $_POST, array("val"), array("role", "id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	if (!in_array($fields["role"], array("photographer", "viewer", "fan"))) {
		aerr(array("Такой роли не существует"));
	}

	$fields["val"] = (int)isset($fields["val"]);

	$db = new db;
	$id = $db->getOne("SELECT id FROM comp_members WHERE uid = ?i AND cid = ?i", $_SESSION["user_id"], $fields["id"]); //check exists
	if ($id == NULL) {
		$db->query("INSERT INTO comp_members (cid, uid, ?n) VALUES (?i, ?i, ?i)", $fields["role"], $fields["id"], $_SESSION["user_id"], $fields["val"]);
	} else {
		$upd = array(
			$fields["role"] => $fields["val"]
		);
		$db->query("UPDATE comp_members SET ?u WHERE id = ?i", $upd, $id);
	}
	aok(array($fields["val"]));
}

function api_comp_fan_member() {
	validate_fields($fields, $_POST, array(), array("user_id", "cid"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
    $fields['user_id'] = implode(',',$fields['user_id']);
	$db = new db;
	$id = $db->getOne("SELECT id FROM comp_members WHERE uid = ?i AND cid = ?i", $_SESSION["user_id"], $fields["cid"]); //check exists
	if ($id == NULL) {
		$db->query("INSERT INTO comp_members (cid, uid, fan, fan_riders) VALUES (?i, ?i, ?i, ?s)", $fields["cid"], $_SESSION["user_id"], 1, $fields['user_id']);
	} else {
		$db->query("UPDATE comp_members SET fan = 1, fan_riders = ?s WHERE id = ?i", $fields['user_id'], $id);
	}
	aok(array(0));
}

function api_comp_rider() {
	validate_fields($fields, $_POST, array("act","rid","dennik","razvyazki"), array("id", "hid|Лошадь"), array(), $errors); //act==0 remove

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	if(!$fields["act"]){
        $ids = $db->getRow("SELECT GROUP_CONCAT(id) as ids FROM routes_heights WHERE route_id = ?i",$fields["id"]);
        $db->query("DELETE FROM comp_riders WHERE uid = ?i AND rid IN (".$ids['ids'].")", $_SESSION["user_id"]);
    }
	if(!isset($fields['dennik'])) $fields['dennik'] = 0;
	if(!isset($fields['razvyazki'])) $fields['razvyazki'] = 0;
	if($fields['dennik'] > 0 || $fields['razvyazki'] > 0){
		$comp = $db->getRow("SELECT c.dennik,c.razvyazki,c.id
										FROM comp AS c
										INNER JOIN routes AS r ON (r.cid = c.id)
										WHERE r.id = ?i", $fields["id"]);
		$dennik_razv = $db->getRow("SELECT SUM(cr.dennik) as dennik, SUM(cr.razvyazki) AS razvyazki FROM comp_riders AS cr
					INNER JOIN routes_heights AS rh ON (rh.id = cr.rid)
                    INNER JOIN routes AS r ON (r.id = rh.route_id)
					WHERE r.cid = ?i
					", $comp["id"]);
		$dennik_res = $comp['dennik']-$dennik_razv['dennik'];
		$razvyazki_res = $comp['razvyazki']-$dennik_razv['razvyazki'];
		if($fields['dennik'] > $dennik_res) $errors[] = 'Укажите количество денников до '.$dennik_res;
		if($fields['razvyazki'] > $razvyazki_res) $errors[] = 'Укажите количество развязок до '.$razvyazki_res;
	}
	if (!empty($errors)) {
		aerr($errors);
	}
	if ($fields["act"] && $fields['rid'] != '') {
        $fields['rid'] = explode('-',trim($fields['rid'],'-'));
        foreach($fields['rid'] as $rid){
            $db->query("INSERT INTO comp_riders (uid, rid, hid, dennik, razvyazki) VALUES (?i, ?i, ?i, ?i, ?i)", $_SESSION["user_id"], $rid, $fields['hid'], intval($fields['dennik']), intval($fields['razvyazki']));
			$fields['dennik'] = 0;
			$fields['razvyazki'] = 0;
		}
		$comp = $db->getRow("SELECT comp.name, comp.id, comp.o_cid FROM comp, routes WHERE routes.id = ?i AND comp.id = routes.cid",$fields["id"]);
		$message = 'Вы зарегистрировались на участие в соревновании <a href="/competition.php?id='.$comp["id"].'#start-list">'.$comp['name'].'</a>';
		api_add_notice($_SESSION["user_id"],$comp['o_cid'],$message,'club');

	}
	aok(array(isset($fields["act"])));
}

function api_add_member_admin() {
	validate_fields($fields, $_POST, array(), array("uid", "hid", "rid"), array(), $errors); //act==0 remove

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$db->query("DELETE FROM comp_riders WHERE uid = ?i AND rid = ?i AND hid = ?i", $fields['uid'], $fields["rid"], $fields["hid"]);
	$db->query("INSERT INTO comp_riders (uid, rid, hid) VALUES (?i, ?i, ?i)", $fields['uid'], $fields["rid"], $fields['hid']);
	aok(array($db->insertId()));
}

function api_delete_rider() {
	validate_fields($fields, $_POST, array("reason","blocked"), array("rid"), array(), $errors); //act==0 remove

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;

	if(isset($fields['blocked']) && $fields['blocked'] > 0){
		$user = $db->getRow("SELECT comp_riders.uid, routes.blocked, routes.id FROM comp_riders,routes,routes_heights WHERE
								comp_riders.rid = routes_heights.id
								AND routes_heights.route_id = routes.id
								AND comp_riders.id = ?i", $fields["rid"]);
		$user['blocked'] .= $user['uid'].',';
		$db->query("UPDATE routes SET blocked = ?s WHERE id = ?i",$user['blocked'],$user['id']);
	}
	if(isset($fields['reason']) && $fields['reason'] != ''){
		$user = $db->getRow("SELECT comp_riders.uid, comp.o_cid FROM comp, comp_riders,routes,routes_heights WHERE
								comp_riders.rid = routes_heights.id
								AND routes_heights.route_id = routes.id
								AND routes.cid = comp.id AND comp_riders.id = ?i", $fields["rid"]);
		api_add_notice($user['uid'],$user['o_cid'],$fields['reason'],'club');
	}
	$db->query("DELETE FROM comp_riders WHERE id = ?i", $fields["rid"]);
	aok(array(isset($fields["act"])));
}

function api_comp_route_add() {
	validate_fields($fields, $_POST, array(
		"opt_name",
		"sub_type",
        "time",
		"opt"
	), array(
		"type", 
		"name|Маршрут",
		"date|Дата начала",
		"status",
		"height|Высота",
		"exam|Зачет для",
		"cid"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM clubs, comp WHERE comp.id = ?i AND comp.o_cid = clubs.id", $fields["cid"]);
	if ($perm == NULL || $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете добавлять маршрут в этот клуб."));
	}
	$fields['options'] = array();
	if (isset($fields["opt_name"]) && isset($fields["opt"])) {
		foreach ($fields["opt_name"] as $k => $v) {
			$fields["options"][$v] = $fields["opt"][$k];
		}
	}
	$fields["options"] = serialize($fields["options"]);
	unset($fields["opt_name"]);
	unset($fields["opt"]);
    if(!isset($fields["time"])) $fields["time"] = '23:59:59';
	$fields["bdate"] = others_data_format($fields["date"], ".", "-") . " " . $fields["time"];
	unset($fields["date"]);
	unset($fields["time"]);
	$fields_h = $fields;
	unset($fields['exam']);
	unset($fields['height']);
	$db->query("INSERT INTO routes SET ?u", $fields);
	$insert_id = $db->insertId();
	foreach($fields_h['height'] as $key=>$h){
		$insert = array(
			'route_id' => $insert_id,
			'height' => $h,
			'exam' => $fields_h['exam'][$key],
		);
		$db->query("INSERT INTO routes_heights SET ?u", $insert);
	}
	aok(array("WELL DONE"));
}

function api_comp_route_info() {
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$info = $db->getRow("SELECT * FROM routes WHERE id = ?i", $fields["id"]);
	$temp = explode(" ", $info["bdate"]);
	$info["time"] = ($temp[1] == '23:59:59')?'':date("H:i",strtotime($info["bdate"]));
	$info["date"] = others_data_format($temp[0], "-", ".");
	unset($info["bdate"]);
	$info['heights'] = $db->getAll("SELECT * FROM routes_heights WHERE route_id = ?i", $fields["id"]);
	$info["options"] = unserialize($info["options"]);
	//$info["opt_name"] = array_keys($info["options"]);
	//$info["opt"] = array_values($info["options"]);
	
	aok($info);
}

function api_comp_route_delete() {
	validate_fields($fields, $_POST, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM clubs, comp, routes 
		WHERE routes.id = ?i 
		AND routes.cid = comp.id 
		AND comp.o_cid = clubs.id", $fields["id"]);
	if ($perm == NULL || $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете удалить этот маршрут"));
	}
	$db->query("DELETE FROM routes WHERE id = ?i", $fields["id"]);
	$db->query("DELETE FROM routes_heights WHERE route_id = ?i", $fields["id"]);
	aok(array("DONE"));
}

function api_comp_route_edit() {
	validate_fields($fields, $_POST, array(
		"opt_name",
        "sub_type",
        "time",
		"opt"
	), array(
		"type", 
		"name|Маршрут",
		"date|Дата начала",
		"status",
		"exam|Зачет для",
		"height|Высота",
		"id"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	
	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM clubs, comp, routes 
		WHERE routes.id = ?i 
		AND routes.cid = comp.id 
		AND comp.o_cid = clubs.id", $fields["id"]);
	if ($perm == NULL || $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете изменить этот маршрут"));
	}

	$fields['options'] = array();
	if (isset($fields["opt_name"]) && isset($fields["opt"])) {
		foreach ($fields["opt_name"] as $k => $v) {
			$fields["options"][$v] = $fields["opt"][$k];
		}
	}
	$fields["options"] = serialize($fields["options"]);
	unset($fields["opt_name"]);
	unset($fields["opt"]);
    if(!isset($fields["time"])) $fields["time"] = '23:59:59';
	$fields["bdate"] = others_data_format($fields["date"], ".", "-") . " " . $fields["time"];
	unset($fields["date"]);
	unset($fields["time"]);
	$fields_h = $fields;
	unset($fields['exam']);
	unset($fields['height']);
	$db->query("UPDATE routes SET ?u WHERE id = ?i", $fields, $fields["id"]);
	$heights = $db->getAll("SELECT * FROM routes_heights WHERE route_id = ?i",$fields["id"]);
	foreach($heights as $h){
		if(isset($fields_h['height'][$h['id']])){
			$db->query("UPDATE routes_heights SET height = ?s, exam = ?s WHERE id = ?i", $fields_h['height'][$h['id']], $fields_h['exam'][$h['id']],$h['id']);
			unset($fields_h['height'][$h['id']]);
			unset($fields_h['exam'][$h['id']]);
		}else{
			$db->query("DELETE FROM routes_heights WHERE id = ?i", $h['id']);
		}
	}
	foreach($fields_h['height'] as $key=>$h){
		$insert = array(
			'route_id' => $fields["id"],
			'height' => $h,
			'exam' => $fields_h['exam'][$key],
		);
		$db->query("INSERT INTO routes_heights SET ?u", $insert);
	}


    $o_cid = $db->getOne("SELECT comp.o_cid FROM routes, comp WHERE routes.cid = comp.id AND routes.id = ?i", $fields["id"]);
    $users = $db->getAll("SELECT uid FROM comp_riders WHERE rid = ?i",$fields["id"]);
    foreach($users as $row){
        $message = 'Изменился маршрут, в котором вы учавствуете.';
        api_add_notice($row['uid'],$o_cid,$message,'club');
    }
	aok(array("WELL DONE"));
}

function api_accept_riders(){
	validate_fields($fields, $_POST, array(), array(
		"id",
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$comp = $db->getRow("SELECT clubs.name, comp.o_cid FROM comp,clubs WHERE clubs.id = comp.o_cid AND comp.id = ?i",$fields['id']);
	$users = $db->getAll("SELECT comp_riders.uid as uid,routes.name FROM routes, routes_heights,comp_riders WHERE comp_riders.rid = routes_heights.id AND routes.id = routes_heights.route_id AND routes.cid = ?i",$fields["id"]);
	foreach($users as $row){
		$message = 'Ваше участие в соревновании "'.$row['name'].'", клуба "'.$comp['name'].'" подтверждено.';
		api_add_notice($row['uid'],$comp['o_cid'],$message,'club');
	}
	aok(array("WELL DONE"));
}

function api_startlist_update_row(){
	validate_fields($fields, $_POST, array(
		"id",
		"uid",
		"hid",
		"rid",
	), array(), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	if(!isset($fields['uid'])) $fields['uid'] = 0;
	if(!isset($fields['hid'])) $fields['hid'] = 0;
	if(!isset($fields['id'])){
		$db->query("INSERT INTO comp_riders SET uid = ?i, hid = ?i, rid = ?i", $fields['uid'], $fields['hid'], $fields['rid']);
		$fields['id'] = $db->insertId();
	}else{
		$db->query("UPDATE comp_riders SET ?u WHERE id = ?i", $fields, $fields["id"]);
	}
	aok(array($fields['id']));
}

function api_change_publish(){
	validate_fields($fields, $_POST, array("publish"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	if(!isset($fields["publish"])) $fields["publish"] = 0;
	$db->query("UPDATE comp SET publish = ?i WHERE id = ?i", $fields['publish'], $fields["id"]);
	if($fields["publish"] == 1){
		$users = $db->getAll("SELECT uid FROM comp_riders, routes WHERE routes.id = comp_riders.rid AND routes.cid = ?i GROUP BY uid",$fields["id"]);
		$comp = $db->getRow("SELECT comp.name, o_cid FROM comp WHERE id = ?i",$fields["id"]);
		foreach($users as $user){
			$message = 'Был опубликован стартовый лист в мероприятии <a href="/competition.php?id='.$fields["id"].'#start-list">'.$comp['name'].'</a>';
			api_add_notice($user['uid'],$comp['o_cid'],$message,'club');
		}

	}
	aok(array($fields['id']));
}

function api_change_publish_results(){
	validate_fields($fields, $_POST, array("publish_results"), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	if(!isset($fields["publish_results"])) $fields["publish_results"] = 0;
	$db->query("UPDATE comp SET publish_results = ?i WHERE id = ?i", $fields['publish_results'], $fields["id"]);
	if($fields["publish_results"] == 1){
		$users = $db->getAll("SELECT uid FROM comp_riders, routes WHERE routes.id = comp_riders.rid AND routes.cid = ?i GROUP BY uid",$fields["id"]);
		$comp = $db->getRow("SELECT comp.name, o_cid FROM comp WHERE id = ?i",$fields["id"]);
		foreach($users as $user){
			$message = 'Были опубликованы результаты в мероприятии <a href="/competition.php?id='.$fields["id"].'#start-list">'.$comp['name'].'</a>';
			api_add_notice($user['uid'],$comp['o_cid'],$message,'club');
		}

	}
	aok(array($fields['id']));
}

function api_comp_results_update() {
	validate_fields($fields, $_POST, array(
		"disq",
		"reason",
		"pos",
		"fio",
		"degree",
		"club_id",
		"shtraf_route",
		"time",
		"shtraf",
		"reroute",
		"ball",
		"money",
		"currency",
		"norma"
	), array("horse","id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM comp, clubs WHERE comp.id = ?i AND comp.o_cid = clubs.id", $fields["id"]);
	if ($perm == NULL && $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете менять результаты этого соревнования."));
	}

    $results = array();

    foreach ($fields["pos"] as $route_id => $elements) {
        $results[$route_id] = array();
        foreach ($elements as $key => $element) {
            if($fields["fio"][$route_id][$key] == 0) continue;
            if(!isset($fields["club_id"][$route_id][$key])) $fields["club_id"][$route_id][$key] = 0;
            if(!isset($fields["ball"][$route_id][$key])) $fields["ball"][$route_id][$key] = 0;
            if(!isset($fields["money"][$route_id][$key])) $fields["money"][$route_id][$key] = 0;
            if(!isset($fields["currency"][$route_id][$key])) $fields["currency"][$route_id][$key] = '';
            if(!isset($fields["horse"][$route_id][$key])) $fields["horse"][$route_id][$key] = 0;
            if($fields["horse"][$route_id][$key] == 0) {
                $errors[] = "У № ".$fields["pos"][$route_id][$key]." не выбрана лошадь";
            }
            $results[$route_id][] = array(
                "rid" => $route_id,
                "rank" => $fields["pos"][$route_id][$key],
                "disq" => $fields["disq"][$route_id][$key],
                "reason" => $fields["reason"][$route_id][$key],
                "user_id" => $fields["fio"][$route_id][$key],
                "razryad" => $fields["degree"][$route_id][$key],
                "horse" => $fields["horse"][$route_id][$key],
                "club_id" => $fields["club_id"][$route_id][$key],
                "shtraf_route" => $fields["shtraf_route"][$route_id][$key],
                "time" => $fields["time"][$route_id][$key],
                "shtraf" => $fields["shtraf"][$route_id][$key],
                "rerun" => $fields["reroute"][$route_id][$key],
                "ball" => $fields["ball"][$route_id][$key],
                "money" => $fields["money"][$route_id][$key],
                "currency" => $fields["currency"][$route_id][$key],
                "norma" => $fields["norma"][$route_id][$key]
            );
        }
        //usort($results[$route_id], others_results_position_sort);
    }

    foreach($results as $route_id=>$users){
        $db->query("DELETE FROM comp_results WHERE rid = ?i", $route_id);
        foreach($users as $user){
            $check_event = $db->getOne("SELECT id FROM comp_riders WHERE rid = ?i AND hid = ?i AND uid = ?i", $user['rid'], intval($user['horse']), $user['user_id']);
            if($check_event === FALSE){
                $db->query("INSERT INTO comp_riders SET rid = ?i, uid = ?i, hid = ?i", $user['rid'], $user['user_id'], intval($user['horse']));
            }
            $db->query("INSERT INTO comp_results SET ?u", $user);
        }
    }
	if (!empty($errors)) {
		aerr($errors);
	}
	//$db->query("UPDATE comp SET results = ?s WHERE id = ?i", $results, $fields["id"]);
	aok(array("Результаты сохранены"));
}

function api_comp_results_parse() {
	validate_fields($fields, $_GET, array(), array("id"), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$perm = $db->getOne("SELECT o_uid FROM comp, clubs WHERE comp.id = ?i AND comp.o_cid = clubs.id", $fields["id"]);
	if ($perm == NULL && $perm != $_SESSION["user_id"]) {
		aerr(array("Вы не можете менять результаты этого соревнования."));
	}

	if ((!empty($_FILES["xls"])) && ($_FILES["xls"]['error'] == 0)) {
		$filename = basename($_FILES["xls"]['name']);
		$temp = explode(".", $filename);
		$ext = strtolower($temp[1]);
		if (($ext == "xls") && ($_FILES["xls"]["size"] < 300000000)) {
			$xlsReader = new PHPExcel_Reader_Excel5();
			$xlsOpen = $xlsReader->load($_FILES["xls"]['tmp_name']);

			$results = array();
			foreach ($xlsOpen->getWorksheetIterator() as $sheet) {
				if ($sheet->getCellByColumnAndRow(1, 10)->getCalculatedValue() == "BEGIN") {
					$route_id = $sheet->getCellByColumnAndRow(1, 5)->getCalculatedValue();
					$results[$route_id] = array();
					$row_number = 11;
					while ($sheet->getCellByColumnAndRow(1, $row_number)->getCalculatedValue() != "END") {
						$row = array(
							'pos' 		=> $sheet->getCellByColumnAndRow(1, $row_number)->getCalculatedValue(),
							'fio' 		=> $sheet->getCellByColumnAndRow(2, $row_number)->getCalculatedValue(),
							'degree' 	=> $sheet->getCellByColumnAndRow(3, $row_number)->getCalculatedValue(),
							'horse' 	=> $sheet->getCellByColumnAndRow(4, $row_number)->getCalculatedValue(),
							'team' 		=> $sheet->getCellByColumnAndRow(5, $row_number)->getCalculatedValue(),
							'opt1' 		=> $sheet->getCellByColumnAndRow(6, $row_number)->getCalculatedValue(),
							'opt2' 		=> $sheet->getCellByColumnAndRow(7, $row_number)->getCalculatedValue(),
							'opt3' 		=> $sheet->getCellByColumnAndRow(8, $row_number)->getCalculatedValue(),
							'opt4' 		=> $sheet->getCellByColumnAndRow(9, $row_number)->getCalculatedValue(),
							'opt5' 		=> $sheet->getCellByColumnAndRow(10, $row_number)->getCalculatedValue(),
							'disq' 		=> $sheet->getCellByColumnAndRow(11, $row_number)->getCalculatedValue()
						);
						$results[$route_id][] = $row;
						$row_number++;
					}
					usort($results[$route_id], others_results_position_sort);
				}
			}

			$db->query("UPDATE comp SET results = ?s WHERE id = ?i", serialize($results), $fields["id"]);
			aok(array("Таблица сохранена."));
		} else {
			aerr(array("Для загрузки доступны только EXCEL файлы."));
		}
	} else {
		aerr(array("Файл не загружен."));
	}
}

function api_delete_file(){
	validate_fields($fields, $_POST, array(), array(
		"id"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	$db->query("DELETE FROM comp_files WHERE id = ?i;",$fields["id"]);
	aok(array("Файл удален"));
}

function api_comp_review_add() {
	validate_fields($fields, $_POST, array(), array(
		"cid",
		"rating",
		"text"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["o_uid"] = $_SESSION["user_id"];
	$db = new db;
    $db->query("DELETE FROM club_reviews WHERE `time` >  NOW( ) - INTERVAL 3 MONTH AND o_uid = ?i AND cid = ?i;",$fields["o_uid"], $fields["cid"]);
	$db->query("INSERT club_reviews SET ?u", $fields);
	$review = $db->getRow("SELECT *,
									club_reviews.id as review_id,
									CONCAT(fname,' ',lname) as fio,
									0 as plus,
									0 as minus 
									FROM club_reviews, users
									WHERE club_reviews.id = ?i
									AND users.id = club_reviews.o_uid", $db->insertId());
	$rendered = template_render_to_var(array(
		"review" => $review
	), "iterations/review.tpl");
	aok($rendered);
}

function api_comp_review_useless() {
	validate_fields($fields, $_POST, array(), array(
		"review_id",
		"type"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["o_uid"] = $_SESSION["user_id"];

	$db = new db;
	$db->query("DELETE FROM club_reviews_useless WHERE o_uid = ?i AND review_id = ?i", $fields["o_uid"], $fields["review_id"]);
	$db->query("INSERT club_reviews_useless SET ?u", $fields);
	$votes = $db->getRow("SELECT (SELECT COUNT(id) FROM club_reviews_useless WHERE review_id = ?i AND type = 1) as plus,
									(SELECT COUNT(id) FROM club_reviews_useless WHERE review_id = ?i AND type = 2) as minus", $fields["review_id"], $fields["review_id"]);
	aok($votes);
}

function api_find_events() {
    /* validate data */
    validate_fields($fields, $_POST, array("name","type","bdate","edate", "status", "city","country", "exam","club","height_from",
            "height_to",
        ),
        array(), array(), $errors,false);
    $db = new db;
    $add_sql = '';
    if($fields['name'] != ''){
        $add_sql .= ' AND c.name LIKE "%'.mysql_escape_string($fields['name']).'%"';
    }
    if($fields['type'] != ''){
        $add_sql .= ' AND c.type = "'.mysql_escape_string($fields['type']).'"';
    }
    if($fields['bdate'] != ''){
        $add_sql .= ' AND c.bdate = "'.mysql_escape_string(date("Y-m-d",strtotime($fields['bdate']))).'"';
    }
    if($fields['edate'] != ''){
        $add_sql .= ' AND r.edate = "'.mysql_escape_string(date("Y-m-d",strtotime($fields['edate']))).'"';
    }
    if($fields['status'] != ''){
        $add_sql .= ' AND r.status = "'.mysql_escape_string($fields['status']).'"';
    }
    if($fields['city'] != ''){
        $add_sql .= ' AND c.city = "'.mysql_escape_string($fields['city']).'"';
    }
    if($fields['exam'] != ''){
        $add_sql .= ' AND rh.exam = "'.mysql_escape_string($fields['exam']).'"';
    }
    if($fields['country'] != ''){
        $add_sql .= ' AND c.country = "'.mysql_escape_string($fields['country']).'"';
    }
    if(count($fields['club']) > 0){
        $clubs = '';
        foreach($fields['club'] as $club) $clubs .= "'".$club."',";
        $add_sql .= ' AND club.name IN ('.trim($clubs,',').')';
    }


    if (!empty($errors)) {
        aerr($errors);
    }
    $horses = $db->getAll("SELECT GROUP_CONCAT(DISTINCT(r.status)) as status, c.*, club.name as club, club.id as club_id,c.country,c.city
							FROM routes as r
							INNER JOIN routes_heights as rh ON (rh.route_id = r.id)
							INNER JOIN comp as c ON (c.id = r.cid)
							INNER JOIN clubs as club ON (c.o_cid = club.id)
							WHERE
							rh.height >= ?i AND rh.height <= ?i ".$add_sql."
							GROUP BY c.id ORDER BY r.bdate",
        $fields['height_from'], $fields["height_to"]);
    $tmpl_name = 'iterations/events_search.tpl';

    /* render it */
    $tmpl = new templater;
    $tmpl->assign("user", array("id" => $_SESSION["user_id"]));

    foreach($horses as &$horse) {
        $tmpl->assign("event", $horse);
        $horse = $tmpl->fetch($tmpl_name);
    }
    aok($horses);
}

function api_import_to_results(){
	validate_fields($fields, $_POST, array(), array(
		"id",
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["o_uid"] = $_SESSION["user_id"];

	$db = new db;
	$startlist = $db->getAll("SELECT cr.*, u.cid AS club_id,u.rank FROM routes AS r
						INNER JOIN routes_heights AS rh ON (rh.route_id = r.id)
						INNER JOIN comp_riders AS cr ON (cr.rid = rh.id)
						INNER JOIN users AS u ON (u.id = cr.uid)
						WHERE r.cid = ?i ORDER BY r.id, cr.ordering", $fields["id"]);
	$route_id = 0;
	$ranks = get_ranks();
	foreach($startlist as $row){
		if($route_id != $row['rid']) $db->query("DELETE FROM comp_results WHERE rid = ?i ", $row['rid']);
		$route_id = $row['rid'];
		$ins = array(
			"rid" => $route_id,
			"user_id" => $row['uid'],
			"horse" => $row['hid'],
			"club_id" => $row['club_id'],
			"razryad" => $ranks[$row['rank']]
		);
		$db->query("INSERT INTO comp_results (`" . implode("` ,`", array_keys($ins)) . "`) VALUES (?a);", $ins);
	}
	$db->query("UPDATE comp SET publish_results = 0 WHERE id = ?i", $fields["id"]);
	aok(array("ok"));
}

function api_comp_delete(){
	validate_fields($fields, $_POST, array(), array(
		"id",
	), array(), $errors);

	$db = new db;
	$access = $db->getOne("SELECT comp.id FROM comp,clubs WHERE clubs.id = comp.o_cid AND comp.id = ?i AND clubs.o_uid = ?i",$fields['id'],$_SESSION['user_id']);
	if($access === false){
		$errors[] = "У вас нет доступа";
	}else{
		$routes = $db->getRow("SELECT GROUP_CONCAT(DISTINCT(routes_heights.id)) AS hids, GROUP_CONCAT(DISTINCT(routes.id)) AS rids FROM routes,routes_heights WHERE routes.id = routes_heights.route_id AND routes.cid = ?i",$fields['id']);
		if($routes !== false) {
			$db->query("DELETE FROM comp_results WHERE rid IN (".$routes['hids'].")");
			$db->query("DELETE FROM comp_riders WHERE rid IN (".$routes['hids'].")");
			$db->query("DELETE FROM routes_heights WHERE route_id IN (".$routes['rids'].")");
		}
		$db->query("DELETE FROM comp_members WHERE cid = ?i",$fields['id']);
		$db->query("DELETE FROM comp_files WHERE cid = ?i",$fields['id']);
		$db->query("DELETE FROM comp_photo WHERE cid = ?i",$fields['id']);
		$db->query("DELETE FROM comp_viewers WHERE cid = ?i",$fields['id']);
		$db->query("DELETE FROM comp WHERE id = ?i",$fields['id']);
		$db->query("DELETE FROM routes WHERE cid = ?i",$fields['id']);
	}
	if (!empty($errors)) {
		aerr($errors);
	}
	aok(array("ok"));
}

function api_route_heights(){
	validate_fields($fields, $_POST, array(), array(
		"id",
	), array(), $errors);
	if (!empty($errors)) {
		aerr($errors);
	}
	$db = new db;
	$rows = $db->getAll("SELECT * FROM routes_heights WHERE route_id = ".$fields['id']);
	$rendered = template_render_to_var(array(
		"heights" => $rows
	), "iterations/heights.tpl");
	aok($rendered);
}