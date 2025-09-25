extends Sprite2D
#
#func _ready():
	## --- Create ArrayMesh with a triangle ---
	#var mesh := ArrayMesh.new()
#
	#var vertices = PackedVector2Array([
		#Vector2(0, 0),
		#Vector2(128, 0),
		#Vector2(64, 128)
	#])
#
	##var uvs = PackedVector2Array([
		##Vector2(0, 0),
		##Vector2(1, 0),
		##Vector2(0.5, 1)
	##])
#
	#var colors = PackedColorArray([
		#Color.RED,
		#Color.GREEN,
		#Color.BLUE
	#])
#
	#var arrays = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	##arrays[Mesh.ARRAY_TEX_UV] = uvs
	#arrays[Mesh.ARRAY_COLOR] = colors
#
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
#
	## --- Create MeshTexture and assign mesh ---
	#var mesh_tex := MeshTexture.new()
	#mesh_tex.mesh = mesh
	#mesh_tex.image_size = Vector2(128, 128)  # controls how Sprite2D stretches the mesh
#
	## --- Apply as Sprite2D texture ---
	#texture = mesh_tex
#
#func _process(delta: float) -> void:
	#position = get_global_mouse_position()

#extends Node2D

@onready var mesh_instance = %MeshInstance2D

func _ready():
	

	var points = PackedVector2Array([
		Vector2(10, 0)*10,
		Vector2(0, 10)*10,
		Vector2(10, 20)*10,
		Vector2(20, 10)*10,

	]) 

	mesh_instance.mesh = create_polygon_mesh(points)


func create_polygon_mesh(points: PackedVector2Array) -> ArrayMesh:
	var mesh = ArrayMesh.new()

	# Get triangle indices from polygon
	var indices = PackedInt32Array(Geometry2D.triangulate_polygon(points))

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	arrays[Mesh.ARRAY_VERTEX] = points
	arrays[Mesh.ARRAY_INDEX] = indices

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh
	
func _process(delta: float) -> void:
	position = get_global_mouse_position()

#use to clear the mesh
func reset_mesh():
	mesh_instance.mesh = ArrayMesh.new()
