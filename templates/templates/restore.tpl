{* Smarty *}
{include "modules/header-mini.tpl"}

<script>
/* Send to api function */
function restore(e) {
	api_query({
		qmethod: "POST",
		amethod: "pass_restore",
		params: $(e).serialize(),
		success: function (data) {
			alert(data);
		},
		fail: "standart"
	});
	return false;
}
</script>
<div class="container login-page main-blocks-area">
		
		<div class="row">
		<div class="span4 lthr-bgbordertitle block offset4 login-block">
				<h3 class="inner-bg">Восстановление пароля</h3>
					<div class="row">
						{if $restored == true}
							<p>Пароль изменен успешно.</p>
							<p>Проверьте почту, для получения дальнейших инструкций.</p>
						{else}
							<form method="post" action="#" onsubmit="restore(this); return false;">
								<div class="controls controls-row">
									<label>Введите ваш email</label>
									<input type="text" class="span4" name="mail" placeholder="Ваша почта">
								</div>
								<div class="controls controls-row">
									<button type="submit" class="span4 btn btn-warning" name="sms-submit">Восстановить</button>
								</div>
							</form>
						{/if}
					</div>
			</div>
		</div>
		
		
		<div class="row">
			<div class="span4 offset4">
				<!--<center><a class="white-color" href="home.php">Отправить снова?</a></center>-->
			</div>
		</div>	
</div>

{include "modules/footer.tpl"}