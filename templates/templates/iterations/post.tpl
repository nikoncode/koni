{* Smarty *}
<div class="post">
	<img src="{$post.owner_avatar}" class="avatar" />
	<p class="user-name"><a href="/{$post.owner_type}.php?id={$post.owner_id}">{$post.owner_name}</a></p>
	<p class="date">{$post.time}</p>
	{if $post.o_uid == $user.id}
		<div class="edit-my-topic">
			<ul class="unstyled inline">
				<li><a href="#" onclick="edit_news_make({$post.id}, this); return false;"><i class="icon-pencil" title="Редактировать запись"></i></a></li>
				<li><a href="#" onclick="remove_news({$post.id}, this); return false;"><i class="icon-remove" title="Удалить запись"></i></a></li>
			</ul>
		</div>
	{/if}
	<p class="message">{$post.text}</p>
	{if $post.photos}
		<ul class="gallery-in-post" data-gallery-list="{$post.photo_ids}">
			{foreach $post.photos as $photo}
				<li><a href="#" data-gallery-pid="{$photo@key}"><div style="background-image: url({$photo})"></div></a></li>
			{/foreach}
		</ul>
	{/if}
	<div class="answer-block">
		<p><span><a href="#" onclick="response(this); return false;">Ответить </a></span><span> | </span><span><a href="#" class="likebox" onclick="{if $post.is_liked}un{/if}like('n', {$post.id}, this); return false;
			">Мне нравится: <span class="likes_cnt">{$post.likes_cnt}</span> <i class="icon-like{if $post.is_liked} liked{/if}"></i></a></span></p>
	</div>
</div>