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
var px_position: Vector2i = Vector2i(0,0) #top left px position

## World: each px represents a cell for the entire world
var world_terrain_img: Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, TerrainColor.IMAGE_FORMAT)
var world_terrain_tex: ImageTexture = ImageTexture.create_from_image(world_terrain_img)
var world_velocity_img: Image = Image.create_empty(CELL_COLS, CELL_ROWS, false, VelocityColor.IMAGE_FORMAT)
var world_velocity_tex: ImageTexture = ImageTexture.create_from_image(world_velocity_img)

func _ready() -> void:
	world_terrain_img.fill(TerrainColor.EMPTY_COLOR)
	world_terrain_tex.update(world_terrain_img)
	
	world_velocity_img.fill(VelocityColor.EMPTY_COLOR)
	world_velocity_tex.update(world_velocity_img)
	
	background.material.set_shader_parameter("world_cell_size", Vector2i(CELL_COLS, CELL_ROWS))
	terrain.material.set_shader_parameter("world_data_tex", world_terrain_tex)
	
	world_velocity_img.set_pixel(0,0,VelocityColor.create(2,"se").color)
	VelocityColor.decode(world_velocity_img.get_pixel(0,0))
	update_view()

func update_view() -> void:
	background.material.set_shader_parameter("px_per_cell", px_per_cell)
	background.material.set_shader_parameter("px_position", px_position)
	terrain.material.set_shader_parameter("px_per_cell", px_per_cell)
	terrain.material.set_shader_parameter("px_position", px_position)
	
func move_view(by_px: Vector2i) -> void:
	px_position += by_px
	var max_px_pos: Vector2i = Vector2i.ONE * CELL_COLS * px_per_cell - get_screen_size()
	px_position.x = clamp(px_position.x, 0, max_px_pos.x)
	px_position.y = clamp(px_position.y, 0, max_px_pos.y)
	update_view()
	
func zoom_view(by: int) -> void:
	var old_center_cell_idx: Vector2i = (get_cell_idx() + get_screen_cell_size()/2)
	px_per_cell = clamp(px_per_cell + by, ZOUT_PX_PER_CELL, ZIN_PX_PER_CELL)
	var now_center_cell_idx: Vector2i = (get_cell_idx() + get_screen_cell_size()/2)  
	var cell_shift: Vector2i = old_center_cell_idx - now_center_cell_idx
	move_view(cell_shift * px_per_cell)
	update_view()

func get_screen_size() -> Vector2i:
	return get_viewport().get_visible_rect().size

func get_screen_cell_size() -> Vector2i:
	return ceil(get_screen_size() / px_per_cell)
	
func get_cell_idx(px_pos: Vector2i = px_position) -> Vector2i:
	return px_pos / px_per_cell
	
func get_mouse_px_position() -> Vector2i:
	return Vector2i(get_viewport().get_mouse_position()) + px_position

func get_mouse_cell_idx() -> Vector2i:
	return get_cell_idx(get_mouse_px_position())
	
func draw_terrain(color: Color, world_rect: Rect2i) -> void:
	_draw_to_img(world_terrain_img, world_terrain_tex, color, world_rect)

func draw_velocity(color: Color, world_rect: Rect2i) -> void:
	_draw_to_img(world_velocity_img, world_velocity_tex, color, world_rect)
	
func erase(world_rect: Rect2i) -> void:
	draw_terrain(TerrainColor.EMPTY_COLOR, world_rect)
	draw_velocity(VelocityColor.EMPTY_COLOR, world_rect)
	
func _draw_to_img(img: Image, tex: ImageTexture, color: Color, world_rect: Rect2i) -> void:
	img.fill_rect(world_rect, color)
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
