extends Node2D

@onready var ViewSprite: Sprite2D = %ViewSprite
@onready var MouseCellIdx: RichTextLabel = %MouseCellIdx

const WORLD_CELL_ROWS: int = 1000
const WORLD_CELL_COLS: int = 1000
const ZIN_PX_PER_CELL: int = 12*4
const Z1_PX_PER_CELL: int = 12
const ZOUT_PX_PER_CELL: int = int(12/4.0)

var time_delta: float
var move_speed: float = 400.0 #500.0 / 10
var zoom_speed: float = 1.0 #increment px_per_cell

var px_per_cell: int = Z1_PX_PER_CELL
var screen_position: Vector2  = Vector2(0,0)

var world_data_img : Image
var world_data_tex : ImageTexture
var screen_data_img: Image
var screen_data_tex: ImageTexture
var screen_view_img: Image
var screen_view_tex: ImageTexture

func _ready() -> void:
	init_world_data()
	setup_screen()
	handle_screen()

func _process(delta: float) -> void:
	time_delta = delta
	display_mouse_cell_idx()
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
	screen_data_img.blit_rect(world_data_img, copy_at_rect, paste_at_idx)
	screen_data_tex.update(screen_data_img)
	
func handle_move() -> bool:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move camera north"): dir += Vector2(0, -1)
	elif Input.is_action_pressed("move camera south"): dir += Vector2(0, +1)
	elif Input.is_action_pressed("move camera west"):  dir += Vector2(-1, 0)
	elif Input.is_action_pressed("move camera east"):  dir += Vector2(+1, 0)
	else: return false
	var did_change: bool = set_screen_position(dir.normalized() * move_speed * time_delta)
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
		set_screen_position(cell_shift * px_per_cell)
		set_screen_data(curr_screen_cell_size)
		set_view_sprite_material()
	return did_change
	
func handle_screen_adjustment() -> bool:
	var screen_size: Vector2i = get_screen_size()
	var old_screen_size: Vector2i = Vector2i(screen_view_img.get_width(), screen_view_img.get_height())
	if screen_size == old_screen_size: return false
	setup_screen()
	return true
		
func init_world_data() -> void:
	world_data_img = create_gradient_random_image(WORLD_CELL_COLS, WORLD_CELL_ROWS)
	world_data_tex = ImageTexture.create_from_image(world_data_img)
	
func init_view_sprite() -> void:
	#var shader: Shader = load("res://WorldRender3/attempt3.gdshader")
	#var mat: ShaderMaterial = ShaderMaterial.new()
	#mat.shader = shader
	set_view_sprite_material()
	ViewSprite.texture = screen_view_tex #yes it should be the screen texture
	ViewSprite.centered = false

func set_view_sprite_material() -> void:
	ViewSprite.material.set_shader_parameter("data_tex", screen_data_tex) #yes it should be the data texture

func set_screen_data(screen_cell_size: Vector2i) -> void:
	screen_data_img = Image.create_empty(screen_cell_size.x, screen_cell_size.y, false, Image.FORMAT_RGBA8)
	screen_data_tex = ImageTexture.create_from_image(screen_data_img)

func set_screen_view(screen_size: Vector2i) -> void:
	screen_view_img = Image.create_empty(screen_size.x, screen_size.y, false, Image.FORMAT_RGBA8)
	screen_view_tex = ImageTexture.create_from_image(screen_view_img)

func set_screen_position(position_delta: Vector2) -> bool:
	var old_pos: Vector2 = screen_position
	var ss: Vector2i = get_screen_size()
	screen_position += position_delta
	screen_position.x = clamp(screen_position.x, 0, WORLD_CELL_COLS * px_per_cell - ss.x)
	screen_position.y = clamp(screen_position.y, 0, WORLD_CELL_ROWS * px_per_cell - ss.y)
	if screen_position == old_pos: return false
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
	return calc_screen_cell_idx(screen_position)

func calc_screen_cell_idx(screen_pos: Vector2) -> Vector2i:
	return screen_pos / px_per_cell

func display_mouse_cell_idx() -> void:
	var mouse_cell_idx: Vector2i = get_mouse_cell_idx()
	var s: String = "C: " + str(mouse_cell_idx.x) + " --- R: " + str(mouse_cell_idx.y) + " TL Pos: " + str(screen_position)
	MouseCellIdx.text = s

func get_mouse_cell_idx() -> Vector2i:
	#get the current mouse position relative to the top left corner of the screen
	var mouse_position: Vector2 = get_global_mouse_position()
	return calc_screen_cell_idx(screen_position + mouse_position)

func create_random_image(w: int, h: int) -> Image:
	var start_time = Time.get_ticks_msec()  # Start timer
	var img: Image = Image.create(w, h, false, Image.FORMAT_RGBA8)
	var color1 = Color.AQUA  #Color(randf(), randf(), randf())
	var color2 = Color.CORAL #Color(randf(), randf(), randf())
	for y in h: for x in w:
		var use_color1 = ((x + y) % 2 == 0)
		img.set_pixel(x, y, color1 if use_color1 else color2)
	var end_time = Time.get_ticks_msec()  # End timer
	var delta = end_time - start_time
	print("Generated in %s ms" % delta)
	return img
	
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
	
