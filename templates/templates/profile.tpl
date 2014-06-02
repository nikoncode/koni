{* Smarty *}
{include "modules/header.tpl"}
<script>
function profile_edit(form) {
	api_query({
		qmethod: "POST",
		amethod: "auth_user_change",
		params: $(form).serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

</script>
<div class="container profile-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-bgborder block">
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
							<div class="control-group">
								<label class="control-label">E-mail</label>
								<div class="controls"><input type="text" placeholder="E-mail" name="mail" value="{$u.mail}"></div>
								<label class="control-label">Ваш сайт</label>
								<div class="controls"><input type="text" placeholder="Ваш сайт" name="site" value="{$u.site}"></div>
								<label class="control-label">Страна</label>
								<div class="controls">									
									<select name="country">
										{foreach $countries as $country}
											<option value="{$country}" {if $country == $u.country}selected="selected"{/if}>{$country}</option>
										{/foreach}
									</select></div>
								<label class="control-label">Город</label>
								<div class="controls"><input type="text" placeholder="Город" name="city" value="{$u.city}"></div>
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
									<div class="span2"><label class="checkbox pull-left"><input type="checkbox" name="work[]" value="{$prof@key}" {$prof}>{$prof@key}</label></div>
								{/foreach}
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