class_name VelocityColor

# r: speed -> (0 to 1000) / 1000
# g: direction -> (0 to 360) / 360
# b: is_full -> 0 or 1
# a: NONE

const IMAGE_FORMAT := Image.FORMAT_RGBH # r,g,b with 16 bits
const EMPTY_COLOR: Color = Color(0,0,0,0)
const MAX_SPEED_MPH: int = 250
const MIN_SPEED_MPH: int = 0
const MAX_DIR_DEG: int  = 315

var cardinal_table: Dictionary = {
	"e" : 0,
	"ne": 45,
	"n" : 90,
	"nw": 135,
	"w" : 180,
	"sw": 225,
	"s" : 270,
	"se": 315,
}

var color: Color = EMPTY_COLOR

static func create_empty() -> VelocityColor:
	return VelocityColor.new()

static func create(speed_mph: int, dir: String) -> VelocityColor:
	var vel: VelocityColor = VelocityColor.new()
	vel.set_speed(speed_mph)
	vel.set_direction(dir)
	vel.set_full()
	return vel

func set_speed(mph: int) -> void:
	var formated_speed: float = clamp(mph, MIN_SPEED_MPH, MAX_SPEED_MPH) / float(MAX_SPEED_MPH)
	color.r = formated_speed

func set_direction(dir: String) -> void:
	var direction_degrees: int
	direction_degrees = cardinal_table[dir.to_lower()]
	color.g = direction_degrees / float(MAX_DIR_DEG)

func set_full() -> void:
	color.b = 1

func is_empty() -> bool:
	if color.b == 0: return true
	return false
	
static func decode(c: Color) -> void:
	var speed: int = int(round(c.r * MAX_SPEED_MPH))
	var dir_deg: int = int(round(c.g * MAX_DIR_DEG))
	var is_full: int = int(c.b)
	
	print(speed, " ", dir_deg, " ", is_full)
	
	
	


		


	
	
