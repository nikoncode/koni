<?php
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/session.php");

function api_add_adv(){
    validate_fields($fields, $_POST,
        array("in_chemp"),
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

    $db->query("INSERT INTO adv (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);
    aok(array("Объявление успешно добавлено."), "/adv.php");

}

function api_find_adv() {
    /* validate data */
    validate_fields($fields, $_POST, array("in_chemp","sex","nick", "country", "city","age_from"),
        array(
            "usage",
            "type",
            "poroda",
            "mast",

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
    if(!isset($country['country_name_ru'])){
        //$errors[] = "Не выбрана страна.";
    }else{
        $add_sql .= ' AND city = "'.$city['country_name_ru'].'"';
    }
    if(!isset($city['city_name_ru'])){
        //$errors[] = "Не выбран город.";
    }else{
        $add_sql .= ' AND city = "'.$city['city_name_ru'].'"';
    }
    if($fields['nick'] != ''){
        $add_sql .= ' AND nick = "'.mysql_real_escape_string($fields['nick']).'"';
    }
    if (!empty($errors)) {
        aerr($errors);
    }
    $age_from = $fields['age_from'];
    $fields['age_from'] = intval(date('Y')) - $fields['age_to'];
    $fields['age_to'] = intval(date('Y')) - $age_from;

    $horses = $db->getAll("SELECT *
							FROM adv
							WHERE
							`usage` = ?i AND `type` = ?i AND poroda = ?s AND mast = ?s AND age >= ?i AND age <= ?i AND price >= ?i AND price <= ?i AND height >= ?i AND height <= ?i AND spec = ?s ".$add_sql."
							ORDER BY add_time",
        $fields['usage'], $fields["type"], $fields["poroda"], $fields["mast"], $fields["age_from"], $fields["age_to"],
        $fields["price_from"], $fields["price_to"], $fields["height_from"], $fields["height_to"], $fields["spec"]);
    /* render it */
    $tmpl = new templater;
    $tmpl->assign("user", array("id" => $_SESSION["user_id"]));
    foreach($horses as &$horse) {
        $tmpl->assign("horse", $horse);
        $horse = $tmpl->fetch("iterations/adv_horse.tpl");
    }
    aok($horses);
}