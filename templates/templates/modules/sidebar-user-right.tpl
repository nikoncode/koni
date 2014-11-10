{* Smarty *}

<script type="text/javascript" src="js/friends.js"></script>
<script>
function add_to_friend_callback(uid) {
	add_to_friend(uid, function () {
		$("#friends-button").attr("onclick", "delete_from_friend_callback(" + uid + ");return false;");
		$("#friends-button").text("Удалить из друзей");	
	});
}

function delete_from_friend_callback(uid) {
	delete_from_friend(uid, function () {
			$("#friends-button").attr("onclick", "add_to_friend_callback(" + uid + ");return false;");
			$("#friends-button").text("Добавить в друзья");
	});
}
</script>
<div class="span3 lthr-bgborder block" id="sidebarRight">
	
	<div class="user-info">
		<center><a href="/user.php?id={$another_user.id}"><img src="{$another_user.avatar}" class="current-user-avatar" /></a></center>
		<h2 class="user-name">{$another_user.fio}</h2>
		<p class="user-info">{$another_user.info}</p>
		{if $another_user.profs}
			<ul class="user-profs inline">
				{foreach $another_user.profs as $prof}
					<li>{$prof}{if !$prof@last},{/if}</li>
				{/foreach}
			</ul>
		{/if}
		<p class="user-club">
			{if $another_user.club_name}
				Состоит в клубе "<a href="club.php?id={$another_user.club_id}">{$another_user.club_name}</a>"
			{else}
				Не состоит в <a href="clubs.php">клубах</a>
			{/if}
		</p>
        {if $another_user.hand == 0}
		<ul class="unstyled user-controls">
			<li><a class="btn btn-warning" href="/chat.php?id={$another_user.id}"><i class="icon-envelope icon-white"></i> Отправить сообщение</a></li>
			{if $another_user.is_friends}
				<li><button class="btn" href="#" id="friends-button" onclick="delete_from_friend_callback({$another_user.id});return false;">Удалить из друзей</button></li>
			{else}
				<li><button class="btn" href="#" id="friends-button" onclick="add_to_friend_callback({$another_user.id});return false;">Добавить в друзья</button></li>
			{/if}
		</ul>

        {else}
            Эта страница создана автоматически, если это Вы и хотите получить доступ к управлению своей страницей, то напишите <a href="/support.php">Службу поддержки</a>
        {/if}
	</div>
	
	{if $another_user.friends}
		<div>
			<h3 class="inner-bg">Друзья</h3>
			<ul class="my-friends-menu">
				{foreach $another_user.friends as $friend}
					<li><a href="user.php?id={$friend.id}"><img src="{$friend.avatar}" /><p>{$friend.fio}</p></a></li>
				{/foreach}
			</ul>
			<div class="clear"></div>
		</div>
	{/if}
    <div class="my-events">
        <h3 class="inner-bg">Мероприятия</h3>
        <div class="my-events-list">
            <h4 class="event-next">Ближайшие</h4>
            {if $another_user.competitions}
                <dl class="dl-horizontal">
                    {foreach $another_user.competitions as $comp}
                        <dt>{$comp.date.0}.{$comp.date.1}</dt>
                        <dd><a href="/competition.php?id={$comp.id}">{$comp.name}</a></dd>
                    {/foreach}
                </dl>
                <div class="text-center"><a href="/user-events.php?id={$another_user.id}">Все соревнования</a></div>
            {else}
                <p class="text-align: center;">Нет соревнований.</p>
            {/if}
        </div>
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