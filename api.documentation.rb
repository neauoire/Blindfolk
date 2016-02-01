#!/bin/env ruby
# encoding: utf-8

begin

require 'json'

documentation = {}

documentation['introduction'] = "Blindfolk is a multiplayer game that involves programming a fighting style.
Every 15 minutes, if more than 2 fighters are alive, a turn occurs.
Blindfolks will keep on fighting as long as they are alive."

documentation['fighting'] = ["A fighting style is a series of cases and actions.
Cases are triggers that will act upon the Blindfolk's action.

<span class='sh_case'>case</span> <span class='sh_event'>attack</span>.<span class='sh_method'>backward</span>

<span class='sh_indent'>></span> <span class='sh_action'>step</span>.<span class='sh_method'>right</span>
<span class='sh_indent'>></span> <span class='sh_action'>move</span>.<span class='sh_method'>backward</span>
<span class='sh_indent'>></span> <span class='sh_action'>turn</span>.<span class='sh_method'>left</span>
<span class='sh_indent'>></span> <span class='sh_action'>attack</span>.<span class='sh_method'>forward</span>"]

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