{*Smarty *}
<script>
function part_prepare(rid) {
	api_query({
		amethod: "route_heights",
		qmethod: "POST",
		params: {
			id: rid
		},
		success: function (data) {
			var mdl = $("#be-member");
			mdl.find(".rhids").html(data);
			mdl.find("[name=rid]").val(rid);
			mdl.modal("show");
		},
		fail: "standart"
	})

}

function participate(form) {
	var f = $(form);
    var rid = f.find("[name=rid]").val();
    $(form).find('.horses').each(function(){
        var hid = $(this).find("[name=hid]:checked").val() || 0;
        if(hid > 0){
            var rhid = '';
            $(this).find(".heights  option:selected").each(function(){
                rhid += $(this).val()+'-';
            });
            var dennik = 0;
            if($(this).find('.dennik:checked').size() > 0) dennik = $(this).find('.dennik_count').val();
            var razvyazki = 0;
            if($(this).find('.razvyazki:checked').size() > 0) razvyazki = $(this).find('.razvyazki_count').val();
            query_to_ride(rid, hid, 1, dennik,razvyazki,rhid);
        }
    });

}
    $(function(){
        $('.dennik').change(function(){
            var selected = $(this).prop('checked');
            if(selected) $(this).closest('div').find('.dennik_count').removeClass('hidden');
            else $(this).closest('div').find('.dennik_count').addClass('hidden');
        });
		$('.razvyazki').change(function(){
            var selected = $(this).prop('checked');
            if(selected) $(this).closest('div').find('.razvyazki_count').removeClass('hidden');
            else $(this).closest('div').find('.razvyazki_count').addClass('hidden');
        });
        $('.dennik_count,.dennik_count').change(function(){
            if($(this).val() < 1) $(this).val(1);
        });
    })
</script>
<div id="be-member" class="modal hide in modal800" tabindex="-1" role="dialog" aria-hidden="false">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3>Буду участвовать</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal" method="post" action="#" onsubmit="participate(this); return false;">
						<div class="row">
                            <div class="controls controls-row">
                                <div class="row">
                                    <label class="span2">Выберите лошадь:</label>
                                    <label class="span3">Выберите высоту:</label>
                                    <label class="span2">Денники<br/>(в наличии {$comp.dennik_res}):</label>
                                    <label class="span2">Развязки<br/>(в наличии {$comp.razvyazki_res}):</label>
                                </div>
                            </div>

                            {foreach $horses as $h}
                                <div class="controls controls-row horses">
                                    <div class="row">
                                        <div class="span2"><input type="checkbox" name="hid" value="{$h.id}"> {$h.nick}</div>
                                        <div class="span3"><div class="rhids"></div></div>
                                        <div class="span2">
                                            {if $comp.dennik}
                                                <label class="checkbox inline"><input type="checkbox" name="dennik" class="dennik"></label>
                                                <input name="dennik_count" type="number" class="hidden dennik_count" value="1">
                                            {/if}
                                        </div>
                                        <div class="span2">
                                            {if $comp.razvyazki}
                                                <label class="checkbox inline"><input type="checkbox" name="razvyazki" class="razvyazki"></label>
                                                <input name="razvyazki_count" type="number" class="razvyazki_count hidden" value="1">
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
							<input type="hidden" name="rid">
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