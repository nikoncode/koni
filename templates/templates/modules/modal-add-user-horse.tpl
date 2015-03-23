{* Smarty *}
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
<script>
    {literal}
    function change_country() {
        var country = $('.chosen-country option:selected').val();
        api_query({
            qmethod: "POST",
            amethod: "auth_get_city",
            params:  {country_id:country},
            success: function (response, data) {
                $('select.chosen-city').html(response);
                /*$('select.select-city option').each(function(){
                    var tmp = $(this).html();
                    $(this).val(tmp);
                });*/
                $(".chosen-city").trigger("chosen:updated");
            },
            fail:    "standart"
        })
        /*phone = $("input[name=phone]");
         country = $(select).val();
         if (country == "Беларусь") phone.val("+375");
         else if(country == "Россия") phone.val("+7");
         else if(country == "Украина") phone.val("+380");
         else phone.val("");*/
    }
    {/literal}

    function new_user_horse_prepare() {
        $("#modal-add-user-horse").modal("show");
    }

    function new_owner_horse_prepare() {
        $('.chosen-container.chosen-select').attr('style','');
        change_country();
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
        api_query({
            qmethod: "POST",
            amethod: "add_user_owner",
            params:  $(form).serialize(),
            success: function (data) {
                new_horse_prepare();
                $("#modal-add-horse input.user_id").val(data);
            },
            fail:    "standart"
        });

        $("#modal-add-owner-horse").modal("hide");
    }
    function delete_user_horse(hid, element,id) {
        if (confirm("Вы действительно хотите удалить лошадь?")) {
            api_query({
                qmethod: "POST",
                amethod: "horses_user_delete",
                params:  {id : hid,uid:id},
                success: function (data) {
                    $(element).closest(".my-horse").remove();
                },
                fail:    "standart"
            })
        }
    }
    function search_user_horse() {
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
    }
    function select_owner_horse(el){
        var user_id = $(el).attr('alt');
        var $this = $(el).closest('.user-info-actions');
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
    }
    $(document).ready(function() {
        $(".chosen-select").chosen({
            no_results_text: "Не найдено по запросу",
            placeholder_text_single: "Выберите страну",
            inherit_select_classes: true
        });
        /*$('#modal-add-user-horse').on('click','.user_search_btn',function(){
            var find = $('#user_search').val();
            alert(1);
            api_query({
                qmethod: "POST",
                amethod: "user_horse_find",
                params: {q:find},
                success: function (data) {
                    $(".friends-list").html(data);
                },
                fail: "standart"
            })
        });*/

        /*$('body').on('click','.friends-list .select_user',function(){
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
        });*/
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
                    <input type="button" class="btn btn-warning span3 user_search_btn" value="Искать владельца" onclick="search_user_horse()"/>
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
                        <input type="hidden" name="admin_user_id" class="admin_user_id" value="">
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
                    <input type="text" class="span3 name_owner" name="fname" placeholder="Имя владельца">
                    <input type="text" class="span3 lname_owner" name="lname" placeholder="Фамилия владельца">
                </div>
            </div>
            <div class="row">
                <div class="controls controls-row">
                    <select name="country" class="chosen-country chosen-select span3" onchange="change_country(this);" style="width: 150px">
                        {foreach $countries as $country}
                            <option>{$country.country_name_ru}</option>
                        {/foreach}
                    </select>
                    <select class="chosen-city chosen-select span3" name="city">

                    </select>
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