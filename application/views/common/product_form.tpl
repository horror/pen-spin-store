<form method="post" enctype="multipart/form-data">
    <div><label for="name">Название </label></div><div><input id="name" type="text" name="name" value="[% prod_info.name %]" /></div>
    <div><label for="description">Описание </label></div><div><input id="description" type="text" name="description" value="[% prod_info.description %]"  /></div>
    <div><label for="price">Цена </label></div><div><input id="price" type="text" name="price" value="[% prod_info.price %]"  /></div>
    <div class="[% pass_block_class %]">
	<div><label for="password">Пароль </label></div><div><input id="password" type="password" name="password" value="[% prod_info.password %]"  /></div>
	<div><label for="confim_password">Подтверждение </label></div><div><input id="confim_password" type="password" name="confim_password" value="[% prod_info.password %]"  /></div>
    </div>
    <div><label for="images">Изображения<small>(ctrl + mclick)</small> </label></div><div><input type="file" name="images" multiple="true"/></div>
    <input type="hidden" name="user_id" value="[% prod_info.id %]" />
    <div>&nbsp;</div><input type="submit" name="submit" value="[% submit_caption %]" />
</from>