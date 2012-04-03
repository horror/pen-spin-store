function gen_table() { 
    jQuery("#products_grid").jqGrid({
   	url: 'index.pl?controller=json_products&action=get&cat_id=' + $.jCookies({ get : 'cat_id' }),
	editurl: 'index.pl?controller=json_products&action=set',
	datatype: "json",
	mtype: 'GET',
   	colNames:['id', 'Изображение', 'Название', 'Описание', 'Цена', 'Корзина'],
   	colModel:[
	        {name:'id',index:'id', hidden: true, width:55, align:"left", editable:false},
   		{name:'image',index:'image',sortable:false,align:"left",search:false,editable:true,editoptions:{size:10}, formatter: unitsInStockFormatter},
   		{name:'name',index:'name',align:"left",searchoptions:{sopt:['bw','bn','ew','en','cn','nc']},editable:true,editrules:{required:true},editoptions:{size:10}, formatter: nameFormatter, unformat: nameUnFormatter},
   		{name:'description',index:'description',align:"left",searchoptions:{sopt:['bw','bn','ew','en','cn','nc']},editable:true,editrules:{required:true},editoptions:{size:10}},
		{name:'price',index:'price',align:"left",searchoptions:{sopt:['eq','ne','lt','le','gt','ge']},editable:true,editrules:{required:true},editoptions:{size:10}},
		{name:'сart',align:"left",search:false,formatter: cartFormatter},
   	],
   	rowNum:10,
   	rowList:[10, 20, 30],
   	pager: '#pager_grid',
   	sortname: 'name',
	autowidth: true,
	height: 'auto',
	gridview : true,
	viewrecords: true,
	sortorder: "desc",
	caption:"Товары",
	onSelectRow: function(id){  
	    var dataFromTheRow = jQuery('#products_grid').jqGrid ('getRowData', id);
            $('#product_id').val(id);
	    var patt = />(.*?)<\/a>/;
            $('#name').val(dataFromTheRow.name.match(patt)[1]);
	    $('#description').val(dataFromTheRow.description);
	    $('#price').val(dataFromTheRow.price);
	}
    });
    
    jQuery("#products_grid").jqGrid('navGrid','#pager_grid',
        {del:false, add:false, edit:false}, //options
	{}, // edit options
	{}, // add options
	{}, // del options
	{multipleSearch:true,closeAfterSearch:true} // search options);
    );

};

function unitsInStockFormatter(cellvalue) {
    return (cellvalue) ? "<div class='product_image'><img src='/application/media/img/products/thumb/" + cellvalue + "' /></div>" : '';
}; 

function nameFormatter(cellValue, opts, rowObject) {
    return "<a class='product_link' href='index.pl?controller=products&action=detailes&id=" + rowObject[0] + "' >" + cellValue + "</a>";
};

function cartFormatter(cellValue, opts, rowObject) {
    return "<form action='index.pl?controller=cart&action=set&oper=add' method='post'>" +
        "<label for='p_cnt'>Количество</label><input id='p_cnt' name='product_count' type='number' value='1'/>" +
	"<input type='hidden' name='product_id' value='" + rowObject[0] + "'>" +
	"<input type='hidden' name='product_price' value='" + rowObject[4] + "'>" +
	"<input type='hidden' name='oper' value='add'>" +
	"<input type='submit' value='в корзину'>" +
	"<br /><a class='comparison' id='product_id_" + rowObject[0] + "' href='#'>Добавить к сравнению</a>" +
	"</form>";
};

function nameUnFormatter(cellValue, opts, rowObject) {
    return $('a', rowObject).attr('text');
};

$(document).ready(gen_table);