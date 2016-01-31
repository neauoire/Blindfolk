class Blindfolk

	def initialize id,x,y,code

		@id = id
		@rules = parse(code)
		@stamina = 10
		@actionIndex = 0
		@status = "default"
		@isAlive = 1

		@orientation = 0
		@x = x
		@y = y
		@name = "Blindfolk ##{@id}"

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

	def name
		return @name
	end

	def isAlive
		return @isAlive
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

		@stamina -= 1

		if @stamina < 1 then return end
		if @isAlive == 0 then return end

		actionIndexClamped = @actionIndex % @rules[@status].length
		command = @rules[@status][actionIndexClamped]

		if command.include?("move.") then act_move(command) end
		if command.include?("turn.") then act_turn(command) end
		if command.include?("step.") then act_step(command) end
		if command.include?("say ") then act_say(command) end
		if command.include?("attack.") then act_attack(command) end

		@actionIndex += 1

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

		if enemyAtLocation(new_x,new_y)
			log("#{@name} attemps to move, but is blocked by #{enemyAtLocation(new_x,new_y).name}.")
			collide(enemyAtLocation(new_x,new_y)) 
		else 
			@x = new_x ; @y = new_y 
			log("#{@name} moved to #{@x},#{@y}.")
		end

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

		if enemyAtLocation(new_x,new_y)
			log("#{@name} attemps to step, but is blocked by #{enemyAtLocation(new_x,new_y).name}.")
			collide(enemyAtLocation(new_x,new_y)) 
		else 
			@x = new_x ; @y = new_y 
			log("#{@name} moved to #{@x},#{@y}.")
		end

	end

	def act_attack command

		method = command.sub("attack.","")
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

		target = enemyAtLocation(new_x,new_y)

		if target
			log("#{@name} attacks #{target.name}.")
			target.attacked(self) 
		else 
			log("#{@name} attacks nothing #{method} at #{new_x},#{new_y} from #{@x},#{@y}.")
		end

		# Land blow

		if target && target.x == new_x && target.y == new_y
			if @stamina > 0
				kill(target)
			end
		else
			log("Missed")
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

		log("#{@name} turns #{method}.")

	end

	def act_say command

		value = command.sub("say ","")
		log("#{@name} says \"#{value}\".")

	end

	def collide enemy

		log("#{@name} collides with \"#{enemy.name}\".")

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

		# Riposte

		if @rules["collide.#{caseOrientation}"]
			log("#{@name} [combo].")
			@status = "collide.#{caseOrientation}"
			@actionIndex = 0
			for riposte in @rules["collide.#{caseOrientation}"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
		else
			log("#{@name} idle.")
		end

	end

	def attacked enemy

		caseOrientation = ""

		if @orientation == 0
			if enemy.x == @x && enemy.y == @y + 1 then caseOrientation = "forward" end
			if enemy.x == @x && enemy.y == @y - 1 then caseOrientation = "back" end
		end
		if @orientation == 1
			if enemy.x == @x + 1 && enemy.y == @y then caseOrientation = "forward" end
			if enemy.x == @x - 1 && enemy.y == @y then caseOrientation = "back" end
		end
		if @orientation == 2
			if enemy.x == @x && enemy.y == @y - 1 then caseOrientation = "forward" end
			if enemy.x == @x && enemy.y == @y + 1 then caseOrientation = "back" end
		end
		if @orientation == 3
			if enemy.x == @x - 1 && enemy.y == @y then caseOrientation = "forward" end
			if enemy.x == @x + 1 && enemy.y == @y then caseOrientation = "back" end
		end

		# Riposte
		if @rules["attack.#{caseOrientation}"]
			log("#{@name} [riposte].")
			@status = "attack.#{caseOrientation}"
			@actionIndex = 0
			for riposte in @rules["attack.#{caseOrientation}"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
		end

	end

	def kill enemy

		log("#{@name} kills #{enemy.name}.")
		enemy.die()

	end

	def die

		@isAlive = 0
		log("#{@name} dies.")

	end

	def enemyAtLocation x,y

		for player in $players
			if player.id == @id then next end
			if player.isAlive == 0 then next end
			if player.x == x && player.y == y then return player end
		end

		return nil

	end

end
