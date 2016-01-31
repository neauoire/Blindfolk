class Blindfolk

	def initialize id,x,y,code

		@id = id
		@rules = parse(code)
		@stamina = 10
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

	def act

		if @stamina < 1 then return end

		actionIndexClamped = @actionIndex % @rules[@status].length
		command = @rules[@status][actionIndexClamped]

		if command.include?("move.") then act_move(command) end
		if command.include?("turn.") then act_turn(command) end
		if command.include?("step.") then act_step(command) end
		if command.include?("say ") then act_say(command) end
		if command.include?("attack.") then act_attack(command) end

		puts "#{@id} [#{@status}] -> #{command} [#{@x},#{@y}:#{@orientation}] stamina:#{@stamina}"

		@actionIndex += 1
		@stamina -= 1

	end

	def act_move command

		method = command.sub("move.","")
		new_x = @x
		new_y = @y

		if method == "forward"
			if @orientation == 0 then new_y += 1 end
			if @orientation == 1 then new_x += 1 end
			if @orientation == 2 then new_y -= 1 end
			if @orientation == 3 then new_x -= 1 end
		end

		if method == "backward"
			if @orientation == 0 then new_y -= 1 end
			if @orientation == 1 then new_x -= 1 end
			if @orientation == 2 then new_y += 1 end
			if @orientation == 3 then new_x += 1 end
		end

		if enemyAtLocation(new_x,new_y) then collide(enemyAtLocation(new_x,new_y)) else @x = new_x ; @y = new_y end

	end

	def act_step command

		method = command.sub("step.","")
		new_x = @x
		new_y = @y

		if method == "left"
			if @orientation == 0 then new_x -= 1 end
			if @orientation == 1 then new_y += 1 end
			if @orientation == 2 then new_x += 1 end
			if @orientation == 3 then new_y -= 1 end
		end

		if method == "right"
			if @orientation == 0 then new_x += 1 end
			if @orientation == 1 then new_y -= 1 end
			if @orientation == 2 then new_x -= 1 end
			if @orientation == 3 then new_y += 1 end
		end

		if enemyAtLocation(new_x,new_y) then collide(enemyAtLocation(new_x,new_y)) else @x = new_x ; @y = new_y end

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

	def collide enemy

		origin_normal = ""
		caseOrientation = ""

		# North
		if enemy.x == @x && enemy.y == @y + 1
			if @orientation == 0 then caseOrientation = "forward" end
			if @orientation == 1 then caseOrientation = "left" end
			if @orientation == 2 then caseOrientation = "back" end
			if @orientation == 3 then caseOrientation = "right" end
		end

		# East
		if enemy.x == @x + 1 && enemy.y == @y
			if @orientation == 0 then caseOrientation = "right" end
			if @orientation == 1 then caseOrientation = "forward" end
			if @orientation == 2 then caseOrientation = "left" end
			if @orientation == 3 then caseOrientation = "back" end
		end

		# South
		if enemy.x == @x && enemy.y == @y - 1
			if @orientation == 0 then caseOrientation = "back" end
			if @orientation == 1 then caseOrientation = "right" end
			if @orientation == 2 then caseOrientation = "forward" end
			if @orientation == 3 then caseOrientation = "left" end
		end

		# West
		if enemy.x == @x - 1 && enemy.y == @y
			if @orientation == 0 then caseOrientation = "left" end
			if @orientation == 1 then caseOrientation = "back" end
			if @orientation == 2 then caseOrientation = "right" end
			if @orientation == 3 then caseOrientation = "forward" end
		end

		if @rules["collide.#{caseOrientation}"]
			@status = "collide.#{caseOrientation}"
			@actionIndex = 0
			for riposte in @rules["collide.#{caseOrientation}"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
		end

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
case default
  turn.right
  turn.right
"
p1 = Blindfolk.new(1,0,1,code)

# Make Player3
code = "
case collide.forward
  step.right
  step.right
case default
  move.forward
  move.forward
"
p3 = Blindfolk.new(3,0,0,code)

$players = [p1,p3].shuffle

# Play

phase = 1
while phase <= 10
	puts "-------------"
	puts "PHASE #{phase}"
	for player in $players
		player.act()
	end
	phase += 1
	puts "-------------"
end

puts "SUMMARY"
puts "[missing]"



