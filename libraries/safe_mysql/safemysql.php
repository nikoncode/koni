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
			"host"	  => "127.0.0.1",
			"port"	  => SPHINX_PORT
		);
		parent::__construct($options);
	}
}