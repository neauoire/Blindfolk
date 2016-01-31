class Blindfolk

	def initialize id,code
		@id = id
		@rules = parse(code)
		stamina = 10
		@actionIndex = 0
		@status = "default"
	end

	def parse code

		rules = {}
		code = code.gsub("\n\n","\n")
		_case = "default"
		code.lines.each do |line|
			line = line.strip
			if line == "" then next end
			if line[0,5] == "case " then _case = line.sub("case ","") ; next end
			if !rules[_case] then rules[_case] = [] end
			rules[_case].push(line)
		end
		return rules

	end

	def handlers

	end

	def status

		return "default"

	end

	def act phase

		actionIndexClamped = @actionIndex % @rules[@status].length
		puts "#{@id} [#{status}] -> #{phase} * #{@rules[@status][actionIndexClamped]}"
		@actionIndex += 1
	end

	def action
		return @code
	end

end

# Create Players

# Make Player1
code = "
move.forward
move.backward
"
p1 = Blindfolk.new(1,code)

# Make Player2
code = "
turn.right
turn.right
"
p2 = Blindfolk.new(2,code)

# Make Player3
code = "
case hit.high
  attack.high
  turn.left
case default
  attack.high
  turn.left
"
p3 = Blindfolk.new(3,code)

players = [p1,p2,p3].shuffle

# Play

phase = 1
while phase <= 5
	puts "PHASE #{phase}"
	for player in players
		player.act(phase)
	end
	phase += 1
end

puts "SUMMARY"
puts "[missing]"



