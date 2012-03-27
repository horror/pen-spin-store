<h2 class="product_title">[% product_info.name %]</h2>
<table>
<tr>
[% FOREACH image = product_images %]
    <td><img src='/application/media/img/products/[% image %]' /></td>
[% END %]
</tr>
<tr>
     <td>[% product_info.description %]</td>
     <td>[% product_info.price %]</td>
</tr>
</table>