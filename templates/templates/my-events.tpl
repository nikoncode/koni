{* Smarty *}
{include "modules/header.tpl"}
<div class="container my-events-page main-blocks-area">
    <div class="row">
        {include "modules/sidebar-my-left.tpl"}
        <div class="brackets" id="bra-2"></div>
        <div class="brackets" id="bra-3"></div>

        <div class="span6 lthr-bgborder block" style="background-color: #fff">
            <h3 class="inner-bg">Мероприятия</h3>

            <ul id="friendsTab" class="nav nav-tabs new-tabs tabs2">
                <li class="active"><a href="#near-events" data-toggle="tab">Ближайшие</a></li>
                <li><a href="#past-events" data-toggle="tab">Прошедшие</a></li>
            </ul>

            <div id="friendsTabContent" class="tab-content bg-white">

                <div class="tab-pane in active" id="near-events">
                    <div class="row">
                        <form>
                            <div class="controls controls-row">

                                <div class="popup-calend span1">
                                    <a href="#" class="btn btn-default"><i class="icon-calendar"></i></a>
                                    <link rel="stylesheet" type="text/css" media="all" href="css/datepicker.css" />
                                    <script src="js/bootstrap-datepicker.js"></script>
                                    <script src="js/bootstrap-datepicker.ru.js"></script>
                                    <div id="compt-box-container"><div></div></div>
                                </div>

                                <input type="text" class="span3 search-query" placeholder="Введите дату или название">
                                <a href="friends-add.php" class="btn btn-warning span2">Искать</a>
                            </div>
                        </form>
                    </div>

                    <div class="row">
                        <table class="table table-striped competitions-table my-compts">
                            <tbody><tr>
                                <th>Тип</th>
                                <th>Время и место</th>
                                <th>Название</th>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="i-fan">Я болею за 3х человек</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="my-fans">За вас болеют 23 человека</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-3.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="i-fan">Я болею за 3х человек</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="my-fans">За вас болеют 23 человека</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-2.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="i-fan">Я болею за 3х человек</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-4.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="my-fans">За вас болеют 23 человека</div>
                                </td>
                            </tr>
                            </tbody></table>
                    </div>
                </div> <!-- //near-events -->

                <div class="tab-pane in" id="past-events">
                    <div class="row">
                        <form>
                            <div class="controls controls-row">

                                <div class="popup-calend span1">
                                    <a href="#" class="btn btn-default"><i class="icon-calendar"></i></a>
                                    <link rel="stylesheet" type="text/css" media="all" href="css/datepicker.css" />
                                    <script src="js/bootstrap-datepicker.js"></script>
                                    <script src="js/bootstrap-datepicker.ru.js"></script>
                                    <div id="compt-box-container"><div></div></div>
                                </div>

                                <input type="text" class="span3 search-query" placeholder="Введите дату или название">
                                <a href="friends-add.php" class="btn btn-warning span2">Искать</a>
                            </div>
                        </form>
                    </div>

                    <div class="row">
                        <table class="table table-striped competitions-table my-compts">
                            <tbody><tr>
                                <th>Тип</th>
                                <th>Время и место</th>
                                <th>Название</th>
                            </tr>

                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-3.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="i-fan">Я болею за 3х человек</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-1.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="my-fans">За вас болеют 23 человека</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-2.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="i-fan">Я болею за 3х человек</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="compt-img"><a href="#"><img src="images/icon-competition-4.jpg"></a></td>
                                <td class="compt-date">
                                    <p class="date">26 июля 2014 г. <span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. Москва, клуб <a href="#">«Битца»</a></p>
                                </td>
                                <td class="competition"><a href="club-sample-compt.php">CSI2*-W/ CSIYH1* - Riga (Латвия)  [М3, 115 см, любители (н)]</a>
                                    <div class="my-fans">За вас болеют 23 человека</div>
                                </td>
                            </tr>
                            </tbody></table>
                    </div>
                </div> <!-- //online-friends -->


            </div>

        </div>

        {include "modules/sidebar-my-right.tpl"}

    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}