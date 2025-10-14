class_name GameboardMatrix

const _w: int = EngineData.CELL_WIDTH_PX
var cells: Array[Array] = [[GameboardCell.create_empty()]] 

static func create_empty(cols: int, rows: int) -> GameboardMatrix:
	var gb_matrix: GameboardMatrix = GameboardMatrix.new()
	var empty_cells: Array[Array] = []
	for r in rows: 
		var row: Array = []
		for c in cols: 
			var cell: GameboardCell = GameboardCell.create_empty()
			cell.ground = cell.GROUND.LIGHT if (r + c) % 2 == 0 else cell.GROUND.DARK
			row.append(cell)
		empty_cells.append(row)
	gb_matrix.cells = empty_cells
	return gb_matrix
	
func _to_string() -> String:
	if cells.is_empty():
		return "Matrix: empty"

	var rows := cells.size()
	var cols := cells[0].size() if rows > 0 else 0
	
	var light_count := 0
	var dark_count := 0
	
	for row in cells:
		for cell in row:
			if cell.ground == cell.GROUND.LIGHT:
				light_count += 1
			elif cell.ground == cell.GROUND.DARK:
				dark_count += 1
	
	return "Matrix: %dx%d | LIGHT: %d | DARK: %d" % [cols, rows, light_count, dark_count]

#func get_as_cells_box() -> Vector4:
	#var s: Vector2 = size()
	#return Vector4(0,0, s.x, s.y)
	
func get_rect2() -> Rect2:
	return Rect2(Vector2.ZERO, size())
	
#func get_rect2_in(rect2: Rect2) -> Rect2:
	##given some rect2 finds the rect2 of this matrix that is inside of it (not an intersection I wish)
	#var matrix_tl: Vector2 = Vector2(0,0)
	#var matrix_br: Vector2 = size() - Vector2.ONE #last index
	#var rect_tl: Vector2 = rect2.position
	#var rect_br: Vector2 = rect_tl + rect2.size - Vector2.ONE
	#
	## Clip to the matrix boundaries
	#var new_tl = Vector2(
		#clamp(rect_tl.x, matrix_tl.x, matrix_br.x),
		#clamp(rect_tl.y, matrix_tl.y, matrix_br.y)
	#)
	#var new_br = Vector2(
		#clamp(rect_br.x, matrix_tl.x, matrix_br.x),
		#clamp(rect_br.y, matrix_tl.y, matrix_br.y)
	#)
	#print("shift: ", new_tl, " ", new_br)
	## If rect2 doesn’t fully contain anything, return empty rect
	#if new_br.x < new_tl.x or new_br.y < new_tl.y:
		#return Rect2(Vector2.ZERO, Vector2.ZERO)
	#
	## Construct result (inclusive coordinates)
	#var size_vec = new_br - new_tl + Vector2.ONE
	#return Rect2(new_tl, size_vec)
	

func size() -> Vector2: #(c,r)
	return Vector2(cells[0].size(), cells.size())
	
func size_px() -> Vector2: #(x,y)
	return size() * _w
	
func is_empty() -> bool:
	#Is Empty when all cells are empty
	for r in cells.size(): for c in cells[0].size():
		if not (cells[r][c] as GameboardCell).is_empty():
			return false
	return true
	
func is_valid_index(r: int, c: int) -> bool:
	return r >= 0 and r < cells.size() and c >= 0 and c < cells[r].size()
			
func fill_with(cell: GameboardCell) -> void:
	# Overrides all cells and replaces them with cell
	for r in cells.size(): for c in cells[0].size():
		cells[r][c] = cell #WARNING PASS BY REFERENCE: change one change them all
	
func scale_radially(by: int) -> void:
	#
	# Will not decement below 1x1
	# Ex: if matrix is 1x1, by=1, matrix is now 3x3
	# Ex: if matrix is 1x2, by=1, matrix is now 3x4
	if by == 0: return
	var old_rows: int = cells.size()
	if old_rows == 0: return
	var old_cols: int = cells[0].size()
	var new_rows: int = max(1, old_rows + 2 * by)
	var new_cols: int = max(1, old_cols + 2 * by)
	var new_matrix: GameboardMatrix = GameboardMatrix.create_empty(new_cols, new_rows)
	cells = new_matrix.cells
	
func get_image_texture() -> ImageTexture:
	#WARNING: SLOW
	var rows = cells.size()
	var cols = cells[0].size()
	var img = Image.create(cols * _w, rows * _w, false, Image.FORMAT_RGBA8)
	for r in rows: for c in cols:
		var color = (cells[r][c] as GameboardCell).get_color()
		for y in _w: for x in _w:
				img.set_pixel(c * _w + x, r * _w + y, color)
	var tex = ImageTexture.create_from_image(img)
	return tex
	
func get_array_mesh() -> ArrayMesh:
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	var verts: PackedVector2Array = PackedVector2Array()
	var colors: PackedColorArray = PackedColorArray()
	var indices: PackedInt32Array = PackedInt32Array()
	
	for r in cells.size(): for c in cells[0].size():
		var top_left: Vector2 = Vector2(c,r) * _w
		var cell_color: Color = (cells[r][c] as GameboardCell).get_color()
		var base = verts.size() 
		
		var v0: Vector2 = top_left
		var v1: Vector2 = top_left + Vector2(_w, 0)
		var v2: Vector2 = top_left + Vector2(_w, _w)
		var v3: Vector2 = top_left + Vector2(0, _w)
		
		verts.append_array([v0, v1, v2, v3])
		colors.append_array([cell_color, cell_color, cell_color, cell_color])
		indices.append_array([base, base + 1, base + 2, base, base + 2, base + 3])
		
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh
	
	
	
	
