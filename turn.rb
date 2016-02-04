#!/bin/env ruby
# encoding: utf-8

begin

require "mysql"
require "json"

require_relative "class.blindfolk.rb"
require_relative "../tools/ocean.rb"

$database = Oscean.new()
$database.connect()

$logs = {}

def log phase, event

	if !$logs[phase] then $logs[phase] = [] end
	$logs[phase].push(event)

end

def playersAlive

	alive = 0
	$players.each do |player|
		if player.isAlive == 1 then alive += 1 end
	end

	return alive

end

def runPhase

	$phase = 1
	while $phase <= 10
		log("Phase #{$phase}","<phase># Phase #{$phase}</phase>\n")
		for player in $players
			player.act()
		end
		if playersAlive == 1 then break end
		$phase += 1
	end

	log("<phase># Game Over</phase>\n")

	# Save scores
	for player in $players
		log("Phase #{$phase}","#{player.name} gains <score>#{player.score} point</score>.")
		$database.updatePlayer(player)
	end

	# Format logs
	logsFormatted = ""
	$logs.each do |phase,logs|
		logs.each do |log|
			logsFormatted += "#{log}\n"			
		end
	end
	$database.saveLogs(logsFormatted)

end

$players = $database.players.shuffle

if playersAlive > 1
	runPhase()
else
	puts "Missing players"
end

p $logs

rescue Exception

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end