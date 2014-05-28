{* Smarty *}
<!-- модалка смены альбома у фотографии -->
<script>
    function change_album() {
        api_query({
            qmethod: "POST",
            amethod: "gallery_change_photo_album",
            params: $("#change-photo-album").serialize(),
            success: function (resp, data) {
                document.location = data.redirect;
            },
            fail: "standart"
        });
    }

</script>
<div id="modal-gallery-change-album" class="modal hide modal-gallery-change-album" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Перемещение фотографии</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" id="change-photo-album" onsubmit="change_album();return false;">

            {if $albums}
                Выбрать альбом:
            <select name="album" id="change-photo-albums">
                {foreach $albums as $album}
                    <option value="{$album.id}">{$album.name}</option>
                {/foreach}
            </select>
            {else}
                <p style="text-align: center;">Нет альбомов</p>
            {/if}
            <input type="hidden" id="change-photo-id" name="photo_id" value="">
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
<!-- //модалка смены альбома у фотографии -->