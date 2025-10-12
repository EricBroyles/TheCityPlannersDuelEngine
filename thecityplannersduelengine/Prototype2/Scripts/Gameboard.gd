extends Node2D
class_name Gameboard

@onready var grid_tiles_sprite = %GridTilesSprite
@onready var grid_cells_sprite = %GridCellsSprite
@onready var terrain_mesh = %TerrainMesh
@onready var junction_sprites = %JunctionSprites
@onready var lane_dividers_mesh = %LaneDividersMesh
@onready var builder = %Builder

var cell_cols: int = 12
var cell_rows: int = 10
var _w: int = EngineData.CELL_WIDTH_PX
var _twc: int = EngineData.TILE_WIDTH_CELLS
var matrix: GameboardMatrix

func _ready() -> void:
	matrix = GameboardMatrix.create_empty(cell_cols, cell_rows)
	grid_tiles_sprite.texture = get_grid_texture(int(cell_cols/float(_twc)), int(cell_rows/float(_twc)), _w * _twc, EngineData.grid_dark_color, EngineData.grid_light_color)
	grid_cells_sprite.texture = get_grid_texture(cell_cols, cell_rows, _w, EngineData.grid_dark_color, EngineData.grid_light_color)
	grid_tiles_sprite.centered = false
	grid_cells_sprite.centered = false
	
func get_grid_texture(cols: int, rows: int, width_px: int, color1: Color, color2: Color) -> Texture2D:
	var texture_width: int = cols * width_px
	var texture_height: int = rows * width_px
	var img: Image = Image.create(texture_width, texture_height, false, Image.FORMAT_RGB8)
	for r in rows:
		for c in cols:
			var color: Color = color1 if (r + c) % 2 == 0 else color2
			for y in width_px: 
				for x in width_px:
					img.set_pixel(c * width_px + x, r * width_px + y, color)
	var texture: Texture2D = ImageTexture.create_from_image(img)
	return texture
	



 
