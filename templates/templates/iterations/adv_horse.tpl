<div class="span4 adv-item mini">
    <a href="#"><img src="i/avatar-my-horse-1.jpg" class="adv-img" /></a>
    <div class="adv-info">
        <img class="adv-prem-icon" src="images/sample-small-award-3.png" />

        <a href="#"><h4>{$horse.nick}</h4></a>
        <div class="adv-price">{$horse.price|number_format:0:".":" "} руб.</div>
        <ul class="adv-chars">
            <li><span>Возраст:</span> {$smarty.now|date_format:"Y" - $horse.age} лет </li>
            <li><span>Рост:</span> {$horse.height} см.</li>
            <li>{$horse.country}, {$horse.city}</li>
        </ul>
    </div>
</div>