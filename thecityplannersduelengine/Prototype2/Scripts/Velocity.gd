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
	
func is_empty() -> bool:
	if speed_mph == null and direction_degrees == null:
		return true
	return false

func get_speed_tps() -> float: #tick per sec
	return 0.0 #float or int idk
