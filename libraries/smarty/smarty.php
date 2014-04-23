<?php
/* Custom Smarty constructor */

include('Smarty.class.php');

class templater extends Smarty {
	function __construct() {
		parent::__construct();
		$this->setTemplateDir(SMARTY_TEMPLATES_DIR);
		$this->setCompileDir(SMARTY_COMPILED_DIR);
		$this->setConfigDir(SMARTY_CONFIG_DIR);
		$this->setCacheDir(SMARTY_CACHE_DIR);
		$smarty->caching = false;
	}
}