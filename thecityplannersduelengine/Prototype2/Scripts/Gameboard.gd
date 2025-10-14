extends Node2D
class_name Gameboard

@onready var grid_cells_sprite = %GridCellsSprite
#@onready var terrain_mesh = %TerrainMesh
#@onready var junction_sprites = %JunctionSprites
#@onready var lane_dividers_mesh = %LaneDividersMesh
@onready var builder = %Builder

var curr_cells_view_rect: Rect2
@onready var sprite2: Sprite2D = %GBSpriteShader

var cell_cols: int = 58
var cell_rows: int = 33
var _w: int = EngineData.CELL_WIDTH_PX
var matrix: GameboardMatrix

func _ready() -> void:
	matrix = GameboardMatrix.create_empty(cell_cols, cell_rows)
	grid_cells_sprite.texture = get_grid_texture(cell_cols, cell_rows, _w, EngineData.grid_dark_color, EngineData.grid_light_color)
	grid_cells_sprite.centered = false
	#grid_cells_sprite.scale = Vector2.ONE * EngineData.CELL_WIDTH_PX
	
func get_grid_texture(cols: int, rows: int, width_px: int, color1: Color, color2: Color) -> Texture2D:
	var img: Image = Image.create(cols, rows, false, Image.FORMAT_RGBA8)
	for r in rows: for c in cols:
			var color: Color = color1 if (r + c) % 2 == 0 else color2
			img.set_pixel(c , r, color)
	# Scale it up by a factor of 4
	var new_width = img.get_width() * width_px
	var new_height = img.get_height() * width_px

	# Resize the image
	img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST)  # Or use INTERPOLATE_BILINEAR for smooth scaling

	var texture: Texture2D = ImageTexture.create_from_image(img)
	return texture
	
#func get_grid_texture(cols: int, rows: int, width_px: int, color1: Color, color2: Color) -> Texture2D:
	#var texture_width: int = cols * width_px
	#var texture_height: int = rows * width_px
	#var img: Image = Image.create(texture_width, texture_height, false, Image.FORMAT_RGB8)
	#for r in rows: for c in cols:
			#var color: Color = color1 if (r + c) % 2 == 0 else color2
			#for y in width_px: 
				#for x in width_px:
					#img.set_pixel(c * width_px + x, r * width_px + y, color)
	#var texture: Texture2D = ImageTexture.create_from_image(img)
	#return texture
	
func _process(_delta: float) -> void:
	
	if curr_cells_view_rect != EngineData.cells_view_rect:
		curr_cells_view_rect = EngineData.cells_view_rect
		var screen_size: Vector2 = get_viewport_rect().size
		var cell_size: Vector2 = screen_size / EngineData.cells_view_rect.size
		
		var img: Image = Image.create(EngineData.cells_view_rect.size.x, EngineData.cells_view_rect.size.y, false, Image.FORMAT_RGBA8)
		for img_c in img.get_width():
			for img_r in img.get_height():
				#noew convert the img_x and img_y into matrix r and col
				var matrix_c: int = img_c + EngineData.cells_view_rect.position.x
				var matrix_r: int = img_r + EngineData.cells_view_rect.position.y
				if matrix.is_valid_index(matrix_r,matrix_c):
					img.set_pixel(img_c,img_r,matrix.cells[matrix_r][matrix_c].get_color())
		
		var new_width = img.get_width() * cell_size.x 
		var new_height = img.get_height() * cell_size.y
		img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		var texture: Texture2D = ImageTexture.create_from_image(img)
		sprite2.texture = texture
		
		
		
		
		
		#curr_cells_view_rect = EngineData.cells_view_rect
		#var screen_size: Vector2 = get_viewport_rect().size
		#var cell_size: Vector2 = screen_size / EngineData.cells_view_rect.size
		#var relevant_matrix_rect: Rect2 = matrix.get_rect2_in(curr_cells_view_rect)
		 #
		#var img: Image = Image.create(EngineData.cells_view_rect.size.x, EngineData.cells_view_rect.size.y, false, Image.FORMAT_RGBA8)
		#img.fill(EngineData.void_color)
		#
		#var start_col: int = int(relevant_matrix_rect.position.x)
		#var end_col: int = int(start_col + relevant_matrix_rect.size.x - 1)
		#var start_row: int = int(relevant_matrix_rect.position.y)
		#var end_row: int = int(start_row + relevant_matrix_rect.size.y - 1)
		#print("----")
		#print("Cols:", start_col, "→", end_col)
		#print("Rows:", start_row, "→", end_row )
		#for c in range(start_col, end_col):
			#for r in range(start_row, end_row): 
				#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#
		#var new_width = img.get_width() * cell_size.x 
		#var new_height = img.get_height() * cell_size.y
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
		
		
		
		
		
		
		
		
		#var screen_size: Vector2 = get_viewport_rect().size
		#var cell_view_top_left: Vector2 = EngineData.cells_view_rect.position
		#var cell_view_size: Vector2 = EngineData.cells_view_rect.size
		#var cell_size: Vector2 = screen_size / cell_view_size
		#var intersect_rect: Rect2 = matrix.get_rect2().intersection(curr_cells_view_rect)
		#print(matrix.get_rect2(), " ", curr_cells_view_rect, " ", intersect_rect)
		##shift the intersect_rect so that curr_cells_view_rect.position is at 0,0
		##if intersect_rect.position.x < 0: intersect_rect.position.x *= -1
		##if intersect_rect.position.y < 0: intersect_rect.position.y *= -1
		#
		#var img: Image = Image.create(cell_view_size.x, cell_view_size.y, false, Image.FORMAT_RGBA8)
		#img.fill(EngineData.void_color)
		#var matrix_start_col: int = int(intersect_rect.position.x)
		#var matrix_end_col: int = int(matrix_start_col + intersect_rect.size.x)
		#var matrix_start_row: int = int(intersect_rect.position.y)
		#var matrix_end_row: int = int(matrix_start_row + intersect_rect.size.y)
		#
		#for c in range(matrix_start_col, matrix_end_col):
			#for r in range(matrix_start_row, matrix_end_row): 
				#if matrix.is_valid_index(r,c):
					#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#var new_width = img.get_width() * cell_size.x #* EngineData.CELL_WIDTH_PX 
		#var new_height = img.get_height() * cell_size.y #* EngineData.CELL_WIDTH_PX
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
		#
		
		
		
		#var screen_size: Vector2 = get_viewport_rect().size
		#var cell_size: Vector2 = screen_size / EngineData.cells_view_rect.size
		#var img: Image = Image.create(EngineData.cells_view_rect.size.x, EngineData.cells_view_rect.size.y, false, Image.FORMAT_RGBA8)
		#img.fill(EngineData.void_color)
		#var matrix_start_col: int = int(EngineData.cells_view_rect.position.x)
		#var matrix_end_col: int = int(matrix_start_col + EngineData.cells_view_rect.size.x)
		#var matrix_start_row: int = int(EngineData.cells_view_rect.position.y)
		#var matrix_end_row: int = int(matrix_start_row + EngineData.cells_view_rect.size.y)
		#print("col: ", range(matrix_start_col, matrix_end_col))
		#print("row: ", range(matrix_start_row, matrix_end_row))
		#for c in range(matrix_start_col, matrix_end_col):
			#for r in range(matrix_start_row, matrix_end_row): 
				#if matrix.is_valid_index(r,c):
					#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#
		#var new_width = img.get_width() * cell_size.x #* EngineData.CELL_WIDTH_PX 
		#var new_height = img.get_height() * cell_size.y #* EngineData.CELL_WIDTH_PX
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
		
		
		
		
		#var screen_size: Vector2 = get_viewport_rect().size
		#var cell_size: Vector2 = screen_size / Vector2(EngineData.cells_view_box.z, EngineData.cells_view_box.w)
		#var img: Image = Image.create(EngineData.cells_view_box.z, EngineData.cells_view_box.w, false, Image.FORMAT_RGBA8)
		#img.fill(EngineData.void_color)
		#var relevant_matrix_view_box: Vector4 = Utils.intersect_rects(curr_cells_view_box, matrix.get_as_cells_box())
		#print(curr_cells_view_box, " | ",  matrix.get_as_cells_box(), " | ", relevant_matrix_view_box)
		#var matrix_start_col: int = int(relevant_matrix_view_box.x)
		#var matrix_end_col: int = int(matrix_start_col + relevant_matrix_view_box.z)
		#var matrix_start_row: int = int(relevant_matrix_view_box.y)
		#var matrix_end_row: int = int(matrix_start_row + relevant_matrix_view_box.w)
		#for c in range(matrix_start_col, matrix_end_col):
			#for r in range(matrix_start_row, matrix_end_row): 
			#
				#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#
		#
		#var new_width = img.get_width() * cell_size.x #* EngineData.CELL_WIDTH_PX 
		#var new_height = img.get_height() * cell_size.y #* EngineData.CELL_WIDTH_PX
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
		
		#recompute the size of the cell to get them all on the screen. 
		
		
		
		
		
		##print(EngineData.cells_view_box)
		##print(Utils.intersect_rects(curr_cells_view_box, matrix.get_as_cells_box()))
		##print(EngineData.cells_view_box, " ", get_viewport_rect())
		#print("GLOBAL ", sprite2.global_position)
		#var cols: int = int(EngineData.cells_view_box.z)
		#var rows: int = int(EngineData.cells_view_box.w)
		#var img: Image = Image.create(cols, rows, false, Image.FORMAT_RGBA8)
		#img.fill(EngineData.void_color)
		#var relevant_matrix_view_box: Vector4 = Utils.intersect_rects(curr_cells_view_box, matrix.get_as_cells_box())
		#var matrix_start_col: int = int(relevant_matrix_view_box.x)
		#var matrix_end_col: int = int(matrix_start_col + relevant_matrix_view_box.z)
		#var matrix_start_row: int = int(relevant_matrix_view_box.y)
		#var matrix_end_row: int = int(matrix_start_row + relevant_matrix_view_box.w)
		#print("IMG: ", cols, " ", rows)
		#print(matrix_start_col, " ", matrix_end_col)
		#print(matrix_start_row, " ", matrix_end_row)
		#for c in range(matrix_start_col, matrix_end_col):
			#for r in range(matrix_start_row, matrix_end_row): 
			#
				#img.set_pixel(c,r,matrix.cells[r][c].get_color())
		#
		##scale is not based on cell_width_px, need to resize so it takes the entire screen via get_viewport_rect()
		#var new_width = img.get_width() * EngineData.CELL_WIDTH_PX #* EngineData.CELL_WIDTH_PX 
		#var new_height = img.get_height() * EngineData.CELL_WIDTH_PX #* EngineData.CELL_WIDTH_PX
		#img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 
		#var texture: Texture2D = ImageTexture.create_from_image(img)
		#sprite2.texture = texture
		pass

		
	


#extends Node2D
#class_name Gameboard
#
#@onready var sprite_shader: Sprite2D = %GBSpriteShader
#@onready var builder = %Builder
#
#const _w: int = EngineData.CELL_WIDTH_PX
#var cell_cols: int = 100
#var cell_rows: int = 120
#var matrix: GameboardMatrix
#
#var matrix_modified_at: Array[Vector2] = []
#var curr_img: Image = Image.create(EngineData.MAX_VIEW_BOX_WIDTH, EngineData.MAX_VIEW_BOX_WIDTH, false, Image.FORMAT_RGBA8)
#var curr_tex: ImageTexture = ImageTexture.create_from_image(curr_img)
#var curr_cells_view_box: Vector4
#
#func _ready() -> void:
	#sprite_shader.centered = false
	#matrix = GameboardMatrix.create_empty(cell_cols, cell_rows)
	#print(matrix)
	#
#func _process(_delta: float) -> void:
	#
	#if curr_cells_view_box != EngineData.cells_view_box:
		### NOTE This needs to be imporvoed
		#
		#curr_img.fill(EngineData.void_color)
		#curr_cells_view_box = EngineData.cells_view_box
		#
		#var matrix_r_start: int = int(curr_cells_view_box.y)
		#var matrix_r_end: int = int(curr_cells_view_box.y + curr_cells_view_box.w)
		#var matrix_c_start: int = int(curr_cells_view_box.x)
		#var matrix_c_end: int = int(curr_cells_view_box.x + curr_cells_view_box.z)
		##print(matrix_r_start," ", matrix_r_end," " , matrix_c_start," " , matrix_c_end)
		#for r in range(matrix_r_start, matrix_r_end):
			#for c in range(matrix_c_start, matrix_c_end):
				#if matrix.is_valid_index(r,c):
					#curr_img.set_pixel(c, r, (matrix.cells[r][c] as GameboardCell).get_color())
		#curr_tex.update(curr_img)
		#sprite_shader.draw_texture_with_shader(curr_tex)
#
	#elif matrix_modified_at.size() != 0:
		#pass
	#
	#pass
	


	
	
	
	
	
	
	
	
	

	#



 
