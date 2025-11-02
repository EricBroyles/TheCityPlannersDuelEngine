class_name TerrainTypeColor
enum  {NONE, ROAD, WALKWAY, CROSSWALK, PARKING, BUILDING, BARRIER, MAX}

const IMAGE_FORMAT := Image.FORMAT_R8
var type: int = 0 

static func create_empty() -> TerrainTypeColor:
	return TerrainTypeColor.new()
	
static func create(t: int) -> TerrainTypeColor:
	var tt_color: TerrainTypeColor = TerrainTypeColor.new()
	tt_color.type = t
	return tt_color
	
func is_empty() -> bool:
	if type == NONE: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(type, 0, 0, 0))
	
static func get_color_map() -> Array[Color]:
	return [GameData.EMPTY_COLOR, GameData.ROAD, 
			GameData.WALKWAY, GameData.CROSSWALK, 
			GameData.PARKING, GameData.BUILDING, 
			GameData.BARRIER]
