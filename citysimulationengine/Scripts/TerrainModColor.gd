class_name TerrainModColor
enum  {NONE, JUNCTION_STOP, JUNCTION1, JUNCTION2, JUNCTION3, LANE_DIVIDER, MAX}
const IMAGE_FORMAT := Image.FORMAT_R8
var mod: int = 0 

static func create_empty() -> TerrainModColor:
	return TerrainModColor.new()
	
static func create(m: int) -> TerrainModColor:
	var tm_color: TerrainModColor = TerrainModColor.new()
	tm_color.mod = m
	return tm_color
	
static func string_create(string: String) -> TerrainModColor:
	match string:
		"lane_divider": return TerrainModColor.create(LANE_DIVIDER)
		"junction_stop": return TerrainModColor.create(JUNCTION_STOP)
		"junction1": return TerrainModColor.create(JUNCTION1)
		"junction2": return TerrainModColor.create(JUNCTION2)
		"junction3": return TerrainModColor.create(JUNCTION3)
		_: return TerrainModColor.create_empty() 
	
func is_empty() -> bool:
	if mod == NONE: return true
	return false
	
func get_color() -> Color:
	return Utils.ivec4_to_rgba8(Vector4i(mod, 0, 0, 0))

#static func get_color_map() -> Array[Color]:
	#return [GameData.EMPTY_COLOR, GameData.JUNCTION_STOP, 
			#GameData.JUNCTION1, GameData.JUNCTION2, 
			#GameData.JUNCTION3, GameData.LANE_DIVIDER]
