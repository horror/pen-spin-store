$(document).ready(function()	{
    $('#comment_content').markItUp(MarkdownSettings);
   // $('a[title="Preview"]').trigger('mouseup');
   
    String.prototype.lead_6_zero = function() {
	var formatted = this;
	const zero_num = 6;
	for (var i = 0; i < zero_num - formatted.length + 3; i++) {
	    formatted = '0' + formatted;
	}
	return formatted;
    };
    
    $(".comment_response").click(function (e) {
	e.preventDefault();
	var ref = $(this).attr('href');
	var comment_id = ref.match(/comment_id=(\d+)/)[1];
	var comment_path = ref.match(/comment_path=(.+)/)[1];
	$('#form_comment_id').val(comment_id);
	$('#form_comment_path').val(comment_path + comment_id.lead_6_zero() + '.');
	$('body,html').animate({ scrollTop: $(document).height() - $(window).height()}, 'slow');
    });
    
});