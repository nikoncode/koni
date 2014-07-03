<div class="span3  lthr-bgborder block">
	<div>
		<h3 class="inner-bg">По параметрам</h3>
		<form class="search-friends-filter">
			
			<!--<div class="sff-block">
				<label>Пол</label>
					<select>
					<option>Любой</option>
					<option>Мужской</option>
					<option>Женский</option>
					</select>-->

				 <label>Возраст</label>
				<input type="text" name="age1" class="span-mini" placeholder="От"> - <input type="text" name="age2" class="span-mini"  placeholder="До">
			</div>
			
			<div class="sff-block">
				<label>Страна</label>
				<select name="country">
					<option selected disabled>Не важно</option>
					{foreach $countries as $country}
						<option>{$country}</option>
					{/foreach}
				</select>

				<label>Город</label>
				<input type="text" name="city" placeholder="Любой город" class="span3">
			</div>
			
			 <div class="sff-block">
					<label>Клуб</label>
						<input type="text" name="club" placeholder="Название клуба" class="span3">
						<label>Профессии</label>
						<ul class="unstyled">
							{foreach $works as $work}
								<li><label class="checkbox"><input type="checkbox" name="work[]" value="{$work}">{$work}</label></li>
							{/foreach}
						</ul>
			</div>
			
			
			
		</form>
	</div>
</div>