{* Smarty *}
{foreach $news as $post}
	<li class="news-container">
		{include "iterations/post.tpl" post = $post}
		{include "iterations/comments_block.tpl" 
			comments_cnt = $post.comments_cnt 
			comments = $post.comments 
			user_avatar = $user.avatar
			c_key = 'nid'
			c_value = $post.id
		}
	</li>
{/foreach}