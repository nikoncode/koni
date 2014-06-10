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
</script>
{/literal}
<div class="container main-blocks-area adv-page adv-new-page">
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <h3 class="inner-bg">Новое объявление о продаже лошади<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>


            <div class="row">
                <form class="search-filter" id="add_adv_form">
                    <input type="hidden" name="usage" value="{$usage}">
                    <input type="hidden" name="type" value="{$type}">
                    <div class="span3 search-filter-block">

                        <label>Кличка</label>
                        <input type="text" name="nick" class="span3">

                        <label>Порода</label>
                        <select name="poroda" class="span3">
                            {foreach $porodi as $poroda}
                                <option value="{$poroda}">{$poroda}</option>
                            {/foreach}
                        </select>

                        <label>Масть</label>
                        <select name="mast" class="span3">
                            {foreach $masti as $mast}
                                <option value="{$mast}">{$mast}</option>
                            {/foreach}
                        </select>

                        <label>Год рождения</label>
                        <input type="text" name="age" class="span3">
                    </div>


                    <div class="span3 search-filter-block">
                        <label>Цена</label>
                        <input type="text" name="price" class="span3">

                        <label>Рост</label>
                        <input type="text" name="height" class="span3">

                        <label>Пол</label>
                        <ul class="inline unstyled" id="horse-sex">
                            {foreach $sexs as $sex}
                                <li><label class="radio"><input type="radio" name="sex" value="{$sex}"> {$sex}</label></li>
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
                                <select class="span6 chosen-select" name="spec" multiple data-placeholder=" ">
                                    {foreach $specs as $spec}
                                        <option value="{$spec}">{$spec}</option>
                                    {/foreach}
                                </select>

                            </div>

                            <div class="span6">
                                <label>Расскажите о лошади</label>
                                <textarea rows="6" name="descr" class="span6"></textarea>
                            </div>

                        </div>
                    </div>

                    <div class="span12 search-filter-block">
                        <label>Фотографии (5 шт. максимум)</label>
                        <ul class="adv-list">
                            <li class="adv-card">
                                <div class="img-adv"><img src="i/avatar-my-horse-1.jpg"></div>
                                <form>
                                    <button type="submit" class="btn btn-warning">Заменить фото</button>
                                    <button type="submit" class="btn">Удалить</button>
                                </form>
                            </li><li class="adv-card">
                                <div class="img-adv"><img src="i/avatar-my-horse-2.jpg"></div>
                                <form>
                                    <button type="submit" class="btn btn-warning">Заменить фото</button>
                                    <button type="submit" class="btn">Удалить</button>
                                </form>
                            </li>
                            <li class="adv-card">
                                <div class="img-adv"><img src="i/avatar-my-horse-3.jpg"></div>
                                <form>
                                    <button type="submit" class="btn btn-warning">Заменить фото</button>
                                    <button type="submit" class="btn">Удалить</button>
                                </form>
                            </li>
                            <li class="adv-card">
                                <div class="img-adv"><img src="i/avatar-my-horse-1.jpg"></div>
                                <form>
                                    <button type="submit" class="btn btn-warning">Заменить фото</button>
                                    <button type="submit" class="btn">Удалить</button>
                                </form>
                            </li>
                            <li class="add-new-adv">
                                <a href="#modal-add-adv-card" role="button" data-toggle="modal"><img src="images/btn-add-new-adv-photo.png"></a>
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