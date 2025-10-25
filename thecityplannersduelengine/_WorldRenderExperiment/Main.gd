extends Node2D







# World Size = 4 mi x 4 mi -> 4ft a cell -> 5280 cells by 5280 cells
# Array of 5280 Images. Each Image is 1 row by 5280 cols

#World Comprised of 128 x 128 chuncks (create world from chuncks not cells)
# chunk_img_matrix: 2D array of images of 128 x 128
# chunk_tex_matrix: 2D array of textures of 128 x 128 (create from img, then update from img when change occurs)
# pass to shader only the relevant chunk_tex_matrix as sampler2DArray, and a scale factor to apply to all cells, and that starting point fro the chunk top left corner (as it is bullshit)
#find the vertext position, is just take the screen position figure out which chunk then figure out the position of the top left corner of that chunk, this becomes that stating draw position
#with this technique I may draw a little extra ( or do a calulcation to decide what is on the screen or not)



## World Shader
# set to postion (0,0)
# full screen size, and expands H and V
# create world_renderer.gdshader script
# add new material, add new shader, load world_renderer
# need to add some kindoff texture (even if it is just an empty texture) to get the shader material to show up
@onready var WorldShader: TextureRect = %WorldShader

const ZIN_CELL_WIDTH: float = 16.0
const Z1_CELL_WIDTH: float = 4.0
const ZOUT_CELL_WIDTH: float = 1.0

const ZIN_SCALE : float = (ZIN_CELL_WIDTH / float(Z1_CELL_WIDTH)) # larger number
const ZOUT_SCALE: float = (ZOUT_CELL_WIDTH / float(Z1_CELL_WIDTH)) # small number

var time_delta: float = 0.0

var cells_per_chunk: int = 128
var chunk_cols: int = 20
var chunk_rows: int = 22
var chunk_img_array: Array[Image] = []
var chunk_tex_array: Texture2DArray = Texture2DArray.new()

var screen_position: Vector2 # Top Left. Varies with WASD. Does not actually move the screen.
var screen_size    : Vector2 # Varies with window adjustment.
var zoom_scale     : float   # Varies with scroll wheel

var move_speed: float = 500  #px/sec
var zoom_speed: float = .05

func _ready() -> void:
	screen_position = Vector2(0,0)
	screen_size = get_viewport_rect().size
	zoom_scale = 1
	WorldShader.texture = CanvasTexture.new()
	
	
	for r in chunk_rows:
		for c in chunk_cols:
			chunk_img_array.append(random_two_color_image(cells_per_chunk, cells_per_chunk))

	# Create the Texture2DArray
	chunk_tex_array.create_from_images(chunk_img_array)

	## IMPORTANT: update_layer(image: Image, layer: int) if I want to update a layer

func _process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	time_delta = delta
	var m: bool = handle_move()
	var z: bool = handle_zoom()
	var a: bool = handle_screen_adjustment()
	var b: bool = bound_screen_position() #this needs to be seperate handle_move as zoomand adj can change these bounds
	
	print(screen_position, " ", get_move_bounds(), " zoom ", zoom_scale)
	
	if m or z or a or b:
		var px_per_cell: float = get_px_per_cell()
		var screen_size_chunks: Vector2 = round(screen_size / px_per_cell / float(cells_per_chunk))
		var screen_chunk_idx: Vector2 = round(screen_position / px_per_cell / float(cells_per_chunk))
		screen_chunk_idx.x =  clamp(screen_chunk_idx.x, 0, chunk_cols)
		screen_chunk_idx.y =  clamp(screen_chunk_idx.y, 0, chunk_rows)
		
		var start_idx: int = int(screen_chunk_idx.y * chunk_cols + screen_chunk_idx.x)
		var num_chunks: int = int(screen_size_chunks.x * screen_size_chunks.y)
		var end_idx: int = int(start_idx + num_chunks - 1)
		
		# this is initialy drawn in screen space as (0,0)
		var start_chunk_position: Vector2 = screen_chunk_idx * cells_per_chunk * px_per_cell
		# amount to shift start_chunk_position so screen_position is at screen space (0,0)\
		var position_offset: Vector2 = screen_position-start_chunk_position #(relative to godots x and y axis dir)
		
		# Assign uniforms to the shader
		WorldShader.material.set_shader_parameter("tex_array", chunk_tex_array)
		WorldShader.material.set_shader_parameter("start_idx", start_idx)
		WorldShader.material.set_shader_parameter("end_idx", end_idx)
		WorldShader.material.set_shader_parameter("px_per_cell", px_per_cell)
		WorldShader.material.set_shader_parameter("position_offset", position_offset)
		
		
func get_px_per_cell() -> float:
	return Z1_CELL_WIDTH * zoom_scale
	
func get_move_bounds() -> Vector4:
	# x : min x position of tl corner
	# y : min y posotion ...
	# z : max x position of tl corner
	# w : max y posotion ...
	return Vector4(
		0, 
		0, 
		chunk_cols * cells_per_chunk * get_px_per_cell() - screen_size.x, 
		chunk_rows * cells_per_chunk * get_px_per_cell() - screen_size.y
	)
func bound_screen_position() -> bool:
	var old_screen_position: Vector2 = screen_position
	var bounds: Vector4 = get_move_bounds()
	screen_position.x = clamp(screen_position.x, bounds.x, bounds.z)
	screen_position.y = clamp(screen_position.y, bounds.y, bounds.w)
	if old_screen_position == screen_position: return false
	return true

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
	screen_position += dir.normalized() * move_speed * time_delta * 1/zoom_scale
	return true

func handle_zoom() -> bool:
	var dir: int = 0
	var old: float = zoom_scale
	if Input.is_action_just_released("zoom camera in"):
		dir = +1
	if Input.is_action_just_released("zoom camera out"):
		dir = -1
	if dir == 0: return false
	zoom_scale += snapped(dir * zoom_speed, .01)
	#screen_position += screen_size * snapped(dir * zoom_speed, .01) ## MAYBE ??? COrrect for zoom ?
	if zoom_scale < ZOUT_SCALE:
		zoom_scale = ZOUT_SCALE
	if zoom_scale > ZIN_SCALE:
		zoom_scale = ZIN_SCALE
	if old == zoom_scale: return false
	return true

func handle_screen_adjustment() -> bool:
	if screen_size == get_viewport_rect().size: return false
	screen_size = get_viewport_rect().size
	return true

func create_random_color_grid(rs: int, cs: int) -> PackedColorArray:
	var colors = PackedColorArray()
	for r in range(rs):
		for c in range(cs):
			var random_color = Color(randf(), randf(), randf(), 1.0)
			colors.append(random_color)
	return colors
	
func random_two_color_image(width: int, height: int) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)

	# Generate two random colors
	var color1 = Color(randf(), randf(), randf())
	var color2 = Color(randf(), randf(), randf())

	for y in height:
		for x in width:
			if x < width / 2.0:
				img.set_pixel(x, y, color1)
			else:
				img.set_pixel(x, y, color2)
	return img









## Depritated 2
## Goals
## 1. allow user to move
## 2. allow user to zoom in and out.
## 3. changin the screen size does not increase the number of cells being displayed
## 3. have "no" limits on movement
## 4. have zoom in and out limits
## 5. scale to any screen size of any aspect ratio
## 6. draw grid of cells of random colors
## 6.. draw grid in continous manner (not perfect cutoffs)
## 7. have a large matrix (larger than what can be rendered to screen) and successfuly only show parts
## 8. maitain around 60 fps
#
#@onready var WorldSprite: Sprite2D = %WorldSprite
#
## X and Y must agree
#const ZIN_MAX_CELLS_VISIBLE: Vector2 = Vector2(20,20)  
#const Z1_MAX_CELLS_VISIBLE: Vector2 = Vector2(100,100)
#const ZOUT_MAX_CELLS_VISIBLE: Vector2 = Vector2(500, 500)
#
#const ZIN_SCALE : float = (Z1_MAX_CELLS_VISIBLE / ZIN_MAX_CELLS_VISIBLE).x # larger number
#const ZOUT_SCALE: float = (Z1_MAX_CELLS_VISIBLE / ZOUT_MAX_CELLS_VISIBLE).x # small number
#
#var time_delta: float = 0.0
#
#var rows: int = 1000
#var cols: int = 2500
#var matrix: Array[Array] = []  # 2D matrix of color "cells"
#
#var screen_position: Vector2 # Top Left. Varies with WASD. Does not actually move the screen.
#var screen_size    : Vector2 # Varies with window adjustment.
#var zoom_scale     : float   # Varies with scroll wheel
#
#var move_speed: float = 500  #px/sec
#var zoom_speed: float = .05
#
#var matrix_img: Image        # I know this has a max size of ZOUT_MAX_CELLS_VISIBLE
#var matrix_tex: ImageTexture
##var sprite_img: Image        # This max size depends on user screen size
##var sprite_tex: ImageTexture
#
#
#
#func _ready() -> void:
	#screen_position = Vector2(0,0)
	#screen_size = get_viewport_rect().size
	#zoom_scale = 1
	#
	## Sprite Setup
	#WorldSprite.centered = true
	#WorldSprite.position = screen_size / 2
	#
	## Image and Texture Setup
	#matrix_img = Image.create(int(ZOUT_MAX_CELLS_VISIBLE.x), int(ZOUT_MAX_CELLS_VISIBLE.y), false, Image.FORMAT_RGBA8)
	#matrix_tex = ImageTexture.create_from_image(matrix_img)
	#
#func _process(delta: float) -> void:
	##print(Engine.get_frames_per_second())
	#time_delta = delta
	#var m: bool = handle_move()
	#var z: bool = handle_zoom()
	#var a: bool = handle_screen_adjustment()
	#
	#if m or z or a:
		#
		#
		#
		#var max_cells_visible: Vector2 = Z1_MAX_CELLS_VISIBLE / zoom_scale #max allowed cells nnow need to think about screen size
		#var max_screen_size_value: float = max(screen_size.x, screen_size.y)
		#var cell_width: float = max_cells_visible.x / max_screen_size_value
		#
		#var screen_cell_index: Vector2 = screen_position * cell_width
		#var cells_visible: Vector2 = screen_size * cell_width
		#
		#print(ZIN_SCALE, " ",  ZOUT_SCALE, " ", zoom_scale)
		#print(cell_width)
		#print(screen_position, " ", screen_cell_index)
		#print(screen_size, " ", cells_visible)
		#print("")
		#
		#
		##create an image of black and white tiles each tile of cell_width that fills the entire screen_size with them
		##add this image to WorldSprite
		#
		## Create an image sized to the screen
		#var img_w = int(screen_size.x)
		#var img_h = int(screen_size.y)
		#var img = Image.create(img_w, img_h, false, Image.FORMAT_RGBA8)
#
		## Draw checkerboard pattern based on cell_width
		#for y in range(img_h):
			#for x in range(img_w):
				#var cell_x = int(floor(x * cell_width))
				#var cell_y = int(floor(y * cell_width))
				#var is_light = (cell_x + cell_y) % 2 == 0
				#var color = Color(0.9, 0.9, 0.9) if is_light else Color(0.1, 0.1, 0.1)
				#img.set_pixel(x, y, color)
#
		## Convert to texture and display
		#var tex = ImageTexture.create_from_image(img)
		#WorldSprite.texture = tex
		#
		#
		#
		#
		#
		##var screen_cell_index: Vector2 = screen_position / 
		## Convert screen_position into screen_cell_index Vector2()
		## Convert screen_size and zoom into cells_visible Vector2()
		#
		#
		##update the matrix_tex and then sprite.draw with shader (with the matrix_tex and scaling information)
		#
	#
	##if somthing has changed
	#
	##how many cells can I have on the screen at my zoom and screen_size
	#
	##where in matrix space am I 
#
#func handle_move() -> bool:
	#var dir: Vector2 = Vector2.ZERO
	#if Input.is_action_pressed("move camera north"):
		#dir += Vector2(0, -1)
	#if Input.is_action_pressed("move camera south"):
		#dir += Vector2(0, +1)
	#if Input.is_action_pressed("move camera west"):
		#dir += Vector2(-1, 0)
	#if Input.is_action_pressed("move camera east"):
		#dir += Vector2(+1, 0)
	#if dir == Vector2.ZERO: return false
	#screen_position += dir.normalized() * move_speed * time_delta * 1/zoom_scale
	#return true
#
#func handle_zoom() -> bool:
	#var dir: int = 0
	#var old: float = zoom_scale
	#if Input.is_action_just_released("zoom camera in"):
		#dir = +1
	#if Input.is_action_just_released("zoom camera out"):
		#dir = -1
	#if dir == 0: return false
	#zoom_scale += snapped(dir * zoom_speed, .01)
	##screen_position += screen_size * snapped(dir * zoom_speed, .01) ## MAYBE ??? COrrect for zoom ?
	#if zoom_scale < ZOUT_SCALE:
		#zoom_scale = ZOUT_SCALE
	#if zoom_scale > ZIN_SCALE:
		#zoom_scale = ZIN_SCALE
	#if old == zoom_scale: return false
	#return true
#
#func handle_screen_adjustment() -> bool:
	#if screen_size == get_viewport_rect().size: return false
	#screen_size = get_viewport_rect().size
	#WorldSprite.position = screen_size / 2
	#return true











## DEPRITATED 1

#
## Goals:
## 1. allow user to move
## 2. allow user to zoom in and out
## 3. have "no" limits on movement
## 4. have zoom in and out limits
## 5. scale to any screen size of any aspect ratio(larger screen can show more cells)
## 6. draw grid of cells of random colors
## 6.. draw grid in continous manner (not perfect cutoffs)
## 7. have a large matrix (larger than what can be rendered to screen) and successfuly only show parts
## 8. maitain around 60 fps
#
#@onready var WorldSprite: Sprite2D = %WorldSprite
#var img: Image
#var tex: ImageTexture
#
#
#var rows: int = 1000
#var cols: int = 2500
#var matrix: Array = []  # 2D matrix of color "cells"
#
#var screen_position: Vector2 # Top Left. Varies with WASD. Does not actually move the screen.
#var screen_size    : Vector2 # Varies with window adjustment.
#var zoom: float = 1
#
#
#
#
#
###SHIT
#
#
#func _ready() -> void:
	#screen_position = Vector2(0,0)
	#screen_size = get_viewport_rect().size
	#WorldSprite.centered = true
	#img = Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGBA8)
	#tex = ImageTexture.create_from_image(img)
	#populate_matrix()
	##quick_draw_sprite()
	#
#func _process(delta: float) -> void:
	##TODO adjust the screen position here by checking inputs
	#print(Engine.get_frames_per_second())
	## The window has changed size
	#if screen_size != get_viewport_rect().size:
		#screen_size = get_viewport_rect().size
		#img = Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGBA8)
		#tex = ImageTexture.create_from_image(img)
		#
	#WorldSprite.position = screen_size / 2 # center the sprite inside the screen
	#
	#for x in int(screen_size.x - 1):
		#for y in int(screen_size.y - 1):
			#var c: int = x + int(screen_position.x)
			#var r: int = y + int(screen_position.y)
			#if is_valid_index(r,c): img.set_pixel(x, y, matrix[r][c])
			#else: img.set_pixel(x, y, Color.TURQUOISE)
			#
	#tex.update(img)
	#WorldSprite.texture = tex
	#
#
#
#
#
### MAYBE USEFUL
##func quick_draw_sprite() -> void:
	### Create an image of the same size as the matrix
	##var img := Image.create(cols, rows, false, Image.FORMAT_RGB8)
	##
	##for y in range(rows):
		##for x in range(cols):
			##img.set_pixel(x, y, matrix[y][x])
	##
	### Convert image to texture and set it to the sprite
	##var tex := ImageTexture.create_from_image(img)
	##WorldSprite.texture = tex
	#
### GOOD
#func is_valid_index(r: int, c: int) -> bool:
	#return r >= 0 and r < matrix.size() and c >= 0 and c < matrix[r].size()
#
#func populate_matrix() -> void:
	#matrix.resize(rows)
	#for r in range(rows):
		#matrix[r] = []
		#for c in range(cols):
			#matrix[r].append(Color(randf(), randf(), randf()))
#
	#var corner_h = int(round(rows * 0.1))
	#var corner_w = int(round(cols * 0.1))
#
	#for r in range(rows):
		#for c in range(cols):
			## top-left
			#if r < corner_h and c < corner_w:
				#matrix[r][c] = Color.RED
			## top-right
			#elif r < corner_h and c >= cols - corner_w:
				#matrix[r][c] = Color.BLUE
			## bottom-left
			#elif r >= rows - corner_h and c < corner_w:
				#matrix[r][c] = Color.GREEN
			## bottom-right
			#elif r >= rows - corner_h and c >= cols - corner_w:
				#matrix[r][c] = Color.YELLOW
