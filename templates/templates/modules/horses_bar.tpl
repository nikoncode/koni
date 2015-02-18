{* Smarty *}
{if $horses_bar}
	<div class="my-horses">
		{foreach $horses_bar as $key=>$horse}
			{if $key == 0}
				<img src="{$horse.avatar}" class="avatar-my-horse-top"/>
				<h2 class="my-horse-name"><a href="/horse.php?id={$horse.id}">{$horse.nick}</a></h2>
				<p class="my-horse-info">{$horse.poroda}</p>
				<ul class="my-horse-award" style="display: none">
					<li><img src="images/sample-small-award-1.png" /></li>
					<li><img src="images/sample-small-award-2.png" /></li>
					<li><img src="images/sample-small-award-3.png" /></li>
					<li><img src="images/sample-small-award-1.png" /></li>
					<li><img src="images/sample-small-award-2.png" /></li>
					<li><img src="images/sample-small-award-3.png" /></li>
				</ul>
				<hr/>
			{else}
				<a href="/horse.php?id={$horse.id}"><img src="{$horse.avatar}" class="avatar-my-horse-bottom"/></a>
			{/if}
		{/foreach}
		<a href="/horses.php?id={$horses_bar_id}" class="btn btn-warning btn-warning-primary">Показать всех лошадей</a>
	</div>
{/if}