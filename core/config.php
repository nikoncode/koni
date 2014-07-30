<?php
/* This is main configuration file. */
error_reporting(0);
/* Main directories options */
define("PROJECT_DIR", 			"d:/WebServers/home/localhost/");
define("WEB_ROOT_DIR",			PROJECT_DIR . "www/");
define("LIBRARIES_DIR", 		PROJECT_DIR . "libraries/");
define("CORE_DIR",				PROJECT_DIR . "core/");
define("UPLOADS_DIR",			WEB_ROOT_DIR . "uploads/");

/* Smarty options */
define("SMARTY_TEMPLATES_DIR", 	PROJECT_DIR . "templates/templates/");
define("SMARTY_COMPILED_DIR", 	PROJECT_DIR . "templates/compile/");
define("SMARTY_CONFIG_DIR",		PROJECT_DIR . "templates/config/");
define("SMARTY_CACHE_DIR",		PROJECT_DIR . "templates/cache/");

/* MYSQL db options*/
define("MYSQL_USER", "root");
define("MYSQL_PASS", "");
define("MYSQL_DB", "koni");

/* SPHINX options*/
define("SPHINX_PORT", 1338);

/* Session options */
define("SESSION_NAME", "ODK");
define("SESSION_LIFETIME", 3000000);
define("SESSION_ID_LIFETIME", 60);