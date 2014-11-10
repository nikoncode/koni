{* Smarty *}
{include "modules/header.tpl"}
<script type="text/javascript" src="/js/gallery.js"></script>
{include "modules/modal-gallery-lightbox.tpl"}
<script>
    $(function(){
        $('.search_comp').change(function(){
            var type = $('.search_comp.type_comp option:selected').html();
            var month = $('.search_comp.month option:selected').val();
            var year = $('.search_comp.year option:selected').html();
            $('.competitions-table .event_row').each(function(){
                var comp_type = $(this).attr('data-type');
                var comp_month = $(this).attr('data-month');
                var comp_year = $(this).attr('data-year');
                if((type == comp_type || type == 'Не важно') && (comp_month == month || month == '') && (comp_year == year || year == 'Не важно')){
                    $(this).css('display','');
                }else{
                    $(this).css('display','none');
                }
            });
        });
    });
</script>
<div class="container current-horse-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" id="centerBlock" style="background-color: #fff">
				<div>
				<h3 class="inner-bg">{if $another_user}Лошади '{$another_user.fio}'{else}Ваши лошади{/if}<span class="pull-right"><a href="horses.php{if $another_user}?id={$another_user.id}{/if}">Назад ко всем лошадям</a></span></h3>
				
				<ul id="horseTab" class="nav nav-tabs new-tabs tabs2">
					<li class="active"><a href="#horse-info" data-toggle="tab">Информация</a></li>
					<li><a href="#horse-competitions" data-toggle="tab">Соревнования</a></li>
					<li><a href="#horse-gallery" data-toggle="tab">Галереи</a></li>
				</ul>
				
			<div id="horseTabContent" class="new-tabs tab-content">
			<div class="tab-pane in active" id="horse-info">
				<div class="my-horses">
					<div class="common-info row">
						<img src="{$horse.avatar}" class="avatar-my-horse-top"/>
						<h2 class="my-horse-name">{$horse.nick}</h2>
						<p class="my-horse-info">{$horse.age} лет ({$horse.byear} г. р.)</p>
						<ul class="my-horse-award">
							<li><img src="images/sample-small-award-1.png" /></li>
							<li><img src="images/sample-small-award-2.png" /></li>
							<li><img src="images/sample-small-award-3.png" /></li>
							<li><img src="images/sample-small-award-1.png" /></li>
							<li><img src="images/sample-small-award-2.png" /></li>
							<li><img src="images/sample-small-award-3.png" /></li>
						</ul>
						<ul class="this-horse-info">
							<li><span>Пол: </span>{$horse.sex}</li>
							{if $horse.rost}<li><span>Рост: </span>{$horse.rost} см.</li>{/if}
							<li><span>Специализация: </span>{$horse.spec}</li>
							<li><span>Масть: </span>{$horse.mast}</li>
							<li><span>Порода: </span>{$horse.poroda}</li>
							</ul>
						
					</div>
					
					
					
					<hr/>
					
					{if $horse.parents || $horse.bplace}
						<div class="row ">
							<p class="title">Родословная:</p>
							<ul class="horse-pedigree">
								{if $horse.bplace}
									<li class="place-birth"><span>Место рождения: </span><a href="#">{$horse.bplace}</a></li>
								{/if}
								{foreach $horse.parents as $parent}
									<li class="pedigree-members"><span>{$parent@key}: </span><a href="#">{$parent}</a></li>
								{/foreach}
							</ul>
						</div>
						<hr/>
					{/if}
					
					{if $horse.about}
						<div class="row ">
							<p class="title">О лошади:</p>
							<p>{$horse.about}</p>
						</div>
						<hr/>
					{/if}
					
					<div class="row ">
						<p class="title">Комментарии:</p>
						<script type="text/javascript" src="js/comments.js"></script>
						<script type="text/javascript" src="js/likes.js"></script>
						{include "iterations/comments_block.tpl"}
					</div>
					
				</div>
			</div> <!-- //horse-info -->
			
			<div class="tab-pane in" id="horse-competitions">
				<div class="future-events">
					<h5>Будущие соревнования</h5>
					<table class="table table-striped competitions-table">
                        {foreach $be_events as $event}
						  <tr><td>
								<p class="comp-date">{$event.date}</p>
								<p><a href="/competition.php?id={$event.id}">{$event.name} [{$event.route}, {$event.height} см, {$event.exam}]</a></p>
						</td></tr>
                        {/foreach}

					</table>
				</div>
			
			<hr/>
			
				<div class="past-events">
					<h5>Прошедшие соревнования</h5>
					<form class="form-horizontal"  method="post" action="#">
						<div class="row">	
						
							<div class="controls controls-row">
								<label class="span2">Тип соревнования:</label><label class="span2">Месяц:</label><label class="span2">Год проведения:</label>
								<select class="span2 search_comp type_comp">
                                    <option value="">Не важно</option>
									{foreach $horses_spec as $spec}
                                    <option>{$spec}</option>
                                    {/foreach}
							   </select>
								<select class="span2 search_comp month">
                                    <option value="">Не важно</option>
                                    {foreach $mounths as $nom=>$month}
									<option value="{$nom}">{$month}</option>
                                    {/foreach}
							   </select>
							   <select class="span2 search_comp year">
									<option>Не важно</option>
									<option>2014</option>
									<option>2013</option>
									<option>2012</option>
									<option>2011</option>
									<option>2010</option>
									<option>2009</option>
									<option>2008</option>
									<option>2007</option>
									<option>2006</option>
									<option>2005</option>
									<option>2004</option>
									<option>2003</option>
									<option>2002</option>
									<option>2001</option>
									<option>2000</option>

							   </select>
							</div>
						</div>
					</form>
					
					<table class="table table-striped competitions-table">
						<tr>
						  <th>Соревнование</th>
						  <th>Место</th>
						  <th>Результат</th>
						</tr>
                        {foreach $end_events as $event}
						 <tr class="event_row" data-type="{$event.type}" data-month="{$event.month}" data-year="{$event.year}">
							<td class="competition">
								<p class="comp-date">{$event.date}</p>
								<p><a href="/competition.php?id={$event.id}">{$event.name} [{$event.route}, {$event.height} см, {$event.exam}]</a></p>
							</td>
							<td class="place"><p>9 место</p></td>
							<td class="result"><p>75,30 / 0,00</p></td>
						</tr>
                        {/foreach}
						<tr>

					</table>
					
				</div>
			</div> <!-- //horse-competitions -->
			
			<div class="tab-pane in" id="horse-gallery">
				<div class="photos">
					<h5>Фото: {if !$another_user && $horse.album_id}[<a href="/gallery-upload.php?id={$horse.album_id}">добавить фото</a>]{/if}</h5>
					<ul class="photo-wall" data-gallery-list="{$horse.photo_ids}">
						{if $horse.photos}
							{foreach $horse.photos as $photo} 
								<li><a href="#" data-gallery-pid="{$photo@key}"><img src="{$photo}" /></a></li>
							{/foreach}
						{else}
							<li>Нет фотографий. </li>
						{/if}
					</ul>
				</div>
				
				<div class="clearfix"></div>
				
				<div class="photos video-gallery" style="display: none;">
					<h5>Видео:</h5>
					<ul class="photo-wall video-wall">
						<li style="background: url(i/sample-img-1.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-2.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-3.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-4.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
						<li style="background: url(i/sample-img-5.jpg) center center"><a href="#"><div class="video-thumb">
							<div class="video-hover"></div>
							<div class="video-time">00:23</div>
						</div></a></li>
					</ul>
				</div>
			</div> <!-- //horse-gallery -->
			
			</div>

			
				</div>
			</div>
			{if $another_user}
				{include "modules/sidebar-user-right.tpl"}
			{else}
				{include "modules/sidebar-my-right.tpl"}
			{/if}
		</div> <!-- /row -->
</div>


{include "modules/footer.tpl"}