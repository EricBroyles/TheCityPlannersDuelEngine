class_name GameboardCell

## Notes:
#  Physical Terrain: only a road or walkway or building or parking can exist simultaniously

enum {
	NONE, 
	ROAD, WALKWAY, BUILDING, PARKING, BARRIER, #Terrains
	STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION, #junction
	LANE_DIVIDER
}

const TERRAINS: Array[int] = [ROAD, WALKWAY, BUILDING, PARKING, BARRIER]
const JUNCTIONS: Array[int] = [STOP_JUNCTION, LVL1_JUNCTION, LVL2_JUNCTION, LVL3_JUNCTION,]

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
	
func get_cell_color() -> Color:

	var color: Color = Color("#000000", 0)
	
	match terrain:
		ROAD: color = color.blend(EngineData.road_color)
		WALKWAY: color = color.blend(EngineData.walkway_color)
		PARKING: color = color.blend(EngineData.parking_color)
		BUILDING: color = color.blend(EngineData.building_color)
		BARRIER: color = color.blend(EngineData.barrier_color)
		
	match junction:
		STOP_JUNCTION: color = color.blend(EngineData.stop_junction_color)
		LVL1_JUNCTION: color = color.blend(EngineData.lvl1_junction_color)
		LVL2_JUNCTION: color = color.blend(EngineData.lvl2_junction_color)
		LVL3_JUNCTION: color = color.blend(EngineData.lvl3_junction_color)
		
	match lane_divider:
		LANE_DIVIDER: color = color.blend(EngineData.lane_divider_color)
	return color
	
func increment_junction(by: int) -> void:
	# will not go back to NONE
	var i: int 
	if junction == NONE: i = -1
	else: i = JUNCTIONS.find(junction)
	i = clamp(i + by, 0, JUNCTIONS.size()-1)
	print(i)
	junction = JUNCTIONS[i]







#enum TERRAINS  {NONE, ROAD, WALKWAY, BUILDING, PARKING, BARRIER}
#enum JUNCTIONS {NONE, STOP, LVL1, LVL2, LVL3}
#
#var terrain_status: int = TERRAINS.NONE
#var junction_status: int = JUNCTIONS.NONE
#var has_lane_divider: bool = false
#var velocity: Velocity = Velocity.create_empty()
#
#static func create_empty() -> GameboardCell:
	#var new_cell: GameboardCell = GameboardCell.new()
	#return new_cell
	#
#func is_empty() -> bool:
	#if (terrain_status == TERRAINS.NONE and junction_status == JUNCTIONS.NONE
		#and not(has_lane_divider) and velocity.is_empty()): return true
	#return false
#
#func clear_terrain() -> void:
	#terrain_status = TERRAINS.NONE
	#
#func clear_junction() -> void:
	#junction_status = JUNCTIONS.NONE
	#
#func clear_lane_divider() -> void:
	#has_lane_divider = false
	#
#func clear_velocity() -> void:
	#velocity = Velocity.create_empty()
	#
#func set_terrain(terrain: int) -> void:
	#terrain_status = terrain
	#
#func set_junction(junction: int) -> void:
	#junction_status = junction
	#
#func set_land_divider(option: bool) -> void:
	#has_lane_divider = option
	#
#func is_road() -> bool:
	#if terrain_status == TERRAINS.ROAD: return true
	#return false
	#
#func is_walkway() -> bool: 
	#if terrain_status == TERRAINS.WALKWAY: return true
	#return false
	#
#func is_building() -> bool: 
	#if terrain_status == TERRAINS.BUILDING: return true
	#return false
	#
#func is_junction() -> bool:
	#if junction_status != JUNCTIONS.NONE:
		#return true
	#return false

	
	

	
