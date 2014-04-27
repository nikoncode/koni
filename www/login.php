<?php
/* Logic part of 'login' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

$tmpl = new templater;
$tmpl->assign("page_title", "Вход > Одноконники");
$tmpl->assign("login", $_GET["login"]);
$tmpl->display("login.tpl");