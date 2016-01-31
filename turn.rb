
class Blindfolk

	def initialize id,code
		@code = code
		actionsLeft = 10
	end

end

# Make Player1
code = "
case default
  move.forward
"
p1 = Blindfolk.new(1,code)

# Make Player2
code = "
case default
  move.forward
"
p2 = Blindfolk.new(2,code)

players = [p1,p2]

puts "Start!"









