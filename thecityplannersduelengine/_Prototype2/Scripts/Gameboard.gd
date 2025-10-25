#extends Node2D
#class_name Gameboard
#
#@onready var builder = %Builder
#@onready var sprite2: Sprite2D = %GBSpriteShader
#
#var cell_cols: int = 580
#var cell_rows: int = 330
#var matrix: GameboardMatrix
#var curr_cells_view_rect: Rect2
##var curr_img: Image
##var curr_tex: ImageTexture
#
#func _ready() -> void:
	#matrix = GameboardMatrix.create_empty(cell_cols, cell_rows)
	#sprite2.centered = false
	#
	#
##func set_empty_image() -> void:
	#
		#
#func _process(_delta: float) -> void:
	##print(Engine.get_frames_per_second())
	#
	#if curr_cells_view_rect != EngineData.cells_view_rect:
		#curr_cells_view_rect = EngineData.cells_view_rect
		#var screen_size: Vector2 = get_viewport_rect().size
		#var cell_size: Vector2 = screen_size / EngineData.cells_view_rect.size
		#
		#var img: Image = Image.create(EngineData.cells_view_rect.size.x, EngineData.cells_view_rect.size.y, false, Image.FORMAT_RGBA8)
		#
		#var start_matrix_c: float = EngineData.cells_view_rect.position.x
		#var start_matrix_r: float = EngineData.cells_view_rect.position.y
		#var end_matrix_c: float = img.get_width() - 1
		#var end_matrix_r: float = img.get_height() - 1
		#
		#print(start_matrix_c, " ", end_matrix_c)
		#
		#for c in range(start_matrix_c, end_matrix_c):
			#for r in range(start_matrix_r, end_matrix_r):
				#if matrix.is_valid_index(r,c):
					#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#
		##for img_c in img.get_width():
			##for img_r in img.get_height():
				###noew convert the img_x and img_y into matrix r and col
				##var matrix_c: int = img_c + EngineData.cells_view_rect.position.x
				##var matrix_r: int = img_r + EngineData.cells_view_rect.position.y
				##if matrix.is_valid_index(matrix_r,matrix_c):
					##img.set_pixel(img_c,img_r,matrix.cells[matrix_r][matrix_c].get_color())
		#
		#var new_width = img.get_width() * cell_size.x 
		#var new_height = img.get_height() * cell_size.y
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
#
#
#
#
##extends Node2D
##class_name Gameboard
##
##@onready var grid_cells_sprite = %GridCellsSprite
##@onready var builder = %Builder
##
##var curr_cells_view_rect: Rect2
##@onready var sprite2: Sprite2D = %GBSpriteShader
##
##var cell_cols: int = 580
##var cell_rows: int = 330
##var _w: int = EngineData.CELL_WIDTH_PX
##var matrix: GameboardMatrix
##
##func _ready() -> void:
	##matrix = GameboardMatrix.create_empty(cell_cols, cell_rows)
	##sprite2.centered = false
	##
##func _process(_delta: float) -> void:
	##print(Engine.get_frames_per_second())
	##
	##if curr_cells_view_rect != EngineData.cells_view_rect:
		##curr_cells_view_rect = EngineData.cells_view_rect
		##var screen_size: Vector2 = get_viewport_rect().size
		##var cell_size: Vector2 = screen_size / EngineData.cells_view_rect.size
		##
		##var img: Image = Image.create(EngineData.cells_view_rect.size.x, EngineData.cells_view_rect.size.y, false, Image.FORMAT_RGBA8)
		##for img_c in img.get_width():
			##for img_r in img.get_height():
				###noew convert the img_x and img_y into matrix r and col
				##var matrix_c: int = img_c + EngineData.cells_view_rect.position.x
				##var matrix_r: int = img_r + EngineData.cells_view_rect.position.y
				##if matrix.is_valid_index(matrix_r,matrix_c):
					##img.set_pixel(img_c,img_r,matrix.cells[matrix_r][matrix_c].get_color())
		##
		##var new_width = img.get_width() * cell_size.x 
		##var new_height = img.get_height() * cell_size.y
		##img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		##var texture: Texture2D = ImageTexture.create_from_image(img)
		##sprite2.texture = texture
		#
		#
		#
#
	#
#
#
	#
	#
	#
	#
	#
	#
	#
	#
	#
#
	#
#
#
#
 #
