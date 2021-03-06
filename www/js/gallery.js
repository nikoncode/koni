console.info("Gallery module linked.");

var active_parent;

/* auto initialize all galleries on page */
$(function () {
	$("[data-gallery-list]").each(function () {
		gallery_initialize(this);
	})
})

/* initialize function */
function gallery_initialize(parent) {
	$(parent).find("[data-gallery-pid]").each(function (){
		$(this).attr("onclick", "gallery_open_modal(this, "+$(this).attr("data-gallery-pid")+",0);return false;");
	});
    $(parent).find("[data-video-pid]").each(function (){
		$(this).attr("onclick", "gallery_open_modal(this, "+$(this).attr("data-video-pid")+",1);return false;");
	});
}

/* open modal & change photo function */
function gallery_open_modal(element, pid, video) {
	var mdl = $("#modal-gallery-post");
	mdl.find("#gallery_full").attr("src", "/images/preloader.gif");
	active_parent = $(element).closest("[data-gallery-list]");
	var photo_list = active_parent.attr("data-gallery-list").split(",");
	var position = photo_list.indexOf(String(pid));

	if (position == -1) {
		console.warn("All photos deleted.");
		mdl.modal("hide");
		return;
	}
	
	api_query({
		qmethod: "POST",
		amethod: "gallery_photo_info",
		params: {id : pid,video : video},
		success: function (resp, data) {
			mdl.find(".comments_container .comments").remove();
			mdl.find(".comments_container").append(resp.comments);

			/* compute next & prev index */
			var next = position + 1, prev = position - 1;
			if (next >= photo_list.length) {
				next = 0;
			}
			if (prev < 0) {
				prev = photo_list.length - 1;
			}
			
			/* from index to values */
			next = photo_list[next];
			prev = photo_list[prev];

			/* bind navigation arrows */
			mdl.find("#gallery_next").attr("onclick", "gallery_open_modal(active_parent, " + next + ", " +video+ "); return false;");
			mdl.find("#gallery_prev").attr("onclick", "gallery_open_modal(active_parent, " + prev + ", " +video+ "); return false;");

			/* check if modal open */
			if (!mdl.hasClass("in")) {
				mdl.modal("show");
			}

			/* change values */
			mdl.find("#gallery_desc").css('display','');
			mdl.find("#change_description_form").css('display','none');
			mdl.find("#gallery_desc").text(resp.desc);
			mdl.find("#gallery_date").text(resp.time);
			mdl.find("#gallery_author a").text(resp.user_name);
			mdl.find("#gallery_author a").attr("href", "/user.php?id=" + resp.user_id);
			if (resp.album_name !== null) {
				mdl.find("#gallery_album").text(resp.album_name);
			} else {
				mdl.find("#gallery_album").text("Фотографии пользователя '" + resp.user_name + "'")
			}

			/* bind delete */
			active_parent.attr("data-gallery-pos", position);
			if (resp.own == 1) {
				mdl.find("#gallery_delete").attr("onclick",  "gallery_photo_delete(" + pid + ", " +video+ "); return false;");
				mdl.find("#gallery_change_album").attr("onclick",  "gallery_change_album(" + pid + "," + resp.album_id + "," + resp.album_club_id + "); return false;");
				mdl.find("#gallery_delete").css("display", "block");
				mdl.find("#gallery_change_album").css("display", "block");
				mdl.find("#change_description").css("display", "block");
				mdl.find("#change_description textarea").attr("name", "desc["+pid+"]").html(resp.desc);
			} else {
				mdl.find("#gallery_delete").css("display", "none");
				mdl.find("#gallery_change_album").css("display", "none");
				mdl.find("#gallery_change_group").css("display", "none");
                mdl.find("#change_description").css("display", "none");
			}

            if(video != '' && video > 0){
                mdl.find("#video_full").attr("src", '//www.youtube.com/embed/'+resp.video);
                mdl.find("#gallery_full").css("display", 'none');
                mdl.find("#gallery_delete").html('<i class="icon-trash"></i>Удалить видео');
            }else{
                mdl.find("#gallery_full").attr("src", resp.full);
                mdl.find("#video_full").css("display", 'none');
                mdl.find("#gallery_delete").html('<i class="icon-trash"></i>Удалить фотографию');
            }
		},
		fail: "standart"
	})
}

function gallery_photo_delete(pid,video) {
    var text = 'Вы уверены, что хотите удалить эту фотографию?';
    if(video > 0) text = 'Вы уверены, что хотите удалить это видео?';
    if(confirm(text)){
        api_query({
            qmethod: "POST",
            amethod: "gallery_photo_delete",
            params: {id : pid, video:video},
            success: function (resp) {
                var photo_list = active_parent.attr("data-gallery-list").split(",");
                photo_list.splice(photo_list.indexOf(String(pid)), 1);
                active_parent.attr("data-gallery-list", photo_list.join(","));
                if(video > 0){
                    active_parent.find("[data-video-pid="+pid+"]").parent().remove();
                }else{
                    active_parent.find("[data-gallery-pid="+pid+"]").parent().remove();
                }

                gallery_open_modal(active_parent, photo_list[active_parent.attr("data-gallery-pos")],video);
            },
            fail: "standart"
        });
    }
}

function gallery_change_album(pid,album_id,club_id) {
    var mdl = $("#modal-gallery-change-album");
    mdl.find('#change-photo-id').val(pid);
    mdl.find('#change-club-id').val(club_id);
    mdl.find('#change-photo-albums option[value="'+album_id+'"]').prop('selected',true);
    $("#modal-gallery-post").modal("hide");
    mdl.modal("show");

}