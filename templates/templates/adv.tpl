{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script>
    $(function() {
        $( "#adv-price" ).slider({
            range: true,
            min: 1,
            max: 1000000,
            values: [ 1, 1000000 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " руб.";
                $('#price_from').val(ui.values[ 0 ]);
                $('#price_to').val(ui.values[ 1 ]);
                document.getElementById('adv-price-amount').innerHTML = CustomAmount;
            }
        });
        var startAmount =   "От " + $( "#adv-price" ).slider( "values", 0 ) +
                " до " + $( "#adv-price" ).slider( "values", 1 ) + " руб.";
        $('#price_from').val($( "#adv-price" ).slider( "values", 0 ));
        $('#price_to').val($( "#adv-price" ).slider( "values", 1 ));
        document.getElementById('adv-price-amount').innerHTML = startAmount;
    }  );

    $(function() {
        $( "#adv-age" ).slider({
            range: true,
            min: 0,
            max: 50,
            values: [ 0, 50 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " лет";
                $('#age_from').val(ui.values[ 0 ]);
                $('#age_to').val(ui.values[ 1 ]);
                document.getElementById('adv-age-amount').innerHTML = CustomAmount;
            }
        });
        var startAmount =   "От " + $( "#adv-age" ).slider( "values", 0 ) +
                " до " + $( "#adv-age" ).slider( "values", 1 ) + " лет";
        $('#age_from').val($( "#adv-age" ).slider( "values", 0 ));
        $('#age_to').val($( "#adv-age" ).slider( "values", 1 ));
        document.getElementById('adv-age-amount').innerHTML = startAmount;
    } );


    $(function() {
        $( "#adv-height" ).slider({
            range: true,
            min: 50,
            max: 200,
            values: [ 50, 200 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " см.";
                $('#height_from').val(ui.values[ 0 ]);
                $('#height_to').val(ui.values[ 1 ]);
                document.getElementById('adv-height-amount').innerHTML = CustomAmount;
            }
        });
        var startAmount =   "От " + $( "#adv-height" ).slider( "values", 0 ) +
                " до " + $( "#adv-height" ).slider( "values", 1 ) + " см.";
        $('#height_from').val($( "#adv-height" ).slider( "values", 0 ));
        $('#height_to').val($( "#adv-height" ).slider( "values", 1 ));
        document.getElementById('adv-height-amount').innerHTML = startAmount;
    } );
</script>
{literal}
    <script>
        function search(){
            api_query({
                qmethod: "POST",
                amethod: "find_adv",
                params:  $('#find_horses').serialize(),
                success: function (data) {
                    if(data == ''){
                        $('#search-results').html('<div class="text-center"><strong>Ничего не найдено</strong></div>');
                    }else{
                        $('#search-results').html(data);
                    }

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
<link rel="stylesheet" href="css/range.css">

<div class="container main-blocks-area adv-page adv-main-page">
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <h3 class="inner-bg">Объявления<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>

            <div class="row">
                <ul id="advTab" class="nav nav-tabs new-tabs tabs2">
                    <li class="active"><a href="#adv-tab1" data-toggle="tab">Лошади</a></li>
                    <li><a href="#adv-tab2" data-toggle="tab">Корма</a></li>
                    <li><a href="#adv-tab3" data-toggle="tab">Траспорт</a></li>
                    <li><a href="#adv-tab4"data-toggle="tab">Для всадника</a></li>
                    <li><a href="#adv-tab5"data-toggle="tab">Для лошади</a></li>
                    <li><a href="#adv-tab6"data-toggle="tab">Для конюшни</a></li>
                    <li><a href="#adv-tab7"data-toggle="tab">Ветеринару</a></li>
                    <li><a href="#adv-tab8"data-toggle="tab">Сувениры</a></li>
                </ul>
            </div>

            <div id="advTabsContent" class="tab-content">
                <div class="tab-pane in active" id="adv-tab1">
                    <div class="row">
                        <form class="search-filter" id="find_horses">
                            <input type="hidden" name="usage" value="1">
                            <div class="span3 search-filter-block">
                                <label>Тип объявления</label>
                                <select name="type" class="span3">
                                    <option value="1">Покупка</option>
                                    <option value="2">Продажа</option>
                                    <option value="3">Аренда</option>
                                </select>

                                <label>Страна</label>
                                <select name="country" class="span3 country" onchange="change_country(this);">
                                    <option value="0">Все страны</option>
                                    {foreach $countries as $country}
                                        <option value="{$country.id}">{$country.country_name_ru}</option>
                                    {/foreach}
                                </select>

                                <label>Город</label>
                                <select name="city" class="span3 city">
                                    <option>Все города</option>
                                </select>

                                <div class="range-block">
                                    <label>Цена</label>
                                    <div id="adv-price" class="xxx"></div>
                                    <div id="adv-price-amount" class="range-amount"></div>
                                    <input type="hidden" name="price_from" id="price_from">
                                    <input type="hidden" name="price_to" id="price_to">
                                </div>
                            </div>


                            <div class="span3 search-filter-block">
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

                                <label>Кличка</label>
                                <input type="text" class="span3">

                                <label>Специализация</label>
                                <select name="spec" class="span3">
                                    {foreach $specs as $spec}
                                        <option value="{$spec}">{$spec}</option>
                                    {/foreach}
                                </select>
                            </div>


                            <div class="span3 search-filter-block">
                                <label>Возраст</label>
                                <div id="adv-age"></div>
                                <div id="adv-age-amount" class="range-amount"></div>
                                <input type="hidden" name="age_from" id="age_from">
                                <input type="hidden" name="age_to" id="age_to">

                                <label>Рост</label>
                                <div id="adv-height"></div>
                                <div id="adv-height-amount" class="range-amount"></div>
                                <input type="hidden" name="height_from" id="height_from">
                                <input type="hidden" name="height_to" id="height_to">


                                <label>Пол</label>
                                <ul class="inline unstyled" id="horse-sex">
                                    {foreach $sexs as $sex}
                                        <li><label class="radio"><input type="radio" name="sex" value="{$sex}"> {$sex}</label></li>
                                    {/foreach}
                                </ul>

                                <label>&nbsp;</label>
                                <label class="checkbox"><input type="checkbox" name="in_chemp" id="in_chemp"> Участие в соревнованиях</label>
                            </div>



                            <div class="span3">
                                <label class="checkbox"><input type="checkbox" name="premium" id="premium"> Только премиум</label>
                                <input type="button" value="Найти" class="span3 btn btn-warning btn-large" onclick="search()"/>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="tab-pane" id="adv-tab2"><!-- корма -->
                    корма
                </div>

                <div class="tab-pane" id="adv-tab3"><!-- транспорт -->
                    транспорт
                </div>

                <div class="tab-pane" id="adv-tab4"><!-- для всадника -->
                    для всадника
                </div>

                <div class="tab-pane" id="adv-tab5"><!-- для лошади -->
                    для лошади
                </div>

                <div class="tab-pane" id="adv-tab6"><!-- для конюшни -->
                    для конюшни
                </div>

                <div class="tab-pane" id="adv-tab7"><!-- ветеринару -->
                    ветеринару
                </div>

                <div class="tab-pane" id="adv-tab8"><!-- сувениры -->
                    сувениры
                </div>

            </div>
        </div>

        <div class="span12 brackets-horizontal"></div>

        <div class="span12 lthr-bgborder block clubs-search-results">
            <h3 class="inner-bg">Результаты поиска</h3>
            <div class="row" id="search-results">
                {foreach $horses as $horse}
                    <div class="span4 adv-item mini">
                        <a href="#"><img src="i/avatar-my-horse-1.jpg" class="adv-img" /></a>
                        <div class="adv-info">
                            <?php if ($i <= 6) { ?>
                            <img class="adv-prem-icon" src="images/sample-small-award-3.png" />
                            <? } ?>

                            <a href="#"><h4>{$horse.nick}</h4></a>
                            <div class="adv-price">{$horse.price|number_format:0:".":" "} руб.</div>
                            <ul class="adv-chars">
                                <li><span>Возраст:</span> {$year_now - $horse.age} лет </li>
                                <li><span>Рост:</span> {$horse.height} см.</li>
                                <li>{$horse.country}, {$horse.city}</li>
                            </ul>
                        </div>
                    </div>
                {/foreach}
            </div>
        </div>

    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}