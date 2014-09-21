<tr>
    <td>{$event.bdate}</td>
    <td><a href="competition.php?id={$event.id}">{$event.name}</a></td>
    <td>{$event.type}</td>
    <td><img src="images/flag-ru.jpg" class="country-flag" title="{$event.country}">{$event.city}</td>
    <td><small><a href="club.php?id={$event.club_id}">{$event.club}</a></small></td>
    <td><small>{$event.status}</small></td>
</tr>