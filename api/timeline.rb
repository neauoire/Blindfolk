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

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end