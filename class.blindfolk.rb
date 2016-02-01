class Blindfolk

	def initialize id,script

		@id = id
		@rules = parse(script)
		@stamina = 10
		@actionIndex = 0
		@status = "default"
		@isAlive = 1
		@score = 0

		@orientation = 0
		@x = 0
		@y = 0
		@name = "<blindfolk>Blindfolk ##{@id}</blindfolk>"

	end

	# Accessors

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

	def score
		return @score
	end

	# Parser

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

	# Actions

	def act

		@stamina -= 1

		if @stamina < 1 then return end
		if @isAlive == 0 then return end

		if !@rules[@status] then @rules[@status] = ["idle"] end

		actionIndexClamped = @actionIndex % @rules[@status].length
		command = @rules[@status][actionIndexClamped]

		if command.include?("move.") then act_move(command)
		elsif command.include?("turn.") then act_turn(command)
		elsif command.include?("step.") then act_step(command)
		elsif command.include?("say ") then act_say(command)
		elsif command.include?("attack.") then act_attack(command)
		else act_idle end

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

	def act_idle

		log("#{@name} idles.")

	end

	# Ripostes

	def collide enemy

		log("#{@name} collides with \"#{enemy.name}\".")

		caseOrientation = ""

		# North
		if enemy.x == @x && enemy.y == @y + 1
			if @orientation == 0 then caseOrientation = "forward" end
			if @orientation == 1 then caseOrientation = "left" end
			if @orientation == 2 then caseOrientation = "backward" end
			if @orientation == 3 then caseOrientation = "right" end
		end

		# East
		if enemy.x == @x + 1 && enemy.y == @y
			if @orientation == 0 then caseOrientation = "right" end
			if @orientation == 1 then caseOrientation = "forward" end
			if @orientation == 2 then caseOrientation = "left" end
			if @orientation == 3 then caseOrientation = "backward" end
		end

		# South
		if enemy.x == @x && enemy.y == @y - 1
			if @orientation == 0 then caseOrientation = "backward" end
			if @orientation == 1 then caseOrientation = "right" end
			if @orientation == 2 then caseOrientation = "forward" end
			if @orientation == 3 then caseOrientation = "left" end
		end

		# West
		if enemy.x == @x - 1 && enemy.y == @y
			if @orientation == 0 then caseOrientation = "left" end
			if @orientation == 1 then caseOrientation = "backward" end
			if @orientation == 2 then caseOrientation = "right" end
			if @orientation == 3 then caseOrientation = "forward" end
		end

		# Riposte

		if @rules["collide.#{caseOrientation}"]
			log("#{@name} counters!")
			@status = "collide.#{caseOrientation}"
			@actionIndex = 0
			for riposte in @rules["collide.#{caseOrientation}"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
		elsif @rules["collide"]
			log("#{@name} counters!")
			@status = "collide"
			@actionIndex = 0
			for riposte in @rules["collide"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
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
			log("#{@name} counters!")
			@status = "attack.#{caseOrientation}"
			@actionIndex = 0
			for riposte in @rules["attack.#{caseOrientation}"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0
		elsif @rules["attack"]
			log("#{@name} counters!")
			@status = "attack"
			@actionIndex = 0
			for riposte in @rules["attack"]
				self.act()
			end
			@status = "default"
			@actionIndex = 0		
		end

	end

	# Events

	def kill enemy

		log("#{@name} kills #{enemy.name}.")
		@score += 1
		enemy.die()

	end

	def die

		@isAlive = 0

	end

	# Tools

	def enemyAtLocation x,y

		for player in $players
			if player.id == @id then next end
			if player.isAlive == 0 then next end
			if player.x == x && player.y == y then return player end
		end

		return nil

	end

end