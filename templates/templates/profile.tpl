{* Smarty *}
{include "modules/header.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
{literal}
    <script>
        /* Send to api function */
        function profile_edit(form) {
            api_query({
                qmethod: "POST",
                amethod: "auth_user_change",
                params: $(form).serialize(),
                success: function (data) {
                    var mdl = $("#modal-info");
                    mdl.find('#info-block').html(data[0]);
                    mdl.modal("show");
                    setTimeout(function(){
                        mdl.modal('hide');
                    },4000);
                },
                fail: "standart"
            })
        }

        /* Autocomplete phone numbers */
        function change_country(select) {
            var city = $('#u_city').val();

            var country = $('.chosen-country option:selected').val();
            api_query({
                qmethod: "POST",
                amethod: "auth_get_city",
                params:  {country_id:country,city:city},
                success: function (response, data) {
                    $('select.chosen-city').html(response);
                    $('select.chosen-city option[value="'+city+'"]').prop('selected',true);
                    $(".chosen-city").trigger("chosen:updated");
                },
                fail:    "standart"
            })
            /*phone = $("input[name=phone]");
            country = $(select).val();
            if (country == "Беларусь") phone.val("+375");
            else if(country == "Россия") phone.val("+7");
            else if(country == "Украина") phone.val("+380");
            else phone.val("");*/
        }
        $(document).ready(function()
        {
            $(".chosen-select").chosen({no_results_text: "Не найдено по запросу",placeholder_text_single: "Выберите страну",inherit_select_classes: true});
            change_country();

            $('input.password,input.password2').blur(function(){
                var psw = $('.password').val();
                var psw2 = $('.password2').val();
                if(psw != psw2) {
                    $('.password').css('background','#D9534F');
                    $('.password2').css('background','#D9534F');
                }else{
                    $('.password').css('background','');
                    $('.password2').css('background','');
                }
            });
            $('input.login').blur(function(){
                var login = $(this).val();
                api_query({
                    qmethod: "POST",
                    amethod: "auth_check_login",
                    params:  {login:login},
                    success: function (response, data) {
                        //alert(response[0]);
                    },
                    fail:    "standart"
                })
            });
            $('.spec').change(function(){
                var rank = false;
                $('.spec:checked').each(function(){
                    if($(this).val() == 'Тренер' || $(this).val() == 'Спортсмен') rank = true;
                });
                if(rank){
                    $('.rank').css('display','');
                }else{
                    $('.rank option[value="0"]').prop('selected',true);
                    $('.rank').css('display','none');
                }
            });
            $('.spec').change();
        });
    </script>
{/literal}
<div class="container profile-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-bgborder block" id="centerBlock">
			<div class="row">
			<h3 class="inner-bg">Настройки</h3>
				
				<ul id="settingsTab" class="nav nav-tabs">
					<li class="active"><a href="#profile" data-toggle="tab">Профиль</a></li>
					<li><a href="#notify" data-toggle="tab">Оповещения</a></li>
					<li><a href="#balance" data-toggle="tab">Баланс</a></li>
				</ul>
				
				<form class="form-horizontal" id="my-settings" onsubmit="profile_edit(this); return false;">
				<div id="settingsTabContent" class="tab-content bg-white">

					<div class="tab-pane in active" id="profile">
						<div>
							<h5 class="title-hr">Изменить имя</h5>
							<div class="control-group">
								<label class="control-label" for="inputNewName">Ваше имя</label>
								<div class="controls"><input type="text" id="inputNewName" placeholder="Имя" name="fname" value="{$u.fname}"></div>
								<label class="control-label" for="inputNewSurname">Ваша фамилия</label>
								<div class="controls"><input type="text" id="inputNewSurname" placeholder="Фамилия" name="lname" value="{$u.lname}"></div>
								<label class="control-label" for="inputNewSurnamen">Ваше отчество</label>
								<div class="controls"><input type="text" id="inputNewSurnamen" placeholder="Отчество" name="mname" value="{$u.mname}"></div>
							</div>
						</div>
						
						<div>
							<h5 class="title-hr">Изменить пароль</h5>
							<div class="control-group">
								<label class="control-label" for="inputNewPass">Новый пароль</label>
								<div class="controls"><input type="text" id="inputNewPass" placeholder="Пароль" name="passwd1"></div>
								<label class="control-label" for="inputPassAgain">Повторите пароль</label>
								<div class="controls"><input type="text" id="inputPassAgain" placeholder="И ещё раз" name="passwd2"></div>
							</div>
						</div>
						
						<div>
							<h5 class="title-hr">Изменить дату рождения</h5>
							<div class="control-group">
								<label class="control-label" class="span6">Введите день</label>
								<div class="controls"><input type="text" placeholder="День" name="bday" value="{$u.bday}"></div>
								<label class="control-label">Выберите месяц</label>
								<div class="controls">
									<select name="bmounth">
										{foreach $mounths as $mounth}
											<option value="{$mounth@key}" {if $mounth@key == $u.bmounth}selected="selected"{/if}>{$mounth}</option>
										{/foreach}
									</select>
								</div>
								<label class="control-label">Введите год</label>
								<div class="controls"><input type="text"placeholder="И ещё раз" name="byear" value="{$u.byear}"></div>
							</div>
						</div>
						
						<div>
							<h5 class="title-hr">Изменить контактные данные</h5>
							<div class="control-group" style="overflow: visible">
								<label class="control-label">E-mail</label>
								<div class="controls"><input type="text" placeholder="E-mail" name="mail" value="{$u.mail}"></div>
								<label class="control-label">Ваш сайт</label>
								<div class="controls"><input type="text" placeholder="Ваш сайт" name="site" value="{$u.site}"></div>
								<label class="control-label">Страна</label>
								<div class="controls" style="overflow: visible">
									<select name="country" class="chosen-country chosen-select" onchange="change_country(this);">
                                        {foreach $countries as $country}
                                            <option value="{$country.id}" {if $country.country_name_ru == $u.country}selected="selected"{/if}>{$country.country_name_ru}</option>
                                        {/foreach}
									</select></div>
								<label class="control-label">Город</label>
								<div class="controls" style="overflow: visible">
                                    <select class="chosen-city chosen-select" name="city">

                                    </select>
                                    <input type="hidden" id="u_city" value="{$u.city}">
                                </div>
								<label class="control-label">Улица</label>
								<div class="controls"><input type="text" placeholder="Улица" name="adress" value="{$u.adress}"></div>
								<label class="control-label">Номер телефона</label>
								<div class="controls"><input type="text" placeholder="Номер телефона" name="phone" value="{$u.phone}"></div>
							</div>
						</div>
	 
						<div>
							<h5 class="title-hr">Изменить увлечения</h5>
							<div class="control-group">
								{foreach $u.profs as $prof}
									<div class="span2"><label class="checkbox pull-left"><input type="checkbox" name="work[]" class="spec" value="{$prof@key}" {$prof}>{$prof@key}</label></div>
								{/foreach}
							</div>
                            <h5 class="title-hr rank">Разряд</h5>
							<div class="control-group rank">
                                <select class="span2 rank" name="rank">
                                    {foreach $const_rank as $key=>$rank}
                                        <option value="{$key}" {if $key == $u.rank}selected="selected"{/if}>{$rank}</option>
                                    {/foreach}
                                </select>
							</div>
						</div>
					</div>
					
					<div class="tab-pane" id="notify">
						<p>Food truck fixie locavore, accusamus mcsweeney's marfa nulla single-origin coffee squid. Exercitation +1 labore velit, blog sartorial PBR leggings next level wes anderson artisan four loko farm-to-table craft beer twee. Qui photo booth letterpress, commodo enim craft beer mlkshk aliquip jean shorts ullamco ad vinyl cillum PBR. Homo nostrud organic, assumenda labore aesthetic magna delectus mollit. Keytar helvetica VHS salvia yr, vero magna velit sapiente labore stumptown. Vegan fanny pack odio cillum wes anderson 8-bit, sustainable jean shorts beard ut DIY ethical culpa terry richardson biodiesel. Art party scenester stumptown, tumblr butcher vero sint qui sapiente accusamus tattooed echo park.</p>
					 </div>
					
					<div class="tab-pane" id="balance">
						<p>Food truck fixie locavore, accusamus mcsweeney's marfa nulla single-origin coffee squid. Exercitation +1 labore velit, blog sartorial PBR leggings next level wes anderson artisan four loko farm-to-table craft beer twee. Qui photo booth letterpress, commodo enim craft beer mlkshk aliquip jean shorts ullamco ad vinyl cillum PBR. Homo nostrud organic, assumenda labore aesthetic magna delectus mollit. Keytar helvetica VHS salvia yr, vero magna velit sapiente labore stumptown. Vegan fanny pack odio cillum wes anderson 8-bit, sustainable jean shorts beard ut DIY ethical culpa terry richardson biodiesel. Art party scenester stumptown, tumblr butcher vero sint qui sapiente accusamus tattooed echo park.</p>
					 </div>
				</div>
				
				<div class="row">
				<div class="span6">
					<div class="controls-row">
						<input type="submit" class="span3 btn btn-warning" value="Применить"/>
						<input type="submit"  class="span3 btn" value="Отмена" />
					</div>
					</form> <!-- /my-settings -->
				
				</div>
				</div>
				</div>
			</div>
			
			{include "modules/sidebar-my-right.tpl"}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}