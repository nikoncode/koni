{* Smarty *}
{include "modules/header.tpl"}

<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>



<script type="text/javascript" src="js/likes.js"></script>
<script type="text/javascript" src="js/gallery.js"></script>
<script type="text/javascript" src="js/comments.js"></script>
<script type="text/javascript" src="js/news.js"></script>
<script type="text/javascript" src="js/autoload.js"></script>

<script>
	$(function () {
		news_form_init($(".add-news form"));
		$(".my-news-wall").autoload({
			id: {$club.id},
			type: "club"
		})
		if (location.hash !== '')
			$('a[href="' + location.hash + '"]').tab('show');
		return $('a[data-toggle="tab"]').on('shown', function(e) {
			return location.hash = $(e.target).attr('href').substr(1);
		});
	})
</script>

<div class="container clubs-page main-blocks-area club-block img.club-avatar">
		<div class="row">
		
			{include "modules/club-header.tpl"}
			
			<div class="span12 brackets-horizontal"></div>
			
			<div class="span12 lthr-bgborder block club-tabs">
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li class="active"><a href="#news-club" data-toggle="tab">Новости/отзывы</a></li>
					<li><a href="#about-club" data-toggle="tab">О клубе</a></li>
					<li><a href="#competitions-club" data-toggle="tab">Соревнования</a></li>
					<li><a href="#rating-club" data-toggle="tab">Рейтинги (156,16)</a></li>
					<li><a href="#gallery-club" data-toggle="tab">Галерея</a></li>
					<li><a href="#contact-club" data-toggle="tab">Контакты</a></li>
				</ul>
				
				<div id="clubTabContent" class="tab-content bg-white">
				
				<div class="tab-pane in active" id="news-club">
					<div class="row">
						<div class="span6">
							<h4>Последние новости клуба</h4>
							{if $club.o_uid == $user.id}
								{include "modules/news-form.tpl" owner_type = "club" owner_id = $club.id}
							{/if}
							<ul class="my-news-wall">
								{include "modules/modal-gallery-lightbox.tpl"}
								{include "iterations/news_block.tpl"}
							</ul>
						</div>
						
						<div class="span6">
							<div>
								<h4>Отзывы</h4>
<div class="row">
	<div class="span2 rate-block">
		<div class="main-rate">{$club.notes.avg|string_format:"%.2f"}</div>
		<div class="horseshoe-rate-block">
			<ul class="horseshoe-rate">
			{for $stars = 1 to 5}
				<li class="horseshoe rate-1 {if $stars <= $club.notes.stars}active{/if}"></li>
			{/for}
			</ul>
			<div class="clearfix"></div>
		</div>
		<p class="voters-numb"><i class="icon-user"></i>{$club.notes.all} оценок</p>
	</div>
	<div class="span4">
		<ul class="unstyled prog-rating">
			{for $rate = 1 to 5}
				<li class="rate-{$rate}"><div class="progress progress-warning"><div class="bar" style="width: {$club.percent.$rate}%">{$club.percent.$rate|string_format:"%.2f"}% ({$club.notes.$rate})</div></div></li>
			{/for}
		</ul>
	</div>
</div>
							</div>
							
							<hr/>
							

<script>
function rate(el) {
	var element = $(el);
	var rate = parseInt(element.attr("data-rate"));
	element.closest(".horseshoe-rate").find("li[data-rate]").removeClass("active")
	.slice(0, rate).addClass("active");
	element.closest("form").find("[name=rating]").val(rate);
}

function review_add(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_review_add",
		params: $(form).serialize(),
		success: function (data) {
			$(".club-reviews ul.comments-lists").prepend(data);
			$(".club-add-your-review .review_text").val('');
		},
		fail: "standart"
	})
}

function useless(review_id, type, el) {
	api_query({
		qmethod: "POST",
		amethod: "comp_review_useless", 
		params: {
			review_id : review_id,
			type : type
		},
		success: function (data) {
			var element = $(el).closest(".useful-review");
			element.find("span.plus").text(data.plus);
			element.find("span.minus").text(data.minus);
		},
		fail: "standart"
	})
}
</script>
							<div class="club-add-your-review">
								<h4>Добавить свой отзыв</h4>
								<form class="row" onsubmit="review_add(this); return false;">
									<textarea placeholder="Что Вы думаете об этом клубе?" rows="5" class="span6 review_text" name="text"></textarea>
									<input type="hidden" name="cid" value="{$club.id}" />
									<input type="hidden" name="rating" value="1" />
									<div class="span4 club-review-rate">
										<ul class="horseshoe-rate">
											<li class="title">Оцените клуб: </li>
											<li class="horseshoe rate-1 active" data-rate="1" onclick="rate(this);"></li>
											<li class="horseshoe rate-2" data-rate="2" onclick="rate(this);"></li>
											<li class="horseshoe rate-3" data-rate="3" onclick="rate(this);"></li>
											<li class="horseshoe rate-4" data-rate="4" onclick="rate(this);"></li>
											<li class="horseshoe rate-5" data-rate="5" onclick="rate(this);"></li>
										</ul>
									</div>
									<button class="btn btn-warning span2">Отправить отзыв</button>
								</form>
							</div>
							
							<hr/>
							
							<div class="club-reviews">
											<ul class="comments-lists">
												{foreach $club.reviews as $review}
													{include "iterations/review.tpl" review = $review}
												{/foreach}
											</ul>
										
										{*<div class="pagination">
											<ul class="page-list">
												<li class="title">Страницы: </li>
												<li class="active page"><a href="#">1</a></li>
												<li class="page"><a href="#">2</a></li>
												<li class="page"><a href="#">3</a></li>
												<li class="page"><a href="#">4</a></li>
												<li class="page"><a href="#">5</a></li>
											</ul>
										</div>*}
						</div>
						
					</div>
					</div>
				</div> <!-- //news-club -->
				
				<div class="tab-pane" id="about-club">
					<div class="row">
						<div class="span6">
							{if $club.desc}
								<h4>О клубе</h4>
								<p>{$club.desc}</p>
								<hr/>
							{/if}
							{if $club.ability}
								<h4>дополнительные возможности клуба</h4>
								<ul class="club-additional-features">
									{foreach $club.ability as $ab}
										<li>{$ab}</li>
									{/foreach}
								</ul>
							{/if}
							<div class="clearfix"></div><hr/>
							{if $club.additions}						
								<dl class="dl-horizontal">
									{foreach $club.additions as $add}
										<dt>{$add.name}:</dt>
										<dd>
											{if $add.name == "Расстояние от города" }
												{$add.l_city}
											{else if $add.name == "Расстояние от остановки общественного транспорта"}
												{$add.l_point}
											{else if $add.name == "Аренда лошади"}
												<ul class="unstyled">
													<li>C инструктором: {$add.with_inst}</li>
													<li>Без инструктора: {$add.without_inst}</li>
													<li>Постой лошади: {$add.horse}</li>
												</ul>
											{else if $add.name == "Лошади"}
												<ul class="unstyled">
													<li>Самок: {$add.man}</li>
													<li>Самцов: {$add.woman}</li>
												</ul>
											{else if $add.name == "Обслуживающий персонал"}
												<ul class="unstyled">
													<li>Денники: {$add.denniki_cnt}</li>
													<li>Тренеры: {$add.trainers_cnt}</li>
													<li>Ветеринары: {$add.doc}</li>
												</ul>
											{/if}
										</dd>
									{/foreach}
								</dl>
							{/if}
						</div>
						
						<div class="span6">
							
								<h4>Администрация клуба <!--<span class="pull-right">5 человек</span>--></h4>
							{if $club.staff}
								<ul class="club-admins">
									{foreach $club.staff as $staff}
										<li class="row">
											<div class="span3"><a href="/user.php?id={$staff.id}"><img src="{$staff.avatar}" /><div>{$staff.fio}</div></a><div class="text-italic">{$staff.club_staff_descr}</div></div>
											<div class="span3">
												<ul class="unstyled">
													<li>Тел: <a href="#">{$staff.phone}</a></li>
													<li>Email: <a href="mailto:{$staff.mail}">{$staff.mail}</a></li>
												</ul>
											</div>
										</li>
									{/foreach}	
								</ul>
							{else}
								<p>Администрация инкогнито :]</p>
							{/if}
							
							
							<h3 class="inner-bg">Участники клуба<!--<span class="pull-right">223 человека</span>--></h3>
							{if $club.members}
							<ul class="clubs-members">
								{foreach $club.members as $member}
									<li><a href="/user.php?id={$member.id}"><img src="{$member.avatar}" /><p>{$member.fio}</p></a></li>
								{/foreach}
							</ul>
							{else}
								<p>В клубе пока нет участников.</p>
							{/if}
						</div>
					</div>
				</div> <!-- //about-club -->
				
				<div class="tab-pane" id="competitions-club">


				<!-- implement datepicker -->
				<link rel="stylesheet" type="text/css" media="all" href="css/datepicker.css" />
				<script src="js/bootstrap-datepicker.js"></script>
				<script src="js/bootstrap-datepicker.ru.js"></script>
				<style>
					.activeDate {
						background-color: green;
					}
				</style>
				<script>
					var cal_comp = $.parseJSON('{$datepicker}');
					 $(function () {
						$('#compt-box-container').datepicker({
							language: "ru",
							dateFormat: 'yy-mm-dd',
							minDate: new Date(), 
							beforeShowDay: function(d) {
								var year = d.getFullYear() + "-";
								var month = "";
								var day = "";
								if ((d.getMonth()+1) < 10)
									month = "0" + (d.getMonth()+1) + "-";
								else
									month = (d.getMonth()+1) + "-";
								if (d.getDate() < 10)
									day = "0" + d.getDate();
								else
									day = d.getDate();

								var date = year+month+day;
								//console.log(cal_comp[date]);
								
								if (cal_comp[date] === undefined) {
									console.log(cal_comp[date]);
									return {
										enabled : false,
										tooltip : "Нет соревнования."
									};        
								} else {
									return {
										enabled : true,
										classes: "activeDate",
										tooltip : cal_comp[date].join(",\n")
									};					
								}
							}
						}).on ("changeDate", function (a) {
								var d = new Date(a.date);
								var year = d.getFullYear() + "-";
								var month = "";
								var day = "";
								if ((d.getMonth()+1) < 10)
									month = "0" + (d.getMonth()+1) + "-";
								else
									month = (d.getMonth()+1) + "-";
								if (d.getDate() < 10)
									day = "0" + d.getDate();
								else
									day = d.getDate();

								var date = year+month+day;
								console.log(date);
								$("#comptTabContent tr[data-date]").css("display", "none");
								$("#comptTabContent tr[data-date="+date+"]").css("display", "table-row");
						});
					});
				</script>

					<div class="row">
						<div class="span4" style="text-align: justify">
							<!--<table class="calendar">
									<thead>
										<tr class="month">
										  <th colspan="7" class="tac" >
											<a><i class="icon-chevron-left"></i></a>
											<a>Февраль 2014</a>
											<a><i class="icon-chevron-right"></i></a>
										  </th>
										</tr>
										<tr class="days">
											<th>Пн</th>
											<th>Вт</th>
											<th>Ср</th>
											<th>Чт</th>
											<th>Пт</th>
											<th>Сб</th>
											 <th>Вс</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="muted">29</td>
											<td class="muted">30</td>
											<td class="muted">31</td>
											<td>1</td>
											<td>2</td>
											<td>3</td>
											<td>4</td>
										</tr>
										<tr>
											<td>5</td>
											<td>6</td>
											<td>7</td>
											<td>8</td>
											<td>9</td>
											<td>10</td>
											<td>11</td>
										</tr>
										<tr>
											<td>12</td>
											<td>13</td>
											<td>14</td>
											<td>15</td>
											<td>16</td>
											<td>17</td>
											<td>18</td>
										</tr>
										<tr>
											<td>19</td>
											<td class="today">20</td>
											<td>21</td>
											<td>22</td>
											<td>23</td>
											<td>24</td>
											<td>25</td>
										</tr>
										<tr>
											<td>26</td>
											<td>27</td>
											<td>28</td>
											<td>29</td>
											<td class="muted">1</td>
											<td class="muted">2</td>
											<td class="muted">3</td>
										</tr>
									</tbody>
								</table>-->
								<div id="compt-box-container"></div>
						</div>
						
						<div class="span8" style="text-align: justify">
							<h4>Ближайшее соревнование</h4>
							{if $club.competitions.soon}
								<div class="row">
									<div class="span1"><a href="/competition.php?id={$club.competitions.soon.id}"><img src="images/icons/{$club.competitions.soon.type}.jpg" /></a></div>
									<div class="span7 comp-info">
										<div class="row">
											<div class="span5">
												<div class="compt-name"><a href="/competition.php?id={$club.competitions.soon.id}">{$club.competitions.soon.name}</a></div>
												<div class="compt-date">{$club.competitions.soon.bdate} (через {$club.competitions.soon.diff} дней)</div>
											</div>
											{*<div class="span2">
												<a href="#" class="btn btn-warning">Участвовать <i class="icon-play icon-white"></i></a>
											</div>*}
										</div>
										<dl>
											{*<dt>Будут присутствовать:</dt>
											<dd>
												<ul class="inline compt-members">
													<li>25 участников</li>
													<li>4 фотографа</li>
													<li>120 зрителей</li>
												</ul>
											</dd>
											<dt>О соревновании:</dt>*}
											<dd>{$club.competitions.soon.desc} </dd>
										</dl>
									</div>
								</div>

								{*<div class="answer-block">
									<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
								</div>*}
							{else}
								<p class="text-align: center;">Соревнований либо нет, либо они прошли.</p>
							{/if}
						</div>
					</div>
					<div class="row">
			<div class="span12">
				{include "modules/competition-page.tpl" competitions = $club.competitions}
          	</div>
		 
					</div>
				</div> <!-- //competitions-club -->
				
				<div class="tab-pane" id="rating-club">
					<div class="row">
						<div class="span3" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены.</p>
						</div>
						<div class="span3" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены.</p>
						</div>
						<div class="span3" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены.</p>
						</div>
						<div class="span3" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены.</p>
						</div>
					</div>
				</div> <!-- //rating-club -->
				
				<div class="tab-pane" id="gallery-club">
					<div class="row">

						<ul id="gallery-tabs" class="nav nav-tabs new-tabs tabs2">
							<li class="active"><a href="#gal-foto" data-toggle="tab">Фото</a></li>
							<li><a href="#gal-video" data-toggle="tab">Видео</a></li>
						</ul>
						<div id="GalTabContent" class="tab-content">
							<div class="tab-pane in active" id="gal-foto"> <!-- tab-photo-->
								
								<div class="albums">
									<div class="span12">
										<a href="#modal-add-edit-album" role="button" data-toggle="modal" class="pull-right btn btn-default btn-create-album" >Создать альбом</a>
										<a href="#" class="pull-right btn btn-warning">Добавить фото</a>
										<h5 class="title-hr">Альбомы</h5>
									</div>
									
									<div class="span12">
									<ul class="album-wall">
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-1.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №1</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-3.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №2</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-5.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №3</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-4.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №4</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-2.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №5</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-1.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №6</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="http://odk/club-sample-gallery-album.php"><img src="i/sample-img-5.jpg"></a>
											<a href="http://odk/club-sample-gallery-album.php"><p>Маршрут №7</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
									</ul>
									</div>
									
									<div class="span12">
										<h5 class="title-hr">Фотографии пользователей</h5>
										<div class="row users-albums">
											<ul class="inline unstyled">
												<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="avatar"> Александр Гетманский</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg" class="avatar"> Елена Урановая</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg" class="avatar"> Наталья Валюженич</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg" class="avatar"> Александр Гетманский</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg" class="avatar"> Елена Урановая</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="avatar"> Наталья Валюженич</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg" class="avatar"> Александр Гетманский</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg" class="avatar"> Елена Урановая</a> (123 фото)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg" class="avatar"> Наталья Валюженич</a> (123 фото)</li>
											</ul>
										
										</div>
									</div>
									
								</div>
								
							</div> <!-- /tab-photo-->
							
							<div class="tab-pane" id="gal-video"> <!-- tab-video-->
								
								<div class="albums">
									<div class="span12">
										<a href="#modal-add-edit-album" role="button" data-toggle="modal" class="pull-right btn btn-default btn-create-album">Создать альбом</a>
										<a href="#" class="pull-right btn btn-warning">Добавить видео</a>
										<h5 class="title-hr">Альбомы</h5>
									</div>
									
									<div class="span12">
									<ul class="album-wall">
										<li>
											<a href="#"><img src="i/sample-img-1.jpg"></a>
											<a href="#"><p>Маршрут №1</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="#"><img src="i/sample-img-3.jpg"></a>
											<a href="#"><p>Маршрут №2</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="#"><img src="i/sample-img-5.jpg"></a>
											<a href="#"><p>Маршрут №3</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
										<li>
											<a href="#"><img src="i/sample-img-4.jpg"></a>
											<a href="#"><p>Маршрут №4</p></a>
											<p>Наряду с этим врожденная интуиция рассматривается смысл жизни, открывая ...</p>
										</li>
									</ul>
									</div>
									
									<div class="span12">
										<h5 class="title-hr">Видео пользователей</h5>
										<div class="row users-albums">
											<ul class="inline unstyled">
												<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="avatar"> Александр Гетманский</a> (123 видео)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg" class="avatar"> Елена Урановая</a> (123 видео)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg" class="avatar"> Наталья Валюженич</a> (123 видео)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg" class="avatar"> Александр Гетманский</a> (123 видео)</li>
												<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg" class="avatar"> Елена Урановая</a> (123 видео)</li>												
											</ul>
										
										</div>
									</div>
									
								</div>
								
							</div> <!-- /tab-video-->
						</div>	
					
					</div>
				</div> <!-- //gallery-club -->
				
				<div class="tab-pane" id="contact-club">
					<div class="row">
							<div class="span12">
									<p>еальность. Катарсис, как следует из вышесказанного, решительно подчеркивает смысл жизни, учитывая опасность, которую представляли собой писания Дюринга для не окрепшего еще немецкого рабочего движения. Отношение к современности понимает под собой конфликт, однако Зигварт считал критерием истинности необходимость и общезначимость, для которых нет никакой опоры в объективном мире. Искусство заполняет бабувизм, при этом буквы А, В, I, О символизируют соответственно общеутвердительное, общеотрицательное, частноутвердительное и частноотрицательное суждения.</p>
							</div>
						</div>
				</div> <!-- //contact-club -->
				
			
				</div>
			</div>
			</div>

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}