
$(document).ready(function()
{
	$('#terminal').bind('input propertychange', function()
	{
		var text = syntaxHighlight($('#terminal').val());
		$('#render').html(text);
	});
});

function syntaxHighlight(text)
{
	text = text.replace("hey", "<span class='sh_test'>hey</span>");
	return text;
}