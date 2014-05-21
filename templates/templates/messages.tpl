{* Smarty *}

{include "modules/header.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
{literal}
<script>
    $(document).ready(function()
    {
        $(".chosen-select").chosen({no_results_text: "Друг не найден",placeholder_text_single: "Введите имя друга",inherit_select_classes: true});
        $('#send-message').click(function(){
            var fid = $('#search-friend').val();
            window.location = 'chat.php?id='+fid;
        })
    });
</script>
{/literal}
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
						<div class="controls controls-row" style="overflow: visible">
                            {if $friends}
                                <select name="friend" id="search-friend" data-placeholder="Введите имя друга" class="span3 search-query chosen-select">
                                {foreach $friends as $friend}
                                    <option value="{$friend.fid}">{$friend.fname} {$friend.lname}</option>
                                {/foreach}
                                </select>
                            {/if}
								<input type="button" class="btn btn-warning span3" id="send-message" value="Написать сообщение">
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