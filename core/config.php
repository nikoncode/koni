<?php
/* This is main configuration file. */

/* Main directories options */
define("PROJECT_DIR", 			"D:/koni/home/koni/");
define("LIBRARIES_DIR", 		PROJECT_DIR . "libraries/");
define("CORE_DIR",				PROJECT_DIR . "core/");

/* Smarty options */
define("SMARTY_TEMPLATES_DIR", 	PROJECT_DIR . "templates/templates/");
define("SMARTY_COMPILED_DIR", 	PROJECT_DIR . "templates/compile/");
define("SMARTY_CONFIG_DIR",		PROJECT_DIR . "templates/config/");
define("SMARTY_CACHE_DIR",		PROJECT_DIR . "templates/cache/");

/* MYSQL db options*/
define("MYSQL_USER", "root");
define("MYSQL_PASS", "");
define("MYSQL_DB", "test");

/* SPHINX options*/
define("SPHINX_PORT", 1337);