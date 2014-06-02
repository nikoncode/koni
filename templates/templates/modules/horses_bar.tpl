{* Smarty *}
{if $horses_bar}
	<div class="my-horses">
		<img src="{$horses_bar.0.avatar}" class="avatar-my-horse-top"/>
		<h2 class="my-horse-name"><a href="/horse.php?id={$horses_bar.0.id}">{$horses_bar.0.nick}</a></h2>
		<p class="my-horse-info">{$horses_bar.0.poroda}</p>
		<ul class="my-horse-award">
			<li><img src="images/sample-small-award-1.png" /></li>
			<li><img src="images/sample-small-award-2.png" /></li>
			<li><img src="images/sample-small-award-3.png" /></li>
			<li><img src="images/sample-small-award-1.png" /></li>
			<li><img src="images/sample-small-award-2.png" /></li>
			<li><img src="images/sample-small-award-3.png" /></li>
		</ul>
		<hr/>
		{if $horses_bar.1}
			<img src="{$horses_bar.1.avatar}" class="avatar-my-horse-bottom"/>
		{/if}
			<a href="/horses.php?id={$horses_bar_id}">все</a>
	</div>
{/if}