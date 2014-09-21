<div class="span4 adv-item mini">
    <a href="/adv_page.php?adv={$horse.id}"><img src="{if $horse.preview == ''}/images/bg-block-horse-without.png{else}{$horse.preview}{/if}" class="adv-img" /></a>
    <div class="adv-info">
        <img class="adv-prem-icon" src="images/sample-small-award-3.png" />

        <a href="/adv_page.php?adv={$horse.id}"><h4>{$horse.marka}</h4></a>
        <div class="adv-price">{$horse.price|number_format:0:".":" "} руб.</div>
        <ul class="adv-chars">
            <li><span>Год:</span> {$horse.age} г.</li>
            <li><span>Состояние:</span> {$horse.sost}</li>
            <li>{$horse.country}, {$horse.city}</li>
        </ul>
    </div>
</div>