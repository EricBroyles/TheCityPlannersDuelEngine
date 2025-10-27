class_name TerrainColor
const IMAGE_FORMAT := Image.FORMAT_RGBA8 # r,g,b,a with 8 bits
const EMPTY_COLOR: Color = Color(0,0,0,0)

#var grid_dark: Color = Color("#3DD06E")
#var grid_light: Color = Color("#4EF887")
const ROAD: Color = Color("#78A2CE")
const WALKWAY: Color = Color("#F4A361")
const PARKING: Color = Color("#2878CC")
const BUILDING: Color = Color("#BBBBBB")
const BARRIER: Color = Color("#424242")
const LANE_DIVIDER: Color = Color("#F0F0F0", 0.5)
const JUNCTION_STOP: Color = Color("#CD0202", 0.9)
const JUNCTION1: Color = Color("#CD0202", 0.7)
const JUNCTION2: Color = Color("#CD0202", 0.5)
const JUNCTION3: Color = Color("#CD0202", 0.3)

var color: Color = EMPTY_COLOR

static func create_empty() -> TerrainColor:
	return TerrainColor.new()
	
static func create(color_option: Color) -> TerrainColor:
	var terrain_color: TerrainColor = TerrainColor.new()
	terrain_color.color = color_option
	return terrain_color

func is_empty() -> bool:
	if color == EMPTY_COLOR: return true
	return false
