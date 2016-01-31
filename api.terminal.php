<?php 

// Clean
$script = strtolower(preg_replace("/[^A-Za-z0-9.\n ]/", '', $_POST['script']));
$script = str_replace("\n\n\n", "\n\n", $script);
$script = str_replace("    ", "  ", $script);
$script = str_replace("   ", "  ", $script);

// Encode
$script = str_replace("\n", "_", $script);
$script = str_replace(" ", "+", $script);

// Token
$token = preg_replace("/[^A-Za-z0-9.\n ]/", '', $_POST['token']);

// Pass over to Ruby
echo `ruby api.terminal.rb $token $script`;

?>