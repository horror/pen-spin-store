$(document).ready(function () {
    jQuery("#orders_grid").jqGrid('navGrid','#pager',
	{del:false, add:false, edit:false, search:true},
        {}, // edit options
	{}, // add options
	{}, // del options
	{multipleSearch:true, closeAfterSearch:true, width: 'auto'} // search options
    
    ) 
    
});