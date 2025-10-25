class_name GameboardMatrix

var cells: Array[Array] = [[GameboardCell.create_empty()]] 
var cells_img: Image
var cells_tex: ImageTexture

static func create_empty(cols: int, rows: int) -> GameboardMatrix:
	var gb_matrix: GameboardMatrix = GameboardMatrix.new()
	gb_matrix.cells_img = Image.create_empty(cols, rows, false, Image.FORMAT_RGBA8)
	gb_matrix.cells_img.fill(GameData.grid_dark_color)
	var empty_cells: Array[Array] = []
	empty_cells.resize(rows)
	for r in rows:
		empty_cells[r] = []
		empty_cells[r].resize(cols)
	
	for r in rows: 
		for c in cols:
			var cell: GameboardCell = GameboardCell.create_empty()
			if (r + c) % 2 == 0:
				cell.ground = cell.GROUND.LIGHT
				gb_matrix.cells_img.set_pixel(c, r, GameData.grid_light_color)
			empty_cells[r][c] = cell
		#print(r,  " of ", rows)
	gb_matrix.cells = empty_cells
	gb_matrix.cells_tex = ImageTexture.create_from_image(gb_matrix.cells_img)
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
	
func get_rect2() -> Rect2:
	return Rect2(Vector2.ZERO, size())
	
func size() -> Vector2i: #(c,r)
	return Vector2i(cells[0].size(), cells.size())
	
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

	
	
	
	
