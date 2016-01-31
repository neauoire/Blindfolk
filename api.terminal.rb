#!/bin/env ruby
# encoding: utf-8

begin

require "mysql"
require 'date'

require_relative "../tools/ocean.rb"

@hash = ARGV[0].to_s
@script = ARGV[1].to_s.gsub("+"," ").gsub("_","\n").to_s.strip

$database = Oscean.new()
$database.connect()
$database.saveScript(@hash,@script)

puts @script

rescue Exception

	error = $@
	errorCleaned = error.to_s.gsub(", ","<br />").gsub("`","<b>").gsub("'","</b>").gsub("\"","").gsub("/var/www/wiki.xxiivv/public_html/","")
	errorCleaned = errorCleaned.gsub("[","\n").gsub("]","")

	puts "<pre><b>Error</b>     "+$!.to_s.gsub("`","<b>").gsub("'","</b>")+"<br/><b>Location</b>  "+errorCleaned+"<br /><b>Report</b>    Please, report this error to <a href='https://twitter.com/aliceffekt'>@aliceffekt</a><br /><br />CURRENTLY UPDATING XXIIVV, COME BACK SOON</pre>"

end