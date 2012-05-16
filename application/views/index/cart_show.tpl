<nav class="horz products_edit_menu ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix">
    <ul>
	<li><a id="confirmation">Оформить заказ</a></li>
	<li><a href="index.pl?controller=cart&action=erase_cart">Очистить карзину</a></li>
    </ul>
</nav>
<section id="order_confirmation">
    <form id="order_confirmation_form" method="get" action="index.pl">
	<input type="hidden" name="controller" value="cart">
	<input type="hidden" name="action" value="check_out">
	<label for="address">Адрес доставки: </label>
	<input type="text" id="address" name="address" value="[% address %]">
    </form>
</section>
<table id="cart_grid"></table>
<section id="pager"></section>