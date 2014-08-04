{* Smarty *}
{include "modules/header.tpl"}

<div class="container ratings-page main-blocks-area ratings-block">
<div class="row">

<div class="span12 lthr-bgborder block ratings-main-tabs">
<h3 class="inner-bg">Рейтинги</h3>
<div class="row">

<ul id="rateNav" class="nav nav-tabs new-tabs tabs2">
    <li class="active"><a href="#rate-club" data-toggle="tab">Клубы</a></li>
    <li><a href="#rate-sportsmans" data-toggle="tab">Спортсмены</a></li>
    <li><a href="#rate-horses" data-toggle="tab">Лошади</a></li>
    <li><a href="#rate-horsebreeder" data-toggle="tab">Коневоды</a></li>
    <li><a href="#rate-roughrider" data-toggle="tab">Бирейторы</a></li>
</ul>

<div id="rateNavContent" class="tab-content bg-white">

<div class="tab-pane in active" id="rate-club">
    <div class="row">
        <div class="span12 no-mrg">
            <div class= "row">
                <div class= "span3"><hr class="nav-btns"></div>
                <div class= "span6">
                    <ul  id="rate-club-type" class="nav nav-tabs nav-btns">
                        <li class="active"><a href="#rct-by-compt" data-toggle="tab">По соревнованиям</a></li>
                        <li><a href="#rct-by-peoples" data-toggle="tab">Народный рейтинг</a></li>
                    </ul>
                </div>
                <div class= "span3"><hr class="nav-btns"></div>
            </div>
            <div id="rate-club-type-Content" class="tab-content">
                <div class="tab-pane in active" id="rct-by-compt"> <!-- таб -->
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
                            <select class="span3">
                                <option>Россия</option>
                                <option>Беларусь</option>
                                <option>Украина</option>
                            </select>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Город</label>
                            <select class="span3">
                                <option>Москва</option>
                                <option>Минск</option>
                                <option>Киев</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="rct-by-peoples">  <!-- таб -->
                    <div class="row">
                        <div class="span6">
                            <label>Период</label>
                            <div class="btn-group" data-toggle="buttons-radio">
                                <button type="button" class="btn active">Общий за всё время</button>
                                <button type="button" class="btn">За 12 месяцев</button>
                                <button type="button" class="btn">Выбрать год <b class="caret"></b></button>
                            </div>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Страна</label>
                            <select class="span3">
                                <option>Россия</option>
                                <option>Беларусь</option>
                                <option>Украина</option>
                            </select>
                        </div>
                        <div class="span3 search-filter-block">
                            <label>Город</label>
                            <select class="span3">
                                <option>Москва</option>
                                <option>Минск</option>
                                <option>Киев</option>
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
            {for $i = 1 to 10}
            <tr>
                <td class="rt-n">{$i}</td>
                <td class="rt-club"><a href="club-sample.php"><img src="i/club-bitza.jpg">Конноспортивный комплекс "Битца"</a></td>
                <td class="rt-city">РФ, г. Москва</td>
                <td class="rt-members">{assign var=x value= 100|rand:2333 } {$x}  чел.</td>
                <td class="rt-points">{assign var=x value= 1|rand:100 } {$x}</td>
            </tr>
            {/for}
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
                    <div class="span8 search-filter-block">
                        <label>Возрастная группа</label>
                        <ul class="inline choose-age">
                            <li class="active"><h5>Все возрасты</h5><small>возраст не учитывается</small></li>
                            <li><h5>Взрослые</h5><small>от 22 лет</small></li>
                            <li><h5>Юниоры</h5><small>от 19 до 22 лет</small></li>
                            <li><h5>Юноши</h5><small>от 15 до 19 лет</small></li>
                            <li><h5>Дети</h5><small>до 15 лет</small></li>

                        </ul>
                    </div>
                    <div class="span2 search-filter-block">
                        <label>Страна</label>
                        <select class="span2">
                            <option>Россия</option>
                            <option>Беларусь</option>
                            <option>Украина</option>
                        </select>
                    </div>
                    <div class="span2 search-filter-block">
                        <label>Город</label>
                        <select class="span2">
                            <option>Москва</option>
                            <option>Минск</option>
                            <option>Киев</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <table class="table table-striped competitions-table ratings-table rating-sportsmans">
            <tbody><tr>
                <th>№</th>
                <th>Клуб</th>
                <th>Город</th>
                <th class="text-right">Участники</th>
                <th class="text-right">Кол-во баллов</th>
            </tr>
            {for $i = 1 to 10}
            <tr>
                <td class="rt-n"><?php echo $i; ?></td>
                <td class="rt-club"><a href="club-sample.php"><img src="i/club-bitza.jpg">Конноспортивный комплекс "Битца"</a></td>
                <td class="rt-city">РФ, г. Москва</td>
                <td class="rt-members">{assign var=x value= 100|rand:2333 } {$x} чел.</td>
                <td class="rt-points">{assign var=x value= 1|rand:100 } {$x}</td>
            </tr>
            {/for}
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