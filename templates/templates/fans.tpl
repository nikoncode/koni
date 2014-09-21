{* Smarty *}

{include "modules/header.tpl"}
<div class="container friends-page main-blocks-area">
    <div class="row">
        {include "modules/sidebar-my-left.tpl"}
        <div class="brackets" id="bra-2"></div>
        <div class="brackets" id="bra-3"></div>

        <div class="span6 lthr-bgborder block" id="centerBlock" style="background-color: #fff">
            <h3 class="inner-bg">{$title}<span class="pull-right"><a href="/my-events.php"> вернуться в мероприятия</a></span></h3>


            <div class="tab-pane in active">
                <div class="friends-list">
                    <div class="span6"><a href="competition.php?id={$compId}">{$compName}</a></div>
                    {if $users}
                        {foreach $users as $friend}
                            <div class="my-friend span3">
                                <div class="row">
                                    <div class="user-info-photo span1">
                                        <a href="/user.php?id={$friend.id}"><img src="{$friend.avatar}" class="friend-avatar"></a>
                                    </div>
                                    <div class="user-info-about span2">
                                        <ul>
                                            <li class="user-name"><a href="/user.php?id={$friend.id}">{$friend.fname} {$friend.lname}</a></li>
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
        {include "modules/sidebar-my-right.tpl"}

    </div> <!-- /row -->
</div>

{include "modules/footer.tpl"}