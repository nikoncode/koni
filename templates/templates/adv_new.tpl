{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<link rel="stylesheet" href="css/chosen.css">
{literal}
<script>
    $(function(){
        $(".chosen-select").chosen()
    });
    $(function () {
        $("#gallery-upl").fileupload({
            url: "/api/api.php?m=adv_upload_photo",
            dataType: "json",
            done: function (e, data) {
                resp = data.result;
                console.log(resp);
                if (resp.type == "success") {
                    $('<li class="adv-card"><input type="text" style="display: none" name="photo[]" value="' + resp.response.id + '"> \
                    <div class="img-adv"><img src="'+ resp.response.preview +'"></div> \
                    <button type="submit" class="btn btn-warning">Заменить фото</button> \
                    <button type="submit" class="btn" onclick="photo_delete(this, ' + resp.response.id + '); return false;">Удалить</button> \
                    </li>').appendTo(".adv-list");
                } else {
                    alert(resp.response[0]);
                }
            }, progressall: function (e, data) {
                $('.progress .bar').css('display', 'block');
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('.progress .bar').css('width', progress + '%');
                if(progress == 100) $('.progress .bar').css('display', 'none');
            }
        });
    });
    function add_adv(){
        api_query({
            qmethod: "POST",
            amethod: "add_adv",
            params:  $('#add_adv_form').serialize(),
            success: function (response, data) {
                document.location.href = data.redirect;
            },
            fail:    "standart"
        })
    }
    function change_country(select) {
        var country = $('.country option:selected').val();
        api_query({
            qmethod: "POST",
            amethod: "auth_get_city",
            params:  {country_id:country},
            success: function (response, data) {
                $('select.city').html(response);
            },
            fail:    "standart"
        })
        country = $(select).val();
    }
    function photo_delete(element, photo_id) {
        api_query({
            qmethod: "POST",
            amethod: "adv_photo_delete",
            params: {id : photo_id},
            success: function (resp) {
                $(element).closest(".adv-card").remove();
            },
            fail: "standart"
        })
    }
</script>
{/literal}
<div class="container main-blocks-area adv-page adv-new-page">
    <!-- implement fileupload -->
    <script src="js/upload/jquery.ui.widget.js"></script>
    <script src="js/upload/jquery.iframe-transport.js"></script>
    <script src="js/upload/jquery.fileupload.js"></script>
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <h3 class="inner-bg">Новое объявление о продаже лошади<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>


            <div class="row">
                <form class="search-filter" id="add_adv_form">
                    <input type="hidden" name="usage" value="{$usage}">
                    <input type="hidden" name="type" value="{$type}">
                    <div class="span3 search-filter-block">

                        <label>Кличка</label>
                        <input type="text" name="nick" class="span3" value="{$horse.nick}">

                        <label>Порода</label>
                        <select name="poroda" class="span3">
                            {foreach $porodi as $poroda}
                                <option value="{$poroda}" {if $poroda == $horse.poroda} selected="selected" {/if}>{$poroda}</option>
                            {/foreach}
                        </select>

                        <label>Масть</label>
                        <select name="mast" class="span3">
                            {foreach $masti as $mast}
                                <option value="{$mast}" {if $mast == $horse.mast} selected="selected" {/if}>{$mast}</option>
                            {/foreach}
                        </select>

                        <label>Год рождения</label>
                        <input type="text" name="age" class="span3" value="{$horse.byear}">
                    </div>


                    <div class="span3 search-filter-block">
                        <label>Цена</label>
                        <input type="text" name="price" class="span3">

                        <label>Рост</label>
                        <input type="text" name="height" class="span3" value="{$horse.rost}">

                        <label>Пол</label>
                        <ul class="inline unstyled" id="horse-sex">
                            {foreach $sexs as $sex}
                                <li><label class="radio"><input type="radio" name="sex" value="{$sex}" {if $sex == $horse.sex} checked="checked" {/if}> {$sex}</label></li>
                            {/foreach}
                        </ul>

                        <label>&nbsp;</label>
                        <label class="checkbox"><input name="in_chemp" type="checkbox"> Участие в соревнованиях</label>
                    </div>


                    <div class="span6 search-filter-block">
                        <div class="row">

                            <div class="span3">
                                <label>Страна</label>
                                <select name="country" class="country span3" onchange="change_country(this);">
                                    <option value="0">Все страны</option>
                                    {foreach $countries as $country}
                                        <option value="{$country.id}">{$country.country_name_ru}</option>
                                    {/foreach}
                                </select>
                            </div>



                            <div class="span3">
                                <label>Город</label>
                                <select name="city" class="span3 city">
                                    <option value="0">Все города</option>
                                </select>
                            </div>

                            <div class="span6">
                                <label>Специализация</label>
                                <select class="span6 chosen-select" name="spec[]" multiple data-placeholder=" ">
                                    {foreach $specs as $spec}
                                        <option value="{$spec}" {if $spec == $horse.spec} selected="selected" {/if}>{$spec}</option>
                                    {/foreach}
                                </select>

                            </div>

                            <div class="span6">
                                <label>Расскажите о лошади</label>
                                <textarea rows="6" name="descr" class="span6">{$horse.about}</textarea>
                            </div>

                        </div>
                    </div>

                    <div class="span12 search-filter-block">
                        <label>Фотографии (5 шт. максимум)</label>
                        <ul class="adv-list">

                            <li class="add-new-adv">
                                <div class="fileupload" style="height: auto">
                                    <input type="file" name="gallery" id="gallery-upl" multiple>
                                    <a href="#" role="button"><img src="images/btn-add-new-adv-photo.png"></a>
                                </div>
                                <div class="progress progress-striped active" style="display: none">
                                    <div class="bar" style="width: 0%;"></div>
                                </div>
                            </li>

                        </ul>
                    </div>

                    <div class="span12">

                        <a href="#" class="span4 btn btn-warning btn-large offset2" onclick="add_adv()">Добавить объявление</a>
                        <a href="adv.php" class="span4 btn btn-large" />Отменить</a>
                    </div>
                </form>
            </div>
        </div>



    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}