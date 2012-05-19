 $(document).ready(function () {
    jQuery("#orders_grid").jqGrid('navGrid','#pager',
	{del:true, add:false, edit:true}, //options
	{height: 'auto'}, // edit options
	{}, // add options
	{reloadAfterSubmit:true}, // del options
	{multipleSearch:true, closeAfterSearch:true, width: 'auto'} // search options
	);
    
});