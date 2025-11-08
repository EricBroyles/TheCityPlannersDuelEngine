class_name WorldColor

const IMAGE_FORMAT := Image.FORMAT_RGBA8

enum TYPES {NONE, ROAD, WALKWAY, CROSSWALK, PARKING, BUILDING, BARRIER, MAX}
enum MODS  {NONE, JUNCTION_STOP, JUNCTION1, JUNCTION2, JUNCTION3, LANE_DIVIDER, MAX}
enum DIRS  {NONE, E, NE, N, NW, W, SW, S, SE, ALL, MAX}
const MIN_SPEED_MPH: int = 0
const MAX_SPEED_MPH: int = 255
const DIR_DEG_MULT: int = 45 #45 degrees * (DIR-1)
#const EMPTY_COLOR: Color = Color(TYPES.NONE,MODS.NONE,MIN_SPEED_MPH,DIRS.NONE)

var type: int = TYPES.NONE
var mod : int = MODS.NONE
var speed_mph: int = MIN_SPEED_MPH
var dir_deg: int = DIRS.NONE #0, 45, 90, ..., 315

static func create_empty() -> WorldColor:
	return WorldColor.new()
	
static func create(t: int, m: int, s: int, d: int) -> WorldColor:
	var world_color: WorldColor = WorldColor.new()
	world_color.type = t
	world_color.mod = m
	world_color.speed_mph = s
	world_color.dir_deg = d
	return world_color
	
func is_empty() -> bool:
	if type + mod + speed_mph + dir_deg == 0: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(type, mod, speed_mph, dir_deg))
