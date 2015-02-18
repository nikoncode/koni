{* Smarty *}
{if $users}
    {assign var="i" value="1"}
    {foreach $users as $user}
        <tr class="rating_user_row">
            <td class="rt-n">{$i++}</td>
            <td class="rt-club"><a href="user.php?id={$user.id}"><div class="club_logo"><img src="{$user.avatar}"></div>{$user.fname} {$user.lname}</a></td>
            <td class="rt-year">{$user.bdate}</td>
            <td class="rt-city">{$user.country}, {$user.city}</td>
            <td class="rt-club">{$user.club}</td>
            <td class="rt-points">{$user.ball}</td>
        </tr>
    {/foreach}
{else}
    <tr class="rating_user_row">
        <td colspan="6" style="text-align: center;">По вашему запросу, спортсменов не найдено. Измените условия поиска и попробуйте еще раз.</td>
    </tr>
{/if}