{* Smarty *}
{include "modules/header.tpl"}
<script>
    $(function(){
        $('.search_comp').click(function(){
            var search = $(this).closest('.tab-pane').find('.search-query').val();
            $(this).closest('.tab-pane').find('.event_row').each(function(){
                var comp_type = $(this).attr('data-type');
                var comp_time = $(this).attr('data-time');
                if(comp_type.indexOf(search) > -1 || comp_time.indexOf(search) > -1){
                    $(this).css('display','');
                }else{
                    $(this).css('display','none');
                }
            });
        });
    });
</script>
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
                                <a href="javascript:void(0)" class="btn btn-warning span2 search_comp">Искать</a>
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
                            {foreach $be_events as $event}
                            <tr class="event_row" data-time="{$event.bdate}" data-type="{$event.type}">
                                <td class="compt-img"><a href="#"><img src="{$event.avatar}"></a></td>
                                <td class="compt-date">
                                    <p class="date">{$event.bdate}<span class="rel-date">(через 1 год)</span></p>
                                    <p class="place">г. {$event.city}, клуб <a href="/club.php?id={$event.club_id}">«{$event.club}»</a></p>
                                </td>
                                <td class="competition"><a href="competition.php?id={$event.id}">{$event.name} {if $event.route}[{$event.route}, {$event.height} см, {$event.exam}]{/if}</a>
                                    {if $event.fan > 0}
                                        {assign var="riders_count" value=","|explode:$event.fan_riders}
                                        <div class="i-fan">Я болею за {$riders_count|count} человек</div>
                                    {/if}
                                    {if isset($be_events_fans[$event.id])}<div class="my-fans">За вас болеют {$be_events_fans[$event.id]} человек</div>{/if}
                                </td>
                            </tr>
                            {/foreach}
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
                                <a href="javascript:void(0)" class="btn btn-warning span2 search_comp">Искать</a>
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

                            {foreach $end_events as $event}
                                <tr class="event_row" data-time="{$event.bdate}" data-type="{$event.type}">
                                    <td class="compt-img"><a href="#"><img src="{$event.avatar}"></a></td>
                                    <td class="compt-date">
                                        <p class="date">{$event.bdate}<span class="rel-date">(через 1 год)</span></p>
                                        <p class="place">г. {$event.city}, клуб <a href="/club.php?id={$event.club_id}">«{$event.club}»</a></p>
                                    </td>
                                    <td class="competition"><a href="competition.php?id={$event.id}">{$event.name} {if $event.route}[{$event.route}, {$event.height} см, {$event.exam}]{/if}</a>
                                        {if $event.fan > 0}
                                            {assign var="riders_count" value=","|explode:$event.fan_riders}
                                            <div class="i-fan">Я болею за {$riders_count|count} человек</div>
                                        {/if}
                                        {if isset($end_events_fans[$event.id])}<div class="my-fans">За вас болеют {$end_events_fans[$event.id]} человек</div>{/if}
                                    </td>
                                </tr>
                            {/foreach}
                            </tbody></table>
                    </div>
                </div> <!-- //online-friends -->


            </div>

        </div>

        {include "modules/sidebar-my-right.tpl"}

    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}