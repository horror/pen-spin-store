﻿function gen_table() { 
    jQuery("#cart_grid").jqGrid({
   	url: 'index.pl?controller=json_cart&action=get',
	editurl: 'index.pl?controller=json_cart&action=set',
	datatype: "json",
   	colNames:['ID', 'ID продукта', 'Изображение', 'Название', 'Количество', 'Общая стоимость'],
   	colModel:[
	        {name:'id',index:'id', hidden: true, align:"left", editable:false},
		{name:'product_id',index:'product_id', hidden: true, align:"left", editable:false},
   		{name:'image',index:'image', align:"left", editable:false, formatter: unitsInStockFormatter},
   		{name:'name',index:'name',align:"left", editable:false, formatter: nameFormatter},
   		{name:'products_count',index:'products_count', align:"left", editable:true, editrules:{required:true}, editoptions:{size:10}},
		{name:'total_price',index:'total_price', align:"left", editable:false},
   	],
   	rowNum:10,
   	rowList:[10, 20, 30],
   	pager: '#pager',
   	sortname: 'id',
	autowidth: true,
	height: 'auto',
	viewrecords: true,
	sortorder: "desc",
	caption:"Корзина"
    });
    jQuery("#cart_grid").jqGrid('navGrid','#pager',
        {del:true, add:false, edit:true}, //options
	{height: 'auto'}, // edit options
	{}, // add options
	{reloadAfterSubmit:true}, // del options
	{} // search options);
    );
};

function unitsInStockFormatter(cellvalue) {
    return (cellvalue) ? "<div class='product_image'><img src='/application/media/img/products/thumb/" + cellvalue + "' /></div>" : '';
}; 

function nameFormatter(cellValue, opts, rowObject) {
    return "<a class='product_link' href='index.pl?controller=products&action=detailes&id=" + rowObject[1] + "' >" + cellValue + "</a>";
};

$(document).ready(gen_table);