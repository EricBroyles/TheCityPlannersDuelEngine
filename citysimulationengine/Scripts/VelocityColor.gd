class_name VelocityColor

# r: speed -> (0 to 1000) / 1000
# g: direction -> (0 to 360) / 360
# b: is_empty -> 0 or 1
# a: NONE

const EMPTY_COLOR: Color = Color(0,0,0,0)
const MAX_SPEED_MPH: int = 1000
const MIN_SPEED_MPU: int = 0

var color: Color = EMPTY_COLOR

static func create_empty() -> VelocityColor:
	return VelocityColor.new()

static func create(speed_mph: int, dir: String) -> VelocityColor:
	var vel: VelocityColor = VelocityColor.new()
	vel.set_speed(speed_mph)
	vel.set_direction(dir)
	return vel

func set_speed(mph: int) -> void:
	var formated_speed: float = clamp(mph, MIN_SPEED_MPU, MAX_SPEED_MPH) / float(MAX_SPEED_MPH)
	color.r = formated_speed

func set_direction(dir: String) -> void:
	var direction_degrees: int
	match dir.to_lower():
		"e" : direction_degrees = 0
		"ne": direction_degrees = 45
		"n" :  direction_degrees = 90
		"nw": direction_degrees = 135
		"w" :  direction_degrees = 180
		"sw": direction_degrees = 225
		"s" :  direction_degrees = 270
		"se": direction_degrees = 315
		_: 
			direction_degrees = 0
			push_error("Failed to provide a carinal direction")
	color.g = direction_degrees / 360.0
	
func is_empty() -> bool:
	if color.b == 0: return true
	return false
	


		


	
	
