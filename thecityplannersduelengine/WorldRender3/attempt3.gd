extends Node2D

# No Zoom, No change screen size
# Movement unbounded
# px_per_cell = 4
# World Image & World Texture: 8000 x 8000 px, each px represents a cell
# screen size: always have the screen size rounded up to the nearest cell
# Screen Data Image & Texture: empty image and texture corresponding to screen_size / 4
# Screen Image & Screen Texture: empty image and texture corresponding to screen_size
# make the worldSprite have the Screen Texture so it has the full size (needed for the shader)
# give the Data Texture to the shader
# every time I change the view:
#	copy the empty Screen !Data! Image and fill it with data using blit.rect() from World Image
# 	update the Data Texture (in theory it will take the data texture and see that the sprite is around 4x larger and draw everything appropriatly)


# zoom changes the PX_PER_CELL
# zoom position correction: get the center of the old zoom, get the center of the new zoom, shift the top left position by the delta


@onready var ViewSprite: Sprite2D = %ViewSprite
@onready var Visualizer: Sprite2D = %Visualizer

var time_delta: float
var move_speed: float = 500.0
var zoom_speed: float = 1.0 #increment px_per_cell

const WORLD_CELL_ROWS: int = 4000
const WORLD_CELL_COLS: int = 4000
const ZIN_PX_PER_CELL: int = 12*4
const Z1_PX_PER_CELL: int = 12
const ZOUT_PX_PER_CELL: int = 12/4.0

var px_per_cell: int = Z1_PX_PER_CELL
var screen_size: Vector2 
var screen_cell_size: Vector2i 
var screen_position: Vector2 
var screen_cell_index: Vector2i

var world_data_img : Image
var world_data_tex : ImageTexture
var screen_data_img: Image
var screen_data_tex: ImageTexture
var screen_view_img: Image
var screen_view_tex: ImageTexture

func _ready() -> void:
	screen_size = get_viewport_rect().size
	screen_cell_size = ceil(screen_size / px_per_cell)
	screen_position = Vector2(0,0)
	screen_cell_index = Vector2i(0,0)
	
	world_data_img = create_random_image(WORLD_CELL_COLS, WORLD_CELL_ROWS)
	world_data_tex = ImageTexture.create_from_image(world_data_img)
	
	screen_data_img = Image.create_empty(screen_cell_size.x, screen_cell_size.y, false, Image.FORMAT_RGBA8)
	screen_data_tex = ImageTexture.create_from_image(screen_data_img)
	
	screen_view_img = Image.create_empty(int(screen_size.x), int(screen_size.y), false, Image.FORMAT_RGBA8)
	screen_view_tex = ImageTexture.create_from_image(screen_view_img)
	
	var shader: Shader = load("res://WorldRender3/attempt3.gdshader")
	var mat: ShaderMaterial = ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("data_tex", screen_data_tex) #yes it should be the data texture
	mat.set_shader_parameter("data_tex_size", Vector2(screen_data_tex.get_width(), screen_data_tex.get_width()))
	ViewSprite.texture = screen_view_tex #yes it should be the screen texture
	ViewSprite.material = mat
	ViewSprite.centered = false
	
	handle_screen()

func _process(delta: float) -> void:
	time_delta = delta
	var m: bool = handle_move()
	#var z: bool = handle_zoom()
	#if m or z:
		#handle_screen()
	if m:
		handle_screen()

func handle_screen() -> void:
	var copy_at_rect: Rect2i = Rect2i(screen_cell_index, screen_cell_size)
	var paste_at_idx: Vector2i = Vector2i(0,0)
	screen_data_img.blit_rect(world_data_img, copy_at_rect, paste_at_idx)
	screen_data_tex.update(screen_data_img)
		
func handle_move() -> bool:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move camera north"):
		dir += Vector2(0, -1)
	if Input.is_action_pressed("move camera south"):
		dir += Vector2(0, +1)
	if Input.is_action_pressed("move camera west"):
		dir += Vector2(-1, 0)
	if Input.is_action_pressed("move camera east"):
		dir += Vector2(+1, 0)
	if dir == Vector2.ZERO: return false
	screen_position += dir.normalized() * move_speed * time_delta #* 1/zoom_scale
	screen_position.x = clamp(screen_position.x, 0, WORLD_CELL_COLS * px_per_cell - screen_size.x)
	screen_position.y = clamp(screen_position.y, 0, WORLD_CELL_ROWS * px_per_cell - screen_size.y)
	screen_cell_index = screen_position / px_per_cell
	return true
	
#func handle_zoom() -> bool:
	#var dir: int = 0
	#var old_px_per_cell: int = px_per_cell
	#if Input.is_action_just_released("zoom camera in"):
		#dir = +1
	#if Input.is_action_just_released("zoom camera out"):
		#dir = -1
	#if dir == 0: return false
	#px_per_cell = clamp(px_per_cell + dir*zoom_speed, ZOUT_PX_PER_CELL, ZIN_PX_PER_CELL)
	#if old_px_per_cell == px_per_cell: return false
	##shift the screen_position to keep screen center in the same place
	#
	##find the old screen center
	##find the new screen center
	##shift the screen center so it is on the old screen center
	##apply the delta to shift the screen_position
	##clamp the screen position
	#
	##ultimalty I need to update screen_cell_index, screen_cell_size!!!!
	#
	#var old_screen_center_cell: Vector2i = screen_cell_index + screen_cell_size
	#var old_screen_center: Vector2 = old_screen_center_cell * old_px_per_cell
	#screen_cell_size = screen_size / px_per_cell #new screen cell size
	#var new_screen_center_cell: Vector2i = screen_cell_index + screen_cell_size
	#var new_screen_center: Vector2 = new_screen_center_cell * px_per_cell
	#var shift: Vector2 = old_screen_center - new_screen_center
	#screen_position += shift
	#screen_position.x = clamp(screen_position.x, 0, WORLD_CELL_COLS * px_per_cell - screen_size.x)
	#screen_position.y = clamp(screen_position.y, 0, WORLD_CELL_ROWS * px_per_cell - screen_size.y)
	#screen_cell_index = screen_position / px_per_cell
	#return true
	
func create_random_image(w: int, h: int) -> Image:
	var start_time = Time.get_ticks_msec()  # Start timer
	var img: Image = Image.create(w, h, false, Image.FORMAT_RGBA8)
	
	var color1 = Color.AQUA  #Color(randf(), randf(), randf())
	var color2 = Color.CORAL #Color(randf(), randf(), randf())
	
	for y in h:
		for x in w:
			var use_color1 = ((x + y) % 2 == 0)
			img.set_pixel(x, y, color1 if use_color1 else color2)
			
	var end_time = Time.get_ticks_msec()  # End timer
	var delta = end_time - start_time
	print("Generated in %s ms" % delta)
	
	return img
