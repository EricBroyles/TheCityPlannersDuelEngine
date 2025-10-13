extends Node2D
class_name GameboardBuilder

@onready var gameboard: Gameboard = %Gameboard
@onready var body_sprite: Sprite2D = %BodySprite
@onready var body_mesh_instance: MeshInstance2D = %BodyMeshInstance

var _w: int = EngineData.CELL_WIDTH_PX
var cell: GameboardCell = GameboardCell.create_empty()
var rect_region: Vector2 = Vector2(_w,_w)
var inputs_per_second: int = 30
var second_progress: float = 0.0
var inputs_count: int = 0

func _ready() -> void:
	body_sprite.centered = false
	
func _process(delta: float) -> void:
	second_progress += delta
	if second_progress >= 1.0: 
		second_progress = 0.0
		inputs_count = 0
	if not cell.is_empty():
		move_builder(EngineData.mouse_position)
		
func _input(_event: InputEvent) -> void:
	if inputs_count > inputs_per_second: return
	var did_input: bool = true
	
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R):
		clear()
		cell.terrain = cell.ROAD
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_W):
		clear()
		cell.terrain = cell.WALKWAY
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_B):
		clear()
		cell.terrain = cell.BUILDING
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_P):
		clear()
		cell.terrain = cell.PARKING
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_A):
		clear()
		cell.terrain = cell.BARRIER
		draw_builder()
	
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_J):
		clear()
		cell.junction = cell.STOP_JUNCTION
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_L):
		clear()
		cell.lane_divider = cell.LANE_DIVIDER
		draw_builder()
		
	elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_V):
		clear()
		print("VELOCITY NOT IMPLEMENTED YET")
		draw_builder()
		
	elif Input.is_key_pressed(KEY_TAB):
		increment(1)
		draw_builder()
	
	elif Input.is_key_pressed(KEY_BACKSPACE):
		increment(-1)
		draw_builder()
		
	#elif Input.is_key_pressed(KEY_R):
		#rotate_cw()
		#draw_builder()
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		gameboard_add()
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gameboard_remove()
	
	elif Input.is_key_pressed(KEY_ESCAPE):
		clear()
		
	else: did_input = false
	if did_input: inputs_count += 1
		
func clear() -> void:
	cell = GameboardCell.create_empty()
	rect_region = Vector2(_w,_w)
	body_sprite.texture = null
	body_mesh_instance.mesh = ArrayMesh.new()
	
func move_builder(req_center_point: Vector2) -> void:
	var grid_locked_top_left_pos: Vector2 = round((req_center_point - rect_region/2)/ EngineData.CELL_WIDTH_PX) * EngineData.CELL_WIDTH_PX
	self.position = grid_locked_top_left_pos 
	
func increment(by: int) -> void:
	if cell.junction == cell.NONE:
		scale_rect_region_radially(by)
	else: cell.increment_junction(by)
	
func gameboard_add() -> void:
	pass
	
func gameboard_remove() -> void:
	pass
	
func draw_builder() -> void:
	#matrix.fill_with(cell)
	body_mesh_instance.mesh = get_rect_region_array_mesh()
	#body_sprite.texture = matrix.get_image_texture()
	pass
	

func scale_rect_region_radially(by: int):
	rect_region = rect_region + Vector2(2 * by, 2 * by) * _w
	
func get_rect_region_array_mesh() -> ArrayMesh:
	var mesh: ArrayMesh = ArrayMesh.new()
	var cell_color: Color = cell.get_cell_color()
	var vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(rect_region.x, 0),
		Vector2(rect_region.x, rect_region.y),
		Vector2(0, rect_region.y)
	])
	var colors = PackedColorArray([
		cell_color, cell_color, cell_color, cell_color
	])
	var indices = PackedInt32Array([0, 1, 2, 0, 2, 3])
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh






#extends Node2D
#class_name GameboardBuilder
#
#@onready var gameboard: Gameboard = %Gameboard
#@onready var body_mesh: MeshInstance2D = %BodyMesh
#
#
## we have multi cell and single cell variations, incrememnt size raidally, draw mesh, or dont draw the mesh
#
#
#
#
#
#var cell_to_build: GameboardCell = GameboardCell.create_empty()
#var occupied_gb_indexes: Array[Vector2] = []
#
#var min_lvl: int = 1
#var road_max_lvl: int = 6
#var walkway_max_lvl: int = 3
#var building_max_lvl: int = 3
#var parking_max_lvl: int = 3
#var barrier_max_lvl: int = 1
#var junction_max_lvl: int = 4
#var land_divider_max_lvl: int = 1
#var velocity_max_lvl: int = 20
#var lvl: int = 1
#
#func _process(_delta: float) -> void:
	#if not cell_to_build.is_empty():
		#move_builder(EngineData.mouse_position)
#
#func _input(_event: InputEvent) -> void:
#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R):
		#clear()
		#cell_to_build.set_terrain(GameboardCell.TERRAINS.ROAD)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_W):
		#clear()
		#cell_to_build.set_terrain(GameboardCell.TERRAINS.WALKWAY)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_B):
		#clear()
		#cell_to_build.set_terrain(GameboardCell.TERRAINS.BUILDING)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_P):
		#clear()
		#cell_to_build.set_terrain(GameboardCell.TERRAINS.PARKING)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_A):
		#clear()
		#cell_to_build.set_terrain(GameboardCell.TERRAINS.BARRIER)
		#draw_builder()
	#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_J):
		#clear()
		#cell_to_build.set_junction(GameboardCell.JUNCTIONS.STOP)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_L):
		#clear()
		#cell_to_build.set_land_divider(true)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_V):
		#clear()
		#cell_to_build.set_junction(GameboardCell.JUNCTIONS.STOP)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_TAB):
		#increment_lvl(1)
		#draw_builder()
	#
	#if Input.is_key_pressed(KEY_BACKSPACE):
		#increment_lvl(-1)
		#draw_builder()
		#
	#if Input.is_key_pressed(KEY_R):
		#rotate_cw()
		#draw_builder()
		#
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#gameboard_add()
		#
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#gameboard_remove()
	#
	#if Input.is_key_pressed(KEY_ESCAPE):
		#clear()
		#
#func clear() -> void:
	#cell_to_build = GameboardCell.create_empty()
	#lvl = min_lvl
	#body_mesh.mesh = ArrayMesh.new()
	#occupied_gb_indexes = []
	#
#func increment_lvl(amount: int) -> void:
	###TO BE CONTINUED.
	#
	#if cell_to_build.is_empty(): return
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.ROAD:
		#lvl = clamp(lvl+amount, min_lvl, road_max_lvl)
	#elif cell_to_build.terrain_status == GameboardCell.TERRAINS.WALKWAY:
		#lvl = clamp(lvl+amount, min_lvl, walkway_max_lvl)
	#elif cell_to_build.terrain_status == GameboardCell.TERRAINS.BUILDING:
		#lvl = clamp(lvl+amount, min_lvl, building_max_lvl)
	#elif cell_to_build.terrain_status == GameboardCell.TERRAINS.PARKING:
		#lvl = clamp(lvl+amount, min_lvl, parking_max_lvl)
	#elif cell_to_build.terrain_status == GameboardCell.TERRAINS.BARRIER:
		#lvl = clamp(lvl+amount, min_lvl, barrier_max_lvl)
	#elif cell_to_build.junction_status != GameboardCell.JUNCTIONS.NONE:
		#lvl = clamp(lvl+amount, min_lvl, junction_max_lvl)
		#match lvl:
			#1:
				#cell_to_build.set_junction(GameboardCell.JUNCTIONS.STOP)
			#2:
				#cell_to_build.set_junction(GameboardCell.JUNCTIONS.LVL1)
			#3:
				#cell_to_build.set_junction(GameboardCell.JUNCTIONS.LVL2)
			#4: 
				#cell_to_build.set_junction(GameboardCell.JUNCTIONS.LVL3)
	#elif cell_to_build.has_lane_divider:
		#lvl = clamp(lvl+amount, min_lvl, land_divider_max_lvl)
	#elif not cell_to_build.velocity.is_empty():
		#lvl = clamp(lvl+amount, min_lvl, velocity_max_lvl)
		#cell_to_build.velocity.speed_mph += (5 * amount)
	#
#func rotate_cw() -> void:
	##skip for know
	#pass
#
#func move_builder(req_pos: Vector2):
	#var new_pos: Vector2 = round(req_pos / EngineData.CELL_WIDTH_PX) * EngineData.CELL_WIDTH_PX
	#position = new_pos
	#
#func gameboard_add() -> void:
	#for index in occupied_gb_indexes:
		#gameboard.add_cell_at_index(cell_to_build, index)
	#
#func gameboard_remove() -> void:
	#for index in occupied_gb_indexes:
		#gameboard.remove_cell_at_index(cell_to_build, index)
	#
#func draw_builder() -> void:
	#var pts: PackedVector2Array = get_mesh_points()
	#body_mesh.mesh = create_polygon_mesh(pts)
	#body_mesh.modulate = get_mesh_color()
	#
	##update this
	#occupied_gb_indexes
	#
#func get_gb_indexes_from_mesh_pts(mesh_pts: PackedVector2Array) -> Array[Vector2]:
	##the mesh is a rectangle composed of cells of widht EngineData.CELL_WIDTH_PX
	##convert the mesh points into a list of all indexes on a grid of cells with EngineData.CELL_WIDTH_PX (negetive indexs are included)
	#
	#var w: int = EngineData.CELL_WIDTH_PX
	#
	#
	#
#func get_mesh_points() -> PackedVector2Array:
	#var w: float = EngineData.CELL_WIDTH_PX
	#if cell_to_build.is_junction():
		#return PackedVector2Array([
				#Vector2(0,0), 
				#Vector2(w, 0), 
				#Vector2(1,1) * w, 
				#Vector2(0,w)]) #0,0 is at the top left corner
				#
	#return PackedVector2Array([
		#Vector2(0,0) * lvl, 
		#Vector2(w, 0) * lvl, 
		#Vector2(1,1) * w * lvl, 
		#Vector2(0,w) * lvl]) #0,0 is at the top left corner
	#
#
#func get_mesh_color() -> Color:
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.ROAD: return EngineData.road_color
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.WALKWAY: return EngineData.walkway_color
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.PARKING: return EngineData.parking_color
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.BUILDING: return EngineData.building_color
	#if cell_to_build.terrain_status == GameboardCell.TERRAINS.BARRIER: return EngineData.barrier_color
	#if cell_to_build.has_lane_divider: return EngineData.lane_divider_color
	#if cell_to_build.junction_status: 
		#var jc: Color = EngineData.junction_color
		#jc.a = jc.a / lvl
		#return jc
	#push_error("The thing you are getting a mesh color for does not have a color. WHITE ASSIGNED")
	#return Color.WHITE
	#
#func create_polygon_mesh(points: PackedVector2Array) -> ArrayMesh:
	#var mesh: ArrayMesh = ArrayMesh.new()
	#var indices: PackedInt32Array = PackedInt32Array(Geometry2D.triangulate_polygon(points))
	#var arrays: Array = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = points
	#arrays[Mesh.ARRAY_INDEX] = indices
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#return mesh
	#
##func is_builder_drawn_as_mesh() -> bool:
	###draw with mesh for Road, Walway, parking, building, barrier, lane_divider
	##if cell_to_build.terrain_status != GameboardCell.TERRAINS.NONE or cell_to_build.has_lane_divider:
		##return true
	##return false
	#
	#
	#
