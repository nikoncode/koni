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
	})
</script>

<div class="container clubs-page main-blocks-area club-block img.club-avatar">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-info" style="background-color: #fff">
				<h3 class="inner-bg">{$club.name}{*<span class="pull-right text-italic">Общий рейтинг: <strong>2367</strong> / Рейтинг по соревнованиям: <strong>7632</strong>*}
					{if $club.o_uid == $user.id}
						<a href="club-admin.php?id={$club.id}">[админ]</a></span>
					{/if}
				</h3>
				<div class="row">
					<div class="span3">
						<a href="#"><img src="{$club.avatar}" class="club-avatar" /></a>
						<input type="button" class="btn btn-warning goto-club" value="Вступить в клуб" />
						<p class="club-access-descr">Вы ещё не вступали ни в однин из <a href="#">клубов</a></p>
					</div>
					
					<div class="span6 current-club-descr">
						<p class="current-club-descr">
							{$club.sdesc}
						</p>
						<dl class="dl-horizontal">
							{if $club.site}
								<dt>Веб-сайт:</dt>
								<dd><a href="{$club.site}">{$club.site}</a></dd>
							{/if}
							{if $club.email}
								<dt>E-mail:</dt>
								<dd><a href="mailto:{$club.email}">{$club.email}</a></dd>
							{/if}
							{if $club.phones}
								<dt>Телефоны:</dt>
								<dd>
									<ul class="unstyled">
										{foreach $club.phones as $phone}
											<li>{$phone@key} - {$phone}</li>
										{/foreach}
									</ul>
								</dd>
							{/if}
							{if $club.adress}
								<dt>Адрес:</dt>
								<dd>{$club.adress}</dd>
							{/if}
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
								{include "iterations/news_block.tpl"}
							</ul>
						</div>
						
						<div class="span6">
							<div>
								<h4>Отзывы</h4>
								<img src="!odk-rate.png"/>
							</div>
							
							<hr/>
							
							<div class="club-add-your-review">
								<h4>Добавить свой отзыв</h4>
								<form class="row">
									<textarea placeholder="Что Вы думаете об этом клубе?" rows="5" class="span6"></textarea>
									<div class="span4 club-review-rate">
										<ul class="horseshoe-rate">
											<li class="title">Оцените клуб: </li>
											<li class="horseshoe rate-1 active"></li>
											<li class="horseshoe rate-2 active"></li>
											<li class="horseshoe rate-3"></li>
											<li class="horseshoe rate-4"></li>
											<li class="horseshoe rate-5"></li>
										</ul>
									</div>
									<input type="button " value="Отправить отзыв" class="btn btn-warning span2" />
								</form>
							</div>
							
							<hr/>
							
							<div class="club-reviews">
											<ul class="comments-lists">
												<li class="comment">
													<img src="i/avatar-1.jpg" class="avatar" />
													<p class="user-name"><a href="#">Leon Ramos</a></p>
													<p class="date">15.02.2013 в 14:11</p>
													<div class="horseshoe-rate-block">
														<ul class="horseshoe-rate">
															<li class="horseshoe rate-1 active"></li>
															<li class="horseshoe rate-2 active"></li>
															<li class="horseshoe rate-3 active"></li>
															<li class="horseshoe rate-4 active"></li>
															<li class="horseshoe rate-5 active"></li>
														</ul>
														<div class="clearfix"></div>
													</div>
													<p class="message">Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены.</p>
													<div class="useful-review">
														<p><em>Отзыв полезен? </em><span><a href="#" class="yes-useful">Да:</a> 146 / </span><span><a href="#" class="not-useful">Нет:</a> 13 </span></p>
													</div>
												</li>
												
												<li class="comment">
													<img src="i/avatar-2.jpg" class="avatar" />
													<p class="user-name"><a href="#">Вася Горбунков</a></p>
													<p class="date">15.02.2013 в 13:11</p>
													<div class="horseshoe-rate-block">
														<ul class="horseshoe-rate">
															<li class="horseshoe rate-1 active"></li>
															<li class="horseshoe rate-2 active"></li>
															<li class="horseshoe rate-3 active"></li>
															<li class="horseshoe rate-4 active"></li>
															<li class="horseshoe rate-5"></li>
														</ul>
														<div class="clearfix"></div>
													</div>
													<p class="message"><a href="#" class="comment-reply">Leon, </a>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха. Содержание лошадей отвечает самым строгим требованиям зоогигиены..</p>
													<div class="useful-review">
														<p><em>Отзыв полезен? </em><span><a href="#" class="yes-useful">Да:</a> 146 / </span><span><a href="#" class="not-useful">Нет:</a> 13 </span></p>
													</div>
												</li>
												
											</ul>
										
										<div class="pagination">
											<ul class="page-list">
												<li class="title">Страницы: </li>
												<li class="active page"><a href="#">1</a></li>
												<li class="page"><a href="#">2</a></li>
												<li class="page"><a href="#">3</a></li>
												<li class="page"><a href="#">4</a></li>
												<li class="page"><a href="#">5</a></li>
											</ul>
										</div>
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
					<div class="row">
						<div class="span4" style="text-align: justify">
							<table class="calendar">
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
								</table>
						</div>
						<div class="span8" style="text-align: justify">
							<h4>Ближайшее соревнование</h4>
							<div class="row">
								<div class="span1"><a href="#"><img src="images/icon-competition-1.jpg" /></a></div>
								<div class="span7 comp-info">
									<div class="row">
										<div class="span5">
											<div class="compt-name"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия) [М3, 115 см, любители (н)]</a></div>
											<div class="compt-date">15.02.2013 в 14:11 (через 15 дней)</div>
										</div>
										{*<div class="span2">
											<a href="#" class="btn btn-warning">Участвовать <i class="icon-play icon-white"></i></a>
										</div>*}
									</div>
									<dl>
										<dt>Будут присутствовать:</dt>
										<dd>
											<ul class="inline compt-members">
												<li>25 участников</li>
												<li>4 фотографа</li>
												<li>120 зрителей</li>
											</ul>
										</dd>
										<dt>О соревновании:</dt>
										<dd>Eдинственной космической субстанцией Гумбольдт считал материю, наделенную внутренней активностью, несмотря на это созерцание контролирует дедуктивный метод, отрицая очевидное. Адаптация, по определению, изоморфна времени. </dd>
									</dl>
								</div>
							</div>
							<div class="answer-block">
								<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
							</div>
						</div>
					</div>
					<div class="row">
	<div class="span12">
            <ul id="comptTab" class="nav nav-tabs">
              <li class="active"><a href="#compt-future" data-toggle="tab">Будущие</a></li>
              <li><a href="#compt-present" data-toggle="tab">Внастоящий момент</a></li>
              <li><a href="#compt-past" data-toggle="tab">Прошедшие</a></li>
              <li>
				<form>
					<div class="controls controls-row">
						<select class="span3">
							<option selected>Все типы соревнований</option>
							<option>Конкур</option>
							<option>Забег</option>
							<option>Скачки</option>
							<option>Препятствия</option>
					   </select>
					</div>
				</form>
			</li>
            </ul>
            <div id="comptTabContent" class="tab-content">
              <div class="tab-pane in active" id="compt-future">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-2.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-3.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-4.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
					</tbody>
					</table>
              </div>
              <div class="tab-pane" id="compt-present">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-3.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-4.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
					</tbody>
					</table>
              </div>
			  <div class="tab-pane" id="compt-past">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-2.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-3.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
						 <tr>
							<td class="compt-img"><a href="#"><img src="images/icon-competition-4.jpg" /></a></td>
							<td class="compt-date">26 июля 2014 г. <div>через 1 год</div></td>
							<td class="competition">
								<a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
							</td>
							<td class="compt-members">
								<ul class="inline compt-members">
									<li>25 участников</li>
									<li>4 фотографа</li>
									<li>120 зрителей</li>
								</ul>
							</td>
						</tr> 
					</tbody>
					</table>
              </div>
            </div>
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