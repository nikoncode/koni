<select name="rhid" class="heights span3" multiple>
    {foreach $heights as $h}
        <option value="{$h.id}">{$h.height},{$h.exam}</option>
    {/foreach}
</select>