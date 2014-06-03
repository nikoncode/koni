{* Smarty *}
<!DOCTYPE html>
<html lang="ru">
	<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<title>{$page_title}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,800&subset=latin,cyrillic-ext' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Open+Sans+Condensed:300,700&subset=latin,cyrillic-ext' rel='stylesheet' type='text/css'>
	<link href="css/bootstrap.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.css" rel="stylesheet">
	<link href="style.css" rel="stylesheet">
	<script src="js/jquery.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/bootstrap-tooltip.js"></script>
	<script src="js/api.js"></script>
	
	<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
		<script src="../assets/js/html5shiv.js"></script>
	<![endif]-->
 </head>

<body>
{include "modules/modal-info.tpl"}
<header class="header-mini">
	<div class="pre-main-menu">
		<div class="container">
			<div class="row mrg20">
				<div class="span4 site-descr"><p>Нас объединяет лошади и общение с лошадьми, верховая езда, иппотерапия и все, что связывает человека и лошадь.</p></div>
				<div class="span4 offset4 soc-share">
					<p>Поделитесь с друзьями</p>
					<script type="text/javascript">(function() {
					 if (window.pluso)if (typeof window.pluso.start == "function") return;
					 var d = document, s = d.createElement('script'), g = 'getElementsByTagName';
					 s.type = 'text/javascript'; s.charset='UTF-8'; s.async = true;
					 s.src = ('https:' == window.location.protocol ? 'https' : 'http')  + '://share.pluso.ru/pluso-like.js';
					 var h=d[g]('head')[0] || d[g]('body')[0];
					 h.appendChild(s);
					})();</script>
					<div class="pluso" data-options="small,round,line,horizontal,nocounter,theme=05" data-services="vkontakte,odnoklassniki,facebook,twitter,google,moimir,email,print" data-background="transparent"></div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="main-menu">
		<div class="container">
			<div class="row">
				<div class="uzd-left"></div><div class="uzd-right"></div>
				<div class="navbar">
					<div class="navbar-inner">
						<ul class="nav span5 main-nav-1">
							<li class="active"><a href="home.php">Главная</a></li>
							<li><a href="ratings.php">Рейтинги</a></li>
							<li><a href="clubs.php">Клубы</a></li>
							<li><a href="find-users.php">Люди</a></li>
						</ul>
						<a href="home.php" class="brand span2 logo"><center><img src="images/logo.png" /></center></a>
						<ul class="nav span5 main-nav-2">
							<li><a href="shop.php">Магазин</a></li>
							<li><a href="adv.php">Объявления</a></li>
							<li><a href="forum.php">Форум</a></li>
							<li><a href="articles.php">Статьи</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</header>