{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="js/chosen.jquery.min.js"></script>
<link  href="css/chosen.css" rel="stylesheet">
<link rel="stylesheet" href="css/range.css">
<script type="text/javascript" src="js/bootstrap-multiselect.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        window.prettyPrint() && prettyPrint();

        $('#car-options').multiselect({
            /*includeSelectAllOption: true,*/
            /*enableFiltering: true,*/
            maxHeight: 150,
            numberDisplayed: 10,
            nonSelectedText: 'Выберите из списка'
            /*						filterPlaceholder: 'Поиск'*/
        });
        {literal}$(".chosen-select").chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true});{/literal}
        $(".chosen-container.chosen-select").removeAttr('style');
    });
</script>
<script>
    $(function() {
        $( "#adv-car-price" ).slider({
            range: true,
            min: 1,
            max: 1000000,
            values: [ 1, 1000000 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " руб.";
                document.getElementById('adv-car-price-amount').innerHTML = CustomAmount;
                $('#price_car_from').val(ui.values[ 0 ]);
                $('#price_car_to').val(ui.values[ 1 ]);
            }
        });
        $('#price_car_from').val($( "#adv-car-price" ).slider( "values", 0 ));
        $('#price_car_to').val($( "#adv-car-price" ).slider( "values", 1 ));
        var startAmount =   "От " + $( "#adv-car-price" ).slider( "values", 0 ) +
                " до " + $( "#adv-car-price" ).slider( "values", 1 ) + " руб.";
        document.getElementById('adv-car-price-amount').innerHTML = startAmount;
    });

    $(function() {
        $( "#sleep-place" ).slider({
            range: true,
            min: 0,
            max: 6,
            values: [ 0, 6 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " шт.";
                document.getElementById('sleep-place-amount').innerHTML = CustomAmount;
                $('#mest_car_from').val(ui.values[ 0 ]);
                $('#mest_car_to').val(ui.values[ 1 ]);
            }
        });
        $('#mest_car_from').val($( "#sleep-place" ).slider( "values", 0 ));
        $('#mest_car_to').val($( "#sleep-place" ).slider( "values", 1 ));
        var startAmount =   "От " + $( "#sleep-place" ).slider( "values", 0 ) +  " до " + $( "#sleep-place" ).slider( "values", 1 ) + " шт.";
        document.getElementById('sleep-place-amount').innerHTML = startAmount;
    });

    $(function() {
        $( "#n-stail" ).slider({
            range: true,
            min: 0,
            max: 12,
            values: [ 0, 12 ],
            slide: function( event, ui ) {
                var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " шт.";
                document.getElementById('n-stail-amount').innerHTML = CustomAmount;
                $('#stoil_car_from').val(ui.values[ 0 ]);
                $('#stoil_car_to').val(ui.values[ 1 ]);
            }
        });
        $('#stoil_car_from').val($( "#n-stail" ).slider( "values", 0 ));
        $('#stoil_car_to').val($( "#n-stail" ).slider( "values", 1 ));
        var startAmount =   "От " + $( "#n-stail" ).slider( "values", 0 ) + " до " + $( "#n-stail" ).slider( "values", 1 ) + " шт.";
        document.getElementById('n-stail-amount').innerHTML = startAmount;
    });
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
        function search(form){
            api_query({
                qmethod: "POST",
                amethod: "find_adv",
                params:  $(form).serialize(),
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
            var country = $('option:selected',select).val();
            var $this = $(select).closest('form');
            api_query({
                qmethod: "POST",
                amethod: "auth_get_city",
                params:  {country_id:country},
                success: function (response, data) {
                    var values = '<option value="0">Все города</option>'+response;
                    $this.find('select.city').html(values).trigger("chosen:updated");
                },
                fail:    "standart"
            });
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
                                    <option value="1">Продажа</option>
                                    <option value="2">Покупка</option>
                                    <option value="3">Аренда</option>
                                </select>

                                <label>Страна</label>
                                <select name="country" class="span3 country chosen-select" onchange="change_country(this);">
                                    <option value="0">Все страны</option>
                                    {foreach $countries as $country}
                                        <option value="{$country.id}">{$country.country_name_ru}</option>
                                    {/foreach}
                                </select>

                                <label>Город</label>
                                <select name="city" class="span3 city chosen-select">
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
                                <select name="poroda" class="span3 chosen-select">
                                    <option value="">Все породы</option>
                                    {foreach $porodi as $poroda}
                                        <option value="{$poroda}">{$poroda}</option>
                                    {/foreach}
                                </select>


                                <label>Масть</label>
                                <select name="mast" class="span3 chosen-select">
                                    <option value="">Все масти</option>
                                    {foreach $masti as $mast}
                                        <option value="{$mast}">{$mast}</option>
                                    {/foreach}
                                </select>

                                <label>Кличка</label>
                                <input type="text" name="nick" class="span3">

                                <label>Специализация</label>
                                <select name="spec" class="span3 chosen-select">
                                    <option value="">Все специализации</option>
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
                                <input type="button" value="Найти" class="span3 btn btn-warning btn-large" onclick="search('#find_horses')"/>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="tab-pane" id="adv-tab2"><!-- корма -->
                    корма
                </div>

                <div class="tab-pane" id="adv-tab3"><!-- транспорт -->
                    <div class="row">
                        <form class="search-filter" id="find_car">
                            <input type="hidden" name="usage" value="3">
                            <div class="span3 search-filter-block">
                                <label>Тип объявления</label>
                                <select name="type" class="span3">
                                    <option value="1">Продажа</option>
                                    <option value="2">Покупка</option>
                                    <option value="3">Аренда</option>
                                </select>

                                <label>Страна</label>
                                <select name="country" class="span3 country chosen-select" onchange="change_country(this);">
                                    <option value="0">Все страны</option>
                                    {foreach $countries as $country}
                                        <option value="{$country.id}">{$country.country_name_ru}</option>
                                    {/foreach}
                                </select>

                                <label>Город</label>
                                <select name="city" class="span3 city chosen-select">
                                    <option>Все города</option>
                                </select>

                                <div class="range-block">
                                    <label>Цена</label>
                                    <div id="adv-car-price" class="xxx"></div>
                                    <div id="adv-car-price-amount" class="range-amount"></div>
                                    <input type="hidden" name="price_from" id="price_car_from">
                                    <input type="hidden" name="price_to" id="price_car_to">
                                </div>
                            </div>


                            <div class="span3 search-filter-block">
                                <label>Марка</label>
                                <input name="marka" type="text" class="span3">

                                <label>Тип</label>
                                <ul class="inline unstyled" id="horse-sex">
                                    <li><label class="radio"><input type="radio" name="type_car" value="Машина-коневоз">Машина</label></li>
                                    <li><label class="radio"><input type="radio" name="type_car" value="Прицеп-коневоз">Прицеп</label></li>
                                    <li><label class="radio"><input type="radio" name="type_car" value="Полуприцеп">Полупр.</label></li>
                                </ul>

                                <label>Год производства</label>
                                <input name="age" type="text" class="span3">

                                <label>Состояние</label>
                                <select name="sost" class="span3">
                                    <option>Отличное</option>
                                    <option>Хорошее</option>
                                    <option>Удовлетворительное</option>
                                    <option>Плохое</option>
                                </select>
                            </div>


                            <div class="span3 search-filter-block">
                                <label>Оборудование</label>
                                <select id="car-options" multiple="multiple" name="oborud[]" class="span6">
                                    <option>Ванная</option>
                                    <option>Кондиционер</option>
                                    <option>Кровать</option>
                                    <option>Стол</option>
                                    <option>Холодильник</option>
                                </select>
                                <label>Спальные места</label>
                                <div id="sleep-place"></div>
                                <div id="sleep-place-amount" class="range-amount"></div>
                                <input type="hidden" name="mest_from" id="mest_car_from">
                                <input type="hidden" name="mest_to" id="mest_car_to">
                                <label>Кол-во стойл</label>
                                <div id="n-stail"></div>
                                <div id="n-stail-amount" class="range-amount"></div>
                                <input type="hidden" name="stoil_from" id="stoil_car_from">
                                <input type="hidden" name="stoil_to" id="stoil_car_to">

                            </div>



                            <div class="span3">
                                <label class="checkbox"><input type="checkbox"> Только премиум</label>
                                <input type="button" value="Найти" class="span3 btn btn-warning btn-large" onclick="search('#find_car')"/>
                            </div>
                        </form>
                    </div>
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
                        <a href="/adv_page.php?adv={$horse.id}"><img src="{if $horse.preview == ''}/images/bg-block-horse-without.png{else}{$horse.preview}{/if} " class="adv-img" /></a>
                        <div class="adv-info">
                            <?php if ($i <= 6) { ?>
                            <img class="adv-prem-icon" src="images/sample-small-award-3.png" />
                            <? } ?>
                            <a href="/adv_page.php?adv={$horse.id}"><h4>{$horse.nick}</h4></a>
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