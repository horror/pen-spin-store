﻿<h2 class="product_title">[% product_info.name %]</h2>
<ul id="product_images">
[% FOREACH image = product_images %]
    <li><img src='/application/media/img/products/[% image %]' /></li>
[% END %]
</ul>
<table id="product_table">
     <tr><td><strong>Цена:</strong> [% product_info.price %] $</td></tr>
     [% IF product_rating %]<tr><td><strong>Оценка:</strong> [% product_rating %] балл</td></tr>[% END %]
     <tr><td><strong>Описание:</strong> [% product_info.description %]</td></tr>
</table>