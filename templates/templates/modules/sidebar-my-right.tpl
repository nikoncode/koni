{* Smarty *}
<div class="span3  lthr-bgborder block" id="sidebarRight">
	{*<div class="my-awards">
		<h3 class="inner-bg">Мои награды<span class="pull-right">5 наград</span></h3>
		<center>
			<img src="i/sample-award-1.png" class="my-award-top"/><h2 class="my-award-name">1 место</h2>
			<p class="my-award-info">в соревнованиях «Битца»</p>
		</center>
		<img src="i/sample-award-2.png" class="my-award-bottom"/>
		<img src="i/sample-award-3.png" class="my-award-bottom"/>
		<img src="i/sample-award-1.png" class="my-award-bottom"/>
		<center><a href="#" class="goto-all-awards">Перейти ко всем наградам (23 шт.)</a></center>
	</div>
	
	<div class="clear"></div>*}
	
	<div class="my-events">
		<h3 class="inner-bg">Мероприятия</h3>
		<div class="my-events-list">
			<h4 class="event-next">Ближайшие</h4>
			{if $user.competitions}
				<dl class="dl-horizontal">
					{foreach $user.competitions as $comp}
						<dt>{$comp.date.0}.{$comp.date.1}</dt>
						<dd><a href="/competition.php?id={$comp.id}">{$comp.name}</a></dd>
					{/foreach}
				</dl>
			{else}
				<p class="text-align: center;">Нет соревнований.</p>
			{/if}
			{*<hr/>
			<h4 class="event-fav">Избранные</h4>
			<dl class="dl-horizontal">
				<dt>12.09</dt>
				<dd><a href="#">Выставка «Konya SEED 2013» в г. Москва</a></dd>
				<dt>16.10</dt>
				
				<dd><a href="#">«Вятская кунсткамера» открывает выставку</a></dd>
				<dt>21.12</dt>
				<dd><a href="#">Выставка «Konya SEED 2013» в г. Москва</a></dd>
			</dl>*}
		</div>
	</div>
	
	{*<div class="my-adv">
		<h3 class="inner-bg">Объявления</h3>
		<div class="my-adv-list">
			<h4 class="adv-fav">Интересные мне</h4>
			<dl class="dl-horizontal">
				<dt><img class="adv-img-small" src="i/avatar-my-horse-2.jpg" /></dt>
				<dd>
					<p><a href="#" class="adv-cat">Лошади</a></p>
					<p><a href="#" class="adv-text">возр. 3 года, спортивная, порода Русский рысак, гнедой масти, обучена в упряж,</a></p>
					<p class="adv-date">12 февраля 2013, г. Москва</p>
				</dd>
			<hr/>
			<dt><img class="adv-img-small" src="i/avatar-my-horse-3.jpg" /></dt>
				<dd>
					<p><a href="#" class="adv-cat">Лошади</a></p>
					<p><a href="#" class="adv-text">возр. 3 года, спортивная, порода Русский рысак, гнедой масти, обучена в упряж,</a></p>
					<p class="adv-date">12 февраля 2013, г. Москва</p>
				</dd>
			</dl>
			<hr/>
			<h4 class="adv-my">Мои объявления</h4>
			<p class="tac fsi">К сожалению, по вашим объявлениям ещё нет ответов</p>
		</div>
	</div>*}

</div>