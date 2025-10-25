extends Node2D

# no zoom yet
# no change in screen size yet
# yes move
# move the camera around

# create a bunch of sprites each with a material that has a given texture
# the camera moves around

# a cell is 4 px by 4 px
# a chunk is 512 px by 512 px, and 128 x 128 cells
# each image stored is 128 x 128 px each px here represents a cell it needs to be scaled up


@onready var World: Node2D = %World

const ZIN_PX_PER_CEL: float = 16.0
const Z1_PX_PER_CELL: float = 4.0
const ZOUT_PX_PER_CEL: float = 1.0

const ZIN_SCALE : float = (ZIN_PX_PER_CEL / float(Z1_PX_PER_CELL)) # larger number
const ZOUT_SCALE: float = (ZOUT_PX_PER_CEL / float(Z1_PX_PER_CELL)) # small number

var time_delta: float = 0.0

var cells_per_chunk: int = 128
var chunk_cols: int = 1
var chunk_rows: int = 1
var chunk_img_matrix: Array[Array]
var chunk_tex_array: Array[Array]

func _ready() -> void:
	var shader: Shader = load("res://SimpleWorldRenderer/SpriteShader.gdshader")
	var empty_img: Image = Image.create(cells_per_chunk * 4, cells_per_chunk * 4, false, Image.FORMAT_RGBA8)
	var empty_tex: ImageTexture = ImageTexture.create_from_image(empty_img)
	
	for r in chunk_rows:
		var img_row: Array[Image] = []
		var tex_row: Array[ImageTexture] = []
		for c in chunk_cols:
			var img: Image          = random_two_color_image(cells_per_chunk, cells_per_chunk)
			var tex: ImageTexture   = ImageTexture.create_from_image(img)
			var mat: ShaderMaterial = ShaderMaterial.new()
			var spr: Sprite2D       = Sprite2D.new()
			
			
			mat.shader = shader
			mat.set_shader_parameter("tex", tex)
			#mat.set_shader_parameter("scale", 1)
			#spr.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			#spr.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
			#spr.scale = Vector2.ONE * Z1_PX_PER_CELL 
			spr.centered = false
			spr.position = Vector2(c, r) * cells_per_chunk * Z1_PX_PER_CELL
			spr.material = mat
			spr.texture = empty_tex
			
			img_row.append(img)
			tex_row.append(tex)
			World.add_child(spr)
			
			
			#var new_sprite: Sprite2D = Sprite2D.new()
			#new_sprite.texture = tex_row[-1]
			##new_sprite.texture_filter = TEXTURE_FILTER_NEAREST
			##new_sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
			#new_sprite.centered = false
			#new_sprite.position = Vector2(c, r) * cells_per_chunk * Z1_PX_PER_CELL
			#var mat: ShaderMaterial = ShaderMaterial.new()
			#mat.shader = shader
			#mat.set_shader_parameter("tex", tex_row[-1])
			##mat.set_shader_parameter("scale", 1)
			##mat.set_shader_parameter("position", )
			#new_sprite.material = mat
			#World.add_child(new_sprite)
		chunk_img_matrix.append(img_row)
		chunk_img_matrix.append(tex_row)
		

		
func random_two_color_image(width: int, height: int) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)

	var color1 = Color.CHOCOLATE #Color(randf(), randf(), randf())
	var color2 = Color.AQUA #Color(randf(), randf(), randf())

	for y in range(height):
		for x in range(width):
			var use_color1 = ((x + y) % 2 == 0)
			img.set_pixel(x, y, color1 if use_color1 else color2)

	return img
