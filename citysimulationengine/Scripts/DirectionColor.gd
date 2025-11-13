class_name DirectionColor

"""
Stores the Direction as a bit_str with each bit represetning a direction starting at e going ccw

multi_dir = true 
ex: N -> [N, NE, NW, E, W],

multi_dir = false
ex: N -> [N]

"""

const IMAGE_FORMAT := Image.FORMAT_R8
const NONE: String = "00000000"
const ALL : String = "11111111"
const E   : String = "00000001"
const NE  : String = "00000010"
const N   : String = "00000100"
const NW  : String = "00001000"
const W   : String = "00010000"
const SW  : String = "00100000"
const S   : String = "01000000"
const SE  : String = "10000000"

#[direct match, if multi_dir is true...]
const DIR_STR_MAP: Dictionary = {
	"none": [NONE],
	"all" : [ALL],
	"e"   : [E, N, S, NE, SE],
	"ne"  : [NE, N, E, NW, SE],
	"n"   : [N, NE, NW, E, W],
	"nw"  : [NW, N, W, NE, SW],
	"w"   : [W, N, S, NW, SW],
	"sw"  : [SW, S, W, SE, NW],
	"s"   : [S, SE, SW, E, W],
	"se"  : [SE, S, E, SW, NE]
}

var dir_bit_str: String = NONE

static func create_empty() -> DirectionColor:
	return DirectionColor.new()
	
static func bit_str_create(bit_str: String) -> DirectionColor:
	var dir_color: DirectionColor = DirectionColor.new()
	dir_color.dir_bit_str = bit_str
	return dir_color
		
static func string_create(d: String, multi_dir = true) -> DirectionColor:
	var bit_str = NONE
	if not DIR_STR_MAP.has(d): 
		push_warning("INPUT: [%s] PROBLEM: [%s] RESULT: [%s]" % [d, "no valid DIR_STR_MAP", "returned empty DirectionColor"]);
		return DirectionColor.create_empty()
		
	if multi_dir: bit_str = Utils.combine_bit_strs(DIR_STR_MAP[d])
	else: bit_str = DIR_STR_MAP[d][0]
	
	return DirectionColor.bit_str_create(bit_str)

func is_empty() -> bool:
	if dir_bit_str == NONE: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(dir_bit_str.bin_to_int(), 0, 0, 0))
