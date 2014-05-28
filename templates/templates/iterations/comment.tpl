{* Smarty *}
<li class="comment">
	<img src="{$comment.avatar}" class="avatar" />
	<p class="user-name"><a href="/user.php?id={$comment.o_uid}">{$comment.fio}</a></p>
	<p class="date">{$comment.time}</p>
	{if $user.id == $comment.o_uid}
		<div class="edit-my-topic">
			<ul class="unstyled inline">
				<li><a href="#"><i class="icon-pencil" title="Редактировать запись" onclick="edit_comment_make({$comment.id}, this); return false;"></i></a></li>
				<li><a href="#" onclick="remove_comment({$comment.id}, this); return false;"><i class="icon-remove" title="Удалить запись"></i></a></li>
			</ul>
		</div>
	{/if}
	<p class="message">{$comment.text}</p>
	<div class="answer-block">
	<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#" class="likebox" onclick="{if $comment.is_liked}un{/if}like('c', {$comment.id}, this); return false;">Мне нравится: <span class="likes_cnt">{$comment.likes_cnt}</span> <i class="icon-like{if $comment.is_liked} liked{/if}"></i></a></span></p>
	</div>
</li>