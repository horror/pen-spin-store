function gen_dialogs() {
    $('#edit_dialog').dialog({
        autoOpen: false,
	width: 'auto',
        buttons: {
	    "Add" :{
	        class: 'product_form_bnt',
		text: 'Внести изменения',
		click: function () {
		    $('#edit_form').submit();
		}
	    },
	    "cancel" :{
	        class: 'product_form_bnt',
		text: 'Отмена',
		click: function () {
		    $(this).dialog('close');
		}
	    },
	},
    });
    
    $('#add_prod_btn').click(function () {
        $('#edit_dialog').dialog({title: 'Добавить'});
	$('#name').val('');
	$('#description').val('');
	$('#price').val('');
	$('#edit_dialog').dialog('open');
	$('#oper').val('add');
    });
    
    $('#edit_prod_btn').click(function () {
        $('#edit_dialog').dialog({title: 'Изменить'});
	$('#edit_dialog').dialog('open');
	$('#oper').val('edit');
    });
    
    $('#del_prod_btn').click(function () {
        $('#edit_dialog').dialog({title: 'Удалить'});
	$('#edit_dialog').dialog('open');
	$('#oper').val('del');
    });
};

$(document).ready(gen_dialogs);