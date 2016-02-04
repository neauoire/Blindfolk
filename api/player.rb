#!/bin/env ruby
# encoding: utf-8

begin

require 'mysql'
require 'json'

require_relative "../../tools/ocean.rb"

@token = ARGV[0].to_s

$database = Oscean.new()
$database.connect()

puts $database.playerWithToken(@token).to_json

rescue Exception
	puts "#{$!}\n#{$@}"
end