/* friends unit */
console.info("friends.js file loaded");
function add_to_friend(uid, callback) {
	api_query({
		qmethod: "POST",
		amethod: "friends_add",
		params:  {id: uid},
		success: function(resp) {
			callback.call(resp);	
		},
		fail:    "standart"
	});
}

function delete_from_friend(uid, callback) {
	api_query({
		qmethod: "POST",
		amethod: "friends_delete",
		params:  {id: uid},
		success: function(resp) {
			callback.call(resp);
		},
		fail:    "standart"
	});
}