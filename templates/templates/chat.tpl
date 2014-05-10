{* Smarty *}

{include "modules/header.tpl"}

<script src="http://koni:1337/socket.io/socket.io.js"></script>
<script>
function add_message(data) {
		lastel = $(".chat-window .chat-dialog:last");
		lastId = lastel.attr("data-uid");
		if (lastId==data.id) {
			lastel.find(".span5").append("<div class='message'> \
											<p class='date'>" + data.time + "</p> \
											<p>" + data.text + "</p> \
										 </div>");
		} else { 
			$("<div class='chat-dialog' data-uid='" + data.id + "'> \
				<div class='row'> \
					<div class='chat-user-info span1'> \
						<a href='/user.php?id=" + data.id + "'><img src='" + data.avatar + "' class='avatar'></a> \
					</div> \
					<div class='span5'> \
						<div class='message'> \
							<p class='user-name'><a href='/user.php?id=" + data.id + "'>" + data.fio + "</a></p> \
							<p class='date'>" + data.time + "</p> \
							<p>" + data.text + "</p> \
						</div> \
					</div> \
				</div> \
			</div>").appendTo(".chat-window");
		}	
}

function send () {
		var date;
		date = new Date();
		date = date.getUTCFullYear() + '-' +
		('00' + (date.getUTCMonth()+1)).slice(-2) + '-' +
		('00' + date.getUTCDate()).slice(-2) + ' ' + 
		('00' + date.getUTCHours()).slice(-2) + ':' + 
		('00' + date.getUTCMinutes()).slice(-2) + ':' + 
		('00' + date.getUTCSeconds()).slice(-2);
		socket.emit("send_message", {
			text: $("#mtext").val(),
			time: date
		});
		$("#mtext").val("");
}

var socket = io.connect('http://koni:1337');
socket.on("connect", function () {
	socket.on("init_load_history", function (data) {
		$(".chat-window .chat-dialog").remove();
		for (var i = data.length-1; i > -1; i--) {
			add_message(data[i]);
		}
		$(".chat-window").scrollTop(9999);
	});
	socket.on("receive_msg", function (data) {
		add_message(data);
		$(".chat-window").scrollTop(9999);
	});
});

$(function () {
	$("#smessage").click(function () {
		send();
	});

	$("#mtext").keyup(function (e) {
		if (e.keyCode==13) {
			send();
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
							
							<div class="chat-dialog">
								<div class="row">
									<div class="chat-user-info span1">
										<a href="inner.php"><img src="i/sample-ava-1.jpg" class="avatar"></a>
									</div>
									<div class="span5">
										<div class="message">
											<p class="user-name"><a href="inner.php">Александр Гетманский</a></p>
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
									</div>
								</div>
							</div>
							
							<div class="chat-dialog">
								<div class="row">
									<div class="chat-user-info span1">
										<a href="inner.php"><img src="i/my-avatar-big.jpg" class="avatar"></a>
									</div>
									<div class="span5">
										<div class="message">
											<p class="user-name"><a href="inner.php">Иннокентий Смоктуновский</a></p>
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
									</div>
								</div>
							</div>
							
							<div class="chat-dialog">
								<div class="row">
									<div class="chat-user-info span1">
										<a href="inner.php"><img src="i/sample-ava-1.jpg" class="avatar"></a>
									</div>
									<div class="span5">
										<div class="message">
											<p class="user-name"><a href="inner.php">Александр Гетманский</a></p>
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
									</div>
								</div>
							</div>
							
							<div class="chat-dialog">
								<div class="row">
									<div class="chat-user-info span1">
										<a href="inner.php"><img src="i/my-avatar-big.jpg" class="avatar"></a>
									</div>
									<div class="span5">
										<div class="message">
											<p class="user-name"><a href="inner.php">Иннокентий Смоктуновский</a></p>
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
										
										<div class="message">
											<p class="date">15.02.2013 в 14:11</p>
											<p>Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</p>
										</div>
									</div>
								</div>
							</div>
						
						</div> <!-- chat-window  -->
						
						<form class="add-chat-message lthr-bg">
							<div class="controls-row">
								<img src="{$user.avatar}" class="avatar" class="span1">
								<textarea placeholder="Напишите сообщение" class="span5" id="mtext"></textarea>
							</div>
							<div class="controls-row">
								<input type="submit " value="Отправить" id="smessage" class="btn btn-warning offset1 span2" />
							</div>
						</form>
							
					</div>
				</div>
			</div>
			
			{include "modules/sidebar-user-right.tpl"}

		</div> <!-- /row -->
</div>

{include "modules/footer.tpl"}