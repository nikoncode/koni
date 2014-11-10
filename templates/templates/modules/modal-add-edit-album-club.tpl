{* Smarty *}

<script>
    function create_album() {
        api_query({
            qmethod: "POST",
            amethod: "gallery_create_album",
            params: $("#add-edit-album").serialize(),
            success: function (resp, data) {
                location.reload();
            },
            fail: "standart"
        });
    }

    {literal}
    function view_update_album_form(album_id,club_id) {
        api_query({
            qmethod: "POST",
            amethod: "gallery_album_info",
            params: {id : album_id,club_id: club_id},
            success: function (resp, data) {
                var mdl = $("#modal-add-edit-album");
                mdl.find("[name=name]").val(resp.name);
                mdl.find("[name=desc]").val(resp.desc);
                mdl.find("[name=id]").val(resp.id);
                mdl.find("form").attr("onsubmit", "update_album();return false;");
                mdl.find(".delete_album").attr("onclick", "delete_album("+album_id+','+club_id+");return false;").css('display','');
                mdl.modal("show");
            },
            fail: "standart"
        });
    }
    function delete_album(album_id,club_id) {
        if(confirm('Находящиеся фотографии в этом альбоме, будут удалены вместе с этим альбомом. Вы уверены, что хотите удалить альбом?')){
            api_query({
                qmethod: "POST",
                amethod: "gallery_album_delete",
                params: {id : album_id,club_id: club_id},
                success: function (resp, data) {
                    location.reload();
                },
                fail: "standart"
            });
        }
    }
    {/literal}

    function update_album() {
        api_query({
            qmethod: "POST",
            amethod: "gallery_album_update",
            params: $("#add-edit-album").serialize(),
            success: function (resp, data) {
                location.reload();
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
                <input type="hidden" name="club_id" value="{$club.id}" />
                <input type="hidden" name="comp_id" value="{$comp.id}" />

            </div>
            <center><button type="button" class="btn btn-warning delete_album" onclick="" style="display: none">Удалить альбом</button></center>
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