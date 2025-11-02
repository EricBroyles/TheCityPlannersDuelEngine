class_name Utils

## STRINGS

#static func cmd_to_velocity_color(cmd: String) -> VelocityColor:
	## FORMAT "velocity(int, String)" where int = speed & String = n,s,e,w,ne,nw,se,sw
	## ex: velocity(100, ne)
	#var speed_mph: int
	#var dir: String
	#var s = cmd.strip_edges()
	#if not s.begins_with("velocity"):
		#push_error("USER INPUT ERROR: cmd_to_velocity_color --- ", s)
		#return VelocityColor.create_empty()
	#s.replace("velocity", "")
	#var str_arr: PackedStringArray = group_to_string_array(s)
	#speed_mph = str_arr[0].to_int()
	#dir = str_arr[1]
	#return VelocityColor.create(speed_mph, dir)
		
static func group_to_string_array(group: String) -> PackedStringArray:
	# FORMAT "(Value, Value, ...)"
	# ex: (100) -> Array["100"]
	# ex: (100, ne)  -> Array["100", "100"]
	# ex: (100, 100, 1000) -> Array["100", "100", "1000"]
	var s: String = group.strip_edges()
	if s.begins_with("(") and s.ends_with(")"):
		s = s.substr(1, s.length() - 2)
	else:
		push_error("USER INPUT ERROR: group_to_string_array --- ", group)
	var parts: PackedStringArray = s.split(",")
	for p in parts: p.strip_edges()
	return parts
	
## COLORS

static func ivec4_to_rgba8(ivec4: Vector4i) -> Color:
	#rgba8: represents ints from 0 -> 255
	var scaled_vec: Vector4 = ivec4 / 255.0
	return Color(scaled_vec.x, scaled_vec.y, scaled_vec.z, scaled_vec.w)
	
