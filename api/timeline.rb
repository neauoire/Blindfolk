#!/bin/env ruby
# encoding: utf-8

begin

require "mysql"
require "json"

require_relative "../class.blindfolk.rb"
require_relative "../../tools/ocean.rb"

$database = Oscean.new()
$database.connect()
puts $database.log.to_json

rescue Exception

	errorName = "#{$!}".downcase
	errorLocation = "#{$@}"
	originName = "Turn"
	errorLocation = errorLocation

	errorTip = "Please report the error to <a href='https://twitter.com/neauoire'>@neauoire</a>, or refresh the page."
	puts "<p>Actions.api: #{errorName}</p>"
	puts "<p style='font-size:14px'>#{errorTip}</p>"
	puts "<p style='font-size:12px'>> #{errorLocation}</p>"

end