function gen_table() { 
	$('#category_tree').jqGrid({
            url: "index.pl?controller=json_categories&action=get",
	    editurl: "index.pl?controller=json_categories&action=set",
            datatype: "json",     
            treeGridModel: 'adjacency',
            colNames: ["ID", "Категории"],
            colModel: [  
                { name: "id", hidden: true, key:true },
                { name: "name", editable:true }
            ],
	    autowidth: true,
	    height: 'auto',
            treeGrid: true,
            caption: "Меню",
            ExpandColumn: "name",
	    pager : "#pager_tree",
            ExpandColClick:true,
	    onSelectRow: function(id){ 
		$('#products_grid').setGridParam({
		    url:'index.pl?controller=json_products&action=get&cat_id=' + id,
		    editurl:'index.pl?controller=json_products&action=set&cat_id=' + id,
		    search:false
		});
		
		$.jCookies({
		    name : 'cat_id',
		    value : id
	        });
		
		$('#products_grid').trigger('reloadGrid',[{page:1}]);
		
		$('#category_id').val(id);
	     }
      });
      jQuery("#category_tree").jqGrid('navGrid',"#pager_tree");
     // jQuery("#category_tree").setSelection(1, true);
};

$(document).ready(gen_table);