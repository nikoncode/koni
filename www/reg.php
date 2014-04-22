<?php
/* Logic part of 'reg' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");
include (CORE_DIR . "constant.php");

$tmpl = new templater;
$tmpl->assign("page_title", "Регистрация > Одноконники");
$tmpl->assign("const_mounth", $const_mounth);
$tmpl->assign("const_work", $const_work);
$tmpl->assign("const_countries", $const_countries);
$tmpl->display("registration.tpl");