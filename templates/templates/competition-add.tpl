{* Smarty *}
{include "modules/header.tpl"}

<script>
	function add_comp(form) {
		api_query({
			qmethod: "POST",
			amethod: "comp_add",
			params: $(form).serialize(),
			success: function (data) {
				console.log(data);
			},
			fail: "standart"
		});
	}
</script>

<div class="container clubs-page club-admin main-blocks-area club-block club-add-comp">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-tabs">
				<h3 class="inner-bg">Настройки клуба<span class="pull-right text-italic"><a href="club-sample.php">Вернуться в клуб</a></span></h3>
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li><a href="club-admin.php#main-admin">Основные</a></li>
					<li><a href="club-admin.php#about-admin">О клубе</a></li>
					<li><a href="club-admin.php#members-admin">Участники</a></li>
					<li class="active"><a href="#competitions-admin" data-toggle="tab">Соревнования</a></li>
					<li><a href="club-admin.php#adv-admin">Реклама</a></li>
					<li><a href="club-admin.php#contact-admin">Контакты</a></li>
				</ul>
				
				<div id="friendsTabContent" class="tab-content bg-white">
				
			<div class="tab-pane in active" id="competitions-admin">
				<form onsubmit="add_comp(this); return false;">
					<input type="hidden" name="o_cid" value="{$cid}">
					<div class="row">
						<div class="span12">
							<div class="row option-row">
								<div class="title-hr">
									<div class="title span7">Новое соревнование</div>
									<button href="club-admin-add-comp.php" class="btn btn-warning span3">Сохранить изменения</button>
									<a href="club-admin-add-comp.php" class="btn span1">Отмена</a>
								</div>
							</div>
						</div>
							
						<div class="row option-row">
							<h5 class="title-hr">Главные настройки</h5>
									<div class="span6">
											<div class="row">
											<div class="controls controls-row">
												<label class="span6">Название соревнования</label>
												<input type="text" class="span6" name="name">
												<label class="span3">Дата начала</label>
												<label class="span3">Дата завершения</label>
												<input type="text" class="span3" placeholder="дд.мм.гг" name="bdate">
												<input type="text" class="span3" placeholder="дд.мм.гг" name="edate">
												<label class="span3">Страна</label>
												<label class="span3">Город</label>
												<select class="span3" name="country">
													{foreach $const_countries as $country}
														<option>{$country}</option>
													{/foreach}
											   </select>
												<input type="text" class="span3" name="city">
											   <label class="span6">Адрес проведения соревнования</label>
												<input type="text" class="span6" name="address">
												<label class="span6">Вид соревнований</label>
												<select class="span6" name="type">
													{foreach $const_types as $type}
														<option>{$type}</option>
													{/foreach}
											   </select>
											</div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
											<label class="span6">Описание соревнования</label>
											<textarea class="span6" rows="5" name="desc"></textarea>
											{*<label class="span3">Документы  (pdf, word, excel):</label>
											<a href="#" class="btn span3">Добавить файл</a>
											<ul class="unstyled span6 comp-added-files">
												<li class="pdf-file">Положение-1.pdf<button type="button" class="close">&times;</button></li>
												<li class="pdf-file">Положение-2.pdf<button type="button" class="close">&times;</button></li>
												<li class="pdf-file">Положение-c-длинным-описанием.pdf<button type="button" class="close">&times;</button></li>
											</ul>*}
										</div>
									</div>
						</div>

				</div>
				</form>
			</div>
			</div>

		</div> <!-- /row -->
</div>


{include "modules/footer.tpl"}