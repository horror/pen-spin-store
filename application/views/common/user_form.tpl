<form method="post">
    [% FOREACH message = messages %]
        <span class="message">[% message %]</span><br />
    [% END %]
    <div><label for="email">E-mail </label></div><div><input id="email" type="text" name="email" value="[% user_info.email %]" /></div>
    <div><label for="name">Имя </label></div><div><input id="name" type="text" name="name" value="[% user_info.name %]"  /></div>
    <div><label for="login">Логин </label></div><div><input id="login" type="text" name="login" value="[% user_info.login %]"  /></div>
    <div class="[% pass_block_class %]">
	<div><label for="password">Пароль </label></div><div><input id="password" type="password" name="password" value="[% user_info.password %]"  /></div>
	<div><label for="confim_password">Подтверждение </label></div><div><input id="confim_password" type="password" name="confim_password" value="[% user_info.password %]"  /></div>
    </div>
    [% IF role_changing %]
        <div><label for="sort_order">Права </label></div>
	<select id="role" name="role">
	    [% fields = {'0' = 'Пользователь', '1' = 'Администратор'} %]
	    [% FOREACH key_field IN fields.keys %]
		<option [% IF key_field == user_info.role %][% ' selected ' %][% END %] value="[% key_field %]" >[% fields.$key_field %]</option>
	    [% END %]
	</select>
    [% END %]
    <input type="hidden" name="user_id" value="[% user_info.id %]" />
    <div>&nbsp;</div><input type="submit" name="submit" value="[% submit_caption %]" />
</from>