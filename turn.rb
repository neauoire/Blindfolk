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

def log event

	if !$logs[$phase] then $logs[$phase] = [] end
	$logs[$phase].push(event)

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
		log("<phase># Phase #{$phase}</phase>\n")
		for player in $players
			player.act()
		end
		if playersAlive == 1 then break end
		$phase += 1
		log("\n")
	end

	log("\n<phase># Game Over</phase>\n")

	# Save scores
	for player in $players
		log("#{player.name} gains <score>#{player.score} point</score>.")
		$database.updatePlayer(player)
	end

	# Last blindfolk standing
	if playersAlive == 1
		$players.each do |player|
			if player.isAlive == 0 then next end
			log("#{player.name} is the last one alive.")
		end
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
end

rescue Exception

	errorName = "#{$!}".downcase
	errorLocation = "#{$@}"
	originName = "Turn"
	errorLocation = errorLocation

	errorTip = "Please report the error to <a href='https://twitter.com/neauoire'>@neauoire</a>, or refresh the page."
	puts "<p>Actions.api: #{errorName}</p>"
	puts "<p style='font-size:14px'>#{errorTip}</p>"
	puts "<p style='font-size:12px'>> #{errorLocatio