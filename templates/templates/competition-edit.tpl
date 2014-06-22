{* Smarty *}
{include "modules/header.tpl"}

<script>
	function edit_comp(form) {
		api_query({
			qmethod: "POST",
			amethod: "comp_edit",
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
					<div class="row">
					<form onsubmit="edit_comp(this); return false;">
						<input type="hidden" name="id" value="{$comp.id}">
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
												<input type="text" class="span6" name="name" value="{$comp.name}">
												<label class="span3">Дата начала</label>
												<label class="span3">Дата завершения</label>
												<input type="text" class="span3" placeholder="дд.мм.гг" name="bdate" value="{$comp.bdate}">
												<input type="text" class="span3" placeholder="дд.мм.гг" name="edate" value="{$comp.edate}">
												<label class="span3">Страна</label>
												<label class="span3">Город</label>
												<select class="span3" name="country">
													{foreach $const_countries as $country}
														<option {if $country == $comp.country}selected{/if}>{$country}</option>
													{/foreach}
											   </select>
												<input type="text" class="span3" name="city" value="{$comp.city}">
											   <label class="span6">Адрес проведения соревнования</label>
												<input type="text" class="span6" name="address" value="{$comp.address}">
												<label class="span6">Вид соревнований</label>
												<select class="span6" name="type">
													{foreach $const_types as $type}
														<option {if $type == $comp.type}selected{/if}>{$type}</option>
													{/foreach}
											   </select>
											</div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
											<label class="span6">Описание соревнования</label>
											<textarea class="span6" rows="5" name="desc">{$comp.desc}</textarea>
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
						</form>

							<div class="row option-row">
								<h5 class="title-hr">Маршруты соревнования</h5>
								<table class="table table-striped competitions-table routes">
									<tbody><tr>
									  <th>Дата/Время</th>
									  <th>Маршрут</th>
									  <th>Высота</th>
									  <th>Зачёт для</th>
									  <th>Статус</th>
									  <th><a class="btn btn-warning" href="#" onclick="prepare_to_add(); return false;">Добавить маршруты</a></th>
									</tr>
									{foreach $comp.routes as $route}
										 <tr>
											<td class="comp-date"><p>{$route.bdate}</p></td>
											<td class="route">
												<a href="events.php">{$route.name}</a>
											</td>
											<td class="height"><p>{$route.height}</p></td>
											<td class="credit-for"><p>{$route.exam}</p></td>
											<td class="status"><p>{$route.status}</p></td>
											<td class="change"><a href="#" class="btn btn-grey" onclick="prepare_to_edit({$route.id}); return false;">Изменить</a><button type="button" class="close" onclick="delete_route({$route.id}, this); return false;">&times;</button></td>
										</tr>
									{/foreach}
								</tbody>
								</table>
						</div>
						
					<div class="row option-row">
						<div class="span12">
            <ul class="nav nav-tabs">
              {*<li><a href="#compt-members" data-toggle="tab">Участники</a></li>*}
              <li class="active"><a href="#compt-results" data-toggle="tab">Результаты</a></li>
              <li><a href="#compt-gallery" data-toggle="tab">Галерея</a></li>
              <li><a href="#compt-disqus" data-toggle="tab">Обсуждения</a></li>
            </ul>
            
			<div class="tab-content">
              
			  {*<div class="tab-pane in active" id="compt-members">
					<div class="span12">
						<h3 class="inner-bg">Всадники<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Зрители<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Фотографы<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
              </div> <!-- compt-members -->*}
              
			  <div class="tab-pane active" id="compt-results">
				<div class="c-results-btns">
					<ul>
						<li><a href="#" class="btn btn-warning">Импортировать результаты с файла</a></li>
						<li><a href="#" class="btn btn-warning">Заполнить результаты вручную</a></li>
						<li><a href="#" class="btn btn-warning">Загрузка PDF-файла для скачивания</a></li>
					</ul>
				</div>
                <table class="table table-striped competitions-table compt-results admin-compts">
						<tbody><tr>
							<th>№</th>
							<th>Всадник</th>
							<th>Разряд</th>
							<th>Лошадь</th>
							<th>Команда</th>
							<th>Ошибки</th>
							<th>Баллы</th>
							<th>Всего %</th>
							<th>Нормы</th>
							<th> </th>
						</tr>
						<tr><td colspan="10" class="table-caption">М1 08.10.2013</td></tr> 
						<tr class="first-place">
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn">
									<div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div>
							</td>
						</tr> 
						<tr>
							<td class="n">2</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">3</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">4</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">5</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						
						<tr><td colspan="10" class="table-caption">М2 (зачёт 2) 08.10.2013</td></tr> 
						<tr class="first-place">
							<td class="n">1</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">2</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">3</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">4</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 
						<tr>
							<td class="n">5</td>
							<td class="name"><span>Павленко</span> Екатерина, 1995</td>
							<td class="discharge ">кмс</td>
							<td class="horse"><span>Кондикор-04</span>, жер., гнед., ит. Сель, Италия</td>
							<td class="team">РГУ ПП, Калининградская обл.</td>
							<td class="errors"><input type="text" ></td>
							<td class="points"><input type="text" ></td>
							<td class="total"><input type="text" ></td>
							<td class="standarts"><input type="text" ></td>
							<td class="closebtn"><div class="dropdown button">
									<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
										<ul id="menu1" class="dropdown-menu" role="menu">
											<li><a tabindex="-1" href="#"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove-sign"></i> Исключить</a></li>
											<li><a tabindex="-1" href="#"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											<li class="divider"></li>
											<li><a tabindex="-1" href="#"><i class="icon-remove"></i> Отмена</a></li>
										</ul>
									</div></td>
						</tr> 

					</tbody>
					</table>
              </div><!-- compt-results -->
			  
			  <div class="tab-pane" id="compt-gallery">
                <div class="photos">
					<ul class="photo-wall">
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
					</ul>
				</div>
              </div><!-- compt-gallery -->
			  
			  <div class="tab-pane" id="compt-disqus">
              </div>
			  
            </div>
          </div>
					</div>
						
					</div>
				</div> <!-- //competitions-club -->
				
				<div class="tab-pane" id="adv-admin">
					<div class="row">
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
					</div>
				</div> <!-- //gallery-club -->
				
				<div class="tab-pane" id="contact-admin">
					<div class="row">
							<div class="span12">
									<p>еальность. Катарсис, как следует из вышесказанного, решительно подчеркивает смысл жизни, учитывая опасность, которую представляли собой писания Дюринга для не окрепшего еще немецкого рабочего движения. Отношение к современности понимает под собой конфликт, однако Зигварт считал критерием истинности необходимость и общезначимость, для которых нет никакой опоры в объективном мире. Искусство заполняет бабувизм, при этом буквы А, В, I, О символизируют соответственно общеутвердительное, общеотрицательное, частноутвердительное и частноотрицательное суждения.</p>
							</div>
						</div>
				</div> <!-- //contact-club -->
				
			
				</div>
			</div>
			</div>

		</div> <!-- /row -->
</div>
<script>

function add_option() {
	return $("<div class='opt'> \
		<select class='span2' name='opt_name[]'> \
			<option>Тип грунта</option> \
			<option selected>Вступительный взнос</option> \
			<option>Дистанция </option> \
			<option>Размеры боевого поля</option> \
			<option>Размеры разминочного поля</option> \
	</select> \
	<input class='span3' type='text' name='opt[]' /> \
	<a href='#' class='span1' onclick='del_option(this); return false;'>удалить</a> \
	</div> \
	<div class='clear'></div>").appendTo("#addRoute #options");	
}

function del_option(el) {
	var element = $(el).closest(".opt");
	var next_clear = element.next(".clear");
	element.remove();
	next_clear.remove();
}

function add_route(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_add",
		params: $(form).serialize(),
		success: function (data) {
			console.log(data);
		},
		fail: function (data) { //your modal not work
			var err = "";
			for (i=0;i<data.length;++i) {
				err += data[i] + "\n";
			}
			alert(err);
		}
	});
}

function edit_route(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_edit",
		params: $(form).serialize(),
		success: function (data) {
			console.log(data);
		},
		fail: function (data) { //your modal not work
			var err = "";
			for (i=0;i<data.length;++i) {
				err += data[i] + "\n";
			}
			alert(err);
		}
	});
}

function delete_route(id, element) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_delete",
		params: {
			id: id
		},
		success: function (data) {
			$(element).closest("tr").remove();
		},
		fail: "standart"
	});
}

function prepare_to_edit(id) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_info",
		params: {
			id : id
		},
		success: function (data) {
			var form = $("#addRoute");
			form.find("#options .opt").remove();
			$.each(data, function (index, value) {
				form.find("[name="+index+"]").val(value);
			});
			$.each(data.options, function (index, value) {
				var new_opt = add_option();
				new_opt.find("select").val(index);
				new_opt.find("input").val(value);
			});
			form.find("h3").text("Изменение маршрута");
			form.find("form").attr("onsubmit", "edit_route(this); return false;");
			form.find("[name=id]").val(data.id);
			form.modal("show");
		},
		fail: "standart"
	});
}

function prepare_to_add() {
	var mdl = $("#addRoute");
	mdl.find("#options .opt").remove();
	mdl.find("h3").text("Добавление маршрута");
	mdl.find("form").attr("onsubmit", "add_route(this); return false;");
	mdl.find("input[type=text]").val("");
	add_option();
	mdl.modal("show");
}



</script>
<div id="addRoute" class="modal hide" tabindex="-1" role="dialog" aria-hidden="false">
     <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Добавление маршрута</h3>
    </div>
    <div class="modal-body">
            <form class="form-horizontal" onsubmit="add_route(this);return false;">
            	<input type="hidden" name="cid" value="{$comp.id}">
            	<input type="hidden" name="id" value="">
                <div class="controls controls-row">
                    <label class="span6">Вид соревнования<span class="req-field">*</span></label>
                    <select class="span3" name="type">
						{foreach $const_types as $type}
							<option>{$type}</option>
						{/foreach}
                    </select>
                    <div class="span6"><hr></div>
                </div>
                
                <div class="controls controls-row">
                    <label class="span3">Маршрут<span class="req-field">*</span></label>
                    <label class="span3">Дата начала<span class="req-field">*</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Время начала</label>
                    <input type="text" class="span3" name="name">
                    <div class="span3">
                        <input type="text" class="span-mini" name="date"><input type="text" class="span-mini" name="time">
                    </div>
                </div>
                
                <div class="controls controls-row">
                    <label class="span3">Статус<span class="req-field">*</span></label>
                    <label class="span3">Зачёт для<span class="req-field">*</span></label>
                    <select class="span3" name="status">
                        <option>Всероссийский</option>
                        <option>Международный</option>
                        <option>Местный</option>
                    </select>
                    <select class="span3" name="exam">
                        <option>Дети 12-14 лет</option>
                        <option>Любители 18-30 лет</option>
                        <option>Любители 31 год и старше</option>
                        <option>Юноши 14-18 лет</option>
                        <option>Взрослые спортсмены</option>
                        <option>Взрослые спортсмены на молодых лошадях 4-5 лет</option>
                    </select>
                </div>          
                <div class="controls controls-row">
                    <label class="span6">Высота<span class="req-field">*</span></label>
                    <input type="text" class="span3" name="height">
                    <div class="span6"><hr></div>
                </div>
                
                <div class="controls controls-row multi-select" id="options">
    
                    <p class="span6"><a href="#" onclick="add_option();return false;">Добавить ещё опций</a></p>
                </div>
                
                <div class="controls controls-row">
                         <button type="submit" class="btn btn-warning span3">Добавить маршрут</button>
                         <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
                 </div>
            </form> 
    </div>
</div>

{include "modules/footer.tpl"}