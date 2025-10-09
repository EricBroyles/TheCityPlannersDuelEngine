class_name GameboardCell

## Notes:
#  Physical Terrain: only a road or walkway or building or parking can exist simultaniously

enum TERRAINS  {NONE, ROAD, WALKWAY, BUILDING, PARKING}
enum JUNCTIONS {NONE, STOP, LVL1, LVL2, LVL3}

var terrain_status: int = TERRAINS.NONE
var junction_status: int = JUNCTIONS.NONE
var has_lane_divider: bool = false
var velocity: Velocity = Velocity.create_empty()

static func create_empty() -> GameboardCell:
	var new_cell: GameboardCell = GameboardCell.new()
	return new_cell
	
func is_empty() -> bool:
	if (terrain_status == TERRAINS.NONE and junction_status == JUNCTIONS.NONE
		and not(has_lane_divider) and velocity.is_empty()): return true
	return false

func clear_terrain() -> void:
	terrain_status = TERRAINS.NONE
	
func clear_junction() -> void:
	junction_status = JUNCTIONS.NONE
	
func clear_lane_divider() -> void:
	has_lane_divider = false
	
func clear_velocity() -> void:
	velocity = Velocity.create_empty()
	
func set_terrain(option: int) -> void:
	terrain_status = option
	
func set_junction(option: int) -> void:
	junction_status = option
	
func set_land_divider(option: bool) -> void:
	has_lane_divider = option
	
	
	

	
