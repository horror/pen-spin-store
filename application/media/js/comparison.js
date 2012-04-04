$(document).ready(function() {
    Array.prototype.remove = function(){
	var what, a= arguments, L= a.length, ax;
	while(L && this.length){
	    what= a[--L];
	    while((ax= this.indexOf(what))!= -1){
		this.splice(ax, 1);
	    }
	}
	return this;
    }
    
    $(".comparison").click( 
	function () {
	    var prod_id = this.id.match(/\d+/)[0];
	    var new_data = $.jCookies({ get : 'comparison_prod_ids' }) || [];
	    new_data.remove(prod_id);
	    $.jCookies({
		name : 'comparison_prod_ids',
		value : new_data
	    }); 
	    location.reload();
	}
    );
    
    $("#erase_comparison").click( 
	function () {
	    $.jCookies({ erase : 'comparison_prod_ids' });
	    location.reload();
	}
    );
});