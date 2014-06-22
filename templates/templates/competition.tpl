{* Smarty *}
{include "modules/header.tpl"}
<script type="text/javascript">
	
function membership(cid, role, val, element) {
	api_query({
		amethod: "comp_member",
		qmethod: "POST",
		params: {
			id: cid,
			role : role,
			val : val
		},
		success: function (data) {
			var selector = "#" + role + "s";
			console.log($(selector));
			var el = $(element);
			if (data[0] == "1") {
				el.removeClass("btn-warning").addClass("btn-success");
				$(selector).append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
			} else {
				el.removeClass("btn-success").addClass("btn-warning");
				$(selector + " .me").remove();
			}
			el.attr("onclick", "membership(" + cid + ", '" + role + "', '" + (+!!!data[0]) + "', this); return false;");
		},
		fail: "standart"
	})
}

function rider(rid, act, element) {
	api_query({
		amethod: "comp_rider",
		qmethod: "POST",
		params: {
			id: rid,
			act : act
		},
		success: function (data) {
			var el = $(element);
			if (data[0] != "0") {
				el.removeClass("btn-warning").addClass("btn-success");
			} else {
				el.removeClass("btn-success").addClass("btn-warning");
			}
			el.attr("onclick", "rider(" + rid + ", '" + (+!!!data[0]) + "', this); return false;");
			if ($("#routes .btn-success").length == 0) {
				$("#riders li.me").remove();
			} else if ($("#riders li.me").length == 0) {
				$("#riders").append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
			}
		},
		fail: "standart"
	})
}


</script>
<div class="container clubs-page main-blocks-area club-block img.club-avatar">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-info" style="background-color: #fff">
				<h3 class="inner-bg">Конноспортивный комплекс "Битца"<span class="pull-right text-italic">Общий рейтинг: <strong>2367</strong> / Рейтинг по соревнованиям: <strong>7632</strong> <a href="club-admin.php">[админ]</a></span></h3>
				<div class="row">
					<div class="span3">
						<a href="#"><img src="i/club-bitza.jpg" class="club-avatar" /></a>
						<input type="button" class="btn btn-warning goto-club" value="Вступить в клуб" />
						<p class="club-access-descr">Вы ещё не вступали ни в однин из <a href="#">клубов</a></p>
					</div>
					
					<div class="span6 current-club-descr">
						<p class="current-club-descr">Конноспортивный комплекс (КСК) «Битца» — это крупнейший конноспортивный комплекс Москвы и единственное учреждение такого рода в мире по масштабам и расположению. КСК очень удобно размещен, недалеко от центра столичного города и огромного лесопарка. Территория комплекса составляет площадь малого государства в Европе, 50 га. Так, не выезжая за город, вы можете окунуться в тишину и покой, и насладиться общением с прекрасным животным — лошадью.</p>
						<dl class="dl-horizontal">
							<dt>Веб-сайт:</dt>
							<dd><a href="http://www.kskbitsa.ru">http://www.kskbitsa.ru</a></dd>
							<dt>E-mail:</dt>
							<dd><a href="mailto:ksk_bitsa@mtu-net.ru">ksk_bitsa@mtu-net.ru</a></dd>
							<dt>Телефоны:</dt>
							<dd>
								<ul class="unstyled">
									<li>+7 (495) 955-93-93 - Многоканальный телефон</li>
									<li>+7 (495) 788-80-18; 8(968) 819-01-19 - Обучение</li>
									<li>+7 (495) 788-80-11 - Бассейн, спортзал </li>
									<li>+7 (495) 645-79-73 - Ветеринария</li>
								</ul>
							</dd>
							<dt>Адрес:</dt>
							<dd>Россия, г. Москва, Балаклавский проспект, 33</dd>
						</dl>
					</div>
					
					<div class="span3 club-banners">
						<a href="#"><img src="i/club-sample-adv.jpg" /></a>
						
					</div>
				</div>
			</div>
			
			<div class="span12 brackets-horizontal"></div>
			
			<div class="span12 lthr-bgborder block club-tabs">
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li><a href="club-sample.php#news-club">Новости/отзывы</a></li>
					<li><a href="club-sample.php#about-club">О клубе</a></li>
					<li class="active"><a href="club-sample.php#competitions-club">Соревнования</a></li>
					<li><a href="club-sample.php#rating-club">Рейтинги (156,16)</a></li>
					<li><a href="club-sample.php#gallery-club">Галерея</a></li>
					<li><a href="club-sample.php#contact-club">Контакты</a></li>
				</ul>
				
				<div id="clubTabContent" class="tab-content bg-white">
				
				<div class="tab-pane in active current-compt">
					<div class="row"><div class="span12 back-link"><a href="club-sample.php#competitions-club">&larr; <span>Вернуться во все соревнования</span></a></div></div>
					<div class="row">
						<div class="span1"><img src="images/flag-test.jpg" class="img-flag"/></div>
						<div class="span11 compt-title"><h4>{$comp.name}</h4></div>
					</div>
					<div class="row">
						<div class="span6">
							<dl class="dl-horizontal">
								<dt>Дата:</dt>
								<dd>
									<p>Начало: {$comp.bdate}</p>
									<p>Окончание: {$comp.edate}</p>
								</dd>
								<dt>Адрес:</dt>
								<dd>{$comp.address}</dd>
								<dt>Вид:</dt>
								<dd>{$comp.type}</dd>
							</dl>
						</div>
						<div class="span6 compt-descr">
							<div class="row">
								<div class="span2">
									<a href="#" class="span2 btn btn-small btn-{if $comp.is_viewer}success{else}warning{/if}" onclick="membership({$comp.id}, 'viewer', '{!$comp.is_viewer}', this); return false;">
										Приду смотреть <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span2">
									<a href="#" class="span2 btn btn-small btn-{if $comp.is_photographer}success{else}warning{/if}" onclick="membership({$comp.id}, 'photographer', '{!$comp.is_photographer}', this); return false;">
										Я фотограф <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span2">
									<a href="#" class="span2 btn btn-small btn-{if $comp.is_fan}success{else}warning{/if}" onclick="membership({$comp.id}, 'fan', '{!$comp.is_fan}', this); return false;">
										Я болельщик <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span6 descr-title"><p>{$comp.desc}</p></div>
								<div class="span6">
									<!--<ul class="unstyled span6 comp-added-files">
										<li class="pdf-file">Положение-1.pdf<button type="button" class="close">&times;</button></li>
										<li class="pdf-file">Положение-2.pdf<button type="button" class="close">&times;</button></li>
										<li class="pdf-file">Положение-c-длинным-описанием.pdf<button type="button" class="close">&times;</button></li>
									</ul>-->
								</div>
								</div>
							</div>
						</div>
						
	<div class="row">
	<div class="span12">
	<table class="table table-striped competitions-table curr-compt-levels" id="routes">
						<tr>
							<th class="span2">Дата</th>
							<th class="span2">Маршрут</th>
							<th class="span2">Высота</th>
							<th class="span2">Зачёт для</th>
							<th class="span2">Статус</th>
							<th class="span2"></th>
						</tr>
						{foreach $comp.routes as $route}
						 <tr>
							<td colspan="6" class="td-complex">
									<div class="row">
										<div class="curr-compt-date span2">{$route.bdate}</div>
										<div class="curr-compt-path span2">{$route.name}</div>
										<div class="curr-compt-height span2">{$route.height}</div>
										<div class="curr-compt-for span2">{$route.exam}</div>
										<div class="curr-compt-status span2">{$route.status}</div>
										<div class="curr-compt-go">
											<a href="#" class="btn btn-{if $route.is_rider}success{else}warning{/if}" onclick="rider({$route.id}, '{!$route.is_rider}', this); return false;">
												Участвовать <i class="icon-play icon-white"></i>
											</a>
										</div>
										<div class="row curr-compt-more">
											<ul class="unstyled span12">
												{foreach $route.options as $option}
													<li><span>{$option@key}</span>  {$option}</li>
												{/foreach}
											</ul>
										</div>
									</div>
							</td>
						</tr> 
						{/foreach}
					</table>
		</div>
	</div>
						
	<div class="row compt-descr-tabs">
	<div class="span12">
            <ul class="nav nav-tabs">
              <li class="active"><a href="#compt-members" data-toggle="tab">Участники</a></li>
              <li><a href="#compt-results" data-toggle="tab">Результаты</a></li>
              <li><a href="#compt-gallery" data-toggle="tab">Галерея</a></li>
              <li><a href="#compt-disqus" data-toggle="tab">Обсуждения</a></li>
            </ul>
            
			<div class="tab-content">
              
			  <div class="tab-pane in active" id="compt-members">
					<div class="span12">
						<h3 class="inner-bg">Всадники{*<span class="pull-right">{$comp.riders|@count}</span>*}</h3>
						<ul class="clubs-members" id="riders">
							{foreach $comp.riders as $rider}
								<li {if $rider.id == $user.id}class="me"{/if}><a href="/user.php?id={$rider.id}"><img src="{$rider.avatar}"><p>{$rider.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Зрители{*<span class="pull-right">{$comp.viewers|@count}</span>*}</h3>
						<ul class="clubs-members" id="viewers">
							{foreach $comp.viewers as $viewer}
								<li {if $viewer.id == $user.id}class="me"{/if}><a href="/user.php?id={$viewer.id}"><img src="{$viewer.avatar}"><p>{$viewer.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Болельщики{*<span class="pull-right">{$comp.fans|@count}</span>*}</h3>
						<ul class="clubs-members" id="fans">
							{foreach $comp.fans as $fan}
								<li {if $fan.id == $user.id}class="me"{/if}><a href="/user.php?id={$fan.id}"><img src="{$fan.avatar}"><p>{$fan.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Фотографы{*<span class="pull-right">{$comp.photographers|@count}</span>*}</h3>
						<ul class="clubs-members" id="photographers">
							{foreach $comp.photographers as $photographer}
								<li {if $photographer.id == $user.id}class="me"{/if}><a href="/user.php?id={$photographer.id}"><img src="{$photographer.avatar}"><p>{$photographer.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
              </div> <!-- compt-members -->
              
			  <div class="tab-pane" id="compt-results">
                <table class="table table-striped competitions-table compt-results">
						<tbody><tr>
							<th>№</th>
							<th>Всадник</th>
							<th>Разряд</th>
							<th>Лошадь</th>
							<th>Команда</th>
							<th>Штраф. очки<br/>маршрут</th>
							<th>Время<br/>маршурт</th>
							<th>Штраф. очки</th>
							<th>Перепрыжка</th>
							<th>Норма</th>
						</tr>
						 <tr><td colspan="10" class="table-caption">Студенческий зачёт</td></tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						
						 <tr><td colspan="10" class="table-caption">Общий зачёт</td></tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 
						<tr>
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors">нет</td>
							<td class="points">696</td>
							<td class="total">68,235</td>
							<td class="standarts">кмс</td>
							<td class="norm">норма</td>
						</tr> 

					</tbody>
					</table>
              </div><!-- compt-results -->
			  <div class="tab-pane" id="compt-gallery">
                <div class="photos">
					<ul class="photo-wall">
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
					</ul>
				</div>
              </div><!-- compt-gallery -->
			
			<div class="tab-pane" id="compt-disqus">
					<ul class="my-news-wall">
								<li>
									<div class="post">
																
										<img src="i/avatar-1.jpg" class="avatar">
										<p class="user-name"><a href="#">Leon Ramos</a></p>
										<p class="date">15.02.2013 в 14:11</p>
										<div class="edit-my-topic">
											<ul class="unstyled inline">
												<li><a href="#"><i class="icon-pencil" title="Редактировать запись"></i></a></li>
												<li><a href="#"><i class="icon-remove" title="Удалить запись"></i></a></li>
											</ul>
										</div>
										<p class="message">
										</p>
										Для того, чтобы быть вместе. Просто быть вместе. А это ведь трудно, очень трудно, и не только шизофреникам и юродивым. Всем трудно раскрываться, верить, отдавать, считаться, терпеть, понимать. Так трудно, что порой перспектива сдохнуть от одиночества видится не самым плохим вариантом.<p></p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#" class="likebox">Мне нравится: 13 <i class="icon-like liked"></i></a></span></p>
										</div>
									</div>
								</li>
								<li>
									<div class="post">
										<img src="i/avatar-2.jpg" class="avatar">
										<p class="user-name"><a href="#">Вася Горбунков</a></p>
										<p class="date">15.02.2013 в 13:11</p>
										<p class="message">Так трудно, что порой перспектива видится не самым плохим вариантом.</p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
										</div>
									</div>
								</li>
								<li>
									<div class="post">
										<img src="i/avatar-1.jpg" class="avatar">
										<p class="user-name"><a href="#">Leon Ramos</a></p>
										<p class="date">15.02.2013 в 14:11</p>
										<p class="message">Для того, чтобы быть вместе. Просто быть вместе.</p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
										</div>
									</div>
								</li>
								<li>
									<div class="post">
										<img src="i/avatar-2.jpg" class="avatar">
										<p class="user-name"><a href="#">Вася Горбунков</a></p>
										<p class="date">15.02.2013 в 13:11</p>
										<p class="message">Так трудно, что порой перспектива видится не самым плохим вариантом.</p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
										</div>
									</div>
								</li>
								<li>
									<div class="post">
										<img src="i/avatar-2.jpg" class="avatar">
										<p class="user-name"><a href="#">Вася Горбунков</a></p>
										<p class="date">15.02.2013 в 13:11</p>
										<p class="message">Так трудно, что порой перспектива видится не самым плохим вариантом.</p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
										</div>
									</div>
								</li>
								<li>
									<div class="post">
										<img src="i/avatar-1.jpg" class="avatar">
										<p class="user-name"><a href="#">Leon Ramos</a></p>
										<p class="date">15.02.2013 в 14:11</p>
										<p class="message">Для того, чтобы быть вместе. Просто быть вместе. А это ведь трудно, очень трудно, и не только шизофреникам и юродивым. Всем трудно раскрываться, верить, отдавать, считаться, терпеть, понимать. Так трудно, что порой перспектива сдохнуть от одиночества видится не самым плохим вариантом.</p>
										<div class="answer-block">
											<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
										</div>
									</div>
								</li>
							</ul>
             </div><!-- compt-disqus -->
			 
            </div>
          </div>
						</div>
					</div>
				</div> <!-- //clubTabContent -->
			</div>
			</div><!-- // block club-tabs -->

	</div>
</div>



<div id="i-am-fan" class="modal hide modal800" tabindex="-1" role="dialog" aria-hidden="false">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3>За кого будете болеть в этом соревновании?</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" method="post" action="">
						<div class="row">	
							<div class="fans-member-list">	
								<ul class="unstyled">
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-1.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li class="member-chosen">
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-2.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#" class="btn btn-warning btn-small">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-3.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-4.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-5.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-6.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-1.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
									
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user-sample.php"><img src="i/sample-ava-2.jpg"></a></td>
												<td class="m-name"><div class="name"><a href="#">Александр Гетманский</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. Москва, клуб «Битца»</td>
												<td class="m-horse">Лошадь «Беркут», Казахская порода</td>
												<td class="m-btn"><a href="#">Буду болеть</a></td>
											</tr>
										</table>
									</li>
								</ul>	
							</div>
						</div>

						<div class="row">	
							<div class="controls controls-row foo-row">
								<center>
								<button type="submit" class="btn btn-warning span3 offset2">Сохранить</button>
								<button class="btn  span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
						</div>
			</form>
	</div>
</div>


{include "modules/footer.tpl"}