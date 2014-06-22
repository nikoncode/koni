{* Smarty *}
{include "modules/header.tpl"}

<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="js/clubs-find-functions.js"></script>
<link rel="stylesheet" href="css/range.css">

<script type="text/javascript">
	function club_search(form) {
		api_query({
			qmethod: "POST",
			amethod: "club_search",
			params: $(form).serialize(),
			success: function (data) {
				map_clear();
				make_circle();
				$("#results tr.result").remove();
				$("#results").append(data.rendered);
				var coords;
				for (i=0;i<data.source.length;++i) {
					coords = data.source[i]["coords"].split(", "); 
					if (coords.length == 2)
						show_address(coords, data.source[i]);
				}
			}, 
			fail: "standart"
		})
	}

	function add_ability() {
		$("<div class='opt'> \
			<select class='span2' name='ability[]'> \
				<option value='' selected>Выберите из списка</option> \
				{foreach $abilities as $ability}
					<option>{$ability}</option> \
				{/foreach}
			</select> \
			<button class='btn add-rem span1' onclick='del_ability(this); return false;'>-</button> \
		</div>").prependTo("#abilities");
	}

	function del_ability(el) {
		$(el).closest("div.opt").remove();
	}
</script>

<div class="container clubs-find-page clubs-page main-blocks-area club-block">
		<div class="row">
		
			<div class="span12 lthr-bgborder filter-block block">
				<h3 class="inner-bg">Поиск клубов<span class="pull-right">
					{if $user.club_name}
						Вы состоите в клубе "<a href="/club.php?id={$user.club_id}">{$user.club_name}</a>"
					{else}
						Вы не состоите в <a href="/clubs.php">клубах</a>.
					{/if}
				</span></h3>
				<div class="row">
					<form class="search-clubs-filter" onsubmit="club_search(this); return false;">
					<div class="span3">
							<div class="search-clubs-filter-block">
								<label>Страна</label>
								<select  class="span3" name="country">
									<option selected="" value="">Не важно</option>
									{foreach $countries as $country}
										<option>{$country}</option>
									{/foreach}
								</select>
							</div>
							
							 <div class="search-clubs-filter-block">
								<label>Город</label>
								<input type="text" placeholder="Любой город" class="span3" name="city">
								
								<ul class="inline unstyled">
									<li><label class="radio"><input type="radio" name="area" value="metro"> Метро</label></li>
									<li><label class="radio"><input type="radio" name="area" value="district"> Округ</label></li>
								</ul>
								
								<select  class="span3">
									<option>Метро-или-округ #1</option>
									<option>Метро-или-округ #2</option>
									<option>Метро-или-округ #3</option>
								</select>
						
							<div class="club-range-block">
								<label>Расстояние от города</label>
								<div id="city-dist" class="xxx"></div>
								<div id="city-dist-amount" class="range-amount"></div>
							</div>
						</div>
					</div>
					
					<div class="span3">
					
						<div class="search-clubs-filter-block">
							<label>Название</label>
							<input type="text" name="name" placeholder="Название" class="span3">
						</div>
						
							<div class="search-clubs-filter-block">
								<label>Вид</label> <!-- undefined field, no info in club-admin -->
								<select  class="span3" name="type">
									<option selected="" value="">Не важно</option>
									{foreach $types as $type}
										<option>{$type}</option>
									{/foreach}
								</select>
							</div>	
							
							<div class="search-clubs-filter-block">
								<label>Цена</label>
								<select  class="span3" name="range_type">
									<option value="with_inst">Аренда лошади с инcтруктором</option>
									<option value="without_inst">Аренда лошади без инcтруктора</option>
									<option value="horse">Постой лошади</option>
								</select>
								
								<input name="amount_start" type="hidden">
								<input name="amount_end" type="hidden">
								<div id="h-with-trainer"></div>
								<div id="h-with-trainer-amount" class="range-amount"></div>
							</div>
						
					</div>
					
					<div class="span3">
						<div class="controls controls-row" id="abilities">
							<div class="opt">
								<select class="span2" name="ability[]">
									<option value='' selected>Выберите из списка</option>
									{foreach $abilities as $ability}
										<option>{$ability}</option>
									{/foreach}
								</select>
								<button class="btn add-rem span1 btn-warning" onclick="add_ability(); return false;">+</button>
							</div>
						</div>
					</div>
					
					<div class="span3">
						<input type="submit" value="Найти клубы" class="span3 btn btn-warning btn-large" />
						<p class="block-descr tac">или</p>
						<hr/>
						<input type="button" data-toggle="modal" href="#createClub" value="Создать клуб" class="span3 btn-danger btn-large" />
						<p class="block-descr">Создать клуб может только уполномоченное или доверенное лицо от клуба</p>
					</div>
					</form>
				</div>
			</div>
			
			<div class="span12 brackets-horizontal"></div>
			
			<div class="span12 lthr-bgborder block clubs-search-results">
				<h3 class="inner-bg">Результаты поиска</h3>
				<div class="row">
					<script src="http://api-maps.yandex.ru/2.0/?load=package.full&lang=ru-RU" type="text/javascript"></script>
					<script>
					{literal}
						var myMap, geoResult = undefined, coords, marks = [], circle = undefined;
						ymaps.ready(init);
						
						function init () {
							myMap = new ymaps.Map('map', {
								center:[55.76, 37.64], 
								zoom: 13
							});
							myMap.controls.add('zoomControl');
						}

						function map_clear() {
							for (i=0;i<marks.length;++i)
								myMap.geoObjects.remove(marks[i]);
							if (circle !== undefined)
								myMap.geoObjects.remove(circle);
						}

						function show_address(adress, club) {
							ymaps.geocode(adress, {results: 1}).then(function(res) {
								if (res.metaData.geocoder.found !== 0) {
									geoResult = res.geoObjects.get(0);
									var placemark = new ymaps.Placemark(geoResult.geometry.getCoordinates(), {
										balloonContent: '<h3>'+club.name+'</h3> \
										'+geoResult.properties.get("text")+' <br>\
										<a href="club.php?id='+club.id+'">Перейти к клубу</a> \
										',
									});
									myMap.geoObjects.add(placemark);
									marks[marks.length] = placemark;
									if (myMap.geoObjects.getBounds() != null)
										myMap.setBounds(myMap.geoObjects.getBounds());
								} else {
								alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
								}
							}, function (err) {
								alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
							});
						}

						function make_circle() {
							var cnt = $("[name=country]").val();
							var ct = $("[name=city]").val();
							var card_point = "";
							if (cnt != "")
								card_point = cnt;
							if (ct != "")
								card_point = card_point + ", " + ct;
							console.log(card_point);
							if (card_point == "")
									return false;
							ymaps.geocode(card_point, {results: 1}).then(function(res) {
								if (res.metaData.geocoder.found !== 0) {
									geoResult = res.geoObjects.get(0);
									myMap.setCenter(geoResult.geometry.getCoordinates());
									circle = new ymaps.Circle([geoResult.geometry.getCoordinates(), parseInt($("#city-dist").slider("values", 1)) * 1000], {}, {
										geodesic: true
									});
									myMap.geoObjects.add(circle);                
								} else {
									alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
								}
							}, function (err) {
								alert("Яндекс не справился с поиском адреса, проверьте введенные данные.");
							});
						}
						{/literal}
						</script>
					<div id="map" style="width:940px; height:260px"></div>
				</div>
				<div class="row">
					<table class="table table-striped competitions-table clubs-results">
									<tbody id="results"><tr>
									  <th>Название</th>
									  <th>Местонахождение</th>
									  <th>Участники</th>
									  <th>Цена за час</th>
									  <th>Рейтинг/отзывы</th>
									</tr>
									<tr class="result">
										<td colspan="5" style="text-align: center;">Начните поиск чтобы увидеть результаты</td>
									</tr>
									 
								</tbody>
								</table>
				</div>
			</div>

		</div> <!-- /row -->
</div>

<script>
function create_club(form) {
	api_query({
		qmethod: "POST",
		amethod: "club_create",
		params: $(form).serialize(),
		success: function (id) {
			window.location = "/club-admin.php?id=" + id;
		},
		fail: function (err) { //our modal not working
			console.log(err);
			var errs = "";
			for (i=0;i<err.length;++i)
				errs += err[i] + "\n";
			alert(errs);
		}
	})
}
</script>

<div id="createClub" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Создать клуб</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" action="#" onsubmit="create_club(this); return false;">
				<div class="controls controls-row">
					<label class="span6">Название клуба</label>
					<input type="text" class="span6" placeholder="Введите название своего клуба" name="name">
				</div>
				<div class="controls controls-row">
					<label class="span6">Ваш контактный телефон</label>
					<input type="text" class="span6" name="phone"  placeholder="Для подтверждения Вашего статуса">
				</div>
				<div class="controls controls-row">
					<label class="checkbox span6">
					  <input type="checkbox" name="accept"> Да, я являюсь уполномоченным лицом от клуба
					</label>
				</div>
				<div class="controls controls-row">
						 <button type="submit" class="btn btn-warning span3">Создать клуб</button>
						 <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
				 </div>
			</form>
	</div>
</div>

{include "modules/footer.tpl"}