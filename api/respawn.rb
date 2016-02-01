#!/bin/env ruby
# encoding: utf-8

begin

require 'mysql'
require 'json'

require_relative "../../tools/ocean.rb"

@token = ARGV[0].to_s

$database = Oscean.new()
$database.connect()

$database.respawn(@token)

rescue Exception

	puts "<p>#{$!}</p>"
	puts "<p>#{$@}</p>"

end