class_name CommandStruct

## Commands
# draw road brush(10, 10)  --- must have draw first | exact spacing does not matter 
# draw speed(100) direction(ne) brush(10, 10)
# draw road junction1 speed(100) direction(any) brush(10,10)
# erase brush(10, 10) or draw erase brush(10,10)
# toggle background -> (hides or unhides background)
# toggle terrain_type -> 
# draw road brush -> default bursh is (10,10)
# draw speed -> warning: no (#) provided
# draw direction -> warning: no (str) provided
# draw road -> draws the road with 10,10 brush
# draw road brush -> same as draw road
# draw road brush(10,10) -> you get the idea.



var brush_size

func create(cmd: String) -> CommandStruct:
	var struct: CommandStruct = CommandStruct.new()
	
	#to lower case
	#remove any excess spaces
	#split based on
	
	
	return struct
	
