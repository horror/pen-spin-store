function gen_table() { 
    jQuery("#products_grid").jqGrid({
   	url: 'index.pl?controller=json_products&action=get',
	editurl: 'index.pl?controller=json_products&action=set',
	datatype: "json",
	mtype: 'GET',
   	colNames:['id', 'Изображение', 'Название', 'Описание', 'Цена'],
   	colModel:[
	        {name:'id',index:'id', hidden: true, width:55, align:"left", editable:false},
   		{name:'image',index:'image',sortable:false,align:"left",search:false,editable:true,editoptions:{size:10}, formatter: unitsInStockFormatter},
   		{name:'name',index:'name',align:"left",searchoptions:{sopt:['bw','bn','ew','en','cn','nc']},editable:true,editrules:{required:true},editoptions:{size:10}},
   		{name:'description',index:'description',align:"left",searchoptions:{sopt:['bw','bn','ew','en','cn','nc']},editable:true,editrules:{required:true},editoptions:{size:10}},
		{name:'price',index:'price',align:"left",searchoptions:{sopt:['eq','ne','lt','le','gt','ge']},editable:true,editrules:{required:true},editoptions:{size:10}},
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
	caption:"Товары"
    });
    jQuery("#products_grid").jqGrid('navGrid','#pager_grid',
        {}, //options
	{mtype:'GET',height:210,reloadAfterSubmit:true,closeAfterEdit:true}, // edit options
	{mtype:'GET',height:210,reloadAfterSubmit:true,closeAfterAdd:true}, // add options
	{mtype:'GET',reloadAfterSubmit:true,closeAfterDel:true}, // del options
	{multipleSearch:true,closeAfterSearch:true} // search options);
    );
};

function  unitsInStockFormatter(cellvalue) {
    return "<img src='/application/media/img/products/" + cellvalue + "' />";
}; 

$(document).ready(gen_table);