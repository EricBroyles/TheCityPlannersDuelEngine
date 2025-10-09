#extends Node2D
#class_name GameboardViewer
#
### Purpose: To handle the visualization of the Gameboard. 
### This does not store the gameboard or modify the gameboard. 
### This will read the gameboard and update the visuals as needed.
#
#@onready var cells_static_sprite: Sprite2D = %CellsStaticSprite
#@onready var trisubcells_mesh: MultiMeshInstance2D = %TriSubCellsMesh
#
#func _ready() -> void:
	#init_cells_static_sprite()
	#
#func init_cells_static_sprite() -> void:
	##create the grid of black and white cells sprite
	#var rows: int = EngineData.GB_ROWS 
	#var cols: int = EngineData.GB_COLS
	#var cell_width = EngineData.GB_CELL_WIDTH
	#cells_static_sprite.texture = create_cells_static_texture(rows, cols, cell_width)
	#cells_static_sprite.centered = false
	#
#func create_cells_static_texture(rows: int, cols: int, cell_width: int) -> Texture2D:
	#var texture_width: int = cols * cell_width
	#var texture_height: int = rows * cell_width
	#
	#var img: Image = Image.create(texture_width, texture_height, false, Image.FORMAT_RGB8)
	#for r in rows:
		#for c in cols:
			#var color: Color = Color.BLACK if (r + c) % 2 == 0 else Color.WHITE
			#for y in cell_width: 
				#for x in cell_width:
					#img.set_pixel(c * cell_width + x, r * cell_width + y, color)
	#var texture: Texture2D = ImageTexture.create_from_image(img)
	#return texture
	#
