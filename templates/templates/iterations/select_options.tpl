{if $finded_horses}
    {foreach $finded_horses as $fu}
        <option value="{$fu.id}">{$fu.nick}</option>
    {/foreach}
{/if}
