﻿<form id="form_comment" action="index.pl?controller=products&action=add_comment" method="post">
    <textarea id="comment_content" name="content" cols="80" rows="20"></textarea><br />
    <input type="hidden" name="product_id" value="[% product_id %]" />
    <input id="form_comment_id" type="hidden" name="comment_id" value="[% comment_id %]" />
    <input id="form_comment_path" type="hidden" name="comment_path" value="[% comment_path %]" />
    <input type="submit" name="comment_submit" value="Добавить коментарий" />
</form>