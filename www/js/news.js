/*
* Это библиотека, для функций, которые нужны 
*/

/* Вызов форм редактирования */
function news_edit(e,nid) {
	api_query({
		qmethod: "GET",
		amethod: "api_get_news_edit_form",
		params: {"nid": nid},
		success: function (resp) {
			container = $(e).closest(".post-rem");
			container.find(".post").addClass("spoiled");
			container.prepend(resp[0])
			container.find(".man-news-tmpl").news_form();
		},
		fail: "standart"
	});
}

function comment_edit(e,cid) {
	api_query({
		qmethod: "GET",
		amethod: "api_get_comment_edit_form",
		params: {"cid": cid},
		success: function (resp) {
			container = $(e).closest(".comment");
			container.find(".comment-body").addClass("spoiled");
			container.append(resp[0]);
		},
		fail: "standart"
	});
}
/* Отправка изменненного коментария (для новости плагин jquery.news.plugin.js) */
function comment_update(e,cid) {
	api_query({
		qmethod: "POST",
		amethod: "api_comment_edit",
		params: {
			"cid": cid,
			"text": $(e).closest(".comment").find("textarea").val()
		},
		success: function (resp) {
			$(e).closest(".comment").html(resp[0]);
		},
		fail: "standart"
	});	
}

/* Удаление новости и комментария. */
function news_del(e, nid) {
	if(confirm('Вы точно хотите удалить эту новость? Вернуть его будет невозможно.'))
		api_query({
			qmethod: "GET",
			amethod: "api_news_del",
			params: {"nid": nid},
			success: function (resp) {
				$(e).closest(".post-rem").remove();
			},
			fail: "standart"
		});
}

function comment_del(e, cid) {
	if(confirm('Вы точно хотите удалить этот комментарий? Вернуть его будет невозможно.'))
		api_query({
			qmethod: "GET",
			amethod: "api_del_comment",
			params: {"cid": cid},
			success: function (resp) {
				$(e).closest(".comment").remove();
			},
			fail: "standart"
		}); 
}
/* отмена редактирования */

function remove_cedit_form(e) {
	if (confirm("Вы уверены?")) {
		container = $(e).closest(".comment");
		container.find(".comments-edit-template").remove();
		container.find(".comment-body").removeClass("spoiled");
	}
}

/* форма комментирования для новостей без комментариев */

function comment_form(e) {
	container = $(e).closest(".post-rem");
	container.find(".comments.dn").removeClass("dn");
	container.find(".comments textarea").focus();
}

/* Отправка комментария */

function commentSubmit(e) {
	api_query({
		qmethod: "POST",
		amethod: "api_add_comment",
		params: $(e).serialize(),
		success: function (resp) {
            $(e).parent().before(resp[0]); 
            $(e).find("textarea").val("");
            form.find(".replier a").remove();
		},
		fail: "standart"
	}); 	
    return false;
}