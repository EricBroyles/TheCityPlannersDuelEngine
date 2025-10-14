extends Sprite2D
class_name GBSpriteShader



#func _ready():
	#print(position, global_position)
	#centered = false
	#region_enabled = true
	#scale = Vector2.ONE * 4
	##var shader_mat: ShaderMaterial = ShaderMaterial.new()
	##shader_mat.shader = load("res://Prototype2/Shaders/GBSpriteShader.gdshader")
	##material = shader_mat
	#
#func draw_texture_with_shader(tex: ImageTexture) -> void:
	##print("attempting to draw the shader: warning I have no idea what the size of this region should be")
	#var sprite_size: Vector2 = Vector2(EngineData.cells_view_box.z, EngineData.cells_view_box.w) * EngineData.CELL_WIDTH_PX
	#region_rect = Rect2(Vector2.ZERO, sprite_size) 
	#texture = tex
	### Update shader parameters
	##material.set_shader_parameter("image_texture", tex)
	##material.set_shader_parameter("image_size", tex.get_size())
	##material.set_shader_parameter("scale_factor", EngineData.CELL_WIDTH_PX)
	##
	## Update sprite display size automatically
	##region_enabled = true
	##region_rect = Rect2(Vector2.ZERO, Vector2(1000, 1000) * EngineData.CELL_WIDTH_PX)
	##scale = Vector2.ONE
	


	
