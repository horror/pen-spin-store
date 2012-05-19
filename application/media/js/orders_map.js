var orders_map;

String.prototype.parse_point = function () {
    var coords = this.match(/(-?\d+\.\d*)\s(-?\d+\.\d*)/);
    
    return [coords[2] * 1, coords[1] * 1];
}

function create_map() {
    orders_map = new ymaps.Map("orders_map", {
	center: [0, 0],
        zoom: 0,
        behaviors: ['default', 'scrollZoom']
    });
    
    orders_map.controls
        .add('zoomControl')
	.add('typeSelector')
	.add('smallZoomControl', { right: 5, top: 75 })
	.add('mapTools')
	.add(new ymaps.control.ScaleLine())
	.add(new ymaps.control.MiniMap({
	    type: 'yandex#publicMap'
	}));
}

function make_map(orders) {
    const COORDS_COL = 6;
    
    if (!orders_map)
        create_map();
	
    console.info(orders);
    point_collection = new ymaps.GeoObjectCollection();
    
    var left_top_bound = [100000, 100000], right_bottom_bound = [-100000, -100000];
    
    for (var i = 0; i < orders.rows.length; ++i)
	if (orders.rows[i].cell[COORDS_COL] != null) {
	    var coords = orders.rows[i].cell[COORDS_COL].parse_point();
	   
	    for (var j = 0; j < 2; ++j) {                      
		if (coords[j] < left_top_bound[j])              // Установка границ
		    left_top_bound[j] = coords[j];		// viewport карты
		if (coords[j] > right_bottom_bound[j])		
		    right_bottom_bound[j] = coords[j];		
	    }
	    
	    
	    placemark = new ymaps.Placemark(coords);
	    point_collection.add(placemark);
	}
	    
    orders_map.geoObjects.add(point_collection);
      
              
    left_top_bound[0] -= 9;		//расширение высоты viewport 
    right_bottom_bound[0] += 9;
    
    orders_map.setBounds([left_top_bound, right_bottom_bound], {
	checkZoomRange: true,
	precizeZoom: true,
	callback: function(err) {
	    if (err) {
		alert("Не удалось показать заданный регион" + err);
	    }
    }
});
}