extends CanvasLayer
class_name World

@onready var background: TextureRect = %Background
@onready var terrain_type: TextureRect = %TerrainType
@onready var terrain_mod: TextureRect = %TerrainMod
@onready var speed_mph: TextureRect = %SpeedMPH
@onready var direction: TextureRect = %Direction

const CELL_ROWS: int = 1000
const CELL_COLS: int = 1000
const ZIN_PX_PER_CELL: int = 12*4
const Z1_PX_PER_CELL: int = 12
const ZOUT_PX_PER_CELL: int = int(12/4.0)

var px_per_cell: int = Z1_PX_PER_CELL
var px: Vector2i = Vector2i(0,0) #top left px position

var terrain_type_img: Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, TerrainTypeColor.IMAGE_FORMAT)
var terrain_mod_img : Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, TerrainModColor.IMAGE_FORMAT)
var speed_mph_img   : Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, SpeedMPHColor.IMAGE_FORMAT)
var direction_img   : Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, DirectionColor.IMAGE_FORMAT)

var terrain_type_tex: ImageTexture = ImageTexture.create_from_image(terrain_type_img)
var terrain_mod_tex : ImageTexture = ImageTexture.create_from_image(terrain_mod_img)
var speed_mph_tex   : ImageTexture = ImageTexture.create_from_image(speed_mph_img)
var direction_tex   : ImageTexture = ImageTexture.create_from_image(direction_img)




func _ready() -> void:
	
	background.material.set_shader_parameter("world_cell_size", Vector2i(CELL_COLS, CELL_ROWS))
	terrain_type.material.set_shader_parameter("color_map", TerrainTypeColor.get_color_map())
	
	terrain_type.material.set_shader_parameter("world_data_tex", terrain_type_tex)
	terrain_mod.material.set_shader_parameter("world_data_tex", terrain_mod_tex)
	speed_mph.material.set_shader_parameter("world_data_tex", speed_mph_tex)

	update_view()
	
func _process(_delta: float) -> void:
	GameData.world_px_per_cell = px_per_cell
	GameData.world_px = px
	GameData.mouse_screen_float_px = get_mouse_screen_float_px()
	GameData.mouse_screen_px = get_mouse_screen_px()
	GameData.mouse_world_px = screen_px_to_px(GameData.mouse_screen_px)
	GameData.mouse_cell_idx = get_cell_idx(GameData.mouse_world_px)
	GameData.screen_px_size = get_screen_size()
	GameData.screen_cell_size = get_screen_cell_size()

func update_view() -> void:
	background.material.set_shader_parameter("px_per_cell", px_per_cell)
	background.material.set_shader_parameter("px_position", px)
	terrain_type.material.set_shader_parameter("px_per_cell", px_per_cell)
	terrain_type.material.set_shader_parameter("px_position", px)
	terrain_mod.material.set_shader_parameter("px_per_cell", px_per_cell)
	terrain_mod.material.set_shader_parameter("px_position", px)
	speed_mph.material.set_shader_parameter("px_per_cell", px_per_cell)
	speed_mph.material.set_shader_parameter("px_position", px)
	
func move_view(by_px: Vector2i) -> void:
	px += by_px
	var max_px_pos: Vector2i = Vector2i.ONE * CELL_COLS * px_per_cell - get_screen_size()
	px.x = clamp(px.x, 0, max_px_pos.x)
	px.y = clamp(px.y, 0, max_px_pos.y)
	update_view()
	
func zoom_view(by: int) -> void:
	var old_center_cell_idx: Vector2i = (get_cell_idx() + get_screen_cell_size()/2)
	px_per_cell = clamp(px_per_cell + by, ZOUT_PX_PER_CELL, ZIN_PX_PER_CELL)
	var now_center_cell_idx: Vector2i = (get_cell_idx() + get_screen_cell_size()/2) 
	#var now_center_cell_idx: Vector2i = get_cell_idx(screen_px_to_px(get_mouse_screen_px())) #attempt to zoom to mouse (fail)
	var cell_shift: Vector2i = old_center_cell_idx - now_center_cell_idx
	move_view(cell_shift * px_per_cell)
	update_view()

func get_screen_size() -> Vector2i:
	return get_viewport().get_visible_rect().size

func get_screen_cell_size() -> Vector2i:
	return ceil(get_screen_size() / px_per_cell)
	
func get_cell_idx(world_px: Vector2i = px) -> Vector2i:
	return world_px / px_per_cell
	
func screen_px_to_px(screen_px_pos: Vector2i) -> Vector2i:
	return screen_px_pos + px 

func get_mouse_screen_float_px() -> Vector2:
	return get_viewport().get_mouse_position()

func get_mouse_screen_px() -> Vector2i:
	return Vector2i(get_mouse_screen_float_px())
	
func get_grid_locked(px_pos: Vector2) -> Vector2i:
	#this does not work.
	#does not need to be a world px, may be screen_px that just need to snap to grid
	return Vector2i(px_pos / float(px_per_cell)) * px_per_cell

func erase(world_cell_rect) -> void:
	draw_terrain_type(world_cell_rect, TerrainTypeColor.create_empty())
	draw_terrain_mod(world_cell_rect, TerrainModColor.create_empty())
	draw_speed_mph(world_cell_rect, SpeedMPHColor.create_empty())
	draw_direction(world_cell_rect, DirectionColor.create_empty())

func draw_terrain_type(world_cell_rect: Rect2i, cc: TerrainTypeColor) -> void:
	_draw_to_img(terrain_type_img, terrain_type_tex, world_cell_rect, cc.get_color())
	
func draw_terrain_mod(world_cell_rect: Rect2i, cc: TerrainModColor) -> void:
	_draw_to_img(terrain_mod_img, terrain_mod_tex, world_cell_rect, cc.get_color())
	
func draw_speed_mph(world_cell_rect: Rect2i, cc: SpeedMPHColor) -> void:
	_draw_to_img(speed_mph_img, speed_mph_tex, world_cell_rect, cc.get_color())
	
func draw_direction(world_cell_rect: Rect2i, cc: DirectionColor) -> void:
	_draw_to_img(direction_img, direction_tex, world_cell_rect, cc.get_color())
	
func _draw_to_img(img: Image, tex: ImageTexture, world_cell_rect: Rect2i, c: Color) -> void:
	img.fill_rect(world_cell_rect, c)
	tex.update(img)
	

	
	
func create_gradient_random_image(w: int, h: int) -> Image:
	var start_time = Time.get_ticks_msec()
	var img: Image = Image.create(w, h, false, Image.FORMAT_RGBA8)

	var color1 = Color.AQUA
	var color2 = Color.CORAL

	# Center of the image
	var center_x = w / 2.0
	var center_y = h / 2.0
	var max_dist = sqrt(center_x * center_x + center_y * center_y)

	for y in range(h):
		for x in range(w):
			var use_color1 = ((x + y) % 2 == 0)
			var base_color = color1 if use_color1 else color2

			# Compute distance to center and normalize it between 0 and 1
			var dx = x - center_x
			var dy = y - center_y
			var dist = sqrt(dx * dx + dy * dy) / max_dist

			# Invert distance so closer to center = darker
			var brightness = dist  # far = 1, near = 0
			var dark_factor = lerp(0, 1, brightness)  # 0.4 = darkest center, 1.0 = edge

			# Apply darkening
			var darker_color = Color(
				base_color.r * dark_factor,
				base_color.g * dark_factor,
				base_color.b * dark_factor,
				1.0
			)

			img.set_pixel(x, y, darker_color)

	var end_time = Time.get_ticks_msec()
	print("Generated in %s ms" % (end_time - start_time))
	return img
