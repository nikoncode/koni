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
			id: {$user.id},
			type: "feed"
		})
	})
</script>

{include "modules/modal-gallery-lightbox.tpl"}
<div class="container news-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}

			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
			<div class="clear"></div>
			<div>
			<h3 class="inner-bg">Новости</h3>
				<ul class="my-news-wall">
					{include "iterations/news_block.tpl"}
				</ul>
				</div>
			</div>
			
			{include "modules/sidebar-my-right.tpl"}
		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}