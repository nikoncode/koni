{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
<script type="text/javascript" src="js/bootstrap-multiselect.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script src="js/chosen.jquery.min.js"></script>
<link rel="stylesheet" href="css/chosen.css">
{literal}
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
        });
    </script>

    <script>
        $(".chosen-select").chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true});
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
                amethod: "add_sell_car_adv",
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
                    var values = '<option value="0">Все города</option>'+response;
                    $('select.city').html(values).trigger("chosen:updated");
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
<div class="container main-blocks-area adv-page adv-new-avto-page">
<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
        <h3 class="inner-bg">Новое объявление о продаже автомобиля<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>


            <div class="row">
                <form class="search-filter" id="add_adv_form">
                    <input type="hidden" name="usage" value="{$usage}">
                    <input type="hidden" name="type" value="{$type}">

                    <table class="search-filter-block">
                        <tr>
                            <td colspan="2">
                                <label>Марка</label>
                                <input type="text" name="marka" class="span6">
                            </td>
                            <td>
                                <label>Год производства</label>
                                <input type="text" name="age" class="span3">
                            </td>
                            <td>
                                <label>Состояние</label>
                                <select  class="span3" name="sost">
                                    <option>Отличное</option>
                                    <option>Хорошее</option>
                                    <option>Удовлетворительное</option>
                                    <option>Плохое</option>
                                </select>
                            </td>

                        </tr>
                        <tr>
                            <td colspan="2">
                                <label>Тип автомобиля</label>
                                <ul class="inline">
                                    <li><label class="radio"><input type="radio" name="type_car" value="Машина-коневоз">Машина-коневоз</label></li>
                                    <li><label class="radio"><input type="radio" name="type_car" value="Прицеп-коневоз">Прицеп-коневоз</label></li>
                                    <li><label class="radio"><input type="radio" name="type_car" value="Полуприцеп">Полуприцеп</label></li>
                                </ul>
                            </td>
                            <td colspan="2" id="td-car-options">
                                <label>Оборудование</label>
                                <select id="car-options" multiple="multiple" name="oborud[]" class="span6">
                                    <option>Душ</option>
                                    <option>Кондиционер</option>
                                    <option>Стол</option>
                                    <option>Холодильник</option>
                                    <option>Кухня</option>
                                    <option>Бойлер</option>
                                    <option>TV SAT</option>
                                    <option>DVD</option>
                                    <option>Туалет</option>
                                    <option>Раковина</option>
                                    <option>Генератор</option>
                                    <option>Стиральная машина</option>
                                    <option>Видео наблюдение</option>
                                    <option>Вебасто</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Спальные места</label>
                                <select name="mest" class="span3">
                                    <option value="0">Нет</option>
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option>4</option>
                                    <option>5</option>
                                    <option>6</option>
                                </select>
                            </td>
                            <td>
                                <label>Кол-во стойл</label>
                                <select name="stoil" class="span3">
                                    <option value="0">Нет</option>
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option>4</option>
                                    <option>5</option>
                                    <option>6</option>
                                    <option>7</option>
                                    <option>8</option>
                                    <option>9</option>
                                    <option>10</option>
                                    <option>11</option>
                                    <option>12</option>
                                </select>
                            </td>
                            <td>
                                <label>Трапы</label>
                                <select name="trap" class="span3">
                                    <option value="0">Нет</option>
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                </select>
                            </td>
                            <td>
                                <label>Наружные отсеки</label>
                                <select name="otsek" class="span3">
                                    <option value="0">Нет</option>
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option>4</option>
                                    <option>5</option>
                                    <option>6</option>
                                    <option>7</option>
                                    <option>8</option>
                                    <option>9</option>
                                    <option>10</option>
                                    <option>11</option>
                                    <option>12</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Местонахождение</label>
                                <select name="country" class="country span3 chosen-select" onchange="change_country(this);">
                                    <option value="0">Все страны</option>
                                    {foreach $countries as $country}
                                        <option value="{$country.id}">{$country.country_name_ru}</option>
                                    {/foreach}
                                </select>
                            </td>
                            <td>
                                <label>Город</label>
                                <select name="city" class="span3 city chosen-select">
                                    <option value="0">Все города</option>
                                </select>
                            </td>
                            <td rowspan="2" colspan="2"><label>Расскажите о транспорте</label>
                                <textarea rows="5" name="descr" class="span6"></textarea></td>
                        </tr>
                        <tr>
                            <td class="price-td colspan2" colspan="2">
                                <label>Цена продажи:</label>
                                <input name="price" type="text">
                                <select name="curr">
                                    <option>Руб.</option>
                                    <option>Грн.</option>
                                    <option>Дол.</option>
                                    <option>Евро</option>
                                </select>
                            </td>
                        </tr>
                    </table>


                    <div class="accordion" id="add-options-accordion">
                        <div class="accordion-group">
                            <div class="accordion-heading"><a class="accordion-toggle" data-toggle="collapse" data-parent="#additional-options" href="#additional-options">
                                    Дополнительные параметры</a></div>
                            <div id="additional-options" class="accordion-body collapse" style="height: 0px;">

                                <table class="search-filter-block">
                                    <tr>
                                        <td colspan="2">
                                            <label>Коробка передач</label>
                                            <ul class="inline">
                                                <li><label class="radio"><input type="radio" name="dop[kpp]" value="Автомат">Автомат</label></li>
                                                <li><label class="radio"><input type="radio" name="dop[kpp]" value="Ручная">Ручная</label></li>
                                                <li><label class="radio"><input type="radio" name="dop[kpp]" value="Полуавтомат">Полуавтомат</label></li>
                                            </ul>
                                        </td>
                                        <td colspan="2">
                                            <label>Подвеска</label>
                                            <ul class="inline">
                                                <li><label class="radio"><input type="radio" name="dop[podveska]" value="Рессорная">Рессорная</label></li>
                                                <li><label class="radio"><input type="radio" name="dop[podveska]" value="Пневматическая">Пневматическая</label></li>
                                                <li><label class="radio"><input type="radio" name="dop[podveska]" value="Торсионная">Торсионная</label></li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Объём двигателя (л.)</label>
                                            <input type="text" name="dop[dvigatel]" class="span3">
                                        </td>
                                        <td>
                                            <label>Топливный бак  (л.)</label>
                                            <input type="text" name="dop[bak]" class="span3">
                                        </td>
                                        <td>
                                            <label>Радиус колёс машины (мм)</label>
                                            <select name="dop[radius]" class="span3">
                                                <option>15</option>
                                                <option>16</option>
                                                <option>17</option>
                                                <option>18</option>
                                                <option>19</option>
                                                <option>20</option>
                                                <option>21</option>
                                                <option>22</option>
                                                <option>23</option>
                                            </select>
                                        </td>
                                        <td>
                                            <label>Количество осей</label>
                                            <select name="dop[os]" class="span3">
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Кол-во лошадинных сил</label>
                                            <input name="dop[ls]" type="text" class="span3">
                                        </td>
                                        <td>
                                            <label>Бак для воды (л.)</label>
                                            <input name="dop[bak_vodi]" type="text" class="span3">
                                        </td>
                                        <td>
                                            <label>Пробег, км</label>
                                            <input name="dop[probeg]" type="text" class="span3">
                                        </td>
                                        <td>
                                            <label>Общая масса</label>
                                            <input name="dop[massa]" type="text" class="span3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Наличие фаркопа;</label>
                                            <select name="dop[farkop]" class="span3">
                                                <option value="0">Нет</option>
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                            </select>
                                        </td>

                                    </tr>
                                </table>

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
                        <a href="#" class="span4 btn btn-warning btn-large offset2" onclick="add_adv()"/>Добавить объявление</a>
                        <a href="adv.php" class="span4 btn btn-large" />Отменить</a>
                    </div>

                </form>
            </div>
        </div>



    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}