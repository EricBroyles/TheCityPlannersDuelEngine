extends Sprite2D

# Simple configurable parameters
@export var grid_size: int = 9
@export var square_size: int = 4
@export var shader_path: String = "res://FunWithShaders/Test.gdshader"
@export var random_seed: float = 0.0

func _ready() -> void:
	centered = false
	position = Vector2.ZERO

	# Ensure the sprite has a visible texture (in case you forgot)
	if texture == null:
		var img := Image.create(9, 9, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		texture = ImageTexture.create_from_image(img)

	# Make sprite draw an exact region matching the grid area
	region_enabled = true
	region_rect = Rect2(0, 0, grid_size * square_size, grid_size * square_size)

	# Create and assign shader material
	var shader_res := load(shader_path)
	if shader_res == null:
		push_error("Could not load shader at: %s" % shader_path)
		return

	var shader_mat := ShaderMaterial.new()
	shader_mat.shader = shader_res

	# Pass uniform parameters
	shader_mat.set_shader_parameter("GRID_SIZE", grid_size)
	shader_mat.set_shader_parameter("SQUARE_SIZE", float(square_size))
	shader_mat.set_shader_parameter("seed", random_seed)

	material = shader_mat
