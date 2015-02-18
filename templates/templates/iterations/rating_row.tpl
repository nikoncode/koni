{* Smarty *}
{if $clubs}
{assign var="i" value="1"}
{foreach $clubs as $club}
    <tr class="rating_row">
        <td class="rt-n">{$i++}</td>
        <td class="rt-club"><a href="/club.php?id={$club.cid}"><div class="club_logo"><img src="{$club.avatar}"></div>{$club.name}</a></td>
        <td class="rt-city">{$club.address}</td>
        <td class="rt-members">{$club.members}  чел.</td>
        <td class="rt-points">{$club.rating|round:2}</td>
    </tr>
{/foreach}
{else}
    <tr class="rating_row">
        <td colspan="5" style="text-align: center;">По вашему запросу, клубов не найдено. Измените условия поиска и попробуйте еще раз.</td>
    </tr>
{/if}