class_name SpeedMPHColor

const IMAGE_FORMAT := Image.FORMAT_R8
const MIN_SPEED: int = 0
const MAX_SPEED: int = 255
var speed_mph: int = 0 

static func create_empty() -> SpeedMPHColor:
	return SpeedMPHColor.new()
	
static func create(s: int) -> SpeedMPHColor:
	var speed_mph_color: SpeedMPHColor = SpeedMPHColor.new()
	speed_mph_color.speed_mph = clamp(s, MIN_SPEED, MAX_SPEED)
	return speed_mph_color
	
func is_empty() -> bool:
	if speed_mph == 0: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(speed_mph, 0, 0, 0))
