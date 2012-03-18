<nav class="horz">
    <ul>
    [% FOREACH menu_item IN menu_items %]
	<li><a href="[% menu_item.uri %]" class="selected_item">[% menu_item.caption %]</a></li>
    [% END %]
    </ul>
</nav>
