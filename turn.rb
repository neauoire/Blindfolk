class Blindfolk

	def initialize id,x,y,code

		@id = id
		@rules = parse(code)
		@actionIndex = 0
		@status = "default"

		@orientation = 0
		@x = x
		@y = y

	end

	def id
		return @id
	end

	def x
		return @x
	end

	def y
		return @y
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

	def act phase

		actionIndexClamped = @actionIndex % @rules[@status].length
		command = @rules[@status][actionIndexClamped]

		if command.include?("move.") then act_move(command) end
		if command.include?("turn.") then act_turn(command) end
		if command.include?("step.") then act_step(command) end
		if command.include?("say ") then act_say(command) end
		if command.include?("attack.") then act_attack(command) end

		puts "#{@id} [#{@status}] -> #{command} [#{@x},#{@y}:#{@orientation}]"

		@actionIndex += 1
	end

	def act_move command

		method = command.sub("move.","")
		new_x = @x
		new_y = @y
		origin = 0

		if method == "forward"
			if @orientation == 0 then new_y += 1 ; origin = 2 end
			if @orientation == 1 then new_x += 1 ; origin = 3 end
			if @orientation == 2 then new_y -= 1 ; origin = 0 end
			if @orientation == 3 then new_x -= 1 ; origin = 1 end
		end

		if method == "backward"
			if @orientation == 0 then new_y -= 1 ; origin = 0 end
			if @orientation == 1 then new_x -= 1 ; origin = 1 end
			if @orientation == 2 then new_y += 1 ; origin = 2 end
			if @orientation == 3 then new_x += 1 ; origin = 3 end
		end

		if enemyAtLocation(new_x,new_y) then enemyAtLocation(new_x,new_y).bump(self,origin) else @x = new_x ; @y = new_y end

	end

	def act_step command

		method = command.sub("step.","")
		new_x = @x
		new_y = @y
		origin = 0

		if method == "left"
			if @orientation == 0 then new_x -= 1 ; origin = 1 end
			if @orientation == 1 then new_y += 1 ; origin = 2 end
			if @orientation == 2 then new_x += 1 ; origin = 3 end
			if @orientation == 3 then new_y -= 1 ; origin = 0 end
		end

		if method == "right"
			if @orientation == 0 then new_x += 1 ; origin = 3 end
			if @orientation == 1 then new_y -= 1 ; origin = 0 end
			if @orientation == 2 then new_x -= 1 ; origin = 1 end
			if @orientation == 3 then new_y += 1 ; origin = 2 end
		end

		if enemyAtLocation(new_x,new_y) then enemyAtLocation(new_x,new_y).bump(self,origin) else @x = new_x ; @y = new_y end

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

	def act_say command

		value = command.sub("say ","")
		puts value

	end

	def act_attack command

		method = command.sub("attack.","")

	end

	def bump player,origin

		puts "Collision [#{player.id} -> #{@id}]"

	end

	def enemyAtLocation x,y

		for player in $players
			if player.id == @id then next end
			if player.x == x && player.y == y then return player end
		end

		return nil

	end

end

# Create Players

# Make Player1
code = "
turn.right
turn.right
"
p1 = Blindfolk.new(1,0,1,code)

# Make Player2
code = "
turn.right
turn.right
"
p2 = Blindfolk.new(2,1,1,code)

# Make Player3
code = "
move.forward
move.forward
"
p3 = Blindfolk.new(3,0,0,code)

$players = [p1,p2,p3].shuffle

# Play

phase = 1
while phase <= 5
	puts "-------------"
	puts "PHASE #{phase}"
	for player in $players
		player.act(phase)
	end
	phase += 1
	puts "-------------"
end

puts "SUMMARY"
puts "[missing]"



