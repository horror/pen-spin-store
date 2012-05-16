$(document).ready(function () {
    $('#order_confirmation').dialog({
        autoOpen: false,
	width: 'auto',
        buttons: {
	    "confirm" :{
	        class: 'product_form_bnt',
		text: 'Подтвердить заказ',
		click: function () {
		    $('#order_confirmation_form').submit();
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
    $('#confirmation').click(function () {
        $('#order_confirmation').dialog({title: 'Подтверждение заказа'});
	$('#order_confirmation').dialog('open');
    });
});