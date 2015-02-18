{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-add-user.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<script src="js/bootstrap-datepicker.js"></script>
<script src="js/bootstrap-datepicker.ru.js"></script>

<script src="js/chosen.ajaxaddition.jquery.js"></script>
<script src="js/jquery-sortable.js"></script>
<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
<script src="js/select2.min.js"></script>
<script src="js/i18n/ru.js"></script>
<script>
    $(function(){
        $('#startlist_table').sortable({
            containerSelector: 'div',
            itemPath: '.height_table',
            itemSelector: 'div.dragabble',
            placeholder: '<div class="placeholder row" style="border: 1px solid #000; height: 25px; background: #ffff00"/>',
            onDrop: function  (item, container, _super) {
                $('#startlist .route_table').each(function(){
                    var i = 0;

                    $('.dragabble',this).each(function(){
                         i++;
						var route_id = $(this).closest('.height_table').attr('alt');
                        var ride_id = $(this).attr('alt');
                        $('.span1 .ordering',this).val(i);
                        $('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
                        $('.span1 .ordering_txt',this).html(i);
                    });
                });
                change_riders_ordering();
                _super(item)
            },
			onDragStart:function ($item, container, _super, event) {
				var rows = $item.closest('.route_table').find('.dragabble').size() || 0;
				if(rows <= 1){
					add_member_list($item.closest('.route_table').find('.table-caption a'));
				}

			}
        });
		$('.datepick').datepicker({
			language: "ru",
			format: "dd.mm.yyyy"
		});
        {literal}
        $('#startlist').on('click','.delete_rider',function(){
            var rid = parseInt($(this).attr('alt')) || 0;
			$('#modal_delete_reason .el_index').val(rid);
			$('#modal_delete_reason').modal('show');
        });

		$('.add_height').on('click',function(){
			var row = $('#addRoute .heights .controls-row:first-child').clone();
			row.find('input').val('');
			row.find('input').attr('name','height[]');
			row.find('select').attr('name','exam[]');
			$('#addRoute .heights').append(row);
		});
		$('#addRoute .heights').on('click','.remove_height',function(){
			var count = $('#addRoute .heights .controls-row').size();
			if(count <= 1) $('.add_height').click();
			$(this).closest('.controls-row').remove();
		});
		$('.comp-added-files').on('click','.delete_file',function(){
            var id = $(this).attr('alt');
            var $this = $(this).closest('li');
            api_query({
                qmethod: "POST",
                amethod: "delete_file",
                params: {id:id},
                success: function (data) {
                    $this.remove();
                },
                fail: "standart"
            });
        });
        {/literal}

        $("#fileupload_file").fileupload({
            url: '/api/api.php?m=file_club_upload&id={$comp.id}',
            dataType: 'json',
            done: function (e, data) {
                resp = data.result;
                if (resp.type=="success") {
                    $('.comp-added-files').append('<li class="'+resp.response.ext+'-file">'+resp.response.filename+'<button type="button" class="close delete_file" alt="'+resp.response.file_id+'">&times;</button></li>');
                } else {
                    alert(resp.response[0]);
                }
            }
        });
    })
    {literal}
    $(document).ready(function(){
        $('#compt-results').on('change','.user_id',function()
        {
            var user_id = $('option:selected',this).val();
            var $this = $(this).closest('tr');
            api_query({
                qmethod: "POST",
                amethod: "user_horses",
                params:  {id:user_id},
                success: function (data) {
                    $this.find('select.horse').html(data);
                },
                fail:    "standart"
            });

            api_query({
                qmethod: "POST",
                amethod: "get_user_club",
                params:  {id:user_id},
                success: function (data) {
                    var rank = $('#modal-add-user .rank option[value="'+data.rank+'"]').html();
                    $this.find('.club_id').val(data.club_id);
                    $this.find('.discharge input').val(rank);
                    if(data.club_name == null) data.club_name = 'Частный владелец';
                    $this.find('.team span').html(data.club_name);
                },
                fail:    "standart"
            });
        });
		$('#startlist').on('change','.user_id',function()
        {
            var user_id = $('option:selected',this).val();
			var owner = $('option:selected',this).html();
            var $this = $(this).closest('div.dragabble');
			var el = $(this);
            api_query({
                qmethod: "POST",
                amethod: "user_horses",
                params:  {id:user_id},
                success: function (data) {
                    $this.find('select.horse').html(data);
                    $this.find('.owner').html(owner);
					startlist_update_row(el);
                },
                fail:    "standart"
            });

            api_query({
                qmethod: "POST",
                amethod: "get_user_club",
                params:  {id:user_id},
                success: function (data) {
                    if(data.club_name == null) data.club_name = 'Частный владелец';
                    $this.find('.team').html(data.club_name);
                },
                fail:    "standart"
            });
        });
		$('#modal-add-member').on('change','.user_id',function()
        {
            var user_id = $('option:selected',this).val();
            var $this = $(this).closest('form');
            api_query({
                qmethod: "POST",
                amethod: "user_horses",
                params:  {id:user_id},
                success: function (data) {
                    $this.find('select.horse').html(data);
                },
                fail:    "standart"
            });
        });
        $('#compt-results').on('click','.add_horse',function(){
            var user_id = $(this).closest('tr').find('.user_id option:selected').val();
            $('#modal_add_horse .o_uid').val(user_id);
            $('#modal_add_horse').modal("show");

        });
		$('#startlist').on('click','.add_horse',function(){
            var user_id = $(this).closest('.dragabble').find('.user_id option:selected').val();
            $('#modal_add_horse .o_uid').val(user_id);
            $('#modal_add_horse').modal("show");

        });
		$('#modal-add-member').on('click','.add_horse',function(){
            var user_id = $(this).closest('form').find('.user_id option:selected').val();
            $('#modal_add_horse .o_uid').val(user_id);
            $('#modal_add_horse').modal("show");

        });
		$('#modal-add-user').on('click','.add_horse',function(){
            $('#modal_add_horse .o_uid').val(0);
            $('#modal-add-user').modal("hide");
            $('#modal_add_horse').modal("show");

        });
        $('#addRoute .type').change(function(){
            $('#addRoute input.sub_type').prop('checked',false);
            var select = $('option:selected',this).val();
            $('#addRoute input.sub_type').each(function(){
                var type = $(this).attr('alt');
                if(type == select){
                    $(this).closest('label').css('display','');
                }else{
                    $(this).closest('label').css('display','none');
                }
            });
        });
    });
    {/literal}
</script>
<link  href="css/chosen.css" rel="stylesheet">
<link  href="css/select2.css" rel="stylesheet">
<link  href="css/datepicker.css" rel="stylesheet">
<script>
	function edit_comp(form) {
		api_query({
			qmethod: "POST",
			amethod: "comp_edit",
			params: $(form).serialize(),
			success: function (data) {
				alert(data[0]);
			},
			fail: "standart"
		});
	}
	{literal}
	function delete_comp(id,club) {
		if(confirm('Все результаты этого соревнования будут также удалены из статистики')){
			api_query({
				qmethod: "POST",
				amethod: "comp_delete",
				params: {id:id},
				success: function (data) {
					window.location.href = '/club.php?id='+club;
				},
				fail: "standart"
			});
		}

	}
	{/literal}
    function change_riders_ordering(){
        api_query({
            qmethod: "POST",
            amethod: "change_riders_ordering",
            params: $('#form_riders_ordering').serialize(),
            success: function (data) {
            },
            fail: "standart"
        });
    }


	function select_country() {
		var def_city = '{$comp.city}';
		var country = $('.select-country option:selected').val();
		{literal}
		api_query({
			qmethod: "POST",
			amethod: "auth_get_city",
			params:  {country_id:country},
			success: function (response, data) {
				$('select.select-city').html('<option value="0"></option>'+response);
				$('select.select-city option').each(function(){
					var tmp = $(this).html();
					$(this).val(tmp);
					if(tmp == def_city) {
						$(this).prop('selected',true);
					}

				});
				$(".select-city").trigger("chosen:updated");
			},
			fail:    "standart"
		});
		{/literal}
	}

	function import_to_results(){
		var id = {$comp.id};
		{literal}
		if(confirm("Сейчас произойдет перенос всадников и их маршрутов со стартового листа. Все заполненные данные результатов ранее будут удалены.")){
			api_query({
				qmethod: "POST",
				amethod: "import_to_results",
				params: {id:id},
				success: function (data) {
					location.reload();
				},
				fail: "standart"
			});
		}
		{/literal}

    }
    $(function(){

        {literal}
		$(".clubs-page .chosen-select").chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true, placeholder_text_multiple: "Выберите виды",search_contains: true,width:'140px'});
		$('select.user_id').select2({
			placeholder: "Выбрать всадника",
			multiple: false,
			minimumInputLength: 1,
			id: function(obj) {
				return obj.id; // use slug field for id
			},
			ajax: {
				url: '/api/api.php?m=find_users',
				dataType: 'json',
				type: 'POST',
				delay: 250,
				data: function (params) {
					return {
						q: params.term, // search term
						page: params.page
					};
				},
				results: function(data, page) {
					return {
						results: data
					};
				}
			}

		});
		{/literal}

    });
	{literal}
	$(document).ready(function()
	{
		$("#competitions-admin .select-select").chosen({no_results_text: "Не найдено по запросу",placeholder_text_single: "Не выбрано",inherit_select_classes: true,search_contains: true,width:'150px'});
		$("#competitions-admin .select-select").css('width','150px');
		select_country();
	});
	{/literal}
</script>


<div class="container clubs-page club-admin main-blocks-area club-block club-add-comp">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-tabs">
				<h3 class="inner-bg">Настройки клуба<span class="pull-right text-italic"><a href="/club.php?id={$comp.o_cid}">Вернуться в клуб</a></span></h3>
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li><a href="/club-admin.php?id={$comp.o_cid}#main-admin">Основные</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#about-admin">О клубе</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#members-admin">Участники</a></li>
					<li class="active"><a href="#competitions-admin" data-toggle="tab">Соревнования</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#adv-admin">Реклама</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#contact-admin">Контакты</a></li>
				</ul>
				
				<div id="friendsTabContent" class="tab-content bg-white">
				
			<div class="tab-pane in active" id="competitions-admin">
					<div class="row">
					<form onsubmit="edit_comp(this); return false;">
						<input type="hidden" name="id" value="{$comp.id}">
						<div class="span12">
							<div class="row option-row">
								<div class="title-hr">
									<div class="title span7">Редактирование соревнования</div>
									<button href="club-admin-add-comp.php" class="btn btn-warning span3">Сохранить изменения</button>
									<a href="/club-admin.php?id={$comp.o_cid}" class="btn span">Отмена</a>
									<a href="javascript:void(0)" class="btn btn-danger span" onclick="delete_comp({$comp.id},{$comp.o_cid});"><i class="icon-trash"></i></a>
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
												<input type="text" class="span3 datepick" placeholder="дд.мм.гггг" name="bdate" value="{$comp.bdate}">
												<input type="text" class="span3 datepick" placeholder="дд.мм.гггг" name="edate" value="{$comp.edate}">
												<label class="span3">Страна</label>
												<label class="span3">Город</label>
												<div class="span3">
													<select class="select-select select-country" name="country" onchange="select_country();">
														{foreach $const_countries as $country}
															<option {if $country.country_name_ru == $comp.country}selected{/if}>{$country.country_name_ru}</option>
														{/foreach}
													</select>
												</div>
												<div class="span3">
													<select class="select-select select-city span3" name="city">
														<option value="0">Выбрать город</option>
													</select>
												</div>


											   <label class="span6">Адрес проведения соревнования</label>
												<input type="text" class="span6" name="address" value="{$comp.address}">
												<label class="span6">Вид соревнований</label>
												<select class="span6 chosen-select" name="type[]" multiple>
													{foreach $const_types as $type}
														<option {if $comp.type|strstr:$type}selected{/if}>{$type}</option>
													{/foreach}
											   </select>
											</div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
											<label class="span6">Описание соревнования</label>
											<textarea class="span6" rows="5" name="desc">{$comp.desc}</textarea>
                                            <label class="span25">Документы  (pdf, word, excel):</label>
                                            <div class="fileupload span25" id="fileupload_file">
                                                <input type="file" name="avatar">
                                                <button class="btn btn-add-file">Добавить файл</button>
                                            </div>
                                            <ul class="unstyled span6 comp-added-files">
                                                {foreach $files as $file}

                                                    <li class="{$file.ext}-file">{$file.file}<button type="button" class="close delete_file" alt="{$file.id}">&times;</button></li>
                                                {/foreach}
                                            </ul>
                                            <label class="span3">Количество денников в наличии</label>
                                            <input type="number" name="dennik" class="span1" value="{$comp.dennik}" onchange="min_zero(this)">
											<label class="span3">Количество развязок в наличии</label>
                                            <input type="number" name="razvyazki" class="span1" value="{$comp.razvyazki}" onchange="min_zero(this)">
											<label class="span3">Размер боевого поля</label>
                                            <input type="text" name="combat_field" class="span1" value="{$comp.combat_field}">
											<label class="span3">Размер тренировочного поля</label>
                                            <input type="text" name="training_field" class="span1" value="{$comp.training_field}">
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
									{if $comp.routes}
										{foreach $comp.routes as $route}
											 <tr>
												<td class="comp-date"><p>{$route.bdate}</p></td>
												<td class="route">
													<a href="/competition.php?id={$comp.id}">{$route.name}</a>
												</td>
												<td class="height"><p>{$route.height}</p></td>
												<td class="credit-for"><p>{$route.exam}</p></td>
												<td class="status"><p>{$route.status}</p></td>
												<td class="change"><a href="#" class="btn btn-grey" onclick="prepare_to_edit({$route.id}); return false;">Изменить</a><button type="button" class="close" onclick="delete_route({$route.id}, this); return false;">&times;</button></td>
											</tr>
										{/foreach}
									{else}
										<tr>
											<td colspan="6" style="text-align: center;">Маршрутов пока нет</td>
										</tr>
									{/if}
								</tbody>
								</table>
						</div>
						
					<div class="row option-row">
						<div class="span12">
            <ul class="nav nav-tabs">
              {*<li><a href="#compt-members" data-toggle="tab">Участники</a></li>*}
              <li class="active"><a href="#compt-results" data-toggle="tab">Результаты</a></li>
              <li><a href="#startlist" data-toggle="tab">Стартовый лист</a></li>
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

<style>
.compt-results input[type=text] {
	width: 90px;
}
.standarts input[type=text] {
	width: 30px !important;
}
.disq1 td {
	background-color: red !important;
}
.disq2 td {
	background-color: #0044cc !important;
}
</style>
<script>
function send_results(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_results_update",
		params: $(form).serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

function pre_add(el) {
	var element = $(el).closest("tr");
	var new_tr = element.clone();
	new_tr.find("input[type=text]").val("");
	new_tr.find("span").html("");
    new_tr.find("select option").prop("selected",false);
    new_tr.find('.chosen-container').remove();
	cancel_disq(new_tr);
    {literal}new_tr.find('select.user_id').select2({
		placeholder: "Выбрать всадника",
		multiple: false,
		minimumInputLength: 1,
		id: function(obj) {
			return obj.id; // use slug field for id
		},
		ajax: {
			url: '/api/api.php?m=find_users',
			dataType: 'json',
			type: 'POST',
			delay: 250,
			data: function (params) {
				return {
					q: params.term, // search term
					page: params.page
				};
			},
			results: function(data, page) {
				return {
					results: data
				};
			},
			cache: true
		}

	});{/literal}
	new_tr.insertBefore(element);
}

function aft_add(el) {
	var element = $(el).closest("tr");
	var new_tr = element.clone();
	new_tr.find("input[type=text]").val("");
    new_tr.find("span").html("");
	new_tr.find("select option").prop("selected",false);
    new_tr.find('.select2-container').remove();
	cancel_disq(new_tr);
    {literal}new_tr.find('select.user_id').select2({
		placeholder: "Выбрать всадника",
		multiple: false,
		minimumInputLength: 1,
		id: function(obj) {
			return obj.id; // use slug field for id
		},
		ajax: {
			url: '/api/api.php?m=find_users',
			dataType: 'json',
			type: 'POST',
			delay: 250,
			data: function (params) {
				return {
					q: params.term, // search term
					page: params.page
				};
			},
			results: function(data, page) {
				return {
					results: data
				};
			},
			cache: true
		}

	});{/literal}
	new_tr.insertAfter(element);
}

function rem(el) {
	$(el).closest("tr").remove();
}

function cancel_disq(el) {
	$(el).closest("tr").removeClass("disq1")
	.find("[name*=disq]").val("0");
    $(el).closest("tr").find("[name*=pos]").css("display","");
}
function disq(el) {
	$(el).closest("tr").addClass("disq1")
	.find("[name*=disq]").val("1");
    $(el).closest("tr").find("[name*=pos]").css("display","none");
	$('#modal_disq_reason .el_index').val($(el).closest('tr').index());
	$('#modal_disq_reason').modal('show');
}
function disq_reason() {
	var index = $('#modal_disq_reason .el_index').val();
	var reason = $('#modal_disq_reason .reason').val();
	var $el = $('.compt-results tr').get(index);
	$($el).find("[name*=reason]").val(reason);

	$('#modal_disq_reason').modal('hide');
}
function add_member_list(el){
	var element = $(el).closest('.height_table').find('.dragabble:last-child');
	var ordering = $(element).find('.ordering').val();
	ordering++;
	var route_id = $(el).closest('.height_table').attr('alt');
	var row = element.clone();
	{literal}
	api_query({
		qmethod: "POST",
		amethod: "startlist_update_row",
		params: {id:0,uid:0,hid:0,rid:route_id},
		success: function (data) {
			row.attr('alt',data);
			row.find('.delete_rider').attr('alt',data);
			row.find('.ordering').attr('name','ordering['+data+']['+route_id+']');
			row.find('.ordering').val(ordering);
			row.find('.ordering_txt').html(ordering);
            row.find("select.horse option").remove();
            row.find(".team").html('');
            row.find("select option[value=0]").prop("selected",true);
            row.find('.select2-container').remove();
            row.find('select.user_id').select2({
                placeholder: "Выбрать всадника",
                multiple: false,
                minimumInputLength: 1,
                id: function(obj) {
                    return obj.id; // use slug field for id
                },
                ajax: {
                    url: '/api/api.php?m=find_users',
                    dataType: 'json',
                    type: 'POST',
                    delay: 250,
                    data: function (params) {
                        return {
                            q: params.term, // search term
                            page: params.page
                        };
                    },
                    results: function(data, page) {
                        return {
                            results: data
                        };
                    },
                    cache: true
                }

            });
            row.find('.chosen-container').css('width','134px');
            row.insertAfter(element);
            $('#startlist .route_table').each(function(){
                var i = 0;

                $('.dragabble',this).each(function(){
                    i++;
                    var route_id = $(this).closest('.height_table').attr('alt');
                    var ride_id = $(this).attr('alt');
                    $('.span1 .ordering',this).val(i);
                    $('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
                    $('.span1 .ordering_txt',this).html(i);
                });
            });
            change_riders_ordering();
		},
		fail: "standart"
	});
	{/literal}


}
function change_publish(el,status){
	var id = {$comp.id};
    $('#startlist .route_table').each(function(){
        var i = 0;
        $('.dragabble',this).each(function(){
            if($(this).find('.user_id option:selected').val() == 0){
                $(this).remove();
            }else{
                i++;
                var route_id = $(this).closest('.height_table').attr('alt');
                var ride_id = $(this).attr('alt');
                $('.span1 .ordering',this).val(i);
                $('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
                $('.span1 .ordering_txt',this).html(i);
            }
        });
    });
    change_riders_ordering();
	{literal}
	api_query({
		qmethod: "POST",
		amethod: "change_publish",
		params: {publish:status,id:id},
		success: function (data) {
			if(status == 1){
				$(el).removeClass('btn-warning').addClass('btn-danger');
				$(el).attr('onclick','change_publish(this,0)');
				$(el).html('<i class="icon-ok-sign"></i> Снять с публикации');
			}else{
				$(el).addClass('btn-warning').removeClass('btn-danger');
				$(el).attr('onclick','change_publish(this,1)');
				$(el).html('Опубликовать');
			}
		},
		fail: "standart"
	});
	{/literal}
}
function change_publish_results(el,status){
	var id = {$comp.id};
	{literal}
	api_query({
		qmethod: "POST",
		amethod: "change_publish_results",
		params: {publish_results:status,id:id},
		success: function (data) {
			if(status == 1){
				$(el).removeClass('btn-warning').addClass('btn-danger');
				$(el).attr('onclick','change_publish_results(this,0)');
				$(el).html('<i class="icon-ok-sign"></i> Снять с публикации');
			}else{
				$(el).addClass('btn-warning').removeClass('btn-danger');
				$(el).attr('onclick','change_publish_results(this,1)');
				$(el).html('Опубликовать');
			}
		},
		fail: "standart"
	});
	{/literal}
}
function startlist_update_row(el){
	var id = $(el).closest('.dragabble').attr('alt');
	var uid = $(el).closest('.dragabble').find('.user_id option:selected').val();
	var hid = $(el).closest('.dragabble').find('.horse option:selected').val();
	var route_id = $(el).closest('.height_table').attr('alt');
	{literal}
	api_query({
		qmethod: "POST",
		amethod: "startlist_update_row",
		params: {id:id,uid:uid,hid:hid,rid:route_id},
		success: function (data) {
			$(el).closest('.dragabble').attr('alt',data);
			$(el).closest('.dragabble').find('.delete_rider').attr('alt',data);
			change_riders_ordering();
		},
		fail: "standart"
	});
	{/literal}
}
function disq2(el) {
	$(el).closest("tr").addClass("disq2")
	.find("[name*=disq]").val("2");
    $(el).closest("tr").find("[name*=pos]").css("display","none");
}
function add_member_result(el,id){
	$(el).closest('table').find('.height'+id+':last .icon-chevron-down').closest('a').click();
}
$(function () {
	$('#fileupload').fileupload({
		maxNumberOfFiles: 1,
		dataType: 'json',
		url: "/api/api.php?m=comp_results_parse&id={$comp.id}",
		done: function (e, data) {
			var result = data.result
			if (result.type == "success") {
				window.location.reload();
			} else {
				errors = "";
				for (i = 0;i < result.response.length; ++i)
					errors += result.response[i] + "<br>";
				alert(errors);
			}
		}
	});
})
</script>

              
			  <div class="tab-pane active" id="compt-results" style="position: relative">
				  <a href="javascript:void(0)" class="btn btn-warning" onclick="import_to_results();">Импорт всадников<br/><small>со стартового листа</small></a>
				  {if $comp.publish_results == 0}
					  <a href="javascript:void(0)" class="btn btn-warning" onclick="change_publish_results(this,1)">Опубликовать</a>
				  {else}
					  <a href="javascript:void(0)" class="btn btn-danger" onclick="change_publish_results(this,0)"><i class="icon-ok-sign"></i> Снять с публикации</a>
				  {/if}
				  <a href="/api/generate_xls.php?id={$comp.id}" target="_blank" class="btn btn-warning">Скачать результаты</a>
				<form onsubmit="send_results(this);return false;">
				<input type="hidden" name="id" value="{$comp.id}" >
				<div class="c-results-btns" style="position: fixed;right: 200px;top: 400px;">
					<ul>
                        <li><button class="btn btn-warning">Сохранить</button></li>
						<li><a href="#modal-add-user" data-toggle="modal" class="btn btn-warning">Добавить всадника</a></li>
					</ul>
				</div>

						{if $comp.routes}
							{foreach $comp.routes as $route}
                    <table class="table table-striped competitions-table compt-results admin-compts">
                        <tbody>
                        {if $route.sub_type == 'на чистоту и трезвость'}
                        <tr>
                            <th rowspan="2" class="mesto">М<br/>е<br/>с<br/>т<br/>о</th>
                            <th rowspan="2">Всадник</th>
                            <th rowspan="2">Разряд</th>
                            <th rowspan="2">Лошадь</th>
                            <th rowspan="2">Команда</th>
                            <th colspan="2"><center>Маршрут</center></th>
                            <th rowspan="2"><center>Выйгрыш</center></th>
                            <th rowspan="2"> </th>
                        </tr>
                        <tr>
                            <th>Ш.О.</th>
                            <th>Время</th>
                        </tr>
                        {elseif $route.sub_type == '269'}

                            <tr>
                                <th rowspan="2" class="mesto">М<br/>е<br/>с<br/>т<br/>о</th>
                                <th rowspan="2">Всадник</th>
                                <th rowspan="2">Разряд</th>
                                <th rowspan="2">Лошадь</th>
                                <th rowspan="2">Команда</th>
                                <th colspan="2"><center>Результат</center></th>
								<th rowspan="2"><center>Выйгрыш</center></th>
                                <th rowspan="2"> </th>
                            </tr>
                            <tr>
                                <th>Балл</th>
                                <th>Время</th>
                            </tr>
                        {elseif $route.sub_type == 'с перепрыжкой'}

                            <tr>
                                <th rowspan="2" class="mesto">М<br/>е<br/>с<br/>т<br/>о</th>
                                <th rowspan="2">Всадник</th>
                                <th rowspan="2">Разряд</th>
                                <th rowspan="2">Лошадь</th>
                                <th rowspan="2">Команда</th>
                                <th colspan="2"><center>Маршрут</center></th>
                                <th colspan="2"><center>Перепрыжка</center></th>
								<th rowspan="2"><center>Выйгрыш</center></th>
                                <th rowspan="2"> </th>
                            </tr>
                            <tr>
                                <th>Ш.О.</th>
                                <th>Время</th>
                                <th>Ш.О.</th>
                                <th>Время</th>
                            </tr>
                        {elseif $route.sub_type == ''}
                        <tr>
                            <th class="mesto">М<br/>е<br/>с<br/>т<br/>о</th>
                            <th>Всадник</th>
                            <th>Разряд</th>
                            <th>Лошадь</th>
                            <th>Команда</th>
                            <th>Ш.О.</th>
                            <th>Время </th>
                            <th>Ш.О.</th>
                            <th>Пере- прыжка</th>
                            <th>Норма</th>
							<th><center>Выйгрыш</center></th>
                            <th> </th>
                        </tr>
                        {/if}
						<tr><td colspan="12" class="table-caption">{$route.name}</td></tr>
						{foreach $comp.heights.{$route.id} as $height}
								<tr><td colspan="12" class="table-caption height-caption"><div class="span"><a href="javascript:void(0)" onclick="add_member_result(this,{$height.id});" style="font-size: 10px">Добавить всадника в маршрут</a></div>{$height.height},{$height.exam}</td></tr>
							{if $comp.results.{$height.id}}
								{foreach $comp.results.{$height.id} as $res}
									<tr class="{if $res.disq}disq{$res.disq}{/if} height{$height.id}" data-disq={$res.disq}>
										<td class="n total standarts">
											<input type="text" name="pos[{$height.id}][]" value="{$res.rank}" {if $res.disq}style="display: none"{/if}>
											<input type="hidden" name="disq[{$height.id}][]" value="{$res.disq}">
											<input type="hidden" name="reason[{$height.id}][]" value="{$res.disq_reason}">
										</td>
										<td class="name">
											<select name="fio[{$height.id}][]" style="width: 140px" class="chosen-select2 user_id">
												<option value="0">Выбрать всадника</option>
												{foreach $users as $usr}
													<option value="{$usr.id}" {if $usr.id == $res.user_id}selected="selected"{/if}>{$usr.lname} {$usr.fname}, {$usr.bdate}, {$usr.city}</option>
												{/foreach}
											</select>
										</td>
										<td class="discharge standarts"><input type="text" name="degree[{$height.id}][]" value="{$res.razryad}"></td>
										<td class="horse" alt="{$res.horse}">

											<select name="horse[{$height.id}][]" class="horse" style="width: 80px">
												<option value="0"></option>
												{foreach $res.horses as $horse}
													<option value="{$horse.id}" {if $horse.id == $res.horse}selected="selected"{/if}>{$horse.nick}</option>
												{/foreach}
											</select>
											<center><a href="javascript:void(0)" class="add_horse">+</a></center>
										</td>
										<td class="team">
											<span>{$res.club}{if $res.club == '' && $res.user_id}Частный владелец{/if}</span>
											<input type="hidden" name="club_id[{$height.id}][]" class="club_id" value="{$res.club_id}">
										</td>
										<td class="standarts" {if $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="shtraf_route[{$height.id}][]" value="{$res.shtraf_route}" ></td>
										<td class="standarts" {if $route.sub_type != '269'}style="display: none"{/if}><input type="text" name="ball[{$height.id}][]" value="{$res.ball}"></td>
										<td class="standarts"><input type="text" name="time[{$height.id}][]" value="{$res.time}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="shtraf[{$height.id}][]" value="{$res.shtraf}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="reroute[{$height.id}][]" value="{$res.rerun}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == 'с перепрыжкой' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="norma[{$height.id}][]" value="{$res.norma}"></td>
										<td class="standarts">
											<input type="text" name="money[{$height.id}][]" value="{$res.money}">
											<select name="currency[{$height.id}][]" style="width: 50px">
												<option value="руб." {if $res.currency == 'руб.'}selected="selected"{/if}>руб.</option>
												<option value="$" {if $res.currency == '$'}selected="selected"{/if}>$</option>
												<option value="€" {if $res.currency == '€'}selected="selected"{/if}>€</option>
											</select>
										</td>

										<td class="closebtn"><div class="dropdown button">
												<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
												<ul id="menu1" class="dropdown-menu" role="menu">
													<li><a tabindex="-1" href="#" onclick="pre_add(this); return false;"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
													<li><a tabindex="-1" href="#" onclick="aft_add(this); return false;"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
													<li class="divider"></li>
													<li><a tabindex="-1" href="#" onclick="disq(this); return false;"><i class="icon-remove-sign"></i> Исключить</a></li>
													<li><a tabindex="-1" href="#" onclick="disq2(this); return false;"><i class="icon-remove-sign"></i> Снялся</a></li>
													<li><a tabindex="-1" href="#" onclick="cancel_disq(this); return false;"><i class="icon-remove-sign"></i> Отменить исключение</a></li>
													<li><a tabindex="-1" href="#" onclick="rem(this); return false;"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
												</ul>
											</div></td>
									</tr>
								{/foreach}
							{else}
								<tr class="height{$height.id}" data-disq=0>
									<td class="n total standarts">
										<input type="text" name="pos[{$height.id}][]" value="">
										<input type="hidden" name="disq[{$height.id}][]" value="">
										<input type="hidden" name="reason[{$height.id}][]" value="">
									</td>
									<td class="name">
										<select name="fio[{$height.id}][]" style="width: 140px" class="chosen-select2 user_id">
											<option value="0">Выбрать всадника</option>
										</select>
									</td>
									<td class="discharge standarts"><input type="text" name="degree[{$height.id}][]" value=""></td>
									<td class="horse" alt="">

										<select name="horse[{$height.id}][]" class="horse" style="width: 80px">
											<option value="0"></option>
										</select>
										<center><a href="javascript:void(0)" class="add_horse">+</a></center>
									</td>
									<td class="team">
										<span></span>
										<input type="hidden" name="club_id[{$height.id}][]" class="club_id" value="">
									</td>
									<td class="standarts" {if $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="shtraf_route[{$height.id}][]" value="" ></td>
									<td class="standarts" {if $route.sub_type != '269'}style="display: none"{/if}><input type="text" name="ball[{$height.id}][]" value=""></td>
									<td class="standarts"><input type="text" name="time[{$height.id}][]" value="{$res.time}"></td>
									<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="shtraf[{$height.id}][]" value=""></td>
									<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="reroute[{$height.id}][]" value=""></td>
									<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == 'с перепрыжкой' || $route.sub_type == '269'}style="display: none"{/if}><input type="text" name="norma[{$height.id}][]" value=""></td>
									<td class="standarts">
										<input type="text" name="money[{$height.id}][]" value="">
										<select name="currency[{$height.id}][]" style="width: 50px">
											<option value="руб.">руб.</option>
											<option value="$">$</option>
											<option value="€">€</option>
										</select>
									</td>

									<td class="closebtn"><div class="dropdown button">
											<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
											<ul id="menu1" class="dropdown-menu" role="menu">
												<li><a tabindex="-1" href="#" onclick="pre_add(this); return false;"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
												<li><a tabindex="-1" href="#" onclick="aft_add(this); return false;"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
												<li class="divider"></li>
												<li><a tabindex="-1" href="#" onclick="disq(this); return false;"><i class="icon-remove-sign"></i> Исключить</a></li>
												<li><a tabindex="-1" href="#" onclick="disq2(this); return false;"><i class="icon-remove-sign"></i> Снялся</a></li>
												<li><a tabindex="-1" href="#" onclick="cancel_disq(this); return false;"><i class="icon-remove-sign"></i> Отменить исключение</a></li>
												<li><a tabindex="-1" href="#" onclick="rem(this); return false;"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
											</ul>
										</div></td>
								</tr>
							{/if}

							{/foreach}

                        </tbody>
                    </table>
							{/foreach}
						{else}
                            <table class="table table-striped competitions-table compt-results admin-compts">
                                <tbody><tr>
                                    <th class="mesto">М<br/>е<br/>с<br/>т<br/>о</th>
                                    <th>Всадник</th>
                                    <th>Разряд</th>
                                    <th>Лошадь</th>
                                    <th>Команда</th>
                                    <th>Штраф. очки маршрут</th>
                                    <th>Время маршрут</th>
                                    <th>Штраф. очки</th>
                                    <th>Пере- прыжка</th>
                                    <th>Норма</th>
                                    <th> </th>
                                </tr>
							<tr>
								<td colspan="11" style="text-align: center;">Для редактирования результатов добавьте маршрут.</td>
							</tr>
                            </tbody>
                            </table>
						{/if}

              	</form>
              </div><!-- compt-results -->
              <div class="tab-pane" id="startlist">
				  <a data-toggle="modal" href="#modal-add-user" class="btn btn-warning">Добавить участника</a>
				  <a onclick="accept_riders({$comp.id})" href="javascript:void(0)" class="btn btn-warning">Подтвердить всем участие</a>

				  {if $comp.publish == 0}
					  <a href="javascript:void(0)" class="btn btn-warning" onclick="change_publish(this,1)">Опубликовать</a>
				  {else}
					  <a href="javascript:void(0)" class="btn btn-danger" onclick="change_publish(this,0)"><i class="icon-ok-sign"></i> Снять с публикации</a>
				  {/if}

                  <form action="#" id="form_riders_ordering" onsubmit="change_riders_ordering(); return false;">
                  <div class="table table-striped competitions-table compt-results admin-compts" id="startlist_table">
                        <div class="row header">
                          <div class="span1">№</div>
                          <div class="span2">Всадник</div>
                          <div class="span2">Разряд</div>
                          <div class="span2">Лошадь</div>
                          <div class="span2">Владелец лошади</div>
                          <div class="span2">Клуб</div>
                          <div class="span1">Удалить</div>
                      </div>
                      {if $comp.routes}
                              {foreach $comp.routes as $route}
					  				<div class="route_table" alt="{$route.id}"><div class="row"><div class="table-caption no-drag span12">{$route.name}</div></div>
								  {foreach $comp.heights.{$route.id} as $height}
									  <div class="height_table" alt="{$height.id}"><div class="row"><div class="table-caption height-caption no-drag span12"><div class="span"><a href="javascript:void(0)" onclick="add_member_list(this);" style="font-size: 10px">Добавить всадника в маршрут</a></div>{$height.height},{$height.exam}</div></div>
										  {if $comp.startlist.{$height.id}}
											  {foreach $comp.startlist.{$height.id} as $res}
												  <div class="dragabble row" alt="{$res.ride_id}">
													  <div class="span1">
														  <span class="ordering_txt">{$res.ordering}</span>
														  <input type="hidden" name="ordering[{$res.ride_id}][{$height.id}]" class="ordering" value="{$res.ordering}">
													  </div>
													  <div class="span2 no-drag">
														  <select style="width: 140px; margin: 0 !important;" onchange="startlist_update_row(this);" class="chosen-select2 user_id">
															  <option value="0">Выбрать всадника</option>
															  {foreach $users as $usr}
																  <option value="{$usr.id}" {if $usr.id == $res.id}selected="selected"{/if}>{$usr.lname} {$usr.fname}, {$usr.bdate}, {$usr.city}</option>
															  {/foreach}
														  </select>
													  </div>
													  <div class="span2">-</div>
													  <div class="span2">
														  <select class="horse" style="width: 80px" onchange="startlist_update_row(this);">
															  {foreach $res.horses as $horse}
																  <option value="{$horse.id}" {if $horse.id == $res.horse_id}selected="selected"{/if}>{$horse.nick}</option>
															  {/foreach}
														  </select>
														  <center><a href="javascript:void(0)" class="add_horse">+</a></center>
													  </div>
													  <div class="span2 owner">{if $res.owner}{$res.owner}{else}{$res.ownerName}{/if}</div>
													  <div class="span2 team">{$res.club}</div>
													  <div class="span1"><a href="javascript:void(0)" class="delete_rider" alt="{$res.ride_id}">удалить</a> </div>
												  </div>
											  {/foreach}

										  {else}
											  <div class="dragabble row" alt="">
												  <div class="span1">
													  <span class="ordering_txt">1</span>
													  <input type="hidden" name="ordering[][{$height.id}]" class="ordering" value="1">
												  </div>
												  <div class="span2">
													  <select style="width: 140px; margin: 0 !important;" onchange="startlist_update_row(this);" class="chosen-select2 user_id">
														  <option value="0">Выбрать всадника</option>
														  {foreach $users as $usr}
															  <option value="{$usr.id}">{$usr.lname} {$usr.fname}, {$usr.bdate}, {$usr.city}</option>
														  {/foreach}
													  </select>
												  </div>
												  <div class="span2">-</div>
												  <div class="span2">
													  <select class="horse" style="width: 80px" onchange="startlist_update_row(this);">
														  {foreach $res.horses as $horse}
															  <option value="{$horse.id}">{$horse.nick}</option>
														  {/foreach}
													  </select>
													  <center><a href="javascript:void(0)" class="add_horse">+</a></center>
												  </div>
												  <div class="span2 owner">-</div>
												  <div class="span2 team">-</div>
												  <div class="span1"><a href="javascript:void(0)" class="delete_rider" alt="">удалить</a> </div>
											  </div>
										  {/if}

									  </div>
								  {/foreach}
								  </div>
                              {/foreach}

                      {else}
                          <div class="row">
                              <div class="span12" style="text-align: center;">Нет маршрутов.</div>
                          </div>
                      {/if}
                  </div>
                  </form>
              </div><!-- compt-startlist -->
			  
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
function my_option(el){
	var opt = $(el).find('option:selected').val();
	if(opt == 'my')$(el).closest('.opt').find('select').replaceWith('<input type="text" class="span2" name="opt_name[]">');
}
function min_zero(el){
	var opt = parseInt($(el).val()) || 0;
	if(opt < 0)$(el).val(0);
}
function add_option() {
	return $("<div class='opt span6'> \
		<select class='span2' name='opt_name[]' onchange='my_option(this)'> \
			<option>Тип грунта</option> \
			<option selected>Вступительный взнос</option> \
			<option>Дистанция </option> \
			<option value='my'>Свой вариант</option> \
	</select> \
	<input class='span2' type='text' name='opt[]' /> \
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
			window.location.reload();
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
			window.location.reload();
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

function accept_riders(id) {
	api_query({
		qmethod: "POST",
		amethod: "accept_riders",
		params: {
			id: id
		},
		success: function (data) {
			alert('Уведомление отправлено всем участникам');
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
			    if(index != 'sub_type') form.find("[name="+index+"]").val(value);
			});
			$.each(data.options, function (index, value) {
				var new_opt = add_option();
				var isset = new_opt.find('select option[value="'+index+'"]').val() || '';
				if(isset != ''){
					new_opt.find("select").val(index);
				}else{
					new_opt.find("select").replaceWith('<input type="text" class="span2" name="opt_name[]" value="'+index+'">');
				}

				new_opt.find('input[name="opt[]"]').val(value);
			});
			var row = $('#addRoute .heights .controls-row:first-child').clone();
			var rows = '';
			$('#addRoute .heights .controls-row').remove();
			$.each(data.heights, function (index, value) {
				row.find('input').attr('name','height['+value.id+']').val(value.height);
				row.find('select').attr('name','exam['+value.id+']');
				row.find('select option').each(function() {
					var tmp = $(this).html();
					$(this).val(tmp);
				});


				row.clone(true).appendTo('#addRoute .heights');
				$('#addRoute .heights .controls-row:last-child select option[value="'+value.exam+'"]').prop('selected',true);
			});

			form.find("h3").text("Изменение маршрута");
			form.find("form").attr("onsubmit", "edit_route(this); return false;");
			form.find("[name=id]").val(data.id);
			form.find('button[type="submit"]').html('Изменить маршрут');
			form.modal("show");
		},
		fail: "standart"
	});
}

function prepare_to_add() {
	var date = $('[name="bdate"]').val();
	var mdl = $("#addRoute");
	var row_h = mdl.find('.heights .controls-row:first-child').clone();
	mdl.find(".heights .controls-row").remove();
	mdl.find(".heights").append(row_h);
	mdl.find("#options .opt").remove();
	mdl.find("h3").text("Добавление маршрута");
	mdl.find("form").attr("onsubmit", "add_route(this); return false;");
	mdl.find("input[type=text]").val("");
	mdl.find("input[name=date]").val(date);
	mdl.find('button[type="submit"]').html('Добавить маршрут');
	mdl.find('.type').change();
	add_option();
	mdl.modal("show");
}



</script>
<div id="disqReason" class="modal hide" tabindex="-1" role="dialog" aria-hidden="false">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Причина исключения</h3>
    </div>
    <div class="modal-body">
        <div class="controls controls-row">
            <textarea class="reason" placeholder="Причина исключения"></textarea>
        </div>
        <div class="controls controls-row">
            <button type="submit" class="btn btn-warning span3">Добавить маршрут</button>
            <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
        </div>
    </div>
</div>
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
                    <label class="span3">Вид соревнования<span class="req-field">*</span></label>
					<label class="span3">Статус<span class="req-field">*</span></label>
                    <select class="span3 type" name="type" style="width:205px">
						{foreach $const_types as $type}
							{if $type == 'Конкур'}<option>{$type}</option>{/if}
						{/foreach}
                    </select>
					<select class="span3" name="status" style="width:205px">
						<option>Всероссийские</option>
						<option>Клубные</option>
						<option>Международные</option>
						<option>Межрегиональные</option>
						<option>Муниципальные</option>
						<option>Региональные</option>
						<option>Традиционные</option>
					</select>
					<br/>
                    <div class="span3">
                        <label class="sub_type" style="display: none"><input type="radio" name="sub_type" class="sub_type" alt="Конкур" value="на чистоту и трезвость"> на чистоту и трезвость</label>
                        <label class="sub_type" style="display: none"><input type="radio" name="sub_type" class="sub_type" alt="Конкур" value="с перепрыжкой"> с перепрыжкой</label>
                        <label class="sub_type" style="display: none"><input type="radio" name="sub_type" class="sub_type" alt="Конкур" value="269"> 269</label>
                    </div>

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
				<div class="heights">
					<div class="controls controls-row">
						<label class="span3">Высота<span class="req-field">*</span></label>
						<label class="span3">Зачёт для<span class="req-field">*</span></label>
						<input type="text" class="span3" name="height[]">
						<select class="span2" name="exam[]" style="width:190px">
							<option value="0">Не выбрано</option>
							<option>Дети 12-14 лет</option>
							<option>Любители 18-30 лет</option>
							<option>Любители 31 год и старше</option>
							<option>Юноши 14-18 лет</option>
							<option>Взрослые спортсмены</option>
							<option>Взрослые спортсмены на молодых лошадях 4-5 лет</option>
						</select>
						<button class="close remove_height span" type="button">×</button>
					</div>
				</div>

                <div class="controls controls-row">
					<div class="span6 text-right"><a href="javascript:void(0)" class="add_height">Добавить высоту</a></div>
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
<script>
    function save_horse(form) {
		var uid = $(form).find('.o_uid').val();
		if(uid > 0){
			api_query({
				qmethod: "POST",
				amethod: "horses_add_admin",
				params: $(form).serialize(),
				success: function (id) {
					var name = $(form).find('input[name="nick"]').val();
					var o_uid = $(form).find('.o_uid').val();
					$('#compt-results select.user_id').each(function(){
						var tmp_selected = $('option:selected',this).val();
						if(tmp_selected == o_uid){
							$(this).closest('tr').find('select.horse').append('<option value="'+id+'">'+name+'</option>');
						}
					});
					$('#startlist select.user_id').each(function(){
						var tmp_selected = $('option:selected',this).val();
						if(tmp_selected == o_uid){
							$(this).closest('.dragabble').find('select.horse').append('<option value="'+id+'">'+name+'</option>');
							startlist_update_row($(this));
						}
					});
					$('#modal-add-member select.user_id').each(function(){
						var tmp_selected = $('option:selected',this).val();
						if(tmp_selected == o_uid){
							$(this).closest('form').find('select.horse').append('<option value="'+id+'">'+name+'</option>');
						}
					});
					$('#modal_add_horse input[type="text"]').val("");
					$('#modal_add_horse select option:first-child').prop("selected",true);
					$('#modal_add_horse').modal("hide");
				},
				fail: function (err) { //our modal not working
					console.log(err);
					var errs = "";
					for (i=0;i<err.length;++i)
						errs += err[i] + "\n";
					alert(errs);
				}
			})
		}else{
			var nick = $(form).find('[name*=nick]').val();
			var forma = '';
			$(form).find('input').each(function(){
				var tmp = $(this).clone();
				forma += '<input type="hidden" name="h_'+tmp.attr('name')+'[]" class="'+tmp.attr('name')+'" value="'+tmp.val()+'">';
			});
			$(form).find('select').each(function(){
				var tmp = $(this).clone();
				forma += '<input type="hidden" name="h_'+tmp.attr('name')+'[]" class="'+tmp.attr('name')+'" value="'+tmp.find('option:selected').val()+'">';
			});
			$('#modal-add-user .horses').append('<li>'+nick+' <a href="javascript:void(0)" class="icon-pencil" onclick="edit_horse(this);"></a> <a href="javascript:void(0)" class="icon-trash" onclick="delete_horse(this);"></a><div style="display: none">'+forma+'</div></li>');
			$('#modal-add-user').modal("show");
			$('#modal_add_horse').modal("hide");
		}

    }
	function delete_rider(){
		var rid = $('#modal_delete_reason .el_index').val();
		var reason = $('#modal_delete_reason .reason').val();
		var blocked = $('#modal_delete_reason .blocked:checked').val() || 0;
		if(rid > 0){
			$('#startlist .dragabble').each(function(){
				var alt = $(this).attr('alt');
				if(alt == rid){
					var rows = $(this).closest('.height_table').find('.delete_rider').size() || 0;
					if(rows <= 1) add_member_list($(this).closest('.height_table').find('.table-caption a'));
					$(this).remove();
				}
			});
			{literal}
			api_query({
				qmethod: "POST",
				amethod: "delete_rider",
				params: {rid:rid,reason:reason,blocked:blocked},
				success: function (data) {
					$('#startlist .route_table').each(function(){
						var i = 0;
						$('.dragabble',this).each(function(){
							i++;
							var route_id = $(this).closest('.height_table').attr('alt');
							var ride_id = $(this).attr('alt');
							$('.span1 .ordering',this).val(i);
							$('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
							$('.span1 .ordering_txt',this).html(i);
						});
					});
					change_riders_ordering();
					$('#modal_delete_reason').modal('hide');
				},
				fail: "standart"
			});{/literal}
		}
	}
</script>
<div id="modal_add_horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавление лошади</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" action="#" onsubmit="save_horse(this); return false;">
            <div class="controls controls-row">
                <label class="span3">Кличка лошади:</label><label class="span3">Пол лошади:</label>
                <input type="text" class="span3" name="nick">
                <select class="span3 offset1" name="sex">
                    {foreach $const_horses_sex as $sex}
                        <option>{$sex}</option>
                    {/foreach}
                </select>
            </div>
            <div class="controls controls-row">
                <label class="span3">Рост лошади:</label><label class="span3">Порода:</label>
                <input type="text" class="span3" name="rost">
                <select class="span3 offset1" name="poroda">
                    {foreach $const_horses_poroda as $poroda}
                        <option>{$poroda}</option>
                    {/foreach}
                </select>
            </div>
            <div class="controls controls-row">
                <label class="span3">Масть:</label><label class="span3">Паспорт:</label>
                <select class="span3 offset1" name="mast">
                    {foreach $const_horses_mast as $mast}
                        <option>{$mast}</option>
                    {/foreach}
                </select>
                <input type="text" class="span3" name="pasport">
            </div>
            <div class="controls controls-row">
                <label class="span3">Год рождения:</label><label class="span3">Место рождения:</label>
                <input type="text" class="span3" name="byear">
                <input type="text" class="span3" placeholder="Пример, клуб 'СССР'" name="bplace">
            </div>
            <div class="controls controls-row">
                <input type="hidden" class="o_uid" name="o_uid" value="">
                <button type="submit" class="btn btn-warning span3">Добавить</button>
                <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
            </div>
        </form>
    </div>
</div>
<div id="modal_disq_reason" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Причина исключения</h3>
    </div>
    <div class="modal-body">
		<div class="controls controls-row">
			<textarea class="reason" placeholder="Причина исключения"></textarea>
		</div>
		<div class="controls controls-row">
			<input type="hidden" class="el_index" value="">
			<button class="btn btn-warning span3" onclick="disq_reason();">Сохранить</button>
			<button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
		</div>
    </div>
</div>
<div id="modal_delete_reason" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Удаление из соревнования</h3>
    </div>
    <div class="modal-body">
		<div class="controls controls-row">
			<textarea class="reason span6" placeholder="Причина удаления"></textarea>
		</div>
		<div class="controls controls-row">
			<input type="checkbox" class="blocked" value="1"> Запретить для спортсмена кнопку Учавствовать в данном соревновании
		</div>
		<hr/>
		<div class="controls controls-row">
			<input type="hidden" class="el_index" value="">
			<button class="btn btn-warning span3" onclick="delete_rider();">Удалить</button>
			<button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
		</div>
    </div>
</div>

{include "modules/footer.tpl"}