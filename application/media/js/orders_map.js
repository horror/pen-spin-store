var orders_map;
var point_collections  = [];

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
    const USER_COL = 1;
    
    var icon_colors = [
    	'twirl#blueStretchyIcon',
	'twirl#darkblueStretchyIcon',
	'twirl#darkgreenStretchyIcon',
	'twirl#darkorangeStretchyIcon',
	'twirl#greenStretchyIcon',
	'twirl#greyStretchyIcon',
	'twirl#lightblueStretchyIcon',
	'twirl#nightStretchyIcon',
	'twirl#orangeStretchyIcon',
	'twirl#pinkStretchyIcon',
	'twirl#redStretchyIcon',
	'twirl#violetStretchyIcon',
	'twirl#whiteStretchyIcon',
	'twirl#yellowStretchyIcon',
	'twirl#brownStretchyIcon',
	'twirl#blackStretchyIcon'
    ]
    if (!orders_map)
        create_map();
	
    console.info(orders);
    
    for(var i = 0; i < point_collections.length; ++i)
	point_collections[i].removeAll();
    
    point_collections.splice(0, point_collections.length);
    
    var left_top_bound = [100000, 100000], right_bottom_bound = [-100000, -100000];
    
    var old_id = -1;
    var collection_idx = -1;
    
    for (var i = 0; i < orders.rows.length; ++i)
	if (orders.rows[i].cell[COORDS_COL] != null) {
	
	    if(orders.rows[i].cell[USER_COL] != old_id) {
		old_id = orders.rows[i].cell[USER_COL];		
		collection_idx++;
		point_collections[collection_idx] = new ymaps.GeoObjectCollection({}, {
                    preset: icon_colors[collection_idx % icon_colors.length],
                    geoObjectCursor: 'point',
                    balloonCloseButton: true
                });

	    }
	    
	    var coords = orders.rows[i].cell[COORDS_COL].parse_point();
	   
	    for (var j = 0; j < 2; ++j) {                      
		if (coords[j] < left_top_bound[j])              // Установка границ
		    left_top_bound[j] = coords[j];		// viewport карты
		if (coords[j] > right_bottom_bound[j])		
		    right_bottom_bound[j] = coords[j];		
	    }
	    
	    
	    placemark = new ymaps.Placemark(coords, {
		iconContent: orders.rows[i].cell[USER_COL],
            });
	    
	    point_collections[collection_idx].add(placemark);
	}
	    
    for(var i = 0; i < point_collections.length; ++i)
	orders_map.geoObjects.add(point_collections[i]);
      
    console.info(left_top_bound);
    console.info(right_bottom_bound);
    
    orders_map.setBounds([left_top_bound, right_bottom_bound], {
	checkZoomRange: true,
	precizeZoom: true
});
}