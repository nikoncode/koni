<?php
/* This file contains session control functions */

function auth($id) {
	session_name(SESSION_NAME);
	session_start();
	$_SESSION["user_id"] = $id;
	$_SESSION["start_time"] = $_SESSION["last_activity"] = time();
}

function check($activity = true) {
	session_name(SESSION_NAME);
	session_start();
	$current_time = time();	
	if (isset($_SESSION["user_id"])) {
		/* check session timeout */
		if ($current_time - $_SESSION["last_activity"] > SESSION_LIFETIME) {
			logout();
			return false;	
		} else if ($activity) {
			$_SESSION["last_activity"] = $current_time;
		}

		/* check session id timeout */
		if ($current_time - $_SESSION["start_time"] > SESSION_ID_LIFETIME) {
			$_SESSION["start_time"] = $current_time;
			session_regenerate_id(true);	
		} 
		return true;
	} else {
		logout();
		return false;
	}
}

function logout() {
	if (session_id() == "") {
		session_name(SESSION_NAME);
		session_start();
	}
	setcookie(session_name(), session_id(), time() - 60 * 60 * 24);
    session_unset();
    session_destroy();	
}