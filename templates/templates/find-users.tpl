{* Smarty *}
{include "modules/header.tpl"}
<script type="text/javascript" src="js/friends.js"></script>
<script>
function add_to_friend_callback(uid, el) {
	add_to_friend(uid, function () {
		$(el).attr("onclick", "delete_from_friend_callback(" + uid + ", this);return false;");
		$(el).text("Удалить из друзей");	
	});
}

function delete_from_friend_callback(uid, el) {
	delete_from_friend(uid, function () {
			$(el).attr("onclick", "add_to_friend_callback(" + uid + ", this);return false;");
			$(el).text("Добавить в друзья");
	});
}

function user_search(form) {
	api_query({
		qmethod: "POST",
		amethod: "user_find",
		params: $(form).serialize(),
		success: function (data) {
			$(".friends-list").html(data);
		},
		fail: "standart"
	})
}
</script>
<div class="container news-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" id="centerBlock" style="background-color: #fff">
				<h3 class="inner-bg">Искать пользователей</h3>
				<div class="row">
						<form class="form-in-messages" onsubmit="user_search(this);return false;">
						<div class="controls controls-row">
								<input type="text" class="span4 search-query" name="q" placeholder="Начните вводить имя или название">
								<input type="submit" class="btn btn-warning span2" value="Искать" />
						</div>
						<!--</form>-->
					</div>
				<div class="friends-list">
					<p style="text-align: center;">Начните поиск.</p>
				</div>
			</div>
			
			{include "modules/sidebar-friends-add.tpl"}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}