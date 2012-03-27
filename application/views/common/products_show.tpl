<section id="tree_section">
    
    <table id="category_tree"></table>
    <section id="pager_tree"></section>

</section>

<section id="grid_section">
    
    <section id="edit_zone">
        <nav class="horz products_edit_menu ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix">
	    <ul>
		<li><a id="add_prod_btn">Добавить</a></li>
		<li><a id="edit_prod_btn">Изменить</a></li>
		<li><a id="del_prod_btn">Удалить</a></li>
	    </ul>
	</nav>
        <section id="edit_dialog">
            <form method="post" action="index.pl?controller=admin_products&action=set" id="edit_form" class="product_form" enctype="multipart/form-data">
		<div><label for="name">Название</label><input type="text" id="name" name="name"/></div>
		<div><label for="description">Описание</label><textarea id="description" name="description"></textarea></div>
		<div><label for="price">Цена</label><input type="text" id="price" name="price"/></div>
		<div><label for="images">Изображения<small>(ctrl + mclick)</small> </label><input id="images" type="file" name="multiple_files" multiple="true"/></div>
		<input type="hidden" id="category_id" name="cat_id" value="0"/>
		<input type="hidden" id="product_id" name="id" value="0" />
		<input type="hidden" id="oper" name="oper" value="add" />
	    </form>
        </section>
    </section>

    <table id="products_grid"></table>
    <section id="pager_grid"></section>
    
</section>