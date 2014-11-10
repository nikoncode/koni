{* Smarty *}

<script>
function create_album() {
	api_query({
		qmethod: "POST",
		amethod: "gallery_create_album",
		params: $("#add-edit-album").serialize(),
		success: function (resp, data) {
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
            if(resp.event > 0){
                mdl.find("[name=event] option[value="+resp.event+"]").prop('selected',true);
                $('.events_block').css('display','');
                $('.is_event').prop('checked',true);
            }else{
                $('.events_block').css('display','none');
                $('.is_event').prop('checked',false);
            }
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
			document.location = data.redirect;
		},
		fail: "standart"
	});	
}
    $(function(){
       $('.is_event').change(function(){
           var is_checked = $('.is_event:checked').size();
           if(is_checked > 0) $('.events_block').css('display','');
           if(is_checked == 0) $('.events_block').css('display','none');
       });
    });
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

                            <div class="controls controls-row">
								<label class="span3">Указать соревнование</label>
								<input type="checkbox" class="is_event" name="is_event" value="1">
							</div>

                            <div class="controls controls-row events_block" style="display: none">
                                <label class="span3">Соревнования</label>
                                <select name="event">
                                    {foreach $events as $event}
                                        <option value="{$event.id}">{$event.date} - {$event.name}</option>
                                    {/foreach}
                                </select>
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