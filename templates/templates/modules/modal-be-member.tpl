{*Smarty *}
<script>
function part_prepare(rid) {
	var mdl = $("#be-member");
	mdl.find("[name=rid]").val(rid);
	mdl.modal("show");
}

function participate(form) {
	var f = $(form);
	var hid = f.find("[name=hid]").val();
	var rid = f.find("[name=rid]").val();
	query_to_ride(rid, hid, 1);
}
</script>
<div id="be-member" class="modal hide in" tabindex="-1" role="dialog" aria-hidden="false">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3>Буду участвовать</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" method="post" action="#" onsubmit="participate(this); return false;">
						<div class="row">	
							<div class="controls controls-row">
								<label class="span6">Выберите лошадь:</label>
								<select name="hid" class="span6">
									{foreach $horses as $h}
										<option value="{$h.id}">{$h.nick}</option>
									{/foreach}
								</select>
							</div>
							<input type="hidden" name="rid">
							
							<div class="controls controls-row">
								<label class="checkbox span6"><input type="checkbox" name="dennik"> Мне нужен денник</label>
							</div>
						</div>
						
						<div class="row">	
							<div class="controls controls-row">
								<center>
								<button type="submit" class="btn btn-warning span3">Сохранить</button>
								<button class="btn  span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
			</form>
	</div>
</div>