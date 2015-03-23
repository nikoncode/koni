{* Smarty *}
{include "modules/header.tpl"}


<script src="/js/gallery.js"></script>
<script src="/js/comments.js"></script>

<script src="/js/chosen.jquery.min.js"></script>
<link  href="/css/chosen.css" rel="stylesheet">

{include "modules/modal-add-horse.tpl"}
{include "modules/modal-add-user-horse.tpl"}

{include "modules/modal-gallery-lightbox.tpl"}
{include "modules/modal-gallery-change-album.tpl"}
<script>
    {literal}
        /* Send to api function */
    function profile_edit(form) {
        api_query({
            qmethod: "POST",
            amethod: "auth_user_change",
            params: $(form).serialize(),
            success: function (data) {
                var mdl = $("#modal-info");
                mdl.find('#info-block').html(data[0]);
                mdl.modal("show");
                setTimeout(function(){
                    mdl.modal('hide');
                },4000);
            },
            fail: "standart"
        })
    }

    /* Autocomplete phone numbers */
    function change_country(select) {
        var city = $('#u_city').val();

        var country = $('.chosen-country option:selected').val();
        api_query({
            qmethod: "POST",
            amethod: "auth_get_city",
            params:  {country_id:country,city:city},
            success: function (response, data) {
                $('select.chosen-city').html(response);
                $('select.chosen-city option[value="'+city+'"]').prop('selected',true);
                $(".chosen-city").trigger("chosen:updated");
            },
            fail:    "standart"
        });
        /*phone = $("input[name=phone]");
         country = $(select).val();
         if (country == "Беларусь") phone.val("+375");
         else if(country == "Россия") phone.val("+7");
         else if(country == "Украина") phone.val("+380");
         else phone.val("");*/
    }
    $(document).ready(function()
    {
        $('input.password,input.password2').blur(function(){
            var psw = $('.password').val();
            var psw2 = $('.password2').val();
            if(psw != psw2) {
                $('.password').css('background','#D9534F');
                $('.password2').css('background','#D9534F');
            }else{
                $('.password').css('background','');
                $('.password2').css('background','');
            }
        });
        $('input.login').blur(function(){
            var login = $(this).val();
            api_query({
                qmethod: "POST",
                amethod: "auth_check_login",
                params:  {login:login},
                success: function (response, data) {
                    //alert(response[0]);
                },
                fail:    "standart"
            })
        });
        $('.spec').change(function(){
            var rank = false;
            $('.spec:checked').each(function(){
                if($(this).val() == 'Тренер' || $(this).val() == 'Спортсмен') rank = true;
            });
            if(rank){
                $('.rank').css('display','');
            }else{
                $('.rank option[value="0"]').prop('selected',true);
                $('.rank').css('display','none');
            }
        });
        $('.spec').change();
    });
    function edit_user(id){
        api_query({
            qmethod: "POST",
            amethod: "get_user_profile",
            params:  {id:id},
            success: function (response, data) {
                $('#profile').html(response.profile);
                $('#horses').html(response.horses);

                $('.admin_user_id').val(id);
                $(".chosen-select").chosen({no_results_text: "Не найдено по запросу",placeholder_text_single: "Выберите страну",inherit_select_classes: true});
                var city = $('#u_city').val();
                change_country();
                $('select.chosen-city option[value="'+city+'"]').prop('selected',true);
                $(".chosen-city").trigger("chosen:updated");
                $('#gallery').html(response.photos);
                $("[data-gallery-list]").each(function () {
                    gallery_initialize(this);
                });
            },
            fail:    "standart"
        });
    }
    function user_block(id,blocked){
        api_query({
            qmethod: "POST",
            amethod: "user_blocked",
            params:  {id:id,blocked:blocked},
            success: function (response, data) {
                alert('Сохранено');
            },
            fail:    "standart"
        });
    }
    function send_access(id,status,el){
        api_query({
            qmethod: "POST",
            amethod: "send_access",
            params:  {id:id,status:status},
            success: function (response, data) {
                if(status == 1){
                    $(el).closest('tr').addClass('access_sending');
                }else{
                    $(el).closest('tr').addClass('access_canceled');
                }
                alert(response);
            },
            fail:    "standart"
        });
    }
    {/literal}
</script>
<div class="container main-blocks-area adv-page adv-main-page">
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <div class="row">
                <ul id="advTab" class="nav nav-tabs new-tabs tabs2">
                    <li class="active"><a href="#users" data-toggle="tab">Люди</a></li>
                    <li><a href="#clubs" data-toggle="tab">Клубы</a></li>
                    <li><a href="#support" data-toggle="tab">Заявки</a></li>
                </ul>
            </div>
            <div id="advTabsContent" class="tab-content bg-white">
                <div class="tab-pane in active" id="users"><!-- для всадника -->
                    <form action="/admin/index.php" method="post">
                        <div class="row">
                            <div class="controls controls-row">
                                <input type="text" name="q" placeholder="Найти человека" class="span4" value="{$q_user}">
                                <input type="submit" name="search_u" value="Искать" class="span btn btn-warning">
                            </div>
                        </div>
                    </form>
                    <table class="table table-striped competitions-table ratings-table ratings-clubs">
                        <tr>
                            <th>ФИО</th>
                            <th>Страна, город</th>
                            <th>Данные</th>
                        </tr>
                        <tr><td></td><td></td>
                            <td width="550" rowspan="{$limit}">
                                <div class="row">
                                    <ul id="userTab" class="nav nav-tabs new-tabs tabs2">
                                        <li class="active"><a href="#profile" data-toggle="tab">Личные данные</a></li>
                                        <li><a href="#horses" data-toggle="tab">Лошади</a></li>
                                        <li><a href="#gallery" data-toggle="tab">Галерея</a></li>
                                    </ul>
                                    <div id="userTabsContent" class="tab-content bg-white">
                                        <div class="tab-pane in active" id="profile">

                                        </div>
                                        <div class="tab-pane" id="horses">

                                        </div>
                                        <div class="tab-pane" id="gallery">

                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        {foreach $users as $user}
                            <tr>
                                <td><a href="javascript:void(0)" alt="{$user.id}" onclick="edit_user({$user.id})">{$user.lname} {$user.fname}</a></td>
                                <td>{$user.country}, {$user.city}</td>
                            </tr>
                        {/foreach}
                    </table>
                    <nav>
                        <ul class="pagination">
                            {for $i = 1; $i< $users_count;$i++}
                                <li {if $i == $start_u}class="active"{/if}><a href="/admin/index.php?page_u={$i}#users">{$i}</a></li>
                            {/for}
                        </ul>
                    </nav>


                </div>

                <div class="tab-pane" id="clubs"><!-- для лошади -->
                    <form action="/admin/index.php#clubs" method="post">
                        <div class="row">
                            <div class="controls controls-row">
                                <input type="text" name="q" placeholder="Найти клуб" class="span4" value="{$q_club}">
                                <input type="submit" name="search_c" value="Искать" class="span btn btn-warning">
                            </div>
                        </div>
                    </form>
                    <table class="table table-striped competitions-table ratings-table ratings-clubs">
                        <tr>
                            <th>Название</th>
                            <th>Страна, город</th>
                        </tr>
                        {foreach $clubs as $club}
                            <tr>
                                <td><a href="/club-admin.php?id={$club.id}">{$club.name}</a></td>
                                <td>{$club.country}, {$club.city}</td>
                            </tr>
                        {/foreach}
                    </table>
                    <nav>
                        <ul class="pagination">
                            {for $i = 1; $i< $clubs_count;$i++}
                                <li {if $i == $start_c}class="active"{/if}><a href="/admin/index.php?page_c={$i}#clubs">{$i}</a></li>
                            {/for}
                        </ul>
                    </nav>
                </div>
                <div class="tab-pane" id="support"><!-- для лошади -->
                    <table class="table table-striped competitions-table ratings-table ratings-clubs">
                        <tr>
                            <th>Имя<br/>Фамилия</th>
                            <th>E-mail</th>
                            <th>Телефон</th>
                            <th>Город</th>
                            <th>Текст сообщения</th>
                            <th>Действие</th>
                        </tr>
                        {foreach $support as $row}
                            <tr class="{if $row.status == 1}access_sending{/if}{if $row.status == 2}access_canceled{/if}">
                                <td>{$row.name}<br/>{$row.lname}</td>
                                <td>{$row.email}</td>
                                <td>{$row.phone}</td>
                                <td>{$row.city}</td>
                                <td>{$row.message}</td>
                                <td>
                                    <a href="javascript:void(0)" class="btn btn-warning" onclick="send_access({$row.id},1,this)">Отправить доступ</a><br/>
                                    <a href="javascript:void(0)" class="btn btn-danger" onclick="send_access({$row.id},2,this)">Отказать</a>
                                </td>
                            </tr>
                        {/foreach}
                    </table>
                    <nav>
                        <ul class="pagination">
                            {for $i = 1; $i< $support_count;$i++}
                                <li {if $i == $start_s}class="active"{/if}><a href="/admin/index.php?page_s={$i}#support">{$i}</a></li>
                            {/for}
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>


</div>
{include "modules/footer.tpl"}