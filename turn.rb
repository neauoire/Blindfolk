class Blindfolk

	def initialize id,code

		@id = id
		@rules = parse(code)
		stamina = 10
		@actionIndex = 0
		@status = "default"

		@orientation = 0
		@x = 0
		@y = 0

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
		command = @rules[@status][actionIndexClamped]

		if command.include?("move.") then act_move(command) end
		if command.include?("turn.") then act_turn(command) end
		if command.include?("step.") then act_step(command) end
			
		puts "#{@id} [#{status}] -> #{command} [#{@x},#{@y}:#{@orientation}]"

		@actionIndex += 1
	end

	def act_move command

		method = command.sub("move.","")

		if method == "forward"
			if @orientation == 0 then @y += 1 end
			if @orientation == 1 then @x += 1 end
			if @orientation == 2 then @y -= 1 end
			if @orientation == 3 then @x -= 1 end
		end

		if method == "backward"
			if @orientation == 0 then @y -= 1 end
			if @orientation == 1 then @x -= 1 end
			if @orientation == 2 then @y += 1 end
			if @orientation == 3 then @x += 1 end
		end

	end

	def act_step command

		method = command.sub("step.","")

		if method == "left"
			if @orientation == 0 then @x -= 1 end
			if @orientation == 1 then @y += 1 end
			if @orientation == 2 then @x += 1 end
			if @orientation == 3 then @y -= 1 end
		end

		if method == "right"
			if @orientation == 0 then @x += 1 end
			if @orientation == 1 then @y -= 1 end
			if @orientation == 2 then @x -= 1 end
			if @orientation == 3 then @y += 1 end
		end

	end

	def act_turn command

		method = command.sub("turn.","")

		if method == "right"
			@orientation = (@orientation + 1) & 3
		end

		if method == "left"
			@orientation = (@orientation - 1) & 3
		end

	end

	def action
		return @code
	end

end

# Create Players

# Make Player1
code = "
move.forward
move.forward
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
	puts "-------------"
	puts "PHASE #{phase}"
	for player in players
		player.act(phase)
	end
	phase += 1
	puts "-------------"
end

puts "SUMMARY"
puts "[missing]"



