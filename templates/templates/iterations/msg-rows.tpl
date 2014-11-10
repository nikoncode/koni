{if $messages}
    {foreach $messages as $mes}
        <div class="row">
            <div class="msg-user-info span2">
                <a href="user-sample.php"><img src="{$mes.avatar}" class="avatar"></a>
                <p class="user-name"><a href="user.php?id={$mes.uid}">{$mes.fio}</a></p>
                <p class="date">{$mes.time}</p>
            </div>
            <div class="span8 msg-last-message">
                <p class="last-message not-readed"><a href="chat.php?id={$mes.uid}">{$mes.text}</a></p>
            </div>
        </div>
    {/foreach}
{else}
    <p>Нет непрочитанных сообщений.</p>
{/if}