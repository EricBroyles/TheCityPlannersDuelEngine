class_name DrawStruct

enum  {NONE, ERASE, DRAW}

const MIN_BRUSH_CELL_SIZE: Vector2i = Vector2i.ONE
const MAX_BRUSH_CELL_SIZE: Vector2i = MIN_BRUSH_CELL_SIZE * 50
const BRUSH_COLOR: Color = Color(0,0,0,.5)

var type: int = NONE 
var terrain_type_color: TerrainTypeColor = TerrainTypeColor.create_empty()
var terrain_mod_color: TerrainModColor = TerrainModColor.create_empty()
var speed_mph_color: SpeedMPHColor = SpeedMPHColor.create_empty()
var direction_color: DirectionColor = DirectionColor.create_empty()

var brush_cell_size: Vector2i = MIN_BRUSH_CELL_SIZE
var brush_color: Color = BRUSH_COLOR

static func create_empty() -> DrawStruct:
	return DrawStruct.new()

static func create(cmd_tokens: PackedStringArray) -> DrawStruct:
	#ex: ["road", "brush(10, 10)"]
	#ex: ["speed_mph(100)", "direction(any)", "brush(10, 10)"]
	#ex: ["erase", "brush(10,10)"]
	# NOTE: (10,10) or (10, 10) or ( 10,  10) etc. are valid
	var draw_struct: DrawStruct = DrawStruct.create_empty()
	var erase_found: bool = false
	var brush_found: bool = false
	for token in cmd_tokens:
		if token.contains("erase"):
			draw_struct.type = ERASE
			erase_found = true
		elif token.contains("brush"):
			var str_arr: PackedStringArray = Utils.group_to_string_array(token.replace("brush", ""))
			var w: int = clamp(str_arr[0].to_int(), MIN_BRUSH_CELL_SIZE.x, MAX_BRUSH_CELL_SIZE.x)
			var h: int = clamp(str_arr[1].to_int(), MIN_BRUSH_CELL_SIZE.y, MAX_BRUSH_CELL_SIZE.y)
			draw_struct.brush_cell_size = Vector2i(w, h)
			brush_found = true
		elif token.contains("speed_mph"):
			var str_arr: PackedStringArray = Utils.group_to_string_array(token.replace("speed_mph", ""))
			draw_struct.speed_mph_color = SpeedMPHColor.create(str_arr[0].to_int())
		elif token.contains("direction"):
			var str_arr: PackedStringArray = Utils.group_to_string_array(token.replace("direction", ""))
			draw_struct.direction_color = DirectionColor.string_create(str_arr[0])
		else:
			match token: 
				"road": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.ROAD)
				"walkway": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.WALKWAY)
				"crosswalk": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.WALKWAY)
				"parking": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.PARKING)
				"building": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.BUILDING)
				"barrier": draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.BARRIER)
				
				"lane_divider": draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.LANE_DIVIDER)
				"junction_stop": draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION_STOP)
				"junction1": draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION1)
				"junction2": draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION2)
				"junction3": draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION3)
	if not brush_found: draw_struct = DrawStruct.create_empty()
	if not erase_found: draw_struct.type = DRAW
	return draw_struct

func get_px_size() -> Vector2i:
	return brush_cell_size * GameData.world_px_per_cell
	

		
