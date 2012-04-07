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
    <input type="hidden" name="anonymous_id" value="[% anonymous_id %]" />
    <div>&nbsp;</div><input type="submit" name="submit" value="[% submit_caption %]" />
</from>