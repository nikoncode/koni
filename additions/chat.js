//node.js socket.io chat 
var io = require('socket.io').listen(1337);
var http = require("http");
var mysql = require("mysql");


io.set('log level', 1);
var query_options = {
	hostname: 'koni',
	port: 80,
	path: '/api/api.php?m=chat_me_info',
	method: 'POST',
	headers: {
		cookie : ''
	} 
};
var mysql_details = {
	host: 'localhost',
	user: 'root',
	password: '',
	database: 'test'
};

var connection;

function handleDisconnect() {
	connection = mysql.createConnection(mysql_details); 
	connection.connect(function(err) {              
		if(err) {                                     
			console.log('error when connecting to db:', err);
			setTimeout(handleDisconnect, 2000); 
		}                                     
	});                                     

	connection.on('error', function(err) {
		console.log('db error', err);
		if(err.code === 'PROTOCOL_CONNECTION_LOST') { 
			handleDisconnect();                        
		} else {                                      
			throw err;                                  
		}
	});
}

handleDisconnect();

function generate_room_name(id1, id2) {
	id1 = parseInt(id1);
	id2 = parseInt(id2);
	if (id1 > id2) return id2 + "/" + id1;
	return id1 + "/" + id2;
}

io.configure(function () {
	io.set('authorization', function (handshakeData, callback) {
		query_options.headers.cookie = handshakeData.headers.cookie;
		var req = http.request(query_options, function(res) {
			var all_response = ""; //to store all data

			res.setEncoding('utf8');
			
			res.on('data', function (chunk) {
				all_response += chunk; //concat all results part
			});

			res.on('end', function () {
				var resp = JSON.parse(all_response); 
				if (resp.type === "success") {
					var url_parts = require("url").parse(handshakeData.headers.referer, true);
					resp.response.room_name = generate_room_name(url_parts.query.id, resp.response.id);
					resp.response.friend_id = url_parts.query.id;
					handshakeData.dialog = resp.response;
					//console.log(handshakeData.user_details);
					console.log("INFO: AUTH DONE");
					callback(null, true);
				} else {
					console.log("INFO: AUTH FALSE");
					callback(null, false);
					return false;
				}
			});
		});
		req.end();	
	});
});

io.sockets.on("connection", function (socket) {
	console.log(socket.handshake.dialog);
	connection.query("SELECT messages.text, messages.time, CONCAT(users.fname,' ',users.lname) as fio, avatar, users.id FROM messages LEFT JOIN users ON uid=users.id WHERE (uid='"+socket.handshake.dialog.id+"' AND fid='"+socket.handshake.dialog.friend_id+"') OR (uid='"+socket.handshake.dialog.friend_id+"' AND fid='"+socket.handshake.dialog.id+"') ORDER BY time DESC LIMIT 10", function (err, rows, fields) {
		socket.emit("init_load_history", rows); //send last message to chat
		socket.join(socket.handshake.dialog.room_name); //join to room
		socket.on("send_message", function (data) {
			console.log("INFO: MESSAGE");
			data.id = socket.handshake.dialog.id;
			data.fid = socket.handshake.dialog.friend_id;
			data.fio = socket.handshake.dialog.fio;
			data.avatar = socket.handshake.dialog.avatar;
			io.sockets. in (socket.handshake.dialog.room_name).emit('receive_msg', data);
			console.log(data);
			connection.query("INSERT INTO `messages` (`id`, `uid`, `fid`, `text`, `time`) VALUES (NULL, '" + data.id + "', '"+ data.fid + "', '" + data.text + "', '" + data.time + "');");
		});	
	});
});
