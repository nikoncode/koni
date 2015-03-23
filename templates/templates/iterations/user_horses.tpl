<div class="horses-list">
    <center><a href="#" onclick="new_horse_prepare();return false;" class="btn btn-warning">Добавить лошадь</a>
        <a href="#" onclick="new_user_horse_prepare();return false;" class="btn btn-warning">Добавить чужую лошадь</a></center>
    {if $horses}
        {foreach $horses as $horse}
            <div class="span6 my-horse">
                <div class="row">
                    <div class="horse-info-photo span1">
                        <a href="/horse.php?id={$horse.id}"><img src="{$horse.avatar}" class="horse-avatar"></a>
                    </div>
                    <div class="horse-info-about span3">
                        <ul>
                            <li class="horse-name"><a href="/horse.php?id={$horse.id}">{$horse.nick}</a></li>
                            <li class="age">{$horse.age} лет ({$horse.byear} год рождения)</li>
                            <li class="sex"><span>Пол: </span>{$horse.sex}</li>
                            <li class="spec"><span>Специализация: </span>{$horse.spec}</li>
                        </ul>
                    </div>
                    <div class="span2 horse-info-actions">
                        <ul>
                            <li><a href="/horse.php?id={$horse.id}">Комментировать</a></li>
                            {if !$another_user}
                                <li><a href="#" onclick="edit_horse_prepare({$horse.id}); return false;">Изменить</a></li>
                                <li><a href="#" onclick="delete_horse({$horse.id}, this,{$horse.o_uid}); return false;">Удалить</a></li>
                            {/if}
                        </ul>
                    </div>
                </div>
            </div>
        {/foreach}
    {/if}
    {if $horses_owners}
        {foreach $horses_owners as $horse}
            <div class="span6 my-horse">
                <div class="row">
                    <div class="horse-info-photo span1">
                        <a href="/horse.php?id={$horse.id}"><img src="{$horse.avatar}" class="horse-avatar"></a>
                    </div>
                    <div class="horse-info-about span3">
                        <ul>
                            <li class="horse-name"><a href="/horse.php?id={$horse.id}">{$horse.nick}</a></li>
                            <li class="age">{$horse.age} лет ({$horse.byear} год рождения)</li>
                            <li class="sex"><span>Пол: </span>{$horse.sex}</li>
                            <li class="spec"><span>Специализация: </span>{$horse.spec}</li>
                        </ul>
                    </div>
                    <div class="span2 horse-info-actions">
                        <ul>
                            <li><a href="/horse.php?id={$horse.id}">Комментировать</a></li>
                            {if !$another_user}
                                <li><a href="#" onclick="delete_user_horse({$horse.id}, this,{$horse.o_uid}); return false;">Удалить</a></li>
                            {/if}
                        </ul>
                    </div>
                </div>
            </div>
        {/foreach}
    {/if}
    {if !$horses && !$horses_owners}
        <p style="text-align: center;">Нет лошадей</p>
    {/if}
</div>