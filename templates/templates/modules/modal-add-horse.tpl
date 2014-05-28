{* Smarty *}
<script>
function add_parents() {
	$("<div class='controls controls-row'> \
		<select class='span2' name='pname[]'> \
			<option selected>Отец</option> \
			<option>Мать</option> \
			<option>Дедушка</option> \
			<option>Бабушка</option> \
		</select> \
		<input type='text' class='span4 offset1' placeholder='Имя отца лошади' name='parent[]'> \
	</div>").appendTo("#parents");	
}

function new_horse(form) {
	api_query({
		qmethod: "POST",
		amethod: "horses_add",
		params:  $(form).serialize(),
		success: function (data) {
			document.location.reload();
		},
		fail:    "standart"
	})
}

{literal}
function delete_horse(hid, element) {
	if (confirm("Вы действительно хотите удалить лошадь?")) {
		api_query({
			qmethod: "POST",
			amethod: "horses_delete",
			params:  {id : hid},
			success: function (data) {
				$(element).closest(".my-horse").remove();
			},
			fail:    "standart"
		})
	}
}

function edit_horse_prepare(hid) { //form clear
	api_query({
		qmethod: "POST",
		amethod: "horses_info",
		params:  {id : hid},
		success: function (data) {
			console.log(data);
			$.each(data, function( index, value ) {
				if (index == "avatar") {
					return; //avatar not working
				}
				$("[name="+index+"]").eq(0).val(value);
			});
			if (data.parents != "") {
				var parents = $.parseJSON(data.parents);
				$("#modal-add-horse #parents").html("");
				$.each(parents, function( index, value ) {
					add_parents();
					var place = $("#modal-add-horse #parents .controls-row:last");
					place.find("select").val(index);
					place.find("input").val(value);
				});
			}
			$("#modal-add-horse").modal("show");
		},
		fail:    "standart"
	})
}
{/literal}
</script>
<div id="modal-add-horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Добавление лошади</h3>
	</div>
	<div class="modal-body">
			<form class="form-horizontal"  method="post" action="#" onsubmit="new_horse(this);return false;">
						<div class="row">	
														
							<div class="controls controls-row">
								<label class="span3">Кличка лошади:</label><label class="span3">Пол лошади:</label>
								<input type="text" name="nick" class="span3">
								<select class="span3 offset1" name="sex">
									{foreach $const_horses_sex as $sex}
										<option>{$sex}</option>
									{/foreach}
							   </select>
							</div>
							
							<div class="controls controls-row">
								<label class="span3">Рост лошади:</label><label class="span3">Порода:</label>
								<input type="text" class="span3" name="rost">
								<select class="span3 offset1" name="poroda">
									{foreach $const_horses_poroda as $poroda}
										<option>{$poroda}</option>
									{/foreach}
							   </select>
							</div>
							
							<div class="controls controls-row">
								<label class="span3">Масть:</label><label class="span3">Специализация:</label>
								<select class="span3 offset1" name="mast">
									{foreach $const_horses_mast as $mast}
										<option>{$mast}</option>
									{/foreach}
							   </select>
								<select class="span3 offset1" name="spec">
									{foreach $const_horses_spec as $spec}
										<option>{$spec}</option>
									{/foreach}
							   </select>
							</div>
							
							<div class="controls controls-row">
								<label class="span3">Год рождения: <span class="req">*</span></label><label class="span3">Место рождения: <span class="req">*</span></label>
								<input type="text" class="span3" name="byear">
								<input type="text" class="span3" placeholder="Пример, клуб 'СССР'" name="bplace">
							</div>
							
							<hr/>

							<div id="parents">
								<div class="controls controls-row">
									<label class="span7">Родословная:</label>
									<select class="span2" name="pname[]">
										<option selected>Отец</option>
										<option>Мать</option>
										<option>Дедушка</option>
										<option>Бабушка</option>
								   </select>
								   <input type="text" class="span4 offset1" placeholder="Имя отца лошади" name="parent[]">
								</div>	
							</div>

							<div class="controls controls-row">
								<label class="span7"><a href="#" onclick="add_parents();return false;">Добавить ещё родственников</a></label>
							</div>
							
							<hr/>
							
							<div class="controls controls-row">
								<div class="span3">
									<img src="http://placehold.it/200x200" />
									<input name="avatar" type="hidden" value ="http://placehold.it/200x200" /> {*XSS*}
								</div>
								<div class="span3 offset1">
									<p>Главная фотография</p>
									<div class="content-add-buttons row">
										<div class="fileupload">
										  <input type="file" name = "salo">
										  <button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить фото</button>
										</div>
									</div>
									<p class="avatar-descr"><br/>Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
								</div>
							</div>
							
							<hr/>
							
							<!--<div class="add-files-to-gallery">
									<p>Добавить фото и видео в галерею лошади</p>
									<div class="content-add-buttons row">
										<div class="fileupload add-files-to-gallery">
											<input type="file" >
											<button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить файлы</button>
										</div>
									</div>
							</div>-->
							
							<div class="controls controls-row">
								<label class="span3">О лошади</label>
								<textarea class="span6" rows="10" name="about"></textarea>
							</div>
							
						</div>
						<hr/>
						<div class="row">	
							<div class="controls controls-row">
								<center>
								<button type="submit" class="btn btn-warning span3">Сохранить</button>
								<button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
			</form>
	</div>
</div>