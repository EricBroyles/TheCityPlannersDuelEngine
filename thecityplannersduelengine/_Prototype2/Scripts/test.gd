#extends MeshInstance2D
#
#const CELL_SIZE := 50
#const ROWS := 3
#const COLS := 3
#
#func _ready():
	#var mesh := ArrayMesh.new()
	#var verts := PackedVector2Array()
	#var colors := PackedColorArray()
	#var indices := PackedInt32Array()
	#
	#var color_list := [
		#Color.RED, Color.GREEN, Color.BLUE,
		#Color.YELLOW, Color.CYAN, Color.MAGENTA,
		#Color(1, 0.5, 0), Color(0.5, 0, 1), Color.BLACK
	#]
	#
	#var color_index := 0
	#
	#for r in ROWS:
		#for c in COLS:
			#var top_left := Vector2(c * CELL_SIZE, r * CELL_SIZE)
			#var cell_color: Color = color_list[color_index % color_list.size()]
			#color_index += 1
#
			## Add vertices for this square
			#var v0 := top_left
			#var v1 := top_left + Vector2(CELL_SIZE, 0)
			#var v2 := top_left + Vector2(CELL_SIZE, CELL_SIZE)
			#var v3 := top_left + Vector2(0, CELL_SIZE)
#
			#var base := verts.size()
			#verts.append_array([v0, v1, v2, v3])
			#colors.append_array([cell_color, cell_color, cell_color, cell_color])
			#indices.append_array([base, base + 1, base + 2, base, base + 2, base + 3])
#
	#var arrays := []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = verts
	#arrays[Mesh.ARRAY_COLOR] = colors
	#arrays[Mesh.ARRAY_INDEX] = indices
	#
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#self.mesh = mesh
