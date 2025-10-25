class_name Velocity

var speed_mph: float
var direction_degrees: float

static func create_empty() -> Velocity:
	var new_vel: Velocity = Velocity.new()
	return new_vel
	
static func create(new_speed_mph: float, new_direction_degrees: float) -> Velocity:
	var new_vel: Velocity = Velocity.new()
	new_vel.speed_mph = new_speed_mph
	new_vel.direction_degrees = new_direction_degrees
	return new_vel
	
func _to_string() -> String:
	return "Velocity [ Speed MPH = " + str(speed_mph) + " | Direction Degrees = " + str(direction_degrees) + " ]"
	
func is_empty() -> bool:
	if speed_mph == null and direction_degrees == null:
		return true
	return false

func get_speed_tps() -> float: #tick per sec
	return 0.0 #float or int idk
	
func set_direction_degrees_from_cardinal(s: String):
	match s:
		"E": direction_degrees = 0.0
		"NE": direction_degrees = 45.0
		"N":  direction_degrees = 90.0
		"NW": direction_degrees = 135.0
		"W":  direction_degrees = 180.0
		"SW": direction_degrees = 225.0
		"S":  direction_degrees = 270.0
		"SE": direction_degrees = 315.0
		_: 
			direction_degrees = 0.0
			push_error("Failed to provide a carinal direction")
		
			
