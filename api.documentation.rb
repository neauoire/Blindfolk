#!/bin/env ruby
# encoding: utf-8

begin

require 'json'

documentation = {}

documentation['cases'] = [
    'attack'  => { 'params' => ['high','low'], 'docs' => 'Missing data' },
    'bump'    => { 'params' => ['front','back','left','right'], 'docs' => 'Missing data' },
    'death'    => { 'params' => [], 'docs' => 'Missing data' },
    'kill'    => { 'params' => [], 'docs' => 'Missing data' },
    'default'    => { 'params' => [], 'docs' => 'Missing data' }
]

documentation['actions'] = [
    'move'    => { 'params' => ['forward','backward'], 'docs' => 'Missing data' },
    'step'    => { 'params' => ['left','right'], 'docs' => 'Missing data' },
    'turn'  => { 'params' => ['left','right'], 'docs' => 'Missing data' },
    'attack'    => { 'params' => ['high','low'], 'docs' => 'Missing data' },
    'say'    => { 'params' => [], 'docs' => 'Missing data' }
]

puts documentation.to_json

rescue Exception

	errorName = "#{$!}".downcase
	errorLocation = "#{$@}"
	originName = "Actions API"
	errorLocation = errorLocation

	errorTip = "Please report the error to <a href='https://twitter.com/neauoire'>@neauoire</a>, or refresh the page."
	puts "<p>Actions.api: #{errorName}</p>"
	puts "<p style='font-size:14px'>#{errorTip}</p>"
	puts "<p style='font-size:12px'>> #{errorLocation}</p>"

end