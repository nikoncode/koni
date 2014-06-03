<?php
/* Including functional dependencies */
include_once (CORE_DIR . "core_includes/session.php");

/* Validating function */
function validate_fields(&$result, $array, $fields, $required, $filters, &$errors, $auth = true){
	if ($auth && !session_check()) {
		$errors[] = "Необходимо войти";
		return;
	}

	$result = array();
    $clear_required = array();
    foreach ($required as $value) {
        $tmp = explode('|',$value);
        $clear_required[] = $tmp[0];
    }

	$all_fields = array_merge($fields, $clear_required);

	foreach ($array as $key => $value) {
		/* remove all non empty values from array & sub array */
		if (is_array($value)) {
			foreach ($value as $sub_key => $sub_value) {
				if (empty($sub_value)) {
					unset($value[$sub_key]);
				}
			}
		}

		/* step first: fill array to requested fields */ 
		if (!empty($value)) {
			if (in_array($key, $all_fields)) {

				$result[$key] = $value;
			}
		}
	}

	/* step two: check required field */
	foreach ($required as $value) {
        $tmp = explode('|',$value);
        if(isset($tmp[1])){
            if (!array_key_exists($tmp[0], $result)) {
                $errors[] = "Обязательное поле '{$tmp[1]}' пустует.";
            }
        }else{
            if (!array_key_exists($tmp[0], $result)) {
                $errors[] = "Обязательное поле '{$tmp[0]}' пустует.";
            }
        }

	}

	/* step three: validate fields */
	foreach ($filters as $key => $value) {
		if (isset($result[$key])) {
			$validate_function = "validate_" . $value;
			if (!$validate_function($result[$key])) {
				$errors[] = "Поле '{$key}' не соответствует формату.";
			}
		}
	}
}

function validate_login($login) {
	if (preg_match("/^[a-zA-Z][A-Za-z0-9_]{4,20}$/", $login) == 0) 
		return false;
	else
		return true;
}

function validate_pass($pass) {
	if (preg_match("/^(?=.*\d)(?=.*[A-Za-z])[0-9A-Za-z!@#$%]{8,20}$/", $pass) == 0) 
		return false;
	else
		return true;
}

function validate_phone($phone) {
	if (preg_match("/[+]{1,1}[0-9]{10,}$/", $phone) == 0)
		return false;
	else
		return true;
}

/* maybe not safe, this is standart function */
function validate_email($mail) { 
	if (filter_var($mail, FILTER_VALIDATE_EMAIL) === false)
		return false;
	else
		return true;
}

/* maybe not safe, this is standart function */
function validate_url($url) {
	if (filter_var($url, FILTER_VALIDATE_URL) === false)
		return false;
	else
		return true;
}