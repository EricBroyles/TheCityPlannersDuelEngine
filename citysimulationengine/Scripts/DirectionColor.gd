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
const NONE_WITH_MULTI: PackedStringArray = [NONE]
const ALL_WITH_MULTI : PackedStringArray = [ALL]
const E_WITH_MULTI   : PackedStringArray = [E, N, S, NE, SE]
const NE_WITH_MULTI  : PackedStringArray = [NE, N, E, NW, SE]
const N_WITH_MULTI   : PackedStringArray = [N, NE, NW, E, W]
const NW_WITH_MULTI  : PackedStringArray = [NW, N, W, NE, SW]
const W_WITH_MULTI   : PackedStringArray = [W, N, S, NW, SW]
const SW_WITH_MULTI  : PackedStringArray = [SW, S, W, SE, NW]
const S_WITH_MULTI   : PackedStringArray = [S, SE, SW, E, W]
const SE_WITH_MULTI  : PackedStringArray = [SE, S, E, SW, NE]

const DIR_STR_MAP: Dictionary = {
	"none": NONE_WITH_MULTI,
	"all" : ALL_WITH_MULTI,
	"e"   : E_WITH_MULTI,
	"ne"  : NE_WITH_MULTI,
	"n"   : N_WITH_MULTI,
	"nw"  : NW_WITH_MULTI,
	"w"   : W_WITH_MULTI,
	"sw"  : SW_WITH_MULTI,
	"s"   : S_WITH_MULTI,
	"se"  : SE_WITH_MULTI,
}

var dir_bit_str: String = NONE

static func create_empty() -> DirectionColor:
	return DirectionColor.new()
	
static func bit_str_create(bit_str: String) -> DirectionColor:
	var dir_color: DirectionColor = DirectionColor.new()
	dir_color.dir_bit_str = bit_str
	return dir_color
		
static func string_create(d: String, multi_dir: bool = true) -> DirectionColor:
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
