<section id="comments">
    <form id="expand_level_form" method="get" action="index.pl">
	<table><tr>
	<td>
	    <label for="expand_level">Отображаемая вложенность: </label>
	    <input type="number" id="expand_level" name="expand_level" min="0" max="100" value="[% expand_level %]" [% IF expand_level == 100 || expand_level == 0 %] disabled="disabled" [% END %] />
	</td>
	<td align="right" width=300>
	    <label for="expand_all">Отобразить все комментарии</label>
	    <input type="radio" id="expand_all" name="expand_radical" name="all" value="100" [% IF expand_level == 100 %] checked [% END %] />
	    <label for="expand_no">Скрыть все комментарии</label>
	    <input type="radio" id="expand_no" name="expand_radical" value="0" [% IF expand_level == 0 %] checked [% END %]  />
	    <label for="expand_manual">Отобразить произв. уровень</label>
	    <input type="radio" id="expand_manual" name="expand_radical" value="manual" [% IF expand_level > 0 && expand_level < 100  %] checked [% END %] />
	</td>
	<td>
	    <input type="submit" value="Применить">
	</td>
	    <input type="hidden" name="controller" value="products" />
	    <input type="hidden" name="action" value="detailes" />
	    <input type="hidden" name="id" value="[% product_id %]" /> 
	</tr></table>
    </form>
    [% IF admin_role %] <span id="admin_here_mark"> </span> [% END %]
    [% FOREACH comment IN comments %]
	<article style="margin-left:[% IF comment_cnt > 1 %][% comment.level * 40 %][% END %]px" id="[% comment.id %]">
	    <header class="comment_header">
		<h1>Комментарий от [% comment.user_name %]</h1>
		<time>[% comment.time %]</time>
		[% IF comment_cnt > 1 %]
		    <a class="comment_response" href="index.pl?controller=products&action=detailes&id=[% product_id %]&comment_id=[% comment.id %]&comment_path=[% comment.path %]" class="recomment">Ответить</a>
		    [% IF comment.has_child %]<a class="comment_show_branch" href="index.pl?controller=products&action=detailes&id=[% product_id %]&comment_path=[% comment.path %]#[% comment.id %]" class="showchild">Развернуть</a>[% END %]
		    [% IF admin_role && !comment.deleted %]<a href="index.pl?controller=products&action=del_comment&id=[% product_id %]&comment_id=[% comment.id %]#[% comment.id %]">удалить</a>[% END %]
		[% END %]
	    </header>
	    [% comment.content %]
	</article>
    [% END %]
    <section id="comment_form">
	[% comment_form %]
    </section>
</section>