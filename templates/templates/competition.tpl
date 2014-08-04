{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-be-member.tpl"}
<script type="text/javascript" src="js/likes.js"></script>
<script type="text/javascript" src="js/comments.js"></script>
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
function query_to_ride(rid, hid, act, callback) {
	api_query({
		amethod: "comp_rider",
		qmethod: "POST",
		params: {
			id: rid,
			hid: hid,
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
			$("#be-member").modal("hide");
		},
		fail: "standart"
	})
}

function rider(rid, act) {
	if (act == 1) {
		part_prepare(rid);
	} else {
		query_to_ride(rid, 1, 0);
	}
}


</script>
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
					<li><a href="/club.php?id={$club.id}#rating-club">Рейтинги (156,16)</a></li>
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
									<!--<ul class="unstyled span6 comp-added-files">
										<li class="pdf-file">Положение-1.pdf<button type="button" class="close">&times;</button></li>
										<li class="pdf-file">Положение-2.pdf<button type="button" class="close">&times;</button></li>
										<li class="pdf-file">Положение-c-длинным-описанием.pdf<button type="button" class="close">&times;</button></li>
									</ul>-->
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
											<div class="curr-compt-path span2">{$route.name}</div>
											<div class="curr-compt-height span2">{$route.height}</div>
											<div class="curr-compt-for span2">{$route.exam}</div>
											<div class="curr-compt-status span2">{$route.status}</div>
											<div class="curr-compt-go">
												<a href="#" class="btn btn-{if $route.is_rider}success{else}warning{/if}" onclick="rider({$route.id}, '{!$route.is_rider}', this); return false;" data-rider-rid="{$route.id}">
													Участвовать <i class="icon-play icon-white"></i>
												</a>
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
              <li><a href="#compt-results" data-toggle="tab">Результаты</a></li>
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
						<h3 class="inner-bg">Фотографы{*<span class="pull-right">{$comp.photographers|@count}</span>*}</h3>
						<ul class="clubs-members" id="photographers">
							{foreach $comp.photographers as $photographer}
								<li {if $photographer.id == $user.id}class="me"{/if}><a href="/user.php?id={$photographer.id}"><img src="{$photographer.avatar}"><p>{$photographer.fio}</p></a></li>
							{/foreach}
						</ul>
					</div> 
              </div> <!-- compt-members -->
              
			  <div class="tab-pane" id="compt-results">
				<table class="table table-striped competitions-table compt-results admin-compts">
						<tbody><tr>
                            <th>№</th>
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
						{if $comp.routes}
							{foreach $comp.routes as $route}
								<tr><td colspan="10" class="table-caption">{$route.name}</td></tr> 
								{if $comp.results.{$route.id}}
									{foreach $comp.results.{$route.id} as $res}
										<tr {if $res.disq}class="disq"{/if} data-disq={$res.disq}>
											<td class="">
												{$res.pos}
											</td>
											<td>{$res.fio}</td>
											<td>{$res.degree}</td>
											<td>{$res.horse}</td>
											<td>{$res.team}</td>
											<td>{$res.opt1}</td>
											<td>{$res.opt2}</td>
											<td>{$res.opt3}</td>
											<td>{$res.opt4}</td>
											<td>{$res.opt5}</td>
										</tr> 
									{/foreach}
								{else}
									<tr>
										<td colspan="10" style="text-align: center;">Администратор мероприятия пока не установил турнирную таблицу. Попробуйте позже.</td>
									</tr>
								{/if}
							{/foreach}
						{else}
							<tr>
								<td colspan="10" style="text-align: center;">Нет маршрутов.</td>
							</tr>
						{/if}
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