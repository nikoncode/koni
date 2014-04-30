{* Smarty *}

<div class="span3 lthr-bgborder block">
	
	<div class="user-info">
		<center><a href="/user.php?id={$another_user.id}"><img src="{$another_user.avatar}" class="current-user-avatar" /></a></center>
		<h2 class="user-name">{$another_user.fio}</h2>
		<ul class="unstyled user-controls">
			<li><button class="btn btn-warning" href="/chat.php?id={$another_user.id}"><i class="icon-envelope icon-white"></i> Отправить сообщение</button></li>
				<li><button class="btn" href="#"><i class="icon-user"></i> Пригласить дружить</button></li>
		</ul>
	</div>
	
	<div>
		<h3 class="inner-bg">Друзья</h3>
		<ul class="user-friends-menu">
			<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg" /><p>Эрик Филлимонов </p></a></li>
			<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg" /><p>Екатерина Мариненко</p></a></li>
			<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg" /><p>Александр Гетманский</p></a></li>
			<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg" /><p>Кирилл Комоносов</p></a></li>
			<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg" /><p>Елена Урановая</p></a></li>
			<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg" /><p>Наталья Валюженич</p></a></li>		
		</ul>
		<div class="clear"></div>
	</div>
	
	<!--<div class="my-awards">
		<h3 class="inner-bg">Мои награды<span class="pull-right">5 наград</span></h3>
		<center>
			<img src="i/sample-award-1.png" class="my-award-top"/><h2 class="my-award-name">1 место</h2>
			<p class="my-award-info">в соревнованиях «Битца»</p>
		</center>
		<img src="i/sample-award-2.png" class="my-award-bottom"/>
		<img src="i/sample-award-3.png" class="my-award-bottom"/>
		<img src="i/sample-award-1.png" class="my-award-bottom"/>
		<center><a href="#" class="goto-all-awards">Перейти ко всем наградам (23 шт.)</a></center>
	</div>-->

</div>