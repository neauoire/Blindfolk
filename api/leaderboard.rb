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
leaderboard["header"] = "Year 1<br />Season 1<br />Ending on March 1st 2016<br /><br />"
leaderboard["players"] = []
leaderboard["playersCount"] = { "alive" => 0, "total" => 0 }

rank = 1
@players.each do |player|
	# Rank
	leaderboard["players"].push(player)
	if player[1] == @token then leaderboard["player"] = { "rank" => rank, "score" => player[2] } end
	rank += 1

	# Count
	if player[3] == 1 then leaderboard["playersCount"]["alive"] += 1 end
	leaderboard["playersCount"]["total"] += 1
end

puts leaderboard.to_json

rescue Exception

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end