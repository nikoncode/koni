{* Smarty *}
{include "modules/header-mini.tpl"}

<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
{literal}
<script>


/* Send to api function */
function sign_up(form) {
	api_query({
		qmethod: "POST",
		amethod: "auth_register",
		params:  $(form).serialize(),
		success: function (response, data) {
			alert(response[0]);
			document.location.href = data.redirect;
		},
		fail:    "standart"
	})
}

/* Autocomplete phone numbers */
function change_country(select) {
    var country = $('.chosen-country option:selected').val();
    api_query({
        qmethod: "POST",
        amethod: "auth_get_city",
        params:  {country_id:country},
        success: function (response, data) {
            $('select.chosen-city').html(response);
            $(".chosen-city").trigger("chosen:updated");
        },
        fail:    "standart"
    })
	phone = $("input[name=phone]");
	country = $(select).val();
	if (country == "Беларусь") phone.val("+375");
	else if(country == "Россия") phone.val("+7");
	else if(country == "Украина") phone.val("+380");
	else phone.val("");
}
$(document).ready(function()
{
    $(".chosen-select").chosen({no_results_text: "Не найдено по запросу",placeholder_text_single: "Выберите страну",inherit_select_classes: true});
    change_country();
});
</script>
{/literal}
<div class="container reg-page main-blocks-area">
		
	<div class="row">
		<div class="span8 lthr-bgbordertitle block offset2 reg-block">
			<h3 class="inner-bg">Регистрация</h3>
			
			<div class="row">	
					<form method="post" action="#" onsubmit="sign_up(this);return false;">
						<div class="row">	
							
							<div class="controls controls-row">
							<label class="span7">Ваш логин: <span class="req">*</span></label>
							<input type="text" class="span6" placeholder="Введите ваш логин" name="login">
							</div>
							
							<div class="controls controls-row">
								<label class="span7">Ваш пароль: <span class="req">*</span></label>
								<input type="password" class="span3" placeholder="Введите пароль" name="passwd1">
								<input type="password" class="span3 offset1" placeholder="Повторите пароль" rel="tooltip" data-placement="bottom" data-original-title="Проверьте правильность ввода паролей" name="passwd2">
							</div>
							
							<div class="controls controls-row">
								<label class="span7">Как вас зовут? <span class="req">*</span></label>
								<input type="text" class="span3" placeholder="Имя" name="fname">
								<input type="text" class="span3 offset1" placeholder="Фамилия" name="lname">
								<input type="text" class="span3" placeholder="Отчество" name="mname">
							</div>
							
							<div class="controls controls-row">
								<label class="span7">Ваша дата рождения</label>
								<input type="text" class="span2" placeholder="День" name="bday">
								<select class="span2" name="bmounth">
									{foreach $const_mounth as $mounth}
										<option value="{$mounth@key}">{$mounth}</option>
									{/foreach}
							   </select>
								<input type="text" class="span2" placeholder="Год" name="byear">
							</div>
							
							<div class="controls controls-row" style="overflow: visible">
								<label class="span6">Ваши контактные данные</label>
								<label class="span6"><small class="muted">Прим: все ваши контактные данные конфиденциальны, нужны лишь для удобства пользования сайтом и не передаются третьим лицам.</small></label>
								<select class="span3 chosen-country chosen-select" name="country" onchange="change_country(this);">
									{foreach $const_countries as $country}
										<option value="{$country.id}">{$country.country_name_ru}</option>
									{/foreach}
							    </select>
                                <select class="span3 chosen-city chosen-select" name="city">

                                </select>
								<input type="text" class="span3" placeholder="E-mail *" name="mail">
								<input type="text" class="span3" placeholder="Номер телефона *" name="phone" value="+7">
								<input type="text" class="span3" placeholder="Улица и дом *" name="adress">
								<input type="text" class="span3" placeholder="Ваш сайт" name="site">
								
							</div>

							<div class="controls controls-row">
								<label class="span6">Я - ...</label>
								{foreach $const_work as $work}
									<div class="span2"><label class="checkbox pull-left"><input name="work[]" type="checkbox" value="{$work}">{$work}</label></div>
								{/foreach}
							</div>
							
						</div>
						<hr/>
						<div class="row">	
							<div class="controls controls-row">
								<label class="checkbox pull-left span4 i-accept">
								<input type="checkbox" name="accept">Я согласен с <a href="home.php">условиями портала</a>
								
								</label>
								<button type="submit" name="reg-submit" class="btn btn-warning">Зарегистрироваться</button>
							</div>
						</div>

				
						</form>
					</div>
				</div>
				</div>
				
		<div class="row">
			<div class="span2 offset4">
				<a class="white-color tar" href="home.php"><p class="tar">Забыли пароль?</p></a>
			</div>
			<div class="span1">
				<a class="white-color" href="index.php"><p class="tar">Войти</p></a>
			</div>
		</div>	

</div>

{include "modules/footer.tpl"}