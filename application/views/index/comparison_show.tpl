[% IF products_cnt %]
<a id="erase_comparison">Очистить список</a>
<br />

<section id="comparison_section">
<table id="comparison_table" class="comparison_table">
<tr>
    <th>Изображение</th>
    [% FOREACH product = products %]
    <td><img src='/application/media/img/products/thumb/[% product.image %]' /></td>
    [% END %]
</tr>
<tr>
    <th>Название</th>
    [% FOREACH product = products %]
    <td>[% product.name %]</td>
    [% END %]
</tr>
<tr>
    <th>Описание</th>
    [% FOREACH product = products %]
    <td>[% product.description %]</td>
    [% END %]
</tr>
<tr>
    <th>Цена</th>
    [% FOREACH product = products %]
    <td>[% product.price %]</td>
    [% END %]
</tr>
<tr>
    <th></th>
    [% FOREACH product = products %]
    <td><a class="comparison" id="product_id_[% product.id %]" >Удалить</a></td>
    [% END %]
</tr>
[% ELSE %]
  <p>Список пусть</p>
[% END %]
</table>
</section>