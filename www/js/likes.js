/* js like unit */
console.info("likes.js file loaded");

function like(key, id, element) {
	api_query({
		qmethod: "POST",
		amethod: "like_add",
		params: {type : key, id : id},
		success: function (data) {
			var box = $(element);
			box.find(".likes_cnt").text(data.new_count);
			box.find(".icon-like").addClass("liked");
			box.attr("onclick", "unlike('" + key + "', "+ id + ", this); return false;");
		},
		fail: "standart"
	})
}

function unlike(key, id, element) {
	api_query({
		qmethod: "POST",
		amethod: "like_delete",
		params: {type : key, id : id},
		success: function (data) {
			var box = $(element);
			box.find(".likes_cnt").text(data.new_count);
			box.find(".icon-like").removeClass("liked");
			box.attr("onclick", "like('" + key + "', "+ id + ", this); return false;");	
		},
		fail: "standart"
	})
}