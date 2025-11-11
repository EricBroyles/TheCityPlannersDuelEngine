class_name DirectionColor

const IMAGE_FORMAT := Image.FORMAT_R8
enum  {NONE, E, NE, N, NW, W, SW, S, SE, ALL, MAX}
var dir: int = NONE 

static func create_empty() -> DirectionColor:
	return DirectionColor.new()

static func string_create(d: String) -> DirectionColor:
	var dir_color: DirectionColor = DirectionColor.new()
	match d:
		"none": dir_color.dir = NONE
		"e": dir_color.dir = E
		"ne": dir_color.dir = NE
		"n": dir_color.dir = N
		"nw": dir_color.dir = NW
		"w": dir_color.dir = W
		"sw": dir_color.dir = SW
		"s": dir_color.dir = S
		"se": dir_color.dir = SE
		"all": dir_color.dir = ALL
		_: 
			dir_color.dir = NONE
			push_warning("USER INPUT ERROR: (set to NONE) string_create for DirectionColor - ", d)
	return dir_color
			
static func create(d: int) -> DirectionColor:
	var dir_color: DirectionColor = DirectionColor.new()
	dir_color.dir = clamp(d, NONE, MAX-1)
	return dir_color
	
func is_empty() -> bool:
	if dir == NONE: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(dir, 0, 0, 0))
