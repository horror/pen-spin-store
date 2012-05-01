<section id="comments">
    [% FOREACH comment IN comments %]
	<article style="margin-left:[% IF comment_cnt > 1 %][% comment.level * 40 %][% END %]px" id="[% comment.id %]">
	    <header class="comment_header">
		<h1>Комментарий от [% comment.user_name %]</h1>
		<time>[% comment.time %]</time>
		[% IF comment_cnt > 1 %]
		    <a href="index.pl?controller=products&action=detailes&id=[% product_id %]&comment_id=[% comment.id %]&comment_path=[% comment.path %]" class="recomment">Ответить</a>
		    [% IF comment.has_child %]<a href="index.pl?controller=products&action=detailes&id=[% product_id %]&comment_path=[% comment.path %]#[% comment.id %]" class="showchild">Развернуть</a>[% END %]
		    [% IF admin_role && !comment.deleted %]<a href="index.pl?controller=products&action=del_comment&id=[% product_id %]&comment_id=[% comment.id %]#[% comment.id %]">удалить</a>[% END %]
		[% END %]
	    </header>
	    [% comment.content %]
	</article>
    [% END %]
</section>
<section id="comment_form">
    [% comment_form %]
</section>