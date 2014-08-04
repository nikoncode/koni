{* Smarty *}
{include "modules/header-mini.tpl"}

<script>
/* Send to api function */
function validate(form) {
	api_query({
		qmethod: "POST",
		amethod: "auth_sms_validate",
		params:  $(form).serialize(),
		success: function (response, data) {
			alert(response[0]);
			document.location.href = data.redirect;
		},
		fail:    "standart"
	})
}
function send_sms_form() {
    $('#sms_form').submit();
}
function send_sms(form) {
    api_query({
        qmethod: "POST",
        amethod: "auth_sms_resend",
        params:  $(form).serialize(),
        success: function (response, data) {
            $("#modal-send-sms").modal('show');
            setTimeout(function(){
                $("#modal-send-sms").modal('hide');
            },4000)
        },
        fail:    "standart"
    })
}
</script>
<div class="container login-page main-blocks-area">
		
		<div class="row">
		<div class="span4 lthr-bgbordertitle block offset4 login-block">
				<h3 class="inner-bg">Проверка кода</h3>
					<div class="row">
						<form method="post" action="#" onsubmit="validate(this);return false;">
							<label>Введите ваш логин</label>
                            <input type="text" class="span4" name="login" placeholder="Ваш логин" value="{$login}">
                            <label>Введите ваш код</label>
							<input type="text" class="span4" name="code" placeholder="Ваш код">
						<div class="row">
							<button type="submit" class="span4 btn btn-warning" name="sms-submit">Ввести код</button>
						</div>
						</form>
					</div>
			</div>
		</div>
		
		
		<div class="row">
			<div class="span4 offset4">
				<center>
                    <form style="display: none;" id="sms_form" method="post" action="#" onsubmit="send_sms(this);return false;"><input type="hidden" name="login" value="{$login}"></form>
                    <a class="white-color" href="#" onclick="send_sms_form()">Отправить снова?</a>
                    <br/>
                    <a class="white-color" href="/login.php">Войти под другим логином</a></center>
			</div>
		</div>	
</div>
<div id="modal-send-sms" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Повторная отправка кода</h3>
    </div>
    <div class="modal-body">
        <p>Вам повторно выслан код</p>
    </div>
</div>

{include "modules/footer.tpl"}