{* Smarty *}
{include "modules/header.tpl"}

<div class="container horses-list-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
				<h3 class="inner-bg">
					{if $another_user}
						Лошади "{$another_user.fio}"
					{else}
						Мои лошади
					{/if}
				</h3>
			
				<div class="horses-list">
					{if !$another_user}
						{include "modules/modal-add-horse.tpl"}
						<center><a href="#" onclick="new_horse_prepare();return false;" class="btn btn-warning">Добавить лошадь</a></center>
					{/if}
					{if $horses}
						{foreach $horses as $horse}
							<div class="span6 my-horse">
								<div class="row">
									<div class="horse-info-photo span1">
										<a href="/horse.php?id={$horse.id}"><img src="{$horse.avatar}" class="horse-avatar"></a>
									</div>
									<div class="horse-info-about span3">
										<ul>
											<li class="horse-name"><a href="/horse.php?id={$horse.id}">{$horse.nick}</a></li>
											<li class="age">{$horse.age} лет ({$horse.byear} год рождения)</li>
											<li class="sex"><span>Пол: </span>{$horse.sex}</li>
											<li class="spec"><span>Специализация: </span>{$horse.spec}</li>
										</ul>
									</div>
									<div class="span2 horse-info-actions">
										<ul>
											<li><a href="/horse.php?id={$horse.id}">Комментировать</a></li>
											{if !$another_user}
												<li><a href="#" onclick="edit_horse_prepare({$horse.id}); return false;">Изменить</a></li>
												<li><a href="#" onclick="delete_horse({$horse.id}, this); return false;">Удалить</a></li>
											{/if}
										</ul>
									</div>
								</div>
							</div>
						{/foreach}
					{else}
						<p style="text-align: center;">Нет лошадей</p>
					{/if}
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