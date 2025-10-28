extends CanvasLayer
class_name World

## Background: color1, color2, px_per_cell, cell_size

# Cell Size = Size in terms of cells

@onready var background: TextureRect = %Background
@onready var terrain: TextureRect = %Terrain
@onready var speed: TextureRect = %Speed
@onready var direction: TextureRect = %Direction

const CELL_ROWS: int = 1000
const CELL_COLS: int = 1000
const ZIN_PX_PER_CELL: int = 12*4
const Z1_PX_PER_CELL: int = 12
const ZOUT_PX_PER_CELL: int = int(12/4.0)

var px_per_cell: int = Z1_PX_PER_CELL
var px: Vector2i = Vector2i(0,0) #top left px position

## World: each px represents a cell for the entire world
var world_terrain_img: Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, TerrainColor.IMAGE_FORMAT)
var world_terrain_tex: ImageTexture = ImageTexture.create_from_image(world_terrain_img)
var world_velocity_img: Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, VelocityColor.IMAGE_FORMAT)
var world_velocity_tex: ImageTexture = ImageTexture.create_from_image(world_velocity_img)

func _ready() -> void:
	
	world_terrain_img.fill(TerrainColor.EMPTY_COLOR)
	#world_terrain_img = create_gradient_random_image(CELL_COLS, CELL_ROWS) ## REMOVE
	world_terrain_tex.update(world_terrain_img)
	
	world_velocity_img.fill(VelocityColor.EMPTY_COLOR)
	world_velocity_tex.update(world_velocity_img)
	
	background.material.set_shader_parameter("world_cell_size", Vector2i(CELL_COLS, CELL_ROWS))
	terrain.material.set_shader_parameter("world_data_tex", world_terrain_tex)
	
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
	terrain.material.set_shader_parameter("px_per_cell", px_per_cell)
	terrain.material.set_shader_parameter("px_position", px)
	
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
	#does not need to be a world px, may be screen_px that just need to snap to grid
	return Vector2i(px_pos / float(px_per_cell)) * px_per_cell
	
func draw_terrain(world_cell_rect: Rect2i, color: Color) -> void:
	_draw_to_img(world_terrain_img, world_terrain_tex, world_cell_rect, color)

func draw_velocity(world_cell_rect: Rect2i, color: Color) -> void:
	_draw_to_img(world_velocity_img, world_velocity_tex, world_cell_rect, color)
	
func erase(world_cell_rect: Rect2i) -> void:
	draw_terrain(world_cell_rect, TerrainColor.EMPTY_COLOR)
	draw_velocity(world_cell_rect, VelocityColor.EMPTY_COLOR)
	
func _draw_to_img(img: Image, tex: ImageTexture, world_cell_rect: Rect2i, color: Color) -> void:
	img.fill_rect(world_cell_rect, color)
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
