<form class="rating" action="index.pl">
    Оцека товару: <input name="rating" type="number" min="0" max="5" value="0">
    <input type="submit" value="оценить">
    <input type="hidden" name="product_id" value="[% product_id %]">
    <input type="hidden" name="controller" value="products">
    <input type="hidden" name="action" value="class">
</form>