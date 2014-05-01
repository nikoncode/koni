{* Smarty *}

{include "modules/header.tpl"}
<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
<script>
$(function () {
	$("#gallery-upl").fileupload({
		url: "/api/api.php?m=upload_gallery_photo&album_id={$album_id}",
		dataType: "json",
		done: function (e, data) {
			resp = data.result;
			console.log(resp);
			if (resp.type == "success") {
				console.log(resp);
			} else {
				alert(resp.response[0]);
			}
		}, progressall: function (e, data) {
			var progress = parseInt(data.loaded / data.total * 100, 10);
			$('.progress .bar').css('width', progress + '%');
		}
	});
});

</script>


<div class="container gallery-page album-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			
			<div class="span6 lthr-border gallery-upload block" style="background-color: #fff">
			<h3 class="inner-bg">Загрузка фото в "{$album_name}" <span class="pull-right"><a href="gallery.php">назад в галерею</a></span></h3>
				<div class="row">
					<div class="span6">
					
					<div class="row">
					<div class="span6">
					<div class="content-add-buttons">
						<div class="fileupload">
						  <input type="file" name="gallery" id="gallery-upl" multiple>
						  <center><button class="btn btn-large btn-add-photo btn-warning"><i class="icon-camera"></i> Выберите файлы</button></center>
						  <p class="upload-descr">Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
						  <hr/>
						</div>
					</div>
					</div>
					</div>
			
						<div class="uploaded-img-area row">
						<form onsubmit="gallery_upd_desc(this);return false;">	
							<input type="hidden" name="album_id" value="{$album_id}" />
							<div class="step1">
								<div class="progress progress-striped active">
									<div class="bar" style="width: 0%;"></div>
								</div>
								
							</div>
							
							<div class="uploaded-img-area row step2">
								<ul class="unstyled" id="uploaded-photos">
								</ul>
							</div>
							
							<div class="row">
									<button class="btn btn-warning span3" href="#" type="submit">Сохранить</button>
									<a class="btn btn-default span3" href="#">Отмена</a>
							</div>
						</form>	
							
							
						</div>

					</div>
				</div>
			</div>

			{include "modules/sidebar-my-right.tpl"}
		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}