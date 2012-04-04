[% IF products %]
<table id="comparison_table">
<a id="erase_comparison">Очистить список</a>
<tr>
    <th>Изображение</th>
    <th>Название</th>
    <th>Описание</th>
    <th>Цена</th>
    <td></td>
</tr>
[% ELSE %]
  <p>Список пусть</p>
[% END %]
[% FOREACH product = products %]
    <tr>
	<td><img src='/application/media/img/products/thumb/[% product.image %]' /></td>
	<td>[% product.name %]</td>
	<td>[% product.description %]</td>
	<td>[% product.price %]</td>
	<td><a class="comparison" id="product_id_[% product.id %]" >Удалить</a></td>
    </tr>
[% END %]
</table>