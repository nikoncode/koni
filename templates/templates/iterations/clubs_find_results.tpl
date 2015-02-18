{* Smarty *}
{if $clubs}
	{foreach $clubs as $club}
		<tr class="result">
			<td class="club-name"><a href="/club.php?id={$club.id}"><div class="club_logo"><img src="{$club.avatar}"></div>{$club.name}</a></td>
			<td class="club-place">
				{$club.country}
				{if $club.city}
					, {$club.city}
				{/if}
			</td>
			<td class="club-members">{$club.members_cnt}  чел.</td>
			<td class="club-rating">{$club.reviews}</td>
		</tr>
	{/foreach}
{else}
	<tr class="result">
		<td colspan="5" style="text-align: center;">По вашему запросу, клубов не найдено. Измените условия поиска и попробуйте еще раз.</td>
	</tr>
{/if}