{* Smarty *}

{include "modules/header.tpl"}
<div class="container messages-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
				<div>
				<h3 class="inner-bg">Сообщения<!--<span class="pull-right">3 диалога</span>--></h3>
					<div class="row">
						<form class="form-in-messages">
						<div class="controls controls-row">
								<input type="text" class="span3 search-query" placeholder="Введите имя друга">
								<input type="submit" class="btn btn-warning span3" value="Написать сообщение">
						</div>
						</form>
					</div>
					<div class="row">
						{if $messages}
							{foreach $messages as $message}
								<div class="msg-last-dialog span6">
									<div class="row">
										<div class="msg-user-info span2">
											<a href="/user.php?id={$message.friend_id}"><img src="{$message.friend_avatar}" class="avatar"></a>
											<p class="user-name"><a href="/user.php?id={$message.friend_id}">{$message.friend_fio}</a></p>
											<p class="date">{$message.time}</p>
										</div>
										<div class="span4 msg-last-message">
											<p class="last-message"><a href="/chat.php?id={$message.friend_id}">
												{if $message.me_last}
													<img src="{$user.avatar}" class="avatar" />
												{/if}
												{$message.text}
											</a></p>
										</div>
									</div>
								</div>
							{/foreach}
						{else}
							<p style="text-align: center;">Диалогов пока нет.</p>
						{/if}						
					</div>
				</div>
			</div>
			
			{include "modules/sidebar-my-right.tpl"}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}