#!/bin/env ruby
# encoding: utf-8

begin

require 'json'

documentation = {}

documentation['introduction'] = "Missing documentation for introduction."

documentation['fighting'] = ["Missing documentation for fighting styles."]

documentation['cases'] = [
    'attack'  => { 'methods' => ['forward','backward'], 'docs' => 'Missing data' },
    'collide'    => { 'methods' => ['front','back','left','right'], 'docs' => 'Missing data' },
    'death'    => { 'methods' => [], 'docs' => 'Missing data' },
    'kill'    => { 'methods' => [], 'docs' => 'Missing data' },
    'default'    => { 'methods' => [], 'docs' => 'Missing data' }
]

documentation['actions'] = [
    'move'    => { 'methods' => ['forward','backward'], 'docs' => 'Missing data' },
    'step'    => { 'methods' => ['left','right'], 'docs' => 'Missing data' },
    'turn'  => { 'methods' => ['left','right'], 'docs' => 'Missing data' },
    'attack'    => { 'methods' => ['forward','backward'], 'docs' => 'Missing data' },
    'say'    => { 'methods' => [], 'docs' => 'Missing data' }
]

documentation['examples'] = ["example1","example2"]

documentation['credits'] = ["Missing documentation for credits."]

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