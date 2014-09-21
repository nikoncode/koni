{* Smarty *}
<script>
    {literal}
    function check_notice(element,id) {
        api_query({
            qmethod: "POST",
            amethod: "check_notice",
            params: {id : id},
            success: function (resp, data) {
                $(element).closest('.event-block').remove();
            },
            fail: "standart"
        });
    }
    {/literal}

</script>
<div id="modal-myEvents" class="modal modal800 bg-white hide head-menu-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header ">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Мои уведомления<span class="pull-right">{$user.notice_count} уведомления</span></h3>
    </div>
    <div class="modal-body">
        <div class="span10">
            {if $user.notice}
                {foreach $user.notice as $not}
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
        </div>
    </div>
</div>
</div>