<?php 

// Token
$token = preg_replace("/[^A-Za-z0-9.\n ]/", '', $_POST['token']);

// Pass over to Ruby
echo `ruby api.respawn.rb $token`;

?>