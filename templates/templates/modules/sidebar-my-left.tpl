<div class="span3 lthr-bgborder block my-block">
	<div class="my-actions">
		<div class="my-avatar-block">
			<a href="/inner.php"><img src="{$user.avatar}" class="my-avatar" /></a>
			<div class="change-avatar-block">
				<a href="#modal-change-avatar" role="button" data-toggle="modal">Изменить аватар</a>
			</div>
		</div>
		<h2 class="my-name">{$user.fio}</h2>
		<p class="my-info">{$user.info}</p>
		{if $user.profs}
			<ul class="my-profs inline">
				{foreach $user.profs as $prof}
					<li>{$prof}{if !$prof@last},{/if}</li>
				{/foreach}
			</ul>
		{/if}
		<p class="my-club">
			{if $user.club_name}
				Состоит в клубе "<a href="club-sample.php?id={$user.club_id}">{$user.club_name}</a>"
			{else}
				Не состоит в <a href="clubs.php">клубах</a>
			{/if}
		</p>
		<ul class="my-actions-menu">
			<li class="my-news"><a href="inner.php">Моя страница</a></li>
			<li class="my-news"><a href="news.php">Новости</a></li>
			<li class="my-messages"><a href="messages.php">Сообщения</a></li>
			<li class="my-clubs"><a href="groups.php">Группы</a></li>
			<li class="my-events"><a href="events.php">Мероприятия</a></li>
			<li class="my-contacts"><a href="friends.php">Друзья</a></li>
			<li class="my-horses"><a href="horses.php">Лошади</a></li>
			<li class="my-gallery"><a href="gallery.php" >Галерея</a></li>
			<li class="my-adv"><a href="adv.php">Объявления</a></li>
			<li class="my-profile"><a href="profile.php">Настройки</a></li>
		</ul>
	</div>
	
	{if $friends_online}
		<div>
			<h3 class="inner-bg">Друзья онлайн</h3>
			<ul class="my-friends-menu">
				{foreach $user.friends_online as $friend}
					<li><a href="user-sample.php?id={$friend.id}"><img src="{$friend.avatar}" /><p>{$friend.fio}</p></a></li>
				{/foreach}
			</ul>
			<div class="clear"></div>
		</div>
	{/if}
	
	<!--<div class="my-groups-block">
		<h3 class="inner-bg">Мои группы<span class="pull-right">77 групп</span></h3>
		<ol class="my-groups-menu">
			<li><a href="#">Типичный конник</a></li>
			<li><a href="#">Мы-конники |MK|</a></li>
			<li><a href="#">Спорт и красота</a></li>
			<li><a href="#">MБK (Мы Братство Конников)</a></li>
			<li><a href="#">Конник</a></li>
			<li><a href="#">Клуб конников «Сибирская подкова»</a></li>
			<li><a href="#">Чёткий Конник</a></li>
			<li><a href="#">Сообщество конников*</a></li>
			<li><a href="#">Конник - спортсмен</a></li>
			<li><a href="#">"Если фотограф - конник"</a></li>
		</ol>
		<a href="#" class="to-all-groups">Все мои группы</a>
	</div>-->
</div>

<!-- модалки -->
<div id="modal-change-avatar" class="modal hide modal700" tabindex="-1" role="dialog">
<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Изменить аватар</h3>
	</div>
	<div class="modal-body step1">
			<form class="form-horizontal" action="#">
				<p>Друзьям будет проще узнать Вас, если Вы загрузите свою настоящую фотографию.</p>
				<div class="change-avatar-buttons">
						<input type="file" name="avatar-file" class="avatar-file">
						 <button type="submit" class="btn btn-warning">Загрузить</button>
						 <button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
				 </div>
				 <p class="avatar-descr">Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
			</form>
	</div>
	
	<div class="modal-body step2">
			<form class="form-horizontal" action="#">
				<p><center>Ожидайте загрузки файла.</center></p>
				<div class="progress progress-striped active">
					<div class="bar" style="width: 40%;"></div>
				</div>
				<div class="change-avatar-buttons">
						 <center><button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button></center>
				 </div>
				 <p class="avatar-descr">Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
			</form>
	</div>
	
	<div class="modal-body step3">
			<form class="form-horizontal" action="#">
				<p>Выбранная область будет показываться на Вашей странице.</p>
				<center><img src="http://odk/i/sample-img-5.jpg" />
				<div class="change-avatar-buttons">
						<button type="submit" class="btn btn-warning">Сохранить</button>
						 <button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
				 </div>
				 </center>
			</form>
	</div>
</div>