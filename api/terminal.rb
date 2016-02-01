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

@script = $database.loadScript(@token)

if @script
	puts @script.to_json
else
	puts $database.createPlayer(@token).to_json
end

rescue Exception

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end