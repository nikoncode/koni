{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-be-member.tpl"}
<script type="text/javascript" src="js/likes.js"></script>
<script type="text/javascript" src="js/comments.js"></script>
<script type="text/javascript" src="js/gallery.js"></script>
<script type="text/javascript" src="js/news.js"></script>
<script type="text/javascript" src="js/autoload.js"></script>
<script type="text/javascript">
	$(function(){



        $('.fans-member-list').on('click','.fan_btn',function(){
            var $this = $(this).closest('td');
            $this.find('input').prop('checked',true);
            $(this).closest('li').addClass('member-chosen');
            $(this).addClass('btn').addClass('btn-warning').addClass('btn-small').addClass('unfan_btn');
            $(this).removeClass('fan_btn');
        });
        $('.fans-member-list').on('click','.unfan_btn',function(){
            var $this = $(this).closest('td');
            $this.find('input').prop('checked',false);
            $(this).closest('li').removeClass('member-chosen');
            $(this).removeClass('btn').removeClass('btn-warning').removeClass('btn-small').removeClass('unfan_btn');
            $(this).addClass('fan_btn');
        });
        $('.get_results').click(function(){
                $('li a.compt-results').click();
            }
        );
		$('.get_startlist').click(function(){
                $('li a.compt-startlist').click();
            }
        )
    });
function membership(cid, role, val, element) {
	api_query({
		amethod: "comp_member",
		qmethod: "POST",
		params: {
			id: cid,
			role : role,
			val : val
		},
		success: function (data) {
			var selector = "#" + role + "s";
			console.log($(selector));
			var el = $(element);
			if (data[0] == "1") {
				el.removeClass("btn-warning").addClass("btn-success");

				$(selector).append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
                if(role == 'viewer') el.html('Приду!');
                if(role == 'photographer') el.html('Фотографирую!');
			} else {
				el.removeClass("btn-success").addClass("btn-warning");
				$(selector + " .me").remove();
                if(role == 'viewer') el.html('Приду смотреть!');
                if(role == 'photographer') el.html('Я фотограф!');
			}
            if(role == 'fan'){
                el.html("Я болельщик!");
                el.attr("onclick", "i_fan(" + cid + "); return false;");
            }else{
                el.attr("onclick", "membership(" + cid + ", '" + role + "', '" + (+!!!data[0]) + "', this); return false;");
            }


		},
		fail: "standart"
	})
}

function i_fan(cid){
    var mdl = $("#i-am-fan");
    mdl.find("[name=cid]").val(cid);
    mdl.modal("show");
}

/*function rider(rid, act, element) {
	api_query({
		amethod: "comp_rider",
		qmethod: "POST",
		params: {
			id: rid,
			act : act
		},
		success: function (data) {
			var el = $("[data-rider-rid=" + rid + "]");
			if (data[0] != "0") {
				el.removeClass("btn-warning").addClass("btn-success");
                el.html('Учавствую <i class="icon-play icon-white"></i>');
			} else {
				el.removeClass("btn-success").addClass("btn-warning");
                el.html('Учавствовать <i class="icon-play icon-white"></i>');
			}
			el.attr("onclick", "rider(" + rid + ", '" + (+!!!data[0]) + "', this); return false;");
			if ($("#routes .btn-success").length == 0) {
				$("#riders li.me").remove();
			} else if ($("#riders li.me").length == 0) {
				$("#riders").append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
			}
		},
		fail: "standart"
	})*/

    function query_fan(form){
        var cid = $(form).find('[name="cid"]').val();
        api_query({
            amethod: "comp_fan_member",
            qmethod: "POST",
            params: $(form).serialize(),
            success: function (data) {
                var selector = "#fans";
                console.log($(selector));
                var el = $('.i_fan_btn');
                el.removeClass("btn-warning").addClass("btn-success");
                $(selector).append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
                el.attr("onclick", "membership(" + cid + ", 'fan', '0', this); return false;");
                el.html('Болею!');
                $("#i-am-fan").modal("hide");
            },
            fail: "standart"
        })
        return false;
    }
function query_to_ride(rid, hid, act, dennik, razvyazki,rhid, callback) {
	api_query({
		amethod: "comp_rider",
		qmethod: "POST",
		params: {
			id: rid,
			rid: rhid,
			hid: hid,
            dennik: dennik,
			razvyazki: razvyazki,
			act : act
		},
		success: function (data) {
			var el = $("[data-rider-rid=" + rid + "]");
			if (data[0] != "0") {
				el.removeClass("btn-warning").addClass("btn-success");
                el.html('Участвую <i class="icon-play icon-white"></i>');
			} else {
				el.removeClass("btn-success").addClass("btn-warning");
                el.html('Участвовать <i class="icon-play icon-white"></i>');
			}
			el.attr("onclick", "rider(" + rid + ", '" + (+!!!data[0]) + "', this); return false;");
			if ($("#routes .btn-success").length == 0) {
				$("#riders li.me").remove();
			} else if ($("#riders li.me").length == 0) {
				$("#riders").append("<li class='me'><a href='/user.php?id={$user.id}'><img src='{$user.avatar}'><p>{$user.fio}</p></a></li>");
			}
			$("#be-member").modal("hide");
		},
		fail: "standart"
	})
}

function rider(rid, act) {
	if (act == 1) {
		part_prepare(rid);

	} else {
		query_to_ride(rid, 1, 0, 0,0);
	}
}


</script>
<style>
    .disq1 td {
        background-color: red !important;
    }
    .disq2 td {
        background-color: #0044cc !important;
    }
</style>
{include "modules/modal-add-edit-album-club.tpl"}
{include "modules/modal-add-edit-album-video.tpl"}
{include "modules/modal-add-video.tpl"}
{include "modules/modal-gallery-lightbox.tpl"}
{include "modules/modal-gallery-change-album.tpl"}
<div class="container clubs-page main-blocks-area club-block img.club-avatar">
		<div class="row">
		
			
			{include "modules/club-header.tpl"}
			
			<div class="span12 brackets-horizontal"></div>
			
			<div class="span12 lthr-bgborder block club-tabs">
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li><a href="/club.php?id={$club.id}#news-club">Новости/отзывы</a></li>
					<li><a href="/club.php?id={$club.id}#about-club">О клубе</a></li>
					<li class="active"><a href="/club.php?id={$club.id}#competitions-club">Соревнования</a></li>
					<li style="display: none"><a href="/club.php?id={$club.id}#rating-club">Рейтинги (156,16)</a></li>
					<li><a href="/club.php?id={$club.id}#gallery-club">Галерея</a></li>
					<li><a href="/club.php?id={$club.id}#contact-club">Контакты</a></li>
				</ul>
				
				<div id="clubTabContent" class="tab-content bg-white">
				
				<div class="tab-pane in active current-compt">
					<div class="row"><div class="span12 back-link"><a href="/club.php?id={$comp.o_cid}">&larr; <span>Вернуться к клубу</span></a></div></div>
					<div class="row">
						<div class="span1"><img src="images/icons/{$comp.country}.jpg" class="img-flag"/></div>
						<div class="span11 compt-title"><h4>{$comp.name}</h4></div>
					</div>
					<div class="row">
						<div class="span6">
							<dl class="dl-horizontal">
								<dt>Дата:</dt>
								<dd>
									<p>Начало: {$comp.bdate}</p>
									<p>Окончание: {$comp.edate}</p>
								</dd>
								<dt>Адрес:</dt>
								<dd>{$comp.address}</dd>
								<dt>Вид:</dt>
								<dd>{$comp.type}</dd>
								<dt>Страна:</dt>
								<dd>{$comp.country}</dd>
								<dt>Город:</dt>
								<dd>{$comp.city}</dd>
								<dt>Денников:</dt>
								<dd>{$comp.dennik} ({$comp.dennik_res} свободно)</dd>
								<dt>Развязок:</dt>
								<dd>{$comp.razvyazki} ({$comp.razvyazki_res} свободно)</dd>
							</dl>
						</div>
						<div class="span6 compt-descr">
							<div class="row">
								<div class="span2">
									<a href="#" class="span2 btn btn-small btn-{if $comp.is_viewer}success{else}warning{/if}" onclick="membership({$comp.id}, 'viewer', '{!$comp.is_viewer}', this); return false;">
                                        {if $comp.is_viewer}Приду!{else}Приду смотреть{/if} <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span2">
									<a href="#" class="span2 btn btn-small btn-{if $comp.is_photographer}success{else}warning{/if}" onclick="membership({$comp.id}, 'photographer', '{!$comp.is_photographer}', this); return false;">
                                        {if $comp.is_photographer}Фотографирую!{else}Я фотограф{/if} <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span2">
									<a href="#" class="i_fan_btn span2 btn btn-small btn-{if $comp.is_fan}success{else}warning{/if}" onclick="{if !$comp.is_fan}i_fan({$comp.id});{else}membership({$comp.id}, 'fan', '{!$comp.is_fan}', this);{/if} return false;">
                                        {if $comp.is_fan}Болею!{else}Я болельщик{/if} <i class="icon-play icon-white"></i>
									</a>
								</div>
								<div class="span6 descr-title"><p>{$comp.desc}</p></div>
								<div class="span6">
									<ul class="unstyled span6 comp-added-files">
										{foreach $comp.files as $file}
											<li class="{$file.ext}-file"><a href="/uploads/{$file.path}.{$file.ext}" target="_blank">{$file.file}</a></li>
										{/foreach}
									</ul>
									<div class="span3">Размер боевого поля</div>
									<div class="span3">{if $comp.combat_field == ''}Нет данных{else}{$comp.combat_field}{/if}</div>
									<div class="span3">Размер тренировочного поля</div>
									<div class="span3">{if $comp.training_field == ''}Нет данных{else}{$comp.training_field}{/if}</div>
								</div>
								</div>
							</div>
						</div>
						
	<div class="row">
	<div class="span12">
	<table class="table table-striped competitions-table curr-compt-levels" id="routes">
						<tr>
							<th class="span2">Дата</th>
							<th class="span2">Маршрут</th>
							<th class="span2">Высота</th>
							<th class="span2">Зачёт для</th>
							<th class="span2">Статус</th>
							<th class="span2"></th>
						</tr>
						{if $comp.routes}
							{foreach $comp.routes as $route}
							 <tr>
								<td colspan="6" class="td-complex">
										<div class="row">
											<div class="curr-compt-date span2">{$route.bdate}</div>
											<div class="curr-compt-path span2"><a href="#startlist{$route.id}" class="get_startlist">{$route.name}</a></div>
											<div class="curr-compt-height span2">{$route.height}</div>
											<div class="curr-compt-for span2">{$route.exam}</div>
											<div class="curr-compt-status span2">{$route.status}</div>
											<div class="curr-compt-go">
                                                {if $route.complete}
                                                    <a href="#result{$route.id}" class="btn btn-warning get_results">
                                                        К результатам
                                                    </a>
                                                {else}
                                                    <a href="#" class="btn btn-{if $route.is_rider}success{else}warning{/if}"onclick=" {if $sportsman == 0}alert('Только спортсмены могут участвовать в соревновании. Если вы спортсмен, то поставьте галочку в настройках личной страницы');{else}rider({$route.id}, '{!$route.is_rider}', this);{/if} return false;" data-rider-rid="{$route.id}">
                                                        {if $route.is_rider}Участвую{else}Участвовать{/if} <i class="icon-play icon-white"></i>
                                                    </a>
                                                {/if}
											</div>
											<div class="row curr-compt-more">
												<ul class="unstyled span12">
													{foreach $route.options as $option}
														<li><span>{$option@key}</span>  {$option}</li>
													{/foreach}
												</ul>
											</div>
										</div>
								</td>
							</tr> 
							{/foreach}
						{else}
							<tr>
								<td colspan="6" style="text-align: center;">Нет маршрутов.</td>
							</tr>
						{/if}
					</table>
		</div>
	</div>
						
	<div class="row compt-descr-tabs">
	<div class="span12">
            <ul class="nav nav-tabs">
              <li class="active"><a href="#compt-members" data-toggle="tab">Участники</a></li>
              <li><a href="#start-list" class="compt-startlist" data-toggle="tab">Стартовый лист</a></li>
              <li><a href="#compt-results" class="compt-results" data-toggle="tab">Результаты</a></li>
              <li><a href="#compt-gallery" data-toggle="tab">Галерея</a></li>
              <li><a href="#compt-disqus" data-toggle="tab">Обсуждения</a></li>
            </ul>
            
			<div class="tab-content">
              
			  <div class="tab-pane in active" id="compt-members">
					<div class="span12">
						<h3 class="inner-bg">Всадники{*<span class="pull-right">{$comp.riders|@count}</span>*}</h3>
						<ul class="clubs-members" id="riders">
							{foreach $comp.riders as $rider}
								<li {if $rider.id == $user.id}class="me"{/if}><a href="/user.php?id={$rider.id}"><img src="{$rider.avatar}"><p>{$rider.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Зрители{*<span class="pull-right">{$comp.viewers|@count}</span>*}</h3>
						<ul class="clubs-members" id="viewers">
							{foreach $comp.viewers as $viewer}
								<li {if $viewer.id == $user.id}class="me"{/if}><a href="/user.php?id={$viewer.id}"><img src="{$viewer.avatar}"><p>{$viewer.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Болельщики{*<span class="pull-right">{$comp.fans|@count}</span>*}</h3>
						<ul class="clubs-members" id="fans">
							{foreach $comp.fans as $fan}
								<li {if $fan.id == $user.id}class="me"{/if}><a href="/user.php?id={$fan.id}"><img src="{$fan.avatar}"><p>{$fan.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Фотографы</h3>
						<ul class="clubs-members" id="photographers">
							{foreach $comp.photographers as $photographer}
								<li {if $photographer.id == $user.id}class="me"{/if}><a href="/user.php?id={$photographer.id}"><img src="{$photographer.avatar}"><p>{$photographer.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
              </div> <!-- compt-members -->
              
			  <div class="tab-pane" id="start-list">
				<table class="table table-striped competitions-table compt-results admin-compts">
						<tbody><tr>
                            <th>№</th>
                            <th>Всадник</th>
                            <th>Разряд</th>
                            <th>Лошадь</th>
                            <th style="display: none">Владелец лошади</th>
                            <th>Клуб</th>
                        </tr>
						{if $comp.routes}
							{if $comp.publish}
								<tr><td colspan="6"><a href="/api/generate_startlist.php?id={$comp.id}" target="_blank" class="btn btn-warning">Скачать стартовый лист</a></td></tr>
								{foreach $comp.routes as $route}
									<tr id="startlist{$route.id}"><td colspan="6" class="table-caption">{$route.name}</td></tr>
									{foreach $comp.heights.{$route.id} as $height}
										<tr><td colspan="6" class="height-caption">{$height.height},{$height.exam}</td></tr>
										{if $comp.startlist.{$height.id}}
											{foreach $comp.startlist.{$height.id} as $res}
												<tr>
													<td class="">
														{$res.ordering}
													</td>
													<td>{$res.fname}<br/>{$res.lname}</td>
													<td>-</td>
													<td>{$res.horse}</td>
													<td style="display: none">{if $res.owner}{$res.owner}{else}{$res.ownerName}{/if}</td>
													<td>{$res.club}</td>
												</tr>
											{/foreach}
										{else}
											<tr>
												<td colspan="6" style="text-align: center;">Администратор мероприятия пока не установил турнирную таблицу. Попробуйте позже.</td>
											</tr>
										{/if}
									{/foreach}
								{/foreach}
							{else}
								<tr>
									<td colspan="6" style="text-align: center;">Стартовый лист еще не опубликован.</td>
								</tr>
							{/if}

						{else}
							<tr>
								<td colspan="6" style="text-align: center;">Нет маршрутов.</td>
							</tr>
						{/if}
					</tbody>
					</table>
              </div><!-- compt-startlist -->
                <div class="tab-pane" id="compt-results">

                    {if $comp.routes}
						{if $comp.publish_results}
							{foreach $comp.routes as $route}
								<table class="table table-striped competitions-table compt-results admin-compts" id="result{$route.id}">
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
										</tr>
									{/if}
									<tr><td colspan="11" class="table-caption">{$route.name}</td></tr>
							{foreach $comp.heights.{$route.id} as $height}
								<tr><td colspan="11" class="height-caption">{$height.height},{$height.exam}</td></tr>
										{foreach $comp.results.{$height.id} as $res}
											<tr {if $res.disq}class="disq{$res.disq}"{/if} data-disq={$res.disq}>
												<td class="">
													{if !$res.disq}{$res.rank}{/if}
												</td>
												<td><a href="/user.php?id={$res.user_id}">{$res.fname}<br/>{$res.lname}</a></td>
												<td>{$res.razryad}</td>
												<td><a href="/horse.php?id={$res.horse}">{$res.horseName}</a> - {$res.horseInfo}</td>
												<td>{if $res.club == ''}Частный владелец{else}<a href="/club.php?id={$res.club_id}">{$res.club}</a>{/if}</td>
												<td class="standarts" {if $route.sub_type == '269'}style="display: none"{/if}>{$res.shtraf_route}</td>
												<td class="standarts" {if $route.sub_type != '269'}style="display: none"{/if}>{$res.ball}</td>
												<td class="standarts">{$res.time}</td>
												<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}>{$res.shtraf}</td>
												<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == '269'}style="display: none"{/if}>{$res.rerun}</td>
												<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == 'с перепрыжкой' || $route.sub_type == '269'}style="display: none"{/if}>{$res.norma}</td>
												<td class="standarts">{$res.money} {$res.currency}</td>
											</tr>
										{/foreach}
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
									<td colspan="11" style="text-align: center;">Результаты еще не опубликованы</td>
								</tr>
								</tbody>
							</table>
						{/if}
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
              </div><!-- compt-results -->
              <div class="tab-pane" id="compt-gallery">
                  {if $gallery_id}
                      <div class="row">
                          <div class="albums">
                              <h3 class="inner-bg">{$gallery.name}<span class="pull-right"><a href="/competition.php?id={$comp.id}#compt-gallery">назад в галерею</a></span></h3>
                              <div class="row">
                                  <div class="photos">
                                      <p class="album-descr">{$gallery.desc}</p>
                                      {if $club.o_uid == $user.id}
                                          {if $gallery.type_album == 0}<a href="/gallery-upload.php?id={$gallery_id}&comp_id={$comp.id}" class="pull-right btn btn-warning">Добавить фото</a>{/if}
                                          {if $gallery.type_album == 1}<a href="#modal-add-video" role="button" data-toggle="modal" class="pull-right btn btn-warning">Добавить видео</a>{/if}
                                      {/if}
                                      <div class="photos" data-gallery-list="{$photos_ids_list}">
                                          {if $gallery.type_album == 0}
                                              {if $photos}
                                                  <ul class="photo-wall">
                                                      {foreach $photos as $photo}
                                                          <li><a href="#" data-gallery-pid="{$photo.id}"><img src="{$photo.preview}" /></a></li>
                                                      {/foreach}
                                                  </ul>
                                              {else}
                                                  <p style="text-align: center;">Нет фотографий</p>
                                              {/if}
                                          {/if}
                                          {if $gallery.type_album == 1}
                                              {if $videos}
                                                  <ul class="photo-wall">
                                                      {foreach $videos as $photo}
                                                          <li><a href="#" data-video-pid="{$photo.id}"><img src="http://img.youtube.com/vi/{$photo.video}/1.jpg" /></a></li>
                                                      {/foreach}
                                                  </ul>
                                              {else}
                                                  <p style="text-align: center;">Нет видео</p>
                                              {/if}
                                          {/if}
                                      </div>
                                  </div>
                              </div>

                          </div>
                      </div>
                  {else}
                      <div class="row">

                          <ul id="gallery-tabs" class="nav nav-tabs new-tabs tabs2">
                              <li class="active"><a href="#gal-foto" data-toggle="tab">Фото</a></li>
                              <li><a href="#gal-video" data-toggle="tab">Видео</a></li>
                          </ul>
                          <div id="GalTabContent" class="tab-content">
                              <div class="tab-pane in active" id="gal-foto"> <!-- tab-photo-->

                                  <div class="albums">
                                      <div class="span12">
                                          {if $club.o_uid == $user.id}
                                              <a href="#modal-add-edit-album" role="button" data-toggle="modal" class="pull-right btn btn-default btn-create-album" >Создать альбом</a>

                                          {/if}
                                          <h5 class="title-hr">Альбомы</h5>
                                      </div>

                                      <div class="span12">
                                          {if $comp.albums}
                                              <ul class="album-wall">
                                                  {foreach $comp.albums as $album}
                                                      <li>
                                                          <a href="/competition.php?id={$comp.id}&album={$album.id}#compt-gallery">
                                                              {if !$album.cover}
                                                                  <img src="http://placehold.it/190x130">
                                                              {else}
                                                                  <img src="{$album.cover}">
                                                              {/if}</a>
                                                          {if $club.o_uid == $user.id}<a href="javascript:void(0)" onclick="view_update_album_form({$album.id},{$club.id})" class="icon-edit"></a>{/if}
                                                          <a href="/competition.php?id={$comp.id}&album={$album.id}#compt-gallery">
                                                              <p>{$album.name}</p>
                                                          </a>

                                                          <p>{$album.desc}</p>
                                                      </li>
                                                  {/foreach}
                                              </ul>
                                          {else}
                                              <p style="text-align: center;">Нет альбомов</p>
                                          {/if}
                                      </div>
                                      {if $users_photos}
                                          <div class="span12">
                                              <h5 class="title-hr">Фотографии пользователей</h5>
                                              <div class="row users-albums">
                                                  <ul class="inline unstyled">
                                                      {foreach $users_photos as $photo}
                                                          <li><a href="gallery-album.php?id={$photo.id}"><img src="{$photo.avatar}" class="avatar"> {$photo.fio}</a> ({$photo.count_photo} фото)</li>
                                                      {/foreach}
                                                  </ul>

                                              </div>
                                          </div>
                                      {/if}

                                  </div>

                              </div> <!-- /tab-photo-->

                              <div class="tab-pane" id="gal-video"> <!-- tab-video-->

                                  <div class="albums">
                                      <div class="span12">
                                          {if $club.o_uid == $user.id}
                                              <a href="#modal-add-edit-album-video" role="button" data-toggle="modal" class="pull-right btn btn-default btn-create-album">Создать альбом</a>
                                          {/if}
                                          <h5 class="title-hr">Альбомы</h5>
                                      </div>

                                      <div class="span12">
                                          {if $comp.albums_video}
                                              <ul class="album-wall">
                                                  {foreach $comp.albums_video as $album}
                                                      <li>
                                                          <a href="/competition.php?id={$comp.id}&album={$album.id}#compt-gallery">
                                                              {if !$album.cover}
                                                                  <img src="http://placehold.it/190x130">
                                                              {else}
                                                                  <img src="http://img.youtube.com/vi/{$album.cover}/1.jpg">
                                                              {/if}</a>
                                                          {if $club.o_uid == $user.id}<a href="javascript:void(0)" onclick="view_update_album_form({$album.id},{$club.id})" class="icon-edit"></a>{/if}
                                                          <a href="/competition.php?id={$comp.id}&album={$album.id}#compt-gallery">
                                                              <p>{$album.name}</p>
                                                          </a>
                                                          <p>{$album.desc}</p>
                                                      </li>
                                                  {/foreach}
                                              </ul>
                                          {else}
                                              <p style="text-align: center;">Нет альбомов</p>
                                          {/if}
                                      </div>

                                      <div class="span12">
                                          <h5 class="title-hr">Видео пользователей</h5>
                                          <div class="row users-albums">
                                              <ul class="inline unstyled">
                                                  <li><a href="user-sample.php"><img src="i/sample-ava-1.jpg" class="avatar"> Александр Гетманский</a> (123 видео)</li>
                                                  <li><a href="user-sample.php"><img src="i/sample-ava-2.jpg" class="avatar"> Елена Урановая</a> (123 видео)</li>
                                                  <li><a href="user-sample.php"><img src="i/sample-ava-3.jpg" class="avatar"> Наталья Валюженич</a> (123 видео)</li>
                                                  <li><a href="user-sample.php"><img src="i/sample-ava-4.jpg" class="avatar"> Александр Гетманский</a> (123 видео)</li>
                                                  <li><a href="user-sample.php"><img src="i/sample-ava-5.jpg" class="avatar"> Елена Урановая</a> (123 видео)</li>
                                              </ul>

                                          </div>
                                      </div>

                                  </div>

                              </div> <!-- /tab-video-->
                          </div>

                      </div>
                  {/if}
              </div> <!-- //gallery-club -->
			
			<div class="tab-pane" id="compt-disqus">
					<ul class="my-news-wall">
                        {$comments_bl}
             </div><!-- compt-disqus -->
			 
            </div>
          </div>
						</div>
					</div>
				</div> <!-- //clubTabContent -->
			</div>
			</div><!-- // block club-tabs -->

	</div>
</div>



<div id="i-am-fan" class="modal hide modal800" tabindex="-1" role="dialog" aria-hidden="false">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3>За кого будете болеть в этом соревновании?</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" method="post" onsubmit="query_fan(this); return false;">
						<div class="row">	
							<div class="fans-member-list">	
								<ul class="unstyled">
                                    {foreach $comp.riders as $rider}
									<li>
										<table class="member">
											<tr valign="top">
												<td class="m-photo"><a href="user.php?id={$rider.id}"><img src="{$rider.avatar}"></a></td>
												<td class="m-name"><div class="name"><a href="user.php?id={$rider.id}">{$rider.fio}</a></div><div class="m-pos">Всадник №5</div></td>
												<td class="m-address">г. {$rider.city}, клуб «{$rider.club}»</td>
												<td class="m-horse">{$rider.horse}</td>
												<td class="m-btn"><a href="#" class="fan_btn">Буду болеть</a><input type="checkbox" name="user_id[]" value="{$rider.id}" style="display: none"></td>
											</tr>
										</table>
									</li>
                                    {/foreach}
								</ul>	
							</div>
						</div>

						<div class="row">	
							<div class="controls controls-row foo-row">
								<center>
                                    <input type="hidden" name="cid">
								<button type="submit" class="btn btn-warning span3 offset2">Сохранить</button>
								<button class="btn  span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
						</div>
			</form>
	</div>
</div>


{include "modules/footer.tpl"}