{* Smarty *}

<script>
function create_album() {
	api_query({
		qmethod: "POST",
		amethod: "gallery_create_album",
		params: $("#add-edit-album").serialize(),
		success: function (resp, data) {
			alert(resp[0]);
			document.location = data.redirect;
		},
		fail: "standart"
	});
}

{literal}
function view_update_album_form(album_id) {
	api_query({
		qmethod: "POST",
		amethod: "gallery_album_info",
		params: {id : album_id},
		success: function (resp, data) {
			var mdl = $("#modal-add-edit-album");
			mdl.find("[name=name]").val(resp.name);
			mdl.find("[name=desc]").val(resp.desc);
			mdl.find("[name=id]").val(resp.id);
			mdl.find("form").attr("onsubmit", "update_album();return false;")
			mdl.modal("show");
		},
		fail: "standart"
	});
}
{/literal}

function update_album() {
	api_query({
		qmethod: "POST",
		amethod: "gallery_album_update",
		params: $("#add-edit-album").serialize(),
		success: function (resp, data) {
			alert(resp[0]);
			document.location = data.redirect;
		},
		fail: "standart"
	});	
}
</script>
<div id="modal-add-edit-album" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Создать альбом</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" id="add-edit-album" onsubmit="create_album();return false;">
						<div class="row">	
														
							<div class="controls controls-row">
								<label class="span6">Название альбома</label>
								<input type="text" name="name" class="span6">
							</div>
	
							<div class="controls controls-row">
								<label class="span3">Описание альбома</label>
								<textarea class="span6" name="desc" rows="10"></textarea>
							</div>

							<input type="hidden" name="id" value="" />
							
						</div>
						<hr/>
						<div class="row">	
							<div class="controls controls-row">
								<center>
								<button type="submit" class="btn btn-warning span3" onclick="">Сохранить</button>
								<button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
			</form>
	</div>
</div>