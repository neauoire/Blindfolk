#!/bin/env ruby
# encoding: utf-8

begin

require 'mysql'
require 'json'

require_relative "../../tools/ocean.rb"

@token = ARGV[0].to_s

$database = Oscean.new()
$database.connect()

@players = $database.leaderboard()

leaderboard = {}
leaderboard["players"] = []
leaderboard["playersCount"] = { "alive" => 0, "total" => 0 }

rank = 1
@players.each do |player|
	# Rank
	leaderboard["players"].push([rank,player[0],player[2]])
	if player[1] == @token then leaderboard["player"] = { "rank" => rank, "score" => player[2] } end
	rank += 1

	# Count
	if player[3] == 1 then leaderboard["playersCount"]["alive"] += 1 end
	leaderboard["playersCount"]["total"] += 1
end

puts leaderboard.to_json

rescue Exception

	error = $@
	errorCleaned = error.to_s.gsub(", ","<br />").gsub("`","<b>").gsub("'","</b>").gsub("\"","").gsub("/var/www/wiki.xxiivv/public_html/","")
	errorCleaned = errorCleaned.gsub("[","\n").gsub("]","")

	puts "<pre><b>Error</b>     "+$!.to_s.gsub("`","<b>").gsub("'","</b>")+"<br/><b>Location</b>  "+errorCleaned+"<br /><b>Report</b>    Please, report this error to <a href='https://twitter.com/aliceffekt'>@aliceffekt</a><br /><br />CURRENTLY UPDATING XXIIVV, COME BACK SOON</pre>"

end