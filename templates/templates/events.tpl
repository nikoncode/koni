{* Smarty *}
{include "modules/header.tpl"}

<script type="text/javascript" src="js/bootstrap-multiselect.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link rel="stylesheet" href="css/range.css">
<script type="text/javascript">
    $(document).ready(function() {
        window.prettyPrint() && prettyPrint();

        $('#event-clubs').multiselect({
            /*includeSelectAllOption: true,*/
            enableFiltering: true,
            maxHeight: 150,
            numberDisplayed: 10,
            nonSelectedText: 'Выберите из списка',
            filterPlaceholder: 'Поиск'
        });

        $(function() {
            $( "#adv-height" ).slider({
                range: true,
                min: 40,
                max: 220,
                step: 5,
                values: [ 40, 220 ],
                slide: function( event, ui ) {
                    var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " см.";
                    document.getElementById('adv-height-amount').innerHTML = CustomAmount;
                }
            });
            var startAmount =   "От " + $( "#adv-height" ).slider( "values", 0 ) + " до " + $( "#adv-height" ).slider( "values", 1 ) + " см.";
            document.getElementById('adv-height-amount').innerHTML = startAmount;
        });

    });
</script>

<div class="container main-blocks-area events-page">
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <h3 class="inner-bg">Мероприятия<span class="pull-right"><a  href="my-events.php"> перейти к моим мероприятияем</a></span></h3>


            <div class="row">
                <form class="search-filter">

                    <table class="search-filter-block">
                        <tr>
                            <td colspan="2">
                                <label>Поиск по названию соревнования</label>
                                <input type="text" class="span6">
                            </td>
                            <td>
                                <label>Вид соревнования</label>
                                <select  class="span3">
                                    <option>Любой</option>
                                    <option>Конкур</option>
                                    <option>Гонка</option>
                                    <option>Выездка</option>
                                </select>
                            </td>
                            <td rowspan="4">
                                <input type="submit" value="Найти" class="span3 btn btn-warning btn-large">
                                <p class="text-center"><a href="#">Сбросить фильтр</a></p>
                                <hr/>
                                <p class="block-descr">Создавать мероприятие может только предстватель одного из <a href="clubs.php">клубов</a>.</p>
                                <!--<div class="banner">
                                    <a href="club-sample.php"><img src="i/club-sample-adv.jpg"></a>
                                </div>-->
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Дата начала</label>
                                <input type="text" class="span3">
                            </td>
                            <td>
                                <label>Дата окончания</label>
                                <input type="text" class="span3">
                            </td>
                            <td>
                                <label>Статус</label>
                                <select  class="span3">
                                    <option>Любой</option>
                                    <option>Всероссийский</option>
                                    <option>Международный</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Страна</label>
                                <input type="text" class="span3">
                            </td>
                            <td>
                                <label>Город</label>
                                <input type="text" class="span3">
                            </td>
                            <td>
                                <label>Вид</label>
                                <select  class="span3">
                                    <option>Все</option>
                                    <option><span class="label label-warning nth-routes"><abbr title="Количество маршрутов">4: Д, Ю, В</abbr></span> Дети -  12-14 лет</option>
                                    <option>[Л] Любители 18-30</option>
                                    <option>Профессионалы 31-131</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="rowspan2">
                                <label>Клубы</label>
                                <select id="event-clubs" multiple="multiple" class="span6 chosen-select">
                                    <option><span class="label label-warning nth-routes"><abbr title="Количество маршрутов">4: Д, Ю, В</abbr></span> Конноспортивный комплекс "Битца"</option>
                                    <option>Комплекс "Кобитца"</option>
                                    <option>Клуб "Мой первый клуб, он трудный самый"</option>
                                    <option>Пельменная "Mediamara"</option>
                                </select>
                            </td>
                            <td>
                                <label>Высота</label>
                                <div id="adv-height"></div>
                                <div id="adv-height-amount" class="range-amount"></div>
                            </td>
                        </tr>

                    </table>

                </form>
            </div>
        </div>

        <div class="span12 brackets-horizontal"></div>

        <div class="span12 lthr-bgborder block clubs-search-results">
            <h3 class="inner-bg">Результаты поиска</h3>
            <div class="row">
                <table class="table table-striped competitions-table clubs-results">
                    <tbody><tr>
                        <th>Дата</th>
                        <th>Соревнование</th>
                        <th>Вид</th>
                        <th>Местоположение</th>
                        <th>Клуб</th>
                        <th>Статус</th>
                    </tr>
                    <tr>
                        <td>21.12.2012</td>
                        <td><a href="events-event.php">CSI2*-W/ CSIYH1* - RIGA (ЛАТВИЯ) [М3, 115 СМ, ЛЮБИТЕЛИ (Н)]</a></td>
                        <td>Бега</td>
                        <td><img src="images/flag-ru.jpg" class="country-flag" title="Россия">Москва</td>
                        <td><small><a href="club-sample.php">Конноспортивный комплекс "Битца"</a></small></td>
                        <td><small>Всероссийский</small></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>



    </div> <!-- /row -->
</div>

{include "modules/footer.tpl"}