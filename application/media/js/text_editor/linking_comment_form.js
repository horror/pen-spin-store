$(document).ready(function()	{
    $('#comment_content').markItUp(MarkdownSettings);
	 $('a[title="Preview"]').trigger('mouseup');
});