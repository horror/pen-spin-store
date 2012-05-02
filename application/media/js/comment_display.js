$(document).ready(function()	{
    $(".comment_show_branch").click(function (e) {
	e.preventDefault();
	var ref = $(this).attr('href');
	var product_id = ref.match(/id=(\d+)&/)[1];
	var comment_path = ref.match(/comment_path=(.+)#/)[1];
	var parent = $(this).parent().parent();
	var admin_here = $('#admin_here_mark').length > 0;
	$(this).remove();
	$.get(
	    "index.pl?controller=json_discussion&action=get_comments_branch",
	    { product_id: product_id, comment_path: comment_path },
	    function(branch){
		var pattern =
		"<span><article style='margin-left:${level*40}px' id='${id}'> \
		    <header class='comment_header'> \
			<h1>Комментарий от ${user_name}</h1> \
			<time>${time}</time> \
			    <a class='comment_response' href='index.pl?controller=products&action=detailes&id=" + product_id + "&comment_id=${id}&comment_path=${path}' class='recomment'>Ответить</a>" +
			   ((admin_here) ? "{{if deleted == 0 }} <a href='index.pl?controller=products&action=del_comment&id=" + product_id + "&comment_id=${id}#${id}'>удалить</a> {{/if}}" : "")
		 + "</header> \
		    {{html content}} \
		</article></span>";
		parent.after($(pattern).tmpl(branch));
	    },
	    'json'
	);
    });
    $("#expand_level").click(function () {
	$("#expand_all").prop("checked", false);
	$("#expand_no").prop("checked", false);
    });
});