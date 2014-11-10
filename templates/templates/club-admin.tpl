{* Smarty *}

{include "modules/header.tpl"}
<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
<!-- implement jcrop -->
<script src="js/upload/jquery.Jcrop.min.js"></script>
<link rel="stylesheet" href="js/upload/jquery.Jcrop.min.css" type="text/css" />
<!-- yandex map -->
<script src="http://api-maps.yandex.ru/2.0/?load=package.full&lang=ru-RU" type="text/javascript"></script>
<script>
window.addition_id = 0;

function add_phone() {
	$("<input type='text' class='span3' name='p_desc[]' placeholder='описание телефона' > \
	  <input type='text' class='span3' name='phones[]' placeholder='номер' >").appendTo("#phones");
}
function update_photo_coords(c) {
    $('.step3 input[name=x1]').val(c.x);
    $('.step3 input[name=y1]').val(c.y);
    $('.step3 input[name=x2]').val(c.x2);
    $('.step3 input[name=y2]').val(c.y2);
}

function crop(el) {
    api_query({
        qmethod: "POST",
        amethod: "club_upload_avatar_crop",
        params:  $(el).serialize(),
        success: function (data) {
            $("#club_avatar").attr("src", data.avatar);
            $("#modal-change-avatar").modal("hide");
        },
        fail:    "standart"
    })
}
$(function () {
	$("#fileupload").fileupload({
		url: '/api/api.php?m=gallery_club_upload_avatar&id={$club.id}',
		dataType: 'json',
		done: function (e, data) {
			resp = data.result;
			if (resp.type=="success") {
				console.log(resp.response.avatar);
				$("#club_avatar").attr("src", resp.response.avatar);
                $(".step3 input[name=avatar]").val(resp.response.avatar);
                $('#modal-change-avatar').modal('show');
                $(".step3").css("display", "");
                $("#future-avatar").Jcrop({
                    aspectRatio: 1,
                    onChange: update_photo_coords,
                    onSelect: update_photo_coords
                }, function () {
                    jcrop_api = this;
                    jcrop_api.setImage(resp.response.avatar, function () {
                        jcrop_api.setSelect([10,10,210,210]);
                    });

                });
			} else {
				alert(resp.response[0]);
			}
		}
	});
    {literal}$(".chosen-select").chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true});{/literal}
    change_city($('select.metro'));
	var data = $.parseJSON('{$club.additions}');
	$.each(data, function (index, value) {
		console.log(value);
		var el = add_new_addition().find("select").val(value.name).trigger("change").closest(".ability");
		$.each(value, function (sub_index, sub_value) {
			el.find("[name*='" + sub_index + "']").val(sub_value);
		});
	})

});

function step_one() {
	api_query({
		qmethod: "POST",
		amethod: "club_edit1",
		params: $('#main-admin form').serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

function step_two() {
	api_query({
		qmethod: "POST",
		amethod: "club_edit2",
		params: $('#about-admin form').serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

function save_steps(){
    step_one();
    step_two();
}

{literal}

function change_country(select) {
    var country = $('select.country option:selected').attr('country_id') || 0;
    var city = $('#club_city').val();

    api_query({
        qmethod: "POST",
        amethod: "auth_get_city",
        params:  {country_id:country},
        success: function (response, data) {
            var values = '<option value="0">Все города</option>'+response;
            $('select.city').html(values);
            $('select.city option').each(function(){
                if($(this).html() != "Все города") $(this).val($(this).html());
            });
            $('select.city option[value="'+city+'"]').prop('selected',true);
            $('select.city').trigger("chosen:updated");
            update_mark();
        },
        fail:    "standart"
    })
}
function change_city(select){
    var city = $('option:selected',select).html();
    if (city == 'Москва'){
        $('.metro').css('display','');
    }else{
        $('.metro').css('display','none');
    }
    update_mark();
}
{/literal}

function update_mark() {
	country = $("[name=country]").val();
	city = $("[name=city]").val();
	address = $("[name=address]").val();
	if (country != null &&  city != "" && address != "") {
		show_address(country + ", " + city + ", " + address);
	}
}

var myMap, geoResult = undefined, coords;
ymaps.ready(init);

function init () {
	myMap = new ymaps.Map('map', {
		center:[55.76, 37.64], 
		zoom: 13
	});
	myMap.controls.add('zoomControl');
	{if $club.coords}
		show_address([{$club.coords.0}, {$club.coords.1}]);
	{/if}
}

function update_coords (data) {
	coords = data;
	$("#x").val(coords[0]);
	$("#y").val(coords[1]);
	console.log(coords);
}

{literal}
function show_address(adress) {
	if (geoResult !== undefined) {
		myMap.geoObjects.remove(geoResult);
	}
	ymaps.geocode(adress, {results: 1}).then(function(res) {
		if (res.metaData.geocoder.found !== 0) {
			geoResult = res.geoObjects.get(0);
			update_coords(geoResult.geometry.getCoordinates());
			geoResult.options.set("draggable", "true");
			geoResult.events.add("dragend", function () {
				update_coords(geoResult.geometry.getCoordinates());
			});
			myMap.geoObjects.add(geoResult);
			myMap.setCenter(coords);
			geoResult.balloon.open();
		} else {
			alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
		}
	}, function (err) {
		alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
	});
}
{/literal}

function add_ability(element) {
	$("#abilities .ability").eq(0).clone().appendTo("#abilities .controls");
}									

function del_ability(element) {
	$(element).closest(".ability").remove();
}

function additions_type_change(el) {
	var id = parseInt($(el).closest(".ability").attr("data-opt"));
	var left_sides = [
		'',
		'	<div class="controls controls-row"> \
				<label class="span2">С инструктором:</label> \
				<input class="span4" type="text" name="opt['+id+'][with_inst]" placeholder="Введите цену за час"> \
				<label class="span2">Без инструктора:</label> \
				<input class="span4" type="text" name="opt['+id+'][without_inst]" placeholder="Введите цену за час"> \
				<label class="span2">Постой лошади:</label> \
				<input class="span4" type="text" name="opt['+id+'][horse]" placeholder="Введите цену за час"> \
			</div>',
		'	<div class="controls controls-row"> \
				<input class="span5" name="opt['+id+'][l_city]" type="text" placeholder="Введите расстояние"><span> км.</span> \
			</div> \
		',
		'	<div class="controls controls-row"> \
				<input class="span5" name="opt['+id+'][l_point]" type="text" placeholder="Введите расстояние"><span> км.</span> \
			</div> \
		',
		'<div class="controls controls-row"> \
				<label class="span2">Денники:</label> \
				<input class="span4" type="text" name="opt['+id+'][denniki_cnt]" placeholder="количество"> \
				<label class="span2">Тренеры:</label> \
				<input class="span4" type="text" name="opt['+id+'][trainers_cnt]" placeholder="количество"> \
				<label class="span2">Ветеринары:</label> \
				<input class="span4" type="text" name="opt['+id+'][doc]" placeholder="количество"> \
		 </div> \
		',
		'	<div class="controls controls-row"> \
				<label class="span1">Самцы:</label> \
				<input class="span5" type="text" name="opt['+id+'][man]" placeholder="Кол-во самцов"> \
				<label class="span1">Самки:</label> \
				<input class="span5" type="text" name="opt['+id+'][woman]" placeholder="Кол-во самок"> \
			</div>'
	];
	$(el).closest(".ability").find(".second_block").html(left_sides[$(el).prop('selectedIndex')]);

}

function del_ability(e) {
	$(e).closest(".ability").remove();
}

function add_new_addition() {
	var new_add = '<div class="row ability" data-opt="'+window.addition_id+'"> \
							<div class="span6"> \
							<div class="controls controls-row"> \
									<select class="span5" name="opt['+window.addition_id+'][name]" onchange="additions_type_change(this);"> \
										<option selected="" disabled="">Выберите из списка</option> \
										<option>Аренда лошади</option> \
										<option>Расстояние от города</option> \
										<option>Расстояние от остановки общественного транспорта</option> \
										<option>Обслуживающий персонал</option> \
										<option>Лошади</option> \
								   </select> \
								   <button class="btn span1" onclick="del_ability(this);return false;">-</button> \
							</div> \
						</div> \
						<div class="span6"> \
							<div class="row second_block"> \
							</div> \
						</div> \
					</div>';
	window.addition_id++;
	return $(new_add).appendTo("#new_addition");
}

function make_staff_form(id, fio, avatar, descr, show_mail, show_phone) {
	var mdl = $("#modal-edit-member");
	mdl.find("form").attr("onsubmit", "user_permission(" + id + ", 'staff', $(this).find('[name=desc]').val(), $(this).find('[name=show_mail]:checked').size(),$(this).find('[name=show_phone]:checked').size()); return false;");
	mdl.find(".link").attr("href", "/user.php?id=" + id);
	mdl.find("img").attr("src", avatar);
	mdl.find(".link:last").text(fio);
	mdl.find("input[name=desc]").val(descr);
	mdl.find("input[name=show_mail]").prop('checked',show_mail);
	mdl.find("input[name=show_phone]").prop('checked',show_phone);
	mdl.modal("show");
}

function user_permission(qid, qtype, qdesc, show_mail, show_phone) {
	api_query({
		qmethod: "POST",
		amethod: "club_user_permission",
		params: {
			id: qid,
			type: qtype,
			desc: qdesc,
			show_mail: show_mail,
			show_phone: show_phone
		},
		success: function (data) {
			alert(data[0]);
			mdl.modal("hide");
		}, 
		fail: "standart"
	});
}

</script>

<div class="container clubs-page club-admin main-blocks-area club-block">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-tabs">
				<h3 class="inner-bg">Настройки клуба<span class="pull-right text-italic"><a href="club.php?id={$club.id}">Вернуться в клуб</a></span></h3>
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li class="active"><a href="#main-admin" data-toggle="tab">Основные</a></li>
					<li><a href="#about-admin" data-toggle="tab">О клубе</a></li>
					<li><a href="#members-admin" data-toggle="tab">Участники</a></li>
					<li><a href="#competitions-admin" data-toggle="tab">Соревнования</a></li>
					<li><a href="#adv-admin" data-toggle="tab">Реклама</a></li>
					{*<li><a href="#contact-admin" data-toggle="tab">Контакты</a></li>*}
				</ul>
				
				<div id="clubTabContent" class="tab-content bg-white">
				
				<div class="tab-pane in active" id="main-admin">
				<form onsubmit="save_steps(); return false;">
					<input type="hidden" name="id" value="{$club.id}" />
					<div class="row option-row">

							<h5 class="title-hr">Главные настройки</h5>
									<div class="span6">
											<div class="row">
											<div class="controls controls-row">
												<label class="span6">Название клуба</label>
												<input type="text" class="span6" name="name" value="{$club.name}">
												
												{*<!-- new 28-03-14 -->
												<label class="span6">Вид клуба</label>
												<select class="span6" name="c_type">
													<option>Бега</option>
													<option>Военно-прикладной спорт</option>
													<option>Вольтижировка</option>
													<option>Выставки</option>
													<option>Драйвинг</option>
													<option>Конкур</option>
													<option>Паралимпийский спорт</option>
													<option>Пони-выездка</option>
													<option>Пони-конкур</option>
													<option>Пробеги</option>
													<option>Прочее</option>
													<option>Рейтинг</option>
													<option>Семинар</option>
													<option>Скачки</option>
													<option>Спорт-прочее</option>
													<option>Троеборье</option>
												</select>
												<!-- //new 28-03-14 -->
												
												<label class="span6">Адрес страницы клуба</label>
												<input type="text" class="span6" placeholder="http://odnokonniki.ru/id4535423545667" >*}
												<label class="span6">Тип клуба</label>
												<select class="span6 chosen-select" name="type[]" multiple>
													{foreach $types as $type}
														<option {if $club.type|strstr:$type}selected{/if}>{$type}</option>
													{/foreach}
											   </select>
											</div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
											<div class="span3">
												<img src="{$club.avatar}" id="club_avatar">
											</div>
											<div class="span3">
												<p>Логотип клуба</p>
												<div class="content-add-buttons row">
												<div class="fileupload" id="fileupload">
													<input type="file" name="avatar">
													<button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить фото</button>
												</div>
												</div>
												<p class="avatar-descr"><br>Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
											</div>
										</div>
									</div>
					</div>
					
					<div class="row option-row">
							<h5 class="title-hr">Контакты</h5>
									<div class="span6">
											<div class="row">
											<div class="controls controls-row">
												<label class="span6">Адрес клуба</label>
                                                <input type="hidden" id="club_country" name="club_country" value="{$club.country}">
                                                <select  class="span3 country chosen-select" name="country" onchange="change_country(this);">
                                                    <option value="">Не важно</option>
                                                    {foreach $countries as $country}
                                                        <option country_id="{$country.id}" value="{$country.country_name_ru}" {if $club.country == $country.country_name_ru}selected="selected"{/if}>{$country.country_name_ru}</option>
                                                    {/foreach}
                                                </select>
												<input type="hidden" id="club_city" name="club_city" value="{$club.city}">
                                                <select name="city" class="span3 city chosen-select" onchange="change_city(this);">
                                                    <option value="">Все города</option>
                                                    {foreach $cities as $city}
                                                        <option value="{$city.city_name_ru}" {if $club.city == $city.city_name_ru}selected="selected"{/if}>{$city.city_name_ru}</option>
                                                    {/foreach}
                                                </select>
												<input type="text" class="span6" name="address" placeholder="Адрес" onblur="update_mark();" value="{$club.address}">
											</div>
                                                <div class="controls controls-row metro" >
                                                    <label class="span6">Ближайшее метро</label>
                                                    <select  class="span3 chosen-select" name="metro">
                                                        <option>Не важно</option>
                                                        {foreach $metros as $metro}
                                                            <option {if $club.metro == $metro}selected="selected"{/if}>{$metro}</option>
                                                        {/foreach}
                                                    </select>
                                                </div>
											
											{*<!-- new 28-03-14 -->
											<div class="controls controls-row">
												<ul class="inline unstyled">
													<li><label class="radio"><input type="radio" name="area" value="metro"> Метро</label></li>
													<li><label class="radio"><input type="radio" name="area" value="district"> Округ</label></li>
												</ul>
												<select class="span6">
													<option>Метро-или-округ-1</option>
													<option>Метро-или-округ-2</option>
													<option>Метро-или-округ-3</option>
													<option>Метро-или-округ-4</option>
													<option>Метро-или-округ-5</option>
												</select>
											</div>
											<!-- //new 28-03-14 -->*}
											
											<div class="controls controls-row">
												<label class="span6">Веб-сайт клуба</label>
												<input type="text" class="span6" placeholder="введите адрес вашего сайта" name="site" value="{$club.site}" >
												<label class="span6">E-mail клуба</label>
												<input type="text" class="span6" placeholder="введите официальный email клуба" name="email" value="{$club.email}" >
												<div id="phones">
													<label class="span6">Телефоны</label>
													{if $club.c_phones}
														{foreach $club.c_phones as $phone}
															<input type="text" class="span3" placeholder="описание телефона" name="p_desc[]" value="{$phone@key}" >
															<input type="text" class="span3" placeholder="номер" name="phones[]" value="{$phone}" >	
														{/foreach}
													{/if}
												</div>
												<a href="#" onclick="add_phone();return false;">Добавить ещё телефоны</a>
											   </div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
												<label class="span6">Уточните адрес</label>
												<div id="map" style="width:460px; height:330px"></div>
												<input type="hidden" id="x" name="coords[]" value = "{$club.coords.0}" />
												<input type="hidden" id="y" name="coords[]" value = "{$club.coords.1}" />
										</div>
									</div>
					</div>

						<div class="row option-row">	
									<hr/>
									<button type="submit" class="btn btn-warning  offset3 span3">Сохранить</button>
									<a class="btn span3" href="club.php?id={$club.id}">Отмена</a>
						</div>
				</form>	
				</div> <!-- //news-club -->
				
				<div class="tab-pane" id="about-admin">
						<form onsubmit="save_steps(); return false;">
							<input type="hidden" name = "id" value = "{$club.id}" >
							<div class="row option-row">
							<h5 class="title-hr">О клубе</h5>
									<div class="span6">
										<div class="row">
											<div class="controls controls-row">
												<label class="span6">Краткое описание клуба</label>
												<textarea class="span6" rows="10" name="sdesc">{$club.sdesc}</textarea>
												<label class="span6">Полное описание клуба</label>
												<textarea class="span6" rows="10" name="desc">{$club.desc}</textarea>
											</div>
										</div>
									</div>

									<div class="span6" id="abilities">
										<div class="controls controls-row">
												<label class="span6">Дополнительные возможности клуба</label>
												{foreach $club.ability as $ability}
													<div class="ability">
														<select class="span5" name="ability[]">
															{foreach $abilities as $const_ability}
																<option {if $const_ability == $ability}selected{/if}>{$const_ability}</option>
															{/foreach}
														</select>
														<button class="btn span1" onclick="del_ability(this);return false;">-</button>
													</div>
											   {/foreach}
										</div>
										<button class="btn span1 btn-warning" onclick="add_ability(this);return false;">+</button>
									</div>
					</div>
					
						<div class="row option-row" id="new_addition">
							<h5 class="title-hr">Дополнительные сведения</h5>
							<div id="new_addition">	
 								
							</div>

					</div>
					
					
					<div class="row">
						<button class="btn span1 btn-warning" onclick="add_new_addition(); return false;">+</button>
										
									<div class="span6">
									</div>
					</div> <!-- //add-opt-row -->
					
					
					<div class="row option-row">	
									<hr/>
									<button type="submit" class="btn btn-warning  offset3 span3">Сохранить</button>
                        <a class="btn span3" href="club.php?id={$club.id}">Отмена</a>
					</div>
					</form>
				</div> <!-- //about-club -->
				
				<div class="tab-pane" id="members-admin"> <!-- участники -->
					
					
<div id="modal-edit-member" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true"><!-- modal-edit-member -->
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Изменить данные</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal"  method="post" action="#">
						<div class="row">	
							<div class="user-info-photo span1"><a href="#" class="link"><img src="i/sample-ava-1.jpg" class="friend-avatar"></a></div>
							<div class="user-info-about span2"><p class="user-name"><a href="user-sample.php" class="link">Елена Урановая</a></p></div>
						</div>
						
						<hr/>
						
						<div class="row">	
														
							<div class="controls controls-row">
								<label class="span6">Должность руководителя</label>
								<input type="text" class="span6" name="desc">
								<label class="span6">Показывать телефон <input type="checkbox" name="show_phone" value="1"></label>
								<label class="span6">Показывать E-mail <input type="checkbox" name="show_mail"  value="1"></label>
							</div>
						</div>
							
						<hr/>
						
						<div class="row">	
							<div class="controls controls-row">
								<center>
								<button type="submit" class="btn btn-warning span3">Сохранить</button>
								<button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
			</form>
	</div>
</div> <!-- //modal-edit-member -->
					
					
					
					 <div class="row option-row">	
						 <form class="form-in-messages">
							<div class="controls controls-row">
									<input type="text" class="span8 search-query" placeholder="Начните вводить имя друга">
									<a href="friends-add.php" class="btn btn-warning span2">Искать</a>
									<a href="friends-add.php" class="btn span2">Добавить</a>
							</div>
						</form>
						
						
			<ul id="club-members" class="nav nav-pills">
              <li class="active"><a href="#all-members" data-toggle="tab">Все участники</a></li>
              {*<li><a href="#admin-members" data-toggle="tab">Руководители</a></li>
              <li><a href="#moders-members" data-toggle="tab">Модераторы</a></li>
              <li><a href="#blacklist-members" data-toggle="tab">Чёрный список</a></li>*}
            </ul>
			<div id="club-membersContent" class="tab-content">
              <div class="tab-pane in active" id="all-members">  <!-- все участники -->
				  <div class="friends-list span12">
				<div class="row">
				{if $members}
					{foreach $members as $member}
						<div class="my-friend span12">
							<div class="row">
								<div class="user-info-photo span1">
									<a href="/user.php?id={$member.id}"><img src="{$member.avatar}" class="friend-avatar"></a>
								</div>
								<div class="user-info-about span2"><p class="user-name"><a href="/user.php?id={$member.id}">{$member.fio}</a></p></div>
								<div class="user-info-about span3"><p class="city">{$member.country}</p></div>
								<div class="user-info-about span3"><p class="status">
									{if $member.is_moderator}
										<b>Модератор</b>
									{elseif $member.is_club_staff}
										<b>{$member.club_staff_descr}</b>
									{else}
										Участник клуба
									{/if}
								</p></div>
								<div class="span3 user-info-actions">
									<ul>
										<li><a href="/user.php?id={$member.id}">Написать сообщение</a></li>
										{if $member.is_moderator}
											<li><a href="#" onclick="make_staff_form({$member.id}, '{$member.fio}', '{$member.avatar}', '', {$member.show_mail}, {$member.show_phone}, this); return false;">В руководители</a></li>
										{elseif $member.is_club_staff}
											<li><a href="#" onclick="make_staff_form({$member.id}, '{$member.fio}', '{$member.avatar}', '{$member.club_staff_descr}', {$member.show_mail}, {$member.show_phone}, this); return false;">Изменить данные</a></li>
										{else}
											<li><a href="#" onclick="make_staff_form({$member.id}, '{$member.fio}', '{$member.avatar}', '', {$member.show_mail}, {$member.show_phone}, this); return false;">В руководители</a> <span class="muted">|</span> <a href="#" onclick="user_permission({$member.id}, 'moderator', '', $member.show_mail, $member.show_phone, this); return false;">в модераторы</a></li>
										{/if}
										<li><a href="#">Удалить из сообщества</a></li>
									</ul>
								</div>
							</div>
						</div>
					{/foreach}	
				{else}
					<p style="text-align: center;">В этом клубе нет участников. Подождите их вступления, прежде чем управлять их ролями.</p>
				{/if}
				</div>
				</div>
              </div>  <!-- // все участники -->
			  
              <div class="tab-pane" id="admin-members"> <!-- руководители -->
                 <div class="friends-list span12">
				<div class="row">
					<div class="my-friend span12">
						<div class="row">
							<div class="user-info-photo span1">
								<a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="friend-avatar"></a>
							</div>
							<div class="user-info-about span2"><p class="user-name"><a href="user-sample.php">Елена Урановая</a></p></div>
							<div class="user-info-about span3"><p class="city">Россия, г. Москва</p></div>
							<div class="user-info-about span3"><p class="status member-admin">Администратор клуба</p></div>
							<div class="span3 user-info-actions">
								<ul>
									<li><a href="chat.php">Написать сообщение</a></li>
									<li><a href="#">Изменить данные</a></li>
									<li><a href="#">Удалить из сообщества</a></li>
								</ul>
							</div>
						</div>
					</div>
					
					<div class="my-friend span12">
						<div class="row">
							<div class="user-info-photo span1">
								<a href="user-sample.php"><img src="i/sample-ava-2.jpg" class="friend-avatar"></a>
							</div>
							<div class="user-info-about span2"><p class="user-name"><a href="user-sample.php">Елена Урановая</a></p></div>
							<div class="user-info-about span3"><p class="city">Россия, г. Москва</p></div>
							<div class="user-info-about span3"><p class="status member-admin">Главный бухгалтер</p></div>
							<div class="span3 user-info-actions">
								<ul>
									<li><a href="chat.php">Написать сообщение</a></li>
									<li><a href="#">Изменить данные</a></li>
									<li><a href="#">Удалить из сообщества</a></li>
								</ul>
							</div>
						</div>
					</div>
					
				</div>
				</div>				
              </div> <!-- // руководители -->
			  
			   <div class="tab-pane" id="moders-members"> <!-- модераторы -->
                 <div class="friends-list span12">
				<div class="row">
					<div class="my-friend span12">
						<div class="row">
							<div class="user-info-photo span1">
								<a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="friend-avatar"></a>
							</div>
							<div class="user-info-about span2"><p class="user-name"><a href="user-sample.php">Елена Урановая</a></p></div>
							<div class="user-info-about span3"><p class="city">Россия, г. Москва</p></div>
							<div class="user-info-about span3"><p class="status member-admin">Администратор клуба</p></div>
							<div class="span3 user-info-actions">
								<ul>
									<li><a href="chat.php">Написать сообщение</a></li>
									<li><a href="#">Изменить данные</a></li>
									<li><a href="#">Удалить из сообщества</a></li>
								</ul>
							</div>
						</div>
					</div>
					
					
				</div>
				</div>				
              </div> <!-- // модераторы -->
			  
			  <div class="tab-pane" id="blacklist-members">  <!-- чёрный список -->
                <div class="friends-list span12">
				<div class="row">

					
					<div class="my-friend span12">
						<div class="row">
							<div class="user-info-photo span1">
								<a href="user-sample.php"><img src="i/sample-ava-5.jpg" class="friend-avatar"></a>
							</div>
							<div class="user-info-about span2"><p class="user-name"><a href="user-sample.php">Неудачник Брайан</a></p></div>
							<div class="user-info-about span3"><p class="city">Россия, г. Москва</p></div>
							<div class="user-info-about span3"><p class="status muted">Забанен</p></div>
							<div class="span3 user-info-actions">
								<ul>
									<li><a href="chat.php">Написать сообщение</a></li>
									<li><a href="#">Удалить из чёрного списка</a></li>
								</ul>
							</div>
						</div>
					</div>
	
				</div>
				</div>
              </div> <!-- //чёрный список -->
			  
            </div>

			</div>
					
					<div class="row option-row">	
						<hr/>
						<button type="submit" class="btn btn-warning  offset3 span3">Сохранить</button>
                        <a class="btn span3" href="club.php?id={$club.id}">Отмена</a>
					</div>
				</div> <!-- //members-club -->
				
				<div class="tab-pane" id="competitions-admin">
					<div class="row">
						<div class="span12">
							<div class="row option-row">
								<a href="/competition-add.php?id={$club.id}" class="btn btn-warning">Добавить соревнование</a>
							</div>

							{include "modules/competition-page.tpl" competitions = $club.competitions}

						</div>
							}
					</div>
				</div> <!-- //competitions-club -->
<script>
function add_adv() {
	adv = "<li class='adv-card'> \
				<div class='img-adv'><img src='http://placehold.it/200x200'></div> \
				<label>Ссылка</label> \
				<input type='hidden' name='adv_img[]' value='http://placehold.it/200x200'> \
				<input type='text' name='adv_link[]' value='www.odnokonniki.ru'> \
				<div class='fileupload adv_upload'> \
					<input type='file' name='adv'> \
					<button type='submit' class='btn btn-warning'>Заменить баннер</button> \
				</div> \
				<button type='submit' class='btn' onclick='del_adv(this);return false;'>Удалить</button> \
			</li>";
	$(adv).prependTo("#adv-list").fileupload({
		url: '/api/api.php?m=gallery_club_upload_adv&id={$club.id}',
		dataType: 'json',
		done: function (e, data) {
			resp = data.result;
			if (resp.type == "success") {
				$(this).find("img").attr("src", resp.response.adv);
				$(this).find("[type=hidden]").val(resp.response.adv);
			} else {
				alert(resp.response[0]);
			}
		}
	});
}


function del_adv(element) {
	$(element).closest(".adv-card").remove();
}

function adv_update(form) {
	api_query({
		qmethod: "POST",
		amethod: "club_adv",
		params: $(form).serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

</script>				
				<div class="tab-pane" id="adv-admin">
				<form onsubmit="adv_update(this);return false;">
					<input type="hidden" name="id" value = "{$club.id}" />	
					<div class="row option-row">	
						<ul class="adv-list" id="adv-list">
							{if $club.adv}
								{foreach $club.adv as $adv}
									<li class="adv-card">
										<div class="img-adv"><img src="{$adv.img}"></div>
										<label>Ссылка</label>
										<input type="hidden" name="adv_img[]" value="{$adv.img}">
										<input type="text" name="adv_link[]" value="{$adv.url}">
										<div class="fileupload adv_upload"> 
											<input type="file" name="adv"> 
											<button type="submit" class="btn btn-warning">Заменить баннер</button> 
										</div>
										<button type="submit" class="btn" onclick="del_adv(this);return false;">Удалить</button>
									</li>
								{/foreach}
							{/if}
								
							<li class="add-new-adv">
								<a  href="#" onclick="add_adv();return false;"><img src="images/btn-add-new-adv.png" /></a>
							</li>

						</ul>
						<div class="clearfix"></div>
						<center><small class="tac">Вы можете загрузить изображение в формате JPG, GIF или PNG.<br/>Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</small></center>
					</div>
					
					<div class="row option-row">	
						<hr/>
						<button type="submit" class="btn btn-warning  offset3 span3">Сохранить</button>
                        <a class="btn span3" href="club.php?id={$club.id}">Отмена</a>
					</div>
				</form>
				</div> <!-- //adv-club -->
				
				{*<div class="tab-pane" id="contact-admin">
					<div class="row">
							<div class="span12">
									<p>еальность. Катарсис, как следует из вышесказанного, решительно подчеркивает смысл жизни, учитывая опасность, которую представляли собой писания Дюринга для не окрепшего еще немецкого рабочего движения. Отношение к современности понимает под собой конфликт, однако Зигварт считал критерием истинности необходимость и общезначимость, для которых нет никакой опоры в объективном мире. Искусство заполняет бабувизм, при этом буквы А, В, I, О символизируют соответственно общеутвердительное, общеотрицательное, частноутвердительное и частноотрицательное суждения.</p>
							</div>
						</div>
				</div> <!-- //contact-club -->*}
				
			
				</div>
			</div>
			</div>

		</div> <!-- /row -->
</div>
<div id="modal-change-avatar" class="modal hide modal700" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Изменить аватар</h3>
    </div>
    <div class="modal-body step3" style="display: none;">
        <form class="form-horizontal" action="#" onsubmit="crop(this);return false;">
            <p>Выбранная область будет показываться на Вашей странице.</p>
            <center>
                <img src="http://placehold.it/1x1" id="future-avatar" />
                <div class="change-avatar-buttons">
                    <input type="hidden" name="x1" value="10" />
                    <input type="hidden" name="y1" value="10" />
                    <input type="hidden" name="x2" value="210" />
                    <input type="hidden" name="y2" value="210" />
                    <input type="hidden" name="avatar" value="" />
                    <input type="hidden" name="id" value="{$club.id}" />
                    <button type="submit" class="btn btn-warning">Сохранить</button>
                    <button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
                </div>
            </center>
        </form>
    </div>
</div>

{include "modules/footer.tpl"}