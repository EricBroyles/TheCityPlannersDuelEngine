class_name DrawStruct

enum  {NONE, ERASE, DRAW}

const MIN_BRUSH_CSIZE: Vector2i = Vector2i.ONE
const MAX_BRUSH_CSIZE: Vector2i = MIN_BRUSH_CSIZE * 100
const BRUSH_COLOR: Color = Color(0,0,0,.5)

var type: int = NONE 
var terrain_type_color: TerrainTypeColor = TerrainTypeColor.create_empty()
var terrain_mod_color: TerrainModColor = TerrainModColor.create_empty()
var speed_mph_color: SpeedMPHColor = SpeedMPHColor.create_empty()
var direction_color: DirectionColor = DirectionColor.create_empty()

var brush_csize: Vector2i = MIN_BRUSH_CSIZE
var brush_color: Color = BRUSH_COLOR

static func create_empty() -> DrawStruct:
	return DrawStruct.new()
	
func set_brush_size(req_brush_csize: Vector2i) -> void:
	brush_csize = clamp(req_brush_csize, MIN_BRUSH_CSIZE, MAX_BRUSH_CSIZE)
	
func get_px_size() -> Vector2i:
	return brush_csize * GameData.world_px_per_cell
