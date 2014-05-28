{* Smarty *}
{include "modules/header.tpl"}

<div class="container current-horse-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
				<div>
				<h3 class="inner-bg">{if $another_user}Лошади '{$another_user.fio}'{else}Ваши лошади{/if}<span class="pull-right"><a href="horses.php{if $another_user}?id={$another_user.id}{/if}">Назад ко всем лошадям</a></span></h3>
				
				<ul id="horseTab" class="nav nav-tabs new-tabs tabs2">
					<li class="active"><a href="#horse-info" data-toggle="tab">Информация</a></li>
					<li><a href="#horse-competitions" data-toggle="tab">Соревнования</a></li>
					<li><a href="#horse-gallery" data-toggle="tab">Галереи</a></li>
				</ul>
				
			<div id="horseTabContent" class="new-tabs tab-content">
				
			<div class="tab-pane in active" id="horse-info">
				<div class="my-horses">
					<div class="common-info row">
						<img src="i/avatar-my-horse-1.jpg" class="avatar-my-horse-top"/>
						<h2 class="my-horse-name">{$horse.nick}</h2>
						<p class="my-horse-info">{$horse.age} лет ({$horse.byear} г. р.)</p>
						<ul class="my-horse-award">
							<li><img src="images/sample-small-award-1.png" /></li>
							<li><img src="images/sample-small-award-2.png" /></li>
							<li><img src="images/sample-small-award-3.png" /></li>
							<li><img src="images/sample-small-award-1.png" /></li>
							<li><img src="images/sample-small-award-2.png" /></li>
							<li><img src="images/sample-small-award-3.png" /></li>
						</ul>
						<ul class="this-horse-info">
							<li><span>Пол: </span>{$horse.sex}</li>
							{if $horse.rost}<li><span>Рост: </span>{$horse.rost} см.</li>{/if}
							<li><span>Специализация: </span>{$horse.spec}</li>
							<li><span>Масть: </span>{$horse.mast}</li>
							<li><span>Порода: </span>{$horse.poroda}</li>
							</ul>
						
					</div>
					
					
					
					<hr/>
					
					{if $horse.parents || $horse.bplace}
						<div class="row ">
							<p class="title">Родословная:</p>
							<ul class="horse-pedigree">
								{if $horse.bplace}
									<li class="place-birth"><span>Место рождения: </span><a href="/clubs-sample.php">{$horse.bplace}</a></li>
								{/if}
								{foreach $horse.parents as $parent}
									<li class="pedigree-members"><span>{$parent@key}: </span><a href="/horse-sample.php">{$parent}</a></li>
								{/foreach}
							</ul>
						</div>
						<hr/>
					{/if}
					
					{if $horse.about}
						<div class="row ">
							<p class="title">О лошади:</p>
							<p>{$horse.about}</p>
						</div>
						<hr/>
					{/if}
					
					<div class="row ">
						<p class="title">Комментарии:</p>
						<script type="text/javascript" src="js/comments.js"></script>
						<script type="text/javascript" src="js/likes.js"></script>
						{include "iterations/comments_block.tpl"}
					</div>
					
				</div>
			</div> <!-- //horse-info -->
			
			<div class="tab-pane in" id="horse-competitions">
				<div class="future-events">
					<h5>Будущие соревнования</h5>
					<table class="table table-striped competitions-table">
						  <tr><td>
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
						</td></tr>
						 <tr><td>
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
						</td></tr>
						 <tr><td>
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
						</td></tr>
					</table>
				</div>
			
			<hr/>
			
				<div class="past-events">
					<h5>Прошедшие соревнования</h5>
					<form class="form-horizontal"  method="post" action="<?php echo $_SERVER['QUERY_STRING']; ?>">
						<div class="row">	
						
							<div class="controls controls-row">
								<label class="span2">Тип соревнования:</label><label class="span2">Месяц:</label><label class="span2">Год проведения:</label>
								<select class="span2">
									<option>Тип 1</option>
									<option>Тип 2</option>
									<option>Тип 3</option>
									<option>Тип 4</option>
									<option>Тип 5</option>
									<option>Тип 6</option>
							   </select>
								<select class="span2">
									<option>Январь</option>
									<option>Февараль</option>
									<option>Март</option>
									<option>Апрель</option>
									<option>Май</option>
									<option>Июнь</option>
									<option>Июль</option>
									<option>Август</option>
									<option>Сентябрь</option>
									<option>Октябрь</option>
									<option>Ноябрь</option>
									<option>Декабрь</option>
							   </select>
							   <select class="span2">
									<option>2013</option>
									<option>2012</option>
									<option>2011</option>
									<option>2010</option>
									<option>2009</option>
									<option>2008</option>
									<option>2007</option>
									<option>2006</option>
									<option>2005</option>
									<option>2004</option>
									<option>2003</option>
									<option>2002</option>
									<option>2001</option>
									<option>2000</option>

							   </select>
							</div>
						</div>
					</form>
					
					<table class="table table-striped competitions-table">
						<tr>
						  <th>Соревнование</th>
						  <th>Место</th>
						  <th>Результат</th>
						</tr>
						 <tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
						<tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
						<tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
						<tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
						<tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
						<tr>
							<td class="competition">
								<p class="comp-date">26 октября</p>
								<p><a href="/events.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
					</table>
					
				</div>
			</div> <!-- //horse-competitions -->
			
			<div class="tab-pane in" id="horse-gallery">
				<div class="photos">
					<h5>Фото:</h5>
					<ul class="photo-wall">
						<li><img src="i/sample-img-1.jpg" /></li>
						<li><img src="i/sample-img-2.jpg" /></li>
						<li><img src="i/sample-img-3.jpg" /></li>
						<li><img src="i/sample-img-4.jpg" /></li>
						<li><img src="i/sample-img-5.jpg" /></li>
						<li><img src="i/sample-img-1.jpg" /></li>
						<li><img src="i/sample-img-2.jpg" /></li>
						<li><img src="i/sample-img-3.jpg" /></li>
						<li><img src="i/sample-img-4.jpg" /></li>
						<li><img src="i/sample-img-5.jpg" /></li>
					</ul>
				</div>
				
				<div class="clearfix"></div>
				
				<div class="photos video-gallery">
					<h5>Видео:</h5>
					<ul class="photo-wall video-wall">
						<li style="background: url(i/sample-img-1.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-2.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-3.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-4.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-5.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
					</ul>
				</div>
			</div> <!-- //horse-gallery -->
			
			</div>

			
				</div>
			</div>
			{if $another_user}
				{include "modules/sidebar-user-right.tpl"}
			{else}
				{include "modules/sidebar-my-right.tpl"}
			{/if}
		</div> <!-- /row -->
</div>


{include "modules/footer.tpl"}