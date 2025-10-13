class_name GameboardMatrix

const _w: int = EngineData.CELL_WIDTH_PX
var contents: Array[Array] = [[GameboardCell.create_empty()]] #2D matrix of Gameboard Cells

static func create_empty(cols: int, rows: int) -> GameboardMatrix:
	var gb_matrix: GameboardMatrix = GameboardMatrix.new()
	var empty_contents: Array[Array] = []
	for r in rows: 
		var row: Array = []
		for c in cols: row.append(GameboardCell.create_empty())
		empty_contents.append(row)
	gb_matrix.contents = empty_contents
	return gb_matrix
	
func size() -> Vector2: #(c,r)
	return Vector2(contents[0].size(), contents.size())
	
func size_px() -> Vector2: #(x,y)
	return size() * _w
	
func is_empty() -> bool:
	#Is Empty when all cells are empty
	for r in contents.size(): for c in contents[0].size():
		if not (contents[r][c] as GameboardCell).is_empty():
			return false
	return true
			
func fill_with(cell: GameboardCell) -> void:
	# Overrides all contents and replaces them with cell
	for r in contents.size(): for c in contents[0].size():
		contents[r][c] = cell #WARNING PASS BY REFERENCE: change one change them all
	
func scale_radially(by: int) -> void:
	#
	# Will not decement below 1x1
	# Ex: if matrix is 1x1, by=1, matrix is now 3x3
	# Ex: if matrix is 1x2, by=1, matrix is now 3x4
	if by == 0: return
	var old_rows: int = contents.size()
	if old_rows == 0: return
	var old_cols: int = contents[0].size()
	var new_rows: int = max(1, old_rows + 2 * by)
	var new_cols: int = max(1, old_cols + 2 * by)
	var new_matrix: GameboardMatrix = GameboardMatrix.create_empty(new_cols, new_rows)
	contents = new_matrix.contents
	
func get_image_texture() -> ImageTexture:
	#WARNING: SLOW
	var rows = contents.size()
	var cols = contents[0].size()
	var img = Image.create(cols * _w, rows * _w, false, Image.FORMAT_RGBA8)
	for r in rows: for c in cols:
		var color = (contents[r][c] as GameboardCell).get_cell_color()
		for y in _w: for x in _w:
				img.set_pixel(c * _w + x, r * _w + y, color)
	var tex = ImageTexture.create_from_image(img)
	return tex
	
func get_array_mesh() -> ArrayMesh:
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	var verts: PackedVector2Array = PackedVector2Array()
	var colors: PackedColorArray = PackedColorArray()
	var indices: PackedInt32Array = PackedInt32Array()
	
	for r in contents.size(): for c in contents[0].size():
		var top_left: Vector2 = Vector2(c,r) * _w
		var cell_color: Color = (contents[r][c] as GameboardCell).get_cell_color()
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
	
	
	
	
