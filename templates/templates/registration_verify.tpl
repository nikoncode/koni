{* Smarty *}
{include "modules/header-mini.tpl"}

<script>
/* Send to api function */
function validate(form) {
	api_query({
		qmethod: "POST",
		amethod: "sms_validate",
		params:  $(form).serialize(),
		success: function (response, data) {
			alert(response);
			document.location.href = data.redirect;
		},
		fail:    "standart"
	})
}
</script>
<div class="container login-page main-blocks-area">
		
		<div class="row">
		<div class="span4 lthr-bgbordertitle block offset4 login-block">
				<h3 class="inner-bg">Проверка SMS-кода</h3>
					<div class="row">
						<form method="post" action="#" onsubmit="validate(this);return false;">
							<label>Введите ваш логин</label>
                            <input type="text" class="span4" name="login" placeholder="Ваш логин" value="{$login}">
                            <label>Введите ваш SMS-код</label>
							<input type="text" class="span4" name="code" placeholder="Ваш SMS-код">
						<div class="row">
							<button type="submit" class="span4 btn btn-warning" name="sms-submit">Ввести код</button>
						</div>
						</form>
					</div>
			</div>
		</div>
		
		
		<div class="row">
			<div class="span4 offset4">
				<center><a class="white-color" href="#">Отправить снова?</a></center>
			</div>
		</div>	
</div>

{include "modules/footer.tpl"}