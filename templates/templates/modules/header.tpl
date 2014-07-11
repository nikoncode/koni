{* Smarty *}

<!DOCTYPE html>
<html lang="ru">
	<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<title>{$page_title}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,400,300,600,700,800&subset=latin,cyrillic-ext' rel='stylesheet' type='text/css'>
	<link href="css/bootstrap.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.css" rel="stylesheet">
	<link href="style.css" rel="stylesheet">
	<link href="style_temp.css" rel="stylesheet">
	<script src="js/jquery.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/api.js"></script>
		
	<!--[if IE]>
    <link rel="stylesheet" type="text/css" href="style-ie.css" />
	<![endif]-->

 </head>

<body>
{include "modules/modal-info.tpl"}
{include "modules/modal-confirm.tpl"}
<header>
	{if $user}
		<script>
		function logout() {
			api_query({
				qmethod: "POST",
				amethod: "auth_logout",
				success: function (res, data) {
					document.location.href = data.redirect;
				},
				fail: "standart"
			});
		}
		</script>
		<div class="my-header-block">
			<div class="container">
				<div class="row">
					<div class="span12">
						<div class="navbar navbar-inverse ">
							<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>
							<div class="nav-collapse collapse">
								<ul class="nav">
									<li class="dropdown my-cab"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="{$user.avatar}" class="my-small-avatar"/>Личный кабинет <b class="caret"></b></a>
										<ul class="dropdown-menu">
											<li><a href="inner.php">Моя страница</a></li>
											<li><a href="messages.php">Сообщения</a></li>
											<li><a href="news.php">Новости</a></li>
											<li><a href="friends.php">Друзья</a></li>
											<li><a href="horses.php">Лошади</a></li>
											<li><a href="my-events.php">Мероприятия</a></li>
											<li><a href="gallery.php">Галерея</a></li>
											<li class="divider"></li>
											<li><a href="profile.php">Настройки</a></li>
											<li><a href="index.php" onclick="logout();return false;">Выйти</a></li>
										</ul>
									</li>
									<li class="my-messages"><a href="#modal-myMessages" role="button" data-toggle="modal">Сообщения</a></li>
									<li class="my-info"><a href="#modal-myEvents" role="button" data-toggle="modal">Уведомления</a></li>
								</ul>
							<form class="form-search pull-right">
								<div class="input-append">
									<input type="text" class="span4 search-query" placeholder="Поиск...">
									<button type="submit" class="btn"><i class="icon-search"></i></button>
								</div>
							</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	{/if}
	
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
                            <li class="active"><a href="/">Главная</a></li>
                            <li><a href="events.php">Мероприятия</a></li>
                            <li><a href="clubs.php">Клубы</a></li>
                        </ul>
                        <a href="home.php" class="brand span2 logo"><center><img src="images/logo.png" /></center></a>
                        <ul class="nav span5 main-nav-2">
                            <li><a href="find-users.php">Люди</a></li>
                            <li><a href="ratings.php">Рейтинги</a></li>
                            <li><a href="adv.php">Объявления</a></li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div>
</header>