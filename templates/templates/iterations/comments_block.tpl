<div class="span12"> <!--комменты-->
    <div class="comments bg-white">
        <h4>Комментарии:</h4>
        <ul class="comments-lists">
            {if $comments_cnt > 3}
                <li class="comment show-all-comments" onclick="comments_extra('{$c_key}', {$c_value}, this);" data-cached="0">
                    Показать еще
                </li>
            {/if}
            {foreach $comments as $comment}
                {include "iterations/comment.tpl" comment = $comment}
            {/foreach}
            {include "modules/comment-form.tpl"}
        </ul>
    </div>
</div>