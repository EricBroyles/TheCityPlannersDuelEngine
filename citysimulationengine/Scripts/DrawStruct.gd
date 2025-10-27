class_name DrawStruct

enum DRAW_TYPE {NONE, ERASE, TERRAIN, VELOCITY}

const MIN_BRUSH_CELL_SIZE: Vector2i = Vector2i.ONE
const MAX_BRUSH_CELL_SIZE: Vector2i = MIN_BRUSH_CELL_SIZE * 50
const BRUSH_COLOR: Color = Color(0,0,0,.5)

var draw_type: int = DRAW_TYPE.NONE 
var terrain_color: TerrainColor = TerrainColor.create_empty()
var velocity_color: VelocityColor = VelocityColor.create_empty()
var brush_cell_size: Vector2i = MIN_BRUSH_CELL_SIZE
var brush_color: Color = BRUSH_COLOR

static func create_empty() -> DrawStruct:
	return DrawStruct.new()

static func create(cmd_tokens: PackedStringArray) -> DrawStruct:
	#ex: ["road", "brush(10, 10)"]
	#ex: ["velocity(100, ne)", "brush(10, 10)"]
	#ex: ["erase", "brush(10,10)"]
	# NOTE: (10,10) or (10, 10) or ( 10,  10) etc. are valid
	var draw_struct: DrawStruct = DrawStruct.new()
	if cmd_tokens.has("erase"): draw_struct.draw_type = DRAW_TYPE.ERASE
	for t in cmd_tokens:
		if t.contains("velocity"):
			draw_struct.draw_type = DRAW_TYPE.VELOCITY
			draw_struct.velocity_color = Utils.cmd_to_velocity_color(t)
		elif t.contains("brush"):
			#brush(10,10)
			var str_arr: PackedStringArray = Utils.group_to_string_array(t.replace("brush", ""))
			var w: int = clamp(str_arr[0].to_int(), MIN_BRUSH_CELL_SIZE.x, MAX_BRUSH_CELL_SIZE.x)
			var h: int = clamp(str_arr[1].to_int(), MIN_BRUSH_CELL_SIZE.y, MAX_BRUSH_CELL_SIZE.y)
			draw_struct.brush_cell_size = Vector2i(w, h)
		else:
			draw_struct.draw_type = DRAW_TYPE.TERRAIN
			match t:
				"road": draw_struct.terrain_color = TerrainColor.create(TerrainColor.ROAD)
				"walkway": draw_struct.terrain_color = TerrainColor.create(TerrainColor.WALKWAY)
				"barrier": draw_struct.terrain_color = TerrainColor.create(TerrainColor.BARRIER)
				"lane_divider": draw_struct.terrain_color = TerrainColor.create(TerrainColor.LANE_DIVIDER)
				"junction_stop": draw_struct.terrain_color = TerrainColor.create(TerrainColor.JUNCTION_STOP)
				"junction1": draw_struct.terrain_color = TerrainColor.create(TerrainColor.JUNCTION1)
				"junction2": draw_struct.terrain_color = TerrainColor.create(TerrainColor.JUNCTION2)
				"junction3": draw_struct.terrain_color = TerrainColor.create(TerrainColor.JUNCTION3)
				"building": draw_struct.terrain_color = TerrainColor.create(TerrainColor.BUILDING)
				"parking": draw_struct.terrain_color = TerrainColor.create(TerrainColor.PARKING)
	return draw_struct	
	
func get_px_size() -> Vector2i:
	return brush_cell_size * GameData.world_px_per_cell

		
