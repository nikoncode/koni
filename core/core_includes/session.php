<?php
/* this is session controller file */

function auth($id) {
	session_name("MYPROJECT");
	session_start();
	$_SESSION["user_id"] = $id;
	$_SESSION["start_time"] = $_SESSION["last_activity"] = time();
}

function check() {
	session_name("MYPROJECT");
	session_start();
	if (isset($_SESSION["user_id"])) 
		return true;
	else
		return false; 
}

function rem() {
	session_name("MYPROJECT");
	session_start();
	setcookie(session_name(), session_id(), time()-60*60*24);
    session_unset();
    session_destroy();	
}