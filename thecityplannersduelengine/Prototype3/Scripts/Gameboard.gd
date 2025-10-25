extends Node2D
class_name Gameboard

@onready var ViewSprite: Sprite2D = %ViewSprite

const GB_CELL_ROWS: int = 1000
const GB_CELL_COLS: int = 1000
const ZIN_PX_PER_CELL: int = 12*4
const Z1_PX_PER_CELL: int = 12
const ZOUT_PX_PER_CELL: int = int(12/4.0)

var time_delta: float
var move_speed: float = 400.0 #500.0 / 10
var zoom_speed: float = 1.0 #increment px_per_cell

var px_per_cell: int = Z1_PX_PER_CELL
var screen_position_on_gb: Vector2  = Vector2(0,0) #top left screen pos in gb coordinates

var screen_cells_img: Image
var screen_cells_tex: ImageTexture
var screen_velocity_img: Image
var screen_velocity_tex: ImageTexture
var screen_view_img: Image
var screen_view_tex: ImageTexture

var matrix: GameboardMatrix

func _ready() -> void:
	
	init_matrix()
	setup_screen()
	handle_screen()

func _process(delta: float) -> void:
	time_delta = delta
	var m: bool = handle_move()
	var z: bool = handle_zoom()
	var a: bool = handle_screen_adjustment()
	if m or z or a:
		handle_screen()

func setup_screen() -> void:
	set_screen_data( get_screen_cell_size() )
	set_screen_view( get_screen_size() )
	init_view_sprite() #must go after set_screen_data and set_screen_view

func handle_screen() -> void:
	var copy_at_rect: Rect2i = Rect2i(get_screen_cell_idx(), get_screen_cell_size())
	var paste_at_idx: Vector2i = Vector2i(0,0)
	screen_cells_img.blit_rect(matrix.cells_img, copy_at_rect, paste_at_idx)
	screen_cells_tex.update(screen_cells_img)
	
func handle_move() -> bool:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move camera north"): dir += Vector2(0, -1)
	elif Input.is_action_pressed("move camera south"): dir += Vector2(0, +1)
	elif Input.is_action_pressed("move camera west"):  dir += Vector2(-1, 0)
	elif Input.is_action_pressed("move camera east"):  dir += Vector2(+1, 0)
	else: return false
	var did_change: bool = set_screen_position_on_gb(dir.normalized() * move_speed * time_delta)
	return did_change
	
func handle_zoom() -> bool:
	var dir: int = 0
	if Input.is_action_just_released("zoom camera in"):    dir = +1
	elif Input.is_action_just_released("zoom camera out"): dir = -1
	else: return false
	var old_screen_cell_idx: Vector2i = get_screen_cell_idx()
	var old_screen_cell_size: Vector2i = get_screen_cell_size()
	var old_screen_center_cell_idx: Vector2i = (old_screen_cell_idx + old_screen_cell_size/2)
	var did_change: bool = set_px_per_cell(px_per_cell + int(dir * zoom_speed))
	if did_change:
		var curr_screen_cell_idx: Vector2i = get_screen_cell_idx()
		var curr_screen_cell_size: Vector2i = get_screen_cell_size()
		var curr_screen_center_cell_idx: Vector2i = (curr_screen_cell_idx + curr_screen_cell_size/2)  
		var cell_shift: Vector2 = old_screen_center_cell_idx - curr_screen_center_cell_idx
		set_screen_position_on_gb(cell_shift * px_per_cell)
		set_screen_data(curr_screen_cell_size)
		set_view_sprite_material()
	return did_change
	
func handle_screen_adjustment() -> bool:
	var screen_size: Vector2i = get_screen_size()
	var old_screen_size: Vector2i = Vector2i(screen_view_img.get_width(), screen_view_img.get_height())
	if screen_size == old_screen_size: return false
	setup_screen()
	return true

func init_matrix() -> void:
	matrix = GameboardMatrix.create_empty(GB_CELL_COLS, GB_CELL_ROWS)
	
func init_view_sprite() -> void:
	set_view_sprite_material()
	ViewSprite.texture = screen_view_tex #yes it should be the screen texture
	ViewSprite.centered = false

func set_view_sprite_material() -> void:
	ViewSprite.material.set_shader_parameter("data_tex", screen_cells_tex) #yes it should be the data texture

func set_screen_data(screen_cell_size: Vector2i) -> void:
	screen_cells_img = Image.create_empty(screen_cell_size.x, screen_cell_size.y, false, Image.FORMAT_RGBA8)
	screen_cells_tex = ImageTexture.create_from_image(screen_cells_img)

func set_screen_view(screen_size: Vector2i) -> void:
	screen_view_img = Image.create_empty(screen_size.x, screen_size.y, false, Image.FORMAT_RGBA8)
	screen_view_tex = ImageTexture.create_from_image(screen_view_img)

func set_screen_position_on_gb(position_delta: Vector2) -> bool:
	var old_pos: Vector2 = screen_position_on_gb
	var ss: Vector2i = get_screen_size()
	screen_position_on_gb += position_delta
	screen_position_on_gb.x = clamp(screen_position_on_gb.x, 0, GB_CELL_COLS * px_per_cell - ss.x)
	screen_position_on_gb.y = clamp(screen_position_on_gb.y, 0, GB_CELL_ROWS * px_per_cell - ss.y)
	if screen_position_on_gb == old_pos: return false
	return true
	
func set_px_per_cell(new_px_per_cell: int) -> bool:
	var old_px_per_cell: int = px_per_cell
	px_per_cell = clamp(new_px_per_cell, ZOUT_PX_PER_CELL, ZIN_PX_PER_CELL)
	if px_per_cell == old_px_per_cell: return false
	return true
	
func get_screen_size() -> Vector2i:
	return get_viewport_rect().size
	
func get_screen_cell_size() -> Vector2i:
	return ceil(get_screen_size() / px_per_cell)
	
func get_screen_cell_idx() -> Vector2i:
	return calc_screen_cell_idx(screen_position_on_gb)

func calc_screen_cell_idx(screen_pos: Vector2) -> Vector2i:
	return screen_pos / px_per_cell
	
func get_mouse_cell_idx() -> Vector2i:
	var mouse_position: Vector2 = get_global_mouse_position()
	return calc_screen_cell_idx(screen_position_on_gb + mouse_position)






# Gameboard
#	add_cell_at_rect_region(cell, rect_region): updates the GameboardMatrix, and the GameboardView
#	remove_cell_at_rect_region(cell, rect_region
# 	handles the move and the zoom and stores/updates the visual data (world, screen, data) 
# GameboardMatrix: stores all data for the game

#Builder: Node with a meshinstance 2D attached
# activate and deactivate. 
# pass in a cell and a region
# command it to increase the region or decrease the region
# draws a mesh centered on the mouse with some builder color


#set all of these
#var mouse_position: Vector2
#var mouse_cell_idx: Vector2i
#
### Gameboard
#var gb_position: Vector2
#var gb_cell_idx: Vector2i
#var gb_px_per_cell: int
