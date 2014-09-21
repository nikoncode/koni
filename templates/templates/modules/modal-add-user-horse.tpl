{* Smarty *}
<script>
    function new_user_horse_prepare() {
        $("#modal-add-user-horse").modal("show");
    }

    function new_owner_horse_prepare() {
        $("#modal-add-user-horse").modal("hide");
        $("#modal-add-owner-horse").modal("show");
    }

    function new_user_horse(form) {
        api_query({
            qmethod: "POST",
            amethod: "horse_owner_add",
            params:  $(form).serialize(),
            success: function (data) {
                document.location.reload();
            },
            fail:    "standart"
        })
    }

    {literal}
    function new_owner_prepare(form) {
        new_horse_prepare();
        $("#modal-add-horse input.name").val($(form).find('.name_owner').val());
        $("#modal-add-horse input.lname").val($(form).find('.lname_owner').val());
        $("#modal-add-owner-horse").modal("hide");
    }
    function delete_user_horse(hid, element) {
        if (confirm("Вы действительно хотите удалить лошадь?")) {
            api_query({
                qmethod: "POST",
                amethod: "horses_user_delete",
                params:  {id : hid},
                success: function (data) {
                    $(element).closest(".my-horse").remove();
                },
                fail:    "standart"
            })
        }
    }
    $(function () {
        $('.user_search_btn').click(function(){
            var find = $('#user_search').val();
            api_query({
                qmethod: "POST",
                amethod: "user_horse_find",
                params: {q:find},
                success: function (data) {
                    $(".friends-list").html(data);
                },
                fail: "standart"
            })
        });

        $('.friends-list').on('click','.select_user',function(){
            var user_id = $(this).attr('alt');
            var $this = $(this).closest('.user-info-actions');
            api_query({
                qmethod: "POST",
                amethod: "user_horses",
                params: {id:user_id},
                success: function (data) {
                    var html = '<select name="horse" class="user_horses">'+data+'</select>';
                    $this.html(html)
                },
                fail: "standart"
            })
        });

    });
    {/literal}
</script>
<div id="modal-add-user-horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавление чужой лошади</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal"  method="post" action="#" onsubmit="new_user_horse(this);return false;">
            <div class="row">
                <div class="controls controls-row">
                    <input type="text" class="span3 search-query" id="user_search" name="q" placeholder="Начните вводить имя или название">
                    <input type="button" class="btn btn-warning span3 user_search_btn" value="Искать владельца"/>
                </div>
                <hr/>
                <div class="friends-list">
                    <p style="text-align: center;">Начните поиск.</p>
                </div>
            </div>
            <hr/>

            <div class="row">
                <div class="controls controls-row">
                    <center>
                        <a href="#" onclick="new_owner_horse_prepare();return false;">Владельца лошади нет на сайте?</a><br/><br/>
                        <button type="submit" class="btn btn-warning span3">Сохранить</button>
                        <button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
                    </center>
                </div>
            </div>
        </form>
    </div>
</div>
<div id="modal-add-owner-horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Информация о владельце</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal"  method="post" action="#" onsubmit="new_owner_prepare(this);return false;">
            <div class="row">
                <div class="controls controls-row">
                    <input type="text" class="span3 name_owner" name="name_owner" placeholder="Имя владельца">
                    <input type="text" class="span3 lname_owner" name="lname_owner" placeholder="Фамилия владельца">
                </div>
            </div>
            <hr/>

            <div class="row">
                <div class="controls controls-row">
                    <center>
                        <button type="submit" class="btn btn-warning span3">Далее</button>
                        <button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
                    </center>
                </div>
            </div>
        </form>
    </div>
</div>