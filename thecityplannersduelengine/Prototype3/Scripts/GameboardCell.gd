class_name GameboardCell
enum GROUND {DARK, LIGHT}
enum {
	ROAD, WALKWAY, BUILDING, PARKING, BARRIER, #Terrains
	STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION, #junction
	LANE_DIVIDER, 
	MAX
}

var ground: int
var contents: Array[bool] = get_empty_contents() #the order matters. it depends on enum int value as the index
var velocity: Velocity = Velocity.create_empty()

static func create_empty() -> GameboardCell:
	var new_cell: GameboardCell = GameboardCell.new()
	return new_cell

static func get_empty_contents() -> Array[bool]:
	var empty_contents: Array[bool] = [false]
	empty_contents.resize(MAX)
	return empty_contents

func is_empty() -> bool:
	if contents == get_empty_contents() and velocity.is_empty(): return true
	return false
	
func override(new_contents: Array[bool], new_velocity: Velocity) -> void:
	override_contents(new_contents)
	override_velocity(new_velocity)

func override_contents(new_contents: Array[bool]) -> void:
	contents = new_contents

func override_velocity(new_velocity: Velocity) -> void:
	if new_velocity.is_empty(): return
	velocity = new_velocity

func is_junction() -> bool:
	if (contents[STOP_JUNCTION] or contents[LVL1_JUNCTION] or
		contents[LVL2_JUNCTION] or contents[LVL3_JUNCTION]): return true
	return false
	
func get_color() -> Color:
	var c: Color = Color("#000000", 0)
	if ground == GROUND.LIGHT: c = c.blend(GameData.grid_light_color)
	else: c = c.blend(GameData.grid_dark_color)
	for i in MAX:
		if contents[i]: c = c.blend(_color_map(i))
	return c
		
func _color_map(i: int) -> Color:
	match i:
		ROAD: return GameData.road_color
		WALKWAY: return GameData.walkway_color
		PARKING: return GameData.parking_color
		BUILDING: return GameData.building_color
		BARRIER: return GameData.barrier_color
		STOP_JUNCTION: return GameData.stop_junction_color
		LVL1_JUNCTION: return GameData.lvl1_junction_color
		LVL2_JUNCTION: return GameData.lvl2_junction_color
		LVL3_JUNCTION: return GameData.lvl3_junction_color
		_: 
			push_warning("NO MATCHING COLOR")
			return Color("#000000", 0)
	
	
	
