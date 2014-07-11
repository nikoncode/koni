<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
<!-- implement jcrop -->
<script src="js/upload/jquery.Jcrop.min.js"></script>
<link rel="stylesheet" href="js/upload/jquery.Jcrop.min.css" type="text/css" />
<script type="text/javascript">
	var jcrop_api;

	function activate_page(num) {
		$(".step1").css("display", "none");
		$(".step2").css("display", "none");
		$(".step3").css("display", "none");
		$(".step" + num).css("display", "block");
	}

	function update_coords(c) {
		$('.step3 input[name=x1]').val(c.x);
		$('.step3 input[name=y1]').val(c.y);
		$('.step3 input[name=x2]').val(c.x2);
		$('.step3 input[name=y2]').val(c.y2);
	}
    function check_unread(){
        api_query({
            qmethod: "POST",
            amethod: "chat_unread_count",
            success: function (resp) {
                var count = resp.count || 0;

                $('#unread_count').html('('+resp.count+')');
            },
            fail: "standart"
        })
    }
	function crop(el) {
		api_query({
			qmethod: "POST",
			amethod: "gallery_upload_avatar_crop",
			params:  $(el).serialize(),
			success: function (data) {
				$("#avatar").attr("src", data.avatar);
				$(".my-small-avatar").attr("src", data.avatar);
				$("#modal-change-avatar").modal("hide");
			},
			fail:    "standart"
		})
	}

	$(function () {
        check_unread();
        setInterval(function () {
            check_unread();
        },5000);
        $('#fileupload').fileupload({
			maxNumberOfFiles: 1,
			dataType: 'json',
			done: function (e, data) {
				var result = data.result
				if (result.type == "success") {
					activate_page(3);
					$(".step3 input[name=avatar]").val(result.response.avatar);
					$("#future-avatar").Jcrop({
						aspectRatio: 1,
						onChange: update_coords,
						onSelect: update_coords
					}, function () { 
						jcrop_api = this; 
						jcrop_api.setImage(result.response.avatar, function () {
							jcrop_api.setSelect([10,10,210,210]);	
						}); 
						
					});
				} else {
					errors = "";
					for (i = 0;i < result.response.length; ++i)
						errors += result.response[i] + "<br>";
					$("#notification").html(errors);
				}
			},
			progressall: function (e, data) {
				activate_page(2);
				var progress = parseInt(data.loaded / data.total * 100, 10);
				$('.step2 .progress .bar').css('width', progress + '%' );
			}
		});

		$('#modal-change-avatar').on('hidden', function () {
			activate_page(1);
			jcrop_api.destroy();
			$('.step2 .progress .bar').css('width', '0%' );
			$("#notification").html("Ожидайте загрузки файла.");
		});
	});
</script>

<div class="span3 lthr-bgborder block my-block">
	<div class="my-actions">
		<div class="my-avatar-block">
			<a href="/inner.php"><img id="avatar" src="{$user.avatar}" class="my-avatar" /></a>
			<div class="change-avatar-block">
				<a href="#modal-change-avatar" role="button" data-toggle="modal">Изменить аватар</a>
			</div>
		</div>
		<h2 class="my-name">{$user.fio}</h2>
		<p class="my-info">{$user.info}</p>
		{if $user.profs}
			<ul class="my-profs inline">
				{foreach $user.profs as $prof}
					<li>{$prof}{if !$prof@last},{/if}</li>
				{/foreach}
			</ul>
		{/if}
		<p class="my-club">
			{if $user.club_name}
				Состоит в клубе "<a href="club.php?id={$user.club_id}">{$user.club_name}</a>"
			{else}
				Не состоит в <a href="clubs.php">клубах</a>
			{/if}
		</p>
		<ul class="my-actions-menu">
			<li class="my-news"><a href="inner.php">Моя страница</a></li>
			<li class="my-news"><a href="news.php">Новости</a></li>
			<li class="my-messages"><a href="messages.php">Сообщения</a> <span id="unread_count">(0)</span></li>
			<!--<li class="my-clubs"><a href="groups.php">Группы</a></li>-->
			<li class="my-events"><a href="my-events.php">Мероприятия</a></li>
			<li class="my-contacts"><a href="friends.php">Друзья</a></li>
			<li class="my-horses"><a href="horses.php">Лошади</a></li>
			<li class="my-gallery"><a href="gallery.php" >Галерея</a></li>
			<li class="my-adv"><a href="adv.php">Объявления</a></li>
			<li class="my-profile"><a href="profile.php">Настройки</a></li>
		</ul>
	</div>
	
	{if $user.friends}
		<div>
			<h3 class="inner-bg">Друзья</h3>
			<ul class="my-friends-menu">
				{foreach $user.friends as $friend}
					<li><a href="/user.php?id={$friend.id}"><img src="{$friend.avatar}" /><p>{$friend.fio}</p></a></li>
				{/foreach}
			</ul>
			<div class="clear"></div>
		</div>
	{/if}
	
	<!--<div class="my-groups-block">
		<h3 class="inner-bg">Мои группы<span class="pull-right">77 групп</span></h3>
		<ol class="my-groups-menu">
			<li><a href="#">Типичный конник</a></li>
			<li><a href="#">Мы-конники |MK|</a></li>
			<li><a href="#">Спорт и красота</a></li>
			<li><a href="#">MБK (Мы Братство Конников)</a></li>
			<li><a href="#">Конник</a></li>
			<li><a href="#">Клуб конников «Сибирская подкова»</a></li>
			<li><a href="#">Чёткий Конник</a></li>
			<li><a href="#">Сообщество конников*</a></li>
			<li><a href="#">Конник - спортсмен</a></li>
			<li><a href="#">"Если фотограф - конник"</a></li>
		</ol>
		<a href="#" class="to-all-groups">Все мои группы</a>
	</div>-->
</div>

<!-- модалки -->
<div id="modal-change-avatar" class="modal hide modal700" tabindex="-1" role="dialog">
<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Изменить аватар</h3>
	</div>
<div class="modal-body step1">
			<form class="form-horizontal" action="#">
				<p>Друзьям будет проще узнать Вас, если Вы загрузите свою настоящую фотографию.</p>
				<div class="change-avatar-buttons" style="text-align: center;">
					<input id="fileupload" type="file" name="avatar" data-url="/api/api.php?m=gallery_upload_avatar">
					<button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
				</div>
				<p class="avatar-descr">Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
			</form>
	</div>
	
	<div class="modal-body step2" style="display: none;">
			<form class="form-horizontal" action="#">
				<p><center id="notification">Ожидайте загрузки файла.</center></p>
				<div class="progress progress-striped active">
					<div class="bar" style="width: 0%;"></div>
				</div>
				<div class="change-avatar-buttons">
						 <center><button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button></center>
				 </div>
				 <p class="avatar-descr">Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
			</form>
	</div>
	
	<div class="modal-body step3" style="display: none;">
			<form class="form-horizontal" action="#" onsubmit="crop(this);return false;">
				<p>Выбранная область будет показываться на Вашей странице.</p>
				<center>
					<img src="http://placehold.it/1x1" id="future-avatar" />
					<div class="change-avatar-buttons">
						<input type="hidden" name="x1" value="10" />
						<input type="hidden" name="y1" value="10" />
						<input type="hidden" name="x2" value="210" />
						<input type="hidden" name="y2" value="210" />
						<input type="hidden" name="avatar" value="" />
						<button type="submit" class="btn btn-warning">Сохранить</button>
						<button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
					 </div>
				 </center>
			</form>
	</div>
</div>