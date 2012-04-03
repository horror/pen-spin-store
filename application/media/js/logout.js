$(document).ready(function() {
    $("#logout").click(
	function () {
	    $.jCookies({ erase : 'sid' });
	    location.reload();
	}
    )
});