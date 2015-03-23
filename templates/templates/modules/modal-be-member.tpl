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
            $('#be-member form').find('.horses').each(function(){
                var id = $(this).find("[name=hid]").val();
                $(this).find(".rhids").html(data);
                $(this).find(".rhids input").attr('name','rhid['+id+']');
            });
			//mdl.find(".rhids").html(data);
			mdl.find("[name=rid]").val(rid);
			mdl.find(".horse").prop('checked',false);
			mdl.find('.dennik[value="0"]').prop('checked',true);
			mdl.find('.horses').removeClass('horse_checked');
			mdl.modal("show");
		},
		fail: "standart"
	})

}

function participate(form) {
	var f = $(form);
    var rid = f.find("[name=rid]").val();
    var error = false;
    $(form).find('.horses').each(function(){
        var hid = $(this).find("[name=hid]:checked").val() || 0;
        if(hid > 0) {
            var rhid = $(this).find(".heights:checked").val() || 0;
            if (rhid == 0) {
                alert('Не выбрана высота');
                error = true;
            }
        }
    });
    if(!error){
        $(form).find('.horses').each(function(){
            var hid = $(this).find("[name=hid]:checked").val() || 0;
            if(hid > 0){
                var rhid = '';
                rhid = $(this).find(".heights:checked").val() || 0;
                var dennik = 0;
                if($(this).find('.dennik:checked').size() > 0) dennik = $(this).find('.dennik:checked').val();
                if(dennik > 0){
                    $(this).find('.dennik_block').html('На соревновании уже зарезервирован');
                }
                var razvyazki = 0;
                if($(this).find('.razvyazki:checked').size() > 0) razvyazki = 1;
                var boxes = 0;
                if($(this).find('.boxes:checked').size() > 0) boxes = 1;
                query_to_ride(rid, hid, 1, dennik,razvyazki,rhid,boxes);
            }
        });
    }


}
$(function(){

    $('.rhids').on('change','.heights',function(){
        $(this).closest('.horses').find('.horse').prop('checked',true).change();
    });
    $('.horse').change(function(){
       var checked = $(this).prop('checked');
        if(checked){
            $(this).closest('.horses').addClass('horse_checked');
        }else{
            $(this).closest('.horses').removeClass('horse_checked');
        }
    });
    $('.dennik').on('change',function(){
        var val = $(this).val();
        var $this = $(this).closest('div.horses');
        if(val > 0){
            $this.find('.razvyazki').prop('checked',false);
            $this.find('.boxes').prop('checked',false);
        }
    });
    $('.razvyazki').on('change',function(){
        var $this = $(this).closest('div.horses');
        $this.find('.dennik[value="0"]').prop('checked',true);
        $this.find('.boxes').prop('checked',false);
    });
    $('.boxes').on('change',function(){
        var $this = $(this).closest('div.horses');
        $this.find('.dennik[value="0"]').prop('checked',true);
        $this.find('.razvyazki').prop('checked',false);
    });
})
</script>
<div id="be-member" class="modal hide in modal990" tabindex="-1" role="dialog" aria-hidden="false">
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
                                    <label class="span3">Денники<br/>({if $comp.dennik_res}в наличии {$comp.dennik_res}{else}недоступно{/if}):</label>
                                    <label class="span2">Развязки<br/>({if $comp.razvyazki_res}в наличии {$comp.razvyazki_res}{else}недоступно{/if}):</label>
                                    <label class="span2">Боксы<br/>({if $comp.boxes_res}в наличии {$comp.boxes_res}{else}недоступно{/if}):</label>
                                </div>
                            </div>

                            {foreach $horses as $h}
                                <div class="controls controls-row horses">
                                    <div class="row">
                                        <div class="span2"><input type="checkbox" class="horse" name="hid" value="{$h.id}"> {$h.nick}</div>
                                        <div class="span3"><div class="rhids"></div></div>
                                        <div class="span3 dennik_block">
                                            {if $comp.dennik_res}
                                                {if $h.dennik}
                                                    На соревновании уже зарезервирован
                                                {else}
                                                    <label><input type="radio" name="dennik[{$h.id}]" class="dennik" value="0" checked="checked"> Не нужны</label>
                                                    <label><input type="radio" name="dennik[{$h.id}]" class="dennik" value="1"> С кормами ({$club.options.horse_food} руб.)</label>
                                                    <label><input type="radio" name="dennik[{$h.id}]" class="dennik" value="2"> Без кормов ({$club.options.horse} руб.)</label>
                                                {/if}
                                            {/if}
                                        </div>
                                        <div class="span2 dennik_block">
                                            {if $comp.razvyazki_res}
                                                {if $h.dennik}
                                                    <label class="checkbox inline"><input type="checkbox" name="razvyazki" class="razvyazki" value="1" disabled></label>
                                                {else}
                                                    <label class="checkbox inline"><input type="checkbox" name="razvyazki" class="razvyazki" value="1" ></label>
                                                {/if}
                                            {/if}
                                        </div>
                                        <div class="span2 dennik_block">
                                            {if $comp.boxes_res}
                                                {if $h.dennik}
                                                    <label class="checkbox inline"><input type="checkbox" name="boxes" class="boxes" value="1" disabled>{$club.options.horse_box} руб.</label>
                                                {else}
                                                    <label class="checkbox inline"><input type="checkbox" name="boxes" class="boxes" value="1">{$club.options.horse_box} руб.</label>
                                                {/if}
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