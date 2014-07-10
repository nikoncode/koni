{* Smarty *}
<script>
    $(function () {
        $(".answer-message").keydown(function (e) {
            if (e.ctrlKey && e.keyCode == 13) {
               $(this).closest('form').find('.comment-submit').click();
                return false;
            }
        });
    });
</script>
<li class="answer-form">
    <form class="min" onsubmit="{if $loaded_comment}edit{else}add{/if}_comment(this); return false;">
        <table class="controls-row">
            <tr>
                <td class="my-avatar"><img src="{$user_avatar}" class="my-avatar"></td>
                <td><textarea type="text" name="text" class="answer-message" placeholder="Комментировать..." onfocus="answer_form_maximize(this);" onblur="answer_form_minimize(this);">{if $loaded_comment}{$loaded_comment}{/if}</textarea>
                    <input type="hidden" name="id" value="{$c_value}" />
                    <input type="hidden" name="type" value="{$c_key}" />
                    <input type="submit" value="Отправить" class="btn btn-warning  comment-submit span2">
                    {if $loaded_comment}
                        <button onclick='edit_comment_cancel(this);return false;' class='btn comment-submit span2'>Отмена</button>
                    {/if}
                </td>
            </tr>
        </table>
    </form>
</li>