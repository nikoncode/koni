{* Smarty *}

{include "modules/header.tpl"}

<script type="text/javascript" src="js/friends.js"></script>
<script>
function add_to_friend_callback(uid, el) {
	add_to_friend(uid, function () {
		$(el).attr("onclick", "delete_from_friend_callback(" + uid + ", this);return false;");
		$(el).text("Удалить из друзей");	
	});
}

function delete_from_friend_callback(uid, el) {
	delete_from_friend(uid, function () {
			$(el).attr("onclick", "add_to_friend_callback(" + uid + ", this);return false;");
			$(el).text("Добавить в друзья");
	});
}
</script>
<div class="container friends-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-bgborder block" style="background-color: #fff">
				<h3 class="inner-bg">Друзья <!--<span class="pull-right">4 друга</span>--></h3>
			
				
				<div class="tab-pane in active" id="all-friends">
					<div class="row">
						<form class="form-in-messages">
						<div class="controls controls-row">
								<input type="text" class="span3 search-query" placeholder="Начните вводить имя друга">
								<a href="friends-add.php" class="btn btn-warning span3">Искать друзей</a>
						</div>
						</form>
					</div>
				<div class="friends-list">
					{if $friends}
						{foreach $friends as $friend}	
							<div class="my-friend span6">
								<div class="row">
									<div class="user-info-photo span1">
										<a href="/user.php?id={$friend.id}"><img src="{$friend.avatar}" class="friend-avatar"></a>
									</div>
									<div class="user-info-about span3">
										<ul>
											<li class="user-name"><a href="/user.php?id={$friend.id}">{$friend.fio}</a></li>
										</ul>
									</div>
									<div class="span2 user-info-actions">
										<ul>
											<li><a href="chat.php?id={$friend.id}">Написать сообщение</a></li>
											{if !$another_user}<li><a href="#" onclick="delete_from_friend_callback({$friend.id}, this);return false;">Убрать из друзей</a></li>{/if}
										</ul>
									</div>
								</div>
							</div>
						{/foreach}
					{else}
						<p style="text-align: center;">У вас пока нет друзей. Может быть вы хотите их <a href="/find-users.php">найти</a>?</p>
					{/if}
				</div>
			</div> <!-- //all-friends -->
			
			
			</div>
			{if $another_user}
				{include "modules/sidebar-user-right.tpl"}
			{else}
				{include "modules/sidebar-my-right.tpl"}
			{/if}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}