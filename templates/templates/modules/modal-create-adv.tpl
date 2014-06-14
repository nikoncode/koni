<script>
    $(document).ready(function() {
        $('.new_horse').change(function(){
            var selected = $('.new_horse:checked').val();
            if(selected == 2){
                $('.adv-my-horses li:first-child').click();
            }else{
                $('.adv-my-horses li.active').removeClass('active');
                $('#horse_id').val(0);
            }
        });
        $('.adv-my-horses li').click(function(){
            $('.adv-my-horses li.active').removeClass('active');
            var horse_id = $(this).find('a').attr('alt');
            $(this).addClass('active');
            $('#horse_id').val(horse_id);
            $('.new_horse[value="2"]').prop('checked',true);
        });
    });
</script>
<div id="createAdv" class="modal hide modal600" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Новое объявление</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" action="adv_new.php" method="post">
            <div class="controls controls-row">
                <label class="span6"><strong>Шаг 1:</strong> Выберите тематику объявления</label>
                <select name="usage" class="span6">
                    <option value="1">Лошади</option>
                    <option value="2">Корма</option>
                    <option value="3">Транспорт</option>
                    <option value="4">Для всадника</option>
                    <option value="5">Для лошади</option>
                    <option value="6">Для конюшни</option>
                    <option value="7">Ветеринару</option>
                    <option value="8">Сувениры</option>
                </select>
            </div>
            <hr/>
            <div class="controls controls-row">
                <label class="span6"><strong>Шаг 2:</strong> Выберите тип объявления</label>
                <select name="type" class="span6">
                    <option value="1">Продажа</option>
                    <option value="2">Покупка</option>
                    <option value="3">Аренда</option>
                </select>
            </div>
            <hr/>
            <div class="controls controls-row">
                <label class="span6"><strong>Шаг 3:</strong> Выберите лошадь для продажи</label>
                <label class="radio span6"><input type="radio" name="new_horse" class="new_horse" value="1" checked="checked"> Создать объявление о новой лошади</label>
                <label class="radio span6"><input type="radio" name="new_horse" class="new_horse" value="2"> Выбрать из своих лошадей</label>

                <ul class="adv-my-horses">
                    {foreach $my_horses as $my_horse}
                        <li><a href="#" alt="{$my_horse.id}"><img src="{$my_horse.avatar}" class="avatar-my-horse">{$my_horse.nick}</a></li>
                    {/foreach}
                </ul>

            </div>
            <hr/>
            <div class="controls controls-row">
                <input type="hidden" name="horse_id" id="horse_id" value="0">
                <button type="submit" class="btn btn-warning span3">Подать объявление</button>
                <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
            </div>
        </form>
    </div>
</div>