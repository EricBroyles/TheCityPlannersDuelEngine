extends Node
class_name GameboardBuilder

enum OPTIONS {
	NONE,
	DRAW_ROADS,
	DRAW_WALKWAYS,
	DRAW_DIRECTIONS,
	DRAW_SPEED,
	DRAW_BARRIERS,
	DRAW_LANES,
	DRAW_PARKING,
	DRAW_BUILDINGS,
	DRAW_JUNCTIONS,
	DRAW_INGRESS,
	DRAW_EGRESS,
}

@onready var mesh_instance: MeshInstance2D = %BuilderMesh

#Note: each of these shapes has the 0,0 that is at the top left corner of a cell
const w: int = EngineData.GB_CELL_WIDTH
var size_levels: Dictionary = {
	1: [Vector2(w,w)/2, Vector2(w,w), Vector2(0, w)], #level 1 triangle
	2: [Vector2(0,0), Vector2(w,w), Vector2(0, w)], #level 2 right triangle
	3: [Vector2(0,0), Vector2(0, w), Vector2(w,w), Vector2(w,0)] #level 3 square
}

var size_levels_rot45: Dictionary = {
	3: [Vector2(w,0), Vector2(0, w), Vector2(w,2*w), Vector2(2*w,w)] #level 3 rotated 45 square 
}

var orientation_degrees: int = 0
var size_level_min: int = 1
var size_level_max: int = 30
var active_size_level: int = 1
var active_option: int = OPTIONS.NONE

func _ready() -> void:
	for n in range(4, size_level_max+1):
		size_levels[n] = [Vector2(0,0), Vector2(0,w), Vector2(w+(n-3)*w,w),Vector2(w+(n-3)*w,0)]
	for n in range(4, size_level_max+1):
		size_levels_rot45[n] = [
			Vector2(w,0), 
			Vector2(0, w), 
			Vector2(w,2*w) + Vector2(1,1)*(n-3)*w, 
			Vector2(2*w,w) + Vector2(1,1)*(n-3)*w
		]
	
func _process(_delta: float) -> void:
	if active_option != OPTIONS.NONE:
		move_mesh(EngineData.mouse_position)

func _input(event: InputEvent) -> void:
	## OPTIONS SELECT
	if event.is_action_released("road")  and Input.is_key_pressed(KEY_CTRL):
		clear()
		active_option = OPTIONS.DRAW_ROADS
		color_mesh(EngineData.ROAD_COLOR)
		draw_mesh()
		
	elif event.is_action_released("walkway"):
		pass
	elif event.is_action_released("place on gameboard"):
		pass
	elif event.is_action_released("remove from gameboard"):
		pass
	
	## MISC
	elif event.is_action_released("clear"):
		clear()
	elif event.is_action_released("help"):
		display_help()
	
	
	## OPTION MODIFIER
	if active_option != OPTIONS.NONE:
		if event.is_action_released("increase"):
			increment_draw_mesh(1)
		elif event.is_action_released("decrease"):
			increment_draw_mesh(-1)
		elif event.is_action_released("rotate") and not Input.is_key_pressed(KEY_CTRL):
			rotate_draw_mesh()
			
func clear() -> void:
	active_option = OPTIONS.NONE
	active_size_level = 1
	orientation_degrees = 0
	mesh_instance.rotation = 0
	color_mesh(Color.WHITE)
	mesh_instance.mesh = ArrayMesh.new()
	
func color_mesh(color: Color) -> void:
	mesh_instance.modulate = color
	
func rotate_draw_mesh() -> void:
	if active_size_level == 1 or active_size_level == 2:
		orientation_degrees += 90 
	else:
		orientation_degrees += 45
	orientation_degrees = orientation_degrees % 360 # Wrap to [0, 360)
	draw_mesh()
	
func increment_draw_mesh(incr: int) -> void:
	active_size_level = clamp(active_size_level + incr, size_level_min, size_level_max)
	if active_size_level == 1 or active_size_level == 2:
		#snap to nearest 90 degree
		orientation_degrees = int(round(orientation_degrees / 90.0) * 90.0)
		orientation_degrees = orientation_degrees % 360 
	draw_mesh()
	
func move_mesh(req_mesh_origin_pos: Vector2) -> void:
	var new_pos: Vector2 = round(req_mesh_origin_pos / EngineData.GB_CELL_WIDTH) * EngineData.GB_CELL_WIDTH
	mesh_instance.position = new_pos
	
func draw_mesh() -> void:
	var pts: PackedVector2Array
	var angle: float = deg_to_rad(orientation_degrees)
	if orientation_degrees % 90 == 0:
		pts = size_levels.get(active_size_level, PackedVector2Array())
	else:
		pts = size_levels_rot45.get(active_size_level, PackedVector2Array())
		angle -= deg_to_rad(45)
	if pts.is_empty():
		push_error("No polygon for level %d" % active_size_level)
		return
	
	var rot: Transform2D = Transform2D(angle, Vector2.ZERO)  # rotation matrix around (0,0)
	var rotated_pts: PackedVector2Array = PackedVector2Array()
	for p in pts:
		rotated_pts.append(rot * p)  
	
	mesh_instance.mesh = create_polygon_mesh(rotated_pts)
	
func create_polygon_mesh(points: PackedVector2Array) -> ArrayMesh:
	var mesh: ArrayMesh = ArrayMesh.new()
	var indices: PackedInt32Array = PackedInt32Array(Geometry2D.triangulate_polygon(points))
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = points
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh
	
func display_help() -> void:
	print("--- Custom Input Actions ---")
	for action_name in Utils.get_custom_input_action_names():
		var events := InputMap.action_get_events(action_name)
		var event_texts: Array[String] = []
		for ev in events:
			event_texts.append(ev.as_text())
		print("%s --> %s" % [action_name, ", ".join(event_texts)])
	print("--- End of List ---")
	
	
