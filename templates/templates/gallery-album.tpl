{* Smarty *}
{include "modules/header.tpl"}
<script src="js/gallery.js"></script>
<script>
{literal}
function delete_album(album_id) {
	api_query({
		qmethod: "POST",
		amethod: "gallery_album_delete",
		params: {id : album_id},
		success: function (resp, data) {
			alert(resp[0]);
			document.location = data.redirect;
		},
		fail: "standart"
	});
}
{/literal}
</script>
<div class="container gallery-page album-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="span6 lthr-border block" style="background-color: #fff">
				<h3 class="inner-bg">{$album.name}<span class="pull-right"><a href="gallery.php?id={$user_id}">назад в галерею</a></span></h3>
				<div class="row">
					<div class="photos">
						{if !$another_user}
							{include "modules/modal-add-edit-album.tpl"}
							<div class="sys-album-btns">
								<center><a href="gallery-upload.php?id={$album.id}" class="btn btn-warning" id="upload-photos">Добавить фото в этот альбом</a><a class="btn btn-default" href="#" onclick="view_update_album_form({$album.id});return false;">Изменить</a><a class="btn btn-default" href="#" onclick="delete_album({$album.id});return false;">Удалить</a><br/></center>
								<hr/>
							</div>
						{/if}
						
						<p class="album-descr">{$album.desc}</p>
						
						<div class="photos" data-gallery-list="{$photos_ids_list}">
							{if $photos}
								{include "modules/modal-gallery-lightbox.tpl"}
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