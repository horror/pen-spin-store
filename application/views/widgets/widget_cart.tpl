﻿<table>
<tr><td><a href="index.pl?controller=cart&action=show">
    <img id="cart_image" src="/application/media/img/[% IF product_cnt %]full_[% END %]cart.png" />
</a></td></tr>
[% IF product_cnt %]<tr><td>Товаров в корзине: [% product_cnt %]</td></tr>[% END %]
<tr><td><a href="index.pl?controller=comparison&action=show">Сравнить(<span id="campr_items_cnt">[% product_comp_cnt %]</span> шт.)</a></td></tr>
</table>