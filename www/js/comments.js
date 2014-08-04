/* comments unit file */
console.info("Comments.js linked");
$(function () {
    $(".answer-message").keydown(function (e) {
        if (e.ctrlKey && e.keyCode == 13) {
            $(this).closest('td').find('.comment-submit').click();
            return false;
        }
    });
});
function comments_extra(key, id, element) {
	if ($(element).attr("data-cached") === "0") {
		api_query({
			qmethod: "POST",
			amethod: "comments_extra",
			params: {type : key, id : id},
			success: function (data) {
				var len = data.length - 3;
				var comments = "";
				for (i = 0; i < len; ++i) {
					comments += data[i] + "\n";
				}		
				$(element).after(comments);
				$(element).attr("data-cached", 1);
			},
			fail: "standart"
		})
	} else {
		$(element).closest(".comments-lists").find("li.comment").slice(1, length - 5).css("display", "block");
	}

	$(element).text("Свернуть");
	$(element).attr("onclick", "comments_hide('" + key + "', " + id + ", this);");
}

function comments_hide(key, id, element) {
	$(element).closest(".comments-lists").find("li.comment").slice(1, length - 5).css("display", "none");
	$(element).text("Показать еще");
	$(element).attr("onclick", "comments_extra('" + key + "', " + id + ", this);");
}

function answer_form_maximize(element) {
	$(element).closest("form").removeClass("min").addClass("max");
}

function answer_form_minimize(element) {
	if ($(element).val() == "") {
		$(element).closest("form").removeClass("max").addClass("min");
	}
}

function response(element) {
	var box = $(element).closest("li").find("div.comments");
	if (box.css("display") == "none") {
		box.css("display", "block");
	}
	box.find("textarea").focus();
}

function name_to_comment(name,element) {
	var box = $(element).closest(".comments");
	if (box.css("display") == "none") {
		box.css("display", "block");
	}
	box.find("textarea").html(name+', ');
	box.find("textarea").focus();
}

function add_comment(element) {
	api_query({
		qmethod: "POST",
		amethod: "comments_add",
		params: $(element).serialize(),
		success: function (data) {
			$(element).closest("li.answer-form").before(data[0]);
			$(element).closest("li.answer-form").find("textarea").val("").focus();	
		},
		fail: "standart"
	})	
}

function remove_comment(cid, element) {
	if (confirm("Действительно хотите удалить?")) {
		api_query({
			qmethod: "POST",
			amethod: "comments_remove",
			params: {id : cid},
			success: function (data) {
				$(element).closest("li.comment").remove();	
			},
			fail: "standart"
		})	
	}
}


function edit_comment_make(id, element) {
	api_query({
		qmethod: "POST",
		amethod: "comments_edit_form",
		params:  {cid : id},
		success: function (data) {
			var post = $(element).closest("li.comment");
			post.css("display", "none");
			post.before(data[0]);
			post.prev("li.answer-form").find("textarea").focus();
		},
		fail:    "standart"
	})
}

function edit_comment(element) {
	api_query({
		qmethod: "POST",
		amethod: "comments_edit",
		params:  $(element).serialize(),
		success: function (data) {
			var form = $(element).closest("li.answer-form");
			form.next("li.comment").remove();
			form.before(data[0]);
			form.remove();	
		},
		fail:    "standart"
	})
}

function edit_comment_cancel(element) {
	var form = $(element).closest("li.answer-form");
	form.next("li.comment").css("display", "block");
	form.remove();
}