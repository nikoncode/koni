<?php
/* Logic part of 'sms page */

include ("../core/config.php");
include (LIBRARIES_DIR . "smarty/smarty.php");

$tmpl = new templater;
$tmpl->assign("page_title", "Подтверждение > Одноконники");
$tmpl->assign("login", $_GET["login"]);
$tmpl->display("registration_verify.tpl");