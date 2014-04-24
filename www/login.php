<?php
/* Logic part of 'reg' page */
include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");
include (CORE_DIR . "constant.php");

$tmpl = new templater;
$tmpl->assign("page_title", "Вход > Одноконники");
$tmpl->display("login.tpl");