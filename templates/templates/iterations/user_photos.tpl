<div class="photos" data-gallery-list="{$photos_ids_list}">
    {if $albums}
        {foreach $albums as $album}
            <p>{$album.name}</p>
            {if $album.photos}
                <ul class="photo-wall">
                    {foreach $album.photos as $photo}
                        <li><a href="#" data-gallery-pid="{$photo.id}"><img src="{$photo.preview}" style="max-height: 120px" /></a></li>
                    {/foreach}
                </ul>
            {/if}
        {/foreach}
    {else}
        <p style="text-align: center;">Нет альбомов</p>
    {/if}
</div>