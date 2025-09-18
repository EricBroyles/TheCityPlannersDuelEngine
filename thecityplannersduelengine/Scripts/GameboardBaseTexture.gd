extends Node2D

func _ready() -> void:
	var base_texture: Sprite2D = Sprite2D.new()
	base_texture.texture = get_base_texture(EngineData.GAMEBOARD_MATRIX_ROWS, EngineData.GAMEBOARD_MATRIX_COLS, EngineData.GAMEBOARD_MATRIX_CELL_WIDTH)
	base_texture.centered = false
	add_child(base_texture)
	
func get_base_texture(rows: int, cols: int, cell_width: int) -> Texture2D:
	var texture_width: int = cols * cell_width
	var texture_height: int = rows * cell_width
	
	var img: Image = Image.create(texture_width, texture_height, false, Image.FORMAT_RGB8)
	for r in rows:
		for c in cols:
			var color: Color = Color.BLACK if (r + c) % 2 == 0 else Color.WHITE
			for y in cell_width: 
				for x in cell_width:
					img.set_pixel(c * cell_width + x, r * cell_width + y, color)
	var texture: Texture2D = ImageTexture.create_from_image(img)
	return texture
	
	
	
	
