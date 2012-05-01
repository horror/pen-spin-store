<form id="comment_form" action="index.pl?controller=products&action=add_comment" method="post">
    <textarea name="content"></textarea><br />
    <input type="hidden" name="product_id" value="[% product_id %]" />
    <input type="hidden" name="comment_id" value="[% comment_id %]" />
    <input type="hidden" name="comment_path" value="[% comment_path %]" />
    <input type="submit" name="comment_submit" value="Добавить коментарий" />
</form>