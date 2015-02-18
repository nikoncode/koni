{* Smarty *}
{include "modules/header.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
<script>
    {literal}
    function club_search() {
        var period = $('#rate-club #rct-by-peoples .period:checked').val();
        var country = $('#rate-club #rct-by-peoples .country option:selected').val();
        var city = $('#rate-club #rct-by-peoples .city option:selected').val();
        api_query({
            qmethod: "POST",
            amethod: "rating_search",
            params: {period:period,country:country,city:city},
            success: function (data) {
                $(".rating_row ").remove();
                $(".ratings-clubs tbody").append(data.rendered);
            },
            fail: "standart"
        })
    }
    function change_country(select) {
        var country = $(select).find('option:selected').attr('country_id');
        var type = $(select).attr('alt');
        api_query({
            qmethod: "POST",
            amethod: "auth_get_city",
            params:  {country_id:country},
            success: function (response, data) {
                var values = '<option value="0">Все города</option>'+response;
                if(type == 'clubs'){
                    $('#rate-club select.city').html(values);
                    $('#rate-club select.city option').each(function(){
                        if($(this).html() != "Все города") $(this).val($(this).html());
                    });
                    club_search();
                }else if(type=='users'){
                    $('#rate-sportsmans select.city').html(values);
                    $('#rate-sportsmans select.city option').each(function(){
                        if($(this).html() != "Все города") $(this).val($(this).html());
                    });
                    users_search();
                }

                //$('select.city').trigger("chosen:updated");
            },
            fail:    "standart"
        })
        country = $(select).val();

    }

    function users_search(){
        var period = $('#rate-sportsmans #rct-by-peoples .period:checked').val();
        var vozrast = $('#rate-sportsmans .age-filter li.active').attr('alt');
        var height = $('#rate-sportsmans .choose-height li.active h5').html() || '';
        var country = $('#rate-sportsmans .country option:selected').val() || '';
        var city = $('#rate-sportsmans .city option:selected').val() || '';
        api_query({
            qmethod: "POST",
            amethod: "rating_search_users",
            params: {period:period,vozrast:vozrast,height:height,country:country,city:city},
            success: function (data) {
                $(".rating_user_row ").remove();
                $(".rating-sportsmans tbody").append(data.rendered);
            },
            fail: "standart"
        })
    }

    $(function(){
       $('.age-filter li').click(function(){
           var vozrast = $(this).attr('alt');
           $('.age-filter li.active').removeClass('active');
           $(this).addClass('active');
           if(vozrast != 'all'){
               $('.choose-height').css('display','none');
               $('.choose-height.'+vozrast).css('display','');
           }else{
               $('.choose-height').css('display','none');
           }
           $('.choose-height li.active').removeClass('active');
           users_search();
       });
        $('.choose-height li').click(function(){
           $('.choose-height li.active').removeClass('active');
           $(this).addClass('active');
            users_search();
       });
    });
    {/literal}
    users_search();
    club_search();
</script>
<div class="container ratings-page main-blocks-area ratings-block">
<div class="row">

<div class="span12 lthr-bgborder block ratings-main-tabs">
<h3 class="inner-bg">Статистика</h3>
<div class="row">

<ul id="rateNav" class="nav nav-tabs new-tabs tabs2">
    <li class="active"><a href="#rate-club" data-toggle="tab">Клубы</a></li>
    <li><a href="#rate-sportsmans" data-toggle="tab">Спортсмены</a></li>
    <li><a href="#rate-horses" data-toggle="tab" style="display: none">Лошади</a></li>
    <li><a href="#rate-horsebreeder" data-toggle="tab" style="display: none">Коневоды</a></li>
    <li><a href="#rate-roughrider" data-toggle="tab" style="display: none">Бирейторы</a></li>
</ul>

<div id="rateNavContent" class="tab-content bg-white">

<div class="tab-pane in active" id="rate-club">
    <div class="row">
        <div class="span12 no-mrg">
            <div class= "row">
                <div class= "span3"><hr class="nav-btns"></div>
                <div class= "span6">
                    <ul  id="rate-club-type" class="nav nav-tabs nav-btns">
                        <li><a href="#rct-by-compt" data-toggle="tab">По соревнованиям</a></li>
                        <li class="active"><a href="#rct-by-peoples" data-toggle="tab">Народный рейтинг</a></li>
                    </ul>
                </div>
                <div class= "span3"><hr class="nav-btns"></div>
            </div>
            <div id="rate-club-type-Content" class="tab-content">
                <div class="tab-pane" id="rct-by-compt"> <!-- таб -->
                    <div class="row">
                        <div class="span6">
                            <label>Период</label>
                            <div class="btn-group" data-toggle="buttons-radio">
                                <button type="button" class="btn active">Общий за всё время</button>
                                <button type="button" class="btn">За 12 месяцев</button>
                                <button type="button" class="btn">Выбрать год <b class="caret"></b></button>
                            </div>
                        </div>
                        <div class="span6 search-filter-block">
                            <label>Уровень</label>
                            <ul class="inline">
                                <li><label class="radio"><input type="radio" name="lvl" value="1" checked>Национальный</label></li>
                                <li><label class="radio"><input type="radio" name="lvl" value="2">Международный</label></li>
                            </ul>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Страна</label>
                            <select class="span3" name="country">
                                <option>Россия</option>
                                <option>Беларусь</option>
                                <option>Украина</option>
                            </select>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Город</label>
                            <select class="span3" name="city">
                                <option>Москва</option>
                                <option>Минск</option>
                                <option>Киев</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="tab-pane in active" id="rct-by-peoples">  <!-- таб -->
                    <div class="row">
                        <div class="span6">
                            <label>Период</label>
                            <div class="btn-group" data-toggle="buttons-radio">
                                <label  class="btn active">Общий за всё время<input type="radio" name="period" value="0" class="period" style="display: none" checked="checked" onchange="club_search()"></label>
                                <label type="button" class="btn">За 12 месяцев<input type="radio" name="period" value="12" class="period" style="display: none" onchange="club_search()"></label>
                                <button type="button" class="btn">Выбрать год <b class="caret"></b></button>
                            </div>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Страна</label>
                            <select  class="span3 country chosen-select" name="country" alt="clubs" onchange="change_country(this);">
                                <option selected="" value="">Не важно</option>
                                {foreach $countries as $country}
                                    <option country_id="{$country.id}" value="{$country.country_name_ru}">{$country.country_name_ru}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Город</label>
                            <select name="city" class="span3 city chosen-select" onchange="club_search()">
                                <option value="">Все города</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <table class="table table-striped competitions-table ratings-table ratings-clubs">
            <tbody><tr>
                <th>№</th>
                <th>Клуб</th>
                <th>Город</th>
                <th class="text-right">Участники</th>
                <th class="text-right">Кол-во баллов</th>
            </tr>


            {assign var="i" value="1"}
            {foreach $clubs as $club}
                <tr class="rating_row">
                    <td class="rt-n">{$i++}</td>
                    <td class="rt-club"><a href="club.php?id={$club.cid}"><img src="{$club.avatar}">{$club.name}</a></td>
                    <td class="rt-city">{$club.address}</td>
                    <td class="rt-members">{$club.members}  чел.</td>
                    <td class="rt-points">{$club.rating|round:2}</td>
                </tr>
            {/foreach}

            </tbody>

        </table>

    </div>
</div> <!-- //rate-club -->


<div class="tab-pane" id="rate-sportsmans">
    <div class="row">
        <div class="span12 no-mrg">

            <div class="tab-pane" id="rct-by-peoples">  <!-- таб -->
                <div class="row">
                    <div class="span6">
                        <label>Период</label>
                        <div class="btn-group" data-toggle="buttons-radio">
                            <label  class="btn active">Общий за всё время<input type="radio" name="period" value="0" class="period" style="display: none" checked="checked" onchange="users_search()"></label>
                            <label type="button" class="btn">За 12 месяцев<input type="radio" name="period" value="12" class="period" style="display: none" onchange="users_search()"></label>
                            <button type="button" class="btn">Выбрать год <b class="caret"></b></button>
                        </div>
                    </div>
                    <div class="span6 search-filter-block">
                        <label>Уровень</label>
                        <ul class="inline">
                            <li><label class="radio"><input type="radio" name="lvl" value="1" checked>Национальный</label></li>
                            <li><label class="radio"><input type="radio" name="lvl" value="2">Международный</label></li>
                        </ul>
                    </div>
                    <div class="span8 search-filter-block">
                        <label>Возрастная группа</label>
                        <ul class="inline choose-age age-filter">
                            <li class="active" alt="all"><h5>Все возрасты</h5><small>возраст не учитывается</small></li>
                            <li alt="lubiteli"><h5>Любители</h5><small>&nbsp;</small></li>
                            <li alt="vzroslie"><h5>Взрослые</h5><small>от 22 лет</small></li>
                            <li alt="uniori"><h5>Юниоры</h5><small>19 - 22 лет</small></li>
                            <li alt="unoshi"><h5>Юноши</h5><small>15 - 19 лет</small></li>
                            <li alt="deti"><h5>Дети</h5><small>до 15 лет</small></li>
                        </ul>
                        <ul class="inline choose-age choose-height deti" style="display: none">
                            <li><h5>60</h5></li>
                            <li><h5>80</h5></li>
                            {assign var = "height" value="90"}
                            {while $height <= 140}
                                <li><h5>{$height}</h5></li>
                                {$height = $height + 5}
                            {/while}
                        </ul>
                        <ul class="inline choose-age choose-height unoshi" style="display: none">
                            {assign var = "height" value="110"}
                            {while $height <= 145}
                                <li><h5>{$height}</h5></li>
                                {$height = $height + 5}
                            {/while}
                        </ul>
                        <ul class="inline choose-age choose-height uniori" style="display: none">
                            {assign var = "height" value="110"}
                            {while $height <= 160}
                                <li><h5>{$height}</h5></li>
                                {$height = $height + 5}
                            {/while}
                        </ul>
                        <ul class="inline choose-age choose-height vzroslie" style="display: none">
                            {assign var = "height" value="120"}
                            {while $height <= 170}
                                <li><h5>{$height}</h5></li>
                                {$height = $height + 5}
                            {/while}
                        </ul>
                        <ul class="inline choose-age choose-height lubiteli" style="display: none">
                            {assign var = "height" value="60"}
                            {while $height <= 125}
                                <li><h5>{$height}</h5></li>
                                {$height = $height + 5}
                            {/while}
                        </ul>
                    </div>
                    <div class="span2 search-filter-block">
                        <label>Страна</label>
                        <select  class="span2 country chosen-select" name="country" alt="users" onchange="change_country(this);">
                            <option selected="" value="">Не важно</option>
                            {foreach $countries as $country}
                                <option country_id="{$country.id}" value="{$country.country_name_ru}">{$country.country_name_ru}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="span2 search-filter-block">
                        <label>Город</label>
                        <select name="city" class="span2 city chosen-select" onchange="users_search()">
                            <option value="">Все города</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <table class="table table-striped competitions-table ratings-table rating-sportsmans">
            <tbody><tr>
                <th>№</th>
                <th>Имя Фамилия</th>
                <th>Год рождения</th>
                <th>Город</th>
                <th class="text-right">Клуб</th>
                <th class="text-right">Кол-во баллов</th>
            </tr>

            </tbody>
        </table>

    </div>
</div> <!-- //rate-sportsmans -->


<div class="tab-pane" id="rate-sportsmans">
    <div class="row">

    </div>
</div> <!-- //rate-sportsmans -->


<div class="tab-pane" id="rate-horsebreeder">
    <div class="row">

    </div>
</div> <!-- //rate-horsebreeder -->


<div class="tab-pane" id="rate-roughrider">
    <div class="row">

    </div>
</div> <!-- //rate-roughrider -->

</div>
</div>
</div>

</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}