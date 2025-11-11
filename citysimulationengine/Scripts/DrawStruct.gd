class_name DrawStruct

enum  {NONE, ERASE, DRAW}

const DEFAULT_BRUSH_SIZE: Vector2i = Vector2i(10,10)
const MIN_BRUSH_CELL_SIZE: Vector2i = Vector2i.ONE
const MAX_BRUSH_CELL_SIZE: Vector2i = MIN_BRUSH_CELL_SIZE * 100
const BRUSH_COLOR: Color = Color(0,0,0,.5)

var type: int = NONE 
var terrain_type_color: TerrainTypeColor = TerrainTypeColor.create_empty()
var terrain_mod_color: TerrainModColor = TerrainModColor.create_empty()
var speed_mph_color: SpeedMPHColor = SpeedMPHColor.create_empty()
var direction_color: DirectionColor = DirectionColor.create_empty()

var brush_cell_size: Vector2i = DEFAULT_BRUSH_SIZE
var brush_color: Color = BRUSH_COLOR

static func create_empty() -> DrawStruct:
	return DrawStruct.new()
	
func set_brush_size(req_brush_cell_size: Vector2i) -> void:
	brush_cell_size = clamp(req_brush_cell_size, MIN_BRUSH_CELL_SIZE, MAX_BRUSH_CELL_SIZE)
	
func get_px_size() -> Vector2i:
	return brush_cell_size * GameData.world_px_per_cell
	

		
