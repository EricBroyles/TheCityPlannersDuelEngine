class_name GameboardCell

## Notes:
#  Physical Terrain: only a road or walkway or building or parking can exist simultaniously

enum {
	NONE, 
	LIGHT_GROUND, DARK_GROUND,
	ROAD, WALKWAY, BUILDING, PARKING, BARRIER, #Terrains
	STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION, #junction
	LANE_DIVIDER
}

const TERRAINS: Array[int] = [ROAD, WALKWAY, BUILDING, PARKING, BARRIER]
const JUNCTIONS: Array[int] = [STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION,]

var ground: int = NONE
var terrain: int = NONE
var junction: int = NONE
var lane_divider: int = NONE
var velocity: Velocity = Velocity.create_empty()

static func create_empty() -> GameboardCell:
	var new_cell: GameboardCell = GameboardCell.new()
	return new_cell
	
func is_empty() -> bool:
	if terrain == NONE and junction == NONE and lane_divider == NONE and velocity.is_empty():
		return true
	return false
	
func additive_override(overriding_cell: GameboardCell) -> void:
	# Ex: 
	# Cell: terrain = Road, junction = NONE, lane_divider = LaneDivider, velocity = 5mph, N
	# Over: terrain = BUILDING, junction = STOP, lane_divider = LaneDivider, velocity = 5mph, N
	if overriding_cell.terrain != NONE: terrain = overriding_cell.terrain
	if overriding_cell.junction != NONE: junction = overriding_cell.junction
	if overriding_cell.lane_divider != NONE: lane_divider = overriding_cell.lane_divider
	if not overriding_cell.velocity.is_empty(): velocity = overriding_cell.velocity

#func subtractive_override(overriding_cell: GameboardCell) -> void:
	##for terrain, junction, lane_divider, velocity take the overriind cells value if it is not NONE
	#if overriding_cell.terrain != NONE: terrain = overriding_cell.terrain
	#if overriding_cell.junction != NONE: junction = overriding_cell.junction
	#if overriding_cell.lane_divider != NONE: lane_divider = overriding_cell.lane_divider
	#if not overriding_cell.velocity.is_empty(): velocity = overriding_cell.velocity
	
func get_cell_color() -> Color:
	var c: Color = Color("#000000", 0)
	match terrain:
		ROAD: c = c.blend(EngineData.road_color)
		WALKWAY: c = c.blend(EngineData.walkway_color)
		PARKING: c = c.blend(EngineData.parking_color)
		BUILDING: c = c.blend(EngineData.building_color)
		BARRIER: c = c.blend(EngineData.barrier_color)
		_: match ground:
			LIGHT_GROUND: c.blend(EngineData.grid_light_color)
			DARK_GROUND: c.blend(EngineData.grid_dark_color)
	match junction:
		STOP_JUNCTION: c = c.blend(EngineData.stop_junction_color)
		LVL1_JUNCTION: c = c.blend(EngineData.lvl1_junction_color)
		LVL2_JUNCTION: c = c.blend(EngineData.lvl2_junction_color)
		LVL3_JUNCTION: c = c.blend(EngineData.lvl3_junction_color)
	match lane_divider:
		LANE_DIVIDER: c = c.blend(EngineData.lane_divider_color)
	return c
	
func increment_junction(by: int) -> void:
	# will not go back to NONE
	var i: int 
	if junction == NONE: i = -1
	else: i = JUNCTIONS.find(junction)
	i = clamp(i + by, 0, JUNCTIONS.size()-1)
	print(i)
	junction = JUNCTIONS[i]







	
	

	
