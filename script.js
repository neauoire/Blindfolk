var token = readCookie("token");

$(document).ready(function()
{
	if(!token){
		var newToken = generateToken();
		setCookie("token",newToken,100);
		console.log("Created new player");
	}

	renderTerminal();

	$('#terminal').bind('input propertychange', function(){ 
		renderTerminal();
		$('#save').text('Save');
		$('#save').css('display','inline-block');
	});

	$('#save').bind( "click", function() { 
		save();
	});

	// Bind Tabs

	$('#tab_render').bind( "click", function() { 
		$('#terminal').show();
		$('#render').show(); $('#timeline').hide(); $('#documentation').hide(); 
		$('#tab_render').attr('class','active'); $('#tab_timeline').attr('class',''); $('#tab_documentation').attr('class',''); 
	});
	$('#tab_timeline').bind( "click", function() { 
		$('#terminal').hide();
		$('#render').hide(); $('#timeline').show(); $('#documentation').hide(); 
		$('#tab_render').attr('class',''); $('#tab_timeline').attr('class','active'); $('#tab_documentation').attr('class',''); 
	});
	$('#tab_documentation').bind( "click", function() { 
		$('#terminal').hide();
		$('#render').hide(); $('#timeline').hide(); $('#documentation').show(); 
		$('#tab_render').attr('class',''); $('#tab_timeline').attr('class',''); $('#tab_documentation').attr('class','active'); 
	});

	loadDocumentation();
	loadTimeline();

});

function loadDocumentation()
{
	$('#documentation').text("");

	$.ajax({ type: "POST", url: "http://blind.xxiivv.com/api.documentation.php", data: {} }).done(function( content_raw ) {

		var documentation = JSON.parse(content_raw);
		var documentationText = "";

		documentationText += "# Introduction\n\n";
		documentationText += documentation["introduction"]+"\n\n";
		documentationText += "# Fighting Styles\n\n";
		documentationText += documentation["fighting"]+"\n\n";

		// Cases
		documentationText += "# Cases Documentation\n\n";
		$.each(documentation["cases"][0], function( _case, value ) {
			documentationText += "<span class='sh_case'>case</span> <span class='sh_event'>"+_case+"</span> ";
			documentationText += "[ ";
			$.each(value['methods'], function( index, _method ) {
				documentationText += ".<span class='sh_method'>"+_method+"</span> ";
			});
			documentationText += "]\n";
			documentationText += "<span class=''>"+value["docs"]+"</span>\n\n";
		});

		// Actions
		documentationText += "# Actions Documentation\n\n";
		$.each(documentation["actions"][0], function( _case, value ) {
			documentationText += "<span class='sh_case'>case</span> <span class='sh_event'>"+_case+"</span> ";
			// Methods
			documentationText += "[ ";
			$.each(value['methods'], function( index, _method ) {
				documentationText += ".<span class='sh_method'>"+_method+"</span> ";
			});
			documentationText += "]\n";
			documentationText += "<span class=''>"+value["docs"]+"</span>\n\n";
		});

		documentationText += "# Exit\n\n";
		documentationText += documentation["credits"]+"\n\n";

		$('#documentation').html(documentationText);
	});
}

function loadTimeline()
{
	$('#timeline').text("");

	$.ajax({ type: "POST", url: "http://blind.xxiivv.com/api.timeline.php", data: {} }).done(function( content_raw ) {
		var timeline = JSON.parse(content_raw);
		var turn = timeline[0];
		var logs = timeline[1];
		$('#timeline').html("! TURN "+turn+"\n"+logs);
	});
}

function save()
{
	$('#save').text('Saving..');

	$.ajax({ type: "POST", url: "http://blind.xxiivv.com/api.terminal.php", data: { token:token, script:$('#terminal').val() }}).done(function( content_raw ) {
		$('#terminal').val(content_raw);
		$('#save').hide();
		console.log(content_raw);
		renderTerminal();
	});
}

function renderTerminal()
{
	var text = syntaxHighlight($('#terminal').val());
	$('#render').html(text+"_");
}

function renderTimeline()
{
	var text = syntaxHighlight($('#timeline').text());
	$('#timeline').html(text);
}

function syntaxHighlight(text)
{
	// Main
	text = text.replaceAll("case ", "<span class='sh_case'>case</span> ");
	// Actions
	text = text.replaceAll("block.", "<span class='sh_action'>block</span>.");
	text = text.replaceAll("move.", "<span class='sh_action'>move</span>.");
	text = text.replaceAll("attack.", "<span class='sh_action'>attack</span>.");
	text = text.replaceAll("turn.", "<span class='sh_action'>turn</span>.");
	text = text.replaceAll("charge.", "<span class='sh_action'>charge</span>.");
	text = text.replaceAll("say ", "<span class='sh_action'>say</span> ");
	// Events
	text = text.replaceAll(" collide", " <span class='sh_event'>collide</span>");
	text = text.replaceAll(" attack", " <span class='sh_event'>attack</span>");
	text = text.replaceAll(" death", " <span class='sh_event'>death</span>");
	text = text.replaceAll(" hit", " <span class='sh_event'>death</span>");
	text = text.replaceAll(" default", " <span class='sh_event'>default</span>");
	// Methods
	text = text.replaceAll(".high", ".<span class='sh_method'>high</span>");
	text = text.replaceAll(".low", ".<span class='sh_method'>low</span>");
	text = text.replaceAll(".forward", ".<span class='sh_method'>forward</span>");
	text = text.replaceAll(".back", ".<span class='sh_method'>back</span>");
	text = text.replaceAll(".right", ".<span class='sh_method'>right</span>");
	text = text.replaceAll(".left", ".<span class='sh_method'>left</span>");
	// Etc..
	text = text.replaceAll("  ", "<span class='sh_indent'>> </span>");
	return text;
}

String.prototype.replaceAll = function(search, replacement)
{
    var target = this;
    return target.split(search).join(replacement);
};

function setCookie(c_name,value,exdays)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	document.cookie=c_name + "=" + c_value;
}

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

var generateToken = function()
{
	var seg1 = Math.random().toString(36).substr(2);
	var seg2 = Math.random().toString(36).substr(2);
    return seg1+seg2; // remove `0.`
};