 {* Smarty *}
 <ul id="comptTab" class="nav nav-tabs">
              <li class="active"><a href="#compt-future" data-toggle="tab">Будущие</a></li>
              <li><a href="#compt-present" data-toggle="tab">В настоящий момент</a></li>
              <li><a href="#compt-past" data-toggle="tab">Прошедшие</a></li>
              <li>
				<form>
					<div class="controls controls-row">
						<select class="span3" onchange="filter_by_type(this);">
							<option selected="">Все типы соревнований</option>
							{foreach $types as $type}
								<option>{$type}</option>
							{/foreach}
					   </select>
					</div>
				</form>
			</li>
            </ul>

<script>
function filter_by_type(element) {
	var type = $(element).val();
	$("#comptTabContent tr[data-type]").css("display", "none");
	if (type == "Все типы соревнований") {
		$("#comptTabContent tr[data-type]").css("display", "table-row");
	} else {
		$("#comptTabContent tr[data-type='" + type + "']").css("display", "table-row");
	}
}
</script>
            <div id="comptTabContent" class="tab-content">
              <div class="tab-pane in active" id="compt-future">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						{if $competitions.future}
							{foreach $competitions.future as $comp}
								 <tr data-type="{$comp.type}" data-date="{$comp.bdate}">
									<td class="compt-img"><a href="/club-compt.php?id={$comp.id}"><img src="images/icons/{$comp.type}.jpg"></a></td>
									<td class="compt-date">{$comp.bdate} <div>через {$comp.diff} дней</div></td>
									<td class="competition">
										<a href="/competition.php?id={$comp.id}">{$comp.name}</a>
									</td>
									<td class="compt-members">
                                        {if $club.o_uid == $user.id}
                                            [<a href="/competition-edit.php?id={$comp.id}">Редактировать или добавить маршруты</a>]
                                        {/if}

										<!--<ul class="inline compt-members">
											<li>25 участников</li>
											<li>4 фотографа</li>
											<li>120 зрителей</li>
										</ul>-->
									</td>
								</tr> 
							{/foreach}
						{else}
							<tr>
								<td colspan="4" style="text-align: center;">Соревнований нет.</td>
							</tr>
						{/if}
					</tbody>
					</table>
              </div>
              <div class="tab-pane" id="compt-present">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						{if $competitions.coming}
							{foreach $competitions.coming as $comp}
							 <tr data-type="{$comp.type}" data-date="{$comp.bdate}">
								<td class="compt-img"><a href="/club-compt.php?id={$comp.id}"><img src="images/icons/{$comp.type}.jpg"></a></td>
								<td class="compt-date">{$comp.bdate} <div>через {$comp.diff} дней</div></td>
								<td class="competition">
									<a href="/competition.php?id={$comp.id}">{$comp.name}</a>
								</td>
								<td class="compt-members">
									[<a href="/competition-edit.php?id={$comp.id}">Редактировать или добавить маршруты</a>]
									<!--<ul class="inline compt-members">
										<li>25 участников</li>
										<li>4 фотографа</li>
										<li>120 зрителей</li>
									</ul>-->
								</td>
							</tr> 
							{/foreach}
						{else}
							<tr>
								<td colspan="4" style="text-align: center;">Соревнований нет.</td>
							</tr>
						{/if}
					</tbody>
					</table>
              </div>
			  <div class="tab-pane" id="compt-past">
                <table class="table table-striped competitions-table compt-club">
						<tbody><tr>
							<th>Тип</th>
							<th>Дата</th>
							<th>Соревнование</th>
							<th>Участники</th>
						</tr>
						{if $competitions.past}
							{foreach $competitions.past as $comp}
							 <tr data-type="{$comp.type}" data-date="{$comp.bdate}">
								<td class="compt-img"><a href="/club-compt.php?id={$comp.id}"><img src="images/icons/{$comp.type}.jpg"></a></td>
								<td class="compt-date">{$comp.bdate} <div>{$comp.diff} дней назад</div></td>
								<td class="competition">
									<a href="/competition.php?id={$comp.id}">{$comp.name}</a>
								</td>
								<td class="compt-members">
									[<a href="/competition-edit.php?id={$comp.id}">Редактировать или добавить маршруты</a>]
									<!--<ul class="inline compt-members">
										<li>25 участников</li>
										<li>4 фотографа</li>
										<li>120 зрителей</li>
									</ul>-->
								</td>
							</tr> 
							{/foreach}
						{else}
							<tr>
								<td colspan="4" style="text-align: center;">Соревнований нет.</td>
							</tr>
						{/if}
					</tbody>
					</table>
              </div>
            </div>