{* Smarty *}
<script>
    {literal}
    function update_description(form) {
        api_query({
            qmethod: "POST",
            amethod: "gallery_update_description",
            params: $(form).serialize(),
            success: function (resp) {
                alert(resp[0]);
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
										<div class="comments">
											<ul class="comments-lists" style="display: none;">
												<li class="comment">
													<img src="i/avatar-1.jpg" class="avatar" />
													<p class="user-name"><a href="#">Leon Ramos</a></p>
													<p class="date">15.02.2013 в 14:11</p>
													<p class="message">Для того, чтобы быть вместе. Просто быть вместе.</p>
													<div class="answer-block">
														<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
													</div>
												</li>
												
												<li class="comment">
													<img src="i/avatar-2.jpg" class="avatar" />
													<p class="user-name"><a href="#">Вася Горбунков</a></p>
													<p class="date">15.02.2013 в 13:11</p>
													<p class="message"><a href="#" class="comment-reply">Leon, </a>Так трудно, что порой перспектива видится не самым плохим вариантом.</p>
													<div class="answer-block">
														<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
													</div>
												</li>
												
												<li class="comment">
													<img src="i/sample-ava-5.jpg" class="avatar" />
													<p class="user-name"><a href="#">Эрик Филя</a></p>
													<p class="date">15.02.2013 в 14:11</p>
													<p class="message">Для того, чтобы быть вместе. Просто быть вместе. А это ведь трудно, очень трудно, и не только шизофреникам и юродивым. Всем трудно раскрываться, верить, отдавать, считаться, терпеть, понимать. Так трудно, что порой перспектива сдохнуть от одиночества видится не самым плохим вариантом.</p>
													<div class="answer-block">
														<p><span><a href="#">Ответить </a></span><span> | </span><span><a href="#">Мне нравится: 13 <i class="icon-heart"></i></a></span></p>
													</div>
												</li>
												
												<li class="answer-form">
													<form class="max">
															<div class="controls-row">
																<img src="i/my-avatar-big.jpg" class="my-avatar">
																<textarea type="text" class="answer-message" placeholder="Комментировать..."/></textarea>
															</div>
															<div class="controls-row">
															<input type="submit " value="Отправить" class="btn btn-warning  comment-submit span2">
															</div>
														</form>
												</li>
												
											</ul>
										</div>
</div>
<!-- //модалка галереи -->