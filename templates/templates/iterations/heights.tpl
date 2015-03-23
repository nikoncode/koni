{if $heights}
    {foreach $heights as $h}
        <label><input type="radio" name="rhid" class="heights" value="{$h.id}"> {$h.height} см,{$h.exam}</label>
    {/foreach}
{/if}