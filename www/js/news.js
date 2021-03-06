/* news unit file */
console.info("news.js loaded");

function news_add(element) {
	tinyMCE.triggerSave();
	api_query({
		qmethod: "POST",
		amethod: "news_add",
		params:  $(element).serialize(),
		success: function (data) {
			$(element).find("textarea").val("");
			$(element).find("#attach").attr("data-album-id", "0");
			$(element).find("input[name=album_id]").val("0");
			$(element).find(".new-uploaded-img").remove();
			news_form_init($(".add-news:first"));
			$(".my-news-wall").prepend(data);
			/* init galleries in added posts */
			$("[data-gallery-list]").each(function () { //TO-DO: performance (fix reinit existing)
				gallery_initialize(this);
			});
			tinyMCE.activeEditor.setContent('');
		},
		fail:    "standart"
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

function news_form_init(form) {
	var element = form.find("#attach");
	album_id = element.attr("data-album-id");
	element.fileupload({
        url: "/api/api.php?m=gallery_upload_photo&album_id=" + album_id,
		dataType: 'json',
		done: function (e, data) {
			var result = data.result
			var response = result.response;
			if (result.type == "success") {
				$("<div class='new-uploaded-img span1'> \
					<img class='img-polaroid' src='" + response.preview + "' /> \
					<a href='#remove-image' onclick='news_form_delete_att(" + response.id + ", this); return false;'><img class='remove-image-icon' src='images/icon-remove-image.png' /></a> \
				   </div>").appendTo(form.find(".previews"));
                $(this).closest("form").find("input[name=album_id]").val(response.album_id);
                $(this).fileupload("option", "url", "/api/api.php?m=gallery_upload_photo&album_id=" + response.album_id);
			} else {
				for (i = 0;i < response.length; ++i)
					alert(response[i]);
			}
		}, 
		progressall: function (e, data) {
            form.find('.progress').css('display', 'block');
            var progress = parseInt(data.loaded / data.total * 100, 10);
            form.find('.progress .bar').css('width', progress + '%');
            if(progress > 99) form.find('.progress').css('display', 'none');
			console.log(form.find('.progress .bar'));
		}
	});	
}

function news_form_delete_att(photo_id, element) {
	api_query({
		qmethod: "POST",
		amethod: "gallery_photo_delete",
		params: {id : photo_id},
		success: function (resp) {
			$(element).closest(".new-uploaded-img").remove();
		},
		fail: "standart"
	})

}

function remove_news(nid, element) {
	if (confirm("Действительно хотите удалить?")) {
		api_query({
			qmethod: "POST",
			amethod: "news_delete",
			params: {id : nid},
			success: function (data) {
				$(element).closest("li.news-container").remove();	
			},
			fail: "standart"
		})	
	}
}

function edit_news_make(nid, element) {
	api_query({
		qmethod: "POST",
		amethod: "news_edit_form",
		params:  {id : nid},
		success: function (data) {
			var post = $(element).closest("div.post");
			post.css("display", "none");
			post.before(data[0]);
			news_form_init(post.prev("div.add-news"));
		},
		fail:    "standart"
	})

}

function edit_news_cancel(element) {
	var form = $(element).closest("div.add-news");
	form.next("div.post").css("display", "block");
	form.remove();
}

function news_edit(element) {
	api_query({
		qmethod: "POST",
		amethod: "news_edit",
		params:  $(element).serialize(),
		success: function (data) {
			var form = $(element).closest("div.add-news");
			form.next("div.post").remove();
			form.before(data[0]);
			/* init galleries in added posts */
			$("[data-gallery-list]").each(function () { //TO-DO: performance (fix reinit existing)
				gallery_initialize(this);
			});	
			form.remove();	
		},
		fail:    "standart"
	})
}