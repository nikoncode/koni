<?php
/* Custom SafeMYSQL constructors */

include('safemysql.class.php');

class db extends safemysql {
	function __construct() {
		$options = array(
			"user"    => MYSQL_USER,
			"pass"    => MYSQL_PASS,
			"db"      => MYSQL_DB,
		);
		parent::__construct($options);
	}
}

class sphinx extends safemysql {
	function __construct() {
		$options = array(
			"port"	  => SPHINX_PORT
		);
		parent::__construct($options);
	}
}