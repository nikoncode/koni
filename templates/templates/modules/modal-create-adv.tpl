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
                <label class="radio span6"><input type="radio" name="radio1" class="new_horse" value="1" checked="checked"> Создать объявление о новой лошади</label>
                <label class="radio span6"><input type="radio" name="radio1" class="new_horse" value="2"> Выбрать из своих лошадей</label>

                <ul class="adv-my-horses">
                    <li class="active"><a href="#"><img src="i/avatar-my-horse-1.jpg" class="avatar-my-horse">Альфа</a></li>
                    <li><a href="#" class="active"><img src="i/avatar-my-horse-2.jpg" class="avatar-my-horse">Бета</a></li>
                    <li><a href="#" class="active"><img src="i/avatar-my-horse-3.jpg" class="avatar-my-horse">Гамма</a></li>
                </ul>

            </div>
            <hr/>
            <div class="controls controls-row">
                <button type="submit" class="btn btn-warning span3">Подать объявление</button>
                <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
            </div>
        </form>
    </div>
</div>