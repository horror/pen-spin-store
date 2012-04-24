$(document).ready(function() {
    jQuery.fn.appendEach = function( arrayOfWrappers ){
	this.html('');
	// Map the array of jQuery objects to an array of
	// raw DOM nodes.
	var rawArray = jQuery.map(
	arrayOfWrappers,
	function( value, index ){
	 
	// Return the unwrapped version. This will return
	// the underlying DOM nodes contained within each
	// jQuery value.
	return( value.get() );
	 
	}
	);
	 
	// Add the raw DOM array to the current collection.
	this.append( rawArray );
	 
	// Return this reference to maintain method chaining.
	return( this );
     
    };

    $('.axises').append($('<option/>', {'value' : 'users', 'text' : 'Пользователи'}));
    $('.axises').append($('<option/>', {'value' : 'products', 'text' : ' Товары и категории'}));
   // $('.axises').append($('<option/>', {'value' : 'periods', 'text' : 'Время'}));
    
    var user_detail = [
        $('<option/>', {'value' : 'sex', 'text' : 'Пол'}),
        $('<option/>', {'value' : 'adress', 'text' : 'Город'}),
	$('<option/>', {'value' : 'name', 'text' : 'Имя'}),
    ];
    
    var product_detail = [
        $('<option/>', {'value' : 'prod_name', 'text' : 'Наименование продукции'}),
        $('<option/>', {'value' : 'cat_name', 'text' : 'Категория'}),
    ];
    
    var period_detail = [
        $('<option/>', {'value' : 'day', 'text' : 'День'}),
        $('<option/>', {'value' : 'week', 'text' : 'Неделя'}),
	$('<option/>', {'value' : 'month', 'text' : 'Месяц'}),
    ];
    
    var detail_type = { "users" : user_detail, "products" : product_detail, "periods" : period_detail};
    $('#x_axis').change(function () {
        $("#y_axis option").css({'display' : 'block'});
        $("#y_axis [value='" + $(this).val() + "']").css({'display' : 'none'});
        $('#x_detalisation').appendEach(detail_type[$(this).val()]);
    });
    
    $('#y_axis').change(function () {
        $("#x_axis option").css({'display' : 'block'});
        $("#x_axis [value='" + $(this).val() + "']").css({'display' : 'none'});
        $('#y_detalisation').appendEach(detail_type[$(this).val()]);
    });
    
    $("#x_axis").val('products');
    $("#x_axis [value='users']").css({'display' : 'none'});
    $("#y_axis [value='products']").css({'display' : 'none'});
    
    $("#x_axis").change();
    $("#y_axis").change();
});