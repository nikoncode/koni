<?php
include ("../core/config.php");
include (CORE_DIR . "core_includes/session.php");

$task = $_GET["t"];

switch($task) {
	case "auth":
		auth(1);
	break;
	case "check":
		echo var_dump(check());
	break;
	case "logout":
		logout();
	break;
	default: 
		echo "HZ";
}

print_r($_SESSION);
print_r($_COOKIE);