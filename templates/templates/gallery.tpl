{* Smarty *}

{include "modules/header.tpl"}
<script src="js/gallery.js"></script>
<div class="container gallery-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			{include "modules/modal-gallery-lightbox.tpl"}
			{include "modules/modal-gallery-change-album.tpl"}
			<div class="span6 lthr-border block" style="background-color: #fff">
				<h3 class="inner-bg">Галерея</h3>
				<div class="albums-head">
					{if !$another_user}
						{include "modules/modal-add-edit-album.tpl"}
						<a href="#modal-add-edit-album" role="button" data-toggle="modal" class="pull-right btn btn-default btn-create-album">Создать альбом</a>	
					{/if}				
					<h5 class="title-hr">Альбомы</h5>
				</div>
				<div class="albums">
					{if $albums}
						<ul class="album-wall">
							{foreach $albums as $album}
							<li>
								<a href="/gallery-album.php?id={$album.id}">
									{if !$album.cover}
										<img src="http://placehold.it/190x130">
									{else}
										<img src="{$album.cover}">
									{/if}
								</a>
								<a href="/gallery-album.php?id={$album.id}"><p>{$album.name}</p></a>
								{if $album.linked_event_name}
									<p>Прикреплено к <a href="club-compt.php?id={$album.linked_event}">{$album.linked_event_name}</a>
								{/if}
								{if $album.desc}
									<p>{$album.desc}</p>
								{/if}
							</li>
							{/foreach}
						<ul>
					{else}
						<p style="text-align: center;">Нет альбомов</p>
					{/if}
				</div>
				
				<div class="clear"></div>
				
				<div class="photos" data-gallery-list="{$photos_ids_list}">
					{if $photos}
					<ul class="photo-wall">
							{foreach $photos as $photo}
								<li><a href="#" data-gallery-pid="{$photo.id}"><img src="{$photo.preview}" /></a></li>
							{/foreach}
					</ul>
					{else}
						<p style="text-align: center;">Нет фотографий</p>
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