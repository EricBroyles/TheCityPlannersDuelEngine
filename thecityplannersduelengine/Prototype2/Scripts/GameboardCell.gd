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
	
static func string_to_contents(s: String) -> Array[bool]:
	var tokens: PackedStringArray = s.strip_edges().split(" ")
	var result: Array[bool] = get_empty_contents()
	for token in tokens:
		if not token.begins_with("ve"):  
			match token:
				"ro": result[ROAD] = true
				"wa": result[WALKWAY] = true
				"bu": result[BUILDING] = true
				"pa": result[PARKING] = true
				"ba": result[BARRIER] = true
				"la": result[LANE_DIVIDER] = true
				"js": result[STOP_JUNCTION] = true
				"j1": result[LVL1_JUNCTION] = true
				"j2": result[LVL2_JUNCTION] = true
				"j3": result[LVL3_JUNCTION] = true
				_: push_warning("Unknown terrain code: ", token)
	return result
	
static func string_to_velocity(s: String) -> Velocity:
	var v: Velocity = Velocity.create_empty()
	if s.strip_edges() == "": return v
	var tokens: PackedStringArray = s.strip_edges().split(" ")
	for token in tokens:
		if token.begins_with("ve"):
			# Extract numeric and direction parts
			# Example: "Ve30NE" -> speed = 30, dir = "NE"
			var body = token.substr(2, token.length() - 2)
			var speed_str: String = ""
			var dir_str: String = ""
			# Separate digits and letters
			for c in body:
				if c.is_valid_int():
					speed_str += c
				else:
					dir_str += c
			if speed_str != "":
				v.speed_mph = float(speed_str)
			if dir_str != "":
				v.set_direction_degrees_from_cardinal(dir_str)
	return v

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
	if ground == GROUND.LIGHT: c = c.blend(EngineData.grid_light_color)
	else: c = c.blend(EngineData.grid_dark_color)
	for i in MAX:
		if contents[i]: c = c.blend(_color_map(i))
	return c
		
func _color_map(i: int) -> Color:
	match i:
		ROAD: return EngineData.road_color
		WALKWAY: return EngineData.walkway_color
		PARKING: return EngineData.parking_color
		BUILDING: return EngineData.building_color
		BARRIER: return EngineData.barrier_color
		STOP_JUNCTION: return EngineData.stop_junction_color
		LVL1_JUNCTION: return EngineData.lvl1_junction_color
		LVL2_JUNCTION: return EngineData.lvl2_junction_color
		LVL3_JUNCTION: return EngineData.lvl3_junction_color
		_: 
			push_warning("NO MATCHING COLOR")
			return Color("#000000", 0)
	
	
	




#class_name GameboardCell
#
### Notes:
##  Physical Terrain: only a road or walkway or building or parking can exist simultaniously
#
#enum {
	#NONE, 
	#LIGHT_GROUND, DARK_GROUND,
	#ROAD, WALKWAY, BUILDING, PARKING, BARRIER, #Terrains
	#STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION, #junction
	#LANE_DIVIDER, MAX_OPTIONS
#}
#
#const TERRAINS: Array[int] = [ROAD, WALKWAY, BUILDING, PARKING, BARRIER]
#const JUNCTIONS: Array[int] = [STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION,]
#
#var ground: int = NONE
#var terrain: int = NONE
#var junction: int = NONE
#var lane_divider: int = NONE
#var velocity: Velocity = Velocity.create_empty()
#
#static func create_empty() -> GameboardCell:
	#var new_cell: GameboardCell = GameboardCell.new()
	#return new_cell
	#
#func is_empty() -> bool:
	#if terrain == NONE and junction == NONE and lane_divider == NONE and velocity.is_empty():
		#return true
	#return false
	#
#func additive_override(overriding_cell: GameboardCell) -> void:
	## Ex: 
	## Cell: terrain = Road, junction = NONE, lane_divider = LaneDivider, velocity = 5mph, N
	## Over: terrain = BUILDING, junction = STOP, lane_divider = LaneDivider, velocity = 5mph, N
	#if overriding_cell.terrain != NONE: terrain = overriding_cell.terrain
	#if overriding_cell.junction != NONE: junction = overriding_cell.junction
	#if overriding_cell.lane_divider != NONE: lane_divider = overriding_cell.lane_divider
	#if not overriding_cell.velocity.is_empty(): velocity = overriding_cell.velocity
#
##func subtractive_override(overriding_cell: GameboardCell) -> void:
	###for terrain, junction, lane_divider, velocity take the overriind cells value if it is not NONE
	##if overriding_cell.terrain != NONE: terrain = overriding_cell.terrain
	##if overriding_cell.junction != NONE: junction = overriding_cell.junction
	##if overriding_cell.lane_divider != NONE: lane_divider = overriding_cell.lane_divider
	##if not overriding_cell.velocity.is_empty(): velocity = overriding_cell.velocity
	#
#func get_cell_color() -> Color:
	#var c: Color = Color("#000000", 0)
	#match terrain:
		#ROAD: c = c.blend(EngineData.road_color)
		#WALKWAY: c = c.blend(EngineData.walkway_color)
		#PARKING: c = c.blend(EngineData.parking_color)
		#BUILDING: c = c.blend(EngineData.building_color)
		#BARRIER: c = c.blend(EngineData.barrier_color)
		#_: match ground:
			#LIGHT_GROUND: c.blend(EngineData.grid_light_color)
			#DARK_GROUND: c.blend(EngineData.grid_dark_color)
	#match junction:
		#STOP_JUNCTION: c = c.blend(EngineData.stop_junction_color)
		#LVL1_JUNCTION: c = c.blend(EngineData.lvl1_junction_color)
		#LVL2_JUNCTION: c = c.blend(EngineData.lvl2_junction_color)
		#LVL3_JUNCTION: c = c.blend(EngineData.lvl3_junction_color)
	#match lane_divider:
		#LANE_DIVIDER: c = c.blend(EngineData.lane_divider_color)
	#return c
	#
#func increment_junction(by: int) -> void:
	## will not go back to NONE
	#var i: int 
	#if junction == NONE: i = -1
	#else: i = JUNCTIONS.find(junction)
	#i = clamp(i + by, 0, JUNCTIONS.size()-1)
	#print(i)
	#junction = JUNCTIONS[i]
#
#
#
#
#
#
#
	#
	#
#
	#
