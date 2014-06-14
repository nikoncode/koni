{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-create-adv.tpl"}
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="js/adv-functions.js"></script>
<script src="js/comments.js"></script>
<script src="js/likes.js"></script>
<link rel="stylesheet" href="css/range.css">

<div class="container main-blocks-area adv-page adv-single-page">
    <div class="row">
        <div class="span12 lthr-bgborder block">
            <h3 class="inner-bg">Продажа лошади "{$horse.nick}", г. {$horse.city}, {$horse.age} г.<span class="pull-right"><a  href="#createAdv" role="button" data-toggle="modal"><i class="icon-plus icon-white"></i> подать объявление</a></span></h3>

            <div class="row">
                <div class="span12">  <!--инфа-->

                    <ul class="breadcrumb">
                        <li><a href="adv.php">Все объявления</a> <span class="divider">/</span></li>
                        <li><a href="adv.php">Лошади</a> <span class="divider">/</span></li>
                        <li><a href="adv.php">Продажа</a></li>
                    </ul>

                    <div class="row">
                        <div class="span3">
                            <ul class="adv-gallery">
                                <li><a href="#"><img src="i/avatar-my-horse-1.jpg" class="img-polaroid"></a></li>
                                <li><a href="#"><img src="i/sample-img-2.jpg" class="img-polaroid"></a></li>
                                <li><a href="#"><img src="i/sample-img-3.jpg" class="img-polaroid"></a></li>
                                <li><a href="#"><img src="i/sample-img-4.jpg" class="img-polaroid"></a></li>
                                <li><a href="#"><img src="i/sample-img-5.jpg" class="img-polaroid"></a></li>
                            </ul>
                        </div>
                        <div class="span9">
                            <h1>{$horse.nick}</h1>

                            <div class="adv-price">Цена: <span class="p-amount">{$horse.price|number_format:0:".":" "}</span> <span class="p-cur">руб.</span></div>
                            <div class="adv-price-btns">
                                <a href="/chat.php?id={$horse.user_id}" class="btn btn-warning"><i class="icon-comment icon-white"></i> Написать владельцу</a>
                                <a href="#" class="btn"><i class="icon-star"></i> Добавить в избранное</a>
                            </div>

                            <ul class="adv-bullets">
                                <li><strong>Год:</strong>{$horse.age}</li>
                                <li><strong>Местоположение:</strong>{$horse.country}</li>
                                <li><strong>Порода:</strong>{$horse.poroda}</li>
                                <li><strong>Город:</strong>{$horse.city}</li>
                                <li><strong>Масть:</strong>{$horse.mast}</li>
                                <li><strong>Специализация:</strong>{$horse.spec}</li>
                                <li><strong>Рост:</strong>{$horse.height} см.</li>
                                <li><strong>Участие в соревнованиях:</strong>Да</li>
                            </ul>

                            <div class="adv-about">
                                <strong>О лошади:</strong>
                                <p>{$horse.descr}</p></div>

                        </div>
                    </div>
                </div>


                {$comments_bl}
            </div>

        </div> <!-- /row -->
    </div> <!-- /row -->
</div>
{include "modules/footer.tpl"}