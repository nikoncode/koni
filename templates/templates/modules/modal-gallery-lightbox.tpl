{* Smarty *}
<script>
    {literal}
    function update_description(form) {
        api_query({
            qmethod: "POST",
            amethod: "gallery_update_description",
            params: $(form).serialize(),
            success: function (resp) {
                var desc = $('#change_description_form textarea').val();
                $('#change_description_form').css('display','none');
                $('#gallery_desc').html(desc);
                $('#gallery_desc').css('display','');
            },
            fail: "standart"
        })
    }

    function change_description(){
        var desc = $('#gallery_desc').html();
        $('#change_description_form').css('display','inline-block');
        $('#change_description_form textarea').html(desc);
        $('#gallery_desc').css('display','none');
    }
    {/literal}
</script>
<!-- модалка галереи -->
									<div id="modal-gallery-post" class="modal hide modal900 modal-notitle modal-gallery-post" tabindex="-1" role="dialog">
										<div class="modal-images-gallery">
											<a href="#" class="gallery-slide-left" id="gallery_prev"></a>
											<a href="#" class="gallery-slide-right" id="gallery_next"></a>
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
											<img src="i/sample-img-1.jpg" id="gallery_full" />
                                            <iframe id="video_full" width="886" height="490" src="" frameborder="0" allowfullscreen></iframe>
										</div>
										<div class="modal-body">
											<table class="image-info"> <!-- класс .without-descr добавленный к таблице делает модалку без начального описания-->
												<tr>
                                                    <td style="display: none" id="change_description">
                                                        <a href="#" class="icon-pencil" onclick="change_description()"></a>
                                                        <form style="display: none" id="change_description_form" onsubmit="update_description(this);return false;">
                                                            <textarea name="desc[]"></textarea><br/>
                                                            <button class="btn btn-warning span3" href="#" type="submit">Сохранить</button>
                                                        </form>
                                                    </td>
													<td class="description" id="gallery_desc"><p>Надо сказать, что вещь в себе творит трансцендентальный катарсис, хотя в официозе принято обратное. Представляется логичным, что дуализм выводит здравый смысл, хотя в официозе принято обратное. Надо сказать, что гравитационный парадокс неоднозначен. Здравый смысл может быть получен из опыта. Единственной космической субстанцией Гумбольдт считал материю, наделенную внутренней активностью, несмотря на это гештальтпсихология непредвзято порождает и обеспечивает предмет деятельности, открывая новые горизонты. Гегельянство, по определению, реально трансформирует дедуктивный метод, ломая рамки привычных представлений.</p>
                                                        <div class="answer-block">
														<!--<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>-->
													    </div>
													</td>

													<td class="info" align="right">
														<ul>
															<li><p class="dt">Добавлена:</p>
															<p class="dd date" id="gallery_date">15.02.2013 в 14:11</p></li>
															<li><p class="dt">Отправитель:</p>
															<p class="dd author" id="gallery_author"><a href="#">Leon Ramos</a></p></li>
															<li><p class="dt">Альбом:</p>
															<p class="dd album" id="gallery_album">Запись на стене</p></li>
														</ul>
                                                        <ul>
                                                            <li><a href="#" id="gallery_delete"><i class="icon-trash"></i>Удалить фотографию</a></li>
                                                            <li><a href="#" id="gallery_change_album">Изменить альбом</a></li>
                                                        </ul>
													</td>
											</table>
										</div>
										<div class="comments_container">

										</div>
</div>
<!-- //модалка галереи -->