{* Smarty *}

<script>
    function add_video() {
        api_query({
            qmethod: "POST",
            amethod: "gallery_add_video",
            params: $("#add-video").serialize(),
            success: function (resp, data) {
                location.reload();
            },
            fail: "standart"
        });
    }
</script>
<div id="modal-add-video" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавить видео</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" id="add-video" onsubmit="add_video();return false;">
            <div class="row">

                <div class="controls controls-row">
                    <label class="span6">Ссылка на видео</label>
                    <input type="text" name="video" class="span6">
                </div>

                <div class="controls controls-row">
                    <label class="span3">Описание видео</label>
                    <textarea class="span6" name="desc" rows="10"></textarea>
                </div>

                <input type="hidden" name="id" value="" />
                <input type="hidden" name="club_id" value="{$club.id}" />
                <input type="hidden" name="comp_id" value="{$comp.id}" />
                <input type="hidden" name="album_club_id" value="{$gallery_id}" />

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