{* Smarty *}
<div class="span12 lthr-bgborder block club-info" style="background-color: #fff">
	<h3 class="inner-bg">{$club.name}{*<span class="pull-right text-italic">Общий рейтинг: <strong>2367</strong> / Рейтинг по соревнованиям: <strong>7632</strong>*}
		{if $club.o_uid == $user.id}
			<a href="club-admin.php?id={$club.id}">[админ]</a></span>
		{/if}
	</h3>
	<div class="row">
		<div class="span3">
			<script>
				function to_club(id, action, element) {
					api_query({
						qmethod: "POST",
						amethod: "club_membership",
						params: {
							id : id,
							act : action
						},
						success: function (data) {
							var block = $(element).closest(".membership_block")
							if (action == "enter") {
								block.find("input").val("Покинуть клуб").attr("onclick", "to_club(" + id + ", 'leave', this); return false;");
								block.find("p").text("Вы вступили в этот клуб");
							} else {
								block.find("input").val("Вступить в клуб").attr("onclick", "to_club(" + id + ", 'enter', this); return false;");
								block.find("p").text("Вы покинули этот клуб.");											
							}
						},
						fail: "standart"
					})
				}
			</script>
			<a href="#"><img src="{$club.avatar}" class="club-avatar" /></a>
			<div class="membership_block">
				<input type="button" class="btn btn-warning goto-club" value="{if $user.club_id == $club.id}Покинуть клуб{else}Вступить в клуб{/if}" onclick="to_club({$club.id}, '{if $user.club_id == $club.id}leave{else}enter{/if}', this); return false;" />
				<p class="club-access-descr">
					{if !$user.club_name}
						Вы не состоите в <a href="/clubs.php">клубах</a>.
					{else}
						Вы состоите в "<a href="/club.php?id={$user.club_id}">{$user.club_name}</a>".
					{/if}
				</p>
			</div>
		</div>
		
		<div class="span6 current-club-descr">
			<p class="current-club-descr">
				{$club.sdesc}
			</p>
			<dl class="dl-horizontal">
				{if $club.site}
					<dt>Веб-сайт:</dt>
					<dd><a href="{$club.site}">{$club.site}</a></dd>
				{/if}
				{if $club.email}
					<dt>E-mail:</dt>
					<dd><a href="mailto:{$club.email}">{$club.email}</a></dd>
				{/if}
				{if $club.phones}
					<dt>Телефоны:</dt>
					<dd>
						<ul class="unstyled">
							{foreach $club.phones as $phone}
								<li>{$phone@key} - {$phone}</li>
							{/foreach}
						</ul>
					</dd>
				{/if}
				{if $club.address}
					<dt>Адрес:</dt>
					<dd>{$club.address}</dd>
				{/if}
			</dl>
		</div>
		
		{if $club.adv}
			<div class="span3 club-banners">
				<a href="{$club.adv.url}"><img src="{$club.adv.img}" /></a>
			</div>
		{/if}
	</div>
</div>