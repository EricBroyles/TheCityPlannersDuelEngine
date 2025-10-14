extends Node2D
class_name GameboardBuilder

@onready var gameboard: Gameboard = %Gameboard
@onready var text_input: TextEdit = %TextInput
@onready var body_sprite: Sprite2D = %BodySprite
@onready var body_mesh_instance: MeshInstance2D = %BodyMeshInstance

const _w: int = EngineData.CELL_WIDTH_PX
const MIN_RECT_REGION: Vector2 = Vector2(_w,_w)
const MAX_RECT_REGION: Vector2 = MIN_RECT_REGION * 50
var cell: GameboardCell = GameboardCell.create_empty()
var rect_region: Vector2 = MIN_RECT_REGION

func _ready() -> void:
	body_sprite.centered = false

func _process(_delta: float) -> void:
	if not cell.is_empty():
		move_builder(EngineData.mouse_cell_position)
		
func _input(_event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_ENTER):
		cell.override(
			GameboardCell.string_to_contents(text_input.text),
			GameboardCell.string_to_velocity(text_input.text)
		)
		clear_text_input()
		draw_builder()
	
func _unhandled_input(_event: InputEvent) -> void:

	if Input.is_key_pressed(KEY_TAB):
		increment(1)
		draw_builder()
	
	elif Input.is_key_pressed(KEY_BACKSPACE):
		increment(-1)
		draw_builder()
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		gameboard_add()
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gameboard_remove()
	
	elif Input.is_key_pressed(KEY_ESCAPE):
		clear()

func clear_text_input() -> void:
	text_input.release_focus()
	text_input.text = ""

func clear() -> void:
	clear_text_input()
	cell = GameboardCell.create_empty()
	rect_region = MIN_RECT_REGION
	body_sprite.texture = null
	body_mesh_instance.mesh = ArrayMesh.new()
	
func move_builder(req_center_point: Vector2) -> void:
	var grid_locked_top_left_pos: Vector2 = round((req_center_point - rect_region/2) / _w) * _w
	self.position = grid_locked_top_left_pos 
	
func increment(by: int) -> void:
	if not cell.is_junction():
		scale_rect_region_radially(by)
	
func gameboard_add() -> void:
	pass
	
func gameboard_remove() -> void:
	pass
	
func draw_builder() -> void:
	body_mesh_instance.mesh = get_rect_region_array_mesh()
	#body_sprite.texture = matrix.get_image_texture()

	
func scale_rect_region_radially(by: int):
	rect_region = clamp(rect_region + Vector2(2,2)*by*_w, MIN_RECT_REGION, MAX_RECT_REGION)
	print(rect_region)
	
func get_rect_region_array_mesh() -> ArrayMesh:
	var mesh: ArrayMesh = ArrayMesh.new()
	var cell_color: Color = cell.get_color()
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
	


#
#var _w: int = EngineData.CELL_WIDTH_PX
#var cell: GameboardCell = GameboardCell.create_empty()
#var rect_region: Vector2 = Vector2(_w,_w)
#var inputs_per_second: int = 30
#var second_progress: float = 0.0
#var inputs_count: int = 0
#
#func _ready() -> void:
	#body_sprite.centered = false
	#
#func _process(delta: float) -> void:
	#second_progress += delta
	#if second_progress >= 1.0: 
		#second_progress = 0.0
		#inputs_count = 0
	#if not cell.is_empty():
		#move_builder(EngineData.mouse_position)
		#
#func _input(_event: InputEvent) -> void:
	#if inputs_count > inputs_per_second: return
	#var did_input: bool = true
	#
	#if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R):
		#clear()
		#cell.terrain = cell.ROAD
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_W):
		#clear()
		#cell.terrain = cell.WALKWAY
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_B):
		#clear()
		#cell.terrain = cell.BUILDING
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_P):
		#clear()
		#cell.terrain = cell.PARKING
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_A):
		#clear()
		#cell.terrain = cell.BARRIER
		#draw_builder()
	#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_J):
		#clear()
		#cell.junction = cell.STOP_JUNCTION
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_L):
		#clear()
		#cell.lane_divider = cell.LANE_DIVIDER
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_V):
		#clear()
		#print("VELOCITY NOT IMPLEMENTED YET")
		#draw_builder()
		#
	#elif Input.is_key_pressed(KEY_TAB):
		#increment(1)
		#draw_builder()
	#
	#elif Input.is_key_pressed(KEY_BACKSPACE):
		#increment(-1)
		#draw_builder()
		#
	##elif Input.is_key_pressed(KEY_R):
		##rotate_cw()
		##draw_builder()
		#
	#elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#gameboard_add()
		#
	#elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#gameboard_remove()
	#
	#elif Input.is_key_pressed(KEY_ESCAPE):
		#clear()
		#
	#else: did_input = false
	#if did_input: inputs_count += 1
		#
#func clear() -> void:
	#cell = GameboardCell.create_empty()
	#rect_region = Vector2(_w,_w)
	#body_sprite.texture = null
	#body_mesh_instance.mesh = ArrayMesh.new()
	#
#func move_builder(req_center_point: Vector2) -> void:
	#var grid_locked_top_left_pos: Vector2 = round((req_center_point - rect_region/2)/ EngineData.CELL_WIDTH_PX) * EngineData.CELL_WIDTH_PX
	#self.position = grid_locked_top_left_pos 
	#
#func increment(by: int) -> void:
	#if cell.junction == cell.NONE:
		#scale_rect_region_radially(by)
	#else: cell.increment_junction(by)
	#
#func gameboard_add() -> void:
	#pass
	#
#func gameboard_remove() -> void:
	#pass
	#
#func draw_builder() -> void:
	##matrix.fill_with(cell)
	#body_mesh_instance.mesh = get_rect_region_array_mesh()
	##body_sprite.texture = matrix.get_image_texture()
	#pass
	#
#
#func scale_rect_region_radially(by: int):
	#rect_region = rect_region + Vector2(2 * by, 2 * by) * _w
	#
#func get_rect_region_array_mesh() -> ArrayMesh:
	#var mesh: ArrayMesh = ArrayMesh.new()
	#var cell_color: Color = cell.get_cell_color()
	#var vertices = PackedVector2Array([
		#Vector2(0, 0),
		#Vector2(rect_region.x, 0),
		#Vector2(rect_region.x, rect_region.y),
		#Vector2(0, rect_region.y)
	#])
	#var colors = PackedColorArray([
		#cell_color, cell_color, cell_color, cell_color
	#])
	#var indices = PackedInt32Array([0, 1, 2, 0, 2, 3])
	#var arrays: Array = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#arrays[Mesh.ARRAY_COLOR] = colors
	#arrays[Mesh.ARRAY_INDEX] = indices
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#return mesh
