{* Smarty *}
{include "modules/header-mini.tpl"}

<script>
/* Send to api function */
function sign_in(form) {
	api_query({
		qmethod: "POST",
		amethod: "login",
		params: $(form).serialize(),
		success: function (resp, data) {
			document.location.href = data.redirect;
		},
		fail: "standart"
	})
}
</script>
<div class="container login-page main-blocks-area">
		
		<div class="row">
		<div class="span4 lthr-bgbordertitle block offset4 login-block">
				<h3 class="inner-bg">Вход на сайт</h3>

					<div class="row">
						<form method="post" action="#" onsubmit="sign_in(this);return false;">
							
							<div class="controls controls-row">
								<label>Логин или адрес электронной почты</label>
								<input type="text" class="span4" name="login" placeholder="Логин" value="{$login}">
								<label>Ваш пароль</label>
								<input type="password" class="span4" name="pass" placeholder="Пароль">
							</div>
							
							<div class="controls controls-row">
								<label class="checkbox span2 remember-me">
									<!--<input type="checkbox"> Запомнить меня-->
								</label>
								<input type="submit" class="span2 btn btn-warning" name="login-submit" value="Войти">
							</div>
						
						</form>
					</div>
						
					</div>
			</div>
		
		
		<div class="row">
			<div class="span2 offset4">
				<a class="white-color" href="home.php">Забыли пароль?</a>
			</div>
			<div class="span2">
				<a class="white-color" href="reg.php">Зарегистрироваться</a>
			</div>
		</div>	
</div>

{include "modules/footer.tpl"}