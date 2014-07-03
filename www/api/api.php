<?php
/* Main api file */

/* Including functional dependencies */
include ("../../core/config.php");
include (LIBRARIES_DIR . "safe_mysql/safemysql.php");
include (CORE_DIR . "core_includes/validate.php");

/* Including api modules */
include (CORE_DIR . "api_includes/auth.php");
include (CORE_DIR . "api_includes/gallery.php");
include (CORE_DIR . "api_includes/chat.php");
include (CORE_DIR . "api_includes/friends.php");
include (CORE_DIR . "api_includes/horses.php");
include (CORE_DIR . "api_includes/likes.php");
include (CORE_DIR . "api_includes/comments.php");
include (CORE_DIR . "api_includes/news.php");
include (CORE_DIR . "api_includes/adv.php");
include (CORE_DIR . "api_includes/clubs.php");
include (CORE_DIR . "api_includes/comp.php");
include (CORE_DIR . "api_includes/users.php");

/* Api response function */
function aok($response, $redirect = NULL) {
	$response = array(
		"type" => "success",
		"response" => $response
	);

	if ($redirect !== NULL) {
		$response["redirect"] = $redirect;
	}

	exit(json_encode($response));
}

function aerr($response, $redirect = NULL) {
	$response = array(
		"type" => "error",
		"response" => $response
	);

	if ($redirect !== NULL) {
		$response["redirect"] = $redirect;
	}

	exit(json_encode($response));
}

/* Calculate method name */
if (!empty($_POST["m"])) {
	$method = $_POST["m"];
} else if (!empty($_GET["m"])) {
	$method = $_GET["m"];
} else {
	aerr(array("Не передан метод для вызова."));
}
$method = "api_" . $method;

/* 
Check existing method and call it 
INFO: all api method must be 'api_' prefix
*/
if (function_exists($method)) {
	$method();
} else {
	aerr(array("Такого метода не существует."));
}


