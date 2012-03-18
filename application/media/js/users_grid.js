function gen_table() { 
    jQuery("#users_grid").jqGrid({
   	url: 'index.pl?controller=json_users&action=get',
	editurl: 'index.pl?controller=json_users&action=set',
	datatype: "json",
   	colNames:['ID', 'Имя', 'Логин', 'Е-Майл', 'Пароль', 'Группа'],
   	colModel:[
	        {name:'id',index:'id', align:"left", editable:false, editoptions:{readonly:true, size:10}},
   		{name:'name',index:'name', align:"left", editable:true, editrules:{required:true}, editoptions:{size:10}},
   		{name:'login',index:'login',align:"left", editable:true, editrules:{required:true}, editoptions:{size:10}},
   		{name:'email',index:'email', align:"left", editable:true, editrules:{required:true}, editoptions:{size:10}},
		{name:'password',index:'password', align:"left", hidden:true, editrules:{edithidden:true}, editable:true, editoptions:{size:10}},
   		{name:'role',index:'role',  align:"left", editable:true, edittype:"select", editoptions:{value:"1:Админ;0:Пользователь"}},	
   	],
   	rowNum:3,
   	rowList:[3, 6, 9],
   	pager: '#pager',
   	sortname: 'id',
	autowidth: true,
	height: 'auto',
	viewrecords: true,
	sortorder: "desc",
	caption:"Пользователи"
    });
    jQuery("#users_grid").jqGrid('navGrid','#pager',{}, //options
	{height:210,reloadAfterSubmit:true}, // edit options
	{height:210,reloadAfterSubmit:true}, // add options
	{reloadAfterSubmit:true}, // del options
	{} // search options);
    );
};

$(document).ready(gen_table);