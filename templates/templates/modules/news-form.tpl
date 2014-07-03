{* Smarty *}
<div class="add-news">
	<form onsubmit="news_{if $n}edit{else}add{/if}(this);return false;">
		<input type="hidden" name="type" value="{$owner_type}">
		<input type="hidden" name="id" value="{$owner_id}">
		<textarea placeholder="Что у вас нового?" class="span6" name="text">{$n.text}</textarea>
		<div class="uploaded-img-area row">
			
			<div class="uploaded-img-area previews row step2">
			{foreach $n.photos as $photo}
				<div class="new-uploaded-img span1"> 					
					<img class="img-polaroid" src="{$photo.preview}"> 					
					<a href="#remove-image" onclick="news_form_delete_att({$photo.id}, this); return false;">
						<img class="remove-image-icon" src="images/icon-remove-image.png">
					</a> 				   
				</div>
			{/foreach}
			</div>
			<div class="step1">
				<div class="progress progress-striped active" style="display: none">
					<div class="bar" id="bar" style="width: 0%;"></div>
				</div>
			</div>
		</div>
		<div class=" pull-right content-add-buttons">
			<div class="fileupload">
			  <input id="attach" type="file" name="gallery" data-album-id="{if $n}{$n.album_id}{else}0{/if}" multiple>
			  <input type="hidden" name="album_id" value="{if $n}{$n.album_id}{else}0{/if}" />
			  <button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить фото</button>
			</div>
		  	
		 	<button class="btn btn-warning" href="#">Поделиться</button>
		 	{if $n}
		 		<button class="btn" href="#" onclick="edit_news_cancel(this);return false;">Отмена</button>
		 	{/if}
		</div>

	</form>
</div>