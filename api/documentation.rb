#!/bin/env ruby
# encoding: utf-8

begin

require 'json'

documentation = {}

documentation['introduction'] = "Blindfolk is a multiplayer game that involves programming a fighting style.
Every 15 minutes, if more than 2 fighters are alive, a turn occurs.
Blindfolks will keep on fighting as long as they are alive.

Begin by pressing RESPAWN on the left menu."

documentation['fighting'] = ["A fighting style is a series of cases and actions.
Cases are triggers that will act upon the Blindfolk's action.

<span class='sh_case'>case</span> <span class='sh_event'>attack</span>.<span class='sh_method'>backward</span>

<span class='sh_indent'>></span> <span class='sh_action'>step</span>.<span class='sh_method'>right</span>
<span class='sh_indent'>></span> <span class='sh_action'>move</span>.<span class='sh_method'>backward</span>
<span class='sh_indent'>></span> <span class='sh_action'>turn</span>.<span class='sh_method'>left</span>
<span class='sh_indent'>></span> <span class='sh_action'>attack</span>.<span class='sh_method'>forward</span>"]

documentation['cases'] = [
    'attack'  => { 'methods' => ['forward','backward'], 'docs' => 'Triggers when another players attack you.<br />* May be used without method and will trigger upon any incoming attack.' },
    'collide'    => { 'methods' => ['forward','backward','left','right'], 'docs' => 'Triggers when you attempt to move on another player\'s position.<br />* May be used without method and will trigger upon any collision.' },
    'kill'    => { 'methods' => [], 'docs' => 'Triggers when you kill someone, used for taunting.' },
    'default'    => { 'methods' => [], 'docs' => 'Triggers on every normal turn, loops.' }
]

documentation['actions'] = [
    'move'    => { 'methods' => ['forward','backward'], 'docs' => 'Move toward the method direction.' },
    'step'    => { 'methods' => ['left','right'], 'docs' => 'Sidestep toward the method direction.' },
    'turn'  => { 'methods' => ['left','right'], 'docs' => 'Turn anti-clockwise or clockwise.' },
    'attack'    => { 'methods' => ['forward','backward'], 'docs' => 'Attack toward the method direction.' },
    'say'    => { 'methods' => [], 'docs' => 'Writes a string of text under 40 characters, to the timeline.' },
    'idle'    => { 'methods' => [], 'docs' => 'Do nothing for a turn.' }
]

documentation['credits'] = ["This project was created by <a href='http://wiki.xxiivv.com/blind' target='_blank'>Devine Lu Linvega</a>. <br />The sources are available on <a href='https://github.com/XXIIVV/Blind' target='_blank'>Github</a>. <br />View updates on the <a href='http://wiki.xxiivv.com/blind:issues' target='_blank'>Changelog</a>. <br />Community <a href='https://twitter.com/search?q=%23blindfolkgame' target='_blank'>#blindfolkgame</a>"]

puts documentation.to_json

rescue Exception

    puts "<p>#{$!}</p>"
    puts "<p>#{$@}</p>"

end