{* Smarty *}

{include "modules/header.tpl"}

<script src="http://odnokonniki.ru:1337/socket.io/socket.io.js"></script>
<script>
/* add new message to the dialog function */

function add_message(data) {
		lastel = $(".chat-window .chat-dialog:last");
		lastId = lastel.attr("data-uid");
    var noread = '';
    if(data.status == 0) noread = 'noread';
    $('#no-messages').remove();
		if (lastId==data.id) {
			lastel.find(".span5").append("<div class='message "+noread+"'> \
											<p class='date'>" + data.time + "</p> \
											<p>" + data.text + "</p> \
										 </div>");
		} else {


			$("<div class='chat-dialog user-id" + data.id + "' data-uid='" + data.id + "'> \
				<div class='row'> \
					<div class='chat-user-info span1'> \
						<a href='/user.php?id=" + data.id + "'><img src='" + data.avatar + "' class='avatar'></a> \
					</div> \
					<div class='span5'> \
						<div class='message "+noread+"'> \
							<p class='user-name'><a href='/user.php?id=" + data.id + "'>" + data.fio + "</a></p> \
							<p class='date'>" + data.time + "</p> \
							<p>" + data.text + "</p> \
						</div> \
					</div> \
				</div> \
			</div>").appendTo(".chat-window");
		}	
}

/* send message function */
function send_message () {
		var message_text = $("#mtext").val();
    var user_id = $('#user-id').val();
    $('.chat-dialog:not(.user-id'+user_id+') .message.noread').removeClass('noread');
		$("#mtext").val("");
		if (message_text.replace(/\s+/g,'').length == 0) {
			return false;
		}
		var date;
		date = new Date();
		date = date.getUTCFullYear() + '-' +
		('00' + (date.getUTCMonth()+1)).slice(-2) + '-' +
		('00' + date.getUTCDate()).slice(-2) + ' ' + 
		('00' + date.getUTCHours()).slice(-2) + ':' + 
		('00' + date.getUTCMinutes()).slice(-2) + ':' + 
		('00' + date.getUTCSeconds()).slice(-2);
		socket.emit("send_message", {
			text: message_text,
			time: date
		});
}

/* Socket initialize and subscribe to events */
var socket = io.connect('http://odnokonniki.ru:1337');
socket.on("connect", function () {
	socket.on("init_load_history", function (data) {
		$(".chat-window .chat-dialog").remove();
		for (var i = data.length-1; i > -1; i--) {
			add_message(data[i]);
		}
        if(data.length == 0){
            $('.chat-window').append('<center id="no-messages">Пока еще нет сообщений...</center>')
        }
		$(".chat-window").scrollTop(9999);
	});
	socket.on("receive_msg", function (data) {
		add_message(data);
		$(".chat-window").scrollTop(9999);
	});
});

$(function () {
	$("#mtext").keydown(function (e) {
		if (e.keyCode==13) {
			send_message();
			return false;
		}
	});
});
</script>
<div class="container chat-page main-blocks-area">
		<div class="row">
			{include "modules/sidebar-my-left.tpl"}
			<div class="brackets" id="bra-2"></div>
			<div class="brackets" id="bra-3"></div>	
			
			<div class="span6 lthr-border block" style="background-color: #fff">
				<div>
				<h3 class="inner-bg">{$another_user.fio}<span class="pull-right"><a href="/messages.php">Вернуться к диалогам</a></span></h3>
					<div class="row">
							
						<div class="chat-window row">						
							
						
						</div> <!-- chat-window  -->
						
						<form class="add-chat-message lthr-bg" onsubmit="send_message();return false;">
							<div class="controls-row">
								<img src="{$user.avatar}" class="avatar" class="span1">
								<textarea placeholder="Напишите сообщение" class="span5" id="mtext"></textarea>
							</div>
							<div class="controls-row">
								<input type="hidden" value="{$user.id}" id="user-id" />
								<input type="submit" value="Отправить" id="smessage" class="btn btn-warning offset1 span2" />
							</div>
						</form>
							
					</div>
				</div>
			</div>
			
			{include "modules/sidebar-user-right.tpl"}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}