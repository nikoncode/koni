<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (CORE_DIR . "core_includes/templates.php");
include_once (CORE_DIR . "core_includes/session.php");
include_once (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include_once (CORE_DIR . "/constant.php");
include_once (CORE_DIR . "core_includes/others.php");

/* Logic part of 'club-admin' page */
if (!session_check()) {
		template_render_error("К сожалению у вас пока нет персональной страницы, или мы вас не опознали. Пожалуйста <a href='/login.php'>войдите</a> или <a href='/reg.php'>зарегистрируйтесь</a>.");
} else {
	if (empty($_GET["id"])) {
		template_render_error("Клуб не найден.");
	}

	$db = new db;
	$assigned_vars["club"] = $db->getRow("SELECT * FROM clubs WHERE id = ?i", $_GET["id"]); 
	$assigned_vars["page_title"] = "Редактирование '" . $assigned_vars["club"]["name"] . "' > Одноконники";
	$assigned_vars["user"] = template_get_short_user_info($_SESSION["user_id"]);
	
	if ($assigned_vars["club"]["o_uid"] != $_SESSION["user_id"]) {
		template_render_error("Вы не можете редактировать этот клуб.");
	}
    $assigned_vars['cities'] = array();
	$assigned_vars["countries"] = $const_countries;
    if($assigned_vars['club']['country'] != ''){
        $assigned_vars['cities'] = $db->getAll("SELECT ct.id,ct.city_name_ru
                                                FROM city_ as ct
                                                INNER JOIN country_ as c ON (c.id = ct.id_country)
                                                WHERE c.country_name_ru = ?s
                                                ORDER BY ct.oid",$assigned_vars['club']['country']);
    }
	$assigned_vars["club"]["c_phones"] = unserialize($assigned_vars["club"]["c_phones"]);
	$assigned_vars["club"]["adv"] = json_decode($assigned_vars["club"]["adv"], 1);
	$assigned_vars["club"]["ability"] = explode(", ", $assigned_vars["club"]["ability"]);
	if (!empty($assigned_vars["club"]["coords"])) {
		$assigned_vars["club"]["coords"] = explode(", ", $assigned_vars["club"]["coords"]);
	}
	$assigned_vars["club"]["competitions"] = others_competitions_get($assigned_vars["club"]["id"]);
	$assigned_vars["abilities"]  = $const_ability;
	$assigned_vars["types"] = $const_club_type;
	$assigned_vars["members"] = $db->getAll("SELECT *, CONCAT(fname,' ',lname) as fio FROM users WHERE cid = ?i", $_GET["id"]);
	$assigned_vars["types"] = $const_horses_spec;
	$assigned_vars["metros"] = $const_metro;
	template_render($assigned_vars, "club-admin.tpl");
}
