{* Smarty *}
{if $finded_users}
	{foreach $finded_users as $fu}
		<div class="my-friend span6">
			<div class="row">
				<div class="user-info-photo span1">
					<a href="/user.php?id={$fu.id}" {if $show_right == 0}target="_blank"{/if}><img src="{$fu.avatar}" class="friend-avatar"></a>
				</div>
				<div class="user-info-about span3">
					<ul>
						<li class="user-name"><a href="/user.php?id={$fu.id}" {if $show_right == 0}target="_blank"{/if}>{$fu.fio}</a></li>
						<li class="from">{$fu.country}, {$fu.city}</li>
						<li class="status">
							{if $fu.club}
								Состоит в "<a href="/club.php?id={$fu.cid}">{$fu.club}</a>"
							{else}
								Не состоит в клубе
							{/if}
						</li>
					</ul>
				</div>
				{if $show_right == 1}
                    <div class="span2 user-info-actions">
                        <ul>
                            <li><a href="/chat.php?id={$fu.id}">Написать сообщение</a></li>
                            <li id="fradd">
                                {if $fu.is_friends}
                                    <a href="#" onclick="delete_from_friend_callback({$fu.id}, this);return false;">Убрать из друзей</a>
                                {else}
                                    <a href="#" onclick="add_to_friend_callback({$fu.id}, this);return false;">Добавить в друзья</a>
                                {/if}
                            </li>
                        </ul>
                    </div>
                {/if}
			</div>
		</div>
	{/foreach}
{else}
{if $show_right == 1}<p style="text-align: center;">Не найдено.</p>{/if}
{/if}