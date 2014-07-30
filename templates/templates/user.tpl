{* Smarty *}

{include "modules/header.tpl"}
<script type="text/javascript" src="js/likes.js"></script>
<script type="text/javascript" src="js/gallery.js"></script>
<script type="text/javascript" src="js/comments.js"></script>
<script type="text/javascript" src="js/news.js"></script>
<script type="text/javascript" src="js/autoload.js"></script>
<script>
	$(function () {
		news_form_init($(".add-news form"));
		$(".my-news-wall").autoload({
			id: {$another_user.id},
			type: "user"
		})
	})
</script>
{include "modules/modal-gallery-lightbox.tpl"}
<div class="container clubs-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
				<div>
				{include "modules/horses_bar.tpl" horses_bar=$another_user.horses_bar horses_bar_id=$another_user.id}
				<div class="clear"></div>
			{if $photos}
			<div>
				<h3 class="inner-bg">Фотографии <span class="pull-right"><a href="gallery.php?id={$another_user.id}">Альбомы</a></span></h3>
						<ul class="club-photo-wall" data-gallery-list="{$photos_ids}">
							{foreach $photos as $photo}
								<li><a href="#" data-gallery-pid="{$photo.id}"><img src="{$photo.preview}" /></a></li>
							{/foreach}
						</ul>
						<div class="clearfix"></div>
			</div>
			{/if}	
			<div>
				<h3 class="inner-bg">Новости</h3>
			
				<ul class="my-news-wall">
					{include "iterations/news_block.tpl"}
							</ul>
					</div>
					
				</div>
			</div>
			
			{include "modules/sidebar-user-right.tpl"}

		</div> <!-- /row -->
</div>



<div id="createClub" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Создать клуб</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" action="club-create.php">
				<div class="control-group">
					<label class="control-label">Название клуба</label>
					<div class="controls">
						<input type="text" class="span4" placeholder="Введите название своего клуба">
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						 <button type="submit" class="btn btn-warning">Создать клуб</button>
						 <button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
					</div>
				 </div>
			</form>
	</div>
</div>




{include "modules/footer.tpl"}