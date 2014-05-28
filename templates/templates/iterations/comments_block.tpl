<div class="comments" {if $post && !$comments}style="display: none;"{/if}>
	<ul class="comments-lists">
		{if $comments_cnt > 3}
			<li class="comment show-all-comments" onclick="comments_extra('{$c_key}', {$c_value}, this);" data-cached="0">
				Показать еще
			</li>
		{/if}
		{foreach $comments as $comment}
			{include "iterations/comment.tpl" comment = $comment}
		{/foreach}
		{include "modules/comment-form.tpl"}
	</ul>
</div>