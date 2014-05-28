{* Smarty *}
<li class="answer-form form-clear">
	<form class="min" onsubmit="{if $loaded_comment}edit{else}add{/if}_comment(this); return false;">
		<div class="controls-row">
				<img src="{$user_avatar}" class="my-avatar">
				<textarea type="text" name="text" class="answer-message" placeholder="Комментировать..." onfocus="answer_form_maximize(this);" onblur="answer_form_minimize(this);">{if $loaded_comment}{$loaded_comment}{/if}</textarea>
				<input type="hidden" name="id" value="{$c_value}" />
				<input type="hidden" name="type" value="{$c_key}" />
			</div>
			<div class="controls-row">
				<input type="submit" value="Отправить" class="btn btn-warning  comment-submit span2">
				{if $loaded_comment}
					<button onclick='edit_comment_cancel(this);return false;' class='btn comment-submit span2'>Отмена</button>
				{/if}
			</div>
	</form>
</li>