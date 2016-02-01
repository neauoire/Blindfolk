<?php

$route = preg_replace("/[^A-Za-z0-9]/", '', $_POST['route']);

// Script
if( $_POST['script'] ){
	$script = strtolower(preg_replace("/[^A-Za-z0-9.\n ]/", '', $_POST['script']));
	$script = str_replace("\n\n\n", "\n\n", $script);
	$script = str_replace("    ", "  ", $script);
	$script = str_replace("   ", "  ", $script);
	$script = str_replace("\n", "_", $script);
	$script = str_replace(" ", "+", $script);
}

// Token
if( $_POST['token'] ){
	$token = preg_replace("/[^A-Za-z0-9.\n ]/", '', $_POST['token']);
}

// Routing
if( $_POST['route'] == "respawn" ){
	echo `ruby api.respawn.rb $token`;
}
else if( $_POST['route'] == "leaderboard" ){
	echo `ruby api.leaderboard.rb $token`;
}
else if( $_POST['route'] == "documentation" ){
	echo `ruby api.documentation.rb`;
}
else if( $_POST['route'] == "timeline" ){
	echo `ruby api.timeline.rb`;
}
else if( $_POST['route'] == "terminal" ){
	echo `ruby api.terminal.rb $token $script`;
}
else{
	echo "Route Unavailable.";
}

?>