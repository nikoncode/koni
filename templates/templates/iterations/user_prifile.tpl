<div class="row">
    <div class="control-group span6">
        <label class="control-label" for="inputNewName">Заблокирован</label>
        <label class="controls"><input type="radio" class="blocked" name="blocked" value="1" {if $u.blocked == 1}checked="checked"{/if} onclick="user_block({$u.id},1)"> Да</label>
        <label class="controls"><input type="radio" class="blocked" name="blocked" value="0" {if $u.blocked == 0}checked="checked"{/if} onclick="user_block({$u.id},1)"> Нет</label>
    </div>
</div>
<form class="form-horizontal" id="my-settings" onsubmit="profile_edit(this); return false;">
    <div>
        <h5 class="title-hr">Изменить имя</h5>
        <div class="control-group">
            <label class="control-label" for="inputNewName">Ваше имя</label>
            <div class="controls"><input type="text" id="inputNewName" placeholder="Имя" name="fname" value="{$u.fname}"></div>
            <label class="control-label" for="inputNewSurname">Ваша фамилия</label>
            <div class="controls"><input type="text" id="inputNewSurname" placeholder="Фамилия" name="lname" value="{$u.lname}"></div>
            <label class="control-label" for="inputNewSurnamen">Ваше отчество</label>
            <div class="controls"><input type="text" id="inputNewSurnamen" placeholder="Отчество" name="mname" value="{$u.mname}"></div>
        </div>
    </div>

    <div>
        <h5 class="title-hr">Изменить пароль</h5>
        <div class="control-group">
            <label class="control-label" for="inputNewPass">Новый пароль</label>
            <div class="controls"><input type="text" id="inputNewPass" placeholder="Пароль" name="passwd1"></div>
            <label class="control-label" for="inputPassAgain">Повторите пароль</label>
            <div class="controls"><input type="text" id="inputPassAgain" placeholder="И ещё раз" name="passwd2"></div>
        </div>
    </div>

    <div>
        <h5 class="title-hr">Изменить дату рождения</h5>
        <div class="control-group">
            <label class="control-label" class="span6">Введите день</label>
            <div class="controls"><input type="text" placeholder="День" name="bday" value="{$u.bday}"></div>
            <label class="control-label">Выберите месяц</label>
            <div class="controls">
                <select name="bmounth">
                    {foreach $mounths as $mounth}
                        <option value="{$mounth@key}" {if $mounth@key == $u.bmounth}selected="selected"{/if}>{$mounth}</option>
                    {/foreach}
                </select>
            </div>
            <label class="control-label">Введите год</label>
            <div class="controls"><input type="text"placeholder="И ещё раз" name="byear" value="{$u.byear}"></div>
        </div>
    </div>

    <div>
        <h5 class="title-hr">Изменить контактные данные</h5>
        <div class="control-group" style="overflow: visible">
            <label class="control-label">E-mail</label>
            <div class="controls"><input type="text" placeholder="E-mail" name="mail" value="{$u.mail}"></div>
            <label class="control-label">Ваш сайт</label>
            <div class="controls"><input type="text" placeholder="Ваш сайт" name="site" value="{$u.site}"></div>
            <label class="control-label">Страна</label>
            <div class="controls" style="overflow: visible">
                <select name="country" class="chosen-country chosen-select" onchange="change_country(this);">
                    {foreach $countries as $country}
                        <option value="{$country.id}" {if $country.country_name_ru == $u.country}selected="selected"{/if}>{$country.country_name_ru}</option>
                    {/foreach}
                </select></div>
            <label class="control-label">Город</label>
            <div class="controls" style="overflow: visible">
                <select class="chosen-city chosen-select" name="city">

                </select>
                <input type="hidden" id="u_city" value="{$u.city}">
            </div>
            <label class="control-label">Улица</label>
            <div class="controls"><input type="text" placeholder="Улица" name="adress" value="{$u.adress}"></div>
            <label class="control-label">Номер телефона</label>
            <div class="controls"><input type="text" placeholder="Номер телефона" name="phone" value="{$u.phone}"></div>
        </div>
    </div>

    <div>
        <h5 class="title-hr">Изменить увлечения</h5>
        <div class="control-group">
            {foreach $u.profs as $prof}
                <div class="span2"><label class="checkbox pull-left"><input type="checkbox" name="work[]" class="spec" value="{$prof@key}" {$prof}>{$prof@key}</label></div>
            {/foreach}
        </div>
        <h5 class="title-hr rank">Разряд</h5>
        <div class="control-group rank">
            <select class="span2 rank" name="rank">
                {foreach $const_rank as $key=>$rank}
                    <option value="{$key}" {if $key == $u.rank}selected="selected"{/if}>{$rank}</option>
                {/foreach}
            </select>
        </div>
    </div>
    <div class="span6">
        <div class="controls-row">
            <input type="hidden" name="user_id" value="{$u.id}"/>
            <input type="submit" class="span3 btn btn-warning" value="Применить"/>
        </div>
    </div>
</form>
