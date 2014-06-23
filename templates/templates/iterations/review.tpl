{* Smarty *}
<li class="comment">
	<img src="{$review.avatar}" class="avatar" />
	<p class="user-name"><a href="/user.php?id={$review.o_uid}">{$review.fio}</a></p>
	<p class="date">{$review.time}</p>
	<div class="horseshoe-rate-block">
		<ul class="horseshoe-rate">
			{for $t_rating=1 to 5}
				<li class="horseshoe rate-{$t_rating} {if $t_rating <= $review.rating}active{/if}"></li>
			{/for}
		</ul>
		<div class="clearfix"></div>
	</div>
	<p class="message">{$review.text}</p>
	<div class="useful-review">
		<p><em>Отзыв полезен? </em><span><a href="#" class="yes-useful" onclick="useless({$review.review_id}, 1, this); return false;">Да:</a> <span class="plus">{$review.plus}</span> / </span><span><a href="#" class="not-useful" onclick="useless({$review.review_id}, 2, this); return false;">Нет:</a> <span class="minus">{$review.minus}</span </span></p>
	</div>
</li>