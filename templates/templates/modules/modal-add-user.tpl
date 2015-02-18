{literal}
    <script>
        /* Send to api function */
        function sign_up(form) {
            api_query({
                qmethod: "POST",
                amethod: "auth_register_admin",
                params:  $(form).serialize(),
                success: function (data) {
                    var fio = $(form).find('input[name="lname"]').val()+' '+$(form).find('input[name="fname"]').val();
                    $('select.user_id').append('<option value="'+data+'">'+fio+'</option>');
                    $('select.user_id').trigger("chosen:updated");
                    $('#modal-add-user').modal("hide");
                    $('#modal-add-user input[type="text"]').val("");
                    $('#modal-add-user .horses').html("");
                    $('#modal-add-user select option:first-child').prop("selected",true);
                    $("#modal-add-user .chosen-select").trigger("chosen:updated");
                },
                fail:    "standart"
            })
        }

        function add_member(form) {
            api_query({
                qmethod: "POST",
                amethod: "add_member_admin",
                params:  $(form).serialize(),
                success: function (data) {
                    var fio = $(form).find('input[name="lname"]').val()+' '+$(form).find('input[name="fname"]').val();
                    change_riders_ordering();
                    location.reload();
                },
                fail:    "standart"
            })
        }

        /* Autocomplete phone numbers */
        function change_country(select) {
            var country = $('.chosen-country option:selected').val();
            api_query({
                qmethod: "POST",
                amethod: "auth_get_city",
                params:  {country_id:country},
                success: function (response, data) {
                    $('select.chosen-city').html('<option value="0"></option>'+response);
                    $(".chosen-city").trigger("chosen:updated");
                },
                fail:    "standart"
            })
        }
        $(document).ready(function()
        {
            $("#modal-add-user .chosen-select").chosen({no_results_text: "Не найдено по запросу",placeholder_text_single: "Не выбрано",inherit_select_classes: true,search_contains: true,width:'150px'});
            $("#modal-add-user .chosen-select").css('width','150px');
            change_country();
        });
    </script>
{/literal}
<div id="modal-add-user" class="modal hide modal900" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавление карточки пользователя</h3>
    </div>
    <div class="modal-body" style="overflow-y: visible">
        <form method="post" action="#" onsubmit="sign_up(this);return false;">
            <div class="row">
                <div class="span7" style="border-right: 1px solid">
                    <div class="controls controls-row">
                        <label class="span7">ФИО: <span class="req">*</span></label>
                        <input type="text" class="span3" placeholder="Имя" name="fname">
                        <input type="text" class="span3" placeholder="Фамилия" name="lname"> <br/>
                        <div class="span6"><input type="text" placeholder="Отчество" name="mname"> (не обязательно)</div>
                    </div>

                    <div class="controls controls-row">
                        <label class="span12">Клуб: <span class="req">*</span></label>
                        <select class="span3 chosen-select cid" name="cid">
                            <option value="0">Частный владелец</option>
                            {foreach $clubs as $club}
                                <option value="{$club.id}">{$club.name}</option>
                            {/foreach}
                        </select>
                        <input type="button" value="Создать клуб" href="#createClub" class="span2" data-toggle="modal" onclick="hide_modal('#modal-add-user')">
                        <select class="span2 rank" name="rank">
                            {foreach $const_rank as $key=>$rank}
                                <option value="{$key}">{$rank}</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="controls controls-row">
                        <label class="span7">Дата рождения</label>
                        <input type="text" class="span2" placeholder="День" name="bday">
                        <select class="span2" name="bmounth">
                            {foreach $const_mounth as $mounth}
                                <option value="{$mounth@key}">{$mounth}</option>
                            {/foreach}
                        </select>
                        <input type="text" class="span2" placeholder="Год" name="byear">
                    </div>

                    <div class="controls controls-row" style="overflow: visible">
                        <label class="span6">Контактные данные</label>
                        <label class="span6"><small class="muted">Прим: все ваши контактные данные конфиденциальны, нужны лишь для удобства пользования сайтом и не передаются третьим лицам.</small></label>
                        <select class="span3 chosen-country chosen-select" name="country" onchange="change_country(this);">
                            {foreach $const_countries as $country}
                                <option value="{$country.id}">{$country.country_name_ru}</option>
                            {/foreach}
                        </select>
                        <select class="span3 chosen-city chosen-select" name="city">

                        </select>
                        <input type="hidden" class="span3" placeholder="Номер телефона *" name="phone" value="+7111111111">
                    </div>
                </div>
                <div class="span4">
                    <strong>Лошади</strong>
                    <a class="add_horse btn" href="javascript:void(0)">+</a>
                    <ul class="horses">

                    </ul>
                </div>


                <input name="work[]" type="checkbox" value="Спортсмен" checked="checked" style="display: none">

            </div>
            <hr/>
            <div class="row">
                <div class="controls controls-row">
                    <center><button type="submit" name="reg-submit" class="btn btn-warning">Зарегистрировать</button></center>
                </div>
            </div>


        </form>
    </div>
</div>
<div id="modal-add-member" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавление участника</h3>
    </div>
    <div class="modal-body" style="overflow-y: visible">
        <form method="post" action="#" onsubmit="add_member(this);return false;">
            <div class="controls controls-row">
                <select name="rid" style="width: 140px">
                    <option value="0">Выбрать Маршрут</option>
                    {foreach $comp.routes as $route}
                        <option value="{$route.id}">{$route.name}</option>
                    {/foreach}
                </select>
            </div>
            <div class="controls controls-row">
                <select name="uid" style="width: 140px" class="chosen-select user_id">
                    <option value="0">Выбрать всадника</option>
                    {foreach $users as $usr}
                        <option value="{$usr.id}">{$usr.lname} {$usr.fname}, {$usr.bdate}, {$usr.city}</option>
                    {/foreach}
                </select>
                <a href="#modal-add-user" data-toggle="modal" class="btn btn-warning">Создать всадника</a>
            </div>


            <div class="controls controls-row">
                <select name="hid" class="horse" style="width: 80px">
                    {foreach $res.horses as $horse}
                        <option value="{$horse.id}">{$horse.nick}</option>
                    {/foreach}
                </select>
                <a href="javascript:void(0)" class="add_horse">+</a>
            </div>
            <hr/>
            <div class="row">
                <div class="controls controls-row">
                    <center><button type="submit" name="reg-submit" class="btn btn-warning">Добавить</button></center>
                </div>
            </div>


        </form>
    </div>
</div>
<script>
    function create_club(form) {
        var accept = $('#createClub .accept:checked').size();
        if(accept == 0) {
            alert('Перед созданием клуба, вы должны подтвердить, что являетесь уполномоченным лицом!');
            return false;
        }
        api_query({
            qmethod: "POST",
            amethod: "club_create",
            params: $(form).serialize(),
            success: function (id) {
                var name = $(form).find('input[name="name"]').val();
                $('select.cid').append('<option value="'+id+'">'+name+'</option>');
                $('select.cid').trigger("chosen:updated");
                $('#createClub').modal("hide");
                show_modal('#modal-add-user');
            },
            fail: function (err) { //our modal not working
                console.log(err);
                var errs = "";
                for (i=0;i<err.length;++i)
                    errs += err[i] + "\n";
                alert(errs);
            }
        })

    }

    function show_modal(modal){

        $(modal).modal('show');
    }
    function hide_modal(modal){
        $(modal).modal('hide');
    }
    function edit_horse(el){
        var mdl = $('#modal_add_horse');
        $(el).closest('li').find('input').each(function(){
            var name = $(this).attr('class');
            var val = $(this).val();
            mdl.find('[name="'+name+'"]').val(val);
        });
        $('#modal_add_horse').modal("show");
    }
    function delete_horse(el){
        $(el).closest('li').remove();
    }
</script>
<div id="createClub" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="show_modal('#modal-add-user')">×</button>
        <h3 >Создать клуб</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" action="#" onsubmit="create_club(this); return false;">
            <div class="controls controls-row">
                <label class="span6">Название клуба</label>
                <input type="text" class="span6" placeholder="Введите название своего клуба" name="name">
            </div>
            <div class="controls controls-row">
                <label class="span6">Ваш контактный телефон</label>
                <input type="text" class="span6" name="phone"  placeholder="Для подтверждения Вашего статуса" value="+7">
            </div>
            <div class="controls controls-row">
                <label class="checkbox span6">
                    <input type="checkbox" class="accept" name="accept"> Да, я являюсь уполномоченным лицом от клуба
                </label>
            </div>
            <div class="controls controls-row">
                <button type="submit" class="btn btn-warning span3">Создать клуб</button>
                <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
            </div>
        </form>
    </div>
</div>