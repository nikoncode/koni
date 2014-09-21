{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
{include "modules/modal-adv-lightbox.tpl"}
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="js/adv-functions.js"></script>
<script src="js/comments.js"></script>
<script src="js/likes.js"></script>
{literal}
    <script>
        var active_parent;
        $(function () {
            $("[data-gallery-list]").each(function () {
                gallery_initialize(this);
            })
        })

        /* initialize function */
        function gallery_initialize(parent) {
            $(parent).find("[data-gallery-pid]").each(function (){
                $(this).attr("onclick", "gallery_open_modal(this, "+$(this).attr("data-gallery-pid")+");return false;");
            })
        }
        function gallery_open_modal(element, pid) {
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
                amethod: "adv_photo_info",
                params: {id : pid},
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
                    mdl.find("#gallery_next").attr("onclick", "gallery_open_modal(active_parent, " + next + "); return false;");
                    mdl.find("#gallery_prev").attr("onclick", "gallery_open_modal(active_parent, " + prev + "); return false;");

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
                        mdl.find("#gallery_delete").attr("onclick",  "gallery_photo_delete(" + pid + "); return false;");
                        mdl.find("#gallery_change_album").attr("onclick",  "gallery_change_album(" + pid + "," + resp.album_id + "); return false;");
                        mdl.find("#gallery_delete").css("display", "block");
                        mdl.find("#gallery_change_album").css("display", "block");
                        mdl.find("#change_description").css("display", "block");
                        mdl.find("#change_description textarea").attr("name", "desc["+pid+"]").html(resp.desc);
                    } else {
                        mdl.find("#gallery_delete").css("display", "none");
                        mdl.find("#gallery_change_group").css("display", "none");
                        mdl.find("#change_description").css("display", "none");
                    }
                    mdl.find("#gallery_full").attr("src", resp.full);
                },
                fail: "standart"
            })
        }
    </script>
{/literal}
<link rel="stylesheet" href="css/range.css">
<div class="container main-blocks-area adv-page adv-single-page">
    <div class="row">
        <div class="span12 lthr-bgborder block">
            <h3 class="inner-bg">Продажа Bentley continental gt, г. Москва, 2014 г.<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>

            <div class="row">
                <div class="span12">  <!--инфа-->

                    <ul class="breadcrumb">
                        <li><a href="adv.php">Все объявления</a> <span class="divider">/</span></li>
                        <li><a href="adv.php">Транспорт</a> <span class="divider">/</span></li>
                        <li><a href="adv.php">Аренда</a></li>
                    </ul>

                    <div class="row">
                        <div class="span3">
                            <ul class="adv-gallery" data-gallery-list="{$photos_ids_list}">
                                {foreach $photos as $photo}
                                    <li><a data-gallery-pid="{$photo.id}" href="#"><img src="{$photo.full}" class="img-polaroid"></a></li>
                                {/foreach}
                            </ul>
                        </div>
                        <div class="span9">
                            <h1>{$horse.marka}</h1>

                            <div class="adv-price">Цена: <span class="p-amount">{$horse.price|number_format:0:".":" "}</span> <span class="p-cur">{$horse.curr}</span></div>
                            <div class="adv-price-btns">
                                <a href="/chat.php?id={$horse.user_id}" class="btn btn-warning"><i class="icon-comment icon-white"></i> Написать владельцу</a>
                                <a href="#" class="btn"><i class="icon-star"></i> Добавить в избранное</a>
                            </div>

                            <label>Основные параметры</label>
                            <ul class="adv-bullets">
                                <li><strong>Год производства:</strong>{$horse.age}</li>
                                <li><strong>Местоположение:</strong>{$horse.country}</li>
                                <li><strong>Состояние:</strong>{$horse.sost}</li>
                                <li><strong>Город:</strong>{$horse.city}</li>
                                <li><strong>Комнаты сопровождающих:</strong>{$horse.mest} шт.</li>
                                <li><strong>Оборудование:</strong>{$horse.oborud}</li>
                                <li><strong>Кол-во стойл:</strong>{$horse.stoil}</li>
                                <li><strong>Участие в соревнованиях:</strong>Да</li>
                            </ul>

                            <label>Дополнительные параметры</label>
                            <ul class="adv-bullets">
                                <li><strong>Коробка передач:</strong>{$horse.dop.kpp}</li>
                                <li><strong>Подвеска:</strong>{$horse.dop.podveska}</li>
                                <li><strong>Объём двигателя:</strong>{$horse.dop.dvigatel} л.</li>
                                <li><strong>Топливный бак:</strong>{$horse.dop.bak} л.</li>
                                <li><strong>Радиус колёс машины:</strong>{$horse.dop.radius} мм.</li>
                                <li><strong>Количество осей:</strong>{$horse.dop.os} оси</li>
                                <li><strong>Кол-во лошадинных сил:</strong>{$horse.dop.ls} л.с.</li>
                                <li><strong>Бак для воды (л.):</strong>{$horse.dop.bak_vodi} л.</li>
                                <li><strong>Пробег, км:</strong>{$horse.dop.probeg|number_format:0:".":" "} км.</li>
                                <li><strong>Общая масса:</strong>{$horse.dop.massa} кг.</li>
                                <li><strong>Наличие фаркопа:</strong>{$horse.dop.farkop} шт.</li>
                            </ul>

                            <div class="adv-about">
                                <strong>О транспорте:</strong>
                                <p>{$horse.descr}</p></div>

                        </div>
                    </div>
                </div>


                <div class="span12">{$comments_bl}</div>
            </div>

        </div> <!-- /row -->
    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}