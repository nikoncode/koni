{* Smarty *}
{if $finded_users}
    {foreach $finded_users as $fu}
        <div class="my-friend span6">
            <div class="row">
                <div class="user-info-photo span1">
                    <a href="/user.php?id={$fu.id}"><img src="{$fu.avatar}" class="friend-avatar"></a>
                </div>
                <div class="user-info-about span3">
                    <ul>
                        <li class="user-name"><a href="/user.php?id={$fu.id}">{$fu.fio}</a></li>
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
            </div>
        </div>
    {/foreach}
{/if}