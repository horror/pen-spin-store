﻿function gen_table() { 
    jQuery("#orders_grid").jqGrid({
   	url: 'index.pl?controller=json_orders&action=get_orders',
	editurl: 'index.pl?controller=json_orders&action=set',
	datatype: "json",
   	colNames: ['ID', 'ID пользователя', 'Количество товаров', 'Общая стоимость', 'Статус заказа'],
   	colModel: [
	        {name:'id',index:'id', align:"left", editable:false},
		{name:'user_id',index:'user_id', align:"left", editable:false},
   		{name:'products_cnt',index:'products_cnt', align:"left", editable:false},
   		{name:'total_price',index:'total_price',align:"left", editable:false},
   		{name:'status',index:'status', align:"left", editable:true,
		    formatter: statusFormatter, editable:true, edittype:"select",
		    editoptions:{value:"2:Обработан;1:Необработан;0:Незавершен"}},
   	],
   	rowNum:10,
   	rowList:[10, 20, 30],
   	pager: '#pager',
   	sortname: 'id',
	autowidth: true,
	height: 'auto',
	viewrecords: true,
	sortorder: "desc",
	caption:"Заказы",
       // name: ['id','product_id','products_count','total_price'], 
	subGrid: true,
	subGridRowExpanded: function(subgrid_id, row_id) {
	    var subgrid_table_id = subgrid_id+'_t';
	    $('#'+subgrid_id).html('<table id="'+subgrid_table_id+'"></table><div id="'+subgrid_table_id+'_pager"></div>');
	    $('#'+subgrid_table_id).jqGrid({
		url: 'index.pl?controller=json_orders&action=get_order_items',
		datatype: 'json',
		mtype: 'POST',
		postData: {'id':row_id},
		colNames:['ID', 'ID продукта', 'Изображение', 'Название', 'Количество', 'Общая стоимость'],
		colModel:[
			{name:'id',index:'id', hidden: true, align:"left", editable:false},
			{name:'product_id',index:'product_id', hidden: true, align:"left", editable:false},
			{name:'image',index:'image', align:"left", editable:false, formatter: unitsInStockFormatter},
			{name:'name',index:'name',align:"left", editable:false, formatter: nameFormatter},
			{name:'products_count',index:'products_count', align:"left", editable:true, editrules:{required:true}, editoptions:{size:10}},
			{name:'total_price',index:'total_price', align:"left", editable:false},
		],
		autowidth: true,
		rownumbers: true,
	        height: 'auto',
		sortname: 'name',
		sortorder: 'asc',
		pager: $('#'+subgrid_table_id+'_pager'),
		rowNum:10,
		rowList:[10,20,50,100]
	    });
	}
    });
    jQuery("#orders_grid").jqGrid('navGrid','#pager',
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

function statusFormatter(cellValue) {
    var order_statuses = ['Незавершен', 'Необработан', 'Обработан']
    return order_statuses[cellValue];
};

$(document).ready(gen_table);