{if $notice}
    {foreach $notice as $not}
        <div class="row event-block">
            <div class="event-user-avatar span2">
                {if $not.type == 'user'}<a href="user-sample.php"><img src="{$not.avatar}" class="avatar"></a>{/if}
                {if $not.type == 'club'}<a href="user-sample.php"><img src="{$not.avatarClub}" class="avatar"></a>{/if}
            </div>
            <div class="span8 event-message-block">
                <p class="user-name">
                    {if $not.type == 'user'}<a href="user.php?id={$not.user_id}">{$not.fio}</a>{/if}
                    {if $not.type == 'club'}<a href="club.php?id={$not.club_id}">{$not.clubName}</a>{/if}
                </p>
                <p class="date">{$not.time}</p>
                <p class="event-message">{$not.message}</p>
                <div class="event-answer-area">
                    <a href="#" class="btn btn-warning" onclick="check_notice(this,{$not.id})">Закрыть</a>
                </div>
            </div>
        </div>
    {/foreach}
{else}
    <p>Нет уведомлений</p>
{/if}