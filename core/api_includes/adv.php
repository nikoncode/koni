<?php
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/session.php");

function api_add_adv(){
    validate_fields($fields, $_POST,
        array("in_chemp", "photo"),
        array(
            "usage",
            "type",
            "nick",
            "poroda",
            "mast",
            "age",
            "price",
            "height",
            "sex",
            "country",
            "city",
            "spec",
            "descr",
        ), array(), $errors,true);
    $db = new db;
    if ($fields["nick"] == '') {
        $errors[] = "Введите кличку";
    }
    if (intval($fields["price"]) < 1) {
        $errors[] = "Введите цену";
    }
    if (intval($fields["height"]) < 1) {
        $errors[] = "Введите рост";
    }
    if (intval($fields["age"]) < 1900 || intval($fields["age"]) > date('Y')) {
        $errors[] = "Введите год рождения в формате ГГГГ (Например: 2003)";
    }
    if ($fields["sex"] == '') {
        $errors[] = "Выберите пол";
    }
    if ($fields["city"] == '') {
        $errors[] = "Выберите город";
    }

    $spec = '';
    foreach($fields['spec'] as $row){
        $spec .= $row.',';
    }
    $fields['spec'] = trim($spec,',');
    $country = $db->getRow("SELECT country_name_ru FROM country_ WHERE id=?i", $fields["country"]);
    $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", $fields["city"]);
    if(!isset($country['country_name_ru'])){
        $errors[] = "Не выбрана страна.";
    }else{
        $fields['country'] = $country['country_name_ru'];
    }
    if(!isset($city['city_name_ru'])){
        $errors[] = "Не выбран город.";
    }else{
        $fields['city'] = $city['city_name_ru'];
    }

    if (!empty($errors)) {
        aerr($errors);
    }
    $fields['user_id'] = $_SESSION['user_id'];
    $fields['add_time'] = time();
    $photos = $fields['photo'];
    unset($fields['photo']);
    $db->query("INSERT INTO adv (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
    $adv_id = $db->getOne("SELECT LAST_INSERT_ID() FROM adv");
    if(!empty($photos)){
        foreach($photos as $row){
            $db->query("UPDATE adv_photos SET adv_id = ?i WHERE id = ?i AND o_uid = ?i;", $adv_id, $row, $_SESSION["user_id"]);
        }
    }
    aok(array("Объявление успешно добавлено."), "/adv.php");

}

function api_find_adv() {
    /* validate data */
    validate_fields($fields, $_POST, array("in_chemp","sex","nick", "country", "city","age_from", "poroda","mast"),
        array(
            "usage",
            "type",
            "age_to",
            "price_from",
            "price_to",
            "height_from",
            "height_to",
            "spec",
        ), array(), $errors);
    $db = new db;
    $country = $db->getRow("SELECT country_name_ru FROM country_ WHERE id=?i", intval($fields["country"]));
    $city = $db->getRow("SELECT city_name_ru FROM city_ WHERE id=?i", intval($fields["city"]));
    $add_sql = '';
    if(isset($country['country_name_ru'])){
        $add_sql .= ' AND country = "'.$country['country_name_ru'].'"';
    }
    if(isset($city['city_name_ru'])){
        $add_sql .= ' AND city = "'.$city['city_name_ru'].'"';
    }
    if($fields['nick'] != ''){
        $add_sql .= ' AND nick = "'.mysql_escape_string($fields['nick']).'"';
    }
    if($fields['poroda'] != ''){
        $add_sql .= ' AND poroda = "'.mysql_escape_string($fields['poroda']).'"';
    }
    if($fields['mast'] != ''){
        $add_sql .= ' AND mast = "'.mysql_escape_string($fields['mast']).'"';
    }
    if($fields['sex'] != ''){
        $add_sql .= ' AND sex = "'.mysql_escape_string($fields['sex']).'"';
    }

    if($fields['spec'] != ''){
        $add_sql .= ' AND spec LIKE "%'.mysql_escape_string($fields["spec"]).'%"';
    }

    if (!empty($errors)) {
        aerr($errors);
    }
    $age_from = $fields['age_from'];
    $fields['age_from'] = intval(date('Y')) - $fields['age_to'];
    $fields['age_to'] = intval(date('Y')) - $age_from;

    $horses = $db->getAll("SELECT *, (SELECT preview FROM adv_photos WHERE adv_id = adv.id LIMIT 1) as preview
							FROM adv
							WHERE
							`usage` = ?i AND `type` = ?i AND age >= ?i AND age <= ?i AND price >= ?i AND price <= ?i AND height >= ?i AND height <= ?i ".$add_sql."
							ORDER BY add_time",
        $fields['usage'], $fields["type"], $fields["age_from"], $fields["age_to"],
        $fields["price_from"], $fields["price_to"], $fields["height_from"], $fields["height_to"]);
    /* render it */
    $tmpl = new templater;
    $tmpl->assign("user", array("id" => $_SESSION["user_id"]));
    foreach($horses as &$horse) {
        $tmpl->assign("horse", $horse);
        $horse = $tmpl->fetch("iterations/adv_horse.tpl");
    }
    aok($horses);
}