<script>
    function send_support(form){
        api_query({
            amethod: "send_support",
            qmethod: "POST",
            params: $(form).serialize(),
            success: function (data) {
                alert(data);
                $("#support").modal("hide");
            },
            fail: "standart"
        });
        return false;
    }
</script>
<div id="support" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Запрос в службу поддержки</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal"  method="post" action="#" onsubmit="send_support(this);return false;">
            <div class="row">
                <div class="controls controls-row">
                    <input type="text" class="span3" name="name" placeholder="Имя">
                    <input type="text" class="span3" name="lname" placeholder="Фамилия">
                </div>
            </div>
            <div class="row">
                <div class="controls controls-row">
                    <input type="text" class="span3" name="email" placeholder="E-mail">
                    <input type="text" class="span3" name="phone" placeholder="Телефон">
                </div>
            </div>
            <div class="row">
                <div class="controls controls-row">
                    <input type="text" class="span3" name="city" placeholder="Город">
                    <textarea class="span3" name="message" placeholder="Текст сообщения"></textarea>
                </div>
            </div>
            <hr/>

            <div class="row">
                <div class="controls controls-row">
                    <center>
                        <input type="hidden" name="url" value="{$url}">
                        <input type="hidden" name="user_id" value="{$another_user.id}">
                        <button type="submit" class="btn btn-warning span3">Отправить</button>
                        <button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
                    </center>
                </div>
            </div>
        </form>
    </div>
</div>