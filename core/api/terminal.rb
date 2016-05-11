#!/bin/env ruby
# encoding: utf-8

begin

require 'mysql'
require 'json'

require_relative "../../tools/ocean.rb"

@token = ARGV[0].to_s
@script = ARGV[1].to_s.gsub("+"," ").gsub("_","\n").to_s.strip

$database = Oscean.new()
$database.connect()

if @script.to_s != "" then $database.saveScript(@token,@script) end

@player = $database.playerWithToken(@token)

puts @player.to_json

rescue Exception

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end