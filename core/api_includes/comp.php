<?php

function api_comp_add() {
	validate_fields($fields, $_POST, array(), array(
		"name",
		"type",
		"country",
		"city",
		"address",
		"bdate",
		"edate",
		"desc",
		"o_cid"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
	}

	$fields["bdate"] = others_data_format($fields["bdate"], ".", "-");
	$fields["edate"] = others_data_format($fields["edate"], ".", "-");

	$db = new db;
	$db->query("INSERT INTO comp (`" . implode("`, `", array_keys($fields)) . "`) VALUES (?a)", $fields);
	aok(array("DONE"));
}

function api_comp_edit() {
	validate_fields($fields, $_POST, array(), array(
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

	$db = new db;
	$db->query("UPDATE comp SET ?u WHERE id = ?i", $fields, $fields["id"]);
	aok(array("DONE"));
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

function api_comp_rider() {
	validate_fields($fields, $_POST, array("act"), array("id"), array(), $errors); //act==0 remove

	if (!empty($errors)) {
		aerr($errors);
	}

	$db = new db;
	$db->query("DELETE FROM comp_riders WHERE uid = ?i AND rid = ?i", $_SESSION["user_id"], $fields["id"]);
	if ($fields["act"]) {
		$db->query("INSERT INTO comp_riders (uid, rid) VALUES (?i, ?i)", $_SESSION["user_id"], $fields["id"]);
	}
	aok(array(isset($fields["act"])));
}

function api_comp_route_add() {
	validate_fields($fields, $_POST, array(
		"opt_name",
		"opt"
	), array(
		"type", 
		"name",
		"date",
		"time",
		"status",
		"exam",
		"height",
		"cid"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
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

	$fields["bdate"] = others_data_format($fields["date"], ".", "-") . " " . $fields["time"];
	unset($fields["date"]);
	unset($fields["time"]);
	$db = new db;
	$db->query("INSERT INTO routes SET ?u", $fields);
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
	$info["time"] = $temp[1];
	$info["date"] = others_data_format($temp[0], "-", ".");
	unset($info["bdate"]);

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
	$db->query("DELETE FROM routes WHERE id = ?i", $fields["id"]);
	aok(array("DONE"));
}

function api_comp_route_edit() {
	validate_fields($fields, $_POST, array(
		"opt_name",
		"opt"
	), array(
		"type", 
		"name",
		"date",
		"time",
		"status",
		"exam",
		"height",
		"id"
	), array(), $errors);

	if (!empty($errors)) {
		aerr($errors);
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

	$fields["bdate"] = others_data_format($fields["date"], ".", "-") . " " . $fields["time"];
	unset($fields["date"]);
	unset($fields["time"]);
	$db = new db;
	$db->query("UPDATE routes SET ?u WHERE id = ?i", $fields, $fields["id"]);
	aok(array("WELL DONE"));
}